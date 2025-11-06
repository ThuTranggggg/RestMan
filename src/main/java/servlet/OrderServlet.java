package servlet;

import dao.OrderDAO;
import dao.TableDAO;
import model.Order;
import model.OrderDetail;
import model.Table;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/order")
public class OrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Kiểm tra nếu nhân viên đã đăng nhập
        if (session == null || session.getAttribute("staff") == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        String tableIdStr = request.getParameter("tableId");
        if (tableIdStr == null || tableIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/searchTable");
            return;
        }
        
        try {
            int tableId = Integer.parseInt(tableIdStr);
            TableDAO tableDAO = new TableDAO();
            OrderDAO orderDAO = new OrderDAO();
            
            // Lấy thông tin bàn
            Table table = tableDAO.getTableById(tableId);
            if (table == null) {
                request.setAttribute("error", "Bàn không tồn tại");
                request.getRequestDispatcher("/WEB-INF/Staff/SearchTablePage.jsp").forward(request, response);
                return;
            }
            
            // Lấy order hiện tại của bàn
            Order order = tableDAO.getOrderByTableId(tableId);
            
            // Nếu chưa có order, tạo order mới
            if (order == null) {
                int customerId = 0;
                int newOrderId = orderDAO.createOrder(tableId, customerId);
                if (newOrderId > 0) {
                    order = orderDAO.getOrderById(newOrderId);
                }
            }
            
            // Lấy danh sách chi tiết đơn hàng
            List<OrderDetail> orderDetails = orderDAO.getOrderDetails(order.getId());
            
            // Tính tổng tiền
            double total = orderDAO.calculateOrderTotal(order.getId());
            
            // Set attributes
            request.setAttribute("order", order);
            request.setAttribute("orderDetails", orderDetails);
            request.setAttribute("total", total);
            request.setAttribute("table", table);
            
            request.getRequestDispatcher("/WEB-INF/Staff/OrderPage.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID bàn không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/searchTable");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi lấy thông tin bàn: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/Staff/SearchTablePage.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Kiểm tra nếu nhân viên đã đăng nhập
        if (session == null || session.getAttribute("staff") == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("addProduct".equals(action)) {
                handleAddProduct(request, response);
            } else if ("removeProduct".equals(action)) {
                handleRemoveProduct(request, response);
            } else if ("updateQuantity".equals(action)) {
                handleUpdateQuantity(request, response);
            } else {
                doGet(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            try {
                doGet(request, response);
            } catch (ServletException | IOException ex) {
                ex.printStackTrace();
            }
        }
    }

    private void handleAddProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException, ServletException {
        String orderIdStr = request.getParameter("orderId");
        String productIdStr = request.getParameter("productId");
        String quantityStr = request.getParameter("quantity");
        
        if (orderIdStr == null || productIdStr == null || quantityStr == null) {
            response.sendRedirect(request.getContextPath() + "/searchTable");
            return;
        }
        
        int orderId = Integer.parseInt(orderIdStr);
        int productId = Integer.parseInt(productIdStr);
        int quantity = Integer.parseInt(quantityStr);
        
        OrderDAO orderDAO = new OrderDAO();
        orderDAO.addOrderDetail(orderId, productId, quantity);
        
        // Redirect lại trang order
        Order order = orderDAO.getOrderById(orderId);
        response.sendRedirect(request.getContextPath() + "/order?tableId=" + order.getTable().getId());
    }

    private void handleRemoveProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException, ServletException {
        String detailIdStr = request.getParameter("detailId");
        String orderIdStr = request.getParameter("orderId");
        
        if (detailIdStr == null || orderIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/searchTable");
            return;
        }
        
        int detailId = Integer.parseInt(detailIdStr);
        int orderId = Integer.parseInt(orderIdStr);
        
        OrderDAO orderDAO = new OrderDAO();
        orderDAO.removeOrderDetail(detailId);
        
        Order order = orderDAO.getOrderById(orderId);
        response.sendRedirect(request.getContextPath() + "/order?tableId=" + order.getTable().getId());
    }

    private void handleUpdateQuantity(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException, ServletException {
        String detailIdStr = request.getParameter("detailId");
        String orderIdStr = request.getParameter("orderId");
        String quantityStr = request.getParameter("quantity");
        
        if (detailIdStr == null || orderIdStr == null || quantityStr == null) {
            response.sendRedirect(request.getContextPath() + "/searchTable");
            return;
        }
        
        int detailId = Integer.parseInt(detailIdStr);
        int orderId = Integer.parseInt(orderIdStr);
        int quantity = Integer.parseInt(quantityStr);
        
        OrderDAO orderDAO = new OrderDAO();
        orderDAO.updateOrderDetailQuantity(detailId, quantity);
        
        Order order = orderDAO.getOrderById(orderId);
        response.sendRedirect(request.getContextPath() + "/order?tableId=" + order.getTable().getId());
    }
}

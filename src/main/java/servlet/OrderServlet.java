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
            
            // Lấy order ID của bàn
            Order orderFromTable = tableDAO.getOrderByTableId(tableId);
            
            // Nếu chưa có order, báo lỗi (không tạo order mới)
            if (orderFromTable == null) {
                request.setAttribute("error", "Bàn này không có order nào đang được thực hiện");
                request.getRequestDispatcher("/WEB-INF/Staff/SearchTablePage.jsp").forward(request, response);
                return;
            }
            
            // Lấy order đầy đủ từ OrderDAO (chứa đầy đủ Customer info)
            Order order = orderDAO.getOrderById(orderFromTable.getId());
            
            if (order == null) {
                request.setAttribute("error", "Không tìm thấy thông tin order");
                request.getRequestDispatcher("/WEB-INF/Staff/SearchTablePage.jsp").forward(request, response);
                return;
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
}

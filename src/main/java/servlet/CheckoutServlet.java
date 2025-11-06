package servlet;

import dao.InvoiceDAO;
import dao.OrderDAO;
import dao.TableDAO;
import model.Order;
import model.Staff;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Kiểm tra nếu nhân viên đã đăng nhập
        if (session == null || session.getAttribute("staff") == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        String orderIdStr = request.getParameter("orderId");
        String bonusPointStr = request.getParameter("bonusPoint");
        
        if (orderIdStr == null || bonusPointStr == null) {
            response.sendRedirect(request.getContextPath() + "/searchTable");
            return;
        }
        
        try {
            int orderId = Integer.parseInt(orderIdStr);
            int bonusPoint = Integer.parseInt(bonusPointStr);
            
            // Lấy thông tin nhân viên
            Staff staff = (Staff) session.getAttribute("staff");
            int staffId = staff.getUser().getId();
            
            // Tạo invoice từ order
            InvoiceDAO invoiceDAO = new InvoiceDAO();
            int invoiceId = invoiceDAO.createInvoice(orderId, staffId, bonusPoint);
            
            if (invoiceId > 0) {
                // Cập nhật trạng thái bàn về 0 (trống)
                OrderDAO orderDAO = new OrderDAO();
                Order order = orderDAO.getOrderById(orderId);
                if (order != null) {
                    TableDAO tableDAO = new TableDAO();
                    tableDAO.updateTableStatus(order.getTable().getId(), 0);
                }
                
                // Redirect tới trang invoice
                response.sendRedirect(request.getContextPath() + "/invoice?id=" + invoiceId);
            } else {
                request.setAttribute("error", "Lỗi khi tạo hóa đơn");
                request.getRequestDispatcher("/WEB-INF/Staff/OrderPage.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ");
            request.getRequestDispatcher("/WEB-INF/Staff/OrderPage.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/Staff/OrderPage.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/searchTable");
    }
}

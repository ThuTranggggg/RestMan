package servlet;

import dao.InvoiceDAO;
import dao.OrderDAO;
import model.Invoice;
import model.Order;
import model.OrderDetail;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/invoice")
public class InvoiceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Kiểm tra nếu nhân viên đã đăng nhập
        if (session == null || session.getAttribute("staff") == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        String invoiceIdStr = request.getParameter("id");
        if (invoiceIdStr == null || invoiceIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/searchTable");
            return;
        }
        
        try {
            int invoiceId = Integer.parseInt(invoiceIdStr);
            
            InvoiceDAO invoiceDAO = new InvoiceDAO();
            Invoice invoice = invoiceDAO.getInvoiceById(invoiceId);
            
            if (invoice == null) {
                request.setAttribute("error", "Hóa đơn không tồn tại");
                request.getRequestDispatcher("/WEB-INF/Staff/SearchTablePage.jsp").forward(request, response);
                return;
            }
            
            // Tạo Order object với orderId để truyền vào DAO
            OrderDAO orderDAO = new OrderDAO();
            Order order = new Order();
            order.setId(invoice.getOrderId());
            
            // Lấy chi tiết đơn hàng và tổng tiền bằng Order object
            List<OrderDetail> orderDetails = orderDAO.getOrderDetails(order);
            double total = orderDAO.calculateOrderTotal(order);
            
            request.setAttribute("invoice", invoice);
            request.setAttribute("orderDetails", orderDetails);
            request.setAttribute("total", total);
            
            request.getRequestDispatcher("/WEB-INF/Staff/InvoicePage.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID hóa đơn không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/searchTable");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi lấy thông tin hóa đơn: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/Staff/SearchTablePage.jsp").forward(request, response);
        }
    }
}

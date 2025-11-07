package servlet;

import dao.InvoiceDAO;
import dao.OrderDAO;
import dao.TableDAO;
import model.Invoice;
import model.Order;
import model.Staff;
import model.Server;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;

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
            
            // Step 1: Lấy Model từ Session
            Staff staff = (Staff) session.getAttribute("staff");
            Server server = new Server(staff.getId(), staff.getFullName(), staff.getPhone(), 
                                      staff.getEmail(), staff.getUsername(), staff.getPassword(), 
                                      staff.getRole(), staff.getPosition());
            
            // Step 2: Lấy Order từ DB
            OrderDAO orderDAO = new OrderDAO();
            Order order = orderDAO.getOrderById(orderId);
            
            if (order == null) {
                request.setAttribute("error", "Đơn hàng không tồn tại");
                request.getRequestDispatcher("/WEB-INF/Staff/OrderPage.jsp").forward(request, response);
                return;
            }
            
            // ✅ Tạo Invoice extends Order (kế thừa các thuộc tính từ Order)
            Invoice invoice = new Invoice();
            invoice.setId(order.getId());
            invoice.setCustomer(order.getCustomer());
            invoice.setTable(order.getTable());
            invoice.setServer(server);
            invoice.setBonusPoint(bonusPoint);
            invoice.setDatetime(LocalDateTime.now()); // Thời gian tạo hóa đơn là lúc nhân viên xác nhận
            
            // Step 3: Gọi DAO 
            InvoiceDAO invoiceDAO = new InvoiceDAO();
            int invoiceId = invoiceDAO.createInvoice(orderId, staff.getId(), bonusPoint);
            
            if (invoiceId > 0) {
                // ✅ Cộng điểm thẻ thành viên cho khách hàng
                if (order.getCustomer() != null && bonusPoint > 0) {
                    try {
                        invoiceDAO.addBonusPointsToMembercard(order.getCustomer().getId(), bonusPoint);
                    } catch (Exception e) {
                        // Log lỗi nhưng không dừng quy trình
                        System.err.println("Lỗi cộng điểm thành viên: " + e.getMessage());
                    }
                }
                
                // ✅ Không xóa Order - để lưu lịch sử
                // Cập nhật trạng thái bàn về 0 (trống)
                TableDAO tableDAO = new TableDAO();
                tableDAO.updateTableStatus(order.getTable().getId(), 0);
                
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

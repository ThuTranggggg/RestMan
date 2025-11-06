package servlet;

import dao.TableDAO;
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

@WebServlet("/searchTable")
public class SearchTableServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Kiểm tra nếu nhân viên đã đăng nhập
        if (session == null || session.getAttribute("staff") == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        TableDAO tableDAO = new TableDAO();
        List<Table> tables = null;
        String keyword = request.getParameter("keyword");
        
        try {
            if (keyword == null || keyword.trim().isEmpty()) {
                // Lấy tất cả bàn đang có order chưa thanh toán
                tables = tableDAO.getTablesWithPendingOrders();
            } else {
                // Tìm kiếm bàn theo từ khóa (chỉ những bàn có order chưa thanh toán)
                tables = tableDAO.searchTablesWithPendingOrders(keyword.trim());
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tìm kiếm bàn: " + e.getMessage());
            tables = new java.util.ArrayList<>();
        }
        
        request.setAttribute("tables", tables);
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("/WEB-INF/Staff/SearchTablePage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

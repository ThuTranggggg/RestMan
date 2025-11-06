package servlet;

import dao.ProductDAO;
import model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "SearchDishServerlet", urlPatterns = {"/searchDish"})
public class SearchDishServerlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String keyword = req.getParameter("keyword");
        try {
            ProductDAO dao = new ProductDAO();
            String contextPath = req.getContextPath();
            
            List<Product> results;
            if (keyword != null && !keyword.trim().isEmpty()) {
                // Nếu có keyword, tìm kiếm theo keyword
                results = dao.searchByKeyword(keyword, contextPath);
                req.setAttribute("keyword", keyword);
            } else {
                // Nếu không có keyword, hiển thị tất cả sản phẩm
                results = dao.getAllProducts(contextPath);
                req.setAttribute("keyword", "");
            }
            
            dao.closeQuietly();

            req.setAttribute("dishes", results);
            // forward to search page
            req.getRequestDispatcher("/WEB-INF/Customer/SearchPage.jsp").forward(req, resp);
        } catch (SQLException e) {
            req.setAttribute("error", "Lỗi khi tìm kiếm: " + e.getMessage());
            req.setAttribute("keyword", keyword == null ? "" : keyword);
            req.getRequestDispatcher("/WEB-INF/Customer/SearchPage.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}

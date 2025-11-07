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
@WebServlet(name = "LinkServerlet", urlPatterns = {"/link"})
public class LinkServerlet extends HttpServlet {

    private static final String VIEW_BASE = "/WEB-INF/Customer/";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        String page = req.getParameter("page");
        if (page == null) {
            // mặc định quay về trang chính của khách hàng
            forward(req, resp, VIEW_BASE + "CustomerPage.jsp");
            return;
        }

        if (page.equalsIgnoreCase("searchdish")) {
            // Load products: if keyword provided, search; otherwise load all products
            String kw = req.getParameter("keyword");
            try {
                ProductDAO dao = new ProductDAO();
                String contextPath = req.getContextPath();
                List<Product> list;
                if (kw != null && !kw.trim().isEmpty()) {
                    // User searched — load matching products
                    list = dao.searchByKeyword(kw, contextPath);
                    req.setAttribute("keyword", kw);
                } else {
                    // Initial page load or empty search — load all products
                    list = dao.getAllProducts(contextPath);
                    req.setAttribute("keyword", "");
                }
                dao.closeQuietly();
                req.setAttribute("dishes", list);
            } catch (SQLException e) {
                req.setAttribute("error", "Lỗi khi tải danh sách sản phẩm: " + e.getMessage());
                req.setAttribute("keyword", kw != null ? kw : "");
            }
            forward(req, resp, VIEW_BASE + "SearchPage.jsp");
        } else {
            forward(req, resp, VIEW_BASE + "CustomerPage.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // cho phép form POST dùng chung logic
        doGet(req, resp);
    }

    private void forward(HttpServletRequest req, HttpServletResponse resp, String target)
            throws ServletException, IOException {
        req.getRequestDispatcher(target).forward(req, resp);
    }
}

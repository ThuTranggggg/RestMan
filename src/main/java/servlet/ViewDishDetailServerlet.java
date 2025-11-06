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

@WebServlet(name = "ViewDishDetailServerlet", urlPatterns = {"/viewDish"})
public class ViewDishDetailServerlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String idStr = req.getParameter("id");
        if (idStr == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing product id");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            ProductDAO dao = new ProductDAO();
            String contextPath = req.getContextPath();
            Product product = dao.getProductDetail(id, contextPath);
            dao.closeQuietly();

            if (product == null) {
                // Provide a friendlier message to the JSP and forward so user sees a helpful page
                req.setAttribute("detailError", "Không tìm thấy thông tin sản phẩm cho id=" + id);
                // still forward to JSP so the UI can show a nicer message and a back link
                req.getRequestDispatcher("/WEB-INF/Customer/DishDetailPage.jsp").forward(req, resp);
                return;
            }

            req.setAttribute("dish", product);
            
            // Format price with thousand separators
            String formattedPrice = String.format("%,.0f", product.getPrice());
            req.setAttribute("formattedPrice", formattedPrice);
            
            // Get image URL from product (already resolved by ProductDAO)
            String dishImageUrl = product.getImageUrl();
            if (dishImageUrl == null || dishImageUrl.isEmpty()) {
                dishImageUrl = contextPath + "/img/defaultImage.png";
            }
            
            req.setAttribute("dishImageUrl", dishImageUrl);
            req.getRequestDispatcher("/WEB-INF/Customer/DishDetailPage.jsp").forward(req, resp);
        } catch (NumberFormatException ex) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid dish id");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}

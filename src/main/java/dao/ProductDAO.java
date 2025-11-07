package dao;

import model.Product;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO extends DAO {

    public ProductDAO() { }

    /**
     * Resolves the image URL for display, applying fallback logic.
     * If no URL is set or empty, uses a default image placeholder.
     * If URL is absolute or context-rooted, returns as-is.
     * Otherwise extracts filename and maps to /img/ folder.
     *
     * @param rawImg the raw image URL from database
     * @param contextPath the request context path
     * @return resolved image URL safe for use in <img src="">
     */
    private String resolveImageUrl(String rawImg, String contextPath) {
        if (rawImg == null || rawImg.trim().length() == 0) {
            return contextPath + "/img/defaultImage.png";
        }

        String rc = rawImg.replace('\\', '/');
        String lc = rc.toLowerCase();

        // If it's absolute (http/https) or context-rooted, use as-is
        if (lc.startsWith("http:") || lc.startsWith("https:") || rc.startsWith("/")) {
            return rc;
        }

        // Otherwise extract filename and map to /img/ folder
        int idx = rc.lastIndexOf('/');
        String filename = (idx >= 0 && idx < rc.length() - 1) ? rc.substring(idx + 1) : rc;
        return contextPath + "/img/" + filename;
    }

    /**
     * Chuyển đổi Product từ ResultSet thành đối tượng Java
     * Trả về đối tượng Product (dùng type để lưu loại sản phẩm)
     */
    private Product mapRowToProduct(ResultSet rs, String contextPath) throws SQLException {
        int id = rs.getInt("id");
        String name = rs.getString("name");
        String description = rs.getString("description");
        float price = rs.getFloat("price");
        String type = rs.getString("type");
        String imageUrl = rs.getString("imageUrl");

        // Resolve image URL
        String resolvedImageUrl = resolveImageUrl(imageUrl, contextPath);

        // Tạo Product duy nhất với type
        Product product = new Product(name, description, price, type);
        product.setId(id);
        product.setImageUrl(resolvedImageUrl);

        return product;
    }

    /**
     * Tìm kiếm sản phẩm theo keyword trong tên hoặc mô tả.
     * Trả về cả DRINK, DISH và COMBO, sắp xếp theo loại (DRINK → DISH → COMBO) và giá tăng dần
     *
     * @param keyword từ khóa tìm kiếm
     * @return danh sách Product
     */
    public List<Product> searchByKeyword(String keyword) throws SQLException {
        return searchByKeyword(keyword, "");
    }

    /**
     * Tìm kiếm sản phẩm theo keyword trong tên hoặc mô tả.
     * Trả về cả DRINK, DISH và COMBO, sắp xếp theo loại (DRINK → DISH → COMBO) và giá tăng dần
     *
     * @param keyword từ khóa tìm kiếm
     * @param contextPath đường dẫn context web để resolve hình ảnh
     * @return danh sách Product với hình ảnh đã được resolve
     */
    public List<Product> searchByKeyword(String keyword, String contextPath) throws SQLException {
        String sql = """
            SELECT id, name, description, price, type, imageUrl
            FROM tblProduct
            WHERE status = 1 AND (name LIKE ? OR description LIKE ?)
            ORDER BY 
                CASE type
                    WHEN 'DRINK' THEN 1
                    WHEN 'DISH' THEN 2
                    WHEN 'COMBO' THEN 3
                    ELSE 4
                END,
                price ASC,
                name ASC
        """;

        String like = "%" + (keyword == null ? "" : keyword.trim()) + "%";

        List<Product> list = new ArrayList<>();
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, like);
            ps.setString(2, like);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product product = mapRowToProduct(rs, contextPath);
                    list.add(product);
                }
            }
        }
        return list;
    }

    /**
     * Lấy tất cả sản phẩm (DRINK, DISH và COMBO) từ CSDL
     * Sắp xếp theo loại (DRINK → DISH → COMBO) và giá tăng dần
     *
     * @param contextPath đường dẫn context web để resolve hình ảnh
     * @return danh sách tất cả Product với hình ảnh đã được resolve
     */
    public List<Product> getAllProducts(String contextPath) throws SQLException {
        String sql = """
            SELECT id, name, description, price, type, imageUrl
            FROM tblProduct
            WHERE status = 1
            ORDER BY 
                CASE type
                    WHEN 'DRINK' THEN 1
                    WHEN 'DISH' THEN 2
                    WHEN 'COMBO' THEN 3
                    ELSE 4
                END,
                price ASC,
                name ASC
        """;

        List<Product> list = new ArrayList<>();
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product product = mapRowToProduct(rs, contextPath);
                    list.add(product);
                }
            }
        }
        return list;
    }

    /**
     * Lấy chi tiết một sản phẩm (DRINK, DISH hoặc COMBO) theo ID
     *
     * @param id ID của sản phẩm
     * @return Product object, hoặc null nếu không tìm thấy
     */
    public Product getProductDetail(int id) throws SQLException {
        return getProductDetail(id, "");
    }

    /**
     * Lấy chi tiết một sản phẩm (DRINK, DISH hoặc COMBO) theo ID
     *
     * @param id ID của sản phẩm
     * @param contextPath đường dẫn context web
     * @return Product object, hoặc null nếu không tìm thấy
     */
    public Product getProductDetail(int id, String contextPath) throws SQLException {
        String sql = """
            SELECT id, name, description, price, type, imageUrl
            FROM tblProduct
            WHERE id = ? AND status = 1
            LIMIT 1
        """;

        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToProduct(rs, contextPath);
                }
            }
        }
        return null;
    }

    /**
     * Lấy tất cả DRINK (type = 'DRINK')
     *
     * @param contextPath đường dẫn context web
     * @return danh sách Product có type = 'DRINK'
     */
    public List<Product> getAllDrinks(String contextPath) throws SQLException {
        String sql = """
            SELECT id, name, description, price, type, imageUrl
            FROM tblProduct
            WHERE type = 'DRINK' AND status = 1
            ORDER BY price ASC, name ASC
        """;

        List<Product> list = new ArrayList<>();
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product product = mapRowToProduct(rs, contextPath);
                    list.add(product);
                }
            }
        }
        return list;
    }

    /**
     * Lấy tất cả DISH (type = 'DISH')
     *
     * @param contextPath đường dẫn context web
     * @return danh sách Product có type = 'DISH'
     */
    public List<Product> getAllDishes(String contextPath) throws SQLException {
        String sql = """
            SELECT id, name, description, price, type, imageUrl
            FROM tblProduct
            WHERE type = 'DISH' AND status = 1
            ORDER BY price ASC, name ASC
        """;

        List<Product> list = new ArrayList<>();
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product product = mapRowToProduct(rs, contextPath);
                    list.add(product);
                }
            }
        }
        return list;
    }

    /**
     * Lấy tất cả COMBO (type = 'COMBO')
     *
     * @param contextPath đường dẫn context web
     * @return danh sách Product có type = 'COMBO'
     */
    public List<Product> getAllCombos(String contextPath) throws SQLException {
        String sql = """
            SELECT id, name, description, price, type, imageUrl
            FROM tblProduct
            WHERE type = 'COMBO' AND status = 1
            ORDER BY price ASC, name ASC
        """;

        List<Product> list = new ArrayList<>();
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product product = mapRowToProduct(rs, contextPath);
                    list.add(product);
                }
            }
        }
        return list;
    }
}

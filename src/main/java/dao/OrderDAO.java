package dao;

import model.Order;
import model.OrderDetail;
import model.Product;
import model.Customer;
import model.Table;
import model.Membercard;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO extends DAO {

    /**
     * Lấy chi tiết đơn hàng theo Order ID
     */
    public List<OrderDetail> getOrderDetails(int orderId) throws SQLException {
        List<OrderDetail> details = new ArrayList<>();
        String sql = "SELECT od.id, od.quantity, od.tblProductid, " +
                     "p.id as product_id, p.name, p.price, p.type, p.imageUrl " +
                     "FROM tblOrderDetail od " +
                     "INNER JOIN tblProduct p ON od.tblProductid = p.id " +
                     "WHERE od.tblOrderid = ?";
        
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("product_id"));
                product.setName(rs.getString("p.name"));
                product.setPrice((float)rs.getDouble("p.price"));
                product.setType(rs.getString("p.type"));
                product.setImageUrl(rs.getString("p.imageUrl"));
                
                // ✅ FIX: Tạo Order object (không null)
                Order order = new Order();
                order.setId(orderId);
                
                OrderDetail detail = new OrderDetail(
                    rs.getInt("od.id"),
                    rs.getInt("od.quantity"),
                    "PENDING",  // Status mặc định là PENDING
                    product,
                    order  // ✅ order không null
                );
                details.add(detail);
            }
        }
        return details;
    }

    /**
     * Tạo đơn hàng mới
     */
    public int createOrder(int tableId, int customerId) throws SQLException {
        String sql = "INSERT INTO tblOrder (tblTableid, tblCustomertblUserid) VALUES (?, ?)";
        
        try (PreparedStatement ps = getConnection().prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, tableId);
            if (customerId > 0) {
                ps.setInt(2, customerId);
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        }
        return -1;
    }

    /**
     * Thêm sản phẩm vào đơn hàng
     */
    public boolean addOrderDetail(int orderId, int productId, int quantity) throws SQLException {
        // Kiểm tra nếu sản phẩm đã có trong đơn hàng, thì cập nhật quantity
        String checkSql = "SELECT id, quantity FROM tblOrderDetail WHERE tblOrderid = ? AND tblProductid = ?";
        try (PreparedStatement checkPs = getConnection().prepareStatement(checkSql)) {
            checkPs.setInt(1, orderId);
            checkPs.setInt(2, productId);
            ResultSet rs = checkPs.executeQuery();
            
            if (rs.next()) {
                // Cập nhật quantity
                int newQuantity = rs.getInt("quantity") + quantity;
                String updateSql = "UPDATE tblOrderDetail SET quantity = ? WHERE id = ?";
                try (PreparedStatement updatePs = getConnection().prepareStatement(updateSql)) {
                    updatePs.setInt(1, newQuantity);
                    updatePs.setInt(2, rs.getInt("id"));
                    return updatePs.executeUpdate() > 0;
                }
            }
        }
        
        // Thêm sản phẩm mới
        String insertSql = "INSERT INTO tblOrderDetail (tblOrderid, tblProductid, quantity) VALUES (?, ?, ?)";
        try (PreparedStatement ps = getConnection().prepareStatement(insertSql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, productId);
            ps.setInt(3, quantity);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Xóa sản phẩm khỏi đơn hàng
     */
    public boolean removeOrderDetail(int detailId) throws SQLException {
        String sql = "DELETE FROM tblOrderDetail WHERE id = ?";
        
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, detailId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Cập nhật số lượng sản phẩm trong đơn hàng
     */
    public boolean updateOrderDetailQuantity(int detailId, int quantity) throws SQLException {
        if (quantity <= 0) {
            return removeOrderDetail(detailId);
        }
        
        String sql = "UPDATE tblOrderDetail SET quantity = ? WHERE id = ?";
        
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, detailId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Lấy thông tin Order đầy đủ theo Order ID
     */
    public Order getOrderById(int orderId) throws SQLException {
        String sql = "SELECT o.id, o.tblTableid, o.tblCustomertblUserid, " +
                     "t.id as table_id, t.name, t.status, t.description, " +
                     "u.id as customer_id, u.fullName, u.phone, u.email, u.username, u.role, " +
                     "c.tblMemberCardid " +
                     "FROM tblOrder o " +
                     "INNER JOIN tblTable t ON o.tblTableid = t.id " +
                     "LEFT JOIN tblUser u ON o.tblCustomertblUserid = u.id " +
                     "LEFT JOIN tblCustomer c ON u.id = c.tblUserid " +
                     "WHERE o.id = ?";
        
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Order order = new Order();
                order.setId(orderId);
                
                // Set table
                Table table = new Table(
                    rs.getInt("table_id"),
                    rs.getString("t.name"),
                    rs.getInt("t.status"),
                    rs.getString("t.description")
                );
                order.setTable(table);
                
                // Set customer (có thể null nếu không có khách hàng)
                int customerId = rs.getInt("customer_id");
                if (customerId > 0) {
                    Customer customer = new Customer();
                    customer.setId(customerId);
                    customer.setFullName(rs.getString("u.fullName"));
                    customer.setPhone(rs.getString("u.phone"));
                    customer.setEmail(rs.getString("u.email"));
                    customer.setUsername(rs.getString("u.username"));
                    customer.setRole(rs.getString("u.role"));
                    
                    // Set membercard nếu có
                    int memberCardId = rs.getInt("c.tblMemberCardid");
                    if (memberCardId > 0) {
                        Membercard membercard = new Membercard();
                        membercard.setId(memberCardId);
                        customer.setMembercard(membercard);
                    }
                    
                    order.setCustomer(customer);
                } else {
                    // Nếu không có khách hàng, set null
                    order.setCustomer(null);
                }
                
                // Load order details
                order.setProducts(null); // Sẽ load riêng nếu cần
                
                return order;
            }
        }
        return null;
    }

    /**
     * Xóa đơn hàng (cùng với tất cả chi tiết)
     */
    public boolean deleteOrder(int orderId) throws SQLException {
        // Xóa chi tiết đơn hàng trước
        String deleteDetailsSql = "DELETE FROM tblOrderDetail WHERE tblOrderid = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(deleteDetailsSql)) {
            ps.setInt(1, orderId);
            ps.executeUpdate();
        }
        
        // Xóa đơn hàng
        String deleteOrderSql = "DELETE FROM tblOrder WHERE id = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(deleteOrderSql)) {
            ps.setInt(1, orderId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Tính tổng tiền của đơn hàng
     */
    public double calculateOrderTotal(int orderId) throws SQLException {
        String sql = "SELECT SUM(od.quantity * p.price) as total " +
                     "FROM tblOrderDetail od " +
                     "INNER JOIN tblProduct p ON od.tblProductid = p.id " +
                     "WHERE od.tblOrderid = ?";
        
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getDouble("total");
            }
        }
        return 0.0;
    }
}

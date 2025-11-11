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
    public List<OrderDetail> getOrderDetails(Order order) throws SQLException {
        if (order == null) {
            return new ArrayList<>();
        }
        
        List<OrderDetail> details = new ArrayList<>();
        String sql = "SELECT od.id, od.quantity, od.tblProductid, " +
                     "p.id as product_id, p.name, p.price, p.type, p.imageUrl " +
                     "FROM tblOrderDetail od " +
                     "INNER JOIN tblProduct p ON od.tblProductid = p.id " +
                     "WHERE od.tblOrderid = ?";
        
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, order.getId());
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("product_id"));
                product.setName(rs.getString("p.name"));
                product.setPrice((float)rs.getDouble("p.price"));
                product.setType(rs.getString("p.type"));
                product.setImageUrl(rs.getString("p.imageUrl"));
                
                OrderDetail detail = new OrderDetail(
                    rs.getInt("od.id"),
                    rs.getInt("od.quantity"),
                    product,
                    order
                );
                details.add(detail);
            }
        }
        return details;
    }

    /**
     * Lấy thông tin Order đầy đủ theo Order ID
     */
    public Order getOrderById(int orderId) throws SQLException {
        String sql = "SELECT o.id, o.tblTableid, o.tblCustomertblUserid, " +
                     "t.id as table_id, t.name, t.status, t.description, " +
                     "u.id as customer_id, u.fullName, u.phone, u.email, u.username, u.role, " +
                     "c.tblMemberCardid, m.point " +
                     "FROM tblOrder o " +
                     "INNER JOIN tblTable t ON o.tblTableid = t.id " +
                     "LEFT JOIN tblUser u ON o.tblCustomertblUserid = u.id " +
                     "LEFT JOIN tblCustomer c ON u.id = c.tblUserid " +
                     "LEFT JOIN tblMemberCard m ON c.tblMemberCardid = m.id " +
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
                        membercard.setPoint(rs.getInt("m.point"));
                        customer.setMembercard(membercard);
                    }
                    
                    order.setCustomer(customer);
                } else {
                    // Nếu không có khách hàng, set null
                    order.setCustomer(null);
                }
                
                return order;
            }
        }
        return null;
    }

    public double calculateOrderTotal(Order order) throws SQLException {
        if (order == null) {
            return 0.0;
        }
        
        String sql = "SELECT SUM(od.quantity * p.price) as total " +
                     "FROM tblOrderDetail od " +
                     "INNER JOIN tblProduct p ON od.tblProductid = p.id " +
                     "WHERE od.tblOrderid = ?";
        
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, order.getId());
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getDouble("total");
            }
        }
        return 0.0;
    }
}

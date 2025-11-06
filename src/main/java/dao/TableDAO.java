package dao;

import model.Table;
import model.Customer;
import model.Order;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TableDAO extends DAO {

    /**
     * Lấy tất cả bàn theo trạng thái (1 = đang phục vụ)
     */
    public List<Table> getTablesByStatus(int status) throws SQLException {
        List<Table> tables = new ArrayList<>();
        String sql = "SELECT id, name, status, description FROM tblTable WHERE status = ? ORDER BY id";
        
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, status);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Table table = new Table(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getInt("status"),
                    rs.getString("description")
                );
                tables.add(table);
            }
        }
        return tables;
    }

    /**
     * Tìm bàn theo ID
     */
    public Table getTableById(int id) throws SQLException {
        String sql = "SELECT id, name, status, description FROM tblTable WHERE id = ?";
        
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return new Table(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getInt("status"),
                    rs.getString("description")
                );
            }
        }
        return null;
    }

    /**
     * Tìm bàn theo từ khóa (tên bàn hoặc ID) hoặc tên khách hàng
     * Chỉ lấy bàn đang được phục vụ (status = 1)
     */
    public List<Table> searchTables(String keyword) throws SQLException {
        List<Table> tables = new ArrayList<>();
        
        // Kiểm tra nếu keyword là số (ID bàn)
        boolean isNumeric = keyword.matches("\\d+");
        
        String sql;
        if (isNumeric) {
            // Tìm theo ID hoặc tên bàn chứa keyword
            sql = "SELECT DISTINCT t.id, t.name, t.status, t.description " +
                  "FROM tblTable t " +
                  "LEFT JOIN tblOrder o ON t.id = o.tblTableid " +
                  "LEFT JOIN tblCustomer c ON o.tblCustomertblUserid = c.tblUserid " +
                  "WHERE t.status = 1 AND " +
                  "(CAST(t.id AS CHAR) LIKE ? OR t.name LIKE ? OR c.fullName LIKE ?) " +
                  "ORDER BY t.id";
        } else {
            // Tìm theo tên bàn hoặc tên khách hàng
            sql = "SELECT DISTINCT t.id, t.name, t.status, t.description " +
                  "FROM tblTable t " +
                  "LEFT JOIN tblOrder o ON t.id = o.tblTableid " +
                  "LEFT JOIN tblCustomer c ON o.tblCustomertblUserid = c.tblUserid " +
                  "WHERE t.status = 1 AND " +
                  "(t.name LIKE ? OR c.fullName LIKE ?) " +
                  "ORDER BY t.id";
        }
        
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            
            if (isNumeric) {
                ps.setString(1, searchPattern);
                ps.setString(2, searchPattern);
                ps.setString(3, searchPattern);
            } else {
                ps.setString(1, searchPattern);
                ps.setString(2, searchPattern);
            }
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Table table = new Table(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getInt("status"),
                    rs.getString("description")
                );
                tables.add(table);
            }
        }
        return tables;
    }

    /**
     * Lấy thông tin khách hàng và order của bàn
     */
    public Order getOrderByTableId(int tableId) throws SQLException {
        String sql = "SELECT o.id, o.tblTableid, o.tblCustomertblUserid, o.created_at, " +
                     "u.id as customer_id, u.fullName, u.phone, u.email, u.username, u.password, u.role " +
                     "FROM tblOrder o " +
                     "LEFT JOIN tblUser u ON o.tblCustomertblUserid = u.id " +
                     "WHERE o.tblTableid = ? ORDER BY o.created_at DESC LIMIT 1";
        
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, tableId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("o.id"));
                
                // Set table
                Table table = new Table();
                table.setId(tableId);
                order.setTable(table);
                
                // Set customer nếu có
                int customerId = rs.getInt("customer_id");
                if (customerId > 0) {
                    Customer customer = new Customer();
                    customer.setId(customerId);
                    customer.setFullName(rs.getString("u.fullName"));
                    customer.setPhone(rs.getString("u.phone"));
                    customer.setEmail(rs.getString("u.email"));
                    customer.setUsername(rs.getString("u.username"));
                    customer.setPassword(rs.getString("u.password"));
                    customer.setRole(rs.getString("u.role"));
                    order.setCustomer(customer);
                }
                
                java.sql.Timestamp timestamp = rs.getTimestamp("o.created_at");
                if (timestamp != null) {
                    order.setCreated_at(timestamp.toLocalDateTime());
                }
                
                return order;
            }
        }
        return null;
    }

    /**
     * Cập nhật trạng thái bàn
     */
    public boolean updateTableStatus(int tableId, int status) throws SQLException {
        String sql = "UPDATE tblTable SET status = ? WHERE id = ?";
        
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, tableId);
            return ps.executeUpdate() > 0;
        }
    }
}

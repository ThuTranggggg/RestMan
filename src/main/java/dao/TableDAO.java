package dao;

import model.Table;
import model.Customer;
import model.Order;
import model.Membercard;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TableDAO extends DAO {
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
     * Lấy thông tin order của bàn (chỉ lấy tên khách hàng và membercard)
     */
    public Order getOrderByTableId(int tableId) throws SQLException {
        String sql = "SELECT o.id, o.tblTableid, o.tblCustomertblUserid, " +
                     "u.id as customer_id, u.fullName, " +
                     "c.tblMemberCardid, m.point " +
                     "FROM tblOrder o " +
                     "LEFT JOIN tblUser u ON o.tblCustomertblUserid = u.id " +
                     "LEFT JOIN tblCustomer c ON u.id = c.tblUserid " +
                     "LEFT JOIN tblMemberCard m ON c.tblMemberCardid = m.id " +
                     "WHERE o.tblTableid = ? ORDER BY o.id DESC LIMIT 1";
        
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
                
                // Set customer (chỉ lấy tên và membercard)
                int customerId = rs.getInt("customer_id");
                if (customerId > 0) {
                    Customer customer = new Customer();
                    customer.setId(customerId);
                    customer.setFullName(rs.getString("u.fullName"));
                    
                    // Set membercard nếu có
                    int memberCardId = rs.getInt("c.tblMemberCardid");
                    if (memberCardId > 0) {
                        Membercard membercard = new Membercard();
                        membercard.setId(memberCardId);
                        membercard.setPoint(rs.getInt("m.point"));
                        customer.setMembercard(membercard);
                    }
                    
                    order.setCustomer(customer);
                }
                
                return order;
            }
        }
        return null;
    }

    /**
     * Lấy tất cả bàn đang có order chưa thanh toán (status = 1)
     */
    public List<Table> getTablesWithPendingOrders() throws SQLException {
        List<Table> tables = new ArrayList<>();
        String sql = "SELECT id, name, status, description " +
                     "FROM tblTable " +
                     "WHERE status = 1 " +
                     "ORDER BY id";
        
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
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
     * Tìm bàn theo từ khóa (tên bàn, ID, hoặc tên khách hàng)
     * Chỉ lấy bàn có order chưa thanh toán (status = 1)
     */
    public List<Table> searchTablesWithPendingOrders(String keyword) throws SQLException {
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
                  "LEFT JOIN tblUser u ON c.tblUserid = u.id " +
                  "WHERE t.status = 1 AND (CAST(t.id AS CHAR) LIKE ? OR t.name LIKE ? OR u.fullName LIKE ?) " +
                  "ORDER BY t.id";
        } else {
            // Tìm theo tên bàn hoặc tên khách hàng
            sql = "SELECT DISTINCT t.id, t.name, t.status, t.description " +
                  "FROM tblTable t " +
                  "LEFT JOIN tblOrder o ON t.id = o.tblTableid " +
                  "LEFT JOIN tblCustomer c ON o.tblCustomertblUserid = c.tblUserid " +
                  "LEFT JOIN tblUser u ON c.tblUserid = u.id " +
                  "WHERE t.status = 1 AND (t.name LIKE ? OR u.fullName LIKE ?) " +
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

    public boolean updateTableStatus(int tableId, int status) throws SQLException {
        String sql = "UPDATE tblTable SET status = ? WHERE id = ?";
        
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, tableId);
            return ps.executeUpdate() > 0;
        }
    }
}

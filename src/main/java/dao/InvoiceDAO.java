package dao;

import model.Invoice;
import model.Order;
import model.Staff;
import model.User;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;

public class InvoiceDAO extends DAO {

    /**
     * Kiểm tra staffId có tồn tại trong bảng tblServer
     */
    private boolean isServerExists(int staffId) throws SQLException {
        String sql = "SELECT 1 FROM tblServer WHERE tblStafftblUserId = ? LIMIT 1";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, staffId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        }
    }

    /**
     * Tạo hóa đơn từ đơn hàng
     */
    public int createInvoice(int orderId, int staffId, int bonusPoint) throws SQLException {
        String sql = "INSERT INTO tblInvoice (tblOrderid, tblServertblStafftblUserid, bonusPoint, datetime) " +
                     "VALUES (?, ?, ?, NOW())";
        
        try (PreparedStatement ps = getConnection().prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, orderId);
            
            // Kiểm tra staffId có tồn tại trong tblServer
            if (isServerExists(staffId)) {
                ps.setInt(2, staffId);
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }
            
            ps.setInt(3, bonusPoint);
            
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
     * Lấy thông tin hóa đơn theo Invoice ID
     */
    public Invoice getInvoiceById(int invoiceId) throws SQLException {
        String sql = "SELECT i.id, i.tblOrderid, i.tblServertblStafftblUserid, i.bonusPoint, i.datetime, " +
                     "u.id as staff_id, u.fullName as staff_name, u.phone, u.email, u.username, u.password, u.role " +
                     "FROM tblInvoice i " +
                     "LEFT JOIN tblUser u ON i.tblServertblStafftblUserid = u.id " +
                     "WHERE i.id = ?";
        
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Staff staff = null;
                int staffId = rs.getInt("staff_id");
                if (staffId > 0) {
                    User staffUser = new User(
                        staffId,
                        rs.getString("staff_name"),
                        rs.getString("u.phone"),
                        rs.getString("u.email"),
                        rs.getString("u.username"),
                        rs.getString("u.password"),
                        rs.getString("u.role")
                    );
                    staff = new Staff(staffUser, "");
                }
                
                // Load order
                Order order = null;
                OrderDAO orderDAO = new OrderDAO();
                try {
                    order = orderDAO.getOrderById(rs.getInt("i.tblOrderid"));
                } catch (SQLException e) {
                    // Order không tìm thấy
                }
                
                Timestamp timestamp = rs.getTimestamp("i.datetime");
                LocalDateTime datetime = timestamp != null ? timestamp.toLocalDateTime() : LocalDateTime.now();
                
                Invoice invoice = new Invoice(
                    invoiceId,
                    datetime,
                    rs.getInt("bonusPoint"),
                    order,
                    staff
                );
                
                return invoice;
            }
        }
        return null;
    }

    /**
     * Lấy danh sách hóa đơn theo ngày
     */
    public java.util.List<Invoice> getInvoicesByDate(LocalDateTime startDate, LocalDateTime endDate) throws SQLException {
        java.util.List<Invoice> invoices = new java.util.ArrayList<>();
        String sql = "SELECT i.id, i.tblOrderid, i.tblServertblStafftblUserid, i.bonusPoint, i.datetime " +
                     "FROM tblInvoice i " +
                     "WHERE DATE(i.datetime) BETWEEN ? AND ? " +
                     "ORDER BY i.datetime DESC";
        
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(startDate));
            ps.setTimestamp(2, Timestamp.valueOf(endDate));
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Invoice invoice = getInvoiceById(rs.getInt("id"));
                if (invoice != null) {
                    invoices.add(invoice);
                }
            }
        }
        return invoices;
    }

    /**
     * Tính tổng doanh thu theo ngày
     */
    public double calculateRevenueByDate(LocalDateTime startDate, LocalDateTime endDate) throws SQLException {
        String sql = "SELECT SUM(od.quantity * p.price) as total_revenue " +
                     "FROM tblInvoice i " +
                     "INNER JOIN tblOrder o ON i.tblOrderid = o.id " +
                     "INNER JOIN tblOrderDetail od ON o.id = od.tblOrderid " +
                     "INNER JOIN tblProduct p ON od.tblProductid = p.id " +
                     "WHERE DATE(i.datetime) BETWEEN ? AND ?";
        
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(startDate));
            ps.setTimestamp(2, Timestamp.valueOf(endDate));
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getDouble("total_revenue");
            }
        }
        return 0.0;
    }
}

package dao;

import model.Invoice;
import model.Order;
import model.Server;
import model.Customer;
import model.Table;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;

public class InvoiceDAO extends DAO {
    private boolean isServerExists(int staffId) throws SQLException {
        String sql = "SELECT 1 FROM tblServer WHERE tblStafftblUserId = ? LIMIT 1";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, staffId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        }
    }

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

    //Lấy thông tin hóa đơn theo Invoice ID
    public Invoice getInvoiceById(int invoiceId) throws SQLException {
        String sql = "SELECT i.id, i.tblOrderid, i.tblServertblStafftblUserid, i.bonusPoint, i.datetime, " +
                     "u.id as staff_id, u.fullName as staff_name, u.phone, u.email, u.username, u.password, u.role, " +
                     "s.position, " +
                     "o.tblCustomertblUserid, o.tblTableid " +
                     "FROM tblInvoice i " +
                     "LEFT JOIN tblServer sv ON i.tblServertblStafftblUserid = sv.tblStafftblUserId " +
                     "LEFT JOIN tblStaff s ON sv.tblStafftblUserId = s.tblUserId " +
                     "LEFT JOIN tblUser u ON s.tblUserId = u.id " +
                     "INNER JOIN tblOrder o ON i.tblOrderid = o.id " +
                     "WHERE i.id = ?";
        
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Server server = null;
                int staffId = rs.getInt("staff_id");
                if (staffId > 0) {
                    server = new Server(
                        staffId,
                        rs.getString("staff_name"),
                        rs.getString("phone"),
                        rs.getString("email"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("role"),
                        rs.getString("position")
                    );
                }
                
                // Load Order info
                Customer customer = null;
                Table table = null;
                int customerId = rs.getInt("o.tblCustomertblUserid");
                int tableId = rs.getInt("o.tblTableid");
                
                if (customerId > 0) {
                    // Load customer (có thể để null nếu không có customer)
                    customer = null; // TODO: Load from database if needed
                }
                
                if (tableId > 0) {
                    // Load table
                    TableDAO tableDAO = new TableDAO();
                    table = tableDAO.getTableById(tableId);
                }
                
                Timestamp timestamp = rs.getTimestamp("i.datetime");
                LocalDateTime datetime = timestamp != null ? timestamp.toLocalDateTime() : LocalDateTime.now();
                
                int orderId = rs.getInt("tblOrderid");
                int invoiceIdValue = rs.getInt("i.id");

                Invoice invoice = new Invoice(
                    invoiceIdValue,  // Invoice ID (kế thừa từ Order.id để tương thích)
                    table,
                    customer,
                    server,
                    rs.getInt("bonusPoint"),
                    datetime
                );
                
                //Set orderId riêng để lấy OrderDetails
                invoice.setOrderId(orderId);
                
                // Load OrderDetails
                OrderDAO orderDAO = new OrderDAO();
                Order order = orderDAO.getOrderById(orderId);
                if (order != null) {
                    invoice.setTable(order.getTable());
                    invoice.setCustomer(order.getCustomer());
                }
                
                return invoice;
            }
        }
        return null;
    }


    public boolean addBonusPointsToMembercard(int customerId, int bonusPoints) throws SQLException {
        String sql = "UPDATE tblMemberCard SET point = point + ? " +
                     "WHERE id = (SELECT tblMemberCardid FROM tblCustomer WHERE tblUserid = ?)";
        
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, bonusPoints);
            ps.setInt(2, customerId);
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        }
    }
}

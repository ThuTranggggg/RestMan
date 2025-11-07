package dao;

import model.Staff;
import model.User;
import model.Server;
import model.Manager;
import model.StockClerk;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class StaffDAO extends DAO {

    /**
     * Tìm nhân viên theo User ID
     */
    public Staff findStaffByUserId(int userId) throws SQLException {
        String sql = "SELECT s.position, u.id, u.fullName, u.phone, u.email, u.username, u.password, u.role " +
                     "FROM tblStaff s " +
                     "INNER JOIN tblUser u ON s.tblUserId = u.id " +
                     "WHERE u.id = ?";
        
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                User user = new User(
                    rs.getInt("u.id"),
                    rs.getString("u.fullName"),
                    rs.getString("u.phone"),
                    rs.getString("u.email"),
                    rs.getString("u.username"),
                    rs.getString("u.password"),
                    rs.getString("u.role")
                );
                
                String position = rs.getString("position");
                Staff staff;
                
                // Tạo đúng kiểu Staff dựa vào position
                if ("Server".equals(position)) {
                    staff = new Server(user, position);
                } else if ("Manager".equals(position)) {
                    staff = new Manager(user, position);
                } else if ("StockClerk".equals(position)) {
                    staff = new StockClerk(user, position);
                } else {
                    staff = new Staff(user, position);
                }
                
                return staff;
            }
        }
        return null;
    }

    /**
     * Tìm nhân viên theo username (để đăng nhập)
     */
    public Staff findStaffByUsername(String username) throws SQLException {
        String sql = "SELECT s.position, u.id, u.fullName, u.phone, u.email, u.username, u.password, u.role " +
                     "FROM tblStaff s " +
                     "INNER JOIN tblUser u ON s.tblUserId = u.id " +
                     "WHERE u.username = ? AND u.role = 'STAFF'";
        
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                User user = new User(
                    rs.getInt("u.id"),
                    rs.getString("u.fullName"),
                    rs.getString("u.phone"),
                    rs.getString("u.email"),
                    rs.getString("u.username"),
                    rs.getString("u.password"),
                    rs.getString("u.role")
                );
                
                String position = rs.getString("position");
                Staff staff;
                
                // Tạo đúng kiểu Staff dựa vào position
                if ("Server".equals(position)) {
                    staff = new Server(user, position);
                } else if ("Manager".equals(position)) {
                    staff = new Manager(user, position);
                } else if ("StockClerk".equals(position)) {
                    staff = new StockClerk(user, position);
                } else {
                    staff = new Staff(user, position);
                }
                
                return staff;
            }
        }
        return null;
    }

    /**
     * Kiểm tra đăng nhập nhân viên
     */
    public Staff authenticate(String username, String password) throws SQLException {
        Staff staff = findStaffByUsername(username);
        if (staff != null && staff.getUser().getPassword().equals(password)) {
            return staff;
        }
        return null;
    }

    /**
     * Tạo nhân viên mới
     */
    public boolean createStaff(User user, String position) throws SQLException {
        // Trước tiên insert vào bảng User
        String userSql = "INSERT INTO tblUser (fullName, phone, email, username, password, role) " +
                        "VALUES (?, ?, ?, ?, ?, 'STAFF')";
        
        try (PreparedStatement ps = getConnection().prepareStatement(userSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getPhone());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getUsername());
            ps.setString(5, user.getPassword());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int userId = generatedKeys.getInt(1);
                    
                    // Insert vào bảng Staff
                    String staffSql = "INSERT INTO tblStaff (tblUserId, position) VALUES (?, ?)";
                    try (PreparedStatement staffPs = getConnection().prepareStatement(staffSql)) {
                        staffPs.setInt(1, userId);
                        staffPs.setString(2, position);
                        return staffPs.executeUpdate() > 0;
                    }
                }
            }
        }
        return false;
    }
}

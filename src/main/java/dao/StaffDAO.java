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
    public Staff findStaffByUsername(String username) throws SQLException {
        String sql = "SELECT s.position, u.id, u.fullName, u.phone, u.email, u.username, u.password, u.role " +
                     "FROM tblStaff s " +
                     "INNER JOIN tblUser u ON s.tblUserId = u.id " +
                     "WHERE u.username = ? AND u.role = 'STAFF'";
        
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                int id = rs.getInt("id");
                String fullName = rs.getString("fullName");
                String phone = rs.getString("phone");
                String email = rs.getString("email");
                String usernameStr = rs.getString("username");
                String password = rs.getString("password");
                String role = rs.getString("role");
                String position = rs.getString("position");
                
                Staff staff;
                
                // Tạo đúng kiểu Staff dựa vào position
                if ("Server".equals(position)) {
                    staff = new Server(id, fullName, phone, email, usernameStr, password, role, position);
                } else if ("Manager".equals(position)) {
                    staff = new Manager(id, fullName, phone, email, usernameStr, password, role, position);
                } else if ("StockClerk".equals(position)) {
                    staff = new StockClerk(id, fullName, phone, email, usernameStr, password, role, position);
                } else {
                    staff = new Staff(id, fullName, phone, email, usernameStr, password, role, position);
                }
                
                return staff;
            }
        }
        return null;
    }

    public Staff authenticate(String username, String password) throws SQLException {
        Staff staff = findStaffByUsername(username);
        if (staff != null && staff.getPassword().equals(password)) {
            return staff;
        }
        return null;
    }
}

package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public abstract class DAO {
    // → Có thể đọc từ env/system properties thay vì hard-code.
    private static final String DB_URL  = System.getProperty("RESTMAN_DB_URL",
            "jdbc:mysql://localhost:3306/RestMan");
    private static final String DB_USER = System.getProperty("RESTMAN_DB_USER", "root");
    private static final String DB_PASS = System.getProperty("RESTMAN_DB_PASS", "1235aBc@03");

    protected Connection con;

    protected Connection getConnection() throws SQLException {
        if (con == null || con.isClosed()) {
            try { Class.forName("com.mysql.cj.jdbc.Driver"); }
            catch (ClassNotFoundException e) { throw new SQLException("MySQL driver not found", e); }
            con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
        }
        return con;
    }

    // Đóng kết nối khi DAO không dùng nữa (ví dụ trong Servlet.destroy)
    public void closeQuietly() {
        if (con != null) try { con.close(); } catch (SQLException ignore) {}
    }
}

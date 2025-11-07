package dao;

import io.github.cdimascio.dotenv.Dotenv;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.io.File;

public abstract class DAO {
    private static final Dotenv dotenv = loadDotenv();
    
    private static Dotenv loadDotenv() {
        String[] possiblePaths = {
            System.getProperty("user.dir"),  // Working directory
            System.getProperty("catalina.base"), // Tomcat base
            "f:/Semester7/PhanTichThietKe/RestMan20", // Absolute path (Windows)
            "/f/Semester7/PhanTichThietKe/RestMan20"  // Absolute path (Unix-style)
        };
        
        for (String path : possiblePaths) {
            if (path != null) {
                File envFile = new File(path, ".env");
                if (envFile.exists()) {
                    System.out.println("✓ Loading .env from: " + envFile.getAbsolutePath());
                    return Dotenv.configure()
                            .directory(path)
                            .ignoreIfMissing()
                            .load();
                }
            }
        }
        
        // Thử tìm trong classpath (WEB-INF/classes)
        try {
            var classLoader = DAO.class.getClassLoader();
            var resource = classLoader.getResource(".env");
            if (resource != null) {
                String classpathDir = new File(resource.toURI()).getParent();
                System.out.println("Loading .env from classpath: " + classpathDir);
                return Dotenv.configure()
                        .directory(classpathDir)
                        .ignoreIfMissing()
                        .load();
            }
        } catch (Exception e) {
            System.err.println("Failed to load .env from classpath: " + e.getMessage());
        }
        
        // Nếu không tìm thấy, dùng config mặc định
        System.err.println("Warning: .env file not found, using default configuration");
        return Dotenv.configure().ignoreIfMissing().load();
    }
    
    private static final String DB_URL  = dotenv.get("DB_URL");
    private static final String DB_USER = dotenv.get("DB_USER");
    private static final String DB_PASS = dotenv.get("DB_PASS");

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

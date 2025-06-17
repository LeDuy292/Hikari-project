
package utils;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.sql.Connection;
import java.sql.SQLException;

public class DBContext {

    private static final HikariDataSource dataSource;

    static {
        HikariConfig config = new HikariConfig();

        // ✅ Thay đổi cấu hình cho MySQL
        config.setJdbcUrl("jdbc:mysql://localhost:3306/jlearning?useSSL=false&serverTimezone=UTC");
        config.setUsername("root");       // sửa lại theo thông tin thật
        config.setPassword("1842004duy");        // sửa lại theo thông tin thật
        config.setDriverClassName("com.mysql.cj.jdbc.Driver");

        // Tuỳ chỉnh hiệu suất (có thể thay đổi)
        config.setMaximumPoolSize(10);
        config.setMinimumIdle(2);
        config.setIdleTimeout(30000);
        config.setConnectionTimeout(30000);
        config.setMaxLifetime(1800000);

        dataSource = new HikariDataSource(config);
    }
        private Connection connection;

    // ✅ Lấy connection mỗi khi cần
    public Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }
    
    
     public void closeConnection() {
        if (connection != null) {
            try {
                if (!connection.isClosed()) {
                    connection.close();
                    System.out.println("Database connection closed.");
                }
            } catch (SQLException e) {
                System.err.println("Error closing database connection: " + e.getMessage());
            } finally {
                connection = null;
            }
        }
    }
}

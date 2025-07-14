package dao.student;

import model.Student;
import utils.DBContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class StudentDAO {
    private static final Logger logger = LoggerFactory.getLogger(StudentDAO.class);
    private Connection con;

    public StudentDAO() {
        DBContext dbContext = new DBContext();
        try {
            con = dbContext.getConnection();
            logger.info("StudentDAO: Database connection established successfully!");
        } catch (Exception e) {
            logger.error("StudentDAO: Error connecting to database: {}", e.getMessage(), e);
            throw new RuntimeException("Failed to initialize database connection", e); // Ném ngoại lệ để báo lỗi ngay
        }
    }

    /**
     * Lấy thông tin sinh viên dựa trên userID
     * @param userID Mã người dùng
     * @return Đối tượng Student nếu tìm thấy, null nếu không
     */
    public Student getStudentByUserId(String userID) {
        if (userID == null || userID.trim().isEmpty()) {
            logger.warn("Invalid userID provided: {}", userID);
            return null;
        }

        String sql = "SELECT studentID, userID, enrollmentDate, vote FROM Student WHERE userID = ?";
        try (PreparedStatement pre = con.prepareStatement(sql);
             ResultSet rs = pre.executeQuery()) {
            pre.setString(1, userID);
            if (rs.next()) {
                Student student = new Student();
                student.setStudentID(rs.getString("studentID"));
                student.setUserID(rs.getString("userID"));
                student.setEnrollmentDate(rs.getDate("enrollmentDate"));
                student.setVote(rs.getInt("vote"));
                logger.info("Found student for userID: {}", userID);
                return student;
            } else {
                logger.warn("No student found for userID: {}", userID);
                return null;
            }
        } catch (SQLException e) {
            logger.error("Error in getStudentByUserId for userID {}: {}", userID, e.getMessage(), e);
            return null; // Trả về null thay vì ném ngoại lệ để xử lý linh hoạt hơn
        }
    }

    /**
     * Lấy studentID dựa trên userID
     * @param userID Mã người dùng
     * @return studentID nếu tìm thấy, null nếu không
     */
    public String getStudentIdByUserId(String userID) {
        if (userID == null || userID.trim().isEmpty()) {
            logger.warn("Invalid userID provided: {}", userID);
            return null;
        }

        String sql = "SELECT studentID FROM Student WHERE userID = ?";
        try (PreparedStatement pre = con.prepareStatement(sql);
             ResultSet rs = pre.executeQuery()) {
            pre.setString(1, userID);
            if (rs.next()) {
                String studentID = rs.getString("studentID");
                logger.info("Found studentID: {} for userID: {}", studentID, userID);
                return studentID;
            } else {
                logger.warn("No studentID found for userID: {}", userID);
                return null;
            }
        } catch (SQLException e) {
            logger.error("Error in getStudentIdByUserId for userID {}: {}", userID, e.getMessage(), e);
            return null;
        }
    }

    /**
     * Đóng kết nối database
     */
    public void closeConnection() {
        try {
            if (con != null && !con.isClosed()) {
                con.close();
                logger.info("StudentDAO: Connection closed successfully!");
            }
        } catch (SQLException e) {
            logger.error("Error closing connection in StudentDAO: {}", e.getMessage(), e);
        }
    }

    /**
     * Đảm bảo đóng kết nối khi đối tượng bị hủy
     */
    @Override
    protected void finalize() throws Throwable {
        try {
            closeConnection();
        } finally {
            super.finalize();
        }
    }
}
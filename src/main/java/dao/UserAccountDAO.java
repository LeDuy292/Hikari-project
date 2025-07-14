package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Teacher;
import model.UserAccount;
import utils.DBContext;

public class UserAccountDAO extends DBContext {

    public List<UserAccount> getAllUsers() {
        List<UserAccount> users = new ArrayList<>();
        String sql = "SELECT userID, username, profilePicture FROM UserAccount";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                UserAccount user = new UserAccount();
                user.setUserID(rs.getString("userID"));
                user.setUsername(rs.getString("username"));
                user.setProfilePicture(rs.getString("profilePicture"));
                users.add(user);

            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    public UserAccount getStudentNameById(String id) {
        UserAccount user = new UserAccount();
        String sql = "Select fullName from UserAccount u join Student s on u.userID = s.userID where s.studentID = ?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, id);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                user.setFullName(rs.getString("fullName"));
            }
        } catch (Exception e) {
        }
        return user ; 
    }
    public Teacher getByUserID(String userID) {
    Teacher teacher = null;
    String sql = "SELECT * FROM Teacher WHERE userID = ?";
    try (Connection con = new DBContext().getConnection(); 
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, userID);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            teacher = new Teacher();
            teacher.setTeacherID(rs.getString("teacherID"));
            teacher.setUserID(rs.getString("userID"));
            teacher.setSpecialization(rs.getString("specialization"));
            teacher.setExperienceYears(rs.getInt("experienceYears"));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return teacher;
}

    public static void main(String[] args) {
        UserAccountDAO dao = new UserAccountDAO();
        System.out.println(dao.getStudentNameById("S001"));
    }
}

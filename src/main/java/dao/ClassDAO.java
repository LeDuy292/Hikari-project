/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.ClassRoom;
import utils.DBContext;

/**
 *
 * @author ADMIN
 */
public class ClassDAO extends DBContext {

    public List<ClassRoom> getClassByTeacherID(String teacherID) {
        List<ClassRoom> classes = new ArrayList<>();
        String sql = "Select * from Class Where teacherID = ? ";
        try (Connection connetion = new DBContext().getConnection(); PreparedStatement pstmt = connetion.prepareStatement(sql)) {
            pstmt.setString(1, teacherID);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                classes.add(new ClassRoom(rs.getString("classID"),
                        rs.getString("courseID"),
                        rs.getString("name"),
                        rs.getString("teacherID"),
                        rs.getInt("numberOfStudents")));

            }
        } catch (Exception e) {
        }
        return classes;
    }
    public static void main(String[] args) {
        ClassDAO dao = new ClassDAO();
        System.out.println(dao.getClassByTeacherID("T002"));
    }
}

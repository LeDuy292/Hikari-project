package dao;

import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Document;
import responsitory.DocumentResponsitory;
import utils.DBContext;

public class DocumentDAO extends DBContext {
    private final DocumentResponsitory res = new DocumentResponsitory();

    public List<Document> getDocumentByTeacher(String teacherID) {
        List<Document> documents = new ArrayList<>();
        String sql = "SELECT * FROM Document WHERE uploadedBy = ?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, teacherID);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                documents.add(new Document(
                        rs.getInt("id"),
                        rs.getInt("lessonID"),
                        rs.getString("classID"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getString("fileUrl"),
                        rs.getString("imageUrl"),
                        rs.getTimestamp("uploadDate"),
                        rs.getString("uploadedBy")
                ));
            }
        } catch (SQLException ex) {
            Logger.getLogger(DocumentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return documents;
    }

    public List<Document> getDocumentByTeacherAndCLass(String teacherID, String classID) {
        List<Document> documents = new ArrayList<>();
        String sql = "SELECT * FROM Document WHERE uploadedBy = ? AND classID = ?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, teacherID);
            pstmt.setString(2, classID);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                documents.add(new Document(
                        rs.getInt("id"),
                        rs.getInt("lessonID"),
                        rs.getString("classID"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getString("fileUrl"),
                        rs.getString("imageUrl"),
                        rs.getTimestamp("uploadDate"),
                        rs.getString("uploadedBy")
                ));
            }
        } catch (SQLException ex) {
            Logger.getLogger(DocumentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return documents;
    }

    public List<Document> getALLDOcument() {
        List<Document> documents = new ArrayList<>();
        String sql = "SELECT * FROM Document";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                documents.add(new Document(
                        rs.getInt("id"),
                        rs.getInt("lessonID"),
                        rs.getString("classID"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getString("fileUrl"),
                        rs.getString("imageUrl"),
                        rs.getTimestamp("uploadDate"),
                        rs.getString("uploadedBy")
                ));
            }
        } catch (SQLException ex) {
            Logger.getLogger(DocumentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return documents;
    }

    public void addDocument(Document document, Part filePart, Part imgPart) throws SQLException, IOException {
        // Kiểm tra classID có tồn tại và thuộc về teacherID
        String checkSql = "SELECT COUNT(*) FROM Class WHERE id = ? AND teacherID = ?";
        try (Connection conn = getConnection(); PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
            checkStmt.setString(1, document.getClassID());
            checkStmt.setString(2, document.getUploadedBy());
            ResultSet rs = checkStmt.executeQuery();
            rs.next();
            if (rs.getInt(1) == 0) {
                throw new SQLException("classID không hợp lệ hoặc bạn không có quyền truy cập lớp này.");
            }
        }

        String sql = "INSERT INTO Document (classID, lessonID, title, description, fileUrl, uploadDate, uploadedBy, imageUrl) " +
                     "VALUES (?, NULL, ?, ?, ?, NOW(), ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            String fileUrl = res.saveFile(filePart, "documents");
            String imgUrl = imgPart != null && imgPart.getSize() > 0 ? res.saveFile(imgPart, "img") : null;
            pstmt.setString(1, document.getClassID());
            pstmt.setString(2, document.getTitle());
            pstmt.setString(3, document.getDescription());
            pstmt.setString(4, fileUrl);
            pstmt.setString(5, document.getUploadedBy());
            pstmt.setString(6, imgUrl);
            pstmt.executeUpdate();
        }
    }

    public void updateDocument(Document document, Part imagePart) throws SQLException, IOException {
        String sql = "UPDATE Document SET title = ?, description = ?, imageUrl = ? WHERE id = ? AND uploadedBy = ?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            String imgUrl = imagePart != null && imagePart.getSize() > 0 ? res.saveFile(imagePart, "img") : null;
            pstmt.setString(1, document.getTitle());
            pstmt.setString(2, document.getDescription());
            pstmt.setString(3, imgUrl);
            pstmt.setInt(4, document.getId());
            pstmt.setString(5, document.getUploadedBy());
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("Không tìm thấy tài liệu hoặc bạn không có quyền cập nhật.");
            }
        }
    }

   public void deleteDocument(int documentId) throws SQLException {
        String sql = "SELECT fileUrl, imageUrl FROM Document WHERE id = ?";
        String fileUrl = null;
        String imageUrl = null;
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, documentId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                fileUrl = rs.getString("fileUrl");
                imageUrl = rs.getString("imageUrl");
            }
        }
        sql = "DELETE FROM Document WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, documentId);
            int rows = pstmt.executeUpdate();
            if (rows == 0) {
                throw new SQLException("Document not found: " + documentId);
            }
            if (fileUrl != null) {
                res.deleteFile(fileUrl);
            }
            if (imageUrl != null) {
                res.deleteFile(imageUrl);
            }
        }
    }

    public static void main(String[] args) {
        DocumentDAO dao = new DocumentDAO();
        System.out.println(dao.getALLDOcument());
        System.out.println(dao.getDocumentByTeacher("T002"));
    }
}

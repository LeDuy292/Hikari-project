package dao;

import jakarta.servlet.http.Part;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Document;
import responsitory.DocumentResponsitory;
import utils.DBContext;

public class DocumentDAO extends DBContext {

    private final DocumentResponsitory res = new DocumentResponsitory();
public List<Document> getDocumentsByLessonId(int lessonId) throws SQLException {
    List<Document> documents = new ArrayList<>();
    String sql = "SELECT id, lessonID, classID, title, description, fileUrl, imageUrl, uploadDate, uploadedBy " +
                 "FROM Document WHERE lessonID = ?";
    try (Connection conn = getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {

        pstmt.setInt(1, lessonId);
        try (ResultSet rs = pstmt.executeQuery()) {
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
        }
        Logger.getLogger(DocumentDAO.class.getName()).log(Level.INFO, 
                "Retrieved {0} documents for lessonId: {1}", 
                new Object[]{documents.size(), lessonId});
    } catch (SQLException ex) {
        Logger.getLogger(DocumentDAO.class.getName()).log(Level.SEVERE, 
                "Error fetching documents for lessonId: " + lessonId, ex);
        throw ex;
    }
    return documents;
}
    public List<Document> getDocumentByTeacher(String teacherID) {
        List<Document> documents = new ArrayList<>();
        String sql = "SELECT * FROM Document WHERE uploadedBy = ?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, teacherID);
            try (ResultSet rs = pstmt.executeQuery()) {
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
            try (ResultSet rs = pstmt.executeQuery()) {
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
            }
        } catch (SQLException ex) {
            Logger.getLogger(DocumentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return documents;
    }

    public List<Document> getALLDOcument() {
        List<Document> documents = new ArrayList<>();
        String sql = "SELECT * FROM Document";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql); ResultSet rs = pstmt.executeQuery()) {

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

    public void addDocumentByLesson(Document document, Part filePart, Part imgPart) throws SQLException, IOException {
    String sql = "INSERT INTO Document (lessonID, title, description, fileUrl, uploadDate, uploadedBy) " +
                 "VALUES (?, ?, ?, ?, NOW(), ?)";
    try (Connection conn = getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {

        if (filePart == null || filePart.getSize() == 0) {
            throw new IOException("File tài liệu không hợp lệ");
        }

        String fileUrl = res.saveFile(filePart, "documents");
        if (fileUrl == null || fileUrl.isEmpty()) {
            throw new IOException("Không thể lưu file");
        }

        pstmt.setObject(1, document.getLessonID(), Types.INTEGER);
        pstmt.setString(2, document.getTitle());
        pstmt.setString(3, document.getDescription());
        pstmt.setString(4, fileUrl);
        pstmt.setString(5, document.getUploadedBy());

        int rowsAffected = pstmt.executeUpdate();
        if (rowsAffected == 0) {
            throw new SQLException("Không thể thêm tài liệu vào cơ sở dữ liệu");
        }
    }
}

    public void addDocument(Document document, Part filePart, Part imgPart) throws SQLException, IOException {
        // Kiểm tra classID có tồn tại và thuộc về teacherID
        String checkSql = "SELECT COUNT(*) FROM Class WHERE classID = ? AND teacherID = ?";
        try (Connection conn = getConnection(); PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {

            checkStmt.setString(1, document.getClassID());
            checkStmt.setString(2, document.getUploadedBy());
            try (ResultSet rs = checkStmt.executeQuery()) {
                rs.next();
                if (rs.getInt(1) == 0) {
                    throw new SQLException("classID không hợp lệ hoặc bạn không có quyền truy cập lớp này.");
                }
            }
        }

        String sql = "INSERT INTO Document (classID, lessonID, title, description, fileUrl, uploadDate, uploadedBy, imageUrl) "
                + "VALUES (?, NULL, ?, ?, ?, NOW(), ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            String fileUrl = res.saveFile(filePart, "documents");
            String imgUrl = (imgPart != null && imgPart.getSize() > 0) ? res.saveFile(imgPart, "img") : null;

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

            String imgUrl = (imagePart != null && imagePart.getSize() > 0) ? res.saveFile(imagePart, "img") : null;

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
        String fileUrl = null;
        String imageUrl = null;

        String sql = "SELECT fileUrl, imageUrl FROM Document WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, documentId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    fileUrl = rs.getString("fileUrl");
                    imageUrl = rs.getString("imageUrl");
                }
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
        System.out.println(dao.getDocumentByTeacher("T001"));
    }
}

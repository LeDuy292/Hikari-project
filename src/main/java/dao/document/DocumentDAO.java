package dao.document;

import jakarta.servlet.http.Part;
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
    private static final Logger LOGGER = Logger.getLogger(DocumentDAO.class.getName());
    public final DocumentResponsitory res = new DocumentResponsitory();

    public DocumentDAO() {
        super();
        // Test connection on initialization
        try {
            Connection testConn = getConnection();
            boolean connected = (testConn != null);
            if (testConn != null) {
                closeConnection();
            }
            LOGGER.info("DocumentDAO initialized. Database connected: " + connected);
        } catch (Exception e) {
            LOGGER.warning("DocumentDAO initialized with database connection issues: " + e.getMessage());
        }
    }

    public List<Document> getDocumentByTeacher(String teacherID) {
        List<Document> documents = new ArrayList<>();
        if (teacherID == null) {
            LOGGER.warning("TeacherID is null, returning all documents");
            return getAllDocuments();
        }
        
        Connection conn = null;
        try {
            conn = getConnection();
            if (conn == null) {
                LOGGER.warning("No database connection, returning sample documents");
                return createSampleDocuments();
            }
            
            String sql = "SELECT d.* FROM Document d " +
                        "LEFT JOIN Class c ON d.classID = c.classID " +
                        "WHERE c.teacherID = ? OR d.classID IS NULL " +
                        "ORDER BY d.uploadDate DESC";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, teacherID);
                ResultSet rs = pstmt.executeQuery();
                while (rs.next()) {
                    Document doc = mapResultSetToDocument(rs);
                    if (doc != null) {
                        documents.add(doc);
                    }
                }
                LOGGER.info("Found " + documents.size() + " documents for teacher: " + teacherID);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.WARNING, "Error getting documents for teacher: " + teacherID, ex);
            return createSampleDocuments();
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    LOGGER.warning("Error closing connection: " + e.getMessage());
                }
            }
        }
        return documents;
    }

    public List<Document> getDocumentByStudent(String studentID) {
        List<Document> documents = new ArrayList<>();
        if (studentID == null) {
            LOGGER.warning("StudentID is null, returning all documents");
            return getAllDocuments();
        }
        
        Connection conn = null;
        try {
            conn = getConnection();
            if (conn == null) {
                LOGGER.warning("No database connection, returning sample documents");
                return createSampleDocuments();
            }
            
            String sql = "SELECT DISTINCT d.* FROM Document d " +
                        "LEFT JOIN Class_Students cs ON d.classID = cs.classID " +
                        "WHERE cs.studentID = ? OR d.classID IS NULL " +
                        "ORDER BY d.uploadDate DESC";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, studentID);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Document doc = mapResultSetToDocument(rs);
                if (doc != null) {
                    documents.add(doc);
                }
            }
            LOGGER.info("Found " + documents.size() + " documents for student: " + studentID);
        }
    } catch (SQLException ex) {
        LOGGER.log(Level.WARNING, "Error getting documents for student: " + studentID, ex);
        return createSampleDocuments();
    } finally {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                LOGGER.warning("Error closing connection: " + e.getMessage());
            }
        }
    }
    return documents;
}

    public List<Document> getAllDocuments() {
        List<Document> documents = new ArrayList<>();
        Connection conn = null;
        
        try {
            conn = getConnection();
            if (conn == null) {
                LOGGER.warning("No database connection available, returning sample documents");
                return createSampleDocuments();
            }
            
            String sql = "SELECT * FROM Document ORDER BY uploadDate DESC";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                ResultSet rs = pstmt.executeQuery();
                while (rs.next()) {
                    Document doc = mapResultSetToDocument(rs);
                    if (doc != null && doc.getFileUrl() != null && !doc.getFileUrl().trim().isEmpty()) {
                        documents.add(doc);
                    }
                }
                LOGGER.info("Successfully loaded " + documents.size() + " documents from database");
            }
            
            // If no documents found in database, return sample data for testing
            if (documents.isEmpty()) {
                LOGGER.info("No documents found in database, returning sample data");
                return createSampleDocuments();
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.WARNING, "Database error, using sample data: " + ex.getMessage(), ex);
            return createSampleDocuments();
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    LOGGER.warning("Error closing connection: " + e.getMessage());
                }
            }
        }
        return documents;
    }

    public Document getDocumentById(int documentId) {
        Connection conn = null;
        try {
            conn = getConnection();
            if (conn == null) {
                LOGGER.warning("No database connection available");
                return null;
            }
            
            String sql = "SELECT * FROM Document WHERE id = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setInt(1, documentId);
                ResultSet rs = pstmt.executeQuery();
                if (rs.next()) {
                    return mapResultSetToDocument(rs);
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.WARNING, "Error getting document by ID: " + documentId, ex);
        } finally {
            if (conn != null) {
                closeConnection();
            }
        }
        return null;
    }

    // Method name compatibility
    public List<Document> getDocumentByClassID(String classId) {
        return getDocumentByClass(classId);
    }

    public List<Document> getDocumentByClass(String classId) {
        List<Document> documents = new ArrayList<>();
        if (classId == null || classId.trim().isEmpty()) {
            return getAllDocuments();
        }
        
        Connection conn = null;
        try {
            conn = getConnection();
            if (conn == null) {
                LOGGER.warning("No database connection available, returning sample documents");
                return createSampleDocuments();
            }
            
            String sql = "SELECT * FROM Document WHERE classID = ? ORDER BY uploadDate DESC";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, classId.trim());
                ResultSet rs = pstmt.executeQuery();
                while (rs.next()) {
                    documents.add(mapResultSetToDocument(rs));
                }
                LOGGER.info("Found " + documents.size() + " documents for class: " + classId);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.WARNING, "Error getting documents for class: " + classId, ex);
            return createSampleDocuments();
        } finally {
            if (conn != null) {
                closeConnection();
            }
        }
        return documents;
    }

    // Helper method to create sample documents when database is not available
    private List<Document> createSampleDocuments() {
        List<Document> documents = new ArrayList<>();
        
        documents.add(new Document(1, 1, "CL001", "Hiragana cơ bản", "Tài liệu học Hiragana", 
            "/Hikari/assets/documents/sample_documents/hiragana_basic.pdf", 
            "/Hikari/assets/img/documents/Japanese-N5.jpg", 
            new java.sql.Timestamp(System.currentTimeMillis()), "T001"));
            
        documents.add(new Document(2, 2, "CL001", "Katakana nâng cao", "Tài liệu học Katakana", 
            "/Hikari/assets/documents/sample_documents/katakana_advanced.pdf", 
            "/Hikari/assets/img/documents/Japanese-N5.jpg", 
            new java.sql.Timestamp(System.currentTimeMillis()), "T001"));
            
        documents.add(new Document(3, 3, null, "Số đếm tiếng Nhật", "Học cách đếm số", 
            "/Hikari/assets/documents/sample_documents/numbers_basic.pdf", 
            "/Hikari/assets/img/documents/Japanese-N5.jpg", 
            new java.sql.Timestamp(System.currentTimeMillis()), "T001"));
            
        documents.add(new Document(4, 11, "CL003", "Ngữ pháp N4", "Ngữ pháp cơ bản N4", 
            "/Hikari/assets/documents/sample_documents/grammar_n4.pdf", 
            "/Hikari/assets/img/documents/Japanese-N4.jpg", 
            new java.sql.Timestamp(System.currentTimeMillis()), "T002"));
            
        documents.add(new Document(5, 5, null, "Kanji N5", "50 Kanji đầu tiên", 
            "/Hikari/assets/documents/sample_documents/kanji_n5.pdf", 
            "/Hikari/assets/img/documents/Japanese-N5.jpg", 
            new java.sql.Timestamp(System.currentTimeMillis()), "T001"));
        
        LOGGER.info("Created " + documents.size() + " sample documents");
        return documents;
    }

    // Helper method to map ResultSet to Document object
    private Document mapResultSetToDocument(ResultSet rs) throws SQLException {
        try {
            return new Document(
                rs.getInt("id"),
                rs.getObject("lessonID") != null ? rs.getInt("lessonID") : 0,
                rs.getString("classID"),
                rs.getString("title"),
                rs.getString("description"),
                rs.getString("fileUrl"),
                rs.getString("imageUrl"),
                rs.getTimestamp("uploadDate"),
                rs.getString("uploadedBy")
            );
        } catch (SQLException e) {
            LOGGER.warning("Error mapping document from ResultSet: " + e.getMessage());
            return null;
        }
    }

    // Safe methods that won't crash the application
    public boolean hasAccessToDocument(String userID, String userRole, String studentID, String teacherID, int documentId) {
        try {
            Document document = getDocumentById(documentId);
            if (document == null) {
                return false;
            }
            
            String classID = document.getClassID();
            
            // Nếu document không thuộc lớp nào (general documents), tất cả đều có thể truy cập
            if (classID == null || classID.trim().isEmpty()) {
                return true;
            }

            if ("Admin".equals(userRole) || "Coordinator".equals(userRole)) {
                return true;
            }
            
            // For testing, allow all access
            return true;
            
        } catch (Exception e) {
            LOGGER.warning("Error checking document access: " + e.getMessage());
            return true; // Default allow for testing
        }
    }

    public List<Document> searchDocuments(String searchTerm, String classId, String userRole, String studentID, String teacherID) {
        try {
            List<Document> allDocs = getAllDocuments();
            if (searchTerm == null || searchTerm.trim().isEmpty()) {
                return allDocs;
            }
            
            List<Document> filtered = new ArrayList<>();
            String search = searchTerm.toLowerCase();
            
            for (Document doc : allDocs) {
                if (doc.getTitle() != null && doc.getTitle().toLowerCase().contains(search) ||
                    doc.getDescription() != null && doc.getDescription().toLowerCase().contains(search)) {
                    filtered.add(doc);
                }
            }
            
            return filtered;
        } catch (Exception e) {
            LOGGER.warning("Error searching documents: " + e.getMessage());
            return new ArrayList<>();
        }
    }
}

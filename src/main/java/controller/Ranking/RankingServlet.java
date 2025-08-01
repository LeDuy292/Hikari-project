package controller.Ranking;

import dao.ranking.ResultDAO;
import dao.student.StudentDAO;
import model.ranking.StudentRanking;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Student;
import model.ranking.Result;

@WebServlet("/ranking")
public class RankingServlet extends HttpServlet {
    private ResultDAO resultDAO;
    
    @Override
    public void init() throws ServletException {
        resultDAO = new ResultDAO();
    }
    
    // Cập nhật method doGet để hỗ trợ phân trang
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Set encoding for Vietnamese characters
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        // Get current student ID from session
        HttpSession session = request.getSession();
        String userID = (String) session.getAttribute("userId");
        String currentStudentId = "";
        
        if (userID != null) {
            try {
                StudentDAO studentDAO = new StudentDAO();
                Student currentStudent = studentDAO.getStudentByUserId(userID);
                currentStudentId = (currentStudent != null) ? currentStudent.getStudentID() : "";
            } catch (Exception e) {
                System.err.println("Lỗi khi lấy thông tin học sinh: " + e.getMessage());
            }
        }
        request.setAttribute("currentStudentId", currentStudentId);
        
        // Get parameters
        String viewMode = request.getParameter("viewMode");
        String jlptLevel = request.getParameter("jlptLevel");
        String searchTerm = request.getParameter("searchTerm");
        String pageParam = request.getParameter("page");
        String pageSizeParam = request.getParameter("pageSize");
        
        // Set default values
        if (viewMode == null || viewMode.isEmpty()) {
            viewMode = "individual";
        }
        if (jlptLevel == null || jlptLevel.isEmpty() || jlptLevel.equals("all")) {
            jlptLevel = "Tất cả";
        }
        if (searchTerm == null) {
            searchTerm = "";
        }
        
        // Pagination parameters
        int page = 1;
        int pageSize = 10; // Mặc định 10 items per page
        
        try {
            if (pageParam != null && !pageParam.isEmpty()) {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            }
            if (pageSizeParam != null && !pageSizeParam.isEmpty()) {
                pageSize = Integer.parseInt(pageSizeParam);
                if (pageSize < 5) pageSize = 5;
                if (pageSize > 50) pageSize = 50; // Giới hạn tối đa
            }
        } catch (NumberFormatException e) {
            page = 1;
            pageSize = 10;
        }
        
        try {
            // Set available JLPT levels for dropdown
            String[] jlptLevels = {"Tất cả", "N5", "N4", "N3", "N2", "N1"};
            request.setAttribute("jlptLevels", jlptLevels);
            
            // Get total count and calculate pagination
            int totalItems = 0;
            String filterJlptLevel = "Tất cả".equals(jlptLevel) ? null : jlptLevel;
            
            if ("individual".equals(viewMode)) {
                totalItems = resultDAO.getTotalResultsCount(filterJlptLevel, searchTerm);
            } else {
                totalItems = resultDAO.getTotalStudentsCount(filterJlptLevel, searchTerm);
            }
            
            int totalPages = (int) Math.ceil((double) totalItems / pageSize);
            if (page > totalPages && totalPages > 0) {
                page = totalPages;
            }
            
            // Get data based on view mode with pagination
            if ("individual".equals(viewMode)) {
                List<Result> results = resultDAO.getFilteredResultsWithPagination(
                    filterJlptLevel, searchTerm, page, pageSize
                );
                
                request.setAttribute("individualResults", results);
                request.setAttribute("hasResults", results != null && !results.isEmpty());
            } else {
                List<StudentRanking> rankings = resultDAO.getAverageRankingsWithPagination(
                    filterJlptLevel, searchTerm, page, pageSize
                );
                request.setAttribute("averageRankings", rankings);
                request.setAttribute("hasResults", rankings != null && !rankings.isEmpty());
            }
            
            // Get statistics (for the full dataset, not paginated)
            ResultDAO.RankingStats stats = resultDAO.getRankingStats(
                filterJlptLevel, searchTerm, viewMode
            );
            
            // Set page title based on view mode
            String pageTitle = "individual".equals(viewMode) 
                ? "Bảng Xếp Hạng Theo Bài Kiểm Tra" 
                : "Bảng Xếp Hạng Trung Bình";
            
            // Set request attributes for JSP
            request.setAttribute("currentViewMode", viewMode);
            request.setAttribute("pageTitle", pageTitle);
            request.setAttribute("currentJlptLevel", jlptLevel);
            request.setAttribute("currentSearchTerm", searchTerm);
            request.setAttribute("stats", stats);
            
            // Pagination attributes
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalItems", totalItems);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("startItem", (page - 1) * pageSize + 1);
            request.setAttribute("endItem", Math.min(page * pageSize, totalItems));
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tải dữ liệu: " + e.getMessage());
            
            // Set empty stats in case of error
            ResultDAO.RankingStats emptyStats = new ResultDAO.RankingStats();
            request.setAttribute("stats", emptyStats);
            request.setAttribute("currentPage", 1);
            request.setAttribute("totalPages", 0);
            request.setAttribute("totalItems", 0);
        }
        
        // Forward to JSP
        request.getRequestDispatcher("/view/student/ranking.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}

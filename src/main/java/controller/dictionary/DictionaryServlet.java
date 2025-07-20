package controller.dictionary;

import com.google.gson.Gson;
import model.JishoEntry;
import model.SearchHistory;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import service.DictionaryService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Collections;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "DictionaryServlet", urlPatterns = {"/dictionary"})
public class DictionaryServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(DictionaryServlet.class.getName());
    private final Gson gson = new Gson();
    private final DictionaryService dictionaryService = new DictionaryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String userIdentifier = getUserIdentifier(request);
        List<JishoEntry.JishoData> results = Collections.emptyList();
        String errorMessage = null;

        // Kiểm tra và xử lý đầu vào
        if (keyword != null) {
            keyword = keyword.trim();
            if (keyword.isEmpty()) {
                errorMessage = "Vui lòng nhập từ khóa để tra cứu.";
            } else if (keyword.length() > 255) {
                errorMessage = "Từ khóa quá dài, vui lòng nhập tối đa 255 ký tự.";
            } else {
                try {
                    results = dictionaryService.searchDictionary(keyword, userIdentifier);
                    if (results.isEmpty()) {
                        errorMessage = "Không tìm thấy kết quả cho từ khóa: " + keyword;
                    }
                } catch (IllegalArgumentException e) {
                    errorMessage = e.getMessage();
                    LOGGER.log(Level.SEVERE, "Lỗi đầu vào khi tra cứu từ điển", e);
                } catch (IOException e) {
                    errorMessage = "Đã xảy ra lỗi khi kết nối đến Jisho API: " + e.getMessage();
                    LOGGER.log(Level.SEVERE, "Lỗi khi gọi Jisho API", e);
                }
            }
        }

        // Lấy lịch sử tìm kiếm
        try {
            List<SearchHistory> recentSearches = dictionaryService.getRecentSearchHistory(userIdentifier, 10);
            request.setAttribute("recentSearches", recentSearches);
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Lỗi khi lấy lịch sử tìm kiếm cho user: " + userIdentifier, e);
            request.setAttribute("recentSearches", Collections.emptyList());
        }

        // Chuẩn bị dữ liệu để hiển thị
        request.setAttribute("keyword", keyword);
        request.setAttribute("results", results);
        request.setAttribute("errorMessage", errorMessage);
        request.getRequestDispatcher("/view/student/dictionary.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    private String getUserIdentifier(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userID") != null) {
            return (String) session.getAttribute("userID");
        } else {
            String ipAddress = request.getHeader("X-Forwarded-For");
            if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)) {
                ipAddress = request.getRemoteAddr();
            }
            return ipAddress;
        }
    }
}
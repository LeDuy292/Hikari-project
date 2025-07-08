package controller.course;

import com.google.gson.Gson;
import dao.QuestionDAO;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.PrintWriter;
import model.Question;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

@MultipartConfig
public class UploadFileExcel extends HttpServlet {

    private final Gson gson = new Gson();
    private final QuestionDAO questionDAO = new QuestionDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        Part filePart = request.getPart("excelFile");
        List<Question> questionList = new ArrayList<>();
        final double totalMark = 100.0;

        try (InputStream inputStream = filePart.getInputStream(); XSSFWorkbook workbook = new XSSFWorkbook(inputStream)) {
            Sheet sheet = workbook.getSheetAt(0);
            int count = 0;

            Row header = sheet.getRow(0);
            if (!isValidHeader(header)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(gson.toJson(new ErrorResponse("error", "Định dạng file Excel không hợp lệ. Yêu cầu các cột: questionText, optionA, optionB, optionC, optionD, correctOption")));
                return;
            }

            for (Row row : sheet) {
                if (row.getRowNum() == 0) {
                    continue;
                }
                count++;
            }
            double mark = count > 0 ? totalMark / count : 0;

            for (Row row : sheet) {
                if (row.getRowNum() == 0) {
                    continue;
                }

                String questionText = getCellValue(row.getCell(0));
                String optionA = getCellValue(row.getCell(1));
                String optionB = getCellValue(row.getCell(2));
                String optionC = getCellValue(row.getCell(3));
                String optionD = getCellValue(row.getCell(4));
                String correctOption = getCellValue(row.getCell(5));

                if (questionText.isEmpty() || optionA.isEmpty() || optionB.isEmpty() || optionC.isEmpty() || optionD.isEmpty() || !isValidCorrectOption(correctOption)) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write(gson.toJson(new ErrorResponse("error", "Dữ liệu câu hỏi không hợp lệ ở hàng " + (row.getRowNum() + 1))));
                    return;
                }

                Question q = new Question(0, questionText, optionA, optionB, optionC, optionD, correctOption, mark, null, 0);
                questionList.add(q);
            }

            if (questionList.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(gson.toJson(new ErrorResponse("error", "File Excel không chứa câu hỏi nào")));
                return;
            }
            System.out.println("Uploaded questions: " + questionList);
            request.getSession().setAttribute("uploadedQuestions", questionList);
            response.getWriter().write(gson.toJson(questionList));

        } catch (IOException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(new ErrorResponse("error", "Lỗi khi đọc file Excel")));
            log("Lỗi đọc file Excel", e);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(new ErrorResponse("error", "Lỗi không xác định khi xử lý file Excel")));
            log("Lỗi không xác định", e);
        }
    }

    private boolean isValidHeader(Row header) {
        String[] expected = {"questionText", "optionA", "optionB", "optionC", "optionD", "correctOption"};
        for (int i = 0; i < expected.length; i++) {
            if (!getCellValue(header.getCell(i)).equalsIgnoreCase(expected[i])) {
                return false;
            }
        }
        return true;
    }

    private String getCellValue(Cell cell) {
        return cell != null ? cell.getStringCellValue().trim() : "";
    }

    private boolean isValidCorrectOption(String correctOption) {
        return correctOption != null && Arrays.asList("A", "B", "C", "D").contains(correctOption.toUpperCase());
    }

    private static class ErrorResponse {

        String status;
        String message;

        ErrorResponse(String status, String message) {
            this.status = status;
            this.message = message;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet UploadFileExcel</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UploadFileExcel at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    
    @Override
    public String getServletInfo() {
        return "Servlet để tải lên và xử lý file Excel chứa câu hỏi";
    }
}

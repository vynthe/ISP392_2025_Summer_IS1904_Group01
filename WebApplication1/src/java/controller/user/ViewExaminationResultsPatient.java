package controller.user;

import model.service.ExaminationResultsService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Users;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

/**
 * Controller để xử lý việc xem kết quả khám của bệnh nhân
 */
@WebServlet("/ViewExaminationResultsPatient")
public class ViewExaminationResultsPatient extends HttpServlet {
    
    private final ExaminationResultsService examinationResultsService;
    
    public ViewExaminationResultsPatient() {
        this.examinationResultsService = new ExaminationResultsService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get the session without creating a new one
        HttpSession session = request.getSession(false);

        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            request.setAttribute("error", "Bạn cần đăng nhập để truy cập trang này.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Get user from session and verify role is Patient
        Users user = (Users) session.getAttribute("user");
        System.out.println("Session user: UserID=" + user.getUserID() + ", Role=" + user.getRole());
        if (!"Patient".equalsIgnoreCase(user.getRole())) {
            request.setAttribute("error", "Chỉ bệnh nhân mới có quyền truy cập vào trang này.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }
        
        // Use UserID from session as patientId
        int patientId = user.getUserID();
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        
        try {
            switch (action) {
                case "list":
                    handleListResults(request, response, patientId);
                    break;
                case "detail":
                    handleResultDetail(request, response, patientId);
                    break;
                default:
                    handleListResults(request, response, patientId);
                    break;
            }
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi truy xuất dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Xử lý hiển thị danh sách kết quả khám của bệnh nhân
     */
    private void handleListResults(HttpServletRequest request, HttpServletResponse response, int patientId) 
            throws ServletException, IOException, SQLException {
        
        // Xử lý phân trang
        int page = 1;
        int pageSize = 10;
        
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        String pageSizeParam = request.getParameter("pageSize");
        if (pageSizeParam != null && !pageSizeParam.isEmpty()) {
            try {
                pageSize = Integer.parseInt(pageSizeParam);
                if (pageSize < 1) pageSize = 10;
                if (pageSize > 50) pageSize = 50; // Giới hạn tối đa
            } catch (NumberFormatException e) {
                pageSize = 10;
            }
        }
        
        // Lấy danh sách kết quả khám
        List<Map<String, Object>> examinationResults = 
            examinationResultsService.getExaminationResultsByPatientId(patientId, page, pageSize);
        
        // Lấy tổng số bản ghi để tính pagination
        int totalResults = examinationResultsService.getTotalExaminationResultsByPatientId(patientId);
        int totalPages = (int) Math.ceil((double) totalResults / pageSize);
        
        // Set attributes cho JSP
        request.setAttribute("examinationResults", examinationResults);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalResults", totalResults);
        request.setAttribute("totalPages", totalPages);
        
        // Tính toán thông tin phân trang
        int startPage = Math.max(1, page - 2);
        int endPage = Math.min(totalPages, page + 2);
        request.setAttribute("startPage", startPage);
        request.setAttribute("endPage", endPage);
        
        // Forward đến JSP
        request.getRequestDispatcher("/views/user/Patient/ViewExaminationResultsPatient.jsp")
               .forward(request, response);
    }
    
    /**
     * Xử lý hiển thị chi tiết kết quả khám
     */
    private void handleResultDetail(HttpServletRequest request, HttpServletResponse response, int patientId) 
            throws ServletException, IOException, SQLException {
        
        String resultIdParam = request.getParameter("resultId");
        if (resultIdParam == null || resultIdParam.isEmpty()) {
            request.setAttribute("errorMessage", "Không tìm thấy ID kết quả khám");
            handleListResults(request, response, patientId);
            return;
        }
        
        try {
            int resultId = Integer.parseInt(resultIdParam);
            
            // Lấy chi tiết kết quả khám (đảm bảo chỉ bệnh nhân này mới xem được)
            Map<String, Object> resultDetail = 
                examinationResultsService.getExaminationResultDetailForPatient(resultId, patientId);
            
            request.setAttribute("resultDetail", resultDetail);
            request.getRequestDispatcher("/views/user/Patient/ViewExaminationResultsPatient.jsp")
                   .forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "ID kết quả khám không hợp lệ");
            handleListResults(request, response, patientId);
        } catch (SQLException e) {
            if (e.getMessage().contains("No examination result found")) {
                request.setAttribute("errorMessage", "Không tìm thấy kết quả khám hoặc bạn không có quyền xem");
            } else {
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi truy xuất dữ liệu: " + e.getMessage());
            }
            handleListResults(request, response, patientId);
        }
    }
}
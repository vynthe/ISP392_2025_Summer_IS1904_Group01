package controller.user;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.service.ExaminationResultsService;

@WebServlet(name = "ViewExaminationResultsPatient", urlPatterns = {"/ViewExaminationResultsPatient"})
public class ViewExaminationResultsPatient extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ExaminationResultsService examinationResultsService;
    private static final int DEFAULT_PAGE_SIZE = 10;

    @Override
    public void init() throws ServletException {
        super.init();
        examinationResultsService = new ExaminationResultsService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer patientId = (Integer) session.getAttribute("userId");
        String userRole = (String) session.getAttribute("userRole");
        
        // Kiểm tra đăng nhập và quyền truy cập
        if (patientId == null || !"patient".equalsIgnoreCase(userRole)) {
            response.sendRedirect("/views/user/Patient/ViewExaminationResultsPatient.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    handleListExaminationResults(request, response, patientId);
                    break;
                case "detail":
                    handleViewDetail(request, response, patientId);
                    break;
                default:
                    handleListExaminationResults(request, response, patientId);
                    break;
            }
        } catch (SQLException e) {
            System.err.println("Database error in ViewExaminationResultsPatient: " + e.getMessage());
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi truy xuất dữ liệu. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Unexpected error in ViewExaminationResultsPatient: " + e.getMessage());
            request.setAttribute("errorMessage", "Có lỗi không mong muốn xảy ra. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
        }
    }

    /**
     * Xử lý hiển thị danh sách kết quả khám bệnh
     */
    private void handleListExaminationResults(HttpServletRequest request, HttpServletResponse response, int patientId)
            throws ServletException, IOException, SQLException {
        
        // Lấy thông số phân trang
        int page = 1;
        int pageSize = DEFAULT_PAGE_SIZE;
        
        String pageParam = request.getParameter("page");
        String pageSizeParam = request.getParameter("pageSize");
        
        try {
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            }
            if (pageSizeParam != null && !pageSizeParam.trim().isEmpty()) {
                pageSize = Integer.parseInt(pageSizeParam);
                if (pageSize < 1) pageSize = DEFAULT_PAGE_SIZE;
                if (pageSize > 50) pageSize = 50; // Giới hạn tối đa
            }
        } catch (NumberFormatException e) {
            System.err.println("Invalid page parameters: " + e.getMessage());
            page = 1;
            pageSize = DEFAULT_PAGE_SIZE;
        }

        // Lấy dữ liệu từ service
        List<Map<String, Object>> examinationResults = 
            examinationResultsService.getExaminationResultsByPatientId(patientId, page, pageSize);
        int totalRecords = examinationResultsService.getTotalExaminationResultsByPatientId(patientId);
        
        // Tính toán thông tin phân trang
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        
        // Set attributes cho JSP
        request.setAttribute("examinationResults", examinationResults);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        
        // Thông tin bổ sung cho phân trang
        request.setAttribute("hasNextPage", page < totalPages);
        request.setAttribute("hasPreviousPage", page > 1);
        request.setAttribute("nextPage", page + 1);
        request.setAttribute("previousPage", page - 1);
        
        // Forward đến JSP danh sách
        request.getRequestDispatcher("/views/user/Patient/ViewExaminationResultsPatient.jsp").forward(request, response);
    }

    /**
     * Xử lý hiển thị chi tiết kết quả khám bệnh
     */
    private void handleViewDetail(HttpServletRequest request, HttpServletResponse response, int patientId)
            throws ServletException, IOException, SQLException {
        
        String resultIdParam = request.getParameter("resultId");
        
        if (resultIdParam == null || resultIdParam.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Không tìm thấy ID kết quả khám bệnh.");
            request.getRequestDispatcher("/views/user/Patient/ViewExaminationResultsPatient.jsp").forward(request, response);
            return;
        }
        
        try {
            int resultId = Integer.parseInt(resultIdParam);
            
            // Lấy chi tiết kết quả khám bệnh
            Map<String, Object> resultDetail = 
                examinationResultsService.getExaminationResultDetailForPatient(resultId, patientId);
            
            if (resultDetail == null || resultDetail.isEmpty()) {
                request.setAttribute("errorMessage", "Không tìm thấy kết quả khám bệnh hoặc bạn không có quyền truy cập.");
                request.getRequestDispatcher("/views/user/Patient/ViewExaminationResultsPatient.jsp").forward(request, response);
                return;
            }
            
            // Set attribute và forward đến JSP chi tiết
            request.setAttribute("resultDetail", resultDetail);
            request.getRequestDispatcher("/views/user/Patient/ViewExaminationResultsPatient.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            System.err.println("Invalid result ID format: " + resultIdParam);
            request.setAttribute("errorMessage", "ID kết quả khám bệnh không hợp lệ.");
            request.getRequestDispatcher("/views/user/Patient/ViewExaminationResultsPatient.jsp").forward(request, response);
        } catch (SQLException e) {
            if (e.getMessage().contains("No examination result found")) {
                request.setAttribute("errorMessage", "Không tìm thấy kết quả khám bệnh hoặc bạn không có quyền truy cập.");
                request.getRequestDispatcher("/views/user/Patient/ViewExaminationResultsPatient.jsp").forward(request, response);
            } else {
                throw e; // Re-throw để xử lý ở level cao hơn
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng POST requests sang GET
        doGet(request, response);
    }
}
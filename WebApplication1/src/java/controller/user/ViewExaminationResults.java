package controller.user;

import model.service.ExaminationResultsService;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Users;

/**
 * Servlet to handle viewing examination results for a doctor.
 */
@WebServlet(name = "ViewExaminationResults", urlPatterns = {"/ViewExaminationResults"})
public class ViewExaminationResults extends HttpServlet {

    private final ExaminationResultsService examinationResultsService;

    public ViewExaminationResults() {
        this.examinationResultsService = new ExaminationResultsService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get the session without creating a new one
        HttpSession session = request.getSession(false);

        // Check if user is logged in and is a Doctor
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;
        if (user == null || !"doctor".equalsIgnoreCase(user.getRole())) {
            request.setAttribute("error", "You must be logged in as a doctor to access this page.");
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            return;
        }

        try {
            // Lấy tham số doctorId, page, pageSize từ request
            int doctorId;
            try {
                doctorId = Integer.parseInt(request.getParameter("doctorId"));
                // Kiểm tra doctorId phải là số dương
                if (doctorId <= 0) {
                    throw new IllegalArgumentException("Doctor ID must be positive");
                }
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("Doctor ID must be a valid number");
            }

            int page = 1;
            int pageSize = 10;
            try {
                String pageParam = request.getParameter("page");
                if (pageParam != null && !pageParam.isEmpty()) {
                    page = Integer.parseInt(pageParam);
                }
                String pageSizeParam = request.getParameter("pageSize");
                if (pageSizeParam != null && !pageSizeParam.isEmpty()) {
                    pageSize = Integer.parseInt(pageSizeParam);
                }
                // Đảm bảo page và pageSize là số dương
                if (page < 1) page = 1;
                if (pageSize < 1) pageSize = 10;
            } catch (NumberFormatException e) {
                // Giữ giá trị mặc định nếu tham số không hợp lệ
            }

            // Gọi service để lấy danh sách lịch hẹn
            List<Map<String, Object>> appointments = examinationResultsService.getAppointmentsWithPatientByDoctorId(doctorId, page, pageSize);

            // Đặt dữ liệu vào request để chuyển sang JSP
            request.setAttribute("appointments", appointments);
            request.setAttribute("doctorId", doctorId);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);

            // Chuyển hướng đến JSP để hiển thị
            request.getRequestDispatcher("/views/user/DoctorNurse/ViewExaminationResults.jsp").forward(request, response);

        } catch (IllegalArgumentException e) {
            // Xử lý lỗi tham số không hợp lệ (bao gồm doctorId không hợp lệ)
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/views/user/DoctorNurse/ViewExaminationResults.jsp").forward(request, response);
        } catch (SQLException e) {
            // Ghi log lỗi và chuyển hướng đến trang lỗi
            System.err.println("SQLException in ViewExaminationResults at " + LocalDateTime.now() + " +07: " + e.getMessage());
            request.setAttribute("errorMessage", "Error retrieving examination results: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
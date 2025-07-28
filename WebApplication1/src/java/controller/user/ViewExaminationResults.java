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
import model.dao.ExaminationResultsDAO;
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

        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            request.setAttribute("error", "Bạn cần đăng nhập để truy cập trang này.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Get user from session and verify role is Doctor
        Users user = (Users) session.getAttribute("user");
        System.out.println("Session user: UserID=" + user.getUserID() + ", Role=" + user.getRole());
        if (!"Doctor".equalsIgnoreCase(user.getRole())) {
            request.setAttribute("error", "Chỉ bác sĩ mới có quyền truy cập vào trang này.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        try {
            // Use UserID from session as doctorId
            int doctorId = user.getUserID();

            // Check if this is a request for diagnosis details
            String action = request.getParameter("action");
            String appointmentIdParam = request.getParameter("appointmentId");
            
            if ("getDetails".equals(action) && appointmentIdParam != null) {
                try {
                    int appointmentId = Integer.parseInt(appointmentIdParam);
                    Map<String, Object> diagnosisDetails = examinationResultsService.getDiagnosisDetailsByAppointmentId(appointmentId);
                    
                    // Set diagnosis details for AJAX response or detailed view
                    request.setAttribute("diagnosisDetails", diagnosisDetails);
                    request.setAttribute("showDetails", true);
                    request.setAttribute("selectedAppointmentId", appointmentId);
                } catch (NumberFormatException e) {
                    System.err.println("Invalid appointmentId parameter: " + appointmentIdParam);
                }
            }

            // Get page and pageSize parameters
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
                // Ensure page and pageSize are positive
                if (page < 1) page = 1;
                if (pageSize < 1) pageSize = 10;
            } catch (NumberFormatException e) {
                // Keep default values if parameters are invalid
                System.err.println("Invalid page or pageSize parameters at " + LocalDateTime.now() + " +07: " + e.getMessage());
            }

            // Check if diagnosis was just added
            String addedDiagnosis = request.getParameter("addedDiagnosis");
            if (addedDiagnosis != null && !addedDiagnosis.isEmpty()) {
                request.setAttribute("addedDiagnosis", addedDiagnosis);
                request.setAttribute("successMessage", "Đã thêm kết quả thành công!");
            }

            // Get appointments and total count
            List<Map<String, Object>> appointments = examinationResultsService.getAppointmentsWithPatientByDoctorId(doctorId, page, pageSize);
            int totalAppointments = examinationResultsService.getTotalAppointmentsByDoctorId(doctorId);
            int totalPages = (int) Math.ceil((double) totalAppointments / pageSize);

            // Debug information
            System.out.println("Debug - DoctorId: " + doctorId + ", Total appointments: " + totalAppointments + ", Current page: " + page);
            for (Map<String, Object> appointment : appointments) {
                System.out.println("Debug - Appointment: " + appointment);
            }

            // Set data to request for JSP
            request.setAttribute("appointments", appointments);
            request.setAttribute("doctorId", doctorId);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalAppointments", totalAppointments);

            request.setAttribute("examinationResultDAO", new ExaminationResultsDAO());


            // Forward to JSP for display
            request.getRequestDispatcher("views/user/DoctorNurse/ViewExaminationResults.jsp").forward(request, response);

        } catch (SQLException e) {
            // Log and handle database errors
            System.err.println("SQLException in ViewExaminationResults for doctorId " + user.getUserID() + " at " + LocalDateTime.now() + " +07: " + e.getMessage() + ", SQLState: " + e.getSQLState());
            e.printStackTrace(); // Print full stack trace for debugging
            request.setAttribute("errorMessage", "Lỗi khi lấy dữ liệu lịch hẹn: " + e.getMessage());
            request.getRequestDispatcher("views/user/DoctorNurse/ViewExaminationResults.jsp").forward(request, response);
        } catch (Exception e) {
            // Handle any other unexpected errors
            System.err.println("Unexpected error in ViewExaminationResults at " + LocalDateTime.now() + " +07: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi không mong muốn: " + e.getMessage());
            request.getRequestDispatcher("views/user/DoctorNurse/ViewExaminationResults.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle POST requests (if needed for adding diagnosis)
        doGet(request, response);
    }
}
package controller.user;

import model.service.ExaminationResultsService;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Users;
import java.util.Arrays;
import java.util.List;

/**
 * Servlet to handle adding examination results for a doctor.
 */
@WebServlet(name = "AddExaminationResultServlet", urlPatterns = {"/AddExaminationResultServlet"})
public class AddExaminationResultServlet extends HttpServlet {

    private final ExaminationResultsService examinationResultsService;

    public AddExaminationResultServlet() {
        this.examinationResultsService = new ExaminationResultsService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            request.setAttribute("error", "Bạn cần đăng nhập để truy cập trang này.");
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            return;
        }

        Users user = (Users) session.getAttribute("user");
        System.out.println("Session user: UserID=" + user.getUserID() + ", Role=" + user.getRole() + " at " + LocalDateTime.now() + " +07");
        if (!"Doctor".equalsIgnoreCase(user.getRole())) {
            request.setAttribute("error", "Chỉ bác sĩ mới có quyền truy cập vào trang này.");
            request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
            return;
        }

        // Lấy appointmentId từ request
        String appointmentIdParam = request.getParameter("appointmentId");
        if (appointmentIdParam != null && !appointmentIdParam.trim().isEmpty()) {
            request.setAttribute("appointmentId", appointmentIdParam.trim());
        }
        request.getRequestDispatcher("/views/user/DoctorNurse/AddExaminationResult.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/views/common/login.jsp?error=You must be logged in.");
            return;
        }

        Users user = (Users) session.getAttribute("user");
        if (!"Doctor".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/common/error.jsp?error=Only doctors can access this page.");
            return;
        }

        try {
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            Integer nurseId = request.getParameter("nurseId") != null && !request.getParameter("nurseId").trim().isEmpty() 
                    ? Integer.parseInt(request.getParameter("nurseId")) : null;
            String status = request.getParameter("status") != null ? request.getParameter("status").trim() : "Pending";
            String diagnosis = request.getParameter("diagnosis"); // Chuẩn đoán
            String notes = request.getParameter("notes"); // Ghi chú

            if (appointmentId <= 0) {
                throw new IllegalArgumentException("Appointment ID must be a positive integer.");
            }
            if (status == null || status.trim().isEmpty()) {
                throw new IllegalArgumentException("Status is required.");
            }
            List<String> validStatuses = Arrays.asList("Pending", "Draft", "Completed", "Reviewed", "Cancelled");
            if (!validStatuses.contains(status)) {
                throw new IllegalArgumentException("Invalid status. Allowed values are: " + String.join(", ", validStatuses) + ".");
            }

            boolean resultAdded = examinationResultsService.addExaminationResultFromAppointment(appointmentId, nurseId, status, diagnosis, notes);
            if (resultAdded) {
                request.getSession().setAttribute("successMessage", "Kết quả khám đã được thêm thành công.");
                System.out.println("Examination result added successfully for appointmentId " + appointmentId + " at " + LocalDateTime.now() + " +07 by DoctorID " + user.getUserID());
                // Chuyển hướng về ViewExaminationResults với appointmentId
                response.sendRedirect(request.getContextPath() + "/ViewExaminationResults?appointmentId=" + appointmentId);
                return;
            } else {
                request.getSession().setAttribute("errorMessage", "Thêm kết quả khám thất bại.");
                System.out.println("Failed to add examination result for appointmentId " + appointmentId + " at " + LocalDateTime.now() + " +07 by DoctorID " + user.getUserID());
            }

            response.sendRedirect(request.getContextPath() + "/ViewExaminationResults");

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Tạo thất bại: Vui lòng nhập số hợp lệ cho các trường ID.");
            System.err.println("NumberFormatException in AddExaminationResultServlet at " + LocalDateTime.now() + " +07: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ViewExaminationResults");
        } catch (IllegalArgumentException e) {
            request.getSession().setAttribute("errorMessage", "Tạo thất bại: " + e.getMessage());
            System.err.println("IllegalArgumentException in AddExaminationResultServlet at " + LocalDateTime.now() + " +07: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ViewExaminationResults");
        } catch (SQLException e) {
            request.getSession().setAttribute("errorMessage", "Tạo thất bại: Lỗi cơ sở dữ liệu - " + e.getMessage());
            System.err.println("SQLException in AddExaminationResultServlet at " + LocalDateTime.now() + " +07: " + e.getMessage() + ", SQLState: " + e.getSQLState());
            response.sendRedirect(request.getContextPath() + "/ViewExaminationResults");
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Tạo thất bại: Lỗi hệ thống - " + e.getMessage());
            System.err.println("Unexpected error in AddExaminationResultServlet at " + LocalDateTime.now() + " +07: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ViewExaminationResults");
        }
    }
}
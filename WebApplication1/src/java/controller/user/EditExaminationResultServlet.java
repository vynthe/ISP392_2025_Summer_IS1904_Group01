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
import java.util.Map;
import model.entity.Users;

/**
 * Servlet to handle editing examination results for a doctor using appointmentId.
 */
@WebServlet(name = "EditExaminationResultServlet", urlPatterns = {"/EditExaminationResultServlet"})
public class EditExaminationResultServlet extends HttpServlet {

    private final ExaminationResultsService examinationResultsService;

    public EditExaminationResultServlet() {
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
        if (!"Doctor".equalsIgnoreCase(user.getRole())) {
            request.setAttribute("error", "Chỉ bác sĩ mới có quyền truy cập vào trang này.");
            request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
            return;
        }

        String appointmentIdParam = request.getParameter("appointmentId");
        
        if (appointmentIdParam == null || appointmentIdParam.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Thiếu thông tin Appointment ID.");
            response.sendRedirect(request.getContextPath() + "/ViewExaminationResults");
            return;
        }

        try {
            int appointmentId = Integer.parseInt(appointmentIdParam.trim());
            Map<String, Object> resultDetails = examinationResultsService.getDiagnosisDetailsByAppointmentId(appointmentId);
            
            if (resultDetails == null || resultDetails.isEmpty()) {
                request.getSession().setAttribute("errorMessage", "Không tìm thấy kết quả khám với Appointment ID: " + appointmentId);
                response.sendRedirect(request.getContextPath() + "/ViewExaminationResults");
                return;
            }
            
            request.setAttribute("resultDetails", resultDetails);
            request.getRequestDispatcher("/views/user/DoctorNurse/EditExaminationResult.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Appointment ID không hợp lệ: '" + appointmentIdParam + "'.");
            response.sendRedirect(request.getContextPath() + "/ViewExaminationResults");
        } catch (SQLException e) {
            request.getSession().setAttribute("errorMessage", "Lỗi khi lấy thông tin kết quả khám: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ViewExaminationResults");
        }
    }

   @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
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

    String appointmentIdParam = request.getParameter("appointmentId");
    
    if (appointmentIdParam == null || appointmentIdParam.trim().isEmpty()) {
        request.getSession().setAttribute("errorMessage", "Thiếu thông tin Appointment ID.");
        response.sendRedirect(request.getContextPath() + "/ViewExaminationResults");
        return;
    }

    try {
        int appointmentId = Integer.parseInt(appointmentIdParam.trim());
        Integer resultId = examinationResultsService.getResultIdByAppointmentId(appointmentId);

        if (resultId == null) {
            request.getSession().setAttribute("errorMessage", "Không tìm thấy ResultID để cập nhật.");
            response.sendRedirect(request.getContextPath() + "/ViewExaminationResults");
            return;
        }

        // Chỉ lấy notes để cập nhật, giữ nguyên diagnosis
        String notes = request.getParameter("notes");

        // FIXED: Chỉ truyền 3 parameters: resultId, diagnosis=null, notes
        boolean updated = examinationResultsService.updateExaminationResult(resultId, null, notes);
        
        if (updated) {
            request.getSession().setAttribute("successMessage", "Ghi chú đã được cập nhật thành công.");
        } else {
            request.getSession().setAttribute("errorMessage", "Cập nhật ghi chú thất bại.");
        }

        response.sendRedirect(request.getContextPath() + "/ViewExaminationResults?appointmentId=" + appointmentId);
        
    } catch (NumberFormatException e) {
        request.getSession().setAttribute("errorMessage", "Appointment ID không hợp lệ - " + appointmentIdParam);
        response.sendRedirect(request.getContextPath() + "/ViewExaminationResults");
    } catch (IllegalArgumentException e) {
        request.getSession().setAttribute("errorMessage", "Cập nhật thất bại: " + e.getMessage());
        response.sendRedirect(request.getContextPath() + "/ViewExaminationResults");
    } catch (SQLException e) {
        request.getSession().setAttribute("errorMessage", "Cập nhật thất bại: Lỗi cơ sở dữ liệu - " + e.getMessage());
        response.sendRedirect(request.getContextPath() + "/ViewExaminationResults");
    }
}
}
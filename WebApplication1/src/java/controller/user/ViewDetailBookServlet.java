package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.service.AppointmentService;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;

@WebServlet(name = "ViewDetailBookServlet", urlPatterns = {"/ViewDetailBookServlet"})
public class ViewDetailBookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AppointmentService appointmentService;

    @Override
    public void init() throws ServletException {
        appointmentService = new AppointmentService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html; charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String doctorIdParam = request.getParameter("doctorId");
        String appointmentDate = request.getParameter("appointmentDate");

        try {
            // Validate doctorId parameter
            if (doctorIdParam == null || doctorIdParam.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng cung cấp ID bác sĩ hợp lệ");
                request.getRequestDispatcher("/views/error.jsp").forward(request, response);
                return;
            }

            int doctorId;
            try {
                doctorId = Integer.parseInt(doctorIdParam.trim());
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID bác sĩ không hợp lệ");
                request.getRequestDispatcher("/views/error.jsp").forward(request, response);
                return;
            }

            // Fetch doctor details
            Map<String, Object> details = appointmentService.viewDetailBook(doctorId);
            if (details == null || details.isEmpty()) {
                request.setAttribute("error", "Không tìm thấy thông tin bác sĩ");
                request.getRequestDispatcher("/views/error.jsp").forward(request, response);
                return;
            }

            // Set attributes for JSP
            request.setAttribute("doctorDetails", details);
            if (appointmentDate != null && !appointmentDate.trim().isEmpty()) {
                request.setAttribute("appointmentDate", appointmentDate.trim());
            }

            request.getRequestDispatcher("/views/user/Patient/ViewDetailBook.jsp").forward(request, response);

        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi không xác định: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html; charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String doctorId = request.getParameter("doctorId");
        String appointmentDate = request.getParameter("appointmentDate");

        // Build redirect URL
        StringBuilder redirectUrl = new StringBuilder(request.getContextPath() + "/ViewDetailBookServlet");
        if (doctorId != null && !doctorId.trim().isEmpty()) {
            redirectUrl.append("?doctorId=").append(doctorId.trim());
            if (appointmentDate != null && !appointmentDate.trim().isEmpty()) {
                redirectUrl.append("&appointmentDate=").append(appointmentDate.trim());
            }
        }

        response.sendRedirect(redirectUrl.toString());
    }
}
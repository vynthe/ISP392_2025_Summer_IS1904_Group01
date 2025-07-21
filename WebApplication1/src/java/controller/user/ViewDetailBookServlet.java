package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.service.AppointmentService;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
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

        HttpSession session = request.getSession(false);
        // Kiểm tra quyền truy cập (giả sử người dùng phải đăng nhập với vai trò Patient)
        if (session == null || session.getAttribute("user") == null) {
            request.setAttribute("error", "Vui lòng đăng nhập để xem chi tiết bác sĩ");
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            return;
        }

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
                if (doctorId <= 0) {
                    throw new NumberFormatException("Doctor ID must be positive");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID bác sĩ không hợp lệ: " + doctorIdParam);
                request.getRequestDispatcher("/views/error.jsp").forward(request, response);
                return;
            }

            // Validate appointmentDate if provided
            LocalDate parsedDate = null;
            if (appointmentDate != null && !appointmentDate.trim().isEmpty()) {
                try {
                    parsedDate = LocalDate.parse(appointmentDate.trim(), DateTimeFormatter.ISO_LOCAL_DATE);
                    request.setAttribute("appointmentDate", parsedDate);
                } catch (DateTimeParseException e) {
                    request.setAttribute("error", "Ngày hẹn không hợp lệ: " + appointmentDate);
                    request.getRequestDispatcher("/views/error.jsp").forward(request, response);
                    return;
                }
            }

            // Fetch doctor details
            Map<String, Object> details = appointmentService.viewDetailBook(doctorId);
            if (details == null || details.isEmpty()) {
                request.setAttribute("error", "Không tìm thấy thông tin bác sĩ với ID: " + doctorId);
                request.getRequestDispatcher("/views/error.jsp").forward(request, response);
                return;
            }

            // Set attributes for JSP
            request.setAttribute("doctorDetails", details);
            request.getRequestDispatcher("/views/user/Patient/ViewDetailBook.jsp").forward(request, response);

        } catch (SQLException e) {
            // Log the error for debugging (consider using a logging framework like SLF4J)
            System.err.println("SQLException in ViewDetailBookServlet at " + java.time.LocalDateTime.now() + " +07: " + e.getMessage());
            request.setAttribute("error", "Lỗi hệ thống: Không thể tải thông tin bác sĩ. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Unexpected error in ViewDetailBookServlet at " + java.time.LocalDateTime.now() + " +07: " + e.getMessage());
            request.setAttribute("error", "Lỗi không xác định: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect to doGet to handle parameters consistently
        doGet(request, response);
    }
}
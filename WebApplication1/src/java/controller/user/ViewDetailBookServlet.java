package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Users;
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

        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/views/common/login.jsp");
            return;
        }

        String doctorIdParam = request.getParameter("doctorId");
        String appointmentDate = request.getParameter("appointmentDate");
        String dayOfWeek = request.getParameter("dayOfWeek");
        String shiftStart = request.getParameter("shiftStart");
        String shiftEnd = request.getParameter("shiftEnd");

        try {
            // Validate doctorId parameter
            if (doctorIdParam == null || doctorIdParam.trim().isEmpty()) {
                session.setAttribute("statusMessage", "Lỗi: Vui lòng cung cấp ID bác sĩ hợp lệ");
                response.sendRedirect(request.getContextPath() + "/BookMedicalAppointmentServlet");
                return;
            }

            int doctorId;
            try {
                doctorId = Integer.parseInt(doctorIdParam.trim());
            } catch (NumberFormatException e) {
                session.setAttribute("statusMessage", "Lỗi: ID bác sĩ không hợp lệ");
                response.sendRedirect(request.getContextPath() + "/BookMedicalAppointmentServlet");
                return;
            }

            // Get logged-in user
            Users user = (Users) session.getAttribute("user");
            if (user == null) {
                session.setAttribute("statusMessage", "Lỗi: Vui lòng đăng nhập để đặt lịch");
                response.sendRedirect(request.getContextPath() + "/views/common/login.jsp");
                return;
            }

            // Book appointment (assuming AppointmentService has a method to handle this)
            boolean booked = appointmentService.bookAppointment(doctorId, user.getUserID(), appointmentDate, dayOfWeek, shiftStart, shiftEnd);
            if (booked) {
                session.setAttribute("statusMessage", "Đặt lịch thành công");
            } else {
                session.setAttribute("statusMessage", "Lỗi: Không thể đặt lịch, vui lòng thử lại");
            }

            // Redirect to BookMedicalAppointmentServlet to display the message
            response.sendRedirect(request.getContextPath() + "/BookMedicalAppointmentServlet");

        } catch (SQLException e) {
            session.setAttribute("statusMessage", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/BookMedicalAppointmentServlet");
        } catch (Exception e) {
            session.setAttribute("statusMessage", "Lỗi hệ thống: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/BookMedicalAppointmentServlet");
        }
    }
}
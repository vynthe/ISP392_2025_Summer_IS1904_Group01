package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import model.service.AppointmentGuestService;
import model.entity.AppointmentGuest;

@WebServlet(name = "BookMedicalGuestServlet", urlPatterns = {"/BookMedicalGuestServlet"})
public class BookAppointmentGuestServlet extends HttpServlet {

    private final AppointmentGuestService appointmentService = new AppointmentGuestService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy dữ liệu từ form
        String fullName = request.getParameter("fullName");
        String phoneNumber = request.getParameter("phoneNumber");
        String email = request.getParameter("email");
        String service = request.getParameter("serviceType");

        // Tạo đối tượng AppointmentGuest
        AppointmentGuest appointment = new AppointmentGuest(fullName, phoneNumber, email, service);
        HttpSession session = request.getSession();

        try {
            // Gọi phương thức bookAppointment từ service
            appointmentService.bookAppointment(appointment);
            session.setAttribute("successMessage", "Đặt lịch hẹn thành công!");
            response.sendRedirect(request.getContextPath() + "/views/common/HomePage.jsp");
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            request.getRequestDispatcher("/views/user/Patient/BookMedical.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/views/user/Patient/BookMedical.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng đến trang đặt lịch khi nhận yêu cầu GET
        request.getRequestDispatcher("/views/user/Patient/BookMedical.jsp").forward(request, response);
    }
}
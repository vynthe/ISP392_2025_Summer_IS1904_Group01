package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import model.entity.AppointmentGuest;
import model.entity.Notification;
import model.service.AppointmentGuestService;
import model.service.NotificationService;

@WebServlet(name = "BookMedicalGuestServlet", urlPatterns = {"/BookMedicalGuestServlet"})
public class BookAppointmentGuestServlet extends HttpServlet {

    private final AppointmentGuestService appointmentService = new AppointmentGuestService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String fullName = request.getParameter("fullName");
        String phoneNumber = request.getParameter("phoneNumber");
        String email = request.getParameter("email");
        String service = request.getParameter("serviceType");

        AppointmentGuest appointment = new AppointmentGuest(fullName, phoneNumber, email, service);
        HttpSession session = request.getSession();

        try {
            // Đặt lịch và đảm bảo ID được gán
            appointmentService.bookAppointment(appointment);
            if (appointment.getId() == 0) {
                throw new SQLException("ID lịch hẹn không được gán sau khi đặt lịch.");
            }

            // Gửi thông báo cho Admin
            String message = "Khách " + fullName + " đã đặt lịch khám dịch vụ: " + service + ". ID: " + appointment.getId();
            Notification notification = new Notification(
                0,         // senderID: khách chưa đăng ký
                "Patient", // vai trò người gửi
                1,         // receiverID: admin
                "Admin",   // vai trò người nhận
                "Lịch khám mới từ khách", // tiêu đề
                message    // nội dung chứa ID để xử lý duyệt
            );
            NotificationService notificationService = new NotificationService();
            notificationService.createNotification(notification);


            // Hiển thị thông báo thành công cho khách
            session.setAttribute("successMessage", "Vui lòng chờ xác nhận đặt lịch!");
            response.sendRedirect(request.getContextPath() + "/views/common/HomePage.jsp");

        } catch (SQLException e) {
            session.setAttribute("error", "Lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/views/user/Patient/BookMedical.jsp");
        } catch (Exception e) {
            session.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/views/user/Patient/BookMedical.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/user/Patient/BookMedical.jsp").forward(request, response);
    }
}
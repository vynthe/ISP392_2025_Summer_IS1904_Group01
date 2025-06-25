
package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.AppointmentGuest;
import model.entity.Notification;
import model.service.AppointmentGuestService;
import model.service.NotificationService;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.dao.DBContext;

@WebServlet(name = "BookMedicalGuestServlet", urlPatterns = {"/BookMedicalGuestServlet"})
public class BookAppointmentGuestServlet extends HttpServlet {

    private final AppointmentGuestService appointmentService = new AppointmentGuestService();
    private final NotificationService notificationService = new NotificationService();

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

        // Retain form values in case of error
        request.setAttribute("fullName", fullName);
        request.setAttribute("phoneNumber", phoneNumber);
        request.setAttribute("email", email);
        request.setAttribute("serviceType", service);

        AppointmentGuest appointment = new AppointmentGuest(fullName, phoneNumber, email, service);
        HttpSession session = request.getSession();

        try {
            // Validate inputs
            if (fullName == null || fullName.trim().isEmpty() || !fullName.matches("^[\\p{L}\\s]+$")) {
                throw new IllegalArgumentException("Họ và tên không hợp lệ hoặc để trống.");
            }
            if (phoneNumber == null || !phoneNumber.matches("\\d{10,11}")) {
                throw new IllegalArgumentException("Số điện thoại phải có 10-11 chữ số.");
            }
            if (service == null || service.trim().isEmpty()) {
                throw new IllegalArgumentException("Dịch vụ không được để trống.");
            }

            // Book appointment and ensure ID is set
            appointmentService.bookAppointment(appointment);
            if (appointment.getId() == 0) {
                throw new SQLException("ID lịch hẹn không được gán sau khi đặt lịch.");
            }

            // Get an admin ID dynamically
            int receiverID = getAdminID();
            if (receiverID == 0) {
                throw new SQLException("Không tìm thấy admin để gửi thông báo.");
            }

            // Send notification to Admin
            String message = String.format("Khách %s đã đặt lịch khám dịch vụ: %s. ID: %d", 
                fullName, service, appointment.getId());
            Notification notification = new Notification(
                null,      // SenderID: null for guest users
                "Guest",   // SenderRole: Use "Guest" for non-registered users
                receiverID, // ReceiverID: Dynamic admin ID
                "Admin",   // ReceiverRole
                "Lịch khám mới từ khách", // Title
                message    // Message with appointment ID
            );
            notificationService.createNotification(notification);
            System.out.println("Notification sent to AdminID: " + receiverID + ", Message: " + message);

            // Set success message and redirect
            session.setAttribute("successMessage", "Vui lòng chờ xác nhận đặt lịch!");
            response.sendRedirect(request.getContextPath() + "/views/common/HomePage.jsp");

        } catch (IllegalArgumentException e) {
            session.setAttribute("error", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/views/user/Patient/BookMedical.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/views/user/Patient/BookMedical.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/views/user/Patient/BookMedical.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/user/Patient/BookMedical.jsp").forward(request, response);
    }

    private int getAdminID() throws SQLException {
        String sql = "SELECT TOP 1 AdminID FROM Admins";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("AdminID");
            }
        }
        return 0; // Return 0 if no admin is found
    }
}
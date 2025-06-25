package controller.admin;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Notification;
import model.service.NotificationService;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import model.dao.DBContext;

@WebServlet(name = "NotificationServlet", urlPatterns = {"/NotificationServlet"})
public class NotificationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Integer adminId = (session != null && session.getAttribute("adminId") != null)
                ? (Integer) session.getAttribute("adminId") : null;

        if (adminId == null) {
            request.setAttribute("error", "Vui lòng đăng nhập với tư cách admin.");
            request.getRequestDispatcher("/views/admin/login.jsp").forward(request, response);
            return;
        }

        String ajax = request.getParameter("ajax");
        if ("true".equals(ajax)) {
            try {
                NotificationService notificationService = new NotificationService();
                List<Notification> notifications = notificationService.getAdminNotifications(adminId);
                int notificationCount = notificationService.getUnreadNotificationCountForAdmin(adminId);

                Map<String, Object> data = new HashMap<>();
                data.put("notificationCount", notificationCount);
                data.put("notifications", notifications);
                data.put("currentTime", new Timestamp(System.currentTimeMillis())); // Add current time for reference

                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.print(new Gson().toJson(data));
                out.flush();
            } catch (Exception e) {
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.print("{\"error\": \"" + e.getMessage() + "\"}");
                out.flush();
            }
            return;
        }

        try {
            NotificationService notificationService = new NotificationService();
            List<Notification> notifications = notificationService.getAdminNotifications(adminId);
            int notificationCount = notificationService.getUnreadNotificationCountForAdmin(adminId);
            request.setAttribute("notifications", notifications);
            request.setAttribute("notificationCount", notificationCount);
            request.setAttribute("currentTime", new Timestamp(System.currentTimeMillis())); // Add current time
            request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi khi lấy danh sách thông báo: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Integer adminId = (session != null && session.getAttribute("adminId") != null)
                ? (Integer) session.getAttribute("adminId") : null;

        if (adminId == null) {
            request.setAttribute("error", "Vui lòng đăng nhập với tư cách admin.");
            request.getRequestDispatcher("/views/admin/login.jsp").forward(request, response);
            return;
        }

        String notificationIdParam = request.getParameter("notificationId");
        String action = request.getParameter("action");

        if (notificationIdParam == null || notificationIdParam.trim().isEmpty()) {
            handleError(request, response, "ID thông báo không hợp lệ.", notificationIdParam, action, adminId);
            return;
        }

        int notificationId;
        try {
            notificationId = Integer.parseInt(notificationIdParam);
        } catch (NumberFormatException e) {
            handleError(request, response, "ID thông báo phải là một số hợp lệ.", notificationIdParam, action, adminId);
            return;
        }

        if (action == null || !action.matches("^(accept|reject)$")) {
            handleError(request, response, "Hành động không hợp lệ.", notificationIdParam, action, adminId);
            return;
        }

        try {
            NotificationService notificationService = new NotificationService();
            Notification notification = notificationService.getById(notificationId);

            if (notification == null) {
                handleError(request, response, "Không tìm thấy thông báo với ID: " + notificationId, notificationIdParam, action, adminId);
                return;
            }

            int appointmentId = extractAppointmentIdFromMessage(notification.getMessage());

            if ("accept".equals(action)) {
                updateAppointmentStatus(appointmentId, "Approved");
                sendResponseNotification(notification.getSenderID(), "Appointment Approved", 
                    "Lịch hẹn của bạn đã được chấp nhận vào " + new Timestamp(System.currentTimeMillis()), adminId);
            } else if ("reject".equals(action)) {
                updateAppointmentStatus(appointmentId, "Rejected");
                sendResponseNotification(notification.getSenderID(), "Appointment Rejected", 
                    "Lịch hẹn của bạn đã bị từ chối vào " + new Timestamp(System.currentTimeMillis()), adminId);
            }

            notificationService.markNotificationAsRead(notificationId);
            response.sendRedirect(request.getContextPath() + "/NotificationServlet");

        } catch (IllegalArgumentException e) {
            handleError(request, response, e.getMessage(), notificationIdParam, action, adminId);
        } catch (Exception e) {
            handleError(request, response, "Lỗi hệ thống: " + e.getMessage(), notificationIdParam, action, adminId);
        }
    }

    private int extractAppointmentIdFromMessage(String message) {
        if (message == null || message.trim().isEmpty()) {
            throw new IllegalArgumentException("Nội dung thông báo không được để trống.");
        }
        Pattern pattern = Pattern.compile("ID:\\s*(\\d+)");
        Matcher matcher = pattern.matcher(message);
        if (matcher.find()) {
            return Integer.parseInt(matcher.group(1));
        }
        throw new IllegalArgumentException("Không tìm thấy AppointmentID trong nội dung thông báo. Định dạng yêu cầu: 'ID: <số>'.");
    }

    private void updateAppointmentStatus(int appointmentId, String status) throws SQLException {
        String sql = "UPDATE Appointments SET Status = ?, UpdatedAt = CURRENT_TIMESTAMP WHERE AppointmentID = ?";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, appointmentId);
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("Không tìm thấy lịch hẹn với ID: " + appointmentId);
            }
        }
    }

    private void sendResponseNotification(int userId, String title, String message, int adminId) throws SQLException {
        Notification responseNotification = new Notification(
            adminId, "Admin", userId, "Patient", title, message, new Timestamp(System.currentTimeMillis())
        );
        NotificationService notificationService = new NotificationService();
        notificationService.createNotification(responseNotification);
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage,
                            String notificationId, String action, int adminId) throws ServletException, IOException {
        request.setAttribute("error", errorMessage);
        request.setAttribute("formNotificationId", notificationId);
        request.setAttribute("formAction", action);
        try {
            NotificationService notificationService = new NotificationService();
            List<Notification> notifications = notificationService.getAdminNotifications(adminId);
            int notificationCount = notificationService.getUnreadNotificationCountForAdmin(adminId);
            request.setAttribute("notifications", notifications);
            request.setAttribute("notificationCount", notificationCount);
            request.setAttribute("currentTime", new Timestamp(System.currentTimeMillis())); // Add current time
        } catch (Exception e) {
            request.setAttribute("notifications", null);
        }
        request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
    }
}
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
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;
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

        // Kiểm tra đăng nhập
        if (session == null || session.getAttribute("user") == null) {
            request.setAttribute("errorMessage", "Vui lòng đăng nhập để xem chi tiết bác sĩ");
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            return;
        }

        // Kiểm tra role của người dùng
        Users user = (Users) session.getAttribute("user");
        if (user == null || !"patient".equals(user.getRole())) {
            System.err.println("⚠️ WARNING: User not found or role is not patient - User: " + user + ", Role: " + (user != null ? user.getRole() : "null"));
            request.setAttribute("errorMessage", "Vui lòng đăng nhập với vai trò bệnh nhân.");
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            return;
        }

        // Lấy patientId từ user
        int patientId = user.getUserID();
        request.setAttribute("patientId", String.valueOf(patientId));
        System.out.println("✅ Found patientId (userID): " + patientId);

        String doctorIdParam = request.getParameter("doctorId");
        String appointmentDate = request.getParameter("appointmentDate");

        try {
            // Validate doctorId
            if (doctorIdParam == null || doctorIdParam.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Vui lòng cung cấp ID bác sĩ hợp lệ");
                request.getRequestDispatcher("/views/user/error.jsp").forward(request, response);
                return;
            }

            int doctorId = Integer.parseInt(doctorIdParam.trim());
            if (doctorId <= 0) {
                throw new NumberFormatException("Doctor ID must be positive");
            }

            // Validate và parse appointmentDate
            LocalDate parsedDate = null;
            if (appointmentDate != null && !appointmentDate.trim().isEmpty()) {
                try {
                    parsedDate = LocalDate.parse(appointmentDate.trim(), DateTimeFormatter.ISO_LOCAL_DATE);
                } catch (DateTimeParseException e) {
                    request.setAttribute("errorMessage", "Ngày hẹn không hợp lệ: " + appointmentDate);
                    request.getRequestDispatcher("/views/user/error.jsp").forward(request, response);
                    return;
                }
            } else {
                parsedDate = LocalDate.now(); // Mặc định là ngày hiện tại
            }
            request.setAttribute("appointmentDate", parsedDate);

            // Lấy thông tin chi tiết bác sĩ
            Map<String, Object> details = appointmentService.viewDetailBook(doctorId);
            if (details == null || details.isEmpty()) {
                request.setAttribute("errorMessage", "Không tìm thấy thông tin bác sĩ với ID: " + doctorId);
                request.getRequestDispatcher("/views/user/error.jsp").forward(request, response);
                return;
            }

            // Log chi tiết để debug
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> schedules = (List<Map<String, Object>>) details.get("schedules");
            String roomID = (details.get("roomID") != null) ? details.get("roomID").toString() : "null";
            System.out.println("🔧 DEBUG - ViewDetailBookServlet: doctorId = " + doctorId + ", roomID = " + roomID + 
                               ", schedules count = " + (schedules != null ? schedules.size() : 0) + 
                               ", appointmentDate = " + parsedDate + " at " + java.time.LocalDateTime.now() + " +07");
            if (schedules != null) {
                for (Map<String, Object> schedule : schedules) {
                    System.out.println("🔧 DEBUG - Schedule: slotId = " + schedule.get("slotId") + 
                                       ", roomName = " + schedule.get("roomName") + 
                                       ", roomId = " + schedule.get("roomId"));
                }
            }

            // Truyền dữ liệu cho JSP
            request.setAttribute("doctorDetails", details);
            request.setAttribute("currentDate", parsedDate);

            // Debug thêm thông tin
            System.out.println("🔧 DEBUG - ViewDetailBookServlet: doctorDetails = " + (details != null ? "Available" : "null"));

            request.getRequestDispatcher("/views/user/Patient/ViewDetailBook.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "ID bác sĩ không hợp lệ: " + doctorIdParam);
            request.getRequestDispatcher("/views/user/error.jsp").forward(request, response);
        } catch (SQLException e) {
            System.err.println("SQLException in ViewDetailBookServlet at " + java.time.LocalDateTime.now() + " +07: " + e.getMessage());
            request.setAttribute("errorMessage", "Lỗi hệ thống: Không thể tải thông tin bác sĩ. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/views/user/error.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Unexpected error in ViewDetailBookServlet at " + java.time.LocalDateTime.now() + " +07: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi không xác định: " + e.getMessage());
            request.getRequestDispatcher("/views/user/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
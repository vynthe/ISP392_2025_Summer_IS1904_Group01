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

        // Kiểm tra đăng nhập
        if (session == null || session.getAttribute("user") == null) {
            request.setAttribute("errorMessage", "Vui lòng đăng nhập để xem chi tiết bác sĩ");
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            return;
        }

        // ✅ Lấy user từ session và kiểm tra role
        model.entity.Users user = (model.entity.Users) session.getAttribute("user");
        if (user == null || !"patient".equals(user.getRole())) {
            System.err.println("⚠️ WARNING: User not found or role is not patient");
            System.err.println("  user: " + user);
            System.err.println("  role: " + (user != null ? user.getRole() : "null"));
            
            java.util.Enumeration<String> attributeNames = session.getAttributeNames();
            System.err.println("Available session attributes:");
            while (attributeNames.hasMoreElements()) {
                String name = attributeNames.nextElement();
                System.err.println("  " + name + " = " + session.getAttribute(name));
            }
            request.setAttribute("errorMessage", "Vui lòng đăng nhập với vai trò bệnh nhân.");
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            return;
        }

        // ✅ Lấy patientId từ user và chuyển đổi sang String
        int patientIdInt = user.getUserID();
        String patientId = String.valueOf(patientIdInt);
        if (patientId == null || patientId.isEmpty()) {
            System.err.println("⚠️ WARNING: userID not found or empty in user object");
            patientId = "";
        }
        request.setAttribute("patientId", patientId);
        System.out.println("✅ Found patientId (userID): " + patientId);

        String doctorIdParam = request.getParameter("doctorId");
        String appointmentDate = request.getParameter("appointmentDate");

        try {
            // Validate doctorId
            if (doctorIdParam == null || doctorIdParam.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Vui lòng cung cấp ID bác sĩ hợp lệ");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            int doctorId;
            try {
                doctorId = Integer.parseInt(doctorIdParam.trim());
                if (doctorId <= 0) {
                    throw new NumberFormatException("Doctor ID must be positive");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "ID bác sĩ không hợp lệ: " + doctorIdParam);
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            // Validate ngày hẹn nếu có
            LocalDate parsedDate = null;
            if (appointmentDate != null && !appointmentDate.trim().isEmpty()) {
                try {
                    parsedDate = LocalDate.parse(appointmentDate.trim(), DateTimeFormatter.ISO_LOCAL_DATE);
                    request.setAttribute("appointmentDate", parsedDate);
                } catch (DateTimeParseException e) {
                    request.setAttribute("errorMessage", "Ngày hẹn không hợp lệ: " + appointmentDate);
                    request.getRequestDispatcher("/error.jsp").forward(request, response);
                    return;
                }
            } else {
                parsedDate = LocalDate.now(); // Mặc định là ngày hiện tại nếu không có appointmentDate
                request.setAttribute("appointmentDate", parsedDate);
            }

            // Lấy thông tin bác sĩ
            Map<String, Object> details = appointmentService.viewDetailBook(doctorId);
            if (details == null || details.isEmpty()) {
                request.setAttribute("errorMessage", "Không tìm thấy thông tin bác sĩ với ID: " + doctorId);
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            String roomID = (details.get("roomID") != null) ? details.get("roomID").toString() : "null";
            System.out.println("🔧 DEBUG - ViewDetailBookServlet: doctorId = " + doctorId + ", roomID = " + roomID + ", appointmentDate = " + parsedDate + " at " + java.time.LocalDateTime.now() + " +07");

            // Truyền dữ liệu cho JSP
            request.setAttribute("doctorDetails", details);
            request.setAttribute("currentDate", parsedDate);
            
            // ✅ Debug info để tracking
            System.out.println("🔧 DEBUG - ViewDetailBookServlet:");
            System.out.println("  doctorId: " + doctorId);
            System.out.println("  patientId (userID): " + patientId);
            System.out.println("  role: " + user.getRole());
            System.out.println("  doctorDetails: " + (details != null ? "Available" : "null"));
            System.out.println("  roomID from details: " + roomID);

            request.getRequestDispatcher("/views/user/Patient/ViewDetailBook.jsp").forward(request, response);

        } catch (SQLException e) {
            System.err.println("SQLException in ViewDetailBookServlet at " + java.time.LocalDateTime.now() + " +07: " + e.getMessage());
            request.setAttribute("errorMessage", "Lỗi hệ thống: Không thể tải thông tin bác sĩ. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Unexpected error in ViewDetailBookServlet at " + java.time.LocalDateTime.now() + " +07: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi không xác định: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
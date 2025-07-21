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
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "BookMedicalAppointmentServlet", urlPatterns = {"/BookMedicalAppointmentServlet"})
public class BookMedicalAppointmentServlet extends HttpServlet {

    private AppointmentService appointmentService;

    @Override
    public void init() throws ServletException {
        appointmentService = new AppointmentService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/views/common/login.jsp");
            return;
        }

        // Lấy tham số tìm kiếm và trang hiện tại
        String nameKeyword = request.getParameter("nameKeyword");
        String specialtyKeyword = request.getParameter("specialtyKeyword");
        int page = parseIntOrDefault(request.getParameter("page"), 1);
        int pageSize = 10;

        // Xử lý tham số tìm kiếm để tránh null hoặc chuỗi rỗng
        nameKeyword = (nameKeyword != null && !nameKeyword.trim().isEmpty()) ? nameKeyword.trim() : "";
        specialtyKeyword = (specialtyKeyword != null && !specialtyKeyword.trim().isEmpty()) ? specialtyKeyword.trim() : "";

        try {
            // Gọi service để lấy danh sách bác sĩ
            List<Users> doctors = appointmentService.searchDoctorsByNameAndSpecialty(nameKeyword, specialtyKeyword, page, pageSize);
            int totalRecords = appointmentService.getTotalDoctorRecords(nameKeyword, specialtyKeyword);
            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

            // Đặt thuộc tính cho JSP
            request.setAttribute("doctors", doctors);
            request.setAttribute("totalRecords", totalRecords);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);

            // Chuyển tiếp đến trang JSP
            request.getRequestDispatcher("/views/user/Patient/BookMedicalAppointment.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            System.err.println("SQLException at " + new java.util.Date() + " +07: " + e.getMessage());
            request.getRequestDispatcher("/views/user/Patient/BookMedicalAppointment.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            System.err.println("Exception at " + new java.util.Date() + " +07: " + e.getMessage());
            request.getRequestDispatcher("/views/user/Patient/BookMedicalAppointment.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/views/common/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String doctorIdStr = request.getParameter("doctorId");
        String appointmentDate = request.getParameter("appointmentDate");
        String dayOfWeek = request.getParameter("dayOfWeek");
        String startTime = request.getParameter("startTime");
        String endTime = request.getParameter("endTime");
        String nameKeyword = request.getParameter("nameKeyword");
        String specialtyKeyword = request.getParameter("specialtyKeyword");
        int page = parseIntOrDefault(request.getParameter("page"), 1);

        try {
            if ("bookAppointment".equals(action) && doctorIdStr != null && !doctorIdStr.trim().isEmpty()) {
                int doctorId = Integer.parseInt(doctorIdStr.trim());
                Users currentUser = (Users) session.getAttribute("user");

                // Thực hiện đặt lịch (cần triển khai logic thực tế trong service)
                 appointmentService.bookAppointment(page, doctorId, doctorId, appointmentDate, startTime, endTime);

                // Đặt thông báo thành công
                session.setAttribute("statusMessage", "Đặt lịch hẹn thành công");

                // Chuyển hướng lại trang danh sách bác sĩ
                String redirectUrl = request.getContextPath() + "/BookMedicalAppointmentServlet?page=" + page +
                        (nameKeyword != null && !nameKeyword.trim().isEmpty() ? "&nameKeyword=" + URLEncoder.encode(nameKeyword, StandardCharsets.UTF_8) : "") +
                        (specialtyKeyword != null && !specialtyKeyword.trim().isEmpty() ? "&specialtyKeyword=" + URLEncoder.encode(specialtyKeyword, StandardCharsets.UTF_8) : "");
                response.sendRedirect(redirectUrl);
                return;
            }

            // Nếu không có action hoặc doctorId, chuyển hướng lại trang tìm kiếm
            String redirectUrl = request.getContextPath() + "/BookMedicalAppointmentServlet?page=" + page +
                    (nameKeyword != null && !nameKeyword.trim().isEmpty() ? "&nameKeyword=" + URLEncoder.encode(nameKeyword, StandardCharsets.UTF_8) : "") +
                    (specialtyKeyword != null && !specialtyKeyword.trim().isEmpty() ? "&specialtyKeyword=" + URLEncoder.encode(specialtyKeyword, StandardCharsets.UTF_8) : "");
            response.sendRedirect(redirectUrl);

        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("statusMessage", "Lỗi: ID bác sĩ không hợp lệ");
            System.err.println("NumberFormatException at " + new java.util.Date() + " +07: " + e.getMessage());
            String redirectUrl = request.getContextPath() + "/BookMedicalAppointmentServlet?page=" + page +
                    (nameKeyword != null && !nameKeyword.trim().isEmpty() ? "&nameKeyword=" + URLEncoder.encode(nameKeyword, StandardCharsets.UTF_8) : "") +
                    (specialtyKeyword != null && !specialtyKeyword.trim().isEmpty() ? "&specialtyKeyword=" + URLEncoder.encode(specialtyKeyword, StandardCharsets.UTF_8) : "");
            response.sendRedirect(redirectUrl);
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("statusMessage", "Lỗi hệ thống: " + e.getMessage());
            System.err.println("Exception at " + new java.util.Date() + " +07: " + e.getMessage());
            String redirectUrl = request.getContextPath() + "/BookMedicalAppointmentServlet?page=" + page +
                    (nameKeyword != null && !nameKeyword.trim().isEmpty() ? "&nameKeyword=" + URLEncoder.encode(nameKeyword, StandardCharsets.UTF_8) : "") +
                    (specialtyKeyword != null && !specialtyKeyword.trim().isEmpty() ? "&specialtyKeyword=" + URLEncoder.encode(specialtyKeyword, StandardCharsets.UTF_8) : "");
            response.sendRedirect(redirectUrl);
        }
    }

    private int parseIntOrDefault(String value, int defaultValue) {
        try {
            return (value != null && !value.trim().isEmpty()) ? Integer.parseInt(value.trim()) : defaultValue;
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
}
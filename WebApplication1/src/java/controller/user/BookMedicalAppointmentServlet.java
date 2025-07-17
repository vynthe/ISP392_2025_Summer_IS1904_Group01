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

        String nameKeyword = request.getParameter("nameKeyword");
        String specialtyKeyword = request.getParameter("specialtyKeyword");
        int page = parseIntOrDefault(request.getParameter("page"), 1);
        int pageSize = 10;

        try {
            // Lấy danh sách bác sĩ
            List<Users> doctors = appointmentService.searchDoctorsByNameAndSpecialty(nameKeyword, specialtyKeyword, page, pageSize);
            int totalRecords = appointmentService.getTotalDoctorRecords(nameKeyword, specialtyKeyword);
            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

            // Đặt thuộc tính cho JSP
            request.setAttribute("doctors", doctors);
            request.setAttribute("totalRecords", totalRecords);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);

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

        String doctorIdStr = request.getParameter("doctorId");
        String appointmentDate = request.getParameter("appointmentDate");
        String nameKeyword = request.getParameter("nameKeyword");
        String specialtyKeyword = request.getParameter("specialtyKeyword");
        int page = parseIntOrDefault(request.getParameter("page"), 1);

        try {
            if (doctorIdStr != null && !doctorIdStr.trim().isEmpty()) {
                int doctorId = Integer.parseInt(doctorIdStr.trim());
                // Giả sử xử lý đặt lịch (cần thêm logic thực tế)
                // Ví dụ: Gọi service để lưu lịch hẹn
                // appointmentService.bookAppointment(doctorId, appointmentDate, ((Users) session.getAttribute("user")).getUserID());
                session.setAttribute("statusMessage", "Đặt lịch thành công");

                // Chuyển hướng lại trang với các tham số hiện tại
                String redirectUrl = request.getContextPath() + "/BookMedicalAppointmentServlet?page=" + page +
                    (nameKeyword != null ? "&nameKeyword=" + URLEncoder.encode(nameKeyword, StandardCharsets.UTF_8) : "") +
                    (specialtyKeyword != null ? "&specialtyKeyword=" + URLEncoder.encode(specialtyKeyword, StandardCharsets.UTF_8) : "") +
                    (appointmentDate != null ? "&appointmentDate=" + URLEncoder.encode(appointmentDate, StandardCharsets.UTF_8) : "");
                response.sendRedirect(redirectUrl);
                return;
            }

            // Nếu không có doctorId, chuyển hướng lại trang tìm kiếm
            String redirectUrl = request.getContextPath() + "/BookMedicalAppointmentServlet?page=" + page +
                (nameKeyword != null ? "&nameKeyword=" + URLEncoder.encode(nameKeyword, StandardCharsets.UTF_8) : "") +
                (specialtyKeyword != null ? "&specialtyKeyword=" + URLEncoder.encode(specialtyKeyword, StandardCharsets.UTF_8) : "");
            response.sendRedirect(redirectUrl);

        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("statusMessage", "Lỗi: ID bác sĩ không hợp lệ");
            System.err.println("NumberFormatException at " + new java.util.Date() + " +07: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/BookMedicalAppointmentServlet?page=" + page +
                (nameKeyword != null ? "&nameKeyword=" + URLEncoder.encode(nameKeyword, StandardCharsets.UTF_8) : "") +
                (specialtyKeyword != null ? "&specialtyKeyword=" + URLEncoder.encode(specialtyKeyword, StandardCharsets.UTF_8) : ""));
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("statusMessage", "Lỗi hệ thống: " + e.getMessage());
            System.err.println("Exception at " + new java.util.Date() + " +07: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/BookMedicalAppointmentServlet?page=" + page +
                (nameKeyword != null ? "&nameKeyword=" + URLEncoder.encode(nameKeyword, StandardCharsets.UTF_8) : "") +
                (specialtyKeyword != null ? "&specialtyKeyword=" + URLEncoder.encode(specialtyKeyword, StandardCharsets.UTF_8) : ""));
        }
    }

    private int parseIntOrDefault(String value, int defaultValue) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
}
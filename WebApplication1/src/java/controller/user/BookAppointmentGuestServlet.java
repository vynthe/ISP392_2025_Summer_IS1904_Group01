package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.service.Appointment2Service;
import model.entity.Appointment2;
import model.service.Services_Service;
import model.entity.Services;

@WebServlet(name = "BookAppointmentGuestServlet", urlPatterns = {"/BookAppointmentGuestServlet"})
public class BookAppointmentGuestServlet extends HttpServlet {

    private final Appointment2Service appointmentService = new Appointment2Service();
    private final Services_Service servicesService = new Services_Service();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        // Lấy dữ liệu từ form
        String fullName = request.getParameter("fullName");
        String phoneNumber = request.getParameter("phoneNumber");
        String email = request.getParameter("email");
        String serviceIdStr = request.getParameter("serviceID"); // Lấy serviceID từ form
        HttpSession session = request.getSession();

        try {
            // Kiểm tra và chuyển đổi serviceID
            int serviceID;
            try {
                serviceID = Integer.parseInt(serviceIdStr);
                if (serviceID <= 0) {
                    throw new NumberFormatException();
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Vui lòng chọn một dịch vụ hợp lệ.");
                // Lấy lại danh sách dịch vụ để hiển thị lại form
                List<Services> services = servicesService.getAllServices();
                request.setAttribute("services", services);
                request.getRequestDispatcher("/views/user/Patient/BookMedical.jsp").forward(request, response);
                return;
            }

            // Tạo đối tượng Appointment2
            Appointment2 appointment = new Appointment2(fullName, phoneNumber, email, serviceID);

            // Gọi phương thức bookAppointment từ service
            appointmentService.bookAppointment(appointment);
            session.setAttribute("successMessage", "Vui lòng chờ xác nhận đặt lịch!");
            response.sendRedirect(request.getContextPath() + "/views/common/HomePage.jsp");
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            // Lấy lại danh sách dịch vụ để hiển thị lại form
            List<Services> services = null;
            try {
                services = servicesService.getAllServices();
            } catch (SQLException ex) {
                Logger.getLogger(BookAppointmentGuestServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            request.setAttribute("services", services);
            request.getRequestDispatcher("/views/user/Patient/BookMedical.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            // Lấy lại danh sách dịch vụ để hiển thị lại form
            List<Services> services = null;
            try {
                services = servicesService.getAllServices();
            } catch (SQLException ex) {
                Logger.getLogger(BookAppointmentGuestServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            request.setAttribute("services", services);
            request.getRequestDispatcher("/views/user/Patient/BookMedical.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy danh sách dịch vụ để hiển thị trên form
            List<Services> services = servicesService.getAllServices();
            request.setAttribute("services", services);
            request.getRequestDispatcher("/views/user/Patient/BookMedical.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Không thể tải danh sách dịch vụ: " + e.getMessage());
            request.getRequestDispatcher("/views/user/Patient/BookMedical.jsp").forward(request, response);
        }
    }
}
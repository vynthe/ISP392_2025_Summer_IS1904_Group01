package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
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

        // Xử lý đặt lịch hẹn
        StringBuilder errorMsg = new StringBuilder();
        if (fullName == null || fullName.trim().isEmpty()) {
            errorMsg.append("Tên không được để trống. ");
        }
        if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
            errorMsg.append("Số điện thoại không được để trống. ");
        }
        if (service == null || service.trim().isEmpty()) {
            errorMsg.append("Dịch vụ không được để trống. ");
        }

        try {
            if (errorMsg.length() == 0 && appointmentService.bookAppointment(appointment)) {
                session.setAttribute("successMessage", "Đặt lịch hẹn thành công!");
                response.sendRedirect(request.getContextPath() + "/views/common/HomePage.jsp");
            } else {
                request.setAttribute("error", errorMsg.length() > 0 ? errorMsg.toString()
                        : "Đặt lịch hẹn thất bại. Vui lòng kiểm tra lại dữ liệu!");
                request.getRequestDispatcher("/views/user/Patient/BookMedical.jsp").forward(request, response);
            }
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

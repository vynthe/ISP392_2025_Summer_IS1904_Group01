package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.Users;
import model.service.UserService;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "ViewMedicalAppointmentServlet", urlPatterns = {"/ViewMedicalAppointmentServlet"})
public class ViewMedicalAppointmentServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        try {
            // Lấy danh sách bác sĩ từ service
            List<Users> doctors = userService.getAllDoctors();
            request.setAttribute("doctors", doctors);

            // Chuyển tiếp đến JSP để hiển thị
            request.getRequestDispatcher("/views/user/Patient/ViewMedicalAppointment.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi khi tải danh sách bác sĩ: " + e.getMessage());
            request.getRequestDispatcher("/views/user/Patient/ViewMedicalAppointment.jsp").forward(request, response);
        }
    }
}
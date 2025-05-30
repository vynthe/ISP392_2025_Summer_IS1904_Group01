package controller.admin;

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

@WebServlet(name = "ViewPatientServlet", urlPatterns = {"/ViewPatientServlet"})
public class ViewPatientServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        List<Users> patients = null;

        try {
            if (keyword != null && !keyword.trim().isEmpty()) {
                patients = userService.searchPatients(keyword.trim());
            } else {
                patients = userService.getAllPatient();
            }

            request.setAttribute("patients", patients);
            request.setAttribute("keyword", keyword); // giữ lại keyword trong input nếu cần

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải danh sách bệnh nhân: " + e.getMessage());
        }

        request.getRequestDispatcher("/views/admin/ViewPatients.jsp").forward(request, response);
    }
}

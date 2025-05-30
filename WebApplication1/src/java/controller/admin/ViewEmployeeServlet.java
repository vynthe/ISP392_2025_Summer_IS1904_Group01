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
import java.util.logging.Level;
import java.util.logging.Logger;

public class ViewEmployeeServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

  @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Users> employees = null;

        try {
            if (keyword != null && !keyword.trim().isEmpty()) {
                employees = userService.searchEmployees(keyword.trim());
            } else {
                employees = userService.getAllEmployee(); // tên service đã dùng
            }

            request.setAttribute("employees", employees);
            request.setAttribute("keyword", keyword); // để giữ lại keyword trong ô input nếu cần

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải danh sách bác sĩ/y tá: " + e.getMessage());
        }

        request.getRequestDispatcher("/views/admin/ViewEmployees.jsp").forward(request, response);
    }
}

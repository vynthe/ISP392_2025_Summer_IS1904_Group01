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

@WebServlet(name = "ViewSchedulesServlet", urlPatterns = {"/ViewSchedulesServlet"})
public class ViewSchedulesServlet extends HttpServlet {

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
                employees = userService.getAllEmployee(); // Lấy tất cả nhân viên
            }

            request.setAttribute("employees", employees);
            request.setAttribute("keyword", keyword); // Giữ lại keyword cho ô tìm kiếm

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải danh sách nhân viên: " + e.getMessage());
        }

        // Chuyển tiếp đến trang JSP để hiển thị
        request.getRequestDispatcher("/views/admin/ViewSchedules.jsp").forward(request, response);
    }
}
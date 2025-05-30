package controller.admin;

import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.service.AdminService;
import model.entity.Admins;

/**
 *
 * @author exorc
 */
@WebServlet(name = "AdminLoginController", urlPatterns = {"/AdminLoginController"})
public class AdminLoginController extends HttpServlet {

    private AdminService adminService;

    @Override
    public void init() throws ServletException {
        adminService = new AdminService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String emailOrUsername = request.getParameter("emailOrUsername");
        String password = request.getParameter("password");

        if (emailOrUsername == null || emailOrUsername.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Email/Username và mật khẩu là bắt buộc.");
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            return;
        }

        try {
            Admins admin = adminService.authenticateAdmin(emailOrUsername, password);
            if (admin != null) {
                request.getSession().setAttribute("admin", admin);
                response.sendRedirect(request.getContextPath() + "/views/admin/dashboard.jsp");
            } else {
                request.setAttribute("error", "Email/Username hoặc mật khẩu không hợp lệ.");
                request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Xử lý đăng nhập cho admin";
    }
}
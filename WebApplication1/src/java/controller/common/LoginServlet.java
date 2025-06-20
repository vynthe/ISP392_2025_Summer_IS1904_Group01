package controller.common;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author exorc
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy và trim parameters
        String emailOrUsername = request.getParameter("emailOrUsername") != null ? request.getParameter("emailOrUsername").trim() : null;
        String password = request.getParameter("password") != null ? request.getParameter("password").trim() : null;

        // Kiểm tra input cơ bản
        if (emailOrUsername == null || emailOrUsername.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("error", "Email/Username và mật khẩu là bắt buộc.");
            request.setAttribute("form", "login");
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            return;
        }

        // Lưu lại input để repopulate form nếu cần
        request.setAttribute("emailOrUsername", emailOrUsername);
        request.setAttribute("password", password);

        // Chuyển tiếp đến UserLoginController để xử lý đăng nhập
        try {
            request.getRequestDispatcher("/UserLoginController").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi hệ thống khi xử lý đăng nhập: " + e.getMessage());
            request.setAttribute("form", "login");
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("form", "login");
        request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý yêu cầu đăng nhập và chuyển hướng đến UserLoginController.";
    }
}
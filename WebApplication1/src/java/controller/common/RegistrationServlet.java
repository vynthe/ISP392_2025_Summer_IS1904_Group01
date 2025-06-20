package controller.common;

import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.service.UserService;

@WebServlet(name = "RegistrationServlet", urlPatterns = {"/RegistrationServlet"})
public class RegistrationServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Trim parameters
        String username = request.getParameter("username") != null ? request.getParameter("username").trim() : null;
        String email = request.getParameter("email") != null ? request.getParameter("email").trim() : null;
        String password = request.getParameter("password") != null ? request.getParameter("password").trim() : null;
        String role = request.getParameter("role") != null ? request.getParameter("role").trim() : null;

        // Preserve input values for form repopulation
        request.setAttribute("username", username);
        request.setAttribute("email", email);
        request.setAttribute("role", role);

        // Basic validation: check for emptiness
        if (username == null || username.isEmpty()) {
            request.setAttribute("error", "Username không được để trống.");
            request.setAttribute("form", "register");
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            return;
        }

        // Validate username: chỉ chứa chữ cái và số
        if (!username.matches("^[a-zA-Z0-9]+$")) {
            request.setAttribute("error", "Username chỉ được chứa chữ cái và số.");
            request.setAttribute("form", "register");
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            return;
        }

        // Validate username max length
        if (username.length() > 20) {
            request.setAttribute("error", "Username không được vượt quá 20 ký tự.");
            request.setAttribute("form", "register");
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            return;
        }

        if (email == null || email.isEmpty()) {
            request.setAttribute("error", "Email không được để trống.");
            request.setAttribute("form", "register");
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            return;
        }

        // Validate email max length and format
        if (email.length() > 50) {
            request.setAttribute("error", "Email không được vượt quá 50 ký tự.");
            request.setAttribute("form", "register");
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            return;
        }
        if (!email.endsWith("@gmail.com") || email.equals("@gmail.com")) {
            request.setAttribute("error", "Email phải có đuôi @gmail.com.");
            request.setAttribute("form", "register");
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            return;
        }

        if (password == null || password.isEmpty()) {
            request.setAttribute("error", "Password không được để trống.");
            request.setAttribute("form", "register");
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            return;
        }

        // Validate password: ít nhất 8 ký tự, 1 uppercase, 1 special char, 1 digit
        if (password.length() < 8 || !password.matches("^(?=.*[A-Z])(?=.*[!@#$%^&*])(?=.*\\d).+$")) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 8 ký tự, 1 chữ cái in hoa, 1 ký tự đặc biệt và 1 số.");
            request.setAttribute("form", "register");
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            return;
        }

        // Validate password max length
        if (password.length() > 20) {
            request.setAttribute("error", "Mật khẩu không được vượt quá 20 ký tự.");
            request.setAttribute("form", "register");
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            return;
        }

        // Validate role
        if (role == null || role.isEmpty()) {
            request.setAttribute("error", "Role không được để trống.");
            request.setAttribute("form", "register");
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            return;
        }

        // Check for valid roles
        if (!role.equals("patient") && !role.equals("doctor") && !role.equals("nurse") && !role.equals("receptionist")) {
            request.setAttribute("error", "Vai trò không hợp lệ.");
            request.setAttribute("form", "register");
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            return;
        }

        try {
            // Attempt to register user with phone as null (not provided in form)
            if (userService.registerUser(username, email, password, role, null)) {
                HttpSession session = request.getSession();
                session.setAttribute("successMessage", "Đăng ký thành công! Vui lòng kiểm tra email để xác thực tài khoản trước khi đăng nhập.");
                response.sendRedirect(request.getContextPath() + "/UserLoginController");
            } else {
                request.setAttribute("error", "Username hoặc Email đã tồn tại.");
                request.setAttribute("form", "register");
                request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi hệ thống: " + (e.getMessage() != null ? e.getMessage() : "Không thể xử lý đăng ký."));
            request.setAttribute("form", "register");
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("form", "register");
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("form", "register");
        request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
    }
}
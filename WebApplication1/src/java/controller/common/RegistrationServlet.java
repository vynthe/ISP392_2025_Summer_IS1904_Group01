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
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        // Retain form values in case of error
        request.setAttribute("username", username);
        request.setAttribute("email", email);
        request.setAttribute("role", role);

        // Basic validation
        if (username == null || username.trim().isEmpty()) {
            request.setAttribute("error", "Username không được để trống.");
            request.setAttribute("form", "register"); // Stay on registration form
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            return;
        }

        // Validate username: chỉ chứa chữ cái và số
        if (!username.matches("^[a-zA-Z0-9]+$")) {
            request.setAttribute("error", "Username chỉ được chứa chữ cái và số.");
            request.setAttribute("form", "register"); // Stay on registration form
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            return;
        }

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Email không được để trống.");
            request.setAttribute("form", "register"); // Stay on registration form
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            return;
        }

        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Password không được để trống.");
            request.setAttribute("form", "register"); // Stay on registration form
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            return;
        }

        // Validate password: ít nhất 8 ký tự, 1 chữ hoa, 1 ký tự đặc biệt, 1 số
        if (password.length() < 8 || !password.matches("^(?=.*[A-Z])(?=.*[!@#$%^&*])(?=.*\\d).+$")) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 8 ký tự, 1 chữ cái in hoa, 1 ký tự đặc biệt và 1 số.");
            request.setAttribute("form", "register"); // Stay on registration form
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            return;
        }

        if (role == null || role.trim().isEmpty()) {
            request.setAttribute("error", "Role không được để trống.");
            request.setAttribute("form", "register"); // Stay on registration form
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            return;
        }

        try {
            // Gọi registerUser với fullName là null
            if (userService.registerUser(username, email, password, role, null)) {
                HttpSession session = request.getSession();
                session.setAttribute("successMessage", "Đã đăng ký thành công, vui lòng đăng nhập!");
                response.sendRedirect(request.getContextPath() + "/UserLoginController");
            } else {
                request.setAttribute("error", "Username hoặc Email đã tồn tại.");
                request.setAttribute("form", "register"); // Stay on registration form
                request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            // Kiểm tra nếu lỗi là do fullName (vì fullName là null trong bước đăng ký)
            if (e.getMessage().contains("Tên không được để trống")) {
                try {
                    // Đăng ký lại mà không yêu cầu fullName
                    // Giả định UserService có thể xử lý fullName là null hoặc bạn cần chỉnh sửa UserService
                    if (userService.registerUser(username, email, password, role, null)) {
                        HttpSession session = request.getSession();
                        session.setAttribute("successMessage", "Đã đăng ký thành công, vui lòng đăng nhập và hoàn thiện hồ sơ!");
                        response.sendRedirect(request.getContextPath() + "/UserLoginController");
                    } else {
                        request.setAttribute("error", "Username hoặc Email đã tồn tại.");
                        request.setAttribute("form", "register");
                        request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
                    }
                } catch (SQLException ex) {
                    ex.printStackTrace();
                    request.setAttribute("error", "Lỗi khi đăng ký: " + ex.getMessage());
                    request.setAttribute("form", "register");
                    request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
                }
            } else {
                e.printStackTrace();
                request.setAttribute("error", "Lỗi khi đăng ký: " + e.getMessage());
                request.setAttribute("form", "register"); // Stay on registration form
                request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("form", "register"); // Stay on registration form
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
    }
}
package controller.common;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.Users;
import model.service.UserService;

@WebServlet(name = "ResetPasswordServlet", urlPatterns = {"/ResetPasswordServlet","/admin/login"})
public class ResetPasswordServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/common/resetPassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String newPassword = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Store email for form persistence
        request.setAttribute("email", email);

        // Validate input
        if (newPassword == null || newPassword.trim().isEmpty() || confirmPassword == null || confirmPassword.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ mật khẩu và xác nhận mật khẩu.");
            request.getRequestDispatcher("/views/common/resetPassword.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu và xác nhận mật khẩu không khớp.");
            request.getRequestDispatcher("/views/common/resetPassword.jsp").forward(request, response);
            return;
        }

        try {
            // Fetch current user to get old password
            Users user = userService.authenticateUser(email, ""); // Temporary placeholder, adjust logic
            if (user != null && user.getPassword() != null && userService.authenticateUser(email, newPassword) != null) {
                request.setAttribute("error", "Mật khẩu bị trùng với mật khẩu cũ.");
                request.getRequestDispatcher("/views/common/resetPassword.jsp").forward(request, response);
                return;
            }

            // Update password if validation passes (handled in UserService/UserDAO)
            if (userService.updatePassword(email, newPassword)) {
    request.setAttribute("success", "Mật khẩu đã được thay đổi.");
    // Thay vì forward, dùng sendRedirect để thay đổi URL
    response.sendRedirect(request.getContextPath() + "/login");
            } else {
                request.setAttribute("error", "Không thể thay đổi mật khẩu. Vui lòng thử lại.");
                request.getRequestDispatcher("/views/common/resetPassword.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi xử lý yêu cầu: " + e.getMessage());
            request.getRequestDispatcher("/views/common/resetPassword.jsp").forward(request, response);
        }
    }
}
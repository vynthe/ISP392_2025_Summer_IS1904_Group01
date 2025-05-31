package controller.common;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.service.UserService;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/ForgotPasswordServlet"})
public class ForgotPasswordServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/common/forgotPassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");

        // Store email for form persistence
        request.setAttribute("email", email);

        // Validate input
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập email.");
            request.getRequestDispatcher("/views/common/forgotPassword.jsp").forward(request, response);
            return;
        }

        if (!email.endsWith("@gmail.com") || email.equals("@gmail.com")) {
            request.setAttribute("error", "Vui lòng nhập email Gmail hợp lệ.");
            request.getRequestDispatcher("/views/common/forgotPassword.jsp").forward(request, response);
            return;
        }

        try {
            // Check if email exists
            if (userService.isEmailOrUsernameExists(email, null)) {
                // Redirect to reset password page with email
                request.setAttribute("email", email);
                request.getRequestDispatcher("/views/common/resetPassword.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Email không tồn tại trong hệ thống.");
                request.getRequestDispatcher("/views/common/forgotPassword.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi xử lý yêu cầu: " + e.getMessage());
            request.getRequestDispatcher("/views/common/forgotPassword.jsp").forward(request, response);
        }
    }
}
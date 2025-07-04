package controller.common;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.dao.AdminDAO;
import model.dao.UserDAO;
import model.entity.Admins;
import model.entity.Users;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

public class ChangePasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("views/common/changepassword.jsp").forward(request, response);
    }
@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String currentPassword = request.getParameter("oldPassword");
    String newPassword = request.getParameter("newPassword");
    String confirmPassword = request.getParameter("confirmPassword");

    HttpSession session = request.getSession(false); // Không tạo session mới
    if (session == null || (session.getAttribute("admin") == null && session.getAttribute("user") == null)) {
        response.sendRedirect("login");
        return;
    }

    // Kiểm tra đầu vào
    if (currentPassword == null || newPassword == null || confirmPassword == null ||
        currentPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
        request.setAttribute("error", "Vui lòng nhập đầy đủ các trường mật khẩu.");
        request.getRequestDispatcher("views/common/changepassword.jsp").forward(request, response);
        return;
    }

    Admins admin = (Admins) session.getAttribute("admin");
    Users user = (Users) session.getAttribute("user");
    boolean success = false;
    String errorMessage = null;

    try {
        if (!newPassword.equals(confirmPassword)) {
            errorMessage = "Mật khẩu xác nhận không khớp.";
        } else if (admin != null) {
            AdminDAO dao = new AdminDAO();
            if (BCrypt.checkpw(currentPassword, admin.getPassword())) {
                String hashed = BCrypt.hashpw(newPassword, BCrypt.gensalt());
                success = dao.changePassword(admin.getAdminID(), hashed);
                if (success) {
                    admin.setPassword(hashed);
                    session.setAttribute("admin", admin);
                } else {
                    errorMessage = "Không thể cập nhật mật khẩu admin.";
                }
            } else {
                errorMessage = "Mật khẩu hiện tại không đúng.";
            }
        } else if (user != null) {
            UserDAO dao = new UserDAO();
            if (BCrypt.checkpw(currentPassword, user.getPassword())) {
                String hashed = BCrypt.hashpw(newPassword, BCrypt.gensalt());
                success = dao.changePassword(user.getEmail(), hashed);
                if (success) {
                    user.setPassword(hashed);
                    session.setAttribute("user", user);
                } else {
                    errorMessage = "Không thể cập nhật mật khẩu user.";
                }
            } else {
                errorMessage = "Mật khẩu hiện tại không đúng.";
            }
        }

        if (success) {
            request.setAttribute("successMessage", "Đổi mật khẩu thành công.");
        } else {
            request.setAttribute("error", errorMessage != null ? errorMessage : "Không thể đổi mật khẩu.");
        }

        request.getRequestDispatcher("views/common/changepassword.jsp").forward(request, response);

    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("error", "Lỗi hệ thống khi đổi mật khẩu: " + e.getMessage());
        request.getRequestDispatcher("views/common/changepassword.jsp").forward(request, response);
    }
}
}

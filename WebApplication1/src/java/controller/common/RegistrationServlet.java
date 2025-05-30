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
        // Lấy giá trị 'role' từ form đăng ký, đây là bước đầu tiên liên quan đến chia role.
        // Người dùng gửi giá trị role (ví dụ: "User", "Admin") qua form.
        String role = request.getParameter("role");

        // Giữ lại giá trị role trong request để hiển thị lại trên form nếu có lỗi.
        // Điều này đảm bảo người dùng không phải nhập lại role khi đăng ký thất bại.
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

        // Kiểm tra giá trị role có null hoặc rỗng không.
        // Đây là bước xác thực cơ bản để đảm bảo người dùng phải cung cấp role khi đăng ký.
        if (role == null || role.trim().isEmpty()) {
            request.setAttribute("error", "Role không được để trống.");
            request.setAttribute("form", "register"); // Stay on registration form
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            return;
        }

        try {
            // Gọi phương thức registerUser của UserService và truyền 'role' vào.
            // Đây là phần quan trọng liên quan đến chia role: giá trị role được gửi đến tầng service
            // để lưu vào cơ sở dữ liệu hoặc xử lý theo logic phân quyền.
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
            // Xử lý lỗi SQL, có thể liên quan đến role nếu cơ sở dữ liệu có ràng buộc về role.
            // Ví dụ: nếu bảng users yêu cầu role phải thuộc tập giá trị nhất định (enum, constraint).
            if (e.getMessage().contains("Tên không được để trống")) {
                try {
                    // Thử đăng ký lại, tiếp tục truyền 'role' vào UserService.
                    // Điều này cho thấy role vẫn được sử dụng trong quá trình đăng ký lại.
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
            // Xử lý lỗi IllegalArgumentException, có thể liên quan đến role
            // nếu UserService ném ngoại lệ khi role không hợp lệ (ví dụ: giá trị không được định nghĩa trước).
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
package controller.admin;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.service.UserService;
// import org.mindrot.jbcrypt.BCrypt; // KHÔNG CẦN DÙNG TRỰC TIẾP BCrypt Ở ĐÂY NỮA

@WebServlet(name = "AddEmployeeServlet", urlPatterns = {"/AddEmployeeServlet", "/admin/viewEmployees"})
public class AddEmployeeServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Retrieve form parameters
        String fullName = request.getParameter("fullName");
        String gender = request.getParameter("gender");
        String dobStr = request.getParameter("dob");
        String specialization = request.getParameter("specialization");
        String role = request.getParameter("role");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        // Retain form values in case of error
        request.setAttribute("fullName", fullName);
        request.setAttribute("gender", gender);
        request.setAttribute("dob", dobStr);
        request.setAttribute("specialization", specialization);
        request.setAttribute("role", role);
        request.setAttribute("username", username);
        request.setAttribute("password", password); // Giữ lại để hiển thị lỗi, nhưng không dùng để tạo user
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
        request.setAttribute("address", address);

        Date dob = null;
        try {
            if (dobStr != null && !dobStr.trim().isEmpty()) {
                dob = Date.valueOf(dobStr);
            }
        } catch (IllegalArgumentException e) {
            // Không cần ném ngoại lệ ở đây, UserService sẽ kiểm tra null và ném lỗi
            // Nếu dobStr không đúng định dạng, Date.valueOf sẽ ném IllegalArgumentException
            // UserService sẽ bắt lỗi này khi dob là null và validateDob được gọi
        }

        // Get the admin ID from session
        HttpSession session = request.getSession();
        // Lấy UserID của admin đang đăng nhập. Đảm bảo bạn đã lưu nó vào session khi admin đăng nhập
        Integer createdBy = (Integer) session.getAttribute("loggedInUserId"); // Sử dụng tên thuộc tính session hợp lý
        if (createdBy == null) {
            // Nếu không tìm thấy, có thể là lỗi session hoặc admin chưa đăng nhập.
            // Cần xử lý phù hợp hơn cho môi trường production (ví dụ: chuyển hướng về trang đăng nhập)
            System.err.println("Admin ID not found in session, defaulting to 1.");
            createdBy = 1; // Giá trị mặc định cho mục đích thử nghiệm nếu không có session adminId
        }

        try {
            // KHÔNG CẦN VALIDATE DỮ LIỆU Ở ĐÂY NỮA. CHỈ CẦN THU THẬP VÀ GỌI SERVICE.
            // UserService sẽ đảm nhiệm toàn bộ logic validation và ném lỗi nếu có vấn đề.

            // KHÔNG HASH MẬT KHẨU Ở ĐÂY. Để UserService làm việc đó.
            boolean success = userService.addUser(fullName, gender, dob, specialization, role, "Active", email, phone, address, username, password, createdBy);

            if (success) {
                session.setAttribute("successMessage", "Thêm nhân viên thành công!");
                response.sendRedirect(request.getContextPath() + "/ViewEmployeeServlet");
            } else {
                request.setAttribute("error", "Không thể thêm nhân viên. Email, username hoặc số điện thoại có thể đã tồn tại.");
                request.getRequestDispatcher("/views/admin/AddEmployees.jsp").forward(request, response);
            }
        } catch (SQLException | IllegalArgumentException e) { // Bắt cả SQLException và IllegalArgumentException từ UserService
            System.err.println("Lỗi khi thêm nhân viên: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage()); // Hiển thị thông báo lỗi chi tiết từ Service
            request.getRequestDispatcher("/views/admin/AddEmployees.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        if (path.equals("/AddEmployeeServlet")) {
            request.getRequestDispatcher("/views/admin/AddEmployees.jsp").forward(request, response);
        } else if (path.equals("/admin/viewEmployees")) {
            response.sendRedirect(request.getContextPath() + "/ViewEmployeeServlet");
        }
    }
}
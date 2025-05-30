package controller.admin;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.time.LocalDate;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.service.UserService;
import org.mindrot.jbcrypt.BCrypt; // Thêm import cho BCrypt

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
        request.setAttribute("password", password);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
        request.setAttribute("address", address);

        // Validate inputs
        try {
            // Validate fullName: chỉ chứa chữ cái (Unicode) và dấu cách
            if (fullName == null || fullName.trim().isEmpty()) {
                throw new IllegalArgumentException("Tên không được để trống.");
            }
            if (!fullName.matches("^[\\p{L}\\s]+$")) {
                throw new IllegalArgumentException("Tên chỉ được chứa chữ cái và dấu cách.");
            }

            // Validate gender: phải là "Nam", "Nữ", hoặc "Khác"
            if (gender == null || gender.trim().isEmpty()) {
                throw new IllegalArgumentException("Giới tính không được để trống.");
            }
            String trimmedGender = gender.trim();
            if (!trimmedGender.equals("Nam") && !trimmedGender.equals("Nữ") && !trimmedGender.equals("Khác")) {
                throw new IllegalArgumentException("Giới tính phải là 'Nam', 'Nữ', hoặc 'Khác'.");
            }

            // Validate dob: không vượt quá ngày hiện tại
            Date dob;
            try {
                dob = Date.valueOf(dobStr);
                LocalDate currentDate = LocalDate.now(); // 06:04 PM +07, Sunday, May 25, 2025
                LocalDate dobDate = dob.toLocalDate();
                if (dobDate.isAfter(currentDate)) {
                    throw new IllegalArgumentException("Ngày sinh không được vượt quá thời gian thực.");
                }
            } catch (IllegalArgumentException e) {
                throw new IllegalArgumentException("Ngày sinh không hợp lệ.");
            }

            // Validate role: phải là "doctor", "nurse", hoặc "receptionist"
            if (role == null || role.trim().isEmpty()) {
                throw new IllegalArgumentException("Vai trò không được để trống.");
            }
            String trimmedRole = role.trim().toLowerCase();
            if (!trimmedRole.equals("doctor") && !trimmedRole.equals("nurse") && !trimmedRole.equals("receptionist")) {
                throw new IllegalArgumentException("Vai trò phải là 'doctor', 'nurse', hoặc 'receptionist'.");
            }

            // Validate specialization: bắt buộc nếu role là "doctor" hoặc "nurse"
            if ((trimmedRole.equals("doctor") || trimmedRole.equals("nurse")) && 
                (specialization == null || specialization.trim().isEmpty())) {
                throw new IllegalArgumentException("Chuyên môn là bắt buộc cho bác sĩ hoặc y tá.");
            }

            // Validate email: phải kết thúc bằng "@gmail.com"
            if (email == null || email.trim().isEmpty() || !email.endsWith("@gmail.com") || email.equals("@gmail.com")) {
                throw new IllegalArgumentException("Email phải có đuôi @gmail.com.");
            }

            // Validate phone: nếu không rỗng, phải là 10 chữ số
            if (phone != null && !phone.trim().isEmpty() && !phone.matches("\\d{10}")) {
                throw new IllegalArgumentException("Số điện thoại phải là 10 chữ số.");
            }

            // Validate address: không được để trống
            if (address == null || address.trim().isEmpty()) {
                throw new IllegalArgumentException("Địa chỉ không được để trống.");
            }

            // Validate username: chỉ chứa chữ cái và số
            if (username == null || username.trim().isEmpty()) {
                throw new IllegalArgumentException("Tên đăng nhập không được để trống.");
            }
            if (!username.matches("^[a-zA-Z0-9]+$")) {
                throw new IllegalArgumentException("Tên đăng nhập chỉ được chứa chữ cái và số.");
            }

            // Validate password: ít nhất 8 ký tự, 1 chữ cái in hoa, 1 ký tự đặc biệt, 1 số
            if (password == null || password.length() < 8 || 
                !password.matches("^(?=.*[A-Z])(?=.*[!@#$%^&*])(?=.*\\d).+$")) {
                throw new IllegalArgumentException("Mật khẩu phải có ít nhất 8 ký tự, 1 chữ cái in hoa, 1 ký tự đặc biệt và 1 số.");
            }

            // Mã hóa mật khẩu bằng BCrypt
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

            // Get the admin ID from session
            HttpSession session = request.getSession();
            Integer createdBy = (Integer) session.getAttribute("adminId");
            if (createdBy == null) {
                createdBy = 35; // Gán admin ID khớp với database
            }

            // Set default status as "Active"
            String status = "Active";

            // Call UserService to add the user with hashed password
            boolean success = userService.addUser(fullName, gender, dob, specialization, role, status, email, phone, address, username, hashedPassword, createdBy);
            if (success) {
                // Set success message in session and redirect to ViewEmployeeServlet
                session.setAttribute("successMessage", "Thêm nhân viên thành công!");
                response.sendRedirect(request.getContextPath() + "/ViewEmployeeServlet");
            } else {
                request.setAttribute("error", "Không thể thêm nhân viên. Email, username hoặc số điện thoại có thể đã tồn tại.");
                request.getRequestDispatcher("/views/admin/AddEmployees.jsp").forward(request, response);
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/views/admin/AddEmployees.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi thêm nhân viên: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/AddEmployees.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        if (path.equals("/AddEmployeeServlet")) {
            // Forward to AddEmployees.jsp for adding a new employee
            request.getRequestDispatcher("/views/admin/AddEmployees.jsp").forward(request, response);
        } else if (path.equals("/admin/viewEmployees")) {
            // Redirect to ViewEmployeeServlet to display the list of employees
            response.sendRedirect(request.getContextPath() + "/ViewEmployeeServlet");
        }
    }
}
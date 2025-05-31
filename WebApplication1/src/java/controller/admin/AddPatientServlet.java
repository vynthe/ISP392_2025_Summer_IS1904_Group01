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

@WebServlet(name = "AddPatientServlet", urlPatterns = {"/AddPatientServlet"})
public class AddPatientServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/admin/AddPatient.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Retrieve form parameters
        String fullName = request.getParameter("fullName");
        String gender = request.getParameter("gender");
        String dobStr = request.getParameter("dob");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Retain form values in case of error
        request.setAttribute("fullName", fullName);
        request.setAttribute("gender", gender);
        request.setAttribute("dob", dobStr);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
        request.setAttribute("address", address);
        request.setAttribute("username", username);
        request.setAttribute("password", password);

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
                LocalDate currentDate = LocalDate.now(); // 10:15 AM +07, Monday, May 26, 2025
                LocalDate dobDate = dob.toLocalDate();
                if (dobDate.isAfter(currentDate)) {
                    throw new IllegalArgumentException("Ngày sinh không được vượt quá thời gian thực.");
                }
            } catch (IllegalArgumentException e) {
                throw new IllegalArgumentException("Ngày sinh không hợp lệ.");
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
                System.out.println("Không tìm thấy adminId trong session, sử dụng giá trị mặc định: " + createdBy);
            }

            // Role mặc định là "patient"
            String role = "patient";
            // Status mặc định "Active"
            String status = "Active";

            // Call UserService to add the user with hashed password
            boolean success = userService.addUser(fullName, gender, dob, null, role, status, email, phone, address, username, hashedPassword, createdBy);
            if (success) {
                System.out.println("Thêm bệnh nhân thành công: " + fullName + ", Email: " + email);
                session.setAttribute("successMessage", "Thêm bệnh nhân thành công!");
                response.sendRedirect(request.getContextPath() + "/ViewPatientServlet");
            } else {
                System.out.println("Thêm bệnh nhân thất bại: Email, username hoặc số điện thoại có thể đã tồn tại.");
                request.setAttribute("error", "Không thể thêm bệnh nhân. Email, username hoặc số điện thoại có thể đã tồn tại.");
                request.getRequestDispatcher("/views/admin/AddPatient.jsp").forward(request, response);
            }
        } catch (IllegalArgumentException e) {
            System.out.println("Lỗi dữ liệu: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/views/admin/AddPatient.jsp").forward(request, response);
        } catch (SQLException e) {
            System.out.println("Lỗi SQL: " + e.getMessage() + ", SQLState: " + e.getSQLState() + ", Error Code: " + e.getErrorCode());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi thêm bệnh nhân: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/AddPatient.jsp").forward(request, response);
        }
    }
}
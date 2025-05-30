package model.service;

import java.sql.SQLException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import model.dao.UserDAO;
import model.entity.Users;
import org.mindrot.jbcrypt.BCrypt;

public class UserService {

    private final UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

   // Đăng ký tài khoản người dùng mới
public boolean registerUser(String username, String email, String password, String role, String phone) throws SQLException {
    try {
        // Kiểm tra sự tồn tại của email hoặc username
        if (userDAO.isEmailOrUsernameExists(email, username)) {
            System.err.println("Email hoặc username đã tồn tại: " + email + " / " + username);
            return false;
        }

        // Kiểm tra sự tồn tại của số điện thoại (nếu có)
        if (phone != null && !phone.trim().isEmpty()) {
            if (userDAO.isPhoneExists(phone)) {
                System.err.println("Số điện thoại đã tồn tại: " + phone);
                return false;
            }
        } else {
            phone = null; // Đảm bảo phone là null nếu chuỗi rỗng
        }

        // Validate và mã hóa mật khẩu
        validatePassword(password);
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

        // Tạo đối tượng Users
        Users user = new Users();
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(hashedPassword);
        user.setRole(role);
        user.setPhone(phone);
        user.setFullName(null); // Đặt rõ ràng là null trong bước đăng ký cơ bản
        user.setDob(null);      // Đặt các trường khác là null để người dùng hoàn thiện sau
        user.setGender(null);
        user.setAddress(null);
        user.setSpecialization(null);
        user.setMedicalHistory(null); // Nếu có trường này
        user.setStatus("Active");     // Đặt mặc định theo cấu trúc DB
        user.setCreatedBy(null);      // Không có thông tin CreatedBy trong đăng ký cơ bản
        user.setCreatedAt(new java.sql.Date(System.currentTimeMillis())); // Đảm bảo kiểu dữ liệu phù hợp với DB
        user.setUpdatedAt(null);      // Đặt UpdatedAt là null (sẽ được DB tự cập nhật)

        // Gọi DAO để lưu vào DB
        boolean success = userDAO.registerUserBasic(user);
        if (!success) {
            System.err.println("Không thể đăng ký người dùng: " + username);
        }
        return success;

    } catch (SQLException e) {
        System.err.println("Lỗi khi đăng ký người dùng: " + e.getMessage());
        e.printStackTrace();
        throw e;
    }
}

    // Kiểm tra username/email đã tồn tại
    public boolean isEmailOrUsernameExists(String email, String username) throws SQLException {
        return userDAO.isEmailOrUsernameExists(email, username);
    }

    // Validate phone number: must be exactly 10 digits or null/empty
    private void validatePhoneNumber(String phone) throws IllegalArgumentException {
        if (phone != null && !phone.trim().isEmpty() && !phone.matches("\\d{10}")) {
            throw new IllegalArgumentException("Phone number must be exactly 10 digits.");
        }
    }

    // Xác thực người dùng khi đăng nhập
    public Users authenticateUser(String emailOrUsername, String password) throws SQLException {
        Users user = userDAO.findUserByEmailOrUsername(emailOrUsername);
        if (user == null) {
            return null;
        }
        if (BCrypt.checkpw(password, user.getPassword())) {
            return user;
        }
        return null;
    }

    // Kiểm tra xem user đã hoàn thiện hồ sơ chưa
    public boolean isProfileComplete(Users user) {
        return user.getFullName() != null && !user.getFullName().trim().isEmpty()
                && user.getDob() != null
                && user.getGender() != null && !user.getGender().trim().isEmpty()
                && user.getPhone() != null && !user.getPhone().trim().isEmpty()
                && user.getAddress() != null && !user.getAddress().trim().isEmpty();
    }

    public boolean isPhoneExists(String phone) throws SQLException {
        return userDAO.isPhoneExists(phone);
    }

    // Cập nhật thông tin hồ sơ của user
    public void updateUserProfile(Users user) throws SQLException {
        userDAO.updateUserProfile(user);
    }

    public void validateFullName(String fullName) throws SQLException {
        if (fullName != null && !fullName.trim().isEmpty()) {
            if (!fullName.matches("^[\\p{L}\\s]+$")) {
                throw new SQLException("Tên chỉ được chứa chữ cái và dấu cách.");
            }
        } else {
            // Cho phép fullName là null hoặc chuỗi rỗng nếu phù hợp với yêu cầu
            // Nếu muốn bắt buộc, ném lỗi: throw new SQLException("Tên không được để trống.");
        }
    }

    // Validate username: chỉ chứa chữ cái và số
    private void validateUsername(String username) throws SQLException {
        if (username == null || username.trim().isEmpty()) {
            throw new SQLException("Tên đăng nhập không được để trống.");
        }
        if (!username.matches("^[a-zA-Z0-9]+$")) {
            throw new SQLException("Tên đăng nhập chỉ được chứa chữ cái và số.");
        }
    }

    // Validate email: must end with @gmail.com
    private void validateEmail(String email) throws IllegalArgumentException {
        if (email == null || email.trim().isEmpty() || !email.endsWith("@gmail.com") || email.equals("@gmail.com")) {
            throw new IllegalArgumentException("Email phải có đuôi @gmail.com.");
        }
    }

    // Validate DOB: must be between 1900 and current date
    private void validateDob(Date dob) throws IllegalArgumentException {
        LocalDate currentDate = LocalDate.now(); // Current date: 06:09 PM +07, Sunday, May 25, 2025
        LocalDate dobDate = dob.toLocalDate();
        
        // Kiểm tra năm sinh không vượt quá thời gian hiện tại
        if (dobDate.isAfter(currentDate)) {
            throw new IllegalArgumentException("Năm sinh không được vượt quá thời gian thực.");
        }
        
        // Kiểm tra năm sinh không nhỏ hơn 1900
        if (dobDate.getYear() < 1900) {
            throw new IllegalArgumentException("Năm sinh phải từ năm 1900 trở lên.");
        }
    }

    // Validate password: at least 8 chars, 1 uppercase, 1 special char, 1 digit
    private void validatePassword(String password) throws IllegalArgumentException {
        if (password == null || password.length() < 8
                || !password.matches("^(?=.*[A-Z])(?=.*[!@#$%^&*])(?=.*\\d).+$")) {
            throw new IllegalArgumentException("Mật khẩu phải có ít nhất 8 ký tự, 1 chữ cái in hoa, 1 ký tự đặc biệt và 1 số.");
        }
    }

    // New method to update password
    public boolean updatePassword(String email, String newPassword) throws SQLException {
        validateEmail(email);
        validatePassword(newPassword);
        String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        return userDAO.updatePassword(email, hashedPassword);
    }

    public Users getUserByID(int userID) throws SQLException {
        return userDAO.getUserByID(userID);
    }

    // New method to add user
    public boolean addUser(String fullName, String gender, Date dob, String specialization, String role, String status, String email, String phone, String address, String username, String password, int createdBy) throws SQLException {
        // Validate inputs
        validateEmail(email);
        validatePhoneNumber(phone);
        validateDob(dob);
        validatePassword(password);

        // Check for existing email, username, or phone
        if (userDAO.isEmailOrUsernameExists(email, username)) {
            return false;
        }
        if (phone != null && !phone.trim().isEmpty() && userDAO.isPhoneExists(phone)) {
            return false;
        }

        // Map gender to match database values
        String mappedGender = gender;
        if (mappedGender != null && !mappedGender.trim().isEmpty()) {
            mappedGender = mappedGender.trim();
            if (mappedGender.equals("Nam")) {
                mappedGender = "Male";
            } else if (mappedGender.equals("Nữ")) {
                mappedGender = "Female";
            } else if (mappedGender.equals("Khác")) {
                mappedGender = "Other";
            }
        } else {
            mappedGender = null; // Allow NULL as per database schema
        }

        // Create Users object
        Users user = new Users();
        user.setFullName(fullName);
        user.setGender(mappedGender);
        user.setDob(dob);
        user.setSpecialization(specialization);
        user.setRole(role);
        user.setStatus(status);
        user.setEmail(email);
        user.setPhone(phone);
        user.setAddress(address);
        user.setUsername(username);
        user.setPassword(password); // Password should already be hashed by caller (e.g., AddEmployeeServlet)
        user.setCreatedBy(createdBy);

        // Call DAO to add user
        return userDAO.addUser(user, createdBy);
    }

    public List<Users> getAllEmployee() throws SQLException {
        List<Users> users = userDAO.getAllEmployee();
        return users != null ? users : new ArrayList<>();
    }

    public Users getEmployeeByID(int userID) throws SQLException {
        return userDAO.getEmployeeByID(userID);
    }

    public List<Users> getAllPatient() throws SQLException {
        List<Users> users = userDAO.getAllPatient();
        return users != null ? users : new ArrayList<>();
    }

    public Users getPatientByID(int userID) throws SQLException {
        return userDAO.getPatientByID(userID);
    }

    public boolean UpdateEmployee(Users user) throws SQLException {
        try {
            // Validate required fields (skip status validation)
            if (user.getFullName() == null || user.getFullName().trim().isEmpty()) {
                throw new SQLException("Họ và tên không được để trống.");
            }
            if (user.getDob() == null) {
                throw new SQLException("Ngày sinh không được để trống.");
            }
            if (user.getGender() == null || user.getGender().trim().isEmpty()) {
                throw new SQLException("Giới tính không được để trống.");
            }
            if (user.getSpecialization() == null || user.getSpecialization().trim().isEmpty()) {
                throw new SQLException("Chuyên khoa không được để trống.");
            }

            // Map gender to match database values
            String mappedGender = user.getGender().trim();
            System.out.println("Original gender: " + mappedGender);
            if (mappedGender.equals("Nam")) {
                mappedGender = "Male";
            } else if (mappedGender.equals("Nữ")) {
                mappedGender = "Female";
            } else if (mappedGender.equals("Khác")) {
                mappedGender = "Other";
            } else {
                throw new SQLException("Giới tính không hợp lệ: " + user.getGender());
            }
            user.setGender(mappedGender);
            System.out.println("Mapped gender: " + mappedGender);

            // Ensure status is "Active" (override if provided)
            user.setStatus("Active");

            boolean result = userDAO.UpdateEmployee(user);
            System.out.println("DAO updateEmployee result: " + result);
            return result;
        } catch (SQLException e) {
            System.out.println("SQLException in UserService.updateEmployee: " + e.getMessage());
            throw new SQLException("Lỗi khi cập nhật nhân viên: " + e.getMessage(), e);
        }
    }

    public boolean deleteEmployee(int userID) throws SQLException {
        if (userID <= 0) {
            throw new SQLException("ID nhân viên không hợp lệ.");
        }
        return userDAO.deleteEmployee(userID);
    }

    public boolean UpdatePatient(Users user) throws SQLException {
        try {
            // Validate required fields
            if (user.getFullName() == null || user.getFullName().trim().isEmpty()) {
                throw new SQLException("Họ và tên không được để trống.");
            }
            if (user.getDob() == null) {
                throw new SQLException("Ngày sinh không được để trống.");
            }
            if (user.getGender() == null || user.getGender().trim().isEmpty()) {
                throw new SQLException("Giới tính không được để trống.");
            }
            if (user.getPhone() == null || user.getPhone().trim().isEmpty() || !user.getPhone().matches("\\d{10}")) {
                throw new SQLException("Số điện thoại phải là 10 chữ số.");
            }
            if (user.getAddress() == null || user.getAddress().trim().isEmpty()) {
                throw new SQLException("Địa chỉ không được để trống.");
            }

            // Map gender to match database values
            String mappedGender = user.getGender().trim();
            System.out.println("Original gender: " + mappedGender);
            if (mappedGender.equals("Nam")) {
                mappedGender = "Male";
            } else if (mappedGender.equals("Nữ")) {
                mappedGender = "Female";
            } else {
                throw new SQLException("Giới tính không hợp lệ: " + user.getGender());
            }
            user.setGender(mappedGender);
            System.out.println("Mapped gender: " + mappedGender);

            // Ensure status is valid (default to "Active" if not provided)
            if (user.getStatus() == null || user.getStatus().trim().isEmpty()) {
                user.setStatus("Active");
            } else if (!user.getStatus().equals("Active") && !user.getStatus().equals("Inactive")) {
                throw new SQLException("Trạng thái không hợp lệ.");
            }

            boolean result = userDAO.UpdatePatient(user); // Sử dụng UpdatePatient cho vai trò Patient
            System.out.println("DAO updatePatient result: " + result);
            return result;
        } catch (SQLException e) {
            System.out.println("SQLException in UserService.updatePatient: " + e.getMessage());
            throw new SQLException("Lỗi khi cập nhật bệnh nhân: " + e.getMessage(), e);
        }
    }

    // Phương thức này dùng cho chức năng tìm kiếm nhân viên (gần đúng)
    public List<Users> searchEmployees(String keyword) throws SQLException {
        return userDAO.searchEmployees(keyword);
    }
      public List<Users> searchPatients(String keyword) throws SQLException {
        return userDAO.searchPatients(keyword);
    }
}
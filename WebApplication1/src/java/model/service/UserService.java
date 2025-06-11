package model.service;

import java.sql.SQLException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.dao.UserDAO;
import model.entity.Users;
import org.mindrot.jbcrypt.BCrypt;

public class UserService {

    private final UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

    public boolean registerUser(String username, String email, String password, String role, String phone) throws SQLException {
        try {
            username = username != null ? username.trim() : null;
            email = email != null ? email.trim() : null;
            password = password != null ? password.trim() : null;
            role = role != null ? role.trim() : null;
            phone = phone != null ? phone.trim() : null;

            if (username != null && username.length() > 20) throw new SQLException("Tên đăng nhập không được vượt quá 20 ký tự.");
            if (email != null && email.length() > 50) throw new SQLException("Email không được vượt quá 50 ký tự.");
            if (password != null && password.length() > 20) throw new SQLException("Mật khẩu không được vượt quá 20 ký tự.");

            if (userDAO.isEmailOrUsernameExists(email, username)) return false;
            if (phone != null && !phone.isEmpty() && userDAO.isPhoneExists(phone)) return false;

            validateUsername(username);
            validateEmail(email);
            validatePassword(password);
            validatePhoneNumber(phone);

            if (!role.equals("patient") && !role.equals("doctor") && !role.equals("nurse") && !role.equals("receptionist")) {
                throw new SQLException("Vai trò không hợp lệ.");
            }

            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
            Users user = new Users();
            user.setUsername(username);
            user.setEmail(email);
            user.setPassword(hashedPassword);
            user.setRole(role);
            user.setPhone(phone);
            user.setFullName(null);
            user.setDob(null);
            user.setGender(null);
            user.setAddress(null);
            user.setSpecialization(null);
            user.setMedicalHistory(null);
            user.setStatus("Active");
            user.setCreatedAt(new java.sql.Date(System.currentTimeMillis()));
            user.setUpdatedAt(null);

            return userDAO.registerUserBasic(user);
        } catch (SQLException e) {
            System.err.println("Lỗi khi đăng ký người dùng: " + e.getMessage());
            throw e;
        }
    }

    public boolean isEmailOrUsernameExists(String email, String username) throws SQLException {
        return userDAO.isEmailOrUsernameExists(email != null ? email.trim() : null, username != null ? username.trim() : null);
    }

    private void validatePhoneNumber(String phone) throws IllegalArgumentException {
        if (phone != null && !phone.isEmpty() && (!phone.matches("\\d{10}") || phone.length() > 10)) {
            throw new IllegalArgumentException("Số điện thoại phải là 10 chữ số.");
        }
    }

    public Users authenticateUser(String emailOrUsername, String password) throws SQLException {
        emailOrUsername = emailOrUsername != null ? emailOrUsername.trim() : null;
        password = password != null ? password.trim() : null;
        Users user = userDAO.findUserByEmailOrUsername(emailOrUsername);
        if (user == null || !BCrypt.checkpw(password, user.getPassword())) return null;
        return user;
    }

    public boolean isProfileComplete(Users user) {
        if (user == null) return false;
        String role = user.getRole() != null ? user.getRole().toLowerCase() : "";
        boolean basicCheck = user.getFullName() != null && !user.getFullName().trim().isEmpty() && user.getFullName().length() <= 100
                && user.getDob() != null
                && user.getGender() != null && !user.getGender().trim().isEmpty()
                && user.getPhone() != null && !user.getPhone().trim().isEmpty() && user.getPhone().length() <= 10;

        switch (role) {
            case "patient":
                return basicCheck && user.getAddress() != null && !user.getAddress().trim().isEmpty() && user.getAddress().length() <= 255;
            case "doctor":
            case "nurse":
                return basicCheck && user.getSpecialization() != null && !user.getSpecialization().trim().isEmpty() && user.getSpecialization().length() <= 100;
            case "receptionist":
                return basicCheck;
            default:
                return false;
        }
    }

    public boolean isPhoneExists(String phone) throws SQLException {
        return userDAO.isPhoneExists(phone != null ? phone.trim() : null);
    }

    public void updateUserProfile(Users user) throws SQLException {
        if (user.getUsername() != null && user.getUsername().length() > 20) throw new SQLException("Tên đăng nhập không được vượt quá 20 ký tự.");
        if (user.getEmail() != null && user.getEmail().length() > 50) throw new SQLException("Email không được vượt quá 50 ký tự.");
        if (user.getFullName() != null && user.getFullName().length() > 100) throw new SQLException("Họ và tên không được vượt quá 100 ký tự.");
        if (user.getPhone() != null && user.getPhone().length() > 10) throw new SQLException("Số điện thoại không được vượt quá 10 ký tự.");
        if (user.getAddress() != null && user.getAddress().length() > 255) throw new SQLException("Địa chỉ không được vượt quá 255 ký tự.");
        if (user.getSpecialization() != null && user.getSpecialization().length() > 100) throw new SQLException("Trình độ chuyên môn không được vượt quá 100 ký tự.");
        userDAO.updateUserProfile(user);
    }

    public void validateFullName(String fullName) throws SQLException {
        if (fullName != null && !fullName.trim().isEmpty() && fullName.length() > 100) {
            throw new SQLException("Tên chỉ được chứa chữ cái và dấu cách, tối đa 100 ký tự.");
        }
        if (fullName != null && !fullName.trim().isEmpty() && !fullName.matches("^[\\p{L}\\s]+$")) {
            throw new SQLException("Tên chỉ được chứa chữ cái và dấu cách.");
        }
    }

    public void validateUsername(String username) throws SQLException {
        if (username == null || username.trim().isEmpty()) throw new SQLException("Tên đăng nhập không được để trống.");
        if (!username.matches("^[a-zA-Z0-9]+$")) throw new SQLException("Tên đăng nhập chỉ được chứa chữ cái và số.");
        if (username.length() > 20) throw new SQLException("Tên đăng nhập không được vượt quá 20 ký tự.");
    }

    private void validateEmail(String email) throws IllegalArgumentException {
        if (email == null || email.trim().isEmpty() || !email.endsWith("@gmail.com") || email.equals("@gmail.com")) {
            throw new IllegalArgumentException("Email phải có đuôi @gmail.com.");
        }
        if (email.length() > 50) throw new IllegalArgumentException("Email không được vượt quá 50 ký tự.");
    }

    private void validatePassword(String password) throws IllegalArgumentException {
        if (password == null || password.length() < 8 || !password.matches("^(?=.*[A-Z])(?=.*[!@#$%^&*])(?=.*\\d).+$")) {
            throw new IllegalArgumentException("Mật khẩu phải có ít nhất 8 ký tự, 1 chữ cái in hoa, 1 ký tự đặc biệt và 1 số.");
        }
        if (password.length() > 20) throw new IllegalArgumentException("Mật khẩu không được vượt quá 20 ký tự.");
    }

    private void validateDob(Date dob) throws IllegalArgumentException {
        LocalDate currentDate = LocalDate.now();
        LocalDate dobDate = dob.toLocalDate();
        if (dobDate.isAfter(currentDate)) throw new IllegalArgumentException("Năm sinh không được vượt quá thời gian thực.");
        if (dobDate.getYear() < 1915) throw new IllegalArgumentException("Năm sinh phải từ năm 1915 trở lên.");
    }

    public boolean updatePassword(String email, String newPassword) throws SQLException {
        email = email != null ? email.trim() : null;
        newPassword = newPassword != null ? newPassword.trim() : null;
        validateEmail(email);
        validatePassword(newPassword);
        String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        return userDAO.updatePassword(email, hashedPassword);
    }

    public Users getUserByID(int userID) throws SQLException {
        return userDAO.getUserByID(userID);
    }

    public boolean addUser(String fullName, String gender, Date dob, String specialization, String role, String status, String email, String phone, String address, String username, String password, int createdBy) throws SQLException {
        fullName = fullName != null ? fullName.trim() : null;
        gender = gender != null ? gender.trim() : null;
        specialization = specialization != null ? specialization.trim() : null;
        role = role != null ? role.trim() : null;
        status = status != null ? status.trim() : null;
        email = email != null ? email.trim() : null;
        phone = phone != null ? phone.trim() : null;
        address = address != null ? address.trim() : null;
        username = username != null ? username.trim() : null;
        password = password != null ? password.trim() : null;

        if (username != null && username.length() > 20) throw new SQLException("Tên đăng nhập không được vượt quá 20 ký tự.");
        if (email != null && email.length() > 50) throw new SQLException("Email không được vượt quá 50 ký tự.");
        if (password != null && password.length() > 20) throw new SQLException("Mật khẩu không được vượt quá 20 ký tự.");
        if (fullName != null && fullName.length() > 100) throw new SQLException("Họ và tên không được vượt quá 100 ký tự.");
        if (phone != null && phone.length() > 10) throw new SQLException("Số điện thoại không được vượt quá 10 ký tự.");
        if (address != null && address.length() > 255) throw new SQLException("Địa chỉ không được vượt quá 255 ký tự.");
        if (specialization != null && specialization.length() > 100) throw new SQLException("Trình độ chuyên môn không được vượt quá 100 ký tự.");

        validateEmail(email);
        validatePhoneNumber(phone);
        validateDob(dob);
        validatePassword(password);

        if (userDAO.isEmailOrUsernameExists(email, username)) return false;
        if (phone != null && !phone.isEmpty() && userDAO.isPhoneExists(phone)) return false;

        String mappedGender = gender;
        if (mappedGender != null && !mappedGender.isEmpty()) {
            if (mappedGender.equals("Nam")) mappedGender = "Male";
            else if (mappedGender.equals("Nữ")) mappedGender = "Female";
            else if (mappedGender.equals("Khác")) mappedGender = "Other";
        } else {
            mappedGender = null;
        }

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
        user.setPassword(password);
        user.setCreatedBy(createdBy);

        return userDAO.addUser(user, createdBy);
    }

    public List<Users> getAllEmployee() throws SQLException {
        return userDAO.getAllEmployee() != null ? userDAO.getAllEmployee() : new ArrayList<>();
    }

    public Users getEmployeeByID(int userID) throws SQLException {
        return userDAO.getEmployeeByID(userID);
    }

    public List<Users> getAllPatient() throws SQLException {
        return userDAO.getAllPatient() != null ? userDAO.getAllPatient() : new ArrayList<>();
    }

    public Users getPatientByID(int userID) throws SQLException {
        return userDAO.getPatientByID(userID);
    }

    public boolean UpdateEmployee(Users user) throws SQLException {
        if (user.getFullName() == null || user.getFullName().trim().isEmpty() || user.getFullName().length() > 100) {
            throw new SQLException("Họ và tên không được để trống hoặc vượt quá 100 ký tự.");
        }
        if (user.getDob() == null) throw new SQLException("Ngày sinh không được để trống.");
        if (user.getGender() == null || user.getGender().trim().isEmpty()) throw new SQLException("Giới tính không được để trống.");
        if (user.getSpecialization() == null || user.getSpecialization().trim().isEmpty() || user.getSpecialization().length() > 100) {
            throw new SQLException("Chuyên khoa không được để trống hoặc vượt quá 100 ký tự.");
        }

        String mappedGender = user.getGender().trim();
        if (mappedGender.equals("Nam")) mappedGender = "Male";
        else if (mappedGender.equals("Nữ")) mappedGender = "Female";
        else if (mappedGender.equals("Khác")) mappedGender = "Other";
        else throw new SQLException("Giới tính không hợp lệ: " + user.getGender());
        user.setGender(mappedGender);
        user.setStatus("Active");

        return userDAO.UpdateEmployee(user);
    }

    public boolean deleteEmployee(int userID) throws SQLException {
        if (userID <= 0) throw new SQLException("ID nhân viên không hợp lệ.");
        return userDAO.deleteEmployee(userID);
    }

    public boolean UpdatePatient(Users user) throws SQLException {
        if (user.getFullName() == null || user.getFullName().trim().isEmpty() || user.getFullName().length() > 100) {
            throw new SQLException("Họ và tên không được để trống hoặc vượt quá 100 ký tự.");
        }
        if (user.getDob() == null) throw new SQLException("Ngày sinh không được để trống.");
        if (user.getGender() == null || user.getGender().trim().isEmpty()) throw new SQLException("Giới tính không được để trống.");
        if (user.getPhone() == null || user.getPhone().trim().isEmpty() || user.getPhone().length() > 10 || !user.getPhone().matches("\\d{10}")) {
            throw new SQLException("Số điện thoại phải là 10 chữ số.");
        }
        if (user.getAddress() == null || user.getAddress().trim().isEmpty() || user.getAddress().length() > 255) {
            throw new SQLException("Địa chỉ không được để trống hoặc vượt quá 255 ký tự.");
        }

        String mappedGender = user.getGender().trim();
        if (mappedGender.equals("Nam")) mappedGender = "Male";
        else if (mappedGender.equals("Nữ")) mappedGender = "Female";
        else throw new SQLException("Giới tính không hợp lệ: " + user.getGender());
        user.setGender(mappedGender);

        if (user.getStatus() == null || user.getStatus().trim().isEmpty()) user.setStatus("Active");
        else if (!user.getStatus().equals("Active") && !user.getStatus().equals("Inactive")) {
            throw new SQLException("Trạng thái không hợp lệ.");
        }

        return userDAO.UpdatePatient(user);
    }

    public List<Users> searchEmployees(String keyword) throws SQLException {
        return userDAO.searchEmployees(keyword != null ? keyword.trim() : "");
    }

    public List<Users> searchPatients(String keyword) throws SQLException {
        return userDAO.searchPatients(keyword != null ? keyword.trim() : "");
    }

    public List<Users> getUsersByRole(String role) throws SQLException {
        return userDAO.getUsersByRole(role != null ? role.trim() : "");
    }

    public Map<Integer, String> getEmployeeNameMap() throws SQLException {
        Map<Integer, String> employeeMap = new HashMap<>();
        List<Users> employees = userDAO.getAllEmployee();
        for (Users user : employees) {
            if (user.getUserID() > 0) {
                employeeMap.put(user.getUserID(), user.getFullName() != null ? user.getFullName().trim() : "Unknown Employee " + user.getUserID());
            }
        }
        return employeeMap;
    }
}
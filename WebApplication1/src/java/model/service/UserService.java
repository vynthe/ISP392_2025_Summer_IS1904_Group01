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
        username = (username != null) ? username.trim() : null;
        email = (email != null) ? email.trim() : null;
        password = (password != null) ? password.trim() : null;
        role = (role != null) ? role.trim() : null;
        phone = (phone != null) ? phone.trim() : null;

        try {
            if (username != null && username.length() > 20) {
                throw new SQLException("Tên đăng nhập không được vượt quá 20 ký tự.");
            }
            if (email != null && email.length() > 50) {
                throw new SQLException("Email không được vượt quá 50 ký tự.");
            }

            validateUsername(username);
            validateEmail(email);
            validatePassword(password);
            validatePhoneNumber(phone);

            if (userDAO.isEmailOrUsernameExists(email, username)) {
                throw new SQLException("Email hoặc tên đăng nhập đã tồn tại.");
            }
            if (phone != null && !phone.isEmpty() && userDAO.isPhoneExists(phone)) {
                throw new SQLException("Số điện thoại đã tồn tại.");
            }

            List<String> validRoles = List.of("patient", "doctor", "nurse", "receptionist");
            if (role == null || !validRoles.contains(role.toLowerCase())) {
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
        } catch (IllegalArgumentException e) {
            System.err.println("Lỗi xác thực dữ liệu: " + e.getMessage());
            throw new SQLException(e.getMessage(), e);
        }
    }

    public boolean isEmailOrUsernameExists(String email, String username) throws SQLException {
        email = (email != null) ? email.trim() : null;
        username = (username != null) ? username.trim() : null;
        return userDAO.isEmailOrUsernameExists(email, username);
    }

    private void validatePhoneNumber(String phone) throws IllegalArgumentException {
        String trimmedPhone = (phone != null) ? phone.trim() : null;

        if (trimmedPhone != null && !trimmedPhone.isEmpty()) {
            if (!trimmedPhone.matches("^\\d{10}$")) {
                throw new IllegalArgumentException("Số điện thoại phải có đủ 10 chữ số.");
            }
            if (!trimmedPhone.startsWith("0")) {
                throw new IllegalArgumentException("Số điện thoại phải bắt đầu bằng số 0.");
            }
        }
    }

    public Users authenticateUser(String emailOrUsername, String password) throws SQLException {
        emailOrUsername = (emailOrUsername != null) ? emailOrUsername.trim() : null;
        password = (password != null) ? password.trim() : null;

        Users user = userDAO.findUserByEmailOrUsername(emailOrUsername);
        if (user == null) {
            return null;
        }
        if (!BCrypt.checkpw(password, user.getPassword())) {
            return null;
        }
        return user;
    }

    public boolean isProfileComplete(Users user) {
        if (user == null) {
            return false;
        }

        String role = (user.getRole() != null) ? user.getRole().trim().toLowerCase() : "";
        String fullName = (user.getFullName() != null) ? user.getFullName().trim() : "";
        String gender = (user.getGender() != null) ? user.getGender().trim() : "";
        String phone = (user.getPhone() != null) ? user.getPhone().trim() : "";
        String address = (user.getAddress() != null) ? user.getAddress().trim() : "";
        String specialization = (user.getSpecialization() != null) ? user.getSpecialization().trim() : "";

        boolean basicCheck = !fullName.isEmpty() && fullName.length() <= 100
                && user.getDob() != null
                && !gender.isEmpty()
                && !phone.isEmpty() && phone.length() <= 10;

        switch (role) {
            case "patient":
                return basicCheck && !address.isEmpty() && address.length() <= 255;
            case "doctor":
            case "nurse":
                return basicCheck && !specialization.isEmpty() && specialization.length() <= 100;
            case "receptionist":
                return basicCheck;
            default:
                return false;
        }
    }

    public boolean isPhoneExists(String phone) throws SQLException {
        return userDAO.isPhoneExists((phone != null) ? phone.trim() : null);
    }

    public void updateUserProfile(Users user) throws SQLException {
        if (user == null) {
            throw new SQLException("Thông tin người dùng không được để trống.");
        }

        if (user.getUsername() != null) user.setUsername(user.getUsername().trim());
        if (user.getEmail() != null) user.setEmail(user.getEmail().trim());
        if (user.getFullName() != null) user.setFullName(user.getFullName().trim());
        if (user.getPhone() != null) user.setPhone(user.getPhone().trim());
        if (user.getAddress() != null) user.setAddress(user.getAddress().trim());
        if (user.getMedicalHistory() != null) user.setMedicalHistory(user.getMedicalHistory().trim());
        if (user.getSpecialization() != null) user.setSpecialization(user.getSpecialization().trim());
        if (user.getGender() != null) user.setGender(user.getGender().trim());

        validateUsername(user.getUsername());
        validateEmail(user.getEmail());
        validatePhoneNumber(user.getPhone());
        validateFullName(user.getFullName());
        validateDob(user.getDob());

        if (user.getUsername() != null && user.getUsername().length() > 20) throw new SQLException("Tên đăng nhập không được vượt quá 20 ký tự.");
        if (user.getEmail() != null && user.getEmail().length() > 50) throw new SQLException("Email không được vượt quá 50 ký tự.");
        if (user.getFullName() != null && user.getFullName().length() > 100) throw new SQLException("Họ và tên không được vượt quá 100 ký tự.");
        if (user.getPhone() != null && user.getPhone().length() > 10) throw new SQLException("Số điện thoại không được vượt quá 10 ký tự.");
        if (user.getAddress() != null && user.getAddress().length() > 255) throw new SQLException("Địa chỉ không được vượt quá 255 ký tự.");
        if (user.getSpecialization() != null && user.getSpecialization().length() > 100) throw new SQLException("Trình độ chuyên môn không được vượt quá 100 ký tự.");

        userDAO.updateUserProfile(user);
    }

    public void validateFullName(String fullName) throws SQLException {
        String trimmedFullName = (fullName != null) ? fullName.trim() : null;

        if (trimmedFullName == null || trimmedFullName.isEmpty()) {
            throw new SQLException("Họ và tên không được để trống.");
        }
        if (trimmedFullName.length() > 100) {
            throw new SQLException("Họ và tên không được vượt quá 100 ký tự.");
        }
        if (!trimmedFullName.matches("^[\\p{L}\\s]+$")) {
            throw new SQLException("Họ và tên chỉ được chứa chữ cái và dấu cách.");
        }
    }

    public void validateUsername(String username) throws SQLException {
        String trimmedUsername = (username != null) ? username.trim() : null;
        if (trimmedUsername == null || trimmedUsername.isEmpty()) throw new SQLException("Tên đăng nhập không được để trống.");
        if (!trimmedUsername.matches("^[a-zA-Z0-9]+$")) throw new SQLException("Tên đăng nhập chỉ được chứa chữ cái và số.");
        if (trimmedUsername.length() > 20) throw new SQLException("Tên đăng nhập không được vượt quá 20 ký tự.");
    }

    private void validateEmail(String email) throws IllegalArgumentException {
        String trimmedEmail = (email != null) ? email.trim() : null;
        if (trimmedEmail == null || trimmedEmail.isEmpty() || !trimmedEmail.endsWith("@gmail.com") || trimmedEmail.equals("@gmail.com")) {
            throw new IllegalArgumentException("Email phải có đuôi @gmail.com và không được để trống.");
        }
        if (trimmedEmail.length() > 50) throw new IllegalArgumentException("Email không được vượt quá 50 ký tự.");
    }

    private void validatePassword(String password) throws IllegalArgumentException {
        String trimmedPassword = (password != null) ? password.trim() : null;
        if (trimmedPassword == null || trimmedPassword.isEmpty()) {
            throw new IllegalArgumentException("Mật khẩu không được để trống.");
        }
        if (trimmedPassword.length() <= 8) {
            throw new IllegalArgumentException("Mật khẩu phải có trên 8 ký tự.");
        }
        if (!trimmedPassword.matches("^(?=.*[A-Z])(?=.*[!@#$%^&*])(?=.*\\d).+$")) {
            throw new IllegalArgumentException("Mật khẩu phải chứa ít nhất 1 chữ cái in hoa, 1 ký tự đặc biệt (!@#$%^&*) và 1 số.");
        }
    }

    private void validateDob(Date dob) throws IllegalArgumentException {
        if (dob == null) throw new IllegalArgumentException("Ngày sinh không được để trống.");
        LocalDate currentDate = LocalDate.now();
        LocalDate dobDate = dob.toLocalDate();
        if (dobDate.isAfter(currentDate)) throw new IllegalArgumentException("Ngày sinh không được vượt quá thời gian thực.");
        if (dobDate.getYear() < 1915) throw new IllegalArgumentException("Năm sinh phải từ năm 1915 trở lên.");
    }

    public boolean updatePassword(String email, String newPassword) throws SQLException {
        email = (email != null) ? email.trim() : null;
        newPassword = (newPassword != null) ? newPassword.trim() : null;
        validateEmail(email);
        validatePassword(newPassword);
        String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        return userDAO.updatePassword(email, hashedPassword);
    }

    public Users getUserByID(int userID) throws SQLException {
        return userDAO.getUserByID(userID);
    }

    public boolean addUser(String fullName, String gender, Date dob, String specialization, String role, String status, String email, String phone, String address, String username, String password, int createdBy) throws SQLException {
        fullName = (fullName != null) ? fullName.trim() : null;
        gender = (gender != null) ? gender.trim() : null;
        specialization = (specialization != null) ? specialization.trim() : null;
        role = (role != null) ? role.trim() : null;
        status = (status != null) ? status.trim() : null;
        email = (email != null) ? email.trim() : null;
        phone = (phone != null) ? phone.trim() : null;
        address = (address != null) ? address.trim() : null;
        username = (username != null) ? username.trim() : null;
        password = (password != null) ? password.trim() : null;

        validateUsername(username);
        validateEmail(email);
        validatePhoneNumber(phone);
        validateFullName(fullName);
        validateDob(dob);
        validatePassword(password);

        if (userDAO.isEmailOrUsernameExists(email, username)) {
            throw new SQLException("Email hoặc tên đăng nhập đã tồn tại.");
        }
        if (phone != null && !phone.isEmpty() && userDAO.isPhoneExists(phone)) {
            throw new SQLException("Số điện thoại đã tồn tại.");
        }

        String mappedGender = gender;
        if (mappedGender != null && !mappedGender.isEmpty()) {
            if ("Nam".equalsIgnoreCase(mappedGender)) {
                mappedGender = "Male";
            } else if ("Nữ".equalsIgnoreCase(mappedGender)) {
                mappedGender = "Female";
            } else if ("Khác".equalsIgnoreCase(mappedGender)) {
                mappedGender = "Other";
            } else {
                throw new SQLException("Giới tính không hợp lệ.");
            }
        } else {
            mappedGender = null;
        }

        List<String> validRoles = List.of("patient", "doctor", "nurse", "receptionist", "admin");
        if (role == null || !validRoles.contains(role.toLowerCase())) {
            throw new SQLException("Vai trò không hợp lệ.");
        }

        List<String> validStatuses = List.of("Active", "Inactive");
        if (status == null || !validStatuses.contains(status)) {
            status = "Active";
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
        user.setPassword(BCrypt.hashpw(password, BCrypt.gensalt()));
        user.setCreatedBy(createdBy);

        return userDAO.addUser(user, createdBy);
    }

    public List<Users> getAllEmployee() throws SQLException {
        List<Users> employees = userDAO.getAllEmployee();
        return (employees != null) ? employees : new ArrayList<>();
    }

    public Users getEmployeeByID(int userID) throws SQLException {
        return userDAO.getEmployeeByID(userID);
    }

    public List<Users> getAllPatient() throws SQLException {
        List<Users> patients = userDAO.getAllPatient();
        return (patients != null) ? patients : new ArrayList<>();
    }

    public Users getPatientByID(int userID) throws SQLException {
        return userDAO.getPatientByID(userID);
    }

    public boolean UpdateEmployee(Users user) throws SQLException {
        if (user == null) {
            throw new SQLException("Thông tin người dùng không được để trống.");
        }

        if (user.getFullName() != null) user.setFullName(user.getFullName().trim());
        if (user.getGender() != null) user.setGender(user.getGender().trim());
        if (user.getSpecialization() != null) user.setSpecialization(user.getSpecialization().trim());
        if (user.getStatus() != null) user.setStatus(user.getStatus().trim());

        validateFullName(user.getFullName());
        validateDob(user.getDob());

        if (user.getGender() == null || user.getGender().isEmpty()) {
            throw new SQLException("Giới tính không được để trống.");
        }
        String mappedGender = user.getGender();
        if ("Nam".equalsIgnoreCase(mappedGender)) {
            mappedGender = "Male";
        } else if ("Nữ".equalsIgnoreCase(mappedGender)) {
            mappedGender = "Female";
        } else if ("Khác".equalsIgnoreCase(mappedGender)) {
            mappedGender = "Other";
        } else {
            throw new SQLException("Giới tính không hợp lệ: " + user.getGender());
        }
        user.setGender(mappedGender);

        if (user.getSpecialization() == null || user.getSpecialization().isEmpty() || user.getSpecialization().length() > 100) {
            throw new SQLException("Chuyên khoa không được để trống hoặc vượt quá 100 ký tự.");
        }

        List<String> validStatuses = List.of("Active", "Inactive");
        if (user.getStatus() == null || !validStatuses.contains(user.getStatus())) {
            user.setStatus("Active");
        }

        return userDAO.UpdateEmployee(user);
    }

    public boolean deleteEmployee(int userID) throws SQLException {
        if (userID <= 0) {
            throw new SQLException("ID nhân viên không hợp lệ.");
        }
        return userDAO.deleteEmployee(userID);
    }

    public boolean UpdatePatient(Users user) throws SQLException {
        if (user == null) {
            throw new SQLException("Thông tin người dùng không được để trống.");
        }

        if (user.getFullName() != null) user.setFullName(user.getFullName().trim());
        if (user.getGender() != null) user.setGender(user.getGender().trim());
        if (user.getPhone() != null) user.setPhone(user.getPhone().trim());
        if (user.getAddress() != null) user.setAddress(user.getAddress().trim());
        if (user.getStatus() != null) user.setStatus(user.getStatus().trim());

        validateFullName(user.getFullName());
        validateDob(user.getDob());
        validatePhoneNumber(user.getPhone());

        if (user.getGender() == null || user.getGender().isEmpty()) {
            throw new SQLException("Giới tính không được để trống.");
        }
        String mappedGender = user.getGender();
        if ("Nam".equalsIgnoreCase(mappedGender)) {
            mappedGender = "Male";
        } else if ("Nữ".equalsIgnoreCase(mappedGender)) {
            mappedGender = "Female";
        } else if ("Khác".equalsIgnoreCase(mappedGender)) {
            mappedGender = "Other";
        } else {
            throw new SQLException("Giới tính không hợp lệ: " + user.getGender());
        }
        user.setGender(mappedGender);

        if (user.getAddress() == null || user.getAddress().isEmpty() || user.getAddress().length() > 255) {
            throw new SQLException("Địa chỉ không được để trống hoặc vượt quá 255 ký tự.");
        }

        List<String> validStatuses = List.of("Active", "Inactive");
        if (user.getStatus() == null || !validStatuses.contains(user.getStatus())) {
            user.setStatus("Active");
        }

        return userDAO.UpdatePatient(user);
    }

    public List<Users> searchEmployees(String keyword) throws SQLException {
        return userDAO.searchEmployees((keyword != null) ? keyword.trim() : "");
    }

    public List<Users> searchPatients(String keyword) throws SQLException {
        return userDAO.searchPatients((keyword != null) ? keyword.trim() : "");
    }

    public List<Users> getUsersByRole(String role) throws SQLException {
        return userDAO.getUsersByRole((role != null) ? role.trim() : "");
    }
    
    public Map<Integer, String> getEmployeeNameMap() throws SQLException {
        Map<Integer, String> employeeMap = new HashMap<>();
        List<Users> employees = userDAO.getAllEmployee();
        for (Users user : employees) {
            if (user.getUserID() > 0) {
                employeeMap.put(user.getUserID(), (user.getFullName() != null) ? user.getFullName().trim() : "Unknown Employee " + user.getUserID());
            }
        }
        return employeeMap;
    }

    public int countPatients() throws SQLException {
        return userDAO.countPatients();
    }

    public int countEmployee() throws SQLException {
        return userDAO.countEmployee();
    }
     public boolean changePassword(Users user, String newPassword) throws SQLException {
    String hashed = BCrypt.hashpw(newPassword, BCrypt.gensalt());
    return new UserDAO().changePassword(user.getEmail(), hashed);
}
}
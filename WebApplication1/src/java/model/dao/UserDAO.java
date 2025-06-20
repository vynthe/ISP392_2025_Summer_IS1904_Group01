package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.entity.Users;
import model.util.VerificationCodeGenerator;
public class UserDAO {

    private final DBContext dbContext;

    public UserDAO() {
        this.dbContext = DBContext.getInstance();
    }

    // Kiểm tra email hoặc username đã tồn tại chưa trong bảng Users
    public boolean isEmailOrUsernameExists(String email, String username) throws SQLException {
        email = (email != null) ? email.trim() : null;
        username = (username != null) ? username.trim() : null;

        String sql = "SELECT COUNT(*) FROM Users WHERE email = ? OR username = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.setString(2, username);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    // Kiểm tra số điện thoại đã tồn tại chưa (chỉ kiểm tra nếu phone không null)
    public boolean isPhoneExists(String phone) throws SQLException {
        phone = (phone != null) ? phone.trim() : null;

        if (phone == null || phone.isEmpty()) {
            return false;
        }
        String sql = "SELECT COUNT(*) FROM Users WHERE phone = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, phone);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    public boolean registerUserBasic(Users user) throws SQLException {
        // Trim các trường string
        if (user.getUsername() != null) user.setUsername(user.getUsername().trim());
        if (user.getEmail() != null) user.setEmail(user.getEmail().trim());
        if (user.getPassword() != null) user.setPassword(user.getPassword().trim());
        if (user.getRole() != null) user.setRole(user.getRole().trim());
        if (user.getPhone() != null) user.setPhone(user.getPhone().trim());
        if (user.getFullName() != null) user.setFullName(user.getFullName().trim());
        if (user.getGender() != null) user.setGender(user.getGender().trim());
        if (user.getAddress() != null) user.setAddress(user.getAddress().trim());
        if (user.getSpecialization() != null) user.setSpecialization(user.getSpecialization().trim());
        if (user.getStatus() != null) user.setStatus(user.getStatus().trim());

        // Tạo mã xác thực và thời gian hết hạn
        String verificationCode = VerificationCodeGenerator.generateCode();
        Timestamp expiryTime = Timestamp.valueOf(LocalDateTime.now().plusMinutes(10));
        user.setVerificationCode(verificationCode);
        user.setVerificationCodeExpiry(expiryTime);
        user.setVerified(false);

        String sql = "INSERT INTO Users (username, email, password, role, phone, fullName, dob, gender, address, specialization, createdBy, status, createdAt, verification_code, verification_code_expiry, is_verified) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), ?, ?, ?)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword()); // Already hashed in Service
            stmt.setString(4, user.getRole());
            stmt.setString(5, user.getPhone());
            stmt.setString(6, user.getFullName());
            stmt.setDate(7, user.getDob());
            stmt.setString(8, user.getGender());
            stmt.setString(9, user.getAddress());
            stmt.setString(10, user.getSpecialization());
            stmt.setObject(11, user.getCreatedBy(), java.sql.Types.INTEGER);
            stmt.setString(12, user.getStatus() != null && !user.getStatus().isEmpty() ? user.getStatus() : "Active");
            stmt.setString(13, user.getVerificationCode());
            stmt.setTimestamp(14, user.getVerificationCodeExpiry());
            stmt.setBoolean(15, user.isVerified());
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("SQL Error in registerUserBasic: " + e.getMessage());
            throw e;
        }
    }

    public boolean addUser(Users user, int createdBy) throws SQLException {
        // Trim các trường string
        if (user.getFullName() != null) user.setFullName(user.getFullName().trim());
        if (user.getGender() != null) user.setGender(user.getGender().trim());
        if (user.getSpecialization() != null) user.setSpecialization(user.getSpecialization().trim());
        if (user.getRole() != null) user.setRole(user.getRole().trim());
        if (user.getStatus() != null) user.setStatus(user.getStatus().trim());
        if (user.getEmail() != null) user.setEmail(user.getEmail().trim());
        if (user.getPhone() != null) user.setPhone(user.getPhone().trim());
        if (user.getAddress() != null) user.setAddress(user.getAddress().trim());
        if (user.getUsername() != null) user.setUsername(user.getUsername().trim());
        if (user.getPassword() != null) user.setPassword(user.getPassword().trim());

        // Tạo mã xác thực và thời gian hết hạn
        String verificationCode = VerificationCodeGenerator.generateCode();
        Timestamp expiryTime = Timestamp.valueOf(LocalDateTime.now().plusMinutes(10));
        user.setVerificationCode(verificationCode);
        user.setVerificationCodeExpiry(expiryTime);
        user.setVerified(false);

        String sql = "INSERT INTO Users (fullName, gender, dob, specialization, role, status, email, phone, address, username, password, createdBy, createdAt, verification_code, verification_code_expiry, is_verified) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), ?, ?, ?)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getGender());
            stmt.setDate(3, user.getDob());
            stmt.setString(4, user.getSpecialization());
            stmt.setString(5, user.getRole());
            stmt.setString(6, user.getStatus() != null && !user.getStatus().isEmpty() ? user.getStatus() : "Active");
            stmt.setString(7, user.getEmail());
            stmt.setString(8, user.getPhone());
            stmt.setString(9, user.getAddress());
            stmt.setString(10, user.getUsername());
            stmt.setString(11, user.getPassword()); // Assumed hashed in service layer
            stmt.setInt(12, createdBy);
            stmt.setString(13, user.getVerificationCode());
            stmt.setTimestamp(14, user.getVerificationCodeExpiry());
            stmt.setBoolean(15, user.isVerified());
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    // Thêm phương thức xác thực mã
    public boolean verifyUser(String email, String verificationCode) throws SQLException {
        String sql = "SELECT verification_code, verification_code_expiry FROM Users WHERE email = ? AND is_verified = 0";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String storedCode = rs.getString("verification_code");
                    Timestamp expiry = rs.getTimestamp("verification_code_expiry");
                    if (storedCode != null && storedCode.equals(verificationCode) && 
                        (expiry == null || LocalDateTime.now().isBefore(expiry.toLocalDateTime()))) {
                        String updateSql = "UPDATE Users SET is_verified = 1, verification_code = NULL, verification_code_expiry = NULL, updatedAt = GETDATE() WHERE email = ?";
                        try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                            updateStmt.setString(1, email);
                            return updateStmt.executeUpdate() > 0;
                        }
                    }
                }
            }
        }
        return false;
    }

    public Users findUserByEmailOrUsername(String emailOrUsername) throws SQLException {
        emailOrUsername = (emailOrUsername != null) ? emailOrUsername.trim() : null;

        Users user = null;
        String sql = "SELECT * FROM Users WHERE (username = ? OR email = ?)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, emailOrUsername);
            stmt.setString(2, emailOrUsername);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    user = mapResultSetToUser(rs);
                }
            }
        }
        return user;
    }

    public List<Users> searchEmployees(String keyword) throws SQLException {
        String trimmedKeyword = (keyword != null) ? keyword.trim() : "";
        List<Users> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE role IN ('doctor', 'nurse', 'receptionist') AND (CAST(UserID AS VARCHAR) LIKE ? OR fullName LIKE ? OR gender LIKE ? OR specialization LIKE ? OR CAST(YEAR(dob) AS VARCHAR) LIKE ? OR phone LIKE ?)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            String searchPattern = "%" + trimmedKeyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            stmt.setString(4, searchPattern);
            stmt.setString(5, searchPattern);
            stmt.setString(6, searchPattern);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToUser(rs));
                }
            }
        }
        return list;
    }

    public List<Users> searchPatients(String keyword) throws SQLException {
        String trimmedKeyword = (keyword != null) ? keyword.trim() : "";
        List<Users> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE role = 'patient' AND (CAST(UserID AS VARCHAR) LIKE ? OR fullName LIKE ? OR gender LIKE ? OR address LIKE ? OR CAST(YEAR(dob) AS VARCHAR) LIKE ? OR phone LIKE ?)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            String searchPattern = "%" + trimmedKeyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            stmt.setString(4, searchPattern);
            stmt.setString(5, searchPattern);
            stmt.setString(6, searchPattern);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToUser(rs));
                }
            }
        }
        return list;
    }

    public void updateUserProfile(Users user) throws SQLException {
        if (user.getUsername() != null) user.setUsername(user.getUsername().trim());
        if (user.getEmail() != null) user.setEmail(user.getEmail().trim());
        if (user.getFullName() != null) user.setFullName(user.getFullName().trim());
        if (user.getPhone() != null) user.setPhone(user.getPhone().trim());
        if (user.getAddress() != null) user.setAddress(user.getAddress().trim());
        if (user.getMedicalHistory() != null) user.setMedicalHistory(user.getMedicalHistory().trim());
        if (user.getSpecialization() != null) user.setSpecialization(user.getSpecialization().trim());
        if (user.getGender() != null) user.setGender(user.getGender().trim());

        String sql = "UPDATE Users SET username = ?, fullName = ?, dob = ?, gender = ?, phone = ?, address = ?, email = ?, " +
                     "medicalHistory = ?, specialization = ?, updatedAt = GETDATE() WHERE userID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getFullName());
            stmt.setDate(3, user.getDob());
            stmt.setString(4, user.getGender());
            stmt.setString(5, user.getPhone());
            stmt.setString(6, user.getAddress());
            stmt.setString(7, user.getEmail());
            stmt.setString(8, user.getMedicalHistory());
            stmt.setString(9, user.getSpecialization());
            stmt.setInt(10, user.getUserID());
            stmt.executeUpdate();
        }
    }

    public boolean updatePassword(String email, String newPassword) throws SQLException {
        email = (email != null) ? email.trim() : null;
        newPassword = (newPassword != null) ? newPassword.trim() : null;

        String sql = "UPDATE Users SET [password] = ?, updatedAt = GETDATE() WHERE email = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newPassword);
            stmt.setString(2, email);
            return stmt.executeUpdate() > 0;
        }
    }

    public Users getUserByID(int userID) throws SQLException {
        String sql = "SELECT * FROM Users WHERE userID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        }
        return null;
    }

    public List<Users> getAllEmployee() throws SQLException {
        List<Users> users = new ArrayList<>();
        String sql = "SELECT UserID, Username, [Password], Email, FullName, Dob, Gender, Phone, [Address], MedicalHistory, Specialization, [Role], [Status], CreatedBy, CreatedAt, UpdatedAt FROM Users WHERE Role IN ('doctor', 'nurse', 'receptionist')";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        }
        return users;
    }

    public Users getEmployeeByID(int userID) throws SQLException {
        String sql = "SELECT * FROM Users WHERE userID = ? AND Role IN ('doctor', 'nurse', 'receptionist')";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        }
        return null;
    }

    public List<Users> getAllPatient() throws SQLException {
        List<Users> users = new ArrayList<>();
        String sql = "SELECT UserID, Username, [Password], Email, FullName, Dob, Gender, Phone, [Address], MedicalHistory, Specialization, [Role], [Status], CreatedBy, CreatedAt, UpdatedAt FROM Users WHERE Role IN ('patient')";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        }
        return users;
    }

    public Users getPatientByID(int userID) throws SQLException {
        String sql = "SELECT * FROM Users WHERE userID = ? AND Role IN ('patient')";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        }
        return null;
    }

    public boolean UpdateEmployee(Users user) throws SQLException {
        if (user.getFullName() != null) user.setFullName(user.getFullName().trim());
        if (user.getGender() != null) user.setGender(user.getGender().trim());
        if (user.getSpecialization() != null) user.setSpecialization(user.getSpecialization().trim());
        if (user.getStatus() != null) user.setStatus(user.getStatus().trim());

        String sql = "UPDATE Users SET FullName = ?, Gender = ?, Specialization = ?, Dob = ?, Status = ?, UpdatedAt = GETDATE() WHERE UserID = ? AND Role IN ('doctor', 'nurse', 'receptionist')";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            conn.setAutoCommit(false);
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getGender());
            stmt.setString(3, user.getSpecialization());
            stmt.setDate(4, user.getDob());
            stmt.setString(5, user.getStatus() != null && !user.getStatus().isEmpty() ? user.getStatus() : "Active");
            stmt.setInt(6, user.getUserID());
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                conn.commit();
                return true;
            } else {
                conn.rollback();
                return false;
            }
        }
    }

    public boolean deleteEmployee(int userID) throws SQLException {
        String sql = "DELETE FROM Users WHERE userID = ? AND Role IN ('Doctor', 'Nurse', 'Receptionist')";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userID);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    public boolean UpdatePatient(Users patient) throws SQLException {
        if (patient.getFullName() != null) patient.setFullName(patient.getFullName().trim());
        if (patient.getGender() != null) patient.setGender(patient.getGender().trim());
        if (patient.getPhone() != null) patient.setPhone(patient.getPhone().trim());
        if (patient.getAddress() != null) patient.setAddress(patient.getAddress().trim());
        if (patient.getStatus() != null) patient.setStatus(patient.getStatus().trim());

        String sql = "UPDATE Users SET FullName = ?, Gender = ?, Dob = ?, Phone = ?, Address = ?, Status = ?, UpdatedAt = GETDATE() WHERE UserID = ? AND Role = 'patient'";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            conn.setAutoCommit(false);
            stmt.setString(1, patient.getFullName());
            stmt.setString(2, patient.getGender());
            stmt.setDate(3, patient.getDob());
            stmt.setString(4, patient.getPhone());
            stmt.setString(5, patient.getAddress());
            stmt.setString(6, patient.getStatus() != null && !patient.getStatus().isEmpty() ? patient.getStatus() : "Active");
            stmt.setInt(7, patient.getUserID());
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                conn.commit();
                return true;
            } else {
                conn.rollback();
                return false;
            }
        }
    }

    public List<Users> getUsersByRole(String role) throws SQLException {
        role = (role != null) ? role.trim() : "";
        List<Users> users = new ArrayList<>();
        String sql = "SELECT UserID, Username, [Password], Email, FullName, Dob, Gender, Phone, [Address], MedicalHistory, Specialization, [Role], [Status], CreatedBy, CreatedAt, UpdatedAt FROM Users WHERE [Role] = ? AND [Status] = 'Active'";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, role);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    users.add(mapResultSetToUser(rs));
                }
            }
        }
        return users;
    }

    // Helper method to map a ResultSet row to a Users object
    private Users mapResultSetToUser(ResultSet rs) throws SQLException {
        Users user = new Users();
        user.setUserID(rs.getInt("UserID"));
        user.setUsername(rs.getString("Username"));
        user.setPassword(rs.getString("Password"));
        user.setEmail(rs.getString("Email"));
        user.setFullName(rs.getString("FullName"));
        user.setDob(rs.getDate("Dob"));
        user.setGender(rs.getString("Gender"));
        user.setPhone(rs.getString("Phone"));
        user.setAddress(rs.getString("Address"));
        user.setMedicalHistory(rs.getString("MedicalHistory"));
        user.setSpecialization(rs.getString("Specialization"));
        user.setRole(rs.getString("Role"));
        user.setStatus(rs.getString("Status"));
        user.setCreatedBy(rs.getObject("CreatedBy") != null ? rs.getInt("CreatedBy") : null);
        user.setCreatedAt(rs.getDate("CreatedAt"));
        user.setUpdatedAt(rs.getDate("UpdatedAt"));
        // Ánh xạ các cột mới
        user.setVerificationCode(rs.getString("verification_code"));
        user.setVerificationCodeExpiry(rs.getTimestamp("verification_code_expiry"));
        user.setVerified(rs.getBoolean("is_verified"));
        return user;
    }
}
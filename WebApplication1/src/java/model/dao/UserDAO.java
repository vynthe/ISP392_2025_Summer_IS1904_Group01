package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.entity.Users;

public class UserDAO {

    private final DBContext dbContext;

    public UserDAO() {
        this.dbContext = DBContext.getInstance();
    }

    // Kiểm tra email hoặc username đã tồn tại chưa trong bảng Users
    public boolean isEmailOrUsernameExists(String email, String username) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Users WHERE email = ? OR username = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email != null ? email.trim() : null);
            stmt.setString(2, username != null ? username.trim() : null);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    // Kiểm tra số điện thoại đã tồn tại chưa (chỉ kiểm tra nếu phone không null)
    public boolean isPhoneExists(String phone) throws SQLException {
        if (phone == null || phone.trim().isEmpty()) {
            return false;
        }
        String sql = "SELECT COUNT(*) FROM Users WHERE phone = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, phone.trim());
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    public boolean registerUserBasic(Users user) throws SQLException {
        // Validate and trim inputs (moved to Service)
        String sql = "INSERT INTO Users (username, email, password, role, phone, fullName, dob, gender, address, specialization, createdBy) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getUsername() != null ? user.getUsername().trim() : null);
            stmt.setString(2, user.getEmail() != null ? user.getEmail().trim() : null);
            stmt.setString(3, user.getPassword() != null ? user.getPassword().trim() : null); // Already hashed
            stmt.setString(4, user.getRole() != null ? user.getRole().trim() : null);
            stmt.setString(5, user.getPhone() != null ? user.getPhone().trim() : null);
            stmt.setString(6, user.getFullName() != null ? user.getFullName().trim() : null);
            stmt.setDate(7, user.getDob());
            stmt.setString(8, user.getGender() != null ? user.getGender().trim() : null);
            stmt.setString(9, user.getAddress() != null ? user.getAddress().trim() : null);
            stmt.setString(10, user.getSpecialization() != null ? user.getSpecialization().trim() : null);
            stmt.setObject(11, user.getCreatedBy() != null ? user.getCreatedBy() : null, java.sql.Types.INTEGER);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("SQL Error in registerUserBasic: " + e.getMessage());
            throw e;
        }
    }

    public boolean addUser(Users user, int createdBy) throws SQLException {
        String sql = "INSERT INTO Users (fullName, gender, dob, specialization, role, status, email, phone, address, username, password, createdBy, createdAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getFullName() != null ? user.getFullName().trim() : null);
            stmt.setString(2, user.getGender() != null ? user.getGender().trim() : null);
            stmt.setDate(3, user.getDob());
            stmt.setString(4, user.getSpecialization() != null ? user.getSpecialization().trim() : null);
            stmt.setString(5, user.getRole() != null ? user.getRole().trim() : null);
            stmt.setString(6, user.getStatus() != null ? user.getStatus().trim() : "Active");
            stmt.setString(7, user.getEmail() != null ? user.getEmail().trim() : null);
            stmt.setString(8, user.getPhone() != null ? user.getPhone().trim() : null);
            stmt.setString(9, user.getAddress() != null ? user.getAddress().trim() : null);
            stmt.setString(10, user.getUsername() != null ? user.getUsername().trim() : null);
            stmt.setString(11, user.getPassword() != null ? user.getPassword().trim() : null);
            stmt.setInt(12, createdBy);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    public Users findUserByEmailOrUsername(String emailOrUsername) throws SQLException {
        Users user = null;
        String sql = "SELECT * FROM users WHERE (username = ? OR email = ?)";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, emailOrUsername != null ? emailOrUsername.trim() : null);
            stmt.setString(2, emailOrUsername != null ? emailOrUsername.trim() : null);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    user = new Users();
                    user.setUserID(rs.getInt("userID"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setEmail(rs.getString("email"));
                    user.setFullName(rs.getString("fullName"));
                    user.setDob(rs.getDate("dob"));
                    user.setGender(rs.getString("gender"));
                    user.setPhone(rs.getString("phone"));
                    user.setAddress(rs.getString("address"));
                    user.setMedicalHistory(rs.getString("medicalHistory"));
                    user.setSpecialization(rs.getString("specialization"));
                    user.setRole(rs.getString("role"));
                    user.setStatus(rs.getString("status"));
                    user.setCreatedBy(rs.getObject("createdBy") != null ? rs.getInt("createdBy") : null);
                    user.setCreatedAt(rs.getDate("createdAt"));
                    user.setUpdatedAt(rs.getDate("updatedAt"));
                }
            }
        }
        return user;
    }

    public List<Users> searchEmployees(String keyword) throws SQLException {
        List<Users> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE role IN ('doctor', 'nurse', 'receptionist') AND (UserID = ? OR fullName LIKE ? OR gender = ? OR specialization LIKE ? OR YEAR(dob) = ? OR phone LIKE ?)";
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            String searchPattern = "%" + (keyword != null ? keyword.trim() : "") + "%";
            int id;
            try {
                id = Integer.parseInt(keyword != null ? keyword.trim() : "-1");
            } catch (NumberFormatException e) {
                id = -1;
            }
            int year;
            try {
                year = Integer.parseInt(keyword != null ? keyword.trim() : "-1");
            } catch (NumberFormatException e) {
                year = -1;
            }
            stmt.setInt(1, id);
            stmt.setString(2, searchPattern);
            stmt.setString(3, keyword != null ? keyword.trim() : null);
            stmt.setString(4, searchPattern);
            stmt.setInt(5, year);
            stmt.setString(6, searchPattern);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
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
                    list.add(user);
                }
            }
        }
        return list;
    }

    public List<Users> searchPatients(String keyword) throws SQLException {
        List<Users> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE role = 'patient' AND (UserID = ? OR fullName LIKE ? OR gender = ? OR address LIKE ? OR YEAR(dob) = ? OR phone LIKE ?)";
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            String searchPattern = "%" + (keyword != null ? keyword.trim() : "") + "%";
            int id;
            try {
                id = Integer.parseInt(keyword != null ? keyword.trim() : "-1");
            } catch (NumberFormatException e) {
                id = -1;
            }
            int year;
            try {
                year = Integer.parseInt(keyword != null ? keyword.trim() : "-1");
            } catch (NumberFormatException e) {
                year = -1;
            }
            stmt.setInt(1, id);
            stmt.setString(2, searchPattern);
            stmt.setString(3, keyword != null ? keyword.trim() : null);
            stmt.setString(4, searchPattern);
            stmt.setInt(5, year);
            stmt.setString(6, searchPattern);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
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
                    list.add(user);
                }
            }
        }
        return list;
    }

    public void updateUserProfile(Users user) throws SQLException {
        String sql = "UPDATE Users SET username = ?, dob = ?, gender = ?, phone = ?, address = ?, email = ?, "
                + "medicalHistory = ?, specialization = ?, updatedAt = GETDATE() WHERE userID = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getUsername() != null ? user.getUsername().trim() : null);
            stmt.setDate(2, user.getDob());
            stmt.setString(3, user.getGender() != null ? user.getGender().trim() : null);
            stmt.setString(4, user.getPhone() != null ? user.getPhone().trim() : null);
            stmt.setString(5, user.getAddress() != null ? user.getAddress().trim() : null);
            stmt.setString(6, user.getEmail() != null ? user.getEmail().trim() : null);
            stmt.setString(7, user.getMedicalHistory() != null ? user.getMedicalHistory().trim() : null);
            stmt.setString(8, user.getSpecialization() != null ? user.getSpecialization().trim() : null);
            stmt.setInt(9, user.getUserID());
            stmt.executeUpdate();
        }
    }

    public boolean updatePassword(String email, String newPassword) throws SQLException {
        String sql = "UPDATE Users SET [password] = ?, updatedAt = GETDATE() WHERE email = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newPassword != null ? newPassword.trim() : null);
            stmt.setString(2, email != null ? email.trim() : null);
            return stmt.executeUpdate() > 0;
        }
    }

    public Users getUserByID(int userID) throws SQLException {
        String sql = "SELECT * FROM Users WHERE userID = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Users user = new Users();
                    user.setUserID(rs.getInt("userID"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setEmail(rs.getString("email"));
                    user.setFullName(rs.getString("fullName"));
                    user.setDob(rs.getDate("dob"));
                    user.setGender(rs.getString("gender"));
                    user.setPhone(rs.getString("phone"));
                    user.setAddress(rs.getString("address"));
                    user.setMedicalHistory(rs.getString("medicalHistory"));
                    user.setSpecialization(rs.getString("specialization"));
                    user.setRole(rs.getString("role"));
                    user.setStatus(rs.getString("status"));
                    user.setCreatedBy(rs.getObject("createdBy") != null ? rs.getInt("createdBy") : null);
                    user.setCreatedAt(rs.getDate("createdAt"));
                    user.setUpdatedAt(rs.getDate("updatedAt"));
                    return user;
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
                users.add(user);
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
                    Users user = new Users();
                    user.setUserID(rs.getInt("userID"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setEmail(rs.getString("email"));
                    user.setFullName(rs.getString("fullName"));
                    user.setDob(rs.getDate("dob"));
                    user.setGender(rs.getString("gender"));
                    user.setPhone(rs.getString("phone"));
                    user.setAddress(rs.getString("address"));
                    user.setMedicalHistory(rs.getString("medicalHistory"));
                    user.setSpecialization(rs.getString("specialization"));
                    user.setRole(rs.getString("role"));
                    user.setStatus(rs.getString("status"));
                    user.setCreatedBy(rs.getObject("createdBy") != null ? rs.getInt("createdBy") : null);
                    user.setCreatedAt(rs.getDate("createdAt"));
                    user.setUpdatedAt(rs.getDate("updatedAt"));
                    return user;
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
                users.add(user);
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
                    Users user = new Users();
                    user.setUserID(rs.getInt("userID"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setEmail(rs.getString("email"));
                    user.setFullName(rs.getString("fullName"));
                    user.setDob(rs.getDate("dob"));
                    user.setGender(rs.getString("gender"));
                    user.setPhone(rs.getString("phone"));
                    user.setAddress(rs.getString("address"));
                    user.setMedicalHistory(rs.getString("medicalHistory"));
                    user.setSpecialization(rs.getString("specialization"));
                    user.setRole(rs.getString("role"));
                    user.setStatus(rs.getString("status"));
                    user.setCreatedBy(rs.getObject("createdBy") != null ? rs.getInt("createdBy") : null);
                    user.setCreatedAt(rs.getDate("createdAt"));
                    user.setUpdatedAt(rs.getDate("updatedAt"));
                    return user;
                }
            }
        }
        return null;
    }

    public boolean UpdateEmployee(Users user) throws SQLException {
        String sql = "UPDATE Users SET FullName = ?, Gender = ?, Specialization = ?, Dob = ?, Status = ? WHERE UserID = ? AND Role IN ('doctor', 'nurse', 'receptionist')";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            conn.setAutoCommit(false);
            stmt.setString(1, user.getFullName() != null ? user.getFullName().trim() : null);
            stmt.setString(2, user.getGender() != null ? user.getGender().trim() : null);
            stmt.setString(3, user.getSpecialization() != null ? user.getSpecialization().trim() : null);
            stmt.setDate(4, user.getDob());
            stmt.setString(5, user.getStatus() != null ? user.getStatus().trim() : "Active");
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
        String sql = "UPDATE Users SET FullName = ?, Gender = ?, Dob = ?, Phone = ?, Address = ?, Status = ? WHERE UserID = ? AND Role = 'patient'";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            conn.setAutoCommit(false);
            stmt.setString(1, patient.getFullName() != null ? patient.getFullName().trim() : null);
            stmt.setString(2, patient.getGender() != null ? patient.getGender().trim() : null);
            stmt.setDate(3, patient.getDob());
            stmt.setString(4, patient.getPhone() != null ? patient.getPhone().trim() : null);
            stmt.setString(5, patient.getAddress() != null ? patient.getAddress().trim() : null);
            stmt.setString(6, patient.getStatus() != null ? patient.getStatus().trim() : "Active");
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
        List<Users> users = new ArrayList<>();
        String sql = "SELECT UserID, Username, [Password], Email, FullName, Dob, Gender, Phone, [Address], MedicalHistory, Specialization, [Role], [Status], CreatedBy, CreatedAt, UpdatedAt FROM Users WHERE [Role] = ? AND [Status] = 'Active'";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, role != null ? role.trim() : null);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
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
                    users.add(user);
                }
            }
        }
        return users;
    }
}
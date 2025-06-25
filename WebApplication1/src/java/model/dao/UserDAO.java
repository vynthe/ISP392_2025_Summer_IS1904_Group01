package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.entity.Users;
import org.mindrot.jbcrypt.BCrypt;

public class UserDAO {

    private final DBContext dbContext;

    public UserDAO() {
        this.dbContext = DBContext.getInstance();
    }

    // Kiểm tra email hoặc username đã tồn tại chưa trong bảng Users
    public boolean isEmailOrUsernameExists(String email, String username) throws SQLException {
        // Trim inputs immediately
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
        // Trim input immediately
        phone = (phone != null) ? phone.trim() : null;

        if (phone == null || phone.isEmpty()) { // Use isEmpty() after trimming
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
        // Trim all relevant string fields from the Users object before using
        // (Assuming validation and trimming of primitive strings happened in UserService)
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


        String sql = "INSERT INTO Users (username, email, password, role, phone, fullName, dob, gender, address, specialization, createdBy, status, createdAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";
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
            stmt.setString(12, user.getStatus()); // Ensure status is set
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("SQL Error in registerUserBasic: " + e.getMessage());
            throw e;
        }
    }

    public boolean addUser(Users user, int createdBy) throws SQLException {
        // Trim all relevant string fields from the Users object before using
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


        String sql = "INSERT INTO Users (fullName, gender, dob, specialization, role, status, email, phone, address, username, password, createdBy, createdAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getGender());
            stmt.setDate(3, user.getDob());
            stmt.setString(4, user.getSpecialization());
            stmt.setString(5, user.getRole());
            stmt.setString(6, user.getStatus() != null && !user.getStatus().isEmpty() ? user.getStatus() : "Active"); // Default to Active
            stmt.setString(7, user.getEmail());
            stmt.setString(8, user.getPhone());
            stmt.setString(9, user.getAddress());
            stmt.setString(10, user.getUsername());
            stmt.setString(11, user.getPassword()); // Assumed hashed in service layer
            stmt.setInt(12, createdBy);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    public Users findUserByEmailOrUsername(String emailOrUsername) throws SQLException {
        // Trim input immediately
        emailOrUsername = (emailOrUsername != null) ? emailOrUsername.trim() : null;

        Users user = null;
        String sql = "SELECT * FROM users WHERE (username = ? OR email = ?)";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, emailOrUsername);
            stmt.setString(2, emailOrUsername);
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
        // Trim input immediately
        String trimmedKeyword = (keyword != null) ? keyword.trim() : "";

        List<Users> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE role IN ('doctor', 'nurse', 'receptionist') AND (CAST(UserID AS VARCHAR) LIKE ? OR fullName LIKE ? OR gender LIKE ? OR specialization LIKE ? OR CAST(YEAR(dob) AS VARCHAR) LIKE ? OR phone LIKE ?)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            String searchPattern = "%" + trimmedKeyword + "%";

            // Set all parameters using the trimmed keyword or search pattern
            stmt.setString(1, searchPattern); // UserID
            stmt.setString(2, searchPattern); // fullName
            stmt.setString(3, searchPattern); // gender (use LIKE for partial matches)
            stmt.setString(4, searchPattern); // specialization
            stmt.setString(5, searchPattern); // YEAR(dob)
            stmt.setString(6, searchPattern); // phone

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToUser(rs));
                }
            }
        }
        return list;
    }

    public List<Users> searchPatients(String keyword) throws SQLException {
        // Trim input immediately
        String trimmedKeyword = (keyword != null) ? keyword.trim() : "";

        List<Users> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE role = 'patient' AND (CAST(UserID AS VARCHAR) LIKE ? OR fullName LIKE ? OR gender LIKE ? OR address LIKE ? OR CAST(YEAR(dob) AS VARCHAR) LIKE ? OR phone LIKE ?)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            String searchPattern = "%" + trimmedKeyword + "%";

            // Set all parameters using the trimmed keyword or search pattern
            stmt.setString(1, searchPattern); // UserID
            stmt.setString(2, searchPattern); // fullName
            stmt.setString(3, searchPattern); // gender
            stmt.setString(4, searchPattern); // address
            stmt.setString(5, searchPattern); // YEAR(dob)
            stmt.setString(6, searchPattern); // phone

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToUser(rs));
                }
            }
        }
        return list;
    }

    public void updateUserProfile(Users user) throws SQLException {
        // Trim relevant string fields from the Users object before using
        if (user.getUsername() != null) user.setUsername(user.getUsername().trim());
        if (user.getEmail() != null) user.setEmail(user.getEmail().trim());
        if (user.getFullName() != null) user.setFullName(user.getFullName().trim());
        if (user.getPhone() != null) user.setPhone(user.getPhone().trim());
        if (user.getAddress() != null) user.setAddress(user.getAddress().trim());
        if (user.getMedicalHistory() != null) user.setMedicalHistory(user.getMedicalHistory().trim());
        if (user.getSpecialization() != null) user.setSpecialization(user.getSpecialization().trim());
        if (user.getGender() != null) user.setGender(user.getGender().trim());


        String sql = "UPDATE Users SET username = ?, fullName = ?, dob = ?, gender = ?, phone = ?, address = ?, email = ?, "
                + "medicalHistory = ?, specialization = ?, updatedAt = GETDATE() WHERE userID = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getFullName()); // Added fullName to update
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
        // Trim inputs immediately
        email = (email != null) ? email.trim() : null;
        newPassword = (newPassword != null) ? newPassword.trim() : null;

        String sql = "UPDATE Users SET [password] = ?, updatedAt = GETDATE() WHERE email = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newPassword);
            stmt.setString(2, email);
            return stmt.executeUpdate() > 0;
        }
    }

    public Users getUserByID(int userID) throws SQLException {
        String sql = "SELECT * FROM Users WHERE userID = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
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
        // Trim relevant string fields from the Users object before using
        if (user.getFullName() != null) user.setFullName(user.getFullName().trim());
        if (user.getGender() != null) user.setGender(user.getGender().trim());
        if (user.getSpecialization() != null) user.setSpecialization(user.getSpecialization().trim());
        if (user.getStatus() != null) user.setStatus(user.getStatus().trim());

        String sql = "UPDATE Users SET FullName = ?, Gender = ?, Specialization = ?, Dob = ?, Status = ?, UpdatedAt = GETDATE() WHERE UserID = ? AND Role IN ('doctor', 'nurse', 'receptionist')";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            conn.setAutoCommit(false); // Bắt đầu transaction
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getGender());
            stmt.setString(3, user.getSpecialization());
            stmt.setDate(4, user.getDob());
            stmt.setString(5, user.getStatus() != null && !user.getStatus().isEmpty() ? user.getStatus() : "Active");
            stmt.setInt(6, user.getUserID());
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                conn.commit(); // Commit transaction nếu thành công
                return true;
            } else {
                conn.rollback(); // Rollback transaction nếu thất bại
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
        // Trim relevant string fields from the Users object before using
        if (patient.getFullName() != null) patient.setFullName(patient.getFullName().trim());
        if (patient.getGender() != null) patient.setGender(patient.getGender().trim());
        if (patient.getPhone() != null) patient.setPhone(patient.getPhone().trim());
        if (patient.getAddress() != null) patient.setAddress(patient.getAddress().trim());
        if (patient.getStatus() != null) patient.setStatus(patient.getStatus().trim());

        String sql = "UPDATE Users SET FullName = ?, Gender = ?, Dob = ?, Phone = ?, Address = ?, Status = ?, UpdatedAt = GETDATE() WHERE UserID = ? AND Role = 'patient'";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            conn.setAutoCommit(false); // Bắt đầu transaction
            stmt.setString(1, patient.getFullName());
            stmt.setString(2, patient.getGender());
            stmt.setDate(3, patient.getDob());
            stmt.setString(4, patient.getPhone());
            stmt.setString(5, patient.getAddress());
            stmt.setString(6, patient.getStatus() != null && !patient.getStatus().isEmpty() ? patient.getStatus() : "Active");
            stmt.setInt(7, patient.getUserID());
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                conn.commit(); // Commit transaction nếu thành công
                return true;
            } else {
                conn.rollback(); // Rollback transaction nếu thất bại
                return false;
            }
        }
    }

    public List<Users> getUsersByRole(String role) throws SQLException {
        // Trim input immediately
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
        return user;
    }
 public int countPatients() throws SQLException {
    String sql = "SELECT COUNT(*) FROM Users WHERE Role = 'patient'";
    try (Connection conn = dbContext.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql);
         ResultSet rs = stmt.executeQuery()) {
        if (rs.next()) {
            return rs.getInt(1);
        }
        return 0;
    }
 }
 public int countEmployee() throws SQLException {
    String sql = "SELECT COUNT(*) FROM Users WHERE Role IN ('doctor', 'nurse', 'receptionist')";
    try (Connection conn = dbContext.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql);
         ResultSet rs = stmt.executeQuery()) {
        if (rs.next()) {
            return rs.getInt(1);
        }
        return 0;
    }
 }
}
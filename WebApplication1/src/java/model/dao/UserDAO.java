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
            stmt.setString(1, email);
            stmt.setString(2, username);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    // Validate email: must end with @gmail.com
    private void validateEmail(String email) throws SQLException {
        if (email == null || email.trim().isEmpty() || !email.endsWith("@gmail.com") || email.equals("@gmail.com")) {
            throw new SQLException("Email phải có đuôi @gmail.com.");
        }
    }

    // Validate password: at least 8 chars, 1 uppercase, 1 special char, 1 digit
    private void validatePassword(String password) throws SQLException {
        if (password == null || password.length() < 8
                || !password.matches("^(?=.*[A-Z])(?=.*[!@#$%^&*])(?=.*\\d).+$")) {
            throw new SQLException("Mật khẩu phải có ít nhất 8 ký tự, 1 chữ cái in hoa, 1 ký tự đặc biệt và 1 số.");
        }
    }

    // Kiểm tra số điện thoại đã tồn tại chưa (chỉ kiểm tra nếu phone không null)
    public boolean isPhoneExists(String phone) throws SQLException {
        if (phone == null || phone.trim().isEmpty()) {
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

// Validate username: chỉ chứa chữ cái và số
private void validateUsername(String username) throws SQLException {
    if (username == null || username.trim().isEmpty()) {
        throw new SQLException("Tên đăng nhập không được để trống.");
    }
    if (!username.matches("^[a-zA-Z0-9]+$")) {
        throw new SQLException("Tên đăng nhập chỉ được chứa chữ cái và số.");
    }
}

public boolean registerUserBasic(Users user) throws SQLException {
    String sql = "INSERT INTO Users (username, email, password, role, phone, fullName, dob, gender, address, specialization, createdBy) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    try (Connection conn = dbContext.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        // Gán giá trị cho các tham số
        stmt.setString(1, user.getUsername());
        stmt.setString(2, user.getEmail());
        stmt.setString(3, user.getPassword()); // Already hashed in Service
        stmt.setString(4, user.getRole());

        // Xử lý các cột không bắt buộc, để NULL nếu không có giá trị
        stmt.setString(5, user.getPhone() != null ? user.getPhone() : null);
        stmt.setString(6, user.getFullName() != null ? user.getFullName() : null);
        stmt.setDate(7, user.getDob() != null ? user.getDob() : null);
        stmt.setString(8, user.getGender() != null ? user.getGender() : null);
        stmt.setString(9, user.getAddress() != null ? user.getAddress() : null);
        stmt.setString(10, user.getSpecialization() != null ? user.getSpecialization() : null);
        stmt.setObject(11, user.getCreatedBy() != null ? user.getCreatedBy() : null, java.sql.Types.INTEGER);

        // Thực thi và kiểm tra kết quả
        int rowsAffected = stmt.executeUpdate();
        return rowsAffected > 0;

    } catch (SQLException e) {
        System.err.println("SQL Error in registerUserBasic: " + e.getMessage());
        e.printStackTrace();
        throw e;
    }
}
   

   // Tìm kiếm chính xác (dùng cho chức năng đăng nhập)
    public Users findUserByEmailOrUsername(String emailOrUsername) throws SQLException {
        Users user = null;
        String sql = "SELECT * FROM users WHERE (username = ? OR email = ?)";
        
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, emailOrUsername); // Tìm kiếm chính xác username
            stmt.setString(2, emailOrUsername); // Tìm kiếm chính xác email
            ResultSet rs = stmt.executeQuery();
            
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
        } catch (SQLException e) {
            System.err.println("Lỗi khi tìm kiếm user: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return user;
    }
   public List<Users> searchEmployees(String keyword) throws SQLException {
    List<Users> list = new ArrayList<>();
    String sql = "SELECT * FROM Users " +
                 "WHERE role IN ('doctor', 'nurse', 'receptionist') " +
                 "AND (UserID = ? OR fullName LIKE ? OR gender LIKE ? OR specialization LIKE ? OR YEAR(dob) = ? OR phone LIKE ?)";
    try (Connection conn = dbContext.getConnection(); 
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        String searchPattern = "%" + keyword + "%";
        int id;
        try {
            id = Integer.parseInt(keyword); // For UserID
        } catch (NumberFormatException e) {
            id = -1; // Set to invalid ID if keyword isn't a number
        }
        
        int year;
        try {
            year = Integer.parseInt(keyword); // For year of Dob
        } catch (NumberFormatException e) {
            year = -1; // Set to invalid year if keyword isn't a number
        }

        stmt.setInt(1, id); // UserID
        stmt.setString(2, searchPattern); // FullName
        stmt.setString(3, searchPattern); // Gender
        stmt.setString(4, searchPattern); // Specialization
        stmt.setInt(5, year); // Year of Dob
        stmt.setString(6, searchPattern); // Phone

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
        } catch (SQLException e) {
            System.err.println("Lỗi khi tìm kiếm nhân viên: " + e.getMessage());
            throw e;
        }
    }
    return list;
}
     public List<Users> searchPatients(String keyword) throws SQLException {
    List<Users> list = new ArrayList<>();
    String sql = "SELECT * FROM Users " +
                 "WHERE role = 'patient' " +
                 "AND (UserID = ? OR fullName LIKE ? OR gender LIKE ? OR address LIKE ? OR YEAR(dob) = ? or phone like ? )";
    
    try (Connection conn = dbContext.getConnection(); 
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        String searchPattern = "%" + keyword + "%";
        int id;
        try {
            id = Integer.parseInt(keyword); // For UserID
        } catch (NumberFormatException e) {
            id = -1; // Invalid ID
        }

        int year;
        try {
            year = Integer.parseInt(keyword); // For Year of Birth
        } catch (NumberFormatException e) {
            year = -1; // Invalid Year
        }

        stmt.setInt(1, id);                // UserID
        stmt.setString(2, searchPattern);  // fullName
        stmt.setString(3, searchPattern);  // gender
        stmt.setString(4, searchPattern);  // address
        stmt.setInt(5, year);              // Year(dob)
        stmt.setString(6, searchPattern); // Phone

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
        } catch (SQLException e) {
            System.err.println("Lỗi khi tìm kiếm bệnh nhân: " + e.getMessage());
            throw e;
        }
    }
    return list;
}


    // Cập nhật thông tin hồ sơ của user
    public void updateUserProfile(Users user) throws SQLException {
        String sql = "UPDATE Users SET fullName = ?, dob = ?, gender = ?, phone = ?, address = ?, "
                + "medicalHistory = ?, specialization = ?, updatedAt = GETDATE() "
                + "WHERE userID = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getFullName());
            stmt.setDate(2, user.getDob());
            stmt.setString(3, user.getGender());
            stmt.setString(4, user.getPhone());
            stmt.setString(5, user.getAddress());
            stmt.setString(6, user.getMedicalHistory());
            stmt.setString(7, user.getSpecialization());
            stmt.setInt(8, user.getUserID());
            stmt.executeUpdate();
        }
    }

    // New method to update password
    public boolean updatePassword(String email, String newPassword) throws SQLException {
        validateEmail(email);
        validatePassword(newPassword);
        String sql = "UPDATE Users SET [password] = ?, updatedAt = GETDATE() WHERE email = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newPassword); // Already hashed in Service
            stmt.setString(2, email);
            return stmt.executeUpdate() > 0;
        }
    }

    // Placeholder for password hashing
    private String hashPassword(String password) {
        // Implement password hashing (e.g., using BCrypt)
        return password; // Replace with actual hashing logic (e.g., BCrypt.hashpw(password, BCrypt.gensalt()))
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
                    user.setCreatedBy(rs.getInt("createdBy"));
                    user.setCreatedAt(rs.getDate("createdAt"));
                    user.setUpdatedAt(rs.getDate("updatedAt"));
                    return user;
                }
            }
        }
        return null;
    }

    // Trong UserDAO, phương thức addUser
    public boolean addUser(Users user, int createdBy) throws SQLException {
        validateEmail(user.getEmail());
        validatePassword(user.getPassword());
        if (isEmailOrUsernameExists(user.getEmail(), user.getUsername()) || isPhoneExists(user.getPhone())) {
            throw new SQLException("Email, username hoặc số điện thoại đã tồn tại.");
        }

        // Map gender to match database values
        String mappedGender = user.getGender();
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

        String sql = "INSERT INTO Users (fullName, gender, dob, specialization, role, status, email, phone, address, username, password, createdBy, createdAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getFullName() != null ? user.getFullName().trim() : null);
            stmt.setString(2, mappedGender); // Allow NULL if gender is not provided
            stmt.setDate(3, user.getDob());
            stmt.setString(4, user.getSpecialization() != null ? user.getSpecialization().trim() : null);
            stmt.setString(5, user.getRole() != null ? user.getRole().trim() : null);
            stmt.setString(6, user.getStatus() != null ? user.getStatus().trim() : "Active"); // Đảm bảo mặc định "Active"
            stmt.setString(7, user.getEmail() != null ? user.getEmail().trim() : null);
            stmt.setString(8, user.getPhone() != null ? user.getPhone().trim() : null);
            stmt.setString(9, user.getAddress() != null ? user.getAddress().trim() : null);
            stmt.setString(10, user.getUsername() != null ? user.getUsername().trim() : null);
            stmt.setString(11, user.getPassword() != null ? user.getPassword().trim() : null);
            stmt.setObject(12, createdBy, java.sql.Types.INTEGER);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

  public List<Users> getAllEmployee() throws SQLException {
    List<Users> users = new ArrayList<>();
    String sql = "SELECT UserID, Username, [Password], Email, FullName, Dob, Gender, Phone, [Address], MedicalHistory, Specialization, [Role], [Status], CreatedBy, CreatedAt, UpdatedAt FROM Users WHERE Role IN ('doctor', 'nurse','receptionist')";
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

        if (!rs.isBeforeFirst()) {
            System.out.println("Không có bản ghi nào được tìm thấy.");
        }

        while (rs.next()) {
            Users user = new Users();
            try {
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
                System.out.println("Đã ánh xạ: UserID=" + user.getUserID() + ", FullName=" + user.getFullName() + ", Role=" + user.getRole());
            } catch (SQLException e) {
                System.out.println("Lỗi ánh xạ tại UserID=" + (rs.getObject("UserID") != null ? rs.getInt("UserID") : "null") + ": " + e.getMessage());
                e.printStackTrace();
            }
        }
        System.out.println("Số lượng người dùng lấy được: " + users.size());
    } catch (SQLException e) {
        System.out.println("Lỗi SQL: " + e.getMessage() + ", SQLState: " + e.getSQLState() + ", Error Code: " + e.getErrorCode());
        e.printStackTrace();
        throw e; // Ném lại ngoại lệ để Servlet xử lý
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
        stmt.setString(1, user.getFullName());
        stmt.setString(2, user.getGender());
        stmt.setString(3, user.getSpecialization());
        stmt.setDate(4, user.getDob());
        stmt.setString(5, user.getStatus()); // This will be "Active"
        stmt.setInt(6, user.getUserID());
        System.out.println("Executing update for UserID: " + user.getUserID() + ", FullName: " + user.getFullName());
        int rowsAffected = stmt.executeUpdate();
        System.out.println("Rows affected: " + rowsAffected);
        if (rowsAffected > 0) {
            conn.commit();
            return true;
        } else {
            conn.rollback();
            return false;
        }
    } catch (SQLException e) {
        System.out.println("SQLException in UserDAO.updateEmployee: " + e.getMessage());
        throw e;
    }
}
public boolean deleteEmployee(int userID) throws SQLException {
        String sql = "DELETE FROM Users WHERE userID = ? AND Role IN ('Doctor', 'Nurse', 'Receptionist')";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userID);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi xóa nhân viên khỏi cơ sở dữ liệu: " + e.getMessage(), e);
        }
    }

public boolean UpdatePatient(Users patient) throws SQLException {
            String sql = "UPDATE Users SET FullName = ?, Gender = ?, Dob = ?, Phone = ?, Address = ?, Status = ? WHERE UserID = ? AND Role = 'patient'";
              try (Connection conn = dbContext.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {
                conn.setAutoCommit(false);
                stmt.setString(1, patient.getFullName());
                stmt.setString(2, patient.getGender());
                stmt.setDate(3, patient.getDob());
                stmt.setString(4, patient.getPhone());
                stmt.setString(5, patient.getAddress());
                stmt.setString(6, patient.getStatus());
                stmt.setInt(7, patient.getUserID());
                System.out.println("Executing update for UserID: " + patient.getUserID() + ", FullName: " + patient.getFullName());
                int rowsAffected = stmt.executeUpdate();
                System.out.println("Rows affected: " + rowsAffected);
                if (rowsAffected > 0) {
                    conn.commit();
                    return true;
                } else {
                    conn.rollback();
                    return false;
                }
            } catch (SQLException e) {
                System.out.println("SQLException in UserDAO.updatePatient: " + e.getMessage());
                throw e;
            }
        }

}




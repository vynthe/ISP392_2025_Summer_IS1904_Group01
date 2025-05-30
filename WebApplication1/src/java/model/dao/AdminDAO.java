package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import model.entity.Admins;
import org.mindrot.jbcrypt.BCrypt;

public class AdminDAO {

    private final DBContext dbContext;

    public AdminDAO() {
        this.dbContext = DBContext.getInstance();
    }

    /**
     * Kiểm tra xem đã có admin nào trong bảng Admins chưa
     */
    public boolean checkIfAdminExists() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Admins";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            System.out.println("AdminDAO: Kiểm tra số lượng admin trong database...");
            if (rs.next()) {
                int count = rs.getInt(1);
                System.out.println("AdminDAO: Số lượng admin: " + count);
                return count > 0;
            }
        } catch (SQLException e) {
            System.err.println("AdminDAO: Lỗi khi kiểm tra admin tồn tại: " + e.getMessage());
            throw e;
        }
        return false;
    }

    /**
     * Tạo admin mặc định với các trường tối thiểu
     */
   public void createDefaultAdmin(String username, String plainPassword) throws SQLException {
    String sql = "INSERT INTO Admins (username, password, status, createdAt, updatedAt) VALUES (?, ?, ?, ?, ?)";
    try (Connection conn = dbContext.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
         
        // Hash password tại đây
        String hashedPassword = BCrypt.hashpw(plainPassword, BCrypt.gensalt());

        stmt.setString(1, username);
        stmt.setString(2, hashedPassword);
        stmt.setString(3, "active");
        stmt.setDate(4, new Date(System.currentTimeMillis()));
        stmt.setDate(5, new Date(System.currentTimeMillis()));
        
        int rowsAffected = stmt.executeUpdate();
        System.out.println("AdminDAO: Đã tạo admin mặc định, rows affected: " + rowsAffected);
        
        if (rowsAffected == 0) {
            throw new SQLException("Không thể chèn tài khoản admin mặc định.");
        }
    } catch (SQLException e) {
        System.err.println("AdminDAO: Lỗi khi tạo admin mặc định: " + e.getMessage());
        throw e;
    }
}

    /**
     * Tìm admin dựa trên email hoặc username
     */
    public Admins findAdminByEmailOrUsername(String emailOrUsername) throws SQLException {
        String sql = "SELECT * FROM Admins WHERE email = ? OR username = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, emailOrUsername);
            stmt.setString(2, emailOrUsername);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Admins admin = new Admins();
                    admin.setAdminID(rs.getInt("adminID"));
                    admin.setUsername(rs.getString("username"));
                    admin.setPassword(rs.getString("password"));
                    admin.setFullName(rs.getString("fullName"));
                    admin.setEmail(rs.getString("email"));
                    admin.setStatus(rs.getString("status"));
                    admin.setCreatedAt(rs.getDate("createdAt"));
                    admin.setUpdatedAt(rs.getDate("updatedAt"));
                    System.out.println("AdminDAO: Tìm thấy admin: " + admin.getUsername());
                    return admin;
                }
            }
        } catch (SQLException e) {
            System.err.println("AdminDAO: Lỗi khi tìm admin: " + e.getMessage());
            throw e;
        }
        System.out.println("AdminDAO: Không tìm thấy admin với email/username: " + emailOrUsername);
        return null;
    }

    /**
     * Tạo tài khoản admin mới
     */
   public int createAdmin(Admins admin) throws SQLException {
    String sql = "INSERT INTO Admins (username, password, fullName, email, status, createdAt, updatedAt) VALUES (?, ?, ?, ?, ?, ?, ?)";
    try (Connection conn = dbContext.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
         
        // Tự động hash nếu chuỗi password chưa phải BCrypt
        String password = admin.getPassword();
        if (password != null && !password.startsWith("$2a$") && !password.startsWith("$2b$")) {
            password = BCrypt.hashpw(password, BCrypt.gensalt());
        }

        stmt.setString(1, admin.getUsername());
        stmt.setString(2, password);
        stmt.setString(3, admin.getFullName());
        stmt.setString(4, admin.getEmail());
        stmt.setString(5, admin.getStatus());
        stmt.setDate(6, admin.getCreatedAt());
        stmt.setDate(7, admin.getUpdatedAt());

        int rowsAffected = stmt.executeUpdate();
        if (rowsAffected > 0) {
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    System.out.println("AdminDAO: Đã tạo admin mới, ID: " + rs.getInt(1));
                    return rs.getInt(1);
                }
            }
        } else {
            throw new SQLException("Không thể tạo admin mới.");
        }
    } catch (SQLException e) {
        System.err.println("AdminDAO: Lỗi khi tạo admin mới: " + e.getMessage());
        throw e;
    }
    return -1;
}
     public void updateAdmin(Admins admin) throws SQLException {
        String sql = "UPDATE Admins SET fullName = ?, email = ?, username = ?, updatedAt = ? WHERE adminID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, admin.getFullName());
            stmt.setString(2, admin.getEmail());
            stmt.setString(3, admin.getUsername());
            stmt.setDate(4, new Date(System.currentTimeMillis()));
            stmt.setInt(5, admin.getAdminID());

            int rows = stmt.executeUpdate();
            if (rows == 0) {
                throw new SQLException("Không tìm thấy admin để cập nhật.");
            }
            System.out.println("AdminDAO: Cập nhật admin thành công, rows affected: " + rows);
        } catch (SQLException e) {
            System.err.println("AdminDAO: Lỗi khi cập nhật admin: " + e.getMessage());
            throw e;
        }
    }
      public Admins getAdminById(int adminID) throws SQLException {
    String sql = "SELECT * FROM Admins WHERE adminID = ?";
    try (Connection conn = dbContext.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setInt(1, adminID);
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                Admins admin = new Admins();
                admin.setAdminID(rs.getInt("adminID"));
                admin.setUsername(rs.getString("username"));
                admin.setPassword(rs.getString("password"));
                admin.setFullName(rs.getString("fullName"));
                admin.setEmail(rs.getString("email"));
                admin.setStatus(rs.getString("status"));
                admin.setCreatedAt(rs.getDate("createdAt"));
                admin.setUpdatedAt(rs.getDate("updatedAt"));
                return admin;
            }
        }
    }
    return null;
}
}
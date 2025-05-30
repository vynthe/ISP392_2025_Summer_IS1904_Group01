package model.service;

import java.sql.Date;
import java.sql.SQLException;
import model.dao.AdminDAO;
import model.entity.Admins;
import org.mindrot.jbcrypt.BCrypt;

public class AdminService {

    private final AdminDAO adminDAO;

    public AdminService() {
        this.adminDAO = new AdminDAO();
    }

    /**
     * Xác thực admin dựa trên email/username và password
     */
    public Admins authenticateAdmin(String emailOrUsername, String password) throws SQLException {
        System.out.println("AdminService: Thử xác thực admin với email/username: " + emailOrUsername);
        Admins admin = adminDAO.findAdminByEmailOrUsername(emailOrUsername);
        if (admin != null) {
            System.out.println("AdminService: Tìm thấy admin, kiểm tra mật khẩu...");
            if (BCrypt.checkpw(password, admin.getPassword())) {
                System.out.println("AdminService: Xác thực thành công cho admin: " + emailOrUsername);
                return admin;
            } else {
                System.out.println("AdminService: Mật khẩu không khớp cho admin: " + emailOrUsername);
            }
        } else {
            System.out.println("AdminService: Không tìm thấy admin với email/username: " + emailOrUsername);
        }
        return null;
    }

    /**
     * Tạo tài khoản admin mới
     */
    public boolean createAdmin(Admins admin) throws SQLException {
        System.out.println("AdminService: Tạo admin mới: " + admin.getUsername());
        if (admin.getPassword() == null || admin.getPassword().trim().isEmpty()) {
            throw new IllegalArgumentException("Mật khẩu không được để trống.");
        }

        // Gán mặc định các giá trị nếu chưa có
        admin.setStatus(admin.getStatus() != null ? admin.getStatus() : "active");
        admin.setCreatedAt(new Date(System.currentTimeMillis()));
        admin.setUpdatedAt(new Date(System.currentTimeMillis()));

        int result = adminDAO.createAdmin(admin); // DAO sẽ tự hash password nếu cần
        return result > 0;
    }

    /**
     * Kiểm tra xem đã có admin nào trong bảng chưa
     */
    public boolean checkIfAdminExists() throws SQLException {
        System.out.println("AdminService: Kiểm tra admin tồn tại...");
        return adminDAO.checkIfAdminExists();
    }

    /**
     * Tạo tài khoản admin mặc định
     * @param username tên đăng nhập
     * @param password mật khẩu (plaintext, sẽ được mã hóa bởi DAO)
     * @throws SQLException nếu có lỗi khi thêm vào database
     */
    public void createDefaultAdmin(String username, String password) throws SQLException {
        Admins admin = new Admins();
        admin.setUsername(username);
        admin.setPassword(password); // plaintext — sẽ được DAO hash
        admin.setFullName("Default Admin");
        admin.setEmail(username + "@example.com");
        admin.setStatus("active");
        admin.setCreatedAt(new Date(System.currentTimeMillis()));
        admin.setUpdatedAt(new Date(System.currentTimeMillis()));

        adminDAO.createAdmin(admin); // DAO tự hash password
    }
    public void updateAdminProfile(Admins admin) throws SQLException {
        adminDAO.updateAdmin(admin); // Gọi phương thức từ DAO
        System.out.println("AdminService: Cập nhật admin thành công qua DAO.");
    }
     public Admins getAdminById(int adminID) throws SQLException {
        return adminDAO.getAdminById(adminID);
    }
}

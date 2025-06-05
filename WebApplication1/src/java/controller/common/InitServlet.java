package controller.common;

import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Logger;
import java.util.logging.Level;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.service.AdminService;
import model.entity.Admins;

/**
 * Servlet khởi tạo để tạo tài khoản admin mặc định
 */
public class InitServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(InitServlet.class.getName());
    private AdminService adminService;

    @Override
    public void init() throws ServletException {
        try {
            LOGGER.log(Level.INFO, "InitServlet: Bắt đầu khởi tạo...");
            adminService = new AdminService();

            boolean adminExists = adminService.checkIfAdminExists();
            LOGGER.log(Level.INFO, "InitServlet: Admin đã tồn tại? {0}", adminExists);

            if (!adminExists) {
                LOGGER.log(Level.INFO, "InitServlet: Chưa có admin, đang tạo tài khoản mặc định...");

                // Dùng entity Admins để tạo admin mặc định
                Admins defaultAdmin = new Admins();
                defaultAdmin.setUsername("admin");
                defaultAdmin.setPassword("admin123"); // sẽ được mã hóa trong AdminService
                defaultAdmin.setFullName("Default Admin");
                defaultAdmin.setEmail("admin@example.com");

                boolean created = adminService.createAdmin(defaultAdmin);

                if (created) {
                    LOGGER.log(Level.INFO, "InitServlet: Đã tạo tài khoản admin mặc định: username=admin, password=admin123");
                } else {
                    throw new ServletException("Không thể tạo tài khoản admin mặc định.");
                }
            } else {
                LOGGER.log(Level.INFO, "InitServlet: Đã có tài khoản admin trong database, không cần tạo mới.");
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "InitServlet: Lỗi khi tạo tài khoản admin: {0}", e.getMessage());
            throw new ServletException("Không thể tạo tài khoản admin mặc định", e);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "InitServlet: Lỗi không xác định: {0}", e.getMessage());
            throw new ServletException("Lỗi không xác định khi khởi tạo", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.getWriter().write("Khởi tạo ứng dụng hoàn tất.");
    }

    @Override
    public String getServletInfo() {
        return "Servlet khởi tạo để tạo tài khoản admin mặc định";
    }
}

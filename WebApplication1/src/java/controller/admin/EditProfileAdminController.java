package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Date;
import model.entity.Admins;
import model.service.AdminService;

@WebServlet(name = "EditProfileAdminController", urlPatterns = {"/EditProfileAdminController"})
public class EditProfileAdminController extends HttpServlet {

    private final AdminService adminService = new AdminService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Admins admin = (Admins) session.getAttribute("admin");
        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/views/admin/login.jsp");
            return;
        }

        request.setAttribute("admin", admin);
        request.getRequestDispatcher("/views/admin/EditProfileAdmin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); // Đảm bảo hỗ trợ tiếng Việt
        HttpSession session = request.getSession();
        Admins admin = (Admins) session.getAttribute("admin");

        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/views/admin/login.jsp");
            return;
        }

        try {
            // Kiểm tra adminID
            if (admin.getAdminID() == 0) {
                throw new ServletException("AdminID không hợp lệ.");
            }

            // Lấy dữ liệu từ form
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String username = request.getParameter("username");

            // Cập nhật thông tin admin
            admin.setFullName(fullName);
            admin.setEmail(email);
            admin.setUsername(username);
            admin.setUpdatedAt(new Date(System.currentTimeMillis()));

            // Gọi AdminService để cập nhật
            adminService.updateAdminProfile(admin);

            // Cập nhật session
            session.setAttribute("admin", admin);
            request.setAttribute("success", "Cập nhật hồ sơ admin thành công.");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi cơ sở dữ liệu: " + e.getMessage());
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
            request.setAttribute("error", "Dữ liệu không hợp lệ: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }

        // Cập nhật lại thuộc tính admin trong request
        request.setAttribute("admin", session.getAttribute("admin"));
        request.getRequestDispatcher("/views/admin/EditProfileAdmin.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý cập nhật hồ sơ admin";
    }
}
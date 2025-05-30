package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

import model.entity.Admins;
import model.service.AdminService;

@WebServlet(name = "AdminProfileController", urlPatterns = {"/AdminProfileController"})
public class AdminProfileController extends HttpServlet {

    private final AdminService adminService = new AdminService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy session hiện tại
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("admin") == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // Lấy admin hiện tại từ session
            Admins currentAdmin = (Admins) session.getAttribute("admin");

            // Load lại thông tin admin mới nhất từ DB
            Admins adminProfile = adminService.getAdminById(currentAdmin.getAdminID());
            if (adminProfile == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Admin not found");
                return;
            }

            // Gửi dữ liệu sang JSP
            request.setAttribute("adminProfile", adminProfile);
            request.getRequestDispatcher("/views/admin/AdminProfile.jsp").forward(request, response);

        } catch (SQLException ex) {
            ex.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + ex.getMessage());
        }
    }
}



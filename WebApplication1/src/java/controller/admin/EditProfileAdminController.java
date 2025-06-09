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
    //khởi tạo đối tượng AdminService để gọi các phương thức xử lý logic nghiệp vụ

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //lấy session hiện tại 
        HttpSession session = request.getSession();
        //lấy đối tượng admin từ session
        Admins admin = (Admins) session.getAttribute("admin");
        //kiểm tra nếu admin chưa đăng nhập 
        if (admin == null) {
            // thì chuyển hướng về trang đăng nhập
            response.sendRedirect(request.getContextPath() + "/views/admin/login.jsp");
            return;
        }

        // đặt đối tượng admin vào request để sử dụng trong jsp
        request.setAttribute("admin", admin);
        //Chuyển tiếp yêu cầu đến trang JSP để hiển thị form chỉnh sửa hồ sơ
        request.getRequestDispatcher("/views/admin/EditProfileAdmin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); // Đảm bảo hỗ trợ tiếng Việt
        HttpSession session = request.getSession(); //session hien tai
        Admins admin = (Admins) session.getAttribute("admin"); //lay admin tu session

        if (admin == null) {//ktra xem admin da login chua 
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
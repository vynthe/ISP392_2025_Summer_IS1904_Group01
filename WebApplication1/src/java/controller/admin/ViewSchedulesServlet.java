package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Users;
import model.service.UserService;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "ViewSchedulesServlet", urlPatterns = {"/ViewSchedulesServlet", "/admin/schedules"})
public class ViewSchedulesServlet extends HttpServlet {
    
    private UserService userService;
    
    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra session admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String keyword = request.getParameter("keyword");
        List<Users> employees = null;
        
        try {
            if (keyword != null && !keyword.trim().isEmpty()) {
                employees = userService.searchEmployees(keyword.trim());
                request.setAttribute("message", "Tìm thấy " + employees.size() + " nhân viên với từ khóa: " + keyword);
            } else {
                employees = userService.getAllEmployee(); // Lấy tất cả nhân viên
            }
            
            request.setAttribute("employees", employees);
            request.setAttribute("keyword", keyword); // Giữ lại keyword cho ô tìm kiếm
            
            // Thêm thông tin phân trang nếu cần
            int totalEmployees = employees != null ? employees.size() : 0;
            request.setAttribute("totalEmployees", totalEmployees);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải danh sách nhân viên: " + e.getMessage());
            // Đặt danh sách rỗng để tránh null pointer
            request.setAttribute("employees", List.of());
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.setAttribute("employees", List.of());
        }
        
        // Chuyển tiếp đến trang JSP để hiển thị
        request.getRequestDispatcher("/views/admin/ViewSchedules.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Xử lý POST request giống như GET
        doGet(request, response);
    }
}
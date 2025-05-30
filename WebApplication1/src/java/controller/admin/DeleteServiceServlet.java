
package controller.admin;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.service.Services_Service;

@WebServlet(name = "DeleteServiceServlet", urlPatterns = {"/DeleteServiceServlet", "/admin/deleteService"})
public class DeleteServiceServlet extends HttpServlet {

    private Services_Service servicesService;

    @Override
    public void init() throws ServletException {
        servicesService = new Services_Service();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");

        // Lấy ID từ tham số request
        String idParam = request.getParameter("id");
        try {
            int id = Integer.parseInt(idParam);
            System.out.println("Attempting to delete service with ID: " + id + " at " + LocalDateTime.now() + " +07");

            // Kiểm tra quyền admin
            HttpSession session = request.getSession();
            Integer adminId = (Integer) session.getAttribute("adminId");
            if (adminId == null) {
                adminId = 1; // Default to AdminID 1 (ensure this exists in Admins table)
                System.out.println("AdminID not found in session, using default: " + adminId + " at " + LocalDateTime.now() + " +07");
            }

            // Xóa dịch vụ thông qua Services_Service
            boolean deleted = servicesService.deleteService(id);
            if (deleted) {
                // Chuyển hướng về ViewServiceServlet với thông báo thành công
                System.out.println("Service deleted successfully: ID=" + id + " by AdminID=" + adminId + " at " + LocalDateTime.now() + " +07");
                session.setAttribute("successMessage", "Xóa dịch vụ thành công!");
            } else {
                // Nếu xóa không thành công, gửi thông báo lỗi
                System.out.println("Failed to delete service with ID: " + id + " at " + LocalDateTime.now() + " +07");
                session.setAttribute("error", "Không thể xóa dịch vụ với ID: " + id);
            }
            response.sendRedirect(request.getContextPath() + "/ViewServiceServlet");
        } catch (NumberFormatException e) {
            // Xử lý lỗi nếu ID không hợp lệ
            System.out.println("Invalid ID format: " + idParam + " at " + LocalDateTime.now() + " +07");
            request.getSession().setAttribute("error", "ID dịch vụ không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/ViewServiceServlet");
        } catch (SQLException e) {
            // Xử lý lỗi cơ sở dữ liệu
            System.out.println("Database error: " + e.getMessage() + ", SQLState: " + e.getSQLState() + ", ErrorCode: " + e.getErrorCode() + " at " + LocalDateTime.now() + " +07");
            e.printStackTrace();
            request.getSession().setAttribute("error", "Lỗi khi xóa dịch vụ: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ViewServiceServlet");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng tất cả yêu cầu POST sang doGet để xử lý thống nhất
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet for deleting a service directly from ViewServiceServlet";
    }
}
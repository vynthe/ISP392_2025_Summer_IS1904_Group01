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

        HttpSession session = request.getSession();
        String idParam = request.getParameter("id");

        try {
            // Validate service ID
            int id = Integer.parseInt(idParam);
            System.out.println("Attempting to delete service with ID: " + id + " at " + LocalDateTime.now() + " +07");

            // Check admin authentication (optional, based on your setup)
            Integer adminId = (Integer) session.getAttribute("adminId");
            if (adminId == null) {
                adminId = 1; // Default to AdminID 1 (ensure this exists in Admins table)
                System.out.println("AdminID not found in session, using default: " + adminId + " at " + LocalDateTime.now() + " +07");
            }

            // Attempt to delete the service
            boolean deleted = servicesService.deleteService(id);
            if (deleted) {
                session.setAttribute("successMessage", "Xóa dịch vụ thành công!");
                System.out.println("Service deleted successfully: ID=" + id + " by AdminID=" + adminId + " at " + LocalDateTime.now() + " +07");
            } else {
                session.setAttribute("error", "Không thể xóa dịch vụ với ID: " + id);
                System.out.println("Failed to delete service with ID: " + id + " at " + LocalDateTime.now() + " +07");
            }
        } catch (NumberFormatException e) {
            System.out.println("Invalid ID format: " + idParam + " at " + LocalDateTime.now() + " +07");
            session.setAttribute("error", "ID dịch vụ không hợp lệ.");
        } catch (SQLException e) {
            System.out.println("Database error: " + e.getMessage() + ", SQLState: " + e.getSQLState() + ", ErrorCode: " + e.getErrorCode() + " at " + LocalDateTime.now() + " +07");
            e.printStackTrace();
            session.setAttribute("error", "Xóa Dịch Vụ Thất Bại");
        }

        // Redirect to ViewServiceServlet
        response.sendRedirect(request.getContextPath() + "/ViewServiceServlet");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect POST requests to doGet for consistent handling
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet for deleting a service and redirecting to ViewServiceServlet with appropriate message";
    }
}
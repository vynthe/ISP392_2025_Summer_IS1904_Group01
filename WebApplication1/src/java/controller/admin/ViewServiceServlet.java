
package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.Services;
import model.service.Services_Service;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "ViewServiceServlet", urlPatterns = {"/ViewServiceServlet"})
public class ViewServiceServlet extends HttpServlet {

    private Services_Service servicesService;

    @Override
    public void init() throws ServletException {
        servicesService = new Services_Service();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        try {
            // Retrieve all services
            List<Services> services = servicesService.getAllServices();
            request.setAttribute("services", services);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải danh sách dịch vụ: " + e.getMessage());
        }

        // Forward to ViewService.jsp
        request.getRequestDispatcher("/views/admin/ViewServices.jsp").forward(request, response);
            request.setCharacterEncoding("UTF-8");

    }
}
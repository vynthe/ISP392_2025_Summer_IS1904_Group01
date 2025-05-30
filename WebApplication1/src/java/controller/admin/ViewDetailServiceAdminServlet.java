
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

@WebServlet(name = "ViewDetailServiceAdminServlet", urlPatterns = {"/ViewDetailServiceAdminServlet", "/admin/ViewDetailServiceAdmin"})
public class ViewDetailServiceAdminServlet extends HttpServlet {

    private Services_Service servicesService;

    @Override
    public void init() throws ServletException {
        servicesService = new Services_Service();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
   
        String idStr = request.getParameter("id");
        try {
            int id = Integer.parseInt(idStr);
            System.out.println("Lấy thông tin chi tiết cho ServiceID=" + id + " tại 09:41 PM +07, 23/05/2025");
            Services service = servicesService.getServiceById(id); // Sử dụng phương thức từ Services_Service
            if (service != null) {
                System.out.println("Tìm thấy service: ServiceID=" + service.getServiceID() + ", ServiceName=" + service.getServiceName() + " tại 09:41 PM +07, 23/05/2025");
                request.setAttribute("service", service);
            } else {
                System.out.println("Không tìm thấy service với ServiceID=" + id + " tại 09:41 PM +07, 23/05/2025");
            }
            request.getRequestDispatcher("/views/admin/ViewDetailServiceAdmin.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            System.out.println("Lỗi: ID không hợp lệ tại 09:41 PM +07, 23/05/2025: " + e.getMessage());
            request.setAttribute("error", "ID không hợp lệ");
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        } catch (SQLException e) {
            System.out.println("Lỗi SQL trong ViewDetailServiceServlet tại 09:41 PM +07, 23/05/2025: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi không xác định: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
 
        // Redirect POST requests to GET to prevent form resubmission
        response.sendRedirect(request.getContextPath() + "/ViewDetailServiceAdminServlet");
    }
}
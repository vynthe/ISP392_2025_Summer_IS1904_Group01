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
            // Chuyển đổi ID thành số nguyên
            int id = Integer.parseInt(idStr);
            System.out.println("Lấy thông tin chi tiết cho ServiceID=" + id + " tại 09:41 PM +07, 23/05/2025");
            
            // Lấy thông tin dịch vụ từ Services_Service
            Services service = servicesService.getServiceById(id);
            if (service != null) {
                System.out.println("Tìm thấy service: ServiceID=" + service.getServiceID() + ", ServiceName=" + service.getServiceName() + " tại 09:41 PM +07, 23/05/2025");
                // Gửi dữ liệu dịch vụ đến JSP
                request.setAttribute("service", service);
            } else {
                System.out.println("Không tìm thấy service với ServiceID=" + id + " tại 09:41 PM +07, 23/05/2025");
            }
            // Chuyển hướng đến trang chi tiết dịch vụ
            request.getRequestDispatcher("/views/admin/ViewDetailServiceAdmin.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            // Xử lý lỗi khi ID không hợp lệ
            System.out.println("Lỗi: ID không hợp lệ tại 09:41 PM +07, 23/05/2025: " + e.getMessage());
            request.setAttribute("error", "ID không hợp lệ");
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        } catch (SQLException e) {
            // Xử lý lỗi cơ sở dữ liệu
            System.out.println("Lỗi SQL trong ViewDetailServiceAdminServlet tại 09:41 PM +07, 23/05/2025: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi không xác định: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8"); 
        // Chuyển hướng POST sang GET
        response.sendRedirect(request.getContextPath() + "/ViewDetailServiceAdminServlet");
    }
}
package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Services;
import model.service.Services_Service;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "ViewServiceByCategoryServlet", urlPatterns = {"/ViewServiceByCategoryServlet"})
public class ViewServiceByCategoryServlet extends HttpServlet {

    private Services_Service servicesService;

    @Override
    public void init() throws ServletException {
        servicesService = new Services_Service();
    }

 @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    response.setCharacterEncoding("UTF-8");

    // Kiểm tra xem người dùng đã đăng nhập hay chưa
    HttpSession session = request.getSession(false);
    boolean isLoggedIn = session != null && session.getAttribute("user") != null; // Giả sử "user" là thuộc tính lưu thông tin người dùng sau đăng nhập

    String category = request.getParameter("category");
    if (category == null || category.trim().isEmpty()) {
        System.out.println("Lỗi: Danh mục không hợp lệ tại 07:10 PM +07, 29/05/2025");
        request.setAttribute("error", "Danh mục không hợp lệ");
        request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        return;
    }

    try {
        System.out.println("Lấy danh sách dịch vụ cho danh mục=" + category + " tại 07:10 PM +07, 29/05/2025");
        List<Services> services = servicesService.getServicesByCategory(category);
        if (services.isEmpty()) {
            System.out.println("Không tìm thấy dịch vụ nào cho danh mục=" + category + " tại 07:10 PM +07, 29/05/2025");
        } else {
            System.out.println("Tìm thấy " + services.size() + " dịch vụ cho danh mục=" + category + " tại 07:10 PM +07, 29/05/2025");
        }
        request.setAttribute("services", services);
        request.setAttribute("category", category);

        // Chuyển hướng đến JSP dựa trên trạng thái đăng nhập
        if (!isLoggedIn) {
            // Người dùng chưa đăng nhập (ngầm hiểu là "guest")
            request.getRequestDispatcher("/views/user/ViewServicesByCategory.jsp").forward(request, response);
        } else {
            // Người dùng đã đăng nhập (patient)
            request.getRequestDispatcher("/views/user/Patient/ViewServicesByCategoryPatient.jsp").forward(request, response);
        }
    } catch (SQLException e) {
        System.out.println("Lỗi SQL trong ViewServiceByCategoryServlet tại 07:10 PM +07, 29/05/2025: " + e.getMessage());
        e.printStackTrace();
        request.setAttribute("error", "Lỗi không xác định: " + e.getMessage());
        request.getRequestDispatcher("/views/error.jsp").forward(request, response);
    }
}

@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    doGet(request, response); // Chuyển hướng POST về GET
}
}
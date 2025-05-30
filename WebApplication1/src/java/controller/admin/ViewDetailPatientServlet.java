package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.Users;
import model.service.UserService;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "ViewDetailPatientServlet", urlPatterns = {"/ViewPatientDetailServlet"})
public class ViewDetailPatientServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        try {
            int id = Integer.parseInt(idStr);
            System.out.println("Lấy thông tin chi tiết cho bệnh nhân với UserID=" + id + " tại 08:58 AM +07, 23/05/2025");
            Users user = userService.getPatientByID(id); // Giả sử bạn có phương thức getPatientByID trong UserService
            if (user != null) {
                System.out.println("Tìm thấy bệnh nhân: UserID=" + user.getUserID() + ", FullName=" + user.getFullName() + " tại 08:58 AM +07, 23/05/2025");
                request.setAttribute("user", user);
            } else {
                System.out.println("Không tìm thấy bệnh nhân với UserID=" + id + " tại 08:58 AM +07, 23/05/2025");
            }
            request.getRequestDispatcher("/views/admin/ViewDetailPatient.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            System.out.println("Lỗi: ID không hợp lệ tại 08:58 AM +07, 23/05/2025: " + e.getMessage());
            request.setAttribute("error", "ID không hợp lệ");
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        } catch (SQLException e) {
            System.out.println("Lỗi SQL trong ViewDetailPatientServlet tại 08:58 AM +07, 23/05/2025: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi không xác định: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }
}

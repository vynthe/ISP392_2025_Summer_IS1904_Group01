package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.service.UserService;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/DeleteDoctorServlet")
public class DeleteDoctorServlet extends HttpServlet {
    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userIdStr = request.getParameter("id");
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            request.setAttribute("error", "Thiếu tham số ID.");
            request.getRequestDispatcher("/views/admin/ViewEmployees.jsp").forward(request, response);
            return;
        }

        try {
            int userID = Integer.parseInt(userIdStr);
            System.out.println("Processing deletion for userID: " + userID);
            boolean deleted = userService.deleteEmployee(userID);
            if (deleted) {
                response.sendRedirect(request.getContextPath() + "/ViewEmployeeServlet?success=Xóa nhân viên thành công");
            } else {
                request.setAttribute("error", "Xóa nhân viên thất bại. Nhân viên không tồn tại hoặc không thể xóa.");
                request.getRequestDispatcher("/views/admin/ViewEmployees.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID nhân viên không hợp lệ.");
            request.getRequestDispatcher("/views/admin/ViewEmployees.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi khi xóa nhân viên: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/ViewEmployees.jsp").forward(request, response);
        }
    }
}
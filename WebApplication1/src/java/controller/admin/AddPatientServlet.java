package controller.admin;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.service.UserService;
// import org.mindrot.jbcrypt.BCrypt; // KHÔNG CẦN DÙNG TRỰC TIẾP BCrypt Ở ĐÂY NỮA

@WebServlet(name = "AddPatientServlet", urlPatterns = {"/AddPatientServlet"})
public class AddPatientServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/admin/AddPatient.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Retrieve form parameters
        String fullName = request.getParameter("fullName");
        String gender = request.getParameter("gender");
        String dobStr = request.getParameter("dob");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Retain form values in case of error
        request.setAttribute("fullName", fullName);
        request.setAttribute("gender", gender);
        request.setAttribute("dob", dobStr);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
        request.setAttribute("address", address);
        request.setAttribute("username", username);
        request.setAttribute("password", password); 

        Date dob = null;
        try {
            if (dobStr != null && !dobStr.trim().isEmpty()) {
                dob = Date.valueOf(dobStr);
            }
        } catch (IllegalArgumentException e) {
           
        }

        // Get the admin ID from session
        HttpSession session = request.getSession();
        // Lấy UserID của admin đang đăng nhập.
        Integer createdBy = (Integer) session.getAttribute("loggedInUserId"); // Sử dụng tên thuộc tính session hợp lý
        if (createdBy == null) {
            System.err.println("Admin ID not found in session, defaulting to 1.");
            createdBy = 1; // Giá trị mặc định 
        }

        try {
           
            boolean success = userService.addUser(fullName, gender, dob, null, "patient", "Active", email, phone, address, username, password, createdBy);

            if (success) {
                System.out.println("Thêm bệnh nhân thành công: " + fullName + ", Email: " + email);
                session.setAttribute("successMessage", "Thêm bệnh nhân thành công!");
                response.sendRedirect(request.getContextPath() + "/ViewPatientServlet");
            } else {
                System.out.println("Thêm bệnh nhân thất bại: Email, username hoặc số điện thoại có thể đã tồn tại.");
                request.setAttribute("error", "Không thể thêm bệnh nhân. Email, username hoặc số điện thoại có thể đã tồn tại.");
                request.getRequestDispatcher("/views/admin/AddPatient.jsp").forward(request, response);
            }
        } catch (SQLException | IllegalArgumentException e) { // Bắt cả SQLException và IllegalArgumentException từ UserService
            System.err.println("Lỗi khi thêm bệnh nhân: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage()); // Hiển thị thông báo lỗi chi tiết từ Service
            request.getRequestDispatcher("/views/admin/AddPatient.jsp").forward(request, response);
        }
    }
}
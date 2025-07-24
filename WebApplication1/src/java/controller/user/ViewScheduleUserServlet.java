package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.ScheduleEmployee;
import model.entity.Users;
import model.service.SchedulesService;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "ViewScheduleUserServlet", urlPatterns = {"/ViewScheduleUserServlet"})
public class ViewScheduleUserServlet extends HttpServlet {

    private SchedulesService scheduleService;

    @Override
    public void init() throws ServletException {
        scheduleService = new SchedulesService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String destinationPage = "/views/common/login.jsp"; // Default page
        HttpSession session = request.getSession(false);

        // Kiểm tra session để xác thực người dùng
        Users user = null;
        String role = null;
        int userId = 0;

        if (session == null || session.getAttribute("user") == null) {
            request.setAttribute("error", "Vui lòng đăng nhập để xem lịch làm việc.");
            request.getRequestDispatcher(destinationPage).forward(request, response);
            return;
        }

        // Lấy đối tượng Users từ session
        user = (Users) session.getAttribute("user");
        role = user.getRole() != null ? user.getRole().toLowerCase() : null;
        userId = user.getUserID();

        // Validate role
        if (role == null || (!"doctor".equals(role) && !"nurse".equals(role) && !"receptionist".equals(role))) {
            System.out.println("Invalid role detected: " + role);
            request.setAttribute("error", "Vai trò người dùng không hợp lệ: " + (role != null ? role : "không xác định"));
            destinationPage = "/views/common/error.jsp";
            request.getRequestDispatcher(destinationPage).forward(request, response);
            return;
        }

        System.out.println("Role: " + role + ", UserID: " + userId); // Debug output

        try {
            // Lấy danh sách lịch làm việc của user cụ thể
            List<ScheduleEmployee> schedules = scheduleService.getAllSchedulesByUserId(userId);

            // Kiểm tra nếu không có lịch
            if (schedules == null || schedules.isEmpty()) {
                System.out.println("No schedules found for user ID: " + userId);
                request.setAttribute("error", "Không tìm thấy lịch làm việc cho bạn.");
                destinationPage = "/views/common/error.jsp";
            } else {
                System.out.println("Schedules retrieved: " + schedules.size());
                request.setAttribute("schedules", schedules);
                request.setAttribute("scheduleDetails", schedules); // Để tương thích với JSP

                // Xác định trang đích dựa trên vai trò
                switch (role) {
                    case "doctor":
                    case "nurse":
                        destinationPage = "/views/user/DoctorNurse/ViewScheduleEmployee.jsp";
                        break;
                    case "receptionist":
                        destinationPage = "/views/user/Receptionist/ViewScheduleReceptionist.jsp";
                        break;
                    default:
                        destinationPage = "/views/common/error.jsp";
                        request.setAttribute("error", "Không xác định được trang hiển thị lịch làm việc.");
                        break;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("SQLException: " + e.getMessage());
            request.setAttribute("error", "Lỗi cơ sở dữ liệu khi tải lịch làm việc: " + e.getMessage());
            destinationPage = "/views/common/error.jsp";
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Unexpected error: " + e.getMessage());
            request.setAttribute("error", "Lỗi hệ thống không xác định. Vui lòng thử lại sau.");
            destinationPage = "/views/common/error.jsp";
        }

        // Chuyển tiếp đến trang JSP tương ứng
        System.out.println("Forwarding to: " + destinationPage);
        request.getRequestDispatcher(destinationPage).forward(request, response);
    }
}

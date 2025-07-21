package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Admins;
import model.entity.Users;
import model.service.SchedulesService;
import model.service.UserService;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "AddScheduleServlet", urlPatterns = {"/AddScheduleServlet"})
public class AddScheduleServlet extends HttpServlet {
    private SchedulesService scheduleService;
    private UserService userService;

    @Override
    public void init() throws ServletException {
        scheduleService = new SchedulesService();
        userService = new UserService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            System.out.println("No session or admin found. Redirecting to login.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Admins admin = (Admins) session.getAttribute("admin");
        Integer createdBy = admin != null ? admin.getAdminID() : null;

        if (createdBy == null) {
            System.out.println("createdBy is null. Admin ID not found in session.");
            request.setAttribute("error", "Lỗi: Không tìm thấy ID người tạo lịch trong phiên. Vui lòng đăng nhập lại.");
            request.getRequestDispatcher("/views/admin/AddSchedule.jsp").forward(request, response);
            return;
        }

        try {
            handleAutoScheduleCreation(request, response, createdBy);
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Database Error in AddScheduleServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi cơ sở dữ liệu khi tạo lịch: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/AddSchedule.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Unexpected error in AddScheduleServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tạo lịch: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/AddSchedule.jsp").forward(request, response);
        }
    }

    private void handleAutoScheduleCreation(HttpServletRequest request, HttpServletResponse response, Integer createdBy)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        StringBuilder messages = new StringBuilder();
        StringBuilder errors = new StringBuilder();

        try {
            String startDateStr = request.getParameter("startDate");
            int weeksToCreate = Integer.parseInt(request.getParameter("weeks"));
            String roleForAutoSchedule = request.getParameter("role");

            if (weeksToCreate < 1) {
                weeksToCreate = 1;
            }

            LocalDate startDate = LocalDate.parse(startDateStr);
            LocalDate today = LocalDate.now();

            if (startDate.isBefore(today)) {
                errors.append("Lỗi: Không thể tạo lịch trong quá khứ. Ngày bắt đầu phải từ hiện tại trở đi.<br>");
            }

            if (errors.length() > 0) {
                request.setAttribute("error", errors.toString());
                request.getRequestDispatcher("/views/admin/AddSchedule.jsp").forward(request, response);
                return;
            }

            List<Users> users = userService.getUsersByRole(roleForAutoSchedule);
            if (users == null || users.isEmpty()) {
                errors.append("Lỗi: Không tìm thấy nhân viên nào cho vai trò " + roleForAutoSchedule + ".<br>");
            } else {
                List<Integer> userIds = users.stream().map(Users::getUserID).collect(Collectors.toList());
                List<String> roles = users.stream().map(Users::getRole).collect(Collectors.toList());

                int defaultRoomId = 0; // Mặc định không gán phòng
                if ("Receptionist".equalsIgnoreCase(roleForAutoSchedule)) {
                    defaultRoomId = 19; // Gán phòng mặc định cho lễ tân
                }

                try {
                    // Call the service to generate schedule for all selected users
                    scheduleService.generateSchedule(userIds, roles, createdBy, startDate, weeksToCreate, defaultRoomId);
                    if ("Receptionist".equalsIgnoreCase(roleForAutoSchedule)) {
                        messages.append("Lịch làm việc của tất cả lễ tân đã được tạo và gán vào Phòng 19 cho " + weeksToCreate + " tuần.<br>");
                    } else {
                        messages.append("Lịch làm việc của tất cả " + roleForAutoSchedule.toLowerCase() + " đã được tạo thành công cho " + weeksToCreate + " tuần.<br>");
                    }
                } catch (SQLException e) {
                    System.err.println("Lỗi tạo lịch hàng loạt: " + e.getMessage());
                    errors.append("Lỗi khi tạo lịch: " + e.getMessage() + ". Vui lòng kiểm tra dữ liệu hoặc các lịch đã có.<br>");
                }
            }
        } catch (NumberFormatException e) {
            errors.append("Lỗi: Dữ liệu nhập vào không hợp lệ (số tuần).<br>");
        } catch (IllegalArgumentException e) {
            System.err.println("Validation Error: " + e.getMessage());
            errors.append("Lỗi validation: " + e.getMessage() + ".<br>");
        }

        if (messages.length() > 0) {
            request.setAttribute("message", messages.toString());
        }
        if (errors.length() > 0) {
            request.setAttribute("error", errors.toString());
        } else if (messages.length() == 0) {
            request.setAttribute("message", "Không có lịch nào được tạo. Vui lòng kiểm tra lại thông tin.");
        }

        request.getRequestDispatcher("/views/admin/AddSchedule.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.removeAttribute("message");
        request.removeAttribute("error");
        request.getRequestDispatcher("/views/admin/AddSchedule.jsp").forward(request, response);
    }
}
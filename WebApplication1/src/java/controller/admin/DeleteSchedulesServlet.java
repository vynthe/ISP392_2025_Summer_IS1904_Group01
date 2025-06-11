package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.service.SchedulesService;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet để xóa lịch trình dựa trên scheduleID.
 * @author exorc
 */
@WebServlet(name = "DeleteSchedulesServlet", urlPatterns = {"/DeleteSchedulesServlet"})
public class DeleteSchedulesServlet extends HttpServlet {
    private SchedulesService schedulesService;

    @Override
    public void init() throws ServletException {
        schedulesService = new SchedulesService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String scheduleIdParam = request.getParameter("scheduleId");
        HttpSession session = request.getSession();

        if (scheduleIdParam != null && !scheduleIdParam.isEmpty()) {
            try {
                int scheduleId = Integer.parseInt(scheduleIdParam);
                schedulesService.deleteSchedule(scheduleId); // Gọi hàm xóa lịch trình
                session.setAttribute("message", "Xóa lịch trình thành công!"); // Thông báo thành công
            } catch (NumberFormatException e) {
                e.printStackTrace();
                session.setAttribute("error", "Schedule ID không đúng định dạng.");
            } catch (Exception ex) {
                Logger.getLogger(DeleteSchedulesServlet.class.getName()).log(Level.SEVERE, null, ex);
                session.setAttribute("error", "Lỗi khi xóa lịch trình: " + ex.getMessage());
            }
        } else {
            session.setAttribute("error", "Schedule ID không hợp lệ.");
        }

        // Chuyển hướng về trang danh sách lịch trình với các tham số tìm kiếm/phân trang
        String page = request.getParameter("page");
        String employeeName = request.getParameter("employeeName");
        String searchDate = request.getParameter("searchDate");
        String redirectUrl = request.getContextPath() + "/ViewSchedulesServlet" +
                "?page=" + (page != null ? page : "1") +
                "&employeeName=" + (employeeName != null ? employeeName : "") +
                "&searchDate=" + (searchDate != null ? searchDate : "");
        response.sendRedirect(redirectUrl);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
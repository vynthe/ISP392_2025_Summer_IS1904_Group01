package controller.admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.Services;
import model.service.RoomService;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

@WebServlet(name = "AssignServiceToRoomServlet", urlPatterns = {"/AssignServiceToRoomServlet"})
public class AssignServiceToRoomServlet extends HttpServlet {

    private final RoomService roomService = new RoomService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int roomId = Integer.parseInt(request.getParameter("roomId"));

            // Lấy danh sách dịch vụ đã gán cho phòng
            List<Services> assignedServices = roomService.getServicesByRoom(roomId);

            // Lấy danh sách tất cả dịch vụ Active
            List<Services> allServices = roomService.getAllActiveServices();

            // Lọc ra dịch vụ chưa gán
            List<Services> availableServices = allServices.stream()
                    .filter(s -> assignedServices.stream().noneMatch(a -> a.getServiceID() == s.getServiceID()))
                    .collect(Collectors.toList());

            request.setAttribute("roomId", roomId);
            request.setAttribute("assignedServices", assignedServices);
            request.setAttribute("availableServices", availableServices);

            if (request.getParameter("message") != null) {
                request.setAttribute("message", request.getParameter("message"));
            }

            request.getRequestDispatcher("/views/admin/assignService.jsp").forward(request, response);
        } catch (SQLException | NumberFormatException e) {
            Logger.getLogger(AssignServiceToRoomServlet.class.getName()).log(Level.SEVERE, null, e);
            response.getWriter().println("Lỗi: " + e.getMessage());
        }
    }

@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    response.setContentType("text/html;charset=UTF-8");

    try {
        int roomId = Integer.parseInt(request.getParameter("roomId"));
        int serviceId = Integer.parseInt(request.getParameter("serviceId"));
        int adminId = 1; // TODO: Lấy từ session nếu có

        boolean success = roomService.assignServiceToRoom(roomId, serviceId, adminId);

        String message = success ? "Gán dịch vụ thành công" : "Gán dịch vụ thất bại";
        String redirectURL = "ViewRoomServlet?message=" + java.net.URLEncoder.encode(message, "UTF-8");

        response.getWriter().println("<script>");
        response.getWriter().println("alert('" + message + "');");
        response.getWriter().println("window.location.href='" + redirectURL + "';");
        response.getWriter().println("</script>");

    } catch (Exception e) {
        e.printStackTrace();
        String error = "Lỗi xử lý dữ liệu: " + e.getMessage();
        response.getWriter().println("<script>");
        response.getWriter().println("alert('" + error + "');");
        response.getWriter().println("window.location.href='ViewRoomServlet?error=" + java.net.URLEncoder.encode(error, "UTF-8") + "';");
        response.getWriter().println("</script>");
    }
}
}
package controller.user;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.time.LocalDateTime;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.dao.ScheduleDAO;
import org.json.JSONObject;

@WebServlet("/UpdateScheduleDoctorNurseServlet")
public class UpdateScheduleDoctorNurseServlet extends HttpServlet {

    private ScheduleDAO scheduleDAO;

    @Override
    public void init() throws ServletException {
        // Khởi tạo ScheduleDAO
        scheduleDAO = new ScheduleDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Thiết lập response content type là JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JSONObject jsonResponse = new JSONObject();

        try {
            // Lấy tham số từ request
            String slotIdParam = request.getParameter("slotId");
            String newUserIdParam = request.getParameter("newUserId");

            // Kiểm tra tham số không null hoặc rỗng
            if (slotIdParam == null || slotIdParam.trim().isEmpty() ||
                newUserIdParam == null || newUserIdParam.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                jsonResponse.put("status", "error");
                jsonResponse.put("message", "Thiếu tham số slotId hoặc newUserId");
                out.print(jsonResponse);
                return;
            }

            // Chuyển đổi tham số sang int
            int slotId, newUserId;
            try {
                slotId = Integer.parseInt(slotIdParam);
                newUserId = Integer.parseInt(newUserIdParam);
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                jsonResponse.put("status", "error");
                jsonResponse.put("message", "slotId và newUserId phải là số nguyên");
                out.print(jsonResponse);
                return;
            }

            // Gọi ScheduleDAO để reassign lịch
            boolean success = scheduleDAO.reassignScheduleToUser(slotId, newUserId);

            // Trả về phản hồi thành công
            jsonResponse.put("status", "success");
            jsonResponse.put("message", "Gán lịch thành công cho SlotID " + slotId + " và UserID " + newUserId);
            out.print(jsonResponse);

        } catch (IllegalArgumentException e) {
            // Xử lý lỗi đầu vào
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            jsonResponse.put("status", "error");
            jsonResponse.put("message", e.getMessage());
            out.print(jsonResponse);

        } catch (SQLException e) {
            // Xử lý lỗi SQL
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "Lỗi server khi gán lịch: " + e.getMessage());
            System.err.println("SQLException trong ReassignDoctorNurseServlet: " + e.getMessage() + 
                              " tại " + LocalDateTime.now() + " +07");
            out.print(jsonResponse);

        } catch (Exception e) {
            // Xử lý lỗi bất ngờ
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "Lỗi bất ngờ: " + e.getMessage());
            System.err.println("Lỗi bất ngờ trong ReassignDoctorNurseServlet: " + e.getMessage() + 
                              " tại " + LocalDateTime.now() + " +07");
            out.print(jsonResponse);

        } finally {
            out.flush();
            out.close();
        }
    }

    @Override
    public void destroy() {
        // Giải phóng tài nguyên nếu cần
        scheduleDAO = null;
    }
}
package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.service.RoomService;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/DeleteRoomServlet")
public class DeleteRoomServlet extends HttpServlet {
    private RoomService roomService;

    @Override
    public void init() throws ServletException {
        roomService = new RoomService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.isEmpty()) {
            try {
                int roomID = Integer.parseInt(idParam);
                roomService.deleteRoom(roomID);  // Gọi hàm xóa phòng trong UserService
            }
            
            catch (NumberFormatException e) {
                e.printStackTrace();
                // Có thể thêm log hoặc message lỗi tùy ý
            } catch (Exception ex) {
                Logger.getLogger(DeleteRoomServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        // Chuyển hướng về trang danh sách phòng
        response.sendRedirect(request.getContextPath() + "/ViewRoomServlet");
    }
}

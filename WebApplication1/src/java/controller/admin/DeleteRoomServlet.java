package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.service.RoomService;

import java.io.IOException;
import java.sql.SQLException;
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
    response.setContentType("text/html;charset=UTF-8");

    String idParam = request.getParameter("id");

    try {
        if (idParam == null || idParam.trim().isEmpty()) {
            throw new IllegalArgumentException("Không có mã phòng được cung cấp.");
        }

        int roomID = Integer.parseInt(idParam);
        roomService.deleteRoom(roomID);
        sendJsRedirect(response, "Phòng đã được xóa thành công", false);

    } catch (NumberFormatException e) {
        Logger.getLogger(DeleteRoomServlet.class.getName()).log(Level.SEVERE, "Mã phòng không hợp lệ: " + idParam, e);
        sendJsRedirect(response, "Mã phòng không hợp lệ", true);

    } catch (SQLException e) {
        Logger.getLogger(DeleteRoomServlet.class.getName()).log(Level.SEVERE, "Lỗi SQL khi xóa phòng: " + idParam, e);
        sendJsRedirect(response, "Không thể xóa phòng: " + e.getMessage(), true);

    } catch (Exception e) {
        Logger.getLogger(DeleteRoomServlet.class.getName()).log(Level.SEVERE, "Lỗi không xác định khi xóa phòng: " + idParam, e);
        sendJsRedirect(response, "Lỗi không xác định khi xóa phòng", true);
    }
}

private void sendJsRedirect(HttpServletResponse response, String message, boolean isError) throws IOException {
    String encodedMessage = java.net.URLEncoder.encode(message, "UTF-8");
    String redirectUrl = "ViewRoomServlet?message=" + encodedMessage + (isError ? "&error=true" : "");
    response.getWriter().println("<script>");
    response.getWriter().println("alert('" + message.replace("'", "\\'") + "');");
    response.getWriter().println("window.location.href='" + redirectUrl + "';");
    response.getWriter().println("</script>");
}
}

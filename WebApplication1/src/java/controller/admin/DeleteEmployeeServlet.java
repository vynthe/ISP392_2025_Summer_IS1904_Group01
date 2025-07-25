package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.service.UserService;

import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/DeleteEmployeeServlet")
public class DeleteEmployeeServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        String idParam = request.getParameter("id");

        try {
            if (idParam == null || idParam.isBlank()) {
                throw new IllegalArgumentException("Không có userID được cung cấp.");
            }

            int userID = Integer.parseInt(idParam);
            boolean deleted = userService.deleteEmployee(userID);

            if (deleted) {
                sendJsRedirect(response, "✅ Đã xóa nhân viên thành công.", false);
            } else {
                sendJsRedirect(response, "⚠️ Không thể xóa. Nhân viên không tồn tại hoặc đang được sử dụng.", true);
            }

        } catch (NumberFormatException e) {
            Logger.getLogger(DeleteEmployeeServlet.class.getName()).log(Level.SEVERE, "ID không hợp lệ: " + idParam, e);
            sendJsRedirect(response, "❌ ID không hợp lệ.", true);

        } catch (SQLException e) {
            Logger.getLogger(DeleteEmployeeServlet.class.getName()).log(Level.SEVERE, "Lỗi SQL khi xóa nhân viên", e);
            sendJsRedirect(response, "❌ Lỗi cơ sở dữ liệu: " + e.getMessage(), true);

        } catch (Exception e) {
            Logger.getLogger(DeleteEmployeeServlet.class.getName()).log(Level.SEVERE, "Lỗi không xác định", e);
            sendJsRedirect(response, "❌ Có lỗi xảy ra: " + e.getMessage(), true);
        }
    }

    private void sendJsRedirect(HttpServletResponse response, String message, boolean isError) throws IOException {
        String encodedMessage = java.net.URLEncoder.encode(message, "UTF-8");
        String redirectUrl = "ViewEmployeeServlet?message=" + encodedMessage + (isError ? "&error=true" : "");
        response.getWriter().println("<script>");
        response.getWriter().println("alert('" + message.replace("'", "\\'") + "');");
        response.getWriter().println("window.location.href='" + redirectUrl + "';");
        response.getWriter().println("</script>");
    }
}

package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.Rooms;
import model.entity.Services;
import model.service.RoomService;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "ViewRoomDetailServlet", urlPatterns = {"/ViewRoomDetailServlet"})
public class ViewRoomDetailServlet extends HttpServlet {
    private RoomService roomService;

    @Override
    public void init() throws ServletException {
        roomService = new RoomService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String roomIDParam = request.getParameter("id");
        
        if (roomIDParam == null || roomIDParam.trim().isEmpty()) {
            request.setAttribute("error", "ID phòng không hợp lệ.");
            request.getRequestDispatcher("/views/admin/ViewRoomDetail.jsp").forward(request, response);
            return;
        }

        try {
            int roomID = Integer.parseInt(roomIDParam);
            
            // Lấy thông tin phòng
            Rooms room = roomService.getRoomByID(roomID);
            
            if (room != null) {
                request.setAttribute("room", room);
                
                // Lấy danh sách bệnh nhân
                List<String> patients = roomService.getPatientsByRoomId(roomID);
                request.setAttribute("patients", patients.isEmpty() ? 
                    List.of("Không có bệnh nhân") : patients);
                
                // Lấy danh sách dịch vụ (trả về Objects Services thay vì Strings)
                List<Services> services = roomService.getServicesByRoom(roomID);
                request.setAttribute("services", services);
                
                // Nếu bạn muốn lấy tên dịch vụ dạng String thì dùng:
                List<String> serviceNames = roomService.getServicesByRoomId(roomID);
                request.setAttribute("serviceNames", serviceNames);
                
            } else {
                request.setAttribute("error", "Không tìm thấy phòng với ID: " + roomID);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID phòng không hợp lệ: " + roomIDParam);
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi khi tải thông tin phòng: " + e.getMessage());
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Lỗi tham số: " + e.getMessage());
        }

        request.getRequestDispatcher("/views/admin/ViewRoomDetail.jsp").forward(request, response);
    }
}
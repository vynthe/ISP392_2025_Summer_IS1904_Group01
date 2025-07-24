package controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.entity.Rooms;
import model.service.RoomService;

import java.io.IOException;
import java.util.List;

@WebServlet("/SearchRoomServlet")
public class SearchRoomServlet extends HttpServlet {
    private RoomService roomService;

    @Override
    public void init() {
        roomService = new RoomService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String keyword = request.getParameter("keyword");
        String statusFilter = request.getParameter("statusFilter");

        try {
    List<Rooms> result;

    boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
    boolean hasStatus = statusFilter != null && !statusFilter.trim().isEmpty();

    if (!hasKeyword && !hasStatus) {
        result = roomService.getAllRooms();
    } else if (hasKeyword && !hasStatus) {
        result = roomService.searchRooms(keyword.trim());
    } else if (!hasKeyword && hasStatus) {
        result = roomService.searchRoomsByKeywordAndStatus(keyword, statusFilter);
    } else {
        result = roomService.searchRoomsByKeywordAndStatus(keyword.trim(), statusFilter.trim());
    }

    request.setAttribute("roomList", result);
    request.setAttribute("keyword", keyword);
    request.setAttribute("statusFilter", statusFilter);
    request.getRequestDispatcher("/views/admin/ViewRoom.jsp").forward(request, response);

} catch (Exception e) {
    e.printStackTrace();
    request.setAttribute("error", "❌ Đã xảy ra lỗi khi tìm kiếm phòng: " + e.getMessage());
    request.getRequestDispatcher("/views/admin/ViewRoom.jsp").forward(request, response);
}
    }
}

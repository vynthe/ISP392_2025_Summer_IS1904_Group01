//package controller.user;
//
//import model.service.SchedulesService;
//import model.service.ServiceException;
//import model.entity.ScheduleEmployee;
//import com.google.gson.Gson;
//import com.google.gson.GsonBuilder;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//
//import java.io.IOException;
//import java.io.PrintWriter;
//import java.time.LocalDate;
//import java.time.format.DateTimeFormatter;
//import java.time.format.DateTimeParseException;
//import java.util.HashMap;
//import java.util.List;
//import java.util.Map;
//
//@WebServlet("/UpdateScheduleServlet")
//public class UpdateScheduleServlet extends HttpServlet {
//    private final SchedulesService scheduleService;
//    private final Gson gson;
//
//    public UpdateScheduleServlet() {
//        this.scheduleService = new SchedulesService();
//        this.gson = new GsonBuilder().setDateFormat("yyyy-MM-dd").create();
//    }
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        response.setContentType("application/json");
//        response.setCharacterEncoding("UTF-8");
//        PrintWriter out = response.getWriter();
//
//        try {
//            // Lấy tham số date từ query string
//            String dateParam = request.getParameter("date");
//            if (dateParam == null || dateParam.isEmpty()) {
//                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
//                Map<String, String> error = new HashMap<>();
//                error.put("error", "Tham số date là bắt buộc.");
//                out.write(gson.toJson(error));
//                return;
//            }
//
//            // Parse date
//            LocalDate date;
//            try {
//                date = LocalDate.parse(dateParam, DateTimeFormatter.ISO_LOCAL_DATE);
//            } catch (DateTimeParseException e) {
//                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
//                Map<String, String> error = new HashMap<>();
//                error.put("error", "Định dạng ngày không hợp lệ. Sử dụng định dạng yyyy-MM-dd.");
//                out.write(gson.toJson(error));
//                return;
//            }
//
//            // Lấy danh sách lịch bác sĩ không có bệnh nhân
//            List<ScheduleEmployee> schedules = scheduleService.getDoctorSchedulesWithoutAppointments(date);
//            out.write(gson.toJson(schedules));
//        } catch (ServiceException e) {
//            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
//            Map<String, String> error = new HashMap<>();
//            error.put("error", "Lỗi khi lấy lịch: " + e.getMessage());
//            out.write(gson.toJson(error));
//        }
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        response.setContentType("application/json");
//        response.setCharacterEncoding("UTF-8");
//        PrintWriter out = response.getWriter();
//
//        try {
//            // Lấy tham số từ body hoặc query string
//            String slotIdParam = request.getParameter("slotId");
//            String newUserIdParam = request.getParameter("newUserId");
//            String newRole = request.getParameter("newRole");
//            String updatedByParam = request.getParameter("updatedBy");
//
//            // Kiểm tra các tham số bắt buộc
//            if (slotIdParam == null || newUserIdParam == null || newRole == null || updatedByParam == null) {
//                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
//                Map<String, String> error = new HashMap<>();
//                error.put("error", "Thiếu tham số bắt buộc: slotId, newUserId, newRole, updatedBy.");
//                out.write(gson.toJson(error));
//                return;
//            }
//
//            // Parse và kiểm tra dữ liệu
//            int slotId, newUserId, updatedBy;
//            try {
//                slotId = Integer.parseInt(slotIdParam);
//                newUserId = Integer.parseInt(newUserIdParam);
//                updatedBy = Integer.parseInt(updatedByParam);
//            } catch (NumberFormatException e) {
//                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
//                Map<String, String> error = new HashMap<>();
//                error.put("error", "slotId, newUserId, hoặc updatedBy phải là số nguyên.");
//                out.write(gson.toJson(error));
//                return;
//            }
//
//            // Kiểm tra newRole hợp lệ
//            if (!"Doctor".equalsIgnoreCase(newRole) && !"Nurse".equalsIgnoreCase(newRole)) {
//                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
//                Map<String, String> error = new HashMap<>();
//                error.put("error", "newRole phải là 'Doctor' hoặc 'Nurse'.");
//                out.write(gson.toJson(error));
//                return;
//            }
//
//            // Cập nhật lịch
//            boolean success = scheduleService.updateScheduleEmployeeAssignment(slotId, newUserId, newRole, updatedBy);
//            if (success) {
//                response.setStatus(HttpServletResponse.SC_OK);
//                Map<String, String> result = new HashMap<>();
//                result.put("message", "Cập nhật lịch thành công cho SlotID " + slotId);
//                out.write(gson.toJson(result));
//            } else {
//                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
//                Map<String, String> error = new HashMap<>();
//                error.put("error", "Không thể cập nhật lịch cho SlotID " + slotId);
//                out.write(gson.toJson(error));
//            }
//        } catch (ServiceException e) {
//            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
//            Map<String, String> error = new HashMap<>();
//            error.put("error", "Lỗi khi cập nhật lịch: " + e.getMessage());
//            out.write(gson.toJson(error));
//        }
//    }
//}

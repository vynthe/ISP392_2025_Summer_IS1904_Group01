package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.service.AppointmentService;

import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

@WebServlet(name = "ViewScheduleDetail", urlPatterns = {"/ViewScheduleDetail"})
public class ViewScheduleDetail extends HttpServlet {

    private final AppointmentService appointmentService = new AppointmentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String roomIdParam = request.getParameter("roomId");
        String slotIdParam = request.getParameter("slotId");

        try {
            if (roomIdParam == null || slotIdParam == null || roomIdParam.isBlank() || slotIdParam.isBlank()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu roomId hoặc slotId trong URL");
                return;
            }

            int roomId = Integer.parseInt(roomIdParam);
            int slotId = Integer.parseInt(slotIdParam);

            List<Map<String, Object>> scheduleDetails = appointmentService.getScheduleWithAppointments(roomId, slotId);

            // Enrich: thêm tên bác sĩ, bệnh nhân, dịch vụ nếu có
            for (Map<String, Object> row : scheduleDetails) {

                // 🧑‍⚕️ Tên bác sĩ
                Object doctorIdObj = row.get("doctorId");
                if (doctorIdObj != null) {
                    int doctorId = parseId(doctorIdObj);
                    if (doctorId > 0) {
                        String doctorName = appointmentService.getUserFullNameById(doctorId);
                        row.put("doctorName", doctorName);
                    }
                }

                // 👤 Tên bệnh nhân
                Object patientIdObj = row.get("patientId");
                if (patientIdObj != null) {
                    int patientId = parseId(patientIdObj);
                    if (patientId > 0) {
                        String patientName = appointmentService.getUserFullNameById(patientId);
                        row.put("patientName", patientName);
                    }
                }

                // 🧾 Tên dịch vụ
                Object serviceIdObj = row.get("serviceId");
                if (serviceIdObj != null) {
                    int serviceId = parseId(serviceIdObj);
                    if (serviceId > 0) {
                        String serviceName = appointmentService.getServiceNameById(serviceId);
                        row.put("serviceName", serviceName);
                    }
                }
            }

            request.setAttribute("scheduleDetails", scheduleDetails);
            request.setAttribute("roomId", roomId);
            request.setAttribute("slotId", slotId);

            request.getRequestDispatcher("/views/user/DoctorNurse/ViewScheduleDetail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "roomId hoặc slotId không hợp lệ");
        } catch (SQLException e) {
            throw new ServletException("Lỗi truy vấn dữ liệu lịch làm việc và lịch hẹn", e);
        }
    }

    /**
     * Hàm tiện ích để parse ID từ Object sang int an toàn
     */
    private int parseId(Object obj) {
        if (obj instanceof Integer) {
            return (Integer) obj;
        }
        try {
            return Integer.parseInt(obj.toString());
        } catch (NumberFormatException e) {
            return -1;
        }
    }
}

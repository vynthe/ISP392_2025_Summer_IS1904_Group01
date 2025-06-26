package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Appointments;
import model.entity.Rooms;
import model.entity.Users;
import model.entity.Schedules;
import model.service.AppointmentService;
import model.dao.DBContext;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Date;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "BookMedicalAppointmentServlet", urlPatterns = {"/BookMedicalAppointmentServlet"})
public class BookMedicalAppointmentServlet extends HttpServlet {

    private AppointmentService appointmentService;

    @Override
    public void init() throws ServletException {
        try {
            Connection conn = DBContext.getInstance().getConnection();
            appointmentService = new AppointmentService(conn);
        } catch (SQLException e) {
            throw new ServletException("Database connection failed", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse requestResponse)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            // Initial load: Fetch services assigned to rooms
            List<model.entity.Services> services = appointmentService.getServicesAssignedToRooms();
            request.setAttribute("services", services);
            request.getRequestDispatcher("/views/user/Patient/BookMedicalAppointment.jsp").forward(request, requestResponse);
        } else {
            // AJAX requests
            response.setContentType("application/json");
            Map<String, Object> result = new HashMap<>();
            try {
                if ("getRoomsAndDoctors".equals(action)) {
                    int serviceID = Integer.parseInt(request.getParameter("serviceID"));
                    List<Rooms> rooms = appointmentService.getRoomsByService(serviceID);
                    List<Users> doctors = appointmentService.getDoctorsByService(serviceID);
                    result.put("rooms", rooms);
                    result.put("doctors", doctors);
                } else if ("getSchedules".equals(action)) {
                    int doctorID = Integer.parseInt(request.getParameter("doctorID"));
                    List<Schedules> schedules = appointmentService.getSchedulesByDoctor(doctorID);
                    result.put("schedules", schedules);
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    result.put("error", "Invalid action");
                    requestResponse.getWriter().write(new com.google.gson.Gson().toJson(result));
                    return;
                }
                requestResponse.getWriter().write(new com.google.gson.Gson().toJson(result));
            } catch (SQLException | NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                result.put("error", "Error processing request: " + e.getMessage());
                requestResponse.getWriter().write(new com.google.gson.Gson().toJson(result));
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String type = request.getParameter("type");
        HttpSession session = request.getSession();

        // Retain form values in case of error
        request.setAttribute("type", type);
        if ("detailed".equals(type)) {
            request.setAttribute("patientID", request.getParameter("patientID"));
            request.setAttribute("serviceID", request.getParameter("serviceID"));
            request.setAttribute("roomID", request.getParameter("roomID"));
            request.setAttribute("doctorID", request.getParameter("doctorID"));
            request.setAttribute("scheduleID", request.getParameter("scheduleID"));
            request.setAttribute("appointmentTime", request.getParameter("appointmentTime"));
            request.setAttribute("nurseID", request.getParameter("nurseID"));
        } else if ("simple".equals(type)) {
            request.setAttribute("fullName", request.getParameter("fullName"));
            request.setAttribute("phoneNumber", request.getParameter("phoneNumber"));
            request.setAttribute("email", request.getParameter("email"));
            request.setAttribute("service", request.getParameter("service"));
            request.setAttribute("appointmentTime", request.getParameter("appointmentTime"));
        }

        try {
            if ("detailed".equals(type)) {
                Appointments appointment = new Appointments();
                String patientIDStr = request.getParameter("patientID");
                appointment.setPatientID(patientIDStr != null && !patientIDStr.isEmpty() ? Integer.parseInt(patientIDStr) : null);
                appointment.setDoctorID(Integer.parseInt(request.getParameter("doctorID")));
                String nurseIDStr = request.getParameter("nurseID");
                appointment.setNurseID(nurseIDStr != null && !nurseIDStr.isEmpty() ? Integer.parseInt(nurseIDStr) : null);
                appointment.setRoomID(Integer.parseInt(request.getParameter("roomID")));

                String appointmentTimeStr = request.getParameter("appointmentTime");
                if (appointmentTimeStr != null) {
                    Timestamp timestamp = new Timestamp(new SimpleDateFormat("yyyy-MM-dd'T'HH:mm").parse(appointmentTimeStr).getTime());
                    appointment.setAppointmentTime(new Date(timestamp.getTime())); // Convert to java.sql.Date
                } else {
                    throw new IllegalArgumentException("Appointment time is required.");
                }

                appointment.setCreatedBy(patientIDStr != null && !patientIDStr.isEmpty() ? Integer.parseInt(patientIDStr) : 1);

                boolean success = appointmentService.bookAppointment(appointment);
                if (success) {
                    session.setAttribute("successMessage", "Đặt lịch thành công! Vui lòng chờ xác nhận.");
                    response.sendRedirect(request.getContextPath() + "/views/user/Patient/BookMedicalAppointment.jsp");
                } else {
                    session.setAttribute("error", "Failed to book appointment");
                    response.sendRedirect(request.getContextPath() + "/views/user/Patient/BookMedicalAppointment.jsp");
                }
            } else if ("simple".equals(type)) {
                String fullName = request.getParameter("fullName");
                String phoneNumber = request.getParameter("phoneNumber");
                String email = request.getParameter("email");
                String service = request.getParameter("service");
                String appointmentTimeStr = request.getParameter("appointmentTime");
                Date appointmentTime = appointmentTimeStr != null ?
                    new Date(new SimpleDateFormat("yyyy-MM-dd'T'HH:mm").parse(appointmentTimeStr).getTime()) : null;

                if (fullName == null || fullName.trim().isEmpty() || !fullName.matches("^[\\p{L}\\s]+$")) {
                    throw new IllegalArgumentException("Họ và tên không hợp lệ hoặc để trống.");
                }
                if (phoneNumber == null || !phoneNumber.matches("\\d{10,11}")) {
                    throw new IllegalArgumentException("Số điện thoại phải có 10-11 chữ số.");
                }
                if (service == null || service.trim().isEmpty()) {
                    throw new IllegalArgumentException("Dịch vụ không được để trống.");
                }
                if (appointmentTime == null) {
                    throw new IllegalArgumentException("Thời gian đặt lịch là bắt buộc.");
                }

                boolean success = appointmentService.bookSimpleAppointment(fullName, phoneNumber, email, service, appointmentTime);
                if (success) {
                    session.setAttribute("successMessage", "Đặt lịch thành công! Vui lòng chờ xác nhận.");
                    response.sendRedirect(request.getContextPath() + "/views/user/Patient/BookMedicalAppointment.jsp");
                } else {
                    session.setAttribute("error", "Failed to book simple appointment");
                    response.sendRedirect(request.getContextPath() + "/views/user/Patient/BookMedicalAppointment.jsp");
                }
            } else {
                throw new IllegalArgumentException("Invalid booking type.");
            }
        } catch (IllegalArgumentException e) {
            session.setAttribute("error", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/views/user/Patient/BookMedicalAppointment.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/views/user/Patient/BookMedicalAppointment.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/views/user/Patient/BookMedicalAppointment.jsp");
        }
    }

    @Override
    public void destroy() {
        try {
            DBContext.getInstance().closeConnection();
        } catch (SQLException e) {
            System.err.println("Error closing database connection: " + e.getMessage());
        }
    }
}
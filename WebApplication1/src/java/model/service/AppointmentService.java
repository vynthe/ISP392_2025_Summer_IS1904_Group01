package model.service;

import model.entity.Appointments;
import model.entity.Rooms;
import model.entity.Users;
import model.entity.Schedules;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Date;
import java.util.List;
import model.dao.AppointmentDAO;
import model.entity.Services;

public class AppointmentService {

    private AppointmentDAO appointmentDAO;
    private Timestamp Date;

    public AppointmentService(Connection conn) {
        this.appointmentDAO = new AppointmentDAO(conn);
    }

    public List<AppointmentDAO.Services> getServices() throws SQLException {
        return appointmentDAO.getServices();
    }

    public List<Rooms> getRoomsByService(int serviceID) throws SQLException {
        return appointmentDAO.getRoomsByService(serviceID);
    }

    public List<Users> getDoctorsByService(int serviceID) throws SQLException {
        return appointmentDAO.getDoctorsByService(serviceID);
    }

    public List<Schedules> getSchedulesByDoctor(int doctorID) throws SQLException {
        return appointmentDAO.getSchedulesByDoctor(doctorID);
    }

    public boolean bookAppointment(Appointments appointment) throws SQLException {
        if (appointment.getAppointmentTime() == null
                || appointment.getDoctorID() <= 0
                || appointment.getRoomID() <= 0
                || appointment.getPatientID() == null) {
            return false;
        }
        return appointmentDAO.bookAppointment(appointment);
    }

    public boolean bookSimpleAppointment(String fullName, String phoneNumber, String email, String service, Date appointmentTime) throws SQLException {
        if (fullName == null || phoneNumber == null || service == null || appointmentTime == null) {
            return false;
        }
        return appointmentDAO.bookSimpleAppointment(fullName, phoneNumber, email, service, Date appointmentTime);
    }

    public List<Services> getServicesAssignedToRooms() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}

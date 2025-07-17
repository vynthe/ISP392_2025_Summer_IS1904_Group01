package model.service;
import model.dao.ScheduleDAO;
import model.entity.ScheduleEmployee;
import model.entity.AppointmentQueue;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import model.entity.Rooms;
import model.entity.Users;
import model.dao.RoomsDAO;
import model.dao.UserDAO;

public class SchedulesService {

    private final ScheduleDAO scheduleDAO;
    private final RoomService roomService;
    private final RoomsDAO roomDAO;
    private final UserDAO userDAO;

    // Khởi tạo SchedulesService với các DAO cần thiết
    public SchedulesService() {
        this.scheduleDAO = new ScheduleDAO();
        this.roomService = new RoomService();
        this.roomDAO = new RoomsDAO();
        this.userDAO = new UserDAO();
    }

    // Tạo lịch làm việc tự động cho danh sách người dùng
    public void generateSchedule(List<Integer> userIds, List<String> roles, int createdBy, LocalDate startDate, boolean isYearly, int defaultRoomId)
            throws SQLException, ClassNotFoundException {
        if (userIds == null || roles == null || userIds.size() != roles.size()) {
            throw new IllegalArgumentException("Dữ liệu đầu vào không hợp lệ: userIds và roles không được null và phải có cùng kích thước.");
        }

        for (int i = 0; i < userIds.size(); i++) {
            String role = roles.get(i);
            if (!isValidRole(role)) {
                throw new IllegalArgumentException("Vai trò không hợp lệ: " + role);
            }
        }
        scheduleDAO.addSchedule(userIds, roles, defaultRoomId, createdBy, startDate, isYearly);
    }

    // Lấy tất cả các slot lịch làm việc
    public List<ScheduleEmployee> getAllScheduleEmployees() throws SQLException, ClassNotFoundException {
        return scheduleDAO.getAllScheduleEmployees();
    }

    // Lấy thông tin slot lịch làm việc theo ID
    public ScheduleEmployee getScheduleEmployeeById(int slotId) throws SQLException, ClassNotFoundException {
        if (slotId <= 0) {
            throw new IllegalArgumentException("ID slot không hợp lệ.");
        }
        return scheduleDAO.getScheduleEmployeeById(slotId);
    }

    // Xóa một slot lịch làm việc theo ID
    public boolean deleteScheduleEmployee(int slotId) throws SQLException, ClassNotFoundException {
        if (slotId <= 0) {
            throw new IllegalArgumentException("ID slot không hợp lệ.");
        }
        return scheduleDAO.deleteScheduleEmployee(slotId);
    }

    // Thêm một hàng đợi cuộc hẹn
    public boolean addAppointmentQueue(AppointmentQueue queue) throws SQLException, ClassNotFoundException {
        if (queue == null || queue.getSlotId() <= 0 || queue.getAppointmentId() <= 0) {
            throw new IllegalArgumentException("Dữ liệu hàng đợi cuộc hẹn không hợp lệ.");
        }
        return scheduleDAO.addAppointmentQueue(queue);
    }

 
    // Kiểm tra vai trò hợp lệ
    private boolean isValidRole(String role) {
        return role != null && ("Doctor".equalsIgnoreCase(role) || "Nurse".equalsIgnoreCase(role) || "Receptionist".equalsIgnoreCase(role));
    }

    // Lấy danh sách các slot lịch làm việc trong một khoảng ngày
    public List<ScheduleEmployee> getScheduleEmployeesByDateRange(LocalDate startDate, LocalDate endDate) throws SQLException, ClassNotFoundException {
        if (startDate == null || endDate == null || startDate.isAfter(endDate)) {
            throw new IllegalArgumentException("Khoảng ngày không hợp lệ.");
        }
        return scheduleDAO.getScheduleEmployeesByDateRange(startDate, endDate);
    }

    // Lấy danh sách các phòng trống
    public List<Rooms> getAvailableRooms() throws SQLException {
        List<Rooms> allRooms = roomService.getAllRooms();
        List<Rooms> availableRooms = new ArrayList<>();
        for (Rooms room : allRooms) {
            if ("Available".equalsIgnoreCase(room.getStatus())) {
                availableRooms.add(room);
            }
        }
        return availableRooms;
    }

    // Lấy các slot lịch làm việc của một bác sĩ
    public List<ScheduleEmployee> getDoctorSlots(int doctorId) throws SQLException, ClassNotFoundException {
        return scheduleDAO.getScheduleEmployeesByDateRange(LocalDate.now(), LocalDate.now().plusWeeks(2))
                .stream()
                .filter(slot -> slot.getUserId() == doctorId && "Doctor".equalsIgnoreCase(slot.getRole()) && "Available".equalsIgnoreCase(slot.getStatus()))
                .toList();
    }

    // Gán phòng cho lịch hiện có
    public boolean assignRoomToExistingSchedule(int slotId, int roomId, int createdBy) throws SQLException, IllegalArgumentException {
        ScheduleEmployee scheduleToAssign = scheduleDAO.getScheduleById(slotId);
        if (scheduleToAssign == null) {
            throw new IllegalArgumentException("Lịch trình không tồn tại với ID: " + slotId);
        }

        if (scheduleToAssign.getRoomId() != null && scheduleToAssign.getRoomId() != 0) {
            System.out.println("Lịch trình ID " + slotId + " đã có phòng ID " + scheduleToAssign.getRoomId() + ". Đang cố gắng gán lại phòng ID " + roomId);
        }

        Rooms room = roomDAO.getRoomByID(roomId);
        if (room == null) {
            throw new IllegalArgumentException("Phòng không tồn tại với ID: " + roomId);
        }

        LocalDate slotDate = scheduleToAssign.getSlotDate();
        String role = scheduleToAssign.getRole();

        List<ScheduleEmployee> existingSchedulesInRoom = scheduleDAO.getSchedulesByRoomAndRole(roomId, slotDate, role);

        for (ScheduleEmployee existing : existingSchedulesInRoom) {
            if (existing.getSlotId() != slotId) {
                throw new IllegalArgumentException("Phòng ID " + roomId + " đã được gán cho lịch trình khác (ID: " + existing.getSlotId() + ") vào cùng ngày và vai trò.");
            }
        }

        Users user = userDAO.getUserByID(scheduleToAssign.getUserId());
        if (user != null) {
            if ("Doctor".equalsIgnoreCase(user.getRole()) && roomId == 19) {
                throw new IllegalArgumentException("Bác sĩ không thể gán vào phòng lễ tân (ID: 19).");
            }
            if ("Nurse".equalsIgnoreCase(user.getRole()) && roomId == 19) {
                throw new IllegalArgumentException("Y tá không thể gán vào phòng lễ tân (ID: 19).");
            }
            if ("Receptionist".equalsIgnoreCase(user.getRole()) && roomId != 19) {
                throw new IllegalArgumentException("Lễ tân chỉ có thể gán vào phòng lễ tân (ID: 19).");
            }
        }

        return scheduleDAO.assignRoomToSchedule(slotId, roomId);
    }

    // Lấy lịch trình theo ID
    public ScheduleEmployee getScheduleById(int slotId) throws SQLException {
        return scheduleDAO.getScheduleById(slotId);
    }

    // Lấy tất cả lịch trình
    public List<ScheduleEmployee> getAllSchedules() throws SQLException {
        return scheduleDAO.getAllSchedules();
    }

    // Lấy các lịch trình chưa có phòng
    public List<ScheduleEmployee> getSchedulesWithoutRoom() throws SQLException {
        return scheduleDAO.getSchedulesWithoutRoom();
    }

    // Lấy các lịch trình chưa có phòng theo userId
    public List<ScheduleEmployee> getSchedulesWithoutRoomByUserId(int userId) throws SQLException {
        return scheduleDAO.getSchedulesWithoutRoomByUserId(userId);
    }

    // Gán phòng cho các lịch trong khoảng thời gian với kiểm tra ràng buộc
    public int assignRoomToSchedulesInDateRange(int slotId, int roomId, int userId, LocalDate startDate, LocalDate endDate) throws SQLException {
        if (slotId <= 0 || roomId <= 0 || userId <= 0) {
            throw new IllegalArgumentException("ID lịch trình, phòng và người dùng phải là số dương.");
        }
        if (startDate == null || endDate == null || endDate.isBefore(startDate)) {
            throw new IllegalArgumentException("Ngày bắt đầu và ngày kết thúc không hợp lệ.");
        }

        // Lấy thông tin lịch được chọn
        ScheduleEmployee selectedSchedule = scheduleDAO.getScheduleById(slotId);
        if (selectedSchedule == null || selectedSchedule.getUserId() != userId) {
            throw new IllegalArgumentException("Lịch trình không hợp lệ hoặc không thuộc về người dùng ID: " + userId);
        }

        // Kiểm tra ràng buộc phòng cho tất cả các ngày trong khoảng thời gian
        LocalTime startTime = selectedSchedule.getStartTime();
        LocalTime endTime = selectedSchedule.getEndTime();
        String role = selectedSchedule.getRole();
        for (LocalDate date = startDate; !date.isAfter(endDate); date = date.plusDays(1)) {
            boolean canAssign = scheduleDAO.checkRoomAssignmentConstraints(roomId, date, startTime, endTime, role);
            if (!canAssign) {
                throw new IllegalArgumentException("Không thể gán phòng " + roomId + " cho " + role + " vào ngày " + date + 
                                                  " từ " + startTime + " đến " + endTime + ": Phòng đã có đủ bác sĩ hoặc y tá.");
            }
        }

        // Lấy các lịch phù hợp trong khoảng thời gian
        List<ScheduleEmployee> schedulesToAssign = scheduleDAO.getSchedulesByUserIdAndDateRange(
            userId, startDate, endDate, startTime, endTime, role
        );

        if (schedulesToAssign == null || schedulesToAssign.isEmpty()) {
            throw new IllegalArgumentException("Không tìm thấy lịch trình phù hợp trong khoảng thời gian từ " + startDate + " đến " + endDate);
        }

        // Gán phòng cho các lịch chưa có phòng
        int assignedCount = 0;
        for (ScheduleEmployee schedule : schedulesToAssign) {
            if (schedule.getRoomId() == null) {
                boolean success = scheduleDAO.assignRoomToSchedule(schedule.getSlotId(), roomId);
                if (success) {
                    assignedCount++;
                }
            }
        }

        return assignedCount;
    }

    // Gán phòng cho lịch bác sĩ trong khoảng thời gian cho slot sáng hoặc chiều
    public int assignRoomToDoctorSchedulesInDateRange(int slotId, int morningRoomId, int afternoonRoomId, int userId, LocalDate startDate, LocalDate endDate) throws SQLException {
        // Kiểm tra các tham số đầu vào
        if (slotId <= 0 || userId <= 0) {
            throw new IllegalArgumentException("ID lịch trình và người dùng phải là số dương.");
        }
        if (startDate == null || endDate == null || endDate.isBefore(startDate)) {
            throw new IllegalArgumentException("Ngày bắt đầu và ngày kết thúc không hợp lệ.");
        }
        if (morningRoomId <= 0 && afternoonRoomId <= 0) {
            throw new IllegalArgumentException("Phải cung cấp ít nhất một ID phòng hợp lệ cho slot sáng hoặc chiều.");
        }

        // Lấy thông tin lịch được chọn
        ScheduleEmployee selectedSchedule = scheduleDAO.getScheduleById(slotId);
        if (selectedSchedule == null || selectedSchedule.getUserId() != userId) {
            throw new IllegalArgumentException("Lịch trình không hợp lệ hoặc không thuộc về người dùng ID: " + userId);
        }
        if (!"Doctor".equalsIgnoreCase(selectedSchedule.getRole())) {
            throw new IllegalArgumentException("Lịch trình không phải của bác sĩ.");
        }

        // Xác định slot là sáng hay chiều dựa trên thời gian bắt đầu
        LocalTime startTime = selectedSchedule.getStartTime();
        boolean isMorningSlot = startTime.isBefore(LocalTime.of(12, 30));
        int roomIdToAssign = isMorningSlot ? morningRoomId : afternoonRoomId;

        if (roomIdToAssign <= 0) {
            throw new IllegalArgumentException("ID phòng không hợp lệ cho slot " + (isMorningSlot ? "sáng" : "chiều") + ".");
        }

        // Kiểm tra xem phòng có tồn tại không
        Rooms room = roomDAO.getRoomByID(roomIdToAssign);
        if (room == null) {
            throw new IllegalArgumentException("Phòng không tồn tại với ID: " + roomIdToAssign);
        }

        // Kiểm tra ràng buộc phòng cho tất cả các ngày trong khoảng thời gian
        LocalTime endTime = selectedSchedule.getEndTime();
        String role = selectedSchedule.getRole();
        for (LocalDate date = startDate; !date.isAfter(endDate); date = date.plusDays(1)) {
            boolean canAssign = scheduleDAO.checkRoomAssignmentConstraints(roomIdToAssign, date, startTime, endTime, role);
            if (!canAssign) {
                throw new IllegalArgumentException("Không thể gán phòng " + roomIdToAssign + " cho bác sĩ vào ngày " + date + 
                                                  " từ " + startTime + " đến " + endTime + ": Phòng đã có bác sĩ.");
            }
        }

        // Lấy các lịch phù hợp trong khoảng thời gian cho slot sáng hoặc chiều
        List<ScheduleEmployee> schedulesToAssign = scheduleDAO.getSchedulesByUserIdAndDateRange(
            userId, startDate, endDate, startTime, endTime, role
        );

        if (schedulesToAssign == null || schedulesToAssign.isEmpty()) {
            throw new IllegalArgumentException("Không tìm thấy lịch trình phù hợp trong khoảng thời gian từ " + startDate + " đến " + endDate);
        }

        // Gán phòng cho các lịch chưa có phòng
        int assignedCount = 0;
        for (ScheduleEmployee schedule : schedulesToAssign) {
            if (schedule.getRoomId() == null) {
                boolean success = scheduleDAO.assignRoomToSchedule(schedule.getSlotId(), roomIdToAssign);
                if (success) {
                    assignedCount++;
                }
            }
        }

        return assignedCount;
    }
    public List<ScheduleEmployee> getScheduleByDate(int userId, LocalDate date) throws SQLException {
        List<ScheduleEmployee> schedules = scheduleDAO.getScheduleByDate(userId, date);
        for (ScheduleEmployee schedule : schedules) {
            if (schedule.getRoomId() != null) {
                Rooms room = roomDAO.getRoomByID(schedule.getRoomId());
                // Có thể lấy dịch vụ từ roomsDAO.getServicesByRoom nếu cần
                // List<Services> services = roomsDAO.getServicesByRoom(schedule.getRoomId());
            }
        }
        return schedules;
    }
}
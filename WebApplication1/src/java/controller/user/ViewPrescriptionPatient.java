package controller.user;

import model.service.PrescriptionService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Users;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * Controller để xử lý việc xem đơn thuốc của bệnh nhân
 */
@WebServlet("/ViewPrescriptionPatient")
public class ViewPrescriptionPatient extends HttpServlet {
    
    private final PrescriptionService prescriptionService;
    
    public ViewPrescriptionPatient() {
        this.prescriptionService = new PrescriptionService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get the session without creating a new one
        HttpSession session = request.getSession(false);

        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            request.setAttribute("error", "Bạn cần đăng nhập để truy cập trang này.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Get user from session and verify role is Patient
        Users user = (Users) session.getAttribute("user");
        System.out.println("Session user: UserID=" + user.getUserID() + ", Role=" + user.getRole());
        if (!"Patient".equalsIgnoreCase(user.getRole())) {
            request.setAttribute("error", "Chỉ bệnh nhân mới có quyền truy cập vào trang này.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }
        
        // Use UserID from session as patientId
        int patientId = user.getUserID();
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        
        try {
            switch (action) {
                case "list":
                    handleListPrescriptions(request, response, patientId);
                    break;
                case "detail":
                    handlePrescriptionDetail(request, response, patientId);
                    break;
                default:
                    handleListPrescriptions(request, response, patientId);
                    break;
            }
        } catch (SQLException e) {
            System.err.println("SQLException in ViewPrescriptionPatient for patientId " + patientId + 
                               " at " + LocalDateTime.now() + " +07: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi truy xuất dữ liệu đơn thuốc: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Xử lý hiển thị danh sách đơn thuốc của bệnh nhân
     */
    private void handleListPrescriptions(HttpServletRequest request, HttpServletResponse response, int patientId) 
            throws ServletException, IOException, SQLException {
        
        System.out.println("DEBUG - ViewPrescriptionPatient: Getting prescriptions for patientId: " + 
                         patientId + " at " + LocalDateTime.now() + " +07");
        
        // Lấy danh sách đơn thuốc của bệnh nhân
        List<Map<String, Object>> prescriptions = prescriptionService.getPrescriptionsByPatientId(patientId);
        
        // Set attributes cho JSP
        request.setAttribute("prescriptions", prescriptions);
        request.setAttribute("patientId", patientId);
        request.setAttribute("currentDateTime", LocalDateTime.now());
        
        // Thêm thông tin thống kê
        int totalPrescriptions = prescriptions.size();
        long prescriptionsWithNurse = prescriptions.stream()
                .filter(p -> p.get("nurseId") != null)
                .count();
        
        request.setAttribute("totalPrescriptions", totalPrescriptions);
        request.setAttribute("prescriptionsWithNurse", prescriptionsWithNurse);
        request.setAttribute("prescriptionsWithoutNurse", totalPrescriptions - prescriptionsWithNurse);
        
        System.out.println("DEBUG - ViewPrescriptionPatient: Found " + totalPrescriptions + 
                         " prescriptions for patientId: " + patientId + 
                         " (" + prescriptionsWithNurse + " with nurse) at " + 
                         LocalDateTime.now() + " +07");
        
        // Forward đến JSP
        request.getRequestDispatcher("/views/user/Patient/ViewPrescriptionPatient.jsp")
               .forward(request, response);
    }
    
    /**
     * Xử lý hiển thị chi tiết đơn thuốc
     */
    private void handlePrescriptionDetail(HttpServletRequest request, HttpServletResponse response, int patientId) 
            throws ServletException, IOException, SQLException {
        
        String prescriptionIdParam = request.getParameter("prescriptionId");
        if (prescriptionIdParam == null || prescriptionIdParam.isEmpty()) {
            request.setAttribute("errorMessage", "Không tìm thấy ID đơn thuốc");
            handleListPrescriptions(request, response, patientId);
            return;
        }
        
        try {
            int prescriptionId = Integer.parseInt(prescriptionIdParam);
            
            System.out.println("DEBUG - ViewPrescriptionPatient: Getting prescription detail for prescriptionId: " + 
                             prescriptionId + ", patientId: " + patientId + " at " + LocalDateTime.now() + " +07");
            
            // Lấy chi tiết đơn thuốc
            Map<String, Object> prescriptionDetail = prescriptionService.getPrescriptionDetailById(prescriptionId);
            
            // Kiểm tra quyền truy cập - chỉ bệnh nhân sở hữu đơn thuốc mới xem được
            if (prescriptionDetail == null) {
                request.setAttribute("errorMessage", "Không tìm thấy đơn thuốc");
                handleListPrescriptions(request, response, patientId);
                return;
            }
            
            Integer prescriptionPatientId = (Integer) prescriptionDetail.get("patientId");
            if (prescriptionPatientId == null || prescriptionPatientId != patientId) {
                request.setAttribute("errorMessage", "Bạn không có quyền xem đơn thuốc này");
                handleListPrescriptions(request, response, patientId);
                return;
            }
            
            System.out.println("DEBUG - ViewPrescriptionPatient: Prescription detail retrieved successfully for prescriptionId: " + 
                             prescriptionId + " at " + LocalDateTime.now() + " +07");
            
            request.setAttribute("prescriptionDetail", prescriptionDetail);
            request.setAttribute("isDetailView", true);
            
            request.getRequestDispatcher("/views/user/Patient/ViewPrescriptionPatient.jsp")
                   .forward(request, response);
            
        } catch (NumberFormatException e) {
            System.err.println("Invalid prescription ID format: " + prescriptionIdParam + 
                              " for patientId: " + patientId + " at " + LocalDateTime.now() + " +07");
            request.setAttribute("errorMessage", "ID đơn thuốc không hợp lệ");
            handleListPrescriptions(request, response, patientId);
        } catch (SQLException e) {
            System.err.println("SQLException getting prescription detail for prescriptionId " + prescriptionIdParam + 
                              ", patientId " + patientId + " at " + LocalDateTime.now() + " +07: " + e.getMessage());
            e.printStackTrace();
            
            if (e.getMessage().contains("Không tìm thấy đơn thuốc")) {
                request.setAttribute("errorMessage", "Không tìm thấy đơn thuốc hoặc bạn không có quyền xem");
            } else {
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi truy xuất chi tiết đơn thuốc: " + e.getMessage());
            }
            handleListPrescriptions(request, response, patientId);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect POST requests to GET
        doGet(request, response);
    }
}
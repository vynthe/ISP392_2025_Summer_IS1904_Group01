package controller.user;

import model.service.ExaminationResultsService;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.dao.ExaminationResultsDAO;
import model.entity.Users;
import java.util.Map;

/**
 * Servlet to handle viewing detailed examination results for a doctor.
 */
@WebServlet(name = "ViewExaminationResultDetailServlet", urlPatterns = {"/ViewExaminationResultDetailServlet"})
public class ViewExaminationResultDetailServlet extends HttpServlet {

    private final ExaminationResultsService examinationResultsService;

    public ViewExaminationResultDetailServlet() {
        this.examinationResultsService = new ExaminationResultsService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null) {
            request.setAttribute("error", "Phiên làm việc đã hết hạn. Vui lòng đăng nhập lại.");
            request.getRequestDispatcher("/views/user/DoctorNurse/ViewExaminationResultDetail.jsp").forward(request, response);
            return;
        }

        Object userObj = session.getAttribute("user");
        if (userObj == null) {
            request.setAttribute("error", "Bạn cần đăng nhập để truy cập trang này.");
            request.getRequestDispatcher("/views/user/DoctorNurse/ViewExaminationResultDetail.jsp").forward(request, response);
            return;
        }

        if (!(userObj instanceof Users)) {
            request.setAttribute("error", "Dữ liệu người dùng không hợp lệ.");
            request.getRequestDispatcher("/views/user/DoctorNurse/ViewExaminationResultDetail.jsp").forward(request, response);
            return;
        }

        Users user = (Users) userObj;
        System.out.println("Session user: UserID=" + user.getUserID() + ", Role=" + user.getRole() + " at " + LocalDateTime.now() + " +07");
        
        if (!"Doctor".equalsIgnoreCase(user.getRole())) {
            request.setAttribute("error", "Chỉ bác sĩ mới có quyền truy cập vào trang này.");
            request.getRequestDispatcher("/views/user/DoctorNurse/ViewExaminationResultDetail.jsp").forward(request, response);
            return;
        }

        try {
            // Kiểm tra cả resultId và appointmentId
            String resultIdParam = request.getParameter("resultId");
            String appointmentIdParam = request.getParameter("appointmentId");
            
            Map<String, Object> resultDetails = null;

            if (resultIdParam != null && !resultIdParam.trim().isEmpty()) {
                // Trường hợp có resultId
                try {
                    int resultId = Integer.parseInt(resultIdParam.trim());
                    System.out.println("Processing resultId: " + resultId);
                    resultDetails = examinationResultsService.getExaminationResultById(resultId);
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "ID kết quả không hợp lệ: " + resultIdParam);
                    System.err.println("NumberFormatException for resultId in ViewExaminationResultDetailServlet at " + LocalDateTime.now() + " +07: " + e.getMessage());
                    request.getRequestDispatcher("/views/user/DoctorNurse/ViewExaminationResultDetail.jsp").forward(request, response);
                    return;
                }
            } else if (appointmentIdParam != null && !appointmentIdParam.trim().isEmpty()) {
                // Trường hợp có appointmentId - cần tìm resultId trước
                try {
                    int appointmentId = Integer.parseInt(appointmentIdParam.trim());
                    System.out.println("Processing appointmentId: " + appointmentId);
                    
                    // Tìm resultId từ appointmentId
                    Integer resultId = examinationResultsService.getResultIdByAppointmentId(appointmentId);
                    if (resultId == null) {
                        request.setAttribute("error", "Không tìm thấy kết quả khám cho lịch hẹn ID: " + appointmentId);
                        request.getRequestDispatcher("/views/user/DoctorNurse/ViewExaminationResultDetail.jsp").forward(request, response);
                        return;
                    }
                    
                    // Lấy chi tiết kết quả khám
                    resultDetails = examinationResultsService.getExaminationResultById(resultId);
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "ID lịch hẹn không hợp lệ: " + appointmentIdParam);
                    System.err.println("NumberFormatException for appointmentId in ViewExaminationResultDetailServlet at " + LocalDateTime.now() + " +07: " + e.getMessage());
                    request.getRequestDispatcher("/views/user/DoctorNurse/ViewExaminationResultDetail.jsp").forward(request, response);
                    return;
                }
            } else {
                request.setAttribute("error", "Không có ID kết quả hoặc ID lịch hẹn được cung cấp. Vui lòng chọn một kết quả từ danh sách.");
                request.getRequestDispatcher("/views/user/DoctorNurse/ViewExaminationResults.jsp").forward(request, response);
                return;
            }

            System.out.println("Fetched resultDetails: " + resultDetails);

            if (resultDetails == null || resultDetails.isEmpty()) {
                request.setAttribute("error", "Không tìm thấy kết quả khám.");
                request.getRequestDispatcher("/views/user/DoctorNurse/ViewExaminationResultDetail.jsp").forward(request, response);
                return;
            }

            // Kiểm tra quyền truy cập
            Object doctorIdObj = resultDetails.get("doctorId");
            if (doctorIdObj == null) {
                request.setAttribute("error", "Dữ liệu bác sĩ không hợp lệ.");
                request.getRequestDispatcher("/views/user/DoctorNurse/ViewExaminationResultDetail.jsp").forward(request, response);
                return;
            }

            int doctorId;
            if (doctorIdObj instanceof Integer) {
                doctorId = (Integer) doctorIdObj;
            } else if (doctorIdObj instanceof String) {
                try {
                    doctorId = Integer.parseInt((String) doctorIdObj);
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Dữ liệu bác sĩ không phải là số nguyên hợp lệ.");
                    request.getRequestDispatcher("/views/user/DoctorNurse/ViewExaminationResultDetail.jsp").forward(request, response);
                    return;
                }
            } else {
                request.setAttribute("error", "Dữ liệu bác sĩ có định dạng không hợp lệ.");
                request.getRequestDispatcher("/views/user/DoctorNurse/ViewExaminationResultDetail.jsp").forward(request, response);
                return;
            }

            if (doctorId != user.getUserID()) {
            request.setAttribute("error", "Bạn không có quyền xem kết quả này.");
                request.getRequestDispatcher("/views/user/DoctorNurse/ViewExaminationResultDetail.jsp").forward(request, response);
                return;
            }

            // Đặt dữ liệu và forward đến JSP chi tiết
            request.setAttribute("resultDetails", resultDetails);
            request.setAttribute("appointmentId", appointmentIdParam);
            request.setAttribute("examinationResultDAO", new ExaminationResultsDAO());
            request.getRequestDispatcher("/views/user/DoctorNurse/ViewExaminationResultDetail.jsp").forward(request, response);

        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi khi lấy dữ liệu từ cơ sở dữ liệu: " + e.getMessage());
            System.err.println("SQLException in ViewExaminationResultDetailServlet at " + LocalDateTime.now() + " +07: " + e.getMessage() + ", SQLState: " + e.getSQLState());
            e.printStackTrace();
            request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi hệ thống không xác định: " + e.getMessage());
            System.err.println("Unexpected error in ViewExaminationResultDetailServlet at " + LocalDateTime.now() + " +07: " + e.getMessage());
            e.printStackTrace();
            request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
        }
    }
}
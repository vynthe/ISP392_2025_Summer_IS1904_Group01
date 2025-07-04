package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.Prescriptions;
import model.entity.Users;
import model.service.PrescriptionService;
import model.service.UserService;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ViewPrescriptionServlet", urlPatterns = {"/ViewPrescriptionServlet"})
public class ViewPrescriptionServlet extends HttpServlet {
    private PrescriptionService prescriptionService;
    private UserService userService;

    @Override
    public void init() throws ServletException {
        prescriptionService = new PrescriptionService();
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Parse pagination parameters
            int page = 1;
            int pageSize = 10;
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) {
                        page = 1;
                    }
                } catch (NumberFormatException e) {
                    System.err.println("Invalid page parameter: " + pageParam + " at " + LocalDateTime.now() + " +07");
                    page = 1;
                }
            }

            // Get search parameters
            String patientNameKeyword = request.getParameter("patientNameKeyword");
            String medicationNameKeyword = request.getParameter("medicationNameKeyword");

            // Sanitize inputs
            patientNameKeyword = (patientNameKeyword != null) ? patientNameKeyword.trim() : "";
            medicationNameKeyword = (medicationNameKeyword != null) ? medicationNameKeyword.trim() : "";

            List<Prescriptions> prescriptions;
            int totalRecords;
            int totalPages;

            // Determine if search is being performed
            boolean isSearch = !patientNameKeyword.isEmpty() || !medicationNameKeyword.isEmpty();

            if (isSearch) {
                // Perform search with pagination
                prescriptions = prescriptionService.searchPrescriptionsByPatientAndMedication(
                        patientNameKeyword.isEmpty() ? null : patientNameKeyword,
                        medicationNameKeyword.isEmpty() ? null : medicationNameKeyword,
                        page, pageSize);
                totalRecords = prescriptionService.getTotalCountByPatientAndMedication(
                        patientNameKeyword.isEmpty() ? null : patientNameKeyword,
                        medicationNameKeyword.isEmpty() ? null : medicationNameKeyword);
                request.setAttribute("patientNameKeyword", patientNameKeyword);
                request.setAttribute("medicationNameKeyword", medicationNameKeyword);
            } else {
                // Fetch prescriptions with pagination
                prescriptions = prescriptionService.getPrescriptionsByPage(page, pageSize);
                totalRecords = prescriptionService.getTotalPrescriptions();
            }

            // Fetch user names for prescriptions
            Map<Integer, String> patientNames = new HashMap<>();
            Map<Integer, String> doctorNames = new HashMap<>();
            for (Prescriptions p : prescriptions) {
                // Fetch patient name
                Users patient = userService.getPatientByID(p.getPatientId());
                patientNames.put(p.getPatientId(), patient != null && patient.getFullName() != null ? patient.getFullName().trim() : "Unknown Patient " + p.getPatientId());

                // Fetch doctor name
                Users doctor = userService.getEmployeeByID(p.getDoctorId());
                doctorNames.put(p.getDoctorId(), doctor != null && doctor.getFullName() != null ? doctor.getFullName().trim() : "Unknown Doctor " + p.getDoctorId());
            }
            request.setAttribute("patientNames", patientNames);
            request.setAttribute("doctorNames", doctorNames);

            // Calculate total pages
            totalPages = (int) Math.ceil((double) totalRecords / pageSize);
            if (totalPages < 1) {
                totalPages = 1;
            }

            // Set request attributes for JSP
            request.setAttribute("prescriptions", prescriptions);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalRecords", totalRecords);

            // Forward to JSP
            request.getRequestDispatcher("/views/user/DoctorNurse/ViewPrescription.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQLException in ViewPrescriptionServlet.doGet: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi lấy danh sách đơn thuốc: " + e.getMessage());
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
            System.err.println("IllegalArgumentException in ViewPrescriptionServlet.doGet: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Dữ liệu đầu vào không hợp lệ: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Unexpected exception in ViewPrescriptionServlet.doGet: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Đã xảy ra lỗi không mong muốn: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet to view list of prescriptions with pagination and search functionality";
    }
}
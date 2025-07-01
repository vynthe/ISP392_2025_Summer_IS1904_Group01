package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.Prescriptions;
import model.service.PrescriptionService;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet(name = "ViewPrescriptionServlet", urlPatterns = {"/ViewPrescriptionServlet"})
public class ViewPrescriptionServlet extends HttpServlet {
    private PrescriptionService prescriptionService;

    @Override
    public void init() throws ServletException {
        prescriptionService = new PrescriptionService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int page = 1;
            int pageSize = 10;
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            String patientNameKeyword = request.getParameter("patientNameKeyword");
            String medicationNameKeyword = request.getParameter("medicationNameKeyword");

            List<Prescriptions> prescriptions;
            int totalRecords;
            int totalPages;

            boolean isSearch = (patientNameKeyword != null && !patientNameKeyword.trim().isEmpty())
                            || (medicationNameKeyword != null && !medicationNameKeyword.trim().isEmpty());

            if (isSearch) {
                prescriptions = prescriptionService.searchPrescriptionsByPatientAndMedication(
                    patientNameKeyword, medicationNameKeyword, page, pageSize);
                totalRecords = prescriptionService.getTotalCountByPatientAndMedication(
                    patientNameKeyword, medicationNameKeyword);
                request.setAttribute("patientNameKeyword", patientNameKeyword);
                request.setAttribute("medicationNameKeyword", medicationNameKeyword);
            } else {
                prescriptions = prescriptionService.getPrescriptionsByPage(page, pageSize);
                totalRecords = prescriptionService.getTotalPrescriptions();
            }

            totalPages = (int) Math.ceil((double) totalRecords / pageSize);

            request.setAttribute("prescriptions", prescriptions);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalRecords", totalRecords);

            request.getRequestDispatcher("/views/user/DoctorNurse/ViewPrescription.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQLException in ViewPrescriptionServlet.doGet: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi lấy danh sách đơn thuốc: " + e.getMessage());
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
            System.err.println("IllegalArgumentException in ViewPrescriptionServlet.doGet: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
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
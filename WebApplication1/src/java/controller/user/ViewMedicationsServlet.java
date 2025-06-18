package controller.user;

import model.entity.Medication;
import model.service.MedicationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet(name = "ViewMedicationsServlet", urlPatterns = {"/ViewMedicationsServlet"})
public class ViewMedicationsServlet extends HttpServlet {

    private MedicationService medicationService;

    @Override
    public void init() throws ServletException {
        medicationService = new MedicationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get pagination parameters
            int page = 1;
            int pageSize = 10; // 10 medications per page
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            // Fetch paginated medications
            List<Medication> medications = medicationService.getMedicationsPaginated(page, pageSize);
            int totalRecords = medicationService.getTotalMedicationCount();
            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

            // Set attributes for JSP
            request.setAttribute("medications", medications);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalRecords", totalRecords);

            request.getRequestDispatcher("/views/user/DoctorNurse/ViewMedications.jsp").forward(request, response);
        } catch (SQLException e) {
            System.err.println("SQLException in ViewMedicationsServlet.doGet: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            request.setAttribute("error", "Error retrieving medications: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            System.err.println("IllegalArgumentException in ViewMedicationsServlet.doGet: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); // Redirect POST to GET
    }
}
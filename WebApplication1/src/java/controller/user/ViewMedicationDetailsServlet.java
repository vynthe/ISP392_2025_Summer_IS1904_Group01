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

@WebServlet(name = "ViewMedicationDetailsServlet", urlPatterns = {"/ViewMedicationDetailsServlet"})
public class ViewMedicationDetailsServlet extends HttpServlet {

    private final MedicationService medicationService;

    public ViewMedicationDetailsServlet() {
        this.medicationService = new MedicationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Get medication ID from request parameter
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Medication ID is required.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            int medicationId;
            try {
                medicationId = Integer.parseInt(idParam);
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid medication ID format.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            // Retrieve medication details
            Medication medication = medicationService.getMedicationById(medicationId);
            request.setAttribute("medication", medication);

            // Forward to JSP for rendering
            request.getRequestDispatcher("/views/user/DoctorNurse/ViewMedicationDetails.jsp").forward(request, response);

        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
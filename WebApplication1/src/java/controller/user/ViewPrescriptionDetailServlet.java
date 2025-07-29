package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.service.PrescriptionService;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.Map;

@WebServlet(name = "ViewPrescriptionDetailServlet", urlPatterns = {"/ViewPrescriptionDetailServlet"})
public class ViewPrescriptionDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final PrescriptionService prescriptionService = new PrescriptionService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String prescriptionIdStr = request.getParameter("prescriptionId");
            System.out.println("DEBUG - prescriptionId: '" + prescriptionIdStr + "' at " + LocalDateTime.now() + " +07");

            int prescriptionId;
            try {
                prescriptionId = Integer.parseInt(prescriptionIdStr);
                if (prescriptionId < 1) {
                    throw new NumberFormatException("Invalid prescription ID");
                }
            } catch (NumberFormatException e) {
                System.out.println("DEBUG - Invalid prescriptionId format: " + prescriptionIdStr + " at " + LocalDateTime.now() + " +07");
                request.setAttribute("errorMessage", "Invalid prescription ID.");
                request.getRequestDispatcher("/views/user/DoctorNurse/ViewPrescriptionDetail.jsp").forward(request, response);
                return;
            }

            Map<String, Object> prescriptionDetail = prescriptionService.getPrescriptionDetailById(prescriptionId);
            System.out.println("DEBUG - Prescription details retrieved: " + (prescriptionDetail != null ? prescriptionDetail : "null") + " at " + LocalDateTime.now() + " +07");

            if (prescriptionDetail != null) {
                request.setAttribute("prescriptionDetail", prescriptionDetail);
                System.out.println("DEBUG - Setting request attribute 'prescriptionDetail': " + prescriptionDetail.keySet() + " at " + LocalDateTime.now() + " +07");
            } else {
                request.setAttribute("errorMessage", "No prescription found for ID: " + prescriptionId);
                System.out.println("DEBUG - No prescription found for ID: " + prescriptionId + " at " + LocalDateTime.now() + " +07");
            }

            String message = request.getParameter("message");
            if (message != null) {
                request.setAttribute("message", message);
                System.out.println("DEBUG - Message from request: " + message + " at " + LocalDateTime.now() + " +07");
            }

            String statusMessage = (String) request.getSession().getAttribute("statusMessage");
            if (statusMessage != null) {
                request.setAttribute("message", statusMessage);
                request.getSession().removeAttribute("statusMessage");
                System.out.println("DEBUG - Status message from session: " + statusMessage + " at " + LocalDateTime.now() + " +07");
            }

            request.getRequestDispatcher("/views/user/DoctorNurse/ViewPrescriptionDetail.jsp").forward(request, response);

        } catch (SQLException e) {
            System.err.println("DEBUG - SQLException: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: Unable to retrieve prescription details.");
            request.getRequestDispatcher("/views/user/DoctorNurse/ViewPrescriptionDetail.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("DEBUG - Unexpected exception: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unexpected error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("DEBUG - POST request received, redirecting to GET at " + LocalDateTime.now() + " +07");
        String prescriptionId = request.getParameter("prescriptionId");
        String redirectUrl = request.getContextPath() + "/ViewPrescriptionDetailServlet";
        if (prescriptionId != null && !prescriptionId.trim().isEmpty()) {
            redirectUrl += "?prescriptionId=" + java.net.URLEncoder.encode(prescriptionId.trim(), "UTF-8");
        }
        request.setAttribute("errorMessage", "This page does not support POST operations.");
        response.sendRedirect(redirectUrl);
    }
}
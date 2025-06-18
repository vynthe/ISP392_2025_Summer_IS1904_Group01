
package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.Medication;
import model.service.MedicationService;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;

@WebServlet(name = "AddMedicationsServlet", urlPatterns = {"/AddMedicationsServlet"})
public class AddMedicationsServlet extends HttpServlet {
    private static final Log log = LogFactory.getLog(AddMedicationsServlet.class);
    private MedicationService medicationService;

    @Override
    public void init() throws ServletException {
        medicationService = new MedicationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/user/DoctorNurse/AddMedications.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String drugName = request.getParameter("drugName") != null ? request.getParameter("drugName").trim() : "";
            String manufacturingDateStr = request.getParameter("manufacturingDate");
            String expiryDateStr = request.getParameter("expiryDate");
            String quantityStr = request.getParameter("quantity");
            String dosage = request.getParameter("dosage") != null ? request.getParameter("dosage").trim() : "";
            String manufacturer = request.getParameter("manufacturer") != null ? request.getParameter("manufacturer").trim() : "";
            String dosageForm = request.getParameter("dosageForm") != null ? request.getParameter("dosageForm").trim() : "";
            String description = request.getParameter("description") != null ? 
                request.getParameter("description").trim().substring(0, Math.min(255, request.getParameter("description").trim().length())) : "";
            String saveToDB = request.getParameter("save");
            boolean manualEntry = "true".equals(request.getParameter("manualEntry"));

            LocalDate manufacturingDate = manufacturingDateStr != null && !manufacturingDateStr.isEmpty() ? 
                LocalDate.parse(manufacturingDateStr) : null;
            LocalDate expiryDate = expiryDateStr != null && !expiryDateStr.isEmpty() ? 
                LocalDate.parse(expiryDateStr) : null;
            int quantity = quantityStr != null && !quantityStr.isEmpty() ? Integer.parseInt(quantityStr) : -1;
            double price = request.getParameter("price") != null && !request.getParameter("price").isEmpty() ? 
                Double.parseDouble(request.getParameter("price")) : 0.0;

            log.info("Processing add request - drugName: " + drugName + ", quantity: " + quantity + ", saveToDB: " + saveToDB);

            Medication medication = new Medication();
            medication.setName(drugName);
            medication.setDosage(dosage);
            medication.setManufacturer(manufacturer);
            medication.setDescription(description);
            medication.setProductionDate(manufacturingDate);
            medication.setExpirationDate(expiryDate);
            medication.setPrice(price);
            medication.setQuantity(quantity);
            medication.setDosageForm(dosageForm);
            medication.setStatus(quantity > 0 ? "Active" : "Inactive");
       

            if ("true".equals(saveToDB)) {
                try {
                    boolean added = medicationService.addMedication(medication);
                    if (added) {
                        log.info("Medication added successfully: " + drugName);
                        request.getSession().setAttribute("statusMessage", "Tạo thành công");
                    } else {
                        log.warn("Failed to add medication: " + drugName + " (unknown reason)");
                        request.getSession().setAttribute("statusMessage", "Tạo thất bại");
                    }
                } catch (SQLException e) {
                    log.error("SQLException adding medication: " + e.getMessage(), e);
                    request.getSession().setAttribute("statusMessage", "Tạo thất bại: Lỗi cơ sở dữ liệu - " + e.getMessage());
                } catch (Exception e) {
                    log.error("Unexpected error adding medication: " + e.getMessage(), e);
                    request.getSession().setAttribute("statusMessage", "Tạo thất bại: Lỗi hệ thống - " + e.getMessage());
                }
                response.sendRedirect(request.getContextPath() + "/ViewMedicationsServlet");
            } else {
                log.info("Save not requested, returning to form for " + drugName);
                setFormAttributes(request, drugName, manufacturingDateStr, expiryDateStr, quantityStr, 
                    dosage, manufacturer, dosageForm, description, String.valueOf(price));
                request.setAttribute("manualEntry", manualEntry);
                request.getRequestDispatcher("/views/user/DoctorNurse/AddMedications.jsp").forward(request, response);
            }
        } catch (IllegalArgumentException e) {
            log.error("Validation error: " + e.getMessage(), e);
            request.getSession().setAttribute("statusMessage", "Tạo thất bại: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ViewMedicationsServlet");
        } catch (Exception e) {
            log.error("Unexpected error processing request: " + e.getMessage(), e);
            request.getSession().setAttribute("statusMessage", "Tạo thất bại: Lỗi hệ thống - " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ViewMedicationsServlet");
        }
    }

    private void setFormAttributes(HttpServletRequest request, String drugName, String manu, String exp, String qty,
            String dosage, String manufacturer, String dosageForm, String description, String price) {
        request.setAttribute("formDrugName", drugName);
        request.setAttribute("formManufacturingDate", manu);
        request.setAttribute("formExpiryDate", exp);
        request.setAttribute("formQuantity", qty);
        request.setAttribute("formDosage", dosage);
        request.setAttribute("formManufacturer", manufacturer);
        request.setAttribute("formDosageForm", dosageForm);
        request.setAttribute("formDescription", description);
        request.setAttribute("formPrice", price);
    }
}
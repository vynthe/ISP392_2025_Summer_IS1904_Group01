package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.Medication;
import model.service.MedicationService;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet(name = "AddMedicationsServlet", urlPatterns = {"/AddMedicationsServlet"})
public class AddMedicationsServlet extends HttpServlet {
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String drugName = request.getParameter("drugName").trim();
            String manufacturingDateStr = request.getParameter("manufacturingDate");
            String expiryDateStr = request.getParameter("expiryDate");
            String quantityStr = request.getParameter("quantity");
            String saveToDB = request.getParameter("save");

            LocalDate manufacturingDate = LocalDate.parse(manufacturingDateStr);
            LocalDate expiryDate = LocalDate.parse(expiryDateStr);
            int quantity = Integer.parseInt(quantityStr);

            // Kiểm tra thuốc tồn tại từ API
            Medication drugDetails = checkDrugExistence(drugName);
            if (drugDetails == null) {
                request.setAttribute("error", "Thuốc '" + drugName + "' không tồn tại trong cơ sở dữ liệu API. Vui lòng kiểm tra lại!");
                setFormAttributes(request, drugName, manufacturingDateStr, expiryDateStr, quantityStr);
                request.getRequestDispatcher("/views/user/DoctorNurse/AddMedications.jsp").forward(request, response);
                return;
            }

            if ("true".equals(saveToDB)) {
                if (medicationService.isMedicationExists(drugName)) {
                    throw new IllegalArgumentException("Thuốc đã tồn tại trong hệ thống.");
                }

                Medication medication = new Medication();
                medication.setMedicationName(drugName);
                medication.setGenericName(drugName);
                medication.setBrandName(drugDetails.getBrandName() != null ? drugDetails.getBrandName() : drugName);
                medication.setManufacturingDate(manufacturingDate);
                medication.setExpiryDate(expiryDate);
                medication.setQuantity(quantity);
                medication.setSellingPrice(drugDetails.getSellingPrice() != null ? drugDetails.getSellingPrice() : BigDecimal.ZERO);
                medication.setDosage(drugDetails.getDosage() != null ? drugDetails.getDosage() : "");
                medication.setManufacturer(drugDetails.getManufacturer() != null ? drugDetails.getManufacturer() : "N/A");
                medication.setNdc(drugDetails.getNdc() != null ? drugDetails.getNdc() : "N/A");
                medication.setDosageForm(drugDetails.getDosageForm() != null ? drugDetails.getDosageForm() : "N/A");
                medication.setStatus(quantity > 0 ? "Available" : "Inavail");
                medication.setCreatedAt(LocalDateTime.now());
                medication.setUpdatedAt(LocalDateTime.now());
                medication.setCreatedBy(getCurrentUserId(request));

                medicationService.addMedication(medication);
                response.sendRedirect(request.getContextPath() + "/ViewMedicationsServlet");
            } else {
                setFormAttributes(request, drugName, manufacturingDateStr, expiryDateStr, quantityStr);
                request.getRequestDispatcher("/views/user/DoctorNurse/AddMedications.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Đã xảy ra lỗi khi thêm thuốc: " + e.getMessage());
            request.getRequestDispatcher("/views/user/DoctorNurse/AddMedications.jsp").forward(request, response);
        }
    }

    private Medication checkDrugExistence(String drugName) throws Exception {
        HttpClient client = HttpClient.newHttpClient();
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create("https://api.fda.gov/drug/label.json?search=generic_name:" + drugName.replace(" ", "+") + "&limit=1"))
                .build();
        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

        JSONObject jsonResponse = new JSONObject(response.body());
        JSONArray results = jsonResponse.getJSONArray("results");

        if (results.length() > 0) {
            JSONObject result = results.getJSONObject(0);
            JSONObject openfda = result.optJSONObject("openfda") != null ? result.getJSONObject("openfda") : new JSONObject();
            Medication medication = new Medication();
            medication.setMedicationName(drugName);
            medication.setManufacturer(openfda.has("manufacturer_name") ? openfda.getJSONArray("manufacturer_name").getString(0) : "N/A");
            medication.setNdc(openfda.has("product_ndc") ? openfda.getJSONArray("product_ndc").getString(0) : "N/A");
            medication.setDosageForm(result.has("dosage_form") ? result.getString("dosage_form") : "N/A");
            medication.setSellingPrice(BigDecimal.ZERO); // Giá mặc định
            medication.setDosage(result.has("dosage_and_administration") ? result.getString("dosage_and_administration") : "N/A");
            return medication;
        }
        return null;
    }

    private Integer getCurrentUserId(HttpServletRequest request) {
        return (Integer) request.getSession().getAttribute("userId");
    }

    private void setFormAttributes(HttpServletRequest request, String drugName, String manu, String exp, String qty) {
        request.setAttribute("formDrugName", drugName);
        request.setAttribute("formManufacturingDate", manu);
        request.setAttribute("formExpiryDate", exp);
        request.setAttribute("formQuantity", qty);
    }
}

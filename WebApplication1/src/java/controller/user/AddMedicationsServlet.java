package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.dao.MedicationDAO;
import model.entity.Medication;

import java.io.BufferedReader;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AddMedicationServlet", urlPatterns = {"/AddMedicationServlet"})
public class AddMedicationsServlet extends HttpServlet {

    private final MedicationDAO medicationDAO = new MedicationDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<String> added = new ArrayList<>();
        List<String> skipped = new ArrayList<>();

        // ✅ Lấy Connection từ request
        Connection conn = (Connection) request.getAttribute("conn");
        if (conn == null) {
            request.setAttribute("error", "Không thể kết nối cơ sở dữ liệu.");
            request.getRequestDispatcher("/views/user/DoctorNurse/AddMedications.jsp").forward(request, response);
            return;
        }

        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                // Giả định dòng CSV có dạng: GenericName,BrandName,Dosage,SellingPrice
                String[] parts = line.split(",");
                if (parts.length < 4) continue;

                String genericName = parts[0].trim();
                String brandName = parts[1].trim();
                String dosage = parts[2].trim();
                String priceStr = parts[3].trim();

                Medication med = new Medication();
                med.setGenericName(genericName);
                med.setBrandName(brandName);
                med.setSellingPrice(new BigDecimal(priceStr));
                med.parseDosageFromApi(dosage); // Tách "500 mg" thành số và đơn vị
                med.autoSetMedicationName();
                med.setCreatedAt(LocalDateTime.now());
                med.setUpdatedAt(LocalDateTime.now());
                med.setCreatedBy(1);

                // ✅ Kiểm tra trùng tên và thêm thuốc với Connection
                if (medicationDAO.existsByMedicationName(conn, med.getMedicationName())) {
                    skipped.add(med.getMedicationName());
                } else {
                    medicationDAO.addMedication(conn, med);
                    added.add(med.getMedicationName());
                }
            }
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi khi xử lý dữ liệu: " + e.getMessage());
            e.printStackTrace();
        }

        request.setAttribute("addedList", added);
        request.setAttribute("skippedList", skipped);
        request.getRequestDispatcher("/views/user/DoctorNurse/AddMedications.jsp").forward(request, response);
    }
}

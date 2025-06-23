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
import java.time.LocalDate;

@WebServlet(name = "MedicationImportServlet", urlPatterns = {"/MedicationImportServlet"})
public class MedicationImportServlet extends HttpServlet {

    private final MedicationService medicationService;

    public MedicationImportServlet() {
        this.medicationService = new MedicationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String medicationIdParam = request.getParameter("id");
        if (medicationIdParam != null && !medicationIdParam.isEmpty()) {
            try {
                int medicationId = Integer.parseInt(medicationIdParam.trim());
                Medication medication = medicationService.getMedicationById(medicationId);
                if (medication != null) {
                    request.setAttribute("medication", medication);
                    // Xóa thông báo session cũ để tránh hiển thị nhầm
                    request.getSession().removeAttribute("statusMessage");
                    request.getRequestDispatcher("/views/user/DoctorNurse/ImportMedication.jsp").forward(request, response);
                    return;
                } else {
                    request.getSession().setAttribute("statusMessage", "Không tìm thấy thuốc với ID: " + medicationId);
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("statusMessage", "ID thuốc không hợp lệ: " + e.getMessage());
            } catch (SQLException | IllegalArgumentException e) {
                request.getSession().setAttribute("statusMessage", "Lỗi khi lấy thông tin thuốc: " + e.getMessage());
            }
        } else {
            request.getSession().setAttribute("statusMessage", "Vui lòng chọn một loại thuốc để nhập.");
        }
        response.sendRedirect(request.getContextPath() + "/ViewMedicationsServlet");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String medicationIdParam = request.getParameter("id");
        if (medicationIdParam != null && !medicationIdParam.isEmpty()) {
            try {
                int medicationId = Integer.parseInt(medicationIdParam.trim());
                String productionDateStr = request.getParameter("productionDate");
                String expirationDateStr = request.getParameter("expirationDate");
                String priceStr = request.getParameter("price");
                String quantityStr = request.getParameter("quantity");

                // Kiểm tra dữ liệu đầu vào
                if (productionDateStr == null || expirationDateStr == null || priceStr == null || quantityStr == null ||
                    productionDateStr.trim().isEmpty() || expirationDateStr.trim().isEmpty() || priceStr.trim().isEmpty() || quantityStr.trim().isEmpty()) {
                    request.getSession().setAttribute("statusMessage", "Vui lòng điền đầy đủ thông tin.");
                    response.sendRedirect(request.getContextPath() + "/MedicationImportServlet?id=" + medicationId);
                    return;
                }

                LocalDate productionDate = LocalDate.parse(productionDateStr.trim());
                LocalDate expirationDate = LocalDate.parse(expirationDateStr.trim());
                double price = Double.parseDouble(priceStr.trim());
                int quantity = Integer.parseInt(quantityStr.trim());

                Medication medication = new Medication();
                medication.setMedicationID(medicationId);
                medication.setProductionDate(productionDate);
                medication.setExpirationDate(expirationDate);
                medication.setPrice(price);
                medication.setQuantity(quantity);

                boolean success = medicationService.importMedication(medication);
                if (success) {
                    request.getSession().setAttribute("statusMessage", "Nhập thuốc thành công");
                } else {
                    request.getSession().setAttribute("statusMessage", "Nhập thuốc thất bại");
                }
            } catch (IllegalArgumentException e) {
                // Xử lý lỗi validate từ MedicationService
                request.getSession().setAttribute("statusMessage", "Lỗi: " + e.getMessage());
            } catch (SQLException e) {
                request.getSession().setAttribute("statusMessage", "Lỗi: " + e.getMessage());
            }
        } else {
            request.getSession().setAttribute("statusMessage", "Vui lòng chọn một loại thuốc để nhập.");
        }
        response.sendRedirect(request.getContextPath() + "/MedicationImportServlet?id=" + medicationIdParam);
    }
}
package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Medication;
import model.service.MedicationService;
import java.io.IOException;
import java.sql.*;
@WebServlet("/AddMedicationServlet")
public class AddMedicationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MedicationService medicationService;

    @Override
    public void init() throws ServletException {
        // Khởi tạo MedicationService
        medicationService = new MedicationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển tiếp đến form thêm thuốc
        request.getRequestDispatcher("/views/user/DoctorNurse/AddMedication.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        try {
            // Lấy thông tin từ form
            String name = request.getParameter("name");
            String dosage = request.getParameter("dosage");
            String dosageForm = request.getParameter("dosageForm");
            String manufacturer = request.getParameter("manufacturer");
            String description = request.getParameter("description");
            String status = request.getParameter("status");

            // Kiểm tra dữ liệu bắt buộc
            if (name == null || name.trim().isEmpty() ||
                dosage == null || dosage.trim().isEmpty() ||
                dosageForm == null || dosageForm.trim().isEmpty() ||
                manufacturer == null || manufacturer.trim().isEmpty() ||
                status == null || status.trim().isEmpty()) {
                session.setAttribute("statusMessage", "Vui lòng điền đầy đủ các trường bắt buộc!");
                response.sendRedirect(request.getContextPath() + "/AddMedicationServlet");
                return;
            }

            // Kiểm tra dosage_form hợp lệ
            String[] validDosageForms = {"Tablet", "Liquid", "Capsule", "Injection", "Syrup", "Powder", "Cream", "Ointment"};
            boolean isValidDosageForm = false;
            for (String form : validDosageForms) {
                if (form.equals(dosageForm)) {
                    isValidDosageForm = true;
                    break;
                }
            }
            if (!isValidDosageForm) {
                session.setAttribute("statusMessage", "Dạng bào chế không hợp lệ!");
                response.sendRedirect(request.getContextPath() + "/AddMedicationServlet");
                return;
            }

            // Kiểm tra status hợp lệ
            String[] validStatuses = {"Active", "Inactive", "Out of Stock"};
            boolean isValidStatus = false;
            for (String validStatus : validStatuses) {
                if (validStatus.equals(status)) {
                    isValidStatus = true;
                    break;
                }
            }
            if (!isValidStatus) {
                session.setAttribute("statusMessage", "Trạng thái không hợp lệ!");
                response.sendRedirect(request.getContextPath() + "/AddMedicationServlet");
                return;
            }

            // Tạo đối tượng Medication
            Medication medication = new Medication();
            medication.setName(name.trim());
            medication.setDosage(dosage.trim());
            medication.setDosageForm(dosageForm);
            medication.setManufacturer(manufacturer.trim());
            medication.setDescription(description != null ? description.trim() : null);
            medication.setStatus(status);

            // Lưu thuốc vào cơ sở dữ liệu
            boolean success = medicationService.addMedication(medication);

            if (success) {
                session.setAttribute("statusMessage", "Tạo thành công");
                response.sendRedirect(request.getContextPath() + "/ViewMedicationsServlet");
            } else {
                session.setAttribute("statusMessage", "Lỗi khi thêm thuốc!");
                response.sendRedirect(request.getContextPath() + "/AddMedicationServlet");
            }

        } catch (SQLException e) {
            session.setAttribute("statusMessage", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/AddMedicationServlet");
        } catch (Exception e) {
            session.setAttribute("statusMessage", "Đã xảy ra lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/AddMedicationServlet");
        }
    }
}

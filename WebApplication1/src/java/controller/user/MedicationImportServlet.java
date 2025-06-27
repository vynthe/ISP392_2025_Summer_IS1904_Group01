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
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet xử lý việc nhập và cập nhật thông tin thuốc (giá, ngày sản xuất, ngày
 * hết hạn, số lượng) Đường dẫn: /MedicationImportServlet
 */
@WebServlet(name = "MedicationImportServlet", urlPatterns = {"/MedicationImportServlet"})
public class MedicationImportServlet extends HttpServlet {

    private final MedicationService medicationService;

    /**
     */
    public MedicationImportServlet() {
        this.medicationService = new MedicationService();
    }

    /**
     * Xử lý yêu cầu GET: Hiển thị form nhập thuốc dựa trên medicationId hoặc xử
     * lý hủy xác nhận
     *
     * @param request Yêu cầu HTTP từ client
     * @param response Phản hồi HTTP gửi về client
     * @throws ServletException Nếu có lỗi trong quá trình xử lý Servlet
     * @throws IOException Nếu có lỗi I/O xảy ra
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String medicationIdParam = request.getParameter("id");
        String cancelParam = request.getParameter("cancel"); // Nhận tín hiệu hủy

        if (medicationIdParam != null && !medicationIdParam.trim().isEmpty()) {
            try {
                int medicationId = Integer.parseInt(medicationIdParam.trim());
                Medication medication = medicationService.getMedicationById(medicationId);
                if (medication != null) {
                    request.setAttribute("medication", medication);

                    // Xử lý hủy: xóa flag xác nhận và dữ liệu tạm
                    if ("true".equals(cancelParam)) {
                        request.getSession().removeAttribute("showConfirmation");
                        request.getSession().removeAttribute("tempMedication");
                    }

                    request.getRequestDispatcher("/views/user/DoctorNurse/ImportMedication.jsp").forward(request, response);
                    return;
                } else {
                    request.getSession().setAttribute("statusMessage", "Không tìm thấy thuốc với ID: " + medicationId);
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("statusMessage", "ID thuốc không hợp lệ: " + e.getMessage());
            } catch (SQLException e) {
                request.getSession().setAttribute("statusMessage", "Lỗi kết nối cơ sở dữ liệu khi lấy thông tin thuốc: " + e.getMessage());
            } catch (IllegalArgumentException e) {
                request.getSession().setAttribute("statusMessage", "Dữ liệu không hợp lệ khi lấy thông tin thuốc: " + e.getMessage());
            }
        } else {
            request.getSession().setAttribute("statusMessage", "Vui lòng chọn một loại thuốc để nhập.");
        }
        request.getRequestDispatcher("/views/user/DoctorNurse/ImportMedication.jsp").forward(request, response);
    }

    /**
     * Xử lý yêu cầu POST: Xử lý xác nhận và cập nhật thông tin thuốc
     *
     * @param request Yêu cầu HTTP từ client (dữ liệu từ form)
     * @param response Phản hồi HTTP gửi về client
     * @throws ServletException Nếu có lỗi trong quá trình xử lý Servlet
     * @throws IOException Nếu có lỗi I/O xảy ra
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String medicationIdParam = request.getParameter("id");
        String confirmAction = request.getParameter("confirmAction");

        if (medicationIdParam != null && !medicationIdParam.trim().isEmpty()) {
            try {
                int medicationId = Integer.parseInt(medicationIdParam.trim());
                Medication existingMedication = medicationService.getMedicationById(medicationId);
                if (existingMedication == null) {
                    request.getSession().setAttribute("statusMessage", "Thuốc với ID " + medicationId + " không tồn tại hoặc không hoạt động.");
                    request.setAttribute("medication", null);
                    request.getRequestDispatcher("/views/user/DoctorNurse/ImportMedication.jsp").forward(request, response);
                    return;
                }

                String productionDateStr = request.getParameter("productionDate");
                String expirationDateStr = request.getParameter("expirationDate");
                String priceStr = request.getParameter("price");
                String quantityStr = request.getParameter("quantity");

                // Kiểm tra dữ liệu có rỗng không
                if (productionDateStr == null || expirationDateStr == null || priceStr == null || quantityStr == null
                        || productionDateStr.trim().isEmpty() || expirationDateStr.trim().isEmpty() || priceStr.trim().isEmpty() || quantityStr.trim().isEmpty()) {
                    throw new IllegalArgumentException("Vui lòng điền đầy đủ thông tin ngày sản xuất, hạn sử dụng, giá, và số lượng.");
                }

                LocalDate productionDate = LocalDate.parse(productionDateStr.trim());
                LocalDate expirationDate = LocalDate.parse(expirationDateStr.trim());
                double price = Double.parseDouble(priceStr.trim());
                int quantity = Integer.parseInt(quantityStr.trim());

                // Kiểm tra ngày hợp lệ
                if (productionDate.isAfter(expirationDate)) {
                    throw new IllegalArgumentException("Ngày sản xuất không thể sau ngày hết hạn.");
                }

                Medication medication = new Medication();
                medication.setMedicationID(medicationId);
                medication.setProductionDate(productionDate);
                medication.setExpirationDate(expirationDate);
                medication.setPrice(price);
                medication.setQuantity(quantity);

                if ("true".equals(confirmAction)) {
                    // Xử lý khi người dùng xác nhận
                    boolean success = medicationService.importMedication(medication);
                    if (success) {
                        request.getSession().setAttribute("statusMessage", "Cập nhật thông tin thuốc thành công! Thuốc đã được nhập vào kho.");
                    } else {
                        request.getSession().setAttribute("statusMessage", "Nhập thuốc thất bại! Vui lòng thử lại.");
                    }
                    // Xóa dữ liệu tạm
                    request.getSession().removeAttribute("showConfirmation");
                    request.getSession().removeAttribute("tempMedication");
                } else {
                    // Đặt flag xác nhận và lưu thông tin tạm thời
                    request.getSession().setAttribute("showConfirmation", true);
                    request.getSession().setAttribute("tempMedication", medication);
                }

                // Set existingMedication để hiển thị form
                request.setAttribute("medication", existingMedication);
                request.getRequestDispatcher("/views/user/DoctorNurse/ImportMedication.jsp").forward(request, response);

            } catch (NumberFormatException e) {
                request.getSession().setAttribute("statusMessage", "Dữ liệu không hợp lệ: Giá hoặc số lượng phải là số. Chi tiết: " + e.getMessage());
                try {
                    request.setAttribute("medication", medicationService.getMedicationById(Integer.parseInt(medicationIdParam.trim())));
                } catch (SQLException ex) {
                    Logger.getLogger(MedicationImportServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (IllegalArgumentException ex) {
                    Logger.getLogger(MedicationImportServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.getRequestDispatcher("/views/user/DoctorNurse/ImportMedication.jsp").forward(request, response);
            } catch (IllegalArgumentException e) {
                request.getSession().setAttribute("statusMessage", "Lỗi dữ liệu: " + e.getMessage());
                try {
                    request.setAttribute("medication", medicationService.getMedicationById(Integer.parseInt(medicationIdParam.trim())));
                } catch (SQLException ex) {
                    Logger.getLogger(MedicationImportServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (IllegalArgumentException ex) {
                    Logger.getLogger(MedicationImportServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.getRequestDispatcher("/views/user/DoctorNurse/ImportMedication.jsp").forward(request, response);
            } catch (SQLException e) {
                request.getSession().setAttribute("statusMessage", "Lỗi kết nối cơ sở dữ liệu khi nhập thuốc: " + e.getMessage());
                try {
                    request.setAttribute("medication", medicationService.getMedicationById(Integer.parseInt(medicationIdParam.trim())));
                } catch (SQLException ex) {
                    Logger.getLogger(MedicationImportServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (IllegalArgumentException ex) {
                    Logger.getLogger(MedicationImportServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.getRequestDispatcher("/views/user/DoctorNurse/ImportMedication.jsp").forward(request, response);
            }
        } else {
            request.getSession().setAttribute("statusMessage", "Vui lòng chọn một loại thuốc để nhập.");
            request.getRequestDispatcher("/views/user/DoctorNurse/ImportMedication.jsp").forward(request, response);
        }
    }
}
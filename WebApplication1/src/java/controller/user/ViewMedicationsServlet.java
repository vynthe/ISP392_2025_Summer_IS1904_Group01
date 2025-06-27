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
        // Lấy tham số phân trang
        int page = 1;
        int pageSize = 10; // Số lượng mỗi trang
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        // Lấy tham số tìm kiếm riêng
        String nameKeyword = request.getParameter("nameKeyword");
        String dosageFormKeyword = request.getParameter("dosageFormKeyword");

        // Biến chứa kết quả
        List<Medication> medications;
        int totalRecords;
        int totalPages;

        boolean isSearch = (nameKeyword != null && !nameKeyword.trim().isEmpty())
                        || (dosageFormKeyword != null && !dosageFormKeyword.trim().isEmpty());

        if (isSearch) {
            medications = medicationService.searchMedicationsByNameAndDosageForm(nameKeyword, dosageFormKeyword, page, pageSize);
            totalRecords = medicationService.getTotalCountByNameAndDosageForm(nameKeyword, dosageFormKeyword);
            request.setAttribute("nameKeyword", nameKeyword);
            request.setAttribute("dosageFormKeyword", dosageFormKeyword);
        } else {
            medications = medicationService.getMedicationsPaginated(page, pageSize);
            totalRecords = medicationService.getTotalMedicationCount();
        }

        totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        // Đặt thuộc tính gửi về JSP
        request.setAttribute("medications", medications);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);

        // Forward tới giao diện
        request.getRequestDispatcher("/views/user/DoctorNurse/ViewMedications.jsp").forward(request, response);
    } catch (SQLException e) {
        System.err.println("SQLException in ViewMedicationsServlet.doGet: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
        request.setAttribute("error", "Lỗi khi lấy danh sách thuốc: " + e.getMessage());
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
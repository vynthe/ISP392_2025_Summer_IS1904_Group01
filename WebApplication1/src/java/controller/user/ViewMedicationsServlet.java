package controller.user;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.Medication;
import model.service.MedicationService;

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

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        try {
            // ✅ Lấy connection từ attribute (do Filter hoặc Listener thiết lập)
            Connection conn = (Connection) request.getAttribute("conn");

            // ✅ Truyền connection vào service
            List<Medication> medications = medicationService.getAllMedications(conn);

            if (medications != null && !medications.isEmpty()) {
                request.setAttribute("medications", medications);
            } else {
                request.setAttribute("message", "Không có thuốc nào trong hệ thống.");
            }

        } catch (Exception e) {
            request.setAttribute("error", "Lỗi khi lấy danh sách thuốc: " + e.getMessage());
            e.printStackTrace();
        }

        request.getRequestDispatcher("/views/user/DoctorNurse/ViewMedications.jsp")
               .forward(request, response);
    }
}

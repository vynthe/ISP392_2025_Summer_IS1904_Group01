package controller.user;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.service.PrescriptionService;

import java.io.IOException;
import model.entity.Prescriptions;


public class EditPrescriptionNoteServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idRaw = request.getParameter("id");
        try {
            int id = Integer.parseInt(idRaw);
            PrescriptionService service = new PrescriptionService();
            Prescriptions prescription = service.getPrescriptionById(id);

            if (prescription != null) {
                request.setAttribute("prescription", prescription);
                request.getRequestDispatcher("/views/user/DoctorNurse/EditPrescriptionNote.jsp").forward(request, response);
            } else {
                response.sendRedirect("ViewPatientResultServlet"); // Nếu không tìm thấy thì quay về danh sách
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ViewPatientResultServlet");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idRaw = request.getParameter("prescriptionId");
        String note = request.getParameter("note");

        String message = "";
        String redirectUrl = "ViewPrescriptionDetailServlet?id=" + idRaw;

        try {
            int id = Integer.parseInt(idRaw);
            PrescriptionService service = new PrescriptionService();
            boolean success = service.updateNoteForPrescription(id, note);

            if (success) {
                message = "Ghi chú đã được cập nhật thành công.";
            } else {
                message = "Không thể cập nhật ghi chú. Đơn thuốc không tồn tại.";
                redirectUrl = "ViewPatientResultServlet";
            }

        } catch (NumberFormatException e) {
            message = "ID đơn thuốc không hợp lệ.";
            redirectUrl = "ViewPatientResultServlet";
        } catch (Exception e) {
            message = "Đã xảy ra lỗi không mong muốn.";
            e.printStackTrace();
            redirectUrl = "ViewPatientResultServlet";
        }

        request.getSession().setAttribute("message", message);
        response.sendRedirect(redirectUrl);
    }
}

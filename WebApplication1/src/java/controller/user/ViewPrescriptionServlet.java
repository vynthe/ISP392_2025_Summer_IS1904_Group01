package controller.user;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import model.entity.Prescriptions;
import model.service.PrescriptionsService;

@WebServlet(name = "ViewPrescriptionServlet", urlPatterns = {"/ViewPrescriptionServlet"})
public class ViewPrescriptionServlet extends HttpServlet {

    private PrescriptionsService prescriptionsService;

    @Override
    public void init() throws ServletException {
        prescriptionsService = new PrescriptionsService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy danh sách tất cả toa thuốc
        List<Prescriptions> medicines = prescriptionsService.getAllPrescriptions();
        // Gửi dữ liệu sang JSP
        request.setAttribute("Prescription", medicines);

        // Chuyển tiếp đến JSP hiển thị danh sách thuốc
        request.getRequestDispatcher("/views/user/DoctorNurse/ViewPrescription.jsp").forward(request, response);
    }
}

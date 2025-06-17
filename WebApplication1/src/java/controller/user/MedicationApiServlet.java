package controller.user;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.Medication;
import model.service.MedicationService;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/api/medications")
public class MedicationApiServlet extends HttpServlet {
    private MedicationService medicationService;

    @Override
    public void init() throws ServletException {
        medicationService = new MedicationService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        List<Medication> medications = new ArrayList<>();

        try {
            medications = medicationService.getAllMedications();
        } catch (SQLException e) {
            e.printStackTrace();
            // Trả lỗi JSON cho client
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\": \"Lỗi khi truy xuất danh sách thuốc: " + e.getMessage().replace("\"", "'") + "\"}");
            return;
        }

        Gson gson = new Gson();
        String json = gson.toJson(medications);
        resp.getWriter().write(json);
    }
}

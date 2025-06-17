package controller.user;

import model.service.MedicationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet(name = "ViewMedicationsServlet", urlPatterns = {"/ViewMedicationsServlet"})
public class ViewMedicationsServlet extends HttpServlet {
    private MedicationService medicationService;
    private static final String API_URL = "https://api.fda.gov/drug/label.json?limit=100"; // Giảm limit
    private static volatile boolean isDataFetched = false;
    private static final ScheduledExecutorService scheduler = Executors.newSingleThreadScheduledExecutor();

    @Override
    public void init() throws ServletException {
        medicationService = new MedicationService();
        // Lên lịch gọi API định kỳ (ví dụ: mỗi 24 giờ)
        scheduler.scheduleAtFixedRate(this::fetchAndStoreAllDrugs, 0, 24, TimeUnit.HOURS);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            if (!isDataFetched) {
                fetchAndStoreAllDrugs(); // Gọi lần đầu nếu chưa có dữ liệu
            }
            request.setAttribute("medications", medicationService.getAllMedications());
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("medications", new java.util.ArrayList<>());
            request.setAttribute("error", "Failed to load medications: " + e.getMessage());
        }
        request.getRequestDispatcher("/views/user/DoctorNurse/ViewMedications.jsp").forward(request, response);
    }

    private synchronized void fetchAndStoreAllDrugs() {
        if (isDataFetched) return; // Tránh gọi lại nếu đã có dữ liệu

        try {
            HttpClient client = HttpClient.newHttpClient();
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(API_URL))
                    .build();
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

            JSONObject jsonResponse = new JSONObject(response.body());
            JSONArray results = jsonResponse.getJSONArray("results");

            // Tối ưu xử lý JSON: Lấy chỉ 1 generic_name đầu tiên nếu có
            for (int i = 0; i < results.length() && i < 100; i++) { // Giới hạn 100 bản ghi
                JSONObject result = results.getJSONObject(i);
                if (result.has("openfda")) {
                    JSONObject openfda = result.getJSONObject("openfda");
                    if (openfda.has("generic_name") && !openfda.isNull("generic_name")) {
                        JSONArray genericNames = openfda.getJSONArray("generic_name");
                        if (genericNames.length() > 0) {
                            String drugName = genericNames.getString(0); // Lấy tên đầu tiên
                            if (drugName != null && !drugName.trim().isEmpty()) {
                                medicationService.addMedicationFromApi(drugName); // Lưu từng thuốc
                            }
                        }
                    }
                }
            }
            isDataFetched = true;
        } catch (Exception e) {
            e.printStackTrace();
            // Log error or handle appropriately
        }
    }

    @Override
    public void destroy() {
        scheduler.shutdown();
    }
}
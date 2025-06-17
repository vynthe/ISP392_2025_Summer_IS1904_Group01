package controller.user;

import model.service.MedicationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import com.google.gson.Gson;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet(name = "SuggestDrugsServlet", urlPatterns = {"/api/suggestDrugs"})
public class SuggestDrugsServlet extends HttpServlet {
    private MedicationService medicationService;

    @Override
    public void init() throws ServletException {
        medicationService = new MedicationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String query = request.getParameter("q");
        if (query == null || query.trim().isEmpty()) {
            response.getWriter().write("[]");
            return;
        }

        try {
            List<String> suggestions = new ArrayList<>();
            CloseableHttpClient client = HttpClients.createDefault();
            HttpGet httpGet = new HttpGet("https://api.fda.gov/drug/label.json?search=openfda.generic_name:" + query + "&limit=5");
            try (CloseableHttpResponse apiResponse = client.execute(httpGet)) {
                String jsonString = EntityUtils.toString(apiResponse.getEntity());
                JSONObject json = new JSONObject(jsonString);
                JSONArray results = json.getJSONArray("results");
                for (int i = 0; i < results.length(); i++) {
                    JSONObject result = results.getJSONObject(i);
                    JSONObject openfda = result.getJSONObject("openfda");
                    if (openfda.has("generic_name")) {
                        JSONArray genericNames = openfda.getJSONArray("generic_name");
                        for (int j = 0; j < genericNames.length(); j++) {
                            String drugName = genericNames.getString(j);
                            if (drugName != null && !drugName.trim().isEmpty() && !suggestions.contains(drugName)) {
                                suggestions.add(drugName);
                            }
                        }
                    }
                }
            }
            response.getWriter().write(new Gson().toJson(suggestions));
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("[]");
        }
    }
}
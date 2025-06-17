package model.service;

import model.dao.MedicationDAO;
import model.entity.Medication;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.json.JSONObject;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class MedicationService {
    private final MedicationDAO medicationDAO;

    public MedicationService() {
        this.medicationDAO = new MedicationDAO();
    }

    public void addMedication(Medication medication) throws SQLException {
        if (medication.getMedicationName() == null || medication.getMedicationName().trim().isEmpty()) {
            setMedicationNameFallback(medication);
        }
        medicationDAO.addMedication(medication);
    }

    public Medication getMedicationById(int id) throws SQLException {
        return medicationDAO.getMedicationById(id);
    }

    public List<Medication> getAllMedications() throws SQLException {
        return medicationDAO.getAllMedications();
    }

    public boolean isMedicationExists(String medicationName) throws SQLException {
        return medicationDAO.isMedicationExists(medicationName);
    }

    public Medication fetchMedicationFromApi(String drugName) throws IOException, Exception {
        try (CloseableHttpClient client = HttpClients.createDefault()) {
            HttpGet request = new HttpGet("https://api.fda.gov/drug/ndc.json?search=brand_name:" + drugName);
            try (CloseableHttpResponse response = client.execute(request)) {
                if (response.getStatusLine().getStatusCode() != 200) {
                    throw new IOException("API request failed with status: " + response.getStatusLine().getStatusCode());
                }
                String jsonString = EntityUtils.toString(response.getEntity());
                JSONObject json = new JSONObject(jsonString);
                if (json.getJSONArray("results").length() == 0) {
                    throw new Exception("No results found for drug: " + drugName);
                }
                JSONObject result = json.getJSONArray("results").getJSONObject(0);

                Medication medication = new Medication();
                medication.setBrandName(result.optString("brand_name", ""));
                medication.setGenericName(result.optString("generic_name", ""));
                medication.setManufacturer(result.optString("labeler_name", ""));
                medication.setNdc(result.optString("product_ndc", ""));
                medication.setDosageForm(result.optString("dosage_form", ""));

                if (result.has("manufacturing_date") && !result.isNull("manufacturing_date")) {
                    try {
                        medication.setManufacturingDate(LocalDate.parse(result.getString("manufacturing_date")));
                    } catch (Exception e) {
                        System.err.println("Error parsing manufacturing date: " + e.getMessage());
                    }
                }
                if (result.has("expiry_date") && !result.isNull("expiry_date")) {
                    try {
                        medication.setExpiryDate(LocalDate.parse(result.getString("expiry_date")));
                    } catch (Exception e) {
                        System.err.println("Error parsing expiry date: " + e.getMessage());
                    }
                }
                if (result.has("dosage_and_administration") && !result.isNull("dosage_and_administration")) {
                    String dosage = result.getString("dosage_and_administration");
                    medication.setDosage(dosage);
                    medication.parseDosageFromApi(dosage);
                }

                setMedicationNameFallback(medication);
                return medication;
            }
        } catch (Exception e) {
            System.err.println("Error fetching medication from API: " + e.getMessage());
            throw e;
        }
    }

    public void addMedicationFromApi(String drugName) throws IOException, Exception {
        Medication medication = fetchMedicationFromApi(drugName);
        addMedication(medication);
    }

    public List<Medication> fetchAllMedicationsFromApi() throws IOException, Exception {
        List<Medication> medications = new ArrayList<>();
        try (CloseableHttpClient client = HttpClients.createDefault()) {
            HttpGet request = new HttpGet("https://api.fda.gov/drug/ndc.json?limit=100");
            try (CloseableHttpResponse response = client.execute(request)) {
                if (response.getStatusLine().getStatusCode() != 200) {
                    throw new IOException("API request failed with status: " + response.getStatusLine().getStatusCode());
                }
                String jsonString = EntityUtils.toString(response.getEntity());
                JSONObject json = new JSONObject(jsonString);
                if (json.getJSONArray("results").length() == 0) {
                    return medications; // Return empty list if no results
                }
                for (Object obj : json.getJSONArray("results")) {
                    JSONObject result = (JSONObject) obj;
                    Medication medication = new Medication();
                    medication.setBrandName(result.optString("brand_name", ""));
                    medication.setGenericName(result.optString("generic_name", ""));
                    medication.setManufacturer(result.optString("labeler_name", ""));
                    medication.setNdc(result.optString("product_ndc", ""));
                    medication.setDosageForm(result.optString("dosage_form", ""));

                    if (result.has("manufacturing_date") && !result.isNull("manufacturing_date")) {
                        try {
                            medication.setManufacturingDate(LocalDate.parse(result.getString("manufacturing_date")));
                        } catch (Exception e) {
                            System.err.println("Error parsing manufacturing date: " + e.getMessage());
                        }
                    }
                    if (result.has("expiry_date") && !result.isNull("expiry_date")) {
                        try {
                            medication.setExpiryDate(LocalDate.parse(result.getString("expiry_date")));
                        } catch (Exception e) {
                            System.err.println("Error parsing expiry date: " + e.getMessage());
                        }
                    }
                    if (result.has("dosage_and_administration") && !result.isNull("dosage_and_administration")) {
                        String dosage = result.getString("dosage_and_administration");
                        medication.setDosage(dosage);
                        medication.parseDosageFromApi(dosage);
                    }

                    setMedicationNameFallback(medication);
                    medications.add(medication);
                }
            }
        } catch (Exception e) {
            System.err.println("Error fetching all medications from API: " + e.getMessage());
            throw e;
        }
        return medications;
    }

    private void setMedicationNameFallback(Medication medication) {
        if (medication.getBrandName() != null && !medication.getBrandName().trim().isEmpty()) {
            medication.setMedicationName(medication.getBrandName());
        } else if (medication.getGenericName() != null && !medication.getGenericName().trim().isEmpty()) {
            medication.setMedicationName(medication.getGenericName());
        } else {
            medication.setMedicationName("Unknown Medication");
        }
    }
}
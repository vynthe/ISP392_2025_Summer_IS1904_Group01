package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.service.PrescriptionService;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ViewPatientResultServlet", urlPatterns = {"/ViewPatientResultServlet"})
public class ViewPatientResultServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final PrescriptionService prescriptionService = new PrescriptionService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String patientName = request.getParameter("patientName");
            String pageStr = request.getParameter("page");
            
            System.out.println("DEBUG - patientName: '" + patientName + "' at " + LocalDateTime.now() + " +07");
            System.out.println("DEBUG - pageStr: '" + pageStr + "' at " + LocalDateTime.now() + " +07");
            
            // Xử lý tên bệnh nhân
            String trimmedPatientName = null;
            if (patientName != null && !patientName.trim().isEmpty()) {
                trimmedPatientName = patientName.trim();
            }
            
            int currentPage = 1;
            if (pageStr != null && !pageStr.trim().isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageStr.trim());
                    if (currentPage < 1) currentPage = 1;
                } catch (NumberFormatException e) {
                    System.out.println("DEBUG - Invalid page format: " + pageStr + " at " + LocalDateTime.now() + " +07");
                }
            }
            
            int pageSize = 10;
            
            System.out.println("DEBUG - Trimmed patientName: " + trimmedPatientName + " at " + LocalDateTime.now() + " +07");
            System.out.println("DEBUG - currentPage: " + currentPage + " at " + LocalDateTime.now() + " +07");

            List<Map<String, Object>> results;
            int totalRecords = 0;
            int totalPages = 0;

            // Tìm kiếm theo tên bệnh nhân hoặc hiển thị tất cả
            if (trimmedPatientName != null) {
                System.out.println("DEBUG - Searching by patient name: " + trimmedPatientName + " at " + LocalDateTime.now() + " +07");
                results = prescriptionService.getExaminationResultsByPatientName(trimmedPatientName);
            } else {
                System.out.println("DEBUG - Getting all examination results at " + LocalDateTime.now() + " +07");
                results = prescriptionService.getAllExaminationResults();
            }
            
            System.out.println("DEBUG - Raw results size: " + (results != null ? results.size() : "null") + " at " + LocalDateTime.now() + " +07");
            
            // DEBUG: Log first result to see available fields
            if (results != null && !results.isEmpty()) {
                System.out.println("DEBUG - First result keys: " + results.get(0).keySet() + " at " + LocalDateTime.now() + " +07");
                System.out.println("DEBUG - First result data: " + results.get(0) + " at " + LocalDateTime.now() + " +07");
                
                // Check if appointmentId is available in the data
                Object appointmentId = results.get(0).get("appointmentId");
                Object diagnosis = results.get(0).get("diagnosis");
                Object notes = results.get(0).get("notes");
                System.out.println("DEBUG - AppointmentId in first result: " + appointmentId + " at " + LocalDateTime.now() + " +07");
                System.out.println("DEBUG - Diagnosis in first result: " + diagnosis + " at " + LocalDateTime.now() + " +07");
                System.out.println("DEBUG - Notes in first result: " + notes + " at " + LocalDateTime.now() + " +07");
                
                // Add hasPrescription flag to each result
                for (Map<String, Object> result : results) {
                    Integer resultId = (Integer) result.get("resultId");
                    if (resultId != null) {
                        boolean hasPrescription = prescriptionService.hasPrescription(resultId);
                        result.put("hasPrescription", hasPrescription);
                        System.out.println("DEBUG - ResultId: " + resultId + ", hasPrescription: " + hasPrescription + " at " + LocalDateTime.now() + " +07");
                    } else {
                        result.put("hasPrescription", false);
                        System.out.println("DEBUG - ResultId is null, setting hasPrescription to false at " + LocalDateTime.now() + " +07");
                    }
                }

                totalRecords = results.size();
                totalPages = (int) Math.ceil((double) totalRecords / pageSize);

                int start = (currentPage - 1) * pageSize;
                int end = Math.min(start + pageSize, results.size());
                
                System.out.println("DEBUG - Pagination: start=" + start + ", end=" + end + ", totalRecords=" + totalRecords + " at " + LocalDateTime.now() + " +07");
                
                if (start < results.size() && start >= 0) {
                    results = results.subList(start, end);
                } else {
                    results = List.of();
                    if (totalPages > 0 && currentPage > totalPages) {
                        currentPage = 1;
                        start = 0;
                        end = Math.min(pageSize, totalRecords);
                        
                        // Lấy lại dữ liệu cho trang đầu tiên
                        if (trimmedPatientName != null) {
                            List<Map<String, Object>> allResults = prescriptionService.getExaminationResultsByPatientName(trimmedPatientName);
                            for (Map<String, Object> result : allResults) {
                                Integer resultId = (Integer) result.get("resultId");
                                if (resultId != null) {
                                    boolean hasPrescription = prescriptionService.hasPrescription(resultId);
                                    result.put("hasPrescription", hasPrescription);
                                } else {
                                    result.put("hasPrescription", false);
                                }
                            }
                            results = allResults.subList(start, end);
                        } else {
                            List<Map<String, Object>> allResults = prescriptionService.getAllExaminationResults();
                            for (Map<String, Object> result : allResults) {
                                Integer resultId = (Integer) result.get("resultId");
                                if (resultId != null) {
                                    boolean hasPrescription = prescriptionService.hasPrescription(resultId);
                                    result.put("hasPrescription", hasPrescription);
                                } else {
                                    result.put("hasPrescription", false);
                                }
                            }
                            results = allResults.subList(start, end);
                        }
                    }
                }
                
                System.out.println("DEBUG - Final results size after pagination: " + results.size() + " at " + LocalDateTime.now() + " +07");
                
                if (!results.isEmpty()) {
                    System.out.println("DEBUG - First result after pagination: " + results.get(0) + " at " + LocalDateTime.now() + " +07");
                    // Check fields in paginated results
                    Object paginatedAppointmentId = results.get(0).get("appointmentId");
                    Object paginatedDiagnosis = results.get(0).get("diagnosis");
                    Object paginatedNotes = results.get(0).get("notes");
                    Object paginatedHasPrescription = results.get(0).get("hasPrescription");
                    System.out.println("DEBUG - AppointmentId in paginated result: " + paginatedAppointmentId + " at " + LocalDateTime.now() + " +07");
                    System.out.println("DEBUG - Diagnosis in paginated result: " + paginatedDiagnosis + " at " + LocalDateTime.now() + " +07");
                    System.out.println("DEBUG - Notes in paginated result: " + paginatedNotes + " at " + LocalDateTime.now() + " +07");
                    System.out.println("DEBUG - hasPrescription in paginated result: " + paginatedHasPrescription + " at " + LocalDateTime.now() + " +07");
                }
            } else {
                results = List.of();
            }

            request.setAttribute("results", results);
            request.setAttribute("patientName", trimmedPatientName != null ? trimmedPatientName : "");
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalRecords", totalRecords);
            request.setAttribute("totalPages", totalPages);
            
            System.out.println("DEBUG - Setting request attributes at " + LocalDateTime.now() + " +07:");
            System.out.println("  - results size: " + results.size());
            System.out.println("  - patientName: " + (trimmedPatientName != null ? trimmedPatientName : ""));
            System.out.println("  - currentPage: " + currentPage);
            System.out.println("  - totalRecords: " + totalRecords);
            System.out.println("  - totalPages: " + totalPages);

            String message = request.getParameter("message");
            if (message != null) {
                request.setAttribute("message", message);
            }

            // Check session message
            String statusMessage = (String) request.getSession().getAttribute("statusMessage");
            if (statusMessage != null) {
                request.setAttribute("message", statusMessage);
                request.getSession().removeAttribute("statusMessage");
            }

            request.getRequestDispatcher("/views/user/DoctorNurse/ViewPatientResult.jsp").forward(request, response);
            
        } catch (SQLException e) {
            System.err.println("DEBUG - SQLException: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            e.printStackTrace();
            request.setAttribute("message", "Database error: Unable to retrieve examination results.");
            request.setAttribute("results", List.of());
            request.setAttribute("patientName", "");
            request.setAttribute("currentPage", 1);
            request.setAttribute("totalRecords", 0);
            request.setAttribute("totalPages", 0);
            request.getRequestDispatcher("/views/user/DoctorNurse/ViewPatientResult.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("DEBUG - Unexpected exception: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unexpected error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("DEBUG - POST request received, but this servlet does not handle POST operations at " + LocalDateTime.now() + " +07");
        String patientName = request.getParameter("patientName");
        String redirectUrl = request.getContextPath() + "/ViewPatientResultServlet";
        if (patientName != null && !patientName.trim().isEmpty()) {
            redirectUrl += "?patientName=" + java.net.URLEncoder.encode(patientName.trim(), "UTF-8");
        }
        request.setAttribute("message", "This page does not support adding prescriptions. Please use the appropriate form.");
        response.sendRedirect(redirectUrl);
    }
}
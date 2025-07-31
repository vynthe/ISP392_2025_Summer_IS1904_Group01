package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Users;
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
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            request.setAttribute("error", "Bạn cần đăng nhập để truy cập trang này.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        Users user = (Users) session.getAttribute("user");
        System.out.println("Session user: UserID=" + user.getUserID() + ", Role=" + user.getRole());
        
        String role = user.getRole();
        if (!"Doctor".equalsIgnoreCase(role) && !"Nurse".equalsIgnoreCase(role)) {
            request.setAttribute("error", "Chỉ bác sĩ hoặc y tá mới có quyền truy cập vào trang này.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        try {
            int userId = user.getUserID();
            String patientName = request.getParameter("patientName");
            String pageStr = request.getParameter("page");
            
            System.out.println("DEBUG - userId: " + userId + ", role: " + role + ", patientName: '" + patientName + "', pageStr: '" + pageStr + "' at " + LocalDateTime.now() + " +07");
            
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
            
            System.out.println("DEBUG - Trimmed patientName: " + trimmedPatientName + ", currentPage: " + currentPage + " at " + LocalDateTime.now() + " +07");

            List<Map<String, Object>> results;
            int totalRecords;
            int totalPages;
            String forwardJsp;

            if ("Doctor".equalsIgnoreCase(role)) {
                results = prescriptionService.getResultWithPatientByDoctorId(userId, trimmedPatientName, currentPage, pageSize);
                totalRecords = prescriptionService.getTotalResultByDoctorId(userId, trimmedPatientName);
                forwardJsp = "/views/user/DoctorNurse/ViewPatientResult.jsp";
            } else {
                results = prescriptionService.getResultWithPatientByNurseId(userId, trimmedPatientName, currentPage, pageSize);
                totalRecords = prescriptionService.getTotalResultByNurseId(userId, trimmedPatientName);
                forwardJsp = "/views/user/Nurse/ViewPatientResultNurse.jsp";
            }
            
            totalPages = (int) Math.ceil((double) totalRecords / pageSize);
            
            System.out.println("DEBUG - Raw results size: " + results.size() + ", totalRecords: " + totalRecords + " at " + LocalDateTime.now() + " +07");
            
            if (!results.isEmpty()) {
                System.out.println("DEBUG - First result keys: " + results.get(0).keySet() + " at " + LocalDateTime.now() + " +07");
                System.out.println("DEBUG - First result data: " + results.get(0) + " at " + LocalDateTime.now() + " +07");
                
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
            }

            request.setAttribute("results", results);
            request.setAttribute("patientName", trimmedPatientName != null ? trimmedPatientName : "");
            request.setAttribute("userId", userId);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalRecords", totalRecords);
            request.setAttribute("totalPages", totalPages);
            
            System.out.println("DEBUG - Setting request attributes at " + LocalDateTime.now() + " +07:");
            System.out.println("  - results size: " + results.size());
            System.out.println("  - patientName: " + (trimmedPatientName != null ? trimmedPatientName : ""));
            System.out.println("  - userId: " + userId);
            System.out.println("  - currentPage: " + currentPage);
            System.out.println("  - totalRecords: " + totalRecords);
            System.out.println("  - totalPages: " + totalPages);

            String message = request.getParameter("message");
            if (message != null) {
                request.setAttribute("message", message);
            }

            String statusMessage = (String) request.getSession().getAttribute("statusMessage");
            if (statusMessage != null) {
                request.setAttribute("message", statusMessage);
                request.getSession().removeAttribute("statusMessage");
            }

            request.getRequestDispatcher(forwardJsp).forward(request, response);
            
        } catch (SQLException e) {
            System.err.println("DEBUG - SQLException for userId " + user.getUserID() + ": " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            e.printStackTrace();
            request.setAttribute("message", "Database error: Unable to retrieve examination results. Please check the database connection or contact the administrator.");
            request.setAttribute("results", List.of());
            request.setAttribute("patientName", "");
            request.setAttribute("currentPage", 1);
            request.setAttribute("totalRecords", 0);
            request.setAttribute("totalPages", 0);
            String forwardJsp = "Doctor".equalsIgnoreCase(role) ? 
                "/views/user/DoctorNurse/ViewPatientResult.jsp" : 
                "/views/user/DoctorNurse/ViewPrescriptionNurse.jsp";
            request.getRequestDispatcher(forwardJsp).forward(request, response);
        } catch (Exception e) {
            System.err.println("DEBUG - Unexpected exception for userId " + user.getUserID() + ": " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
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
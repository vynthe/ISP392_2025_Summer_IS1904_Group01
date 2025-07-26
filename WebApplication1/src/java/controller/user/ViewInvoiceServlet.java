package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.Invoices;
import model.entity.Users;
import model.service.InvoiceService;
import model.service.UserService;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.entity.Prescriptions;
import model.service.PrescriptionService;

public class ViewInvoiceServlet extends HttpServlet {
    private final InvoiceService invoiceService = new InvoiceService();
    private static final long serialVersionUID = 1L;

  
     @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String patientIdStr = request.getParameter("patientId");
            String pageStr = request.getParameter("page");
            
            System.out.println("DEBUG - patientIdStr: '" + patientIdStr + "'");
            System.out.println("DEBUG - pageStr: '" + pageStr + "'");
            
            Integer patientId = null;
            if (patientIdStr != null && !patientIdStr.trim().isEmpty()) {
                try {
                    int parsedId = Integer.parseInt(patientIdStr.trim());
                    if (parsedId > 0) {
                        patientId = parsedId;
                    }
                } catch (NumberFormatException e) {
                    System.out.println("DEBUG - Invalid patientId format: " + patientIdStr);
                }
            }
            
            int currentPage = 1;
            if (pageStr != null && !pageStr.trim().isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageStr.trim());
                    if (currentPage < 1) currentPage = 1;
                } catch (NumberFormatException e) {
                    System.out.println("DEBUG - Invalid page format: " + pageStr);
                }
            }
            
            int pageSize = 10;
            
            System.out.println("DEBUG - Parsed patientId: " + patientId);
            System.out.println("DEBUG - currentPage: " + currentPage);

            List<Map<String, Object>> results;
            int totalRecords = 0;
            int totalPages = 0;

            if (patientId != null && patientId > 0) {
                System.out.println("DEBUG - Getting results for patientId: " + patientId);
                results = invoiceService.getExaminationResultsByPatientId(patientId);
            } else {
                System.out.println("DEBUG - Getting all examination results");
                results = invoiceService.getAllExaminationResults();
            }
            
            System.out.println("DEBUG - Raw results size: " + (results != null ? results.size() : "null"));
            
            if (results != null && !results.isEmpty()) {
                totalRecords = results.size();
                totalPages = (int) Math.ceil((double) totalRecords / pageSize);

                int start = (currentPage - 1) * pageSize;
                int end = Math.min(start + pageSize, results.size());
                
                System.out.println("DEBUG - Pagination: start=" + start + ", end=" + end + ", totalRecords=" + totalRecords);
                
                if (start < results.size() && start >= 0) {
                    results = results.subList(start, end);
                } else {
                    results = List.of();
                    if (totalPages > 0 && currentPage > totalPages) {
                        currentPage = 1;
                        start = 0;
                        end = Math.min(pageSize, totalRecords);
                        results = patientId != null && patientId > 0
                                ? invoiceService.getExaminationResultsByPatientId(patientId).subList(start, end)
                                : invoiceService.getAllExaminationResults().subList(start, end);
                    }
                }
                
                System.out.println("DEBUG - Final results size after pagination: " + results.size());
                
                if (!results.isEmpty()) {
                    System.out.println("DEBUG - First result: " + results.get(0));
                }
            } else {
                results = List.of();
            }

            request.setAttribute("results", results);
            request.setAttribute("patientId", patientId != null ? patientId : 0);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalRecords", totalRecords);
            request.setAttribute("totalPages", totalPages);
            
            System.out.println("DEBUG - Setting request attributes:");
            System.out.println("  - results size: " + results.size());
            System.out.println("  - patientId: " + (patientId != null ? patientId : 0));
            System.out.println("  - currentPage: " + currentPage);
            System.out.println("  - totalRecords: " + totalRecords);
            System.out.println("  - totalPages: " + totalPages);

            request.getRequestDispatcher("/views/user/Receptionist/ViewInvoice.jsp").forward(request, response);
            
        } catch (SQLException e) {
            System.err.println("DEBUG - SQLException: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("message", "Database error: " + e.getMessage());
            request.setAttribute("results", List.of());
            request.setAttribute("patientId", 0);
            request.setAttribute("currentPage", 1);
            request.setAttribute("totalRecords", 0);
            request.setAttribute("totalPages", 0);
            request.getRequestDispatcher("/views/user/Receptionist/ViewInvoice.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("DEBUG - Unexpected exception: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unexpected error: " + e.getMessage());
        }
    }

   @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String invoiceIdStr = request.getParameter("invoiceId");
            String patientIdStr = request.getParameter("patientId");
            String doctorIdStr = request.getParameter("doctorId");
            String totalAmountStr = request.getParameter("totalAmount");
            String serviceIdStr = request.getParameter("serviceId");

            System.out.println("DEBUG POST - invoiceId: " + invoiceIdStr);
            System.out.println("DEBUG POST - patientId: " + patientIdStr);
            System.out.println("DEBUG POST - doctorId: " + doctorIdStr);
            System.out.println("DEBUG POST - totalAmount: " + totalAmountStr);
            System.out.println("DEBUG POST - serviceId: " + serviceIdStr);

            if (patientIdStr == null || doctorIdStr == null || totalAmountStr == null || serviceIdStr == null ||
                patientIdStr.trim().isEmpty() || doctorIdStr.trim().isEmpty() || totalAmountStr.trim().isEmpty() || serviceIdStr.trim().isEmpty()) {
                
                System.out.println("DEBUG POST - Missing required form data");
                request.setAttribute("message", "Missing required form data.");
                
                int patientId = 0;
                try {
                    if (patientIdStr != null && !patientIdStr.trim().isEmpty()) {
                        patientId = Integer.parseInt(patientIdStr.trim());
                    }
                } catch (NumberFormatException e) {
                    System.out.println("DEBUG POST - Invalid patientId: " + patientIdStr);
                }
                
                String redirectUrl = request.getContextPath() + "/ViewInvoiceServlet";
                if (patientId > 0) {
                    redirectUrl += "?patientId=" + patientId;
                }
                response.sendRedirect(redirectUrl);
                return;
            }

            int patientId = Integer.parseInt(patientIdStr.trim());
            int doctorId = Integer.parseInt(doctorIdStr.trim());
            double totalAmount = Double.parseDouble(totalAmountStr.trim());
            int serviceId = Integer.parseInt(serviceIdStr.trim());
            // invoiceId cĂ³ thá»ƒ lĂ  null náº¿u lĂ  hĂ³a Ä‘Æ¡n má»›i
            int invoiceId = (invoiceIdStr != null && !invoiceIdStr.trim().isEmpty()) ? Integer.parseInt(invoiceIdStr.trim()) : 0;

            System.out.println("DEBUG POST - Parsed values: patientId=" + patientId + ", doctorId=" + doctorId + 
                             ", totalAmount=" + totalAmount + ", serviceId=" + serviceId + ", invoiceId=" + invoiceId);

            Invoices invoice = new Invoices();
            invoice.setPatientID(patientId);
            invoice.setDoctorID(doctorId);
            invoice.setTotalAmount(totalAmount);
            invoice.setStatus("PENDING"); // Giáº£ Ä‘á»‹nh tráº¡ng thĂ¡i máº·c Ä‘á»‹nh
            invoice.setServiceID(serviceId);
            invoice.setCreatedBy(doctorId); // Giáº£ Ä‘á»‹nh createdBy lĂ  doctorId
            invoice.setCreatedAt(new java.sql.Date(System.currentTimeMillis()));
            invoice.setUpdatedAt(new java.sql.Date(System.currentTimeMillis()));

            boolean added = invoiceService.addInvoice(invoice);
            System.out.println("DEBUG POST - Invoice added: " + added);
            
            String message = added ? "Invoice added successfully!" : "Failed to add invoice.";
            
            String redirectUrl = request.getContextPath() + "/ViewInvoiceServlet?patientId=" + patientId + "&message=" + java.net.URLEncoder.encode(message, "UTF-8");
            response.sendRedirect(redirectUrl);

        } catch (NumberFormatException e) {
            System.err.println("DEBUG POST - NumberFormatException: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid input data: " + e.getMessage());
        } catch (SQLException e) {
            System.err.println("DEBUG POST - SQLException: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing invoice: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("DEBUG POST - Unexpected exception: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unexpected error: " + e.getMessage());
        }
    }
}
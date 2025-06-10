package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.Services;
import model.service.Services_Service;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "UpdateServiceServlet", urlPatterns = {"/UpdateServiceServlet", "/admin/updateService"})
public class UpdateServiceServlet extends HttpServlet {

    // Khởi tạo logger để ghi log
    private static final Logger LOGGER = Logger.getLogger(UpdateServiceServlet.class.getName());
    private Services_Service servicesService;

    // Khởi tạo servicesService khi Servlet được tạo
    @Override
    public void init() throws ServletException {
        servicesService = new Services_Service();
    }

    // Xử lý GET: Lấy thông tin dịch vụ để hiển thị trên form chỉnh sửa
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");
        // Lấy tham số ID từ request
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            LOGGER.warning("Invalid or missing service ID parameter");
            request.setAttribute("error", "ID dịch vụ không hợp lệ.");
            request.getRequestDispatcher("/views/admin/UpdateService.jsp").forward(request, response);
            return;
        }

        try {
            // Chuyển đổi ID và lấy thông tin dịch vụ
            int serviceID = Integer.parseInt(idParam);
            Services service = servicesService.getServiceById(serviceID);
            if (service != null) {
                // Gửi dữ liệu dịch vụ đến JSP
                request.setAttribute("service", service);
                request.getRequestDispatcher("/views/admin/UpdateService.jsp").forward(request, response);
            } else {
                LOGGER.warning("Service not found for ID: " + serviceID);
                request.setAttribute("error", "Không tìm thấy dịch vụ để chỉnh sửa.");
                request.getRequestDispatcher("/views/admin/UpdateService.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            // Xử lý lỗi ID không hợp lệ
            LOGGER.log(Level.SEVERE, "Invalid service ID format: " + idParam, e);
            request.setAttribute("error", "ID dịch vụ không hợp lệ: " + idParam);
            request.getRequestDispatcher("/views/admin/UpdateService.jsp").forward(request, response);
        } catch (SQLException e) {
            // Xử lý lỗi cơ sở dữ liệu
            LOGGER.log(Level.SEVERE, "Database error while fetching service: " + idParam, e);
            request.setAttribute("error", "Lỗi khi tải thông tin dịch vụ: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/UpdateService.jsp").forward(request, response);
        }
    }

    // Xử lý POST: Cập nhật thông tin dịch vụ
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");

        // Lấy dữ liệu từ form
        String serviceIdParam = request.getParameter("serviceID");
        String serviceName = request.getParameter("serviceName");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String status = request.getParameter("status");

        // Kiểm tra các trường bắt buộc
        if (serviceIdParam == null || serviceIdParam.trim().isEmpty() ||
            serviceName == null || serviceName.trim().isEmpty() ||
            priceStr == null || priceStr.trim().isEmpty() ||
            status == null || status.trim().isEmpty()) {
            LOGGER.warning("Missing or empty required fields");
            request.setAttribute("error", "Vui lòng điền đầy đủ tất cả các trường bắt buộc.");
            setFormAttributes(request, serviceIdParam, serviceName, description, priceStr, status);
            request.getRequestDispatcher("/views/admin/UpdateService.jsp").forward(request, response);
            return;
        }

        // Chuyển đổi và kiểm tra ID
        int serviceID;
        try {
            serviceID = Integer.parseInt(serviceIdParam);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid service ID format: " + serviceIdParam, e);
            request.setAttribute("error", "ID dịch vụ không hợp lệ.");
            setFormAttributes(request, serviceIdParam, serviceName, description, priceStr, status);
            request.getRequestDispatcher("/views/admin/UpdateService.jsp").forward(request, response);
            return;
        }

        // Chuyển đổi và kiểm tra giá
        double price;
        try {
            price = Double.parseDouble(priceStr);
            if (price < 0) {
                throw new IllegalArgumentException("Giá dịch vụ không thể âm.");
            }
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid price format: " + priceStr, e);
            request.setAttribute("error", "Giá dịch vụ không hợp lệ.");
            setFormAttributes(request, serviceIdParam, serviceName, description, priceStr, status);
            request.getRequestDispatcher("/views/admin/UpdateService.jsp").forward(request, response);
            return;
        } catch (IllegalArgumentException e) {
            LOGGER.log(Level.WARNING, "Invalid price value: " + priceStr, e);
            request.setAttribute("error", e.getMessage());
            setFormAttributes(request, serviceIdParam, serviceName, description, priceStr, status);
            request.getRequestDispatcher("/views/admin/UpdateService.jsp").forward(request, response);
            return;
        }

        // Tạo đối tượng Services và gán dữ liệu
        Services service = new Services();
        service.setServiceID(serviceID);
        service.setServiceName(serviceName.trim());
        service.setDescription(description != null ? description.trim() : "");
        service.setPrice(price);
        service.setStatus(status.trim());

        try {
            // Cập nhật dịch vụ
            boolean updated = servicesService.updateService(service);
            if (updated) {
                LOGGER.info("Service updated successfully: ID=" + serviceID + ", Name=" + serviceName);
                response.sendRedirect(request.getContextPath() + "/ViewServiceServlet");
            } else {
                LOGGER.warning("Service update failed for ID: " + serviceID);
                request.setAttribute("error", "Không thể cập nhật thông tin dịch vụ.");
                request.setAttribute("service", service);
                request.getRequestDispatcher("/views/admin/UpdateService.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            // Xử lý lỗi cơ sở dữ liệu
            LOGGER.log(Level.SEVERE, "Database error during service update: " + serviceID, e);
            request.setAttribute("error", "Lỗi khi cập nhật thông tin dịch vụ: " + e.getMessage());
            request.setAttribute("service", service);
            request.getRequestDispatcher("/views/admin/UpdateService.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            // Xử lý lỗi xác thực dữ liệu
            LOGGER.log(Level.WARNING, "Validation error during service update: " + e.getMessage(), e);
            request.setAttribute("error", e.getMessage());
            request.setAttribute("service", service);
            request.getRequestDispatcher("/views/admin/UpdateService.jsp").forward(request, response);
        }
    }

    // Phương thức hỗ trợ: Lưu dữ liệu form để hiển thị lại khi có lỗi
    private void setFormAttributes(HttpServletRequest request, String serviceID, String serviceName,
                                  String description, String price, String status) {
        request.setAttribute("serviceID", serviceID);
        request.setAttribute("serviceName", serviceName);
        request.setAttribute("description", description);
        request.setAttribute("price", price);
        request.setAttribute("status", status);
    }
}
/*
 * Click https://netbeans.apache.org/project_downloads/www/license.html to change this license
 * Click https://netbeans.apache.org/project_downloads/www/java/class.html to edit this template
 */
package model.service;

import java.sql.Date;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import model.dao.ServicesDAO;
import model.entity.Services;

public class Services_Service {
    private ServicesDAO servicesDAO;

    public Services_Service() {
        servicesDAO = new ServicesDAO();
    }

   public void addService(Services service, int adminId) throws SQLException, IllegalArgumentException {
        try {
            // Validate service
            if (service.getServiceName() == null || service.getServiceName().trim().isEmpty()) {
                throw new IllegalArgumentException("Tên dịch vụ không được để trống.");
            }
            if (service.getPrice() < 0) {
                throw new IllegalArgumentException("Giá dịch vụ không hợp lệ");
            }
            if (service.getStatus() == null || service.getStatus().trim().isEmpty()) {
                throw new IllegalArgumentException("Trạng thái dịch vụ không được để trống.");
            }
            if (servicesDAO.isServiceNameAndPriceExists(service.getServiceName(), service.getPrice())) {
                throw new IllegalArgumentException("Dịch vụ này đã tồn tại");
            }

            // Set timestamps and creator
            service.setCreatedBy(adminId);
            Date currentDate = Date.valueOf(LocalDate.now());
            service.setCreatedAt(currentDate);
            service.setUpdatedAt(currentDate);

            // Delegate to DAO
            servicesDAO.addService(service, adminId);
        } catch (SQLException e) {
            // Handle validation exceptions from DAO
            if (e.getMessage().contains("Tên dịch vụ không hợp lệ")) {
                throw new IllegalArgumentException("Tên dịch vụ không hợp lệ");
            } else if (e.getMessage().contains("Tên không được để trống")) {
                throw new IllegalArgumentException("Tên dịch vụ không được để trống.");
            }
            throw e; // Re-throw other SQL exceptions
        }
    }

    public boolean updateService(Services service) throws SQLException, IllegalArgumentException {
        if (service.getServiceName() == null || service.getServiceName().trim().isEmpty()) {
            throw new IllegalArgumentException("Tên dịch vụ không được để trống.");
        }
        if (service.getPrice() < 0) {
            throw new IllegalArgumentException("Giá dịch vụ không hợp lệ");
        }
        if (service.getStatus() == null || service.getStatus().trim().isEmpty()) {
            throw new IllegalArgumentException("Trạng thái dịch vụ không được để trống.");
        }
        Services existingService = servicesDAO.getServiceById(service.getServiceID());
        if (existingService == null) {
            throw new IllegalArgumentException("Dịch vụ với ID " + service.getServiceID() + " không tồn tại.");
        }
        if (!service.getServiceName().trim().equals(existingService.getServiceName()) || 
            service.getPrice() != existingService.getPrice()) {
            if (servicesDAO.isServiceNameAndPriceExists(service.getServiceName(), service.getPrice())) {
                throw new IllegalArgumentException("Dịch vụ này đã tồn tại");
            }
        }
        service.setUpdatedAt(Date.valueOf(LocalDate.now()));
        return servicesDAO.updateService(service); // Return the boolean result from DAO
    }

    public boolean deleteService(int serviceId) throws SQLException {
        System.out.println("Checking if service exists with ID: " + serviceId );
        try {
            Services existingService = servicesDAO.getServiceById(serviceId);
            if (existingService == null) {
                System.out.println("Service not found with ID: " + serviceId);
                throw new SQLException("Dịch vụ với ID " + serviceId + " không tồn tại.");
            }
            System.out.println("Attempting to delete service with ID: " + serviceId );
            boolean deleted = servicesDAO.deleteService(serviceId);
            if (deleted) {
                System.out.println("Service deleted successfully: ID=" + serviceId);
            } else {
                System.out.println("Failed to delete service with ID: " + serviceId );
                throw new SQLException("Không thể xóa dịch vụ với ID: " + serviceId);
            }
            return deleted;
        } catch (SQLException e) {
            System.out.println("Database error while deleting service with ID: " + serviceId + " - " + e.getMessage());
            throw e;
        }
    }

    public Services getServiceById(int serviceId) throws SQLException {
        Services service = servicesDAO.getServiceById(serviceId);
        if (service == null) {
            throw new SQLException("Dịch vụ với ID " + serviceId + " không tồn tại.");
        }
        return service;
    }

    public List<Services> getAllServices() throws SQLException {
        return servicesDAO.getAllServices();
    }

    public boolean isServiceNameAndPriceExists(String serviceName, double price) throws SQLException {
        return servicesDAO.isServiceNameAndPriceExists(serviceName, price);
    }
    public List<Services> getServicesByCategory(String category) throws SQLException {
    ServicesDAO servicesDAO = new ServicesDAO();
    return servicesDAO.getServicesByCategory(category);
}
}
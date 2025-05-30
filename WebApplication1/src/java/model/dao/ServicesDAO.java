package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.entity.Services;

public class ServicesDAO {

    private static final String INSERT_SERVICE_SQL = "INSERT INTO Services (ServiceName, [Description], Price, [Status], CreatedBy, CreatedAt, UpdatedAt) VALUES (?, ?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_SERVICE_SQL = "UPDATE Services SET ServiceName = ?, [Description] = ?, Price = ?, [Status] = ?, UpdatedAt = GETDATE() WHERE ServiceID = ?";
    private static final String SELECT_SERVICE_BY_ID = "SELECT ServiceID, ServiceName, [Description], Price, [Status], CreatedBy, CreatedAt, UpdatedAt FROM Services WHERE ServiceID = ?";
    private static final String SELECT_ALL_SERVICES = "SELECT ServiceID, ServiceName, [Description], Price, [Status], CreatedBy, CreatedAt, UpdatedAt FROM Services";
    private static final String CHECK_SERVICE_NAME_AND_PRICE_EXISTS = "SELECT COUNT(*) FROM Services WHERE ServiceName = ? AND Price = ?";
    private static final String DELETE_SERVICE_SQL = "DELETE FROM Services WHERE ServiceID = ?";
    private static final String SELECT_SERVICES_BY_CATEGORY = "SELECT ServiceID, ServiceName, [Description], Price, [Status], CreatedBy, CreatedAt, UpdatedAt FROM Services WHERE UPPER(ServiceName) LIKE ? AND [Status] = 'Active'";

    private final DBContext dbContext;

    public ServicesDAO() {
        this.dbContext = DBContext.getInstance();
    }

    private void validateServiceName(String serviceName) throws SQLException {
        if (serviceName == null || serviceName.trim().isEmpty()) {
            throw new SQLException("Tên không được để trống.");
        }
        if (!serviceName.trim().matches("^[\\p{L}0-9\\s-]+$")) {
            throw new SQLException("Tên dịch vụ không hợp lệ");
        }
    }

    private void validatePrice(double price) throws SQLException {
        try {
            if (price < 0) {
                throw new SQLException("Giá dịch vụ không được âm.");
            }
        } catch (NumberFormatException e) {
            throw new SQLException("Giá dịch vụ phải là một số hợp lệ.");
        }
    }

    private void validateStatus(String status) throws SQLException {
        if (status == null || status.trim().isEmpty()) {
            throw new SQLException("Trạng thái dịch vụ không được để trống.");
        }
    }

    private void validateService(Services service) throws SQLException {
        validateServiceName(service.getServiceName());
        validatePrice(service.getPrice());
        validateStatus(service.getStatus());
    }

    public boolean isServiceNameAndPriceExists(String serviceName, double price) throws SQLException {
        if (serviceName == null || serviceName.trim().isEmpty()) {
            return false;
        }
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(CHECK_SERVICE_NAME_AND_PRICE_EXISTS)) {
            stmt.setString(1, serviceName.trim());
            stmt.setDouble(2, price);
            System.out.println("Checking if service name and price exists: ServiceName=" + serviceName + ", Price=" + price + " at " + LocalDateTime.now() + " +07");
            try (ResultSet rs = stmt.executeQuery()) {
                boolean exists = rs.next() && rs.getInt(1) > 0;
                System.out.println("Service name and price exists: " + exists + " for ServiceName=" + serviceName + ", Price=" + price + " at " + LocalDateTime.now() + " +07");
                return exists;
            }
        }
    }

    public boolean addService(Services service, int createdBy) throws SQLException {
        validateService(service);

        if (isServiceNameAndPriceExists(service.getServiceName(), service.getPrice())) {
            throw new SQLException("Dịch vụ đã tồn tại");
        }

        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(INSERT_SERVICE_SQL)) {
            stmt.setString(1, service.getServiceName() != null ? service.getServiceName().trim() : null);
            stmt.setString(2, service.getDescription() != null ? service.getDescription().trim() : null);
            stmt.setDouble(3, service.getPrice());
            stmt.setString(4, service.getStatus() != null ? service.getStatus().trim() : null);
            stmt.setInt(5, createdBy);
            stmt.setTimestamp(6, service.getCreatedAt() != null ? new Timestamp(service.getCreatedAt().getTime()) : new Timestamp(System.currentTimeMillis()));
            stmt.setTimestamp(7, service.getUpdatedAt() != null ? new Timestamp(service.getUpdatedAt().getTime()) : new Timestamp(System.currentTimeMillis()));

            System.out.println("Executing SQL: " + INSERT_SERVICE_SQL + " with values ServiceName=" + service.getServiceName() + ", Price=" + service.getPrice() + ", Status=" + service.getStatus() + " at " + LocalDateTime.now() + " +07");
            int rowsAffected = stmt.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected + " for ServiceName=" + service.getServiceName() + " at " + LocalDateTime.now() + " +07");
            return rowsAffected > 0;
        }
    }

    public boolean updateService(Services service) throws SQLException {
        validateService(service);

        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(CHECK_SERVICE_NAME_AND_PRICE_EXISTS + " AND ServiceID != ?")) {
            stmt.setString(1, service.getServiceName() != null ? service.getServiceName().trim() : "");
            stmt.setDouble(2, service.getPrice());
            stmt.setInt(3, service.getServiceID());
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    throw new SQLException("Dịch vụ đã tồn tại");
                }
            }
        }

        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(UPDATE_SERVICE_SQL)) {
            stmt.setString(1, service.getServiceName() != null ? service.getServiceName().trim() : null);
            stmt.setString(2, service.getDescription() != null ? service.getDescription().trim() : null);
            stmt.setDouble(3, service.getPrice());
            stmt.setString(4, service.getStatus() != null ? service.getStatus().trim() : null);
            stmt.setInt(5, service.getServiceID());

            System.out.println("Executing SQL: " + UPDATE_SERVICE_SQL + " for ServiceID=" + service.getServiceID() + " at " + LocalDateTime.now() + " +07");
            int rowsAffected = stmt.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected + " for ServiceID=" + service.getServiceID() + " at " + LocalDateTime.now() + " +07");
            return rowsAffected > 0;
        }
    }

    public boolean deleteService(int serviceId) throws SQLException {
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(DELETE_SERVICE_SQL)) {
            stmt.setInt(1, serviceId);
            System.out.println("Executing SQL: " + DELETE_SERVICE_SQL + " for ServiceID=" + serviceId + " at " + LocalDateTime.now() + " +07");
            int rowsAffected = stmt.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected + " for ServiceID=" + serviceId + " at " + LocalDateTime.now() + " +07");
            return rowsAffected > 0;
        }
    }

    public Services getServiceById(int serviceId) throws SQLException {
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(SELECT_SERVICE_BY_ID)) {
            stmt.setInt(1, serviceId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Services service = new Services();
                    service.setServiceID(rs.getInt("ServiceID"));
                    service.setServiceName(rs.getString("ServiceName"));
                    service.setDescription(rs.getString("Description"));
                    service.setPrice(rs.getDouble("Price"));
                    service.setStatus(rs.getString("Status"));
                    service.setCreatedBy(rs.getObject("CreatedBy") != null ? rs.getInt("CreatedBy") : 0);
                    service.setCreatedAt(rs.getTimestamp("CreatedAt") != null ? new java.sql.Date(rs.getTimestamp("CreatedAt").getTime()) : null);
                    service.setUpdatedAt(rs.getTimestamp("UpdatedAt") != null ? new java.sql.Date(rs.getTimestamp("UpdatedAt").getTime()) : null);
                    return service;
                }
            }
        }
        throw new SQLException("Dịch vụ với ID " + serviceId + " không tồn tại.");
    }

    public List<Services> getAllServices() throws SQLException {
        List<Services> services = new ArrayList<>();
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(SELECT_ALL_SERVICES); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Services service = new Services();
                service.setServiceID(rs.getInt("ServiceID"));
                service.setServiceName(rs.getString("ServiceName"));
                service.setDescription(rs.getString("Description"));
                service.setPrice(rs.getDouble("Price"));
                service.setStatus(rs.getString("Status"));
                service.setCreatedBy(rs.getObject("CreatedBy") != null ? rs.getInt("CreatedBy") : 0);
                service.setCreatedAt(rs.getTimestamp("CreatedAt") != null ? new java.sql.Date(rs.getTimestamp("CreatedAt").getTime()) : null);
                service.setUpdatedAt(rs.getTimestamp("UpdatedAt") != null ? new java.sql.Date(rs.getTimestamp("UpdatedAt").getTime()) : null);
                services.add(service);
            }
        }
        return services;
    }

    public List<Services> getServicesByCategory(String category) throws SQLException {
        List<Services> services = new ArrayList<>();
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(SELECT_SERVICES_BY_CATEGORY)) {
            stmt.setString(1, "%" + category.toUpperCase() + "%");
            System.out.println("Executing SQL: " + SELECT_SERVICES_BY_CATEGORY + " with category=" + category + " at " + LocalDateTime.now() + " +07");
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Services service = new Services();
                    service.setServiceID(rs.getInt("ServiceID"));
                    service.setServiceName(rs.getString("ServiceName"));
                    service.setDescription(rs.getString("Description"));
                    service.setPrice(rs.getDouble("Price"));
                    service.setStatus(rs.getString("Status"));
                    service.setCreatedBy(rs.getObject("CreatedBy") != null ? rs.getInt("CreatedBy") : 0);
                    service.setCreatedAt(rs.getTimestamp("CreatedAt") != null ? new java.sql.Date(rs.getTimestamp("CreatedAt").getTime()) : null);
                    service.setUpdatedAt(rs.getTimestamp("UpdatedAt") != null ? new java.sql.Date(rs.getTimestamp("UpdatedAt").getTime()) : null);
                    services.add(service);
                }
            }
            System.out.println("Found " + services.size() + " services for category=" + category + " at " + LocalDateTime.now() + " +07");
            return services;
        }
    }
}
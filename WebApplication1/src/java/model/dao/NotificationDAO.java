package model.dao;

import model.entity.Notification;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {
    private DBContext dbContext = DBContext.getInstance();

    public void createNotification(Notification notification) throws SQLException {
        String sql = "INSERT INTO Notifications (SenderID, SenderRole, ReceiverID, ReceiverRole, Title, Message, IsRead, CreatedAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, notification.getSenderID());
            stmt.setString(2, notification.getSenderRole());
            stmt.setInt(3, notification.getReceiverID());
            stmt.setString(4, notification.getReceiverRole());
            stmt.setString(5, notification.getTitle());
            stmt.setString(6, notification.getMessage());
            stmt.setBoolean(7, notification.isRead());
            stmt.setTimestamp(8, Timestamp.valueOf(notification.getCreatedAt()));
            stmt.executeUpdate();

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    notification.setNotificationID(generatedKeys.getInt(1));
                }
            }
        }
    }

    public List<Notification> getAdminNotifications(int adminId) throws SQLException {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM Notifications WHERE ReceiverID = ? AND ReceiverRole = 'Admin' ORDER BY CreatedAt DESC";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, adminId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Notification notification = new Notification();
                    notification.setNotificationID(rs.getInt("NotificationID"));
                    notification.setSenderID(rs.getInt("SenderID"));
                    notification.setSenderRole(rs.getString("SenderRole"));
                    notification.setReceiverID(rs.getInt("ReceiverID"));
                    notification.setReceiverRole(rs.getString("ReceiverRole"));
                    notification.setTitle(rs.getString("Title"));
                    notification.setMessage(rs.getString("Message"));
                    notification.setRead(rs.getBoolean("IsRead"));
                    notification.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                    notifications.add(notification);
                }
            }
        }
        return notifications;
    }

    public int getUnreadNotificationCountForAdmin(int adminId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Notifications WHERE ReceiverID = ? AND ReceiverRole = 'Admin' AND IsRead = 0";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, adminId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    public Notification getById(int notificationId) throws SQLException {
        String sql = "SELECT * FROM Notifications WHERE NotificationID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, notificationId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Notification notification = new Notification();
                    notification.setNotificationID(rs.getInt("NotificationID"));
                    notification.setSenderID(rs.getInt("SenderID"));
                    notification.setSenderRole(rs.getString("SenderRole"));
                    notification.setReceiverID(rs.getInt("ReceiverID"));
                    notification.setReceiverRole(rs.getString("ReceiverRole"));
                    notification.setTitle(rs.getString("Title"));
                    notification.setMessage(rs.getString("Message"));
                    notification.setRead(rs.getBoolean("IsRead"));
                    notification.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                    return notification;
                }
            }
        }
        return null;
    }

    public void markNotificationAsRead(int notificationId) throws SQLException {
        String sql = "UPDATE Notifications SET IsRead = 1 WHERE NotificationID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, notificationId);
            stmt.executeUpdate();
        }
    }
}
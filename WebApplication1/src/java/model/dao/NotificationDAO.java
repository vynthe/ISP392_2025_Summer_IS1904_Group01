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
            // Handle nullable SenderID
            if (notification.getSenderID() == null) {
                stmt.setNull(1, java.sql.Types.INTEGER);
            } else {
                stmt.setInt(1, notification.getSenderID());
            }
            stmt.setString(2, notification.getSenderRole());
            stmt.setInt(3, notification.getReceiverID());
            stmt.setString(4, notification.getReceiverRole());
            stmt.setString(5, notification.getTitle());
            stmt.setString(6, notification.getMessage());
            stmt.setBoolean(7, notification.isRead());
            stmt.setTimestamp(8, Timestamp.valueOf(notification.getCreatedAt()));
            int rowsAffected = stmt.executeUpdate();
            System.out.println("Inserted notification: " + notification.getTitle() + ", Rows affected: " + rowsAffected);

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    notification.setNotificationID(generatedKeys.getInt(1));
                }
            }
        } catch (SQLException e) {
            System.err.println("SQL Error inserting notification: " + e.getMessage());
            throw e;
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
                    // Handle nullable SenderID
                    if (rs.getObject("SenderID") == null) {
                        notification.setSenderID(null);
                    } else {
                        notification.setSenderID(rs.getInt("SenderID"));
                    }
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
        } catch (SQLException e) {
            System.err.println("SQL Error retrieving notifications for AdminID " + adminId + ": " + e.getMessage());
            throw e;
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
        } catch (SQLException e) {
            System.err.println("SQL Error counting unread notifications for AdminID " + adminId + ": " + e.getMessage());
            throw e;
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
                    // Handle nullable SenderID
                    if (rs.getObject("SenderID") == null) {
                        notification.setSenderID(null);
                    } else {
                        notification.setSenderID(rs.getInt("SenderID"));
                    }
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
        } catch (SQLException e) {
            System.err.println("SQL Error retrieving notification ID " + notificationId + ": " + e.getMessage());
            throw e;
        }
        return null;
    }

    public void markNotificationAsRead(int notificationId) throws SQLException {
        String sql = "UPDATE Notifications SET IsRead = 1 WHERE NotificationID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, notificationId);
            int rowsAffected = stmt.executeUpdate();
            System.out.println("Marked notification ID " + notificationId + " as read, Rows affected: " + rowsAffected);
        } catch (SQLException e) {
            System.err.println("SQL Error marking notification ID " + notificationId + " as read: " + e.getMessage());
            throw e;
        }
    }
    
}
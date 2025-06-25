
package model.service;

import model.dao.NotificationDAO;
import model.entity.Notification;
import java.sql.SQLException;
import java.util.List;

public class NotificationService {
    private final NotificationDAO notificationDAO = new NotificationDAO();

    public void createNotification(Notification notification) throws SQLException {
        if (notification == null) {
            throw new IllegalArgumentException("Notification cannot be null");
        }
        try {
            notificationDAO.createNotification(notification);
            System.out.println("Notification created successfully: " + notification.getTitle() + 
                               ", SenderID: " + notification.getSenderID() + 
                               ", ReceiverID: " + notification.getReceiverID());
        } catch (SQLException e) {
            System.err.println("Error creating notification: " + e.getMessage());
            throw e;
        }
    }

    public List<Notification> getAdminNotifications(int adminId) throws SQLException {
        try {
            List<Notification> notifications = notificationDAO.getAdminNotifications(adminId);
            System.out.println("Retrieved " + notifications.size() + " notifications for AdminID: " + adminId);
            return notifications;
        } catch (SQLException e) {
            System.err.println("Error retrieving notifications for AdminID " + adminId + ": " + e.getMessage());
            throw e;
        }
    }

    public int getUnreadNotificationCountForAdmin(int adminId) throws SQLException {
        try {
            int count = notificationDAO.getUnreadNotificationCountForAdmin(adminId);
            System.out.println("Unread notification count for AdminID " + adminId + ": " + count);
            return count;
        } catch (SQLException e) {
            System.err.println("Error counting unread notifications for AdminID " + adminId + ": " + e.getMessage());
            throw e;
        }
    }

    public Notification getById(int notificationId) throws SQLException {
        try {
            Notification notification = notificationDAO.getById(notificationId);
            if (notification != null) {
                System.out.println("Retrieved notification ID " + notificationId + ": " + notification.getTitle());
            } else {
                System.out.println("No notification found for ID: " + notificationId);
            }
            return notification;
        } catch (SQLException e) {
            System.err.println("Error retrieving notification ID " + notificationId + ": " + e.getMessage());
            throw e;
        }
    }

    public void markNotificationAsRead(int notificationId) throws SQLException {
        try {
            notificationDAO.markNotificationAsRead(notificationId);
            System.out.println("Marked notification ID " + notificationId + " as read");
        } catch (SQLException e) {
            System.err.println("Error marking notification ID " + notificationId + " as read: " + e.getMessage());
            throw e;
        }
    }
}
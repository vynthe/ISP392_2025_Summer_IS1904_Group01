package model.service;

import model.dao.NotificationDAO;
import model.entity.Notification;
import java.sql.SQLException;
import java.util.List;

public class NotificationService {
    private final NotificationDAO notificationDAO = new NotificationDAO();

    public void createNotification(Notification notification) throws SQLException {
        notificationDAO.createNotification(notification);
    }

    public List<Notification> getAdminNotifications(int adminId) throws SQLException {
        return notificationDAO.getAdminNotifications(adminId);
    }

    public int getUnreadNotificationCountForAdmin(int adminId) throws SQLException {
        return notificationDAO.getUnreadNotificationCountForAdmin(adminId);
    }

    public Notification getById(int notificationId) throws SQLException {
        return notificationDAO.getById(notificationId);
    }

    public void markNotificationAsRead(int notificationId) throws SQLException {
        notificationDAO.markNotificationAsRead(notificationId);
    }
}
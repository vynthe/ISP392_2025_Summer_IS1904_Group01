package model.service;

import model.dao.UserDAO;
import model.entity.Reviews;
import model.entity.ReviewReply;
import model.entity.Users;
import model.entity.Services;
import model.service.Services_Service;
import java.sql.SQLException;
import java.util.List;

public class ReviewService {
    private final UserDAO userDAO;
    private final Services_Service servicesService;

    public ReviewService() {
        this.userDAO = new UserDAO();
        this.servicesService = new Services_Service();
    }

    /**
     * Lấy danh sách bác sĩ mà bệnh nhân có thể đánh giá
     * (chỉ những bác sĩ đã khám cho bệnh nhân)
     */
    public List<Users> getDoctorsForReview(int patientId) {
        return userDAO.getDoctorsForReview(patientId);
    }

    /**
     * Lấy danh sách dịch vụ mà bệnh nhân đã sử dụng với bác sĩ cụ thể
     */
    public List<Services> getServicesForReview(int patientId, int doctorId) {
        return userDAO.getServicesForReview(patientId, doctorId);
    }

    /**
     * Kiểm tra xem bệnh nhân có thể đánh giá bác sĩ này không
     */
    public boolean canPatientReview(int patientId, int doctorId) {
        return userDAO.canPatientReview(patientId, doctorId);
    }

    /**
     * Lưu đánh giá của bệnh nhân
     */
    public boolean submitReview(int patientId, int doctorId, int serviceId, int serviceRating, int doctorRating, String comment) throws SQLException {
        // Kiểm tra quyền đánh giá
        if (!canPatientReview(patientId, doctorId)) {
            throw new SQLException("Bạn không thể đánh giá bác sĩ này vì chưa từng được khám bởi bác sĩ này.");
        }

        // Kiểm tra đã đánh giá chưa
        if (hasPatientReviewed(patientId, doctorId, serviceId)) {
            throw new SQLException("Bạn đã đánh giá bác sĩ này cho dịch vụ này rồi.");
        }

        Reviews review = new Reviews(patientId, doctorId, serviceId, serviceRating, doctorRating, comment);
        return userDAO.saveReview(review);
    }

    /**
     * Kiểm tra xem bệnh nhân đã đánh giá bác sĩ cho dịch vụ này chưa
     */
    public boolean hasPatientReviewed(int patientId, int doctorId, int serviceId) {
        return userDAO.hasPatientReviewed(patientId, doctorId, serviceId);
    }

    /**
     * Lấy tất cả đánh giá với phản hồi (cho admin xem)
     */
    public List<Reviews> getAllReviewsWithReplies() throws SQLException {
        return userDAO.getAllReviewsWithReplies();
    }

    /**
     * Lấy đánh giá theo bác sĩ
     */
    public List<Reviews> getReviewsByDoctorId(int doctorId) throws SQLException {
        return userDAO.getReviewsByDoctorID(doctorId);
    }

    /**
     * Lưu phản hồi của admin
     */
    public boolean saveReply(int reviewId, int adminId, String replyContent) throws SQLException {
        // Kiểm tra review có tồn tại không
        if (!userDAO.reviewExists(reviewId)) {
            throw new SQLException("Đánh giá không tồn tại.");
        }

        ReviewReply reply = new ReviewReply();
        reply.setReviewID(reviewId);
        reply.setUserID(adminId);
        reply.setComment(replyContent);

        return userDAO.saveReply(reply);
    }

    /**
     * Lấy phản hồi theo reviewId
     */
    public List<ReviewReply> getRepliesByReviewId(int reviewId) throws SQLException {
        return userDAO.getRepliesByReviewId(reviewId);
    }
    public List<Reviews> searchReviewsByDoctorOrPatient(String doctorName, String patientName) throws SQLException {
        // Chuẩn hóa tham số tìm kiếm
        doctorName = (doctorName != null && !doctorName.trim().isEmpty()) ? "%" + doctorName.trim() + "%" : null;
        patientName = (patientName != null && !patientName.trim().isEmpty()) ? "%" + patientName.trim() + "%" : null;

        // Gọi DAO để thực hiện tìm kiếm
        return userDAO.searchReviewsByDoctorOrPatient(doctorName, patientName);
    }
        public boolean editReply(int replyId, int adminId, String replyContent) throws SQLException {
        // Kiểm tra phản hồi có tồn tại không
        if (!userDAO.replyExists(replyId, adminId)) {
            throw new SQLException("Phản hồi không tồn tại hoặc bạn không có quyền chỉnh sửa.");
        }

        ReviewReply reply = new ReviewReply();
        reply.setReplyID(replyId);
        reply.setUserID(adminId);
        reply.setComment(replyContent);

        return userDAO.updateReply(reply);
    }
    public boolean deleteReply(int replyId, int adminId) throws SQLException {
        if (!userDAO.replyExists(replyId, adminId)) {
            throw new SQLException("Phản hồi không tồn tại hoặc bạn không có quyền xóa.");
        }
        return userDAO.deleteReply(replyId, adminId);
    }
    public boolean deleteComment(int reviewId) throws SQLException {
        if (!userDAO.reviewExists(reviewId)) {
            throw new SQLException("Đánh giá không tồn tại.");
        }
        return userDAO.deleteComment(reviewId);
    }
}

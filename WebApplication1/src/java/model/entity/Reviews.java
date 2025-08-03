package model.entity;

import java.sql.Timestamp;
import java.util.List;

public class Reviews {
    private int reviewID;
    private int userID;
    private int doctorID;
    private int serviceID;
    private int serviceRating;
    private int doctorRating;
    private String comment;
    private Timestamp createdAt;
    private String userFullName; // Để hiển thị tên bệnh nhân
    private String doctorFullName; // Để hiển thị tên bác sĩ
    private String serviceName; // Để hiển thị tên dịch vụ
    private List<ReviewReply> replies;

    // Constructors
    public Reviews() {}

    public Reviews(int userID, int doctorID, int serviceID, int serviceRating, int doctorRating, String comment) {
        this.userID = userID;
        this.doctorID = doctorID;
        this.serviceID = serviceID;
        this.serviceRating = serviceRating;
        this.doctorRating = doctorRating;
        this.comment = comment;
    }

    // Getters and Setters
    public int getReviewID() {
        return reviewID;
    }

    public void setReviewID(int reviewID) {
        this.reviewID = reviewID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public int getDoctorID() {
        return doctorID;
    }

    public void setDoctorID(int doctorID) {
        this.doctorID = doctorID;
    }

    public int getServiceID() {
        return serviceID;
    }

    public void setServiceID(int serviceID) {
        this.serviceID = serviceID;
    }

    public int getServiceRating() {
        return serviceRating;
    }

    public void setServiceRating(int serviceRating) {
        this.serviceRating = serviceRating;
    }

    public int getDoctorRating() {
        return doctorRating;
    }

    public void setDoctorRating(int doctorRating) {
        this.doctorRating = doctorRating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getUserFullName() {
        return userFullName;
    }

    public void setUserFullName(String userFullName) {
        this.userFullName = userFullName;
    }

    public String getDoctorFullName() {
        return doctorFullName;
    }

    public void setDoctorFullName(String doctorFullName) {
        this.doctorFullName = doctorFullName;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public List<ReviewReply> getReplies() {
        return replies;
    }

    public void setReplies(List<ReviewReply> replies) {
        this.replies = replies;
    }
}

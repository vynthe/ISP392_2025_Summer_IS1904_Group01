<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Examination Results</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .error { color: red; font-size: 18px; }
        .error-box { background-color: #ffebee; padding: 10px; border: 1px solid #ffcdd2; margin-bottom: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        .pagination { margin-top: 20px; }
        .pagination a { margin: 0 5px; text-decoration: none; }
        .pagination a.active { font-weight: bold; }
        .back-button { background-color: #007bff; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; }
        .action-button { background-color: #28a745; color: white; padding: 6px 12px; text-decoration: none; border-radius: 4px; }
        .action-button:hover { background-color: #218838; }
    </style>
</head>
<body>
    <h2>Danh sách lịch hẹn khám bệnh</h2>

    <!-- Hiển thị thông báo lỗi nếu có -->
    <c:if test="${not empty errorMessage}">
        <div class="error-box">
            <p class="error">Lỗi</p>
            <c:choose>
                <c:when test="${errorMessage.contains('Lỗi khi lấy dữ liệu lịch hẹn')}">
                    <p>Lỗi hệ thống: ${errorMessage}. Vui lòng thử lại hoặc liên hệ quản trị viên.</p>
                </c:when>
                <c:otherwise>
                    <p>${errorMessage}</p>
                </c:otherwise>
            </c:choose>
            <a href="javascript:history.back()" class="back-button">Quay lại trang trước</a>
        </div>
    </c:if>

    <c:if test="${empty errorMessage}">
        <c:if test="${empty appointments}">
            <p>Không tìm thấy lịch hẹn nào. Vui lòng kiểm tra lại hoặc liên hệ quản trị viên.</p>
        </c:if>

        <c:if test="${not empty appointments}">
            <table>
                <thead>
                    <tr>
                        <th>Appointment ID</th>
                        <th>Patient Name</th>
                        <th>Service</th>
                        <th>Room</th>
                        <th>Date</th>
                        <th>Time</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="appointment" items="${appointments}">
                        <tr>
                            <td>${appointment.appointmentId}</td>
                            <td>${appointment.patientName}</td>
                            <td>${appointment.serviceName}</td>
                            <td>${appointment.roomName}</td>
                            <td>${appointment.slotDate}</td>
                            <td>${appointment.startTime} - ${appointment.endTime}</td>
                            <td>${appointment.status}</td>
                            <td>
                                <a href="AddExaminationResult?appointmentId=${appointment.appointmentId}" class="action-button">Thêm kết quả</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <!-- Phân trang -->
            <div class="pagination">
                <c:if test="${currentPage > 1}">
                    <a href="ViewExaminationResults?page=${currentPage - 1}&pageSize=${pageSize}">« Previous</a>
                </c:if>
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <a href="ViewExaminationResults?page=${i}&pageSize=${pageSize}" class="${i == currentPage ? 'active' : ''}">${i}</a>
                </c:forEach>
                <c:if test="${currentPage < totalPages}">
                    <a href="ViewExaminationResults?page=${currentPage + 1}&pageSize=${pageSize}">Next »</a>
                </c:if>
            </div>
        </c:if>
    </c:if>
</body>
</html>
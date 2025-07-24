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
    </style>
</head>
<body>
    <h2>Examination Results for Doctor ID: ${doctorId}</h2>

    <!-- Hiển thị thông báo lỗi nếu có -->
    <c:if test="${not empty errorMessage}">
        <div class="error-box">
            <p class="error">Đã xảy ra lỗi</p>
            <p>${errorMessage}</p>
        </div>
        <a href="javascript:history.back()" class="back-button">Quay lại trang trước</a>
    </c:if>

    <c:if test="${empty errorMessage}">
        <c:if test="${empty appointments}">
            <p>No appointments found for Doctor ID: ${doctorId}</p>
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
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="appointment" items="${appointments}">
                        <tr>
                            <td>${appointment.appointmentId}</td>
                            <td>${appointment.patientName}</td>
                            
                            <td>${appointment.serviceName}</td>
                            <td>${appointment.roomName}</td>
                            <td><fmt:formatDate value="${appointment.slotDate}" pattern="yyyy-MM-dd"/></td>
                            <td>${appointment.startTime} - ${appointment.endTime}</td>
                            <td>${appointment.status}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <!-- Phân trang -->
            <div class="pagination">
                <c:if test="${currentPage > 1}">
                    <a href="ViewExaminationResults?doctorId=${doctorId}&page=${currentPage - 1}&pageSize=${pageSize}">« Previous</a>
                </c:if>
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <a href="ViewExaminationResults?doctorId=${doctorId}&page=${i}&pageSize=${pageSize}" class="${i == currentPage ? 'active' : ''}">${i}</a>
                </c:forEach>
                <a href="ViewExaminationResults?doctorId=${doctorId}&page=${currentPage + 1}&pageSize=${pageSize}">Next »</a>
            </div>
        </c:if>
    </c:if>
</body>
</html>
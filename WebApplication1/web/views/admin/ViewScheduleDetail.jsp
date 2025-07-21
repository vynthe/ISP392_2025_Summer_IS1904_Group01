<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi Tiết Lịch Khám</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f4f4f4;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h1 {
            color: #333;
            text-align: center;
        }
        .schedule-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .schedule-table th, .schedule-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        .schedule-table th {
            background-color: #2196F3;
            color: white;
        }
        .schedule-table tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        .back-link {
            display: block;
            margin-top: 20px;
            text-align: center;
            text-decoration: none;
            color: #2196F3;
            font-weight: bold;
        }
        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Chi Tiết Lịch Khám</h1>
        <c:if test="${not empty errorMessage}">
            <p style="color: red; text-align: center;">${errorMessage}</p>
        </c:if>
        <c:if test="${not empty schedules}">
            <table class="schedule-table">
                <thead>
                    <tr>
                        <th>Mã Lịch</th>
                        <th>Mã Bệnh Nhân</th>
                        <th>Họ Tên</th>
                        <th>Vai Trò</th>
                        <th>Mã Phòng Khám</th>
                        <th>Tên Phòng Khám</th>
                        <th>Ngày Khám</th>
                        <th>Giờ Bắt Đầu</th>
                        <th>Giờ Kết Thúc</th>
                        <th>Trạng Thái</th>
                        <th>Dịch Vụ</th>
                        <th>Người Tạo</th>
                        <th>Ngày Tạo</th>
                        <th>Ngày Cập Nhật</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="schedule" items="${schedules}">
                        <tr>
                            <td>${schedule.slotId}</td>
                            <td>${schedule.userId}</td>
                            <td>${schedule.fullName}</td>
                            <td>${schedule.role}</td>
                            <td>${schedule.roomId != null ? schedule.roomId : 'Chưa phân phòng'}</td>
                            <td>${schedule.roomName != null ? schedule.roomName : 'Chưa phân phòng'}</td>
                            <td>${schedule.slotDate != null ? schedule.slotDate.toString() : 'Chưa xác định'}</td>
                            <td>${schedule.startTime != null ? schedule.startTime.toString() : 'Chưa xác định'}</td>
                            <td>${schedule.endTime != null ? schedule.endTime.toString() : 'Chưa xác định'}</td>
                            <td>${schedule.status}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty schedule.serviceNames}">
                                        <c:forEach var="service" items="${schedule.serviceNames}" varStatus="loop">
                                            ${service}<c:if test="${!loop.last}">, </c:if>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>Chưa chọn dịch vụ</c:otherwise>
                                </c:choose>
                            </td>
                            <td>${schedule.createdBy}</td>
                            <td>${schedule.createdAt != null ? schedule.createdAt.toString() : 'Chưa xác định'}</td>
                            <td>${schedule.updatedAt != null ? schedule.updatedAt.toString() : 'Chưa xác định'}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>
        <a href="${pageContext.request.contextPath}/ViewSchedulesServlet" class="back-link">Quay lại danh sách lịch khám</a>
    </div>
</body>
</html>
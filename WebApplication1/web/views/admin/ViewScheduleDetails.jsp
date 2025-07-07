<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Làm Việc - ${employee.fullName}</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }
        
        .schedule-container {
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 20px;
        }
        
        .header {
            background: #4472C4;
            color: white;
            padding: 8px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 10px;
            min-height: 40px;
        }
        
        .header-controls {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .header select {
            padding: 4px;
            border: none;
            border-radius: 3px;
        }
        
        .header-label {
            font-weight: bold;
        }
        
        .header-buttons {
            display: flex;
            gap: 8px;
            align-items: center;
        }
        
        .btn {
            display: inline-block;
            padding: 8px 12px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            font-weight: bold;
            transition: background-color 0.3s;
            color: white;
            text-decoration: none;
            border: none;
        }
        
        .btn-success {
            background: #28a745;
        }
        
        .btn-success:hover {
            background: #218838;
        }
        
        .btn-warning {
            background: #fd7e14;
        }
        
        .btn-warning:hover {
            background: #e8680b;
        }
        
        .btn i {
            margin-right: 4px;
        }
        
        .schedule-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .day-header {
            background: #4472C4;
            color: white;
            padding: 8px;
            text-align: center;
            font-weight: bold;
            border: 1px solid #ddd;
        }
        
        .slot-cell {
            background: #E8F1FF;
            padding: 8px;
            text-align: center;
            font-weight: bold;
            border: 1px solid #ddd;
            width: 80px;
        }
        
        .schedule-cell {
            padding: 8px;
            border: 1px solid #ddd;
            vertical-align: top;
            position: relative;
        }
        
        .empty-cell {
            text-align: center;
            color: #999;
        }
        
        .event {
            background: #E8F1FF;
            border: 1px solid #4472C4;
            border-radius: 4px;
            padding: 4px;
            margin: 2px 0;
            font-size: 12px;
        }
        
        .event-room {
            color: #666;
        }
        
        .event-time {
            background: #90EE90;
            color: #000;
            padding: 2px 4px;
            border-radius: 2px;
            font-size: 10px;
            margin: 2px 0;
        }
        
        .event-status {
            font-size: 10px;
            margin: 2px 0;
        }
        
        .available {
            background: #90EE90;
            color: #000;
            padding: 1px 4px;
            border-radius: 2px;
        }
        
        .booked {
            background: #0984e3;
            color: white;
            padding: 1px 4px;
            border-radius: 2px;
        }
        
        .cancelled {
            background: #d63031;
            color: white;
            padding: 1px 4px;
            border-radius: 2px;
        }
        
        .completed {
            background: #6c5ce7;
            color: white;
            padding: 1px 4px;
            border-radius: 2px;
        }
        
        .action-buttons {
            display: flex;
            gap: 4px;
            margin-top: 4px;
            flex-wrap: wrap;
        }
        
        .action-btn {
            padding: 2px 6px;
            border-radius: 3px;
            font-size: 9px;
            cursor: pointer;
            border: none;
            font-weight: bold;
            transition: all 0.2s;
        }
        
        .btn-update {
            background: #007bff;
            color: white;
        }
        
        .btn-update:hover {
            background: #0056b3;
        }
        
        .btn-delete {
            background: #dc3545;
            color: white;
        }
        
        .btn-delete:hover {
            background: #c82333;
        }
        
        .no-schedule {
            text-align: center;
            padding: 20px;
            color: #666;
            font-size: 16px;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="schedule-container">
        <div class="header">
            <div class="header-controls">
                <form action="${pageContext.request.contextPath}/ViewScheduleDetailsServlet" method="get" style="display: flex; align-items: center; gap: 10px; margin: 0;">
                    <input type="hidden" name="userID" value="${employee.userID}">
                    <span class="header-label">NĂM</span>
                    <select name="year" onchange="this.form.submit()">
                        <c:forEach var="year" begin="2023" end="2026">
                            <option value="${year}" ${year == requestScope.year ? 'selected' : ''}>${year}</option>
                        </c:forEach>
                    </select>
                    
                    <span class="header-label">TUẦN</span>
                    <select name="week" onchange="this.form.submit()">
                        <c:forEach var="week" begin="1" end="52">
                            <option value="${week}" ${week == requestScope.week ? 'selected' : ''}>Tuần ${week}</option>
                        </c:forEach>
                    </select>
                </form>
            </div>
            <div class="header-buttons">
                <a href="${pageContext.request.contextPath}/ViewSchedulesServlet" class="btn btn-success">
                    <i class="fas fa-arrow-left"></i> Quay lại
                </a>
            </div>
        </div>

        <!-- Thông tin nhân viên -->
        <div style="padding: 10px; background: #f8f9fa; margin-bottom: 10px;">
            <h3 style="margin: 0; color: #2c3e50;">Lịch làm việc của ${employee.fullName}</h3>
            <p style="margin: 5px 0; color: #666;">
                Vai trò: 
                <c:choose>
                    <c:when test="${employee.role == 'doctor'}">Bác sĩ</c:when>
                    <c:when test="${employee.role == 'nurse'}">Y tá</c:when>
                    <c:when test="${employee.role == 'receptionist'}">Lễ tân</c:when>
                    <c:otherwise>${employee.role}</c:otherwise>
                </c:choose>
                | Chuyên khoa: ${employee.specialization != null ? employee.specialization : 'N/A'}
            </p>
        </div>

        <!-- Kiểm tra lịch làm việc -->
        <c:choose>
            <c:when test="${empty schedules}">
                <div class="no-schedule">Chưa có lịch làm việc</div>
            </c:when>
            <c:otherwise>
                <table class="schedule-table">
                    <thead>
                        <tr>
                            <th class="day-header" style="width: 80px;">CA</th>
                            <th class="day-header">THỨ 2<br><fmt:formatDate value="${weekStart}" pattern="dd/MM"/></th>
                            <th class="day-header">THỨ 3<br><fmt:formatDate value="${weekStart.plusDays(1)}" pattern="dd/MM"/></th>
                            <th class="day-header">THỨ 4<br><fmt:formatDate value="${weekStart.plusDays(2)}" pattern="dd/MM"/></th>
                            <th class="day-header">THỨ 5<br><fmt:formatDate value="${weekStart.plusDays(3)}" pattern="dd/MM"/></th>
                            <th class="day-header">THỨ 6<br><fmt:formatDate value="${weekStart.plusDays(4)}" pattern="dd/MM"/></th>
                            <th class="day-header">THỨ 7<br><fmt:formatDate value="${weekStart.plusDays(5)}" pattern="dd/MM"/></th>
                            <th class="day-header">CHỦ NHẬT<br><fmt:formatDate value="${weekStart.plusDays(6)}" pattern="dd/MM"/></th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="timeSlot" items="${timeSlots}" varStatus="slotLoop">
                            <tr>
                                <td class="slot-cell">${timeSlot.display}</td>
                                <c:forEach var="dayOffset" begin="0" end="6">
                                    <td class="schedule-cell">
                                        <c:set var="found" value="false"/>
                                        <c:forEach var="schedule" items="${schedules}">
                                            <c:if test="${schedule.slotDate == weekStart.plusDays(dayOffset) && schedule.startTime.toString() == timeSlot.startTime}">
                                                <c:set var="found" value="true"/>
                                                <div class="event" data-slot-id="${schedule.slotID}">
                                                    <div class="event-room">Phòng ${schedule.roomID} (${schedule.role})</div>
                                                    <div class="event-status">
                                                        <span class="${schedule.status.toLowerCase()}">${schedule.status}</span>
                                                    </div>
                                                    <div class="event-time">
                                                        (<fmt:formatDate value="${schedule.startTime}" pattern="HH:mm"/>-<fmt:formatDate value="${schedule.endTime}" pattern="HH:mm"/>)
                                                    </div>
                                                    <c:if test="${schedule.isAbsent}">
                                                        <div class="change-room">(${schedule.absenceReason != null ? schedule.absenceReason : 'Vắng mặt'})</div>
                                                    </c:if>
                                                    <div class="action-buttons">
                                                        <form action="${pageContext.request.contextPath}/admin/update-schedule" method="get" style="display: inline; margin: 0;">
                                                            <input type="hidden" name="slotID" value="${schedule.slotID}">
                                                            <button type="submit" class="action-btn btn-update">Cập nhật</button>
                                                        </form>
                                                        <form action="${pageContext.request.contextPath}/admin/delete-schedule" method="post" style="display: inline; margin: 0;" onsubmit="return confirm('Bạn có chắc chắn muốn xóa lịch làm việc này?')">
                                                            <input type="hidden" name="slotID" value="${schedule.slotID}">
                                                            <button type="submit" class="action-btn btn-delete">Xóa</button>
                                                        </form>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                        <c:if test="${!found}">
                                            <div class="empty-cell">-</div>
                                        </c:if>
                                    </td>
                                </c:forEach>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>

    <script>
        // Lấy thông tin từ URL parameters
        const urlParams = new URLSearchParams(window.location.search);
        const selectedYear = urlParams.get('year');
        const selectedWeek = urlParams.get('week');
        
        if (selectedYear) {
            console.log('Selected year:', selectedYear);
        }
        if (selectedWeek) {
            console.log('Selected week:', selectedWeek);
        }
    </script>
</body>
</html>
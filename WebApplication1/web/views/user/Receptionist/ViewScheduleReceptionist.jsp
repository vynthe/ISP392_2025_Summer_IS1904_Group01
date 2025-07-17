<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Làm Việc (Lễ Tân)</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f9fafb;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
        }
        .header {
            background-color: #9333ea;
            padding: 10px;
            border-radius: 8px;
            color: white;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .header select {
            padding: 5px;
            border: none;
            border-radius: 4px;
            background-color: #d8b4fe;
        }
        .schedule-list {
            background-color: white;
            border-radius: 8px;
            padding: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .schedule-item {
            padding: 10px;
            border-bottom: 1px solid #e5e7eb;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .schedule-details {
            font-size: 14px;
        }
        .room-info {
            color: #6b7280;
            font-weight: bold;
        }
        .status-tag {
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 12px;
        }
        .status-available { background-color: #a3e4a3; color: #145214; }
        .status-cancelled { background-color: #ff6b6b; color: white; }
        .time-info {
            color: #1e40af;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div>
                <label class="mr-2">Năm:</label>
                <select name="year" onchange="this.form.submit()">
                    <option value="2025" <c:if test="${param.year == '2025'}">selected</c:if>>2025</option>
                    <option value="2024" <c:if test="${param.year == '2024'}">selected</c:if>>2024</option>
                    <option value="2026" <c:if test="${param.year == '2026'}">selected</c:if>>2026</option>
                </select>
                <label class="ml-4 mr-2">Tuần:</label>
                <select name="week" onchange="this.form.submit()">
                    <c:forEach var="week" items="${weekOptions}">
                        <option value="${week.value}" <c:if test="${param.week == week.value}">selected</c:if>>${week.label}</option>
                    </c:forEach>
                </select>
            </div>
            <form method="get" action="ViewScheduleUserServlet">
                <input type="hidden" name="year" value="${param.year}">
                <input type="hidden" name="week" value="${param.week}">
            </form>
        </div>
        <div class="schedule-list">
            <c:forEach var="schedule" items="${scheduleDetails}">
                <div class="schedule-item">
                    <div class="schedule-details">
                        <div><fmt:formatDate value="${schedule.slotDate}" pattern="dd/MM/yyyy"/> - <span class="time-info">${schedule.startTime} - ${schedule.endTime}</span></div>
                        <div class="room-info">Phòng: ${schedule.roomName}</div>
                    </div>
                    <span class="status-tag status-${schedule.status.toLowerCase()}">${schedule.status}</span>
                </div>
            </c:forEach>
            <c:if test="${empty scheduleDetails}">
                <p class="text-center text-gray-500">Không có lịch làm việc trong tuần này.</p>
            </c:if>
        </div>
        <c:if test="${not empty error}">
            <p class="text-red-600 mt-4"><i class="fas fa-exclamation-circle"></i> ${error}</p>
        </c:if>
    </div>
</body>
</html>
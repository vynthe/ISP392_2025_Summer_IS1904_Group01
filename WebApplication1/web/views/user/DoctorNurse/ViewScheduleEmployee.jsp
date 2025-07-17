<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Làm Việc Tuần (Bác Sĩ/Y Tá)</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f3f4f6;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            background-color: #4b5563;
            padding: 10px;
            border-radius: 8px;
            color: white;
        }
        .header select {
            padding: 5px;
            border: none;
            border-radius: 4px;
            background-color: #e5e7eb;
        }
        .schedule-table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .schedule-table th {
            background-color: #3b82f6;
            color: white;
            padding: 12px;
            text-align: center;
        }
        .schedule-table td {
            padding: 10px;
            border: 1px solid #e5e7eb;
            vertical-align: top;
            min-height: 100px;
        }
        .day-header {
            background-color: #93c5fd;
            font-weight: bold;
        }
        .slot-cell {
            background-color: #dbeafe;
            font-weight: bold;
            width: 80px;
        }
        .schedule-item {
            margin-bottom: 8px;
            padding: 6px;
            border-left: 4px solid #10b981;
            background-color: #f3faf7;
            border-radius: 4px;
        }
        .employee-name {
            font-weight: bold;
            color: #10b981;
        }
        .room-info {
            color: #6b7280;
            font-size: 14px;
        }
        .status-available { background-color: #a3e4a3; color: #145214; }
        .status-cancelled { background-color: #ff6b6b; color: white; }
        .status-time { background-color: #93c5fd; color: #1e40af; }
        .status-tag, .time-tag {
            display: inline-block;
            padding: 2px 6px;
            border-radius: 4px;
            font-size: 12px;
            margin-top: 4px;
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
        <table class="schedule-table">
            <thead>
                <tr>
                    <th>Slot</th>
                    <c:forEach var="day" items="${daysOfWeek}">
                        <th class="day-header">${day.label}<br><fmt:formatDate value="${day.date}" pattern="dd/MM"/></th>
                    </c:forEach>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="slot" items="${slots}">
                    <tr>
                        <td class="slot-cell">${slot.name}</td>
                        <c:forEach var="day" items="${daysOfWeek}">
                            <td>
                                <c:forEach var="schedule" items="${scheduleDetails}">
                                    <c:if test="${schedule.slotDate == day.date && schedule.startTime.toString() == slot.startTime}">
                                        <div class="schedule-item">
                                            <span class="employee-name">${schedule.employeeName}</span>
                                            <div class="room-info">Phòng: ${schedule.roomName}</div>
                                            <span class="status-tag status-${schedule.status.toLowerCase()}">${schedule.status}</span>
                                            <span class="time-tag status-time">${schedule.startTime} - ${schedule.endTime}</span>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </td>
                        </c:forEach>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <c:if test="${not empty error}">
            <p class="text-red-600 mt-4"><i class="fas fa-exclamation-circle"></i> ${error}</p>
        </c:if>
    </div>
</body>
</html>
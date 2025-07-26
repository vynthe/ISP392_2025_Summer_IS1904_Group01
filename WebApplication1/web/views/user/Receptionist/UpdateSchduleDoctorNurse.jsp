<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Doctor/Nurse Schedule - Receptionist</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f4f4f4;
        }
        h1 {
            color: #333;
            text-align: center;
        }
        .schedule-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .schedule-table th, .schedule-table td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        .schedule-table th {
            background-color: #2196F3;
            color: white;
        }
        .schedule-table tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        .appointment-actions {
            display: flex;
            gap: 10px;
        }
        .appointment-actions form {
            display: inline-block;
            margin: 5px 0;
        }
        .appointment-actions label {
            font-size: 10px;
            color: #555;
            margin-right: 5px;
        }
        .appointment-actions input[type="date"],
        .appointment-actions input[type="time"] {
            font-size: 10px;
            padding: 2px 4px;
            border: 1px solid #ccc;
            border-radius: 4px;
            margin-right: 5px;
        }
        .appointment-actions button[type="submit"] {
            background-color: #2196F3;
            color: #fff;
            border: none;
            padding: 4px 8px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 10px;
        }
        .appointment-actions button[type="submit"]:hover {
            background-color: #1976d2;
        }
        .message {
            margin: 10px 0;
            padding: 10px;
            border-radius: 4px;
            text-align: center;
        }
        .success-message {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .no-schedules-message {
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeeba;
        }
    </style>
</head>
<body>
    <h1>Doctor/Nurse Schedule for User ID: ${userID}</h1>

    <!-- Display Messages -->
    <c:if test="${not empty successMessage}">
        <div class="message success-message">${successMessage}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="message error-message">${error}</div>
    </c:if>
    <c:if test="${not empty noSchedulesMessage}">
        <div class="message no-schedules-message">${noSchedulesMessage}</div>
    </c:if>

    <!-- Schedule Table -->
    <table class="schedule-table">
        <thead>
            <tr>
                <th>Slot ID</th>
                <th>User ID</th>
                <th>Role</th>
                <th>Room ID</th>
                <th>Date</th>
                <th>Start Time</th>
                <th>End Time</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${not empty schedules}">
                    <c:forEach var="schedule" items="${schedules}">
                        <tr>
                            <td>${schedule.slotId}</td>
                            <td>${schedule.userId}</td>
                            <td>${schedule.role}</td>
                            <td>${schedule.roomId != null ? schedule.roomId : 'N/A'}</td>
                            <td>${schedule.slotDate}</td>
                            <td>${schedule.startTime}</td>
                            <td>${schedule.endTime}</td>
                            <td>${schedule.status}</td>
                            <td class="appointment-actions">
                                <form action="${pageContext.request.contextPath}/UpdateScheduleDoctorNurse" method="post">
                                    <input type="hidden" name="slotId" value="${schedule.slotId}">
                                    <input type="hidden" name="userId" value="${schedule.userId}">
                                    <label for="newSlotDate">New Date:</label>
                                    <input type="date" name="newSlotDate" required>
                                    <label for="newStartTime">Start:</label>
                                    <input type="time" name="newStartTime" required>
                                    <label for="newEndTime">End:</label>
                                    <input type="time" name="newEndTime" required>
                                    <button type="submit">Update</button>
                                </form>
                                <form action="${pageContext.request.contextPath}/DeleteAppointmentServlet" method="post">
                                    <input type="hidden" name="slotId" value="${schedule.slotId}">
                                    <button type="submit" onclick="return confirm('Bạn có chắc muốn xóa lịch này?')">Delete</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="9">No schedules available.</td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>

    <!-- Back Button -->
    <div style="text-align: center; margin-top: 20px;">
        <a href="${pageContext.request.contextPath}/views/user/Receptionist/dashboard.jsp">
            <button>Back to Dashboard</button>
        </a>
    </div>
</body>
</html>
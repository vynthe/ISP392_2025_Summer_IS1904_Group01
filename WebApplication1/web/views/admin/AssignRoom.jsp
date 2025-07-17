<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gán phòng cho bác sĩ/y tá</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f7fa;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            padding: 20px;
        }
        .container {
            background-color: #ffffff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px;
        }
        h2 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            font-weight: bold;
            color: #34495e;
            margin-bottom: 5px;
        }
        input[type="number"], input[type="date"], select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-sizing: border-box;
            font-size: 14px;
        }
        input[readonly] {
            background-color: #f1f3f5;
            cursor: not-allowed;
        }
        button {
            width: 100%;
            padding: 12px;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        button:hover {
            background-color: #2980b9;
        }
        p {
            text-align: center;
            margin: 10px 0;
        }
        p.error {
            color: #e74c3c;
        }
        p.message {
            color: #2ecc71;
        }
        .user-info {
            text-align: center;
            margin-bottom: 20px;
            color: #7f8c8d;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Gán phòng cho lịch trình</h2>
        
        <c:if test="${not empty error}">
            <p class="error">${error}</p>
        </c:if>
        <c:if test="${not empty message}">
            <p class="message">${message}</p>
        </c:if>

        <c:if test="${not empty userName and not empty userRole}">
            <div class="user-info">
                <p>Tên: ${userName}</p>
                <p>Vai trò: ${userRole}</p>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/AssignDoctorNurseToRoom" method="post">
            <div class="form-group">
                <label for="userID">ID người dùng:</label>
                <input type="number" id="userID" name="userID" value="${selectedUserId}" required>
            </div>

            <div class="form-group">
                <label for="morningRoomId">Phòng cho slot sáng:</label>
                <select id="morningRoomId" name="morningRoomId">
                    <option value="">-- Không chọn --</option>
                    <c:forEach var="room" items="${availableRooms}">
                        <option value="${room.roomID}">${room.roomName} (${room.status})</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label for="afternoonRoomId">Phòng cho slot chiều:</label>
                <select id="afternoonRoomId" name="afternoonRoomId">
                    <option value="">-- Không chọn --</option>
                    <c:forEach var="room" items="${availableRooms}">
                        <option value="${room.roomID}">${room.roomName} (${room.status})</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label for="startDate">Ngày bắt đầu:</label>
                <input type="date" id="startDate" name="startDate" value="${startDate}" readonly>
            </div>

            <div class="form-group">
                <label for="endDate">Ngày kết thúc:</label>
                <input type="date" id="endDate" name="endDate" value="${endDate}" readonly>
            </div>

            <button type="submit">Gán phòng</button>
        </form>
    </div>
</body>
</html>
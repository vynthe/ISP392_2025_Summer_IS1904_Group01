<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Cập nhật Phòng</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 20px;
        }
        h2 {
            text-align: center;
            color: #333;
        }
        form {
            width: 500px;
            margin: auto;
            padding: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        label {
            display: block;
            margin-top: 10px;
            font-weight: bold;
        }
        input[type="text"],
        select {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .btn-group {
            margin-top: 20px;
            text-align: center;
        }
        .btn-group input[type="submit"],
        .btn-group a {
            padding: 10px 20px;
            background-color: #2a9d8f;
            color: white;
            text-decoration: none;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-right: 10px;
        }
        .btn-group a {
            background-color: #e76f51;
        }
        .error {
            color: red;
            text-align: center;
        }
    </style>
</head>
<body>
    <h2>Cập nhật thông tin Phòng</h2>

    <c:if test="${not empty error}">
        <div class="error">${error}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/UpdateRoomServlet" method="post">
        <input type="hidden" name="roomID" value="${room.roomID}" />

        <label for="roomName">Tên Phòng:</label>
        <input type="text" name="roomName" id="roomName" value="${room.roomName}" required />

        <label for="description">Mô tả:</label>
        <input type="text" name="description" id="description" value="${room.description}" />

        <label for="doctorID">Mã Bác sĩ:</label>
        <input type="text" name="doctorID" id="doctorID" value="${room.doctorID}" />

        <label for="nurseID">Mã Y tá:</label>
        <input type="text" name="nurseID" id="nurseID" value="${room.nurseID}" />

        <select name="status">
  <option value="Available">Available</option>
  <option value="Completed">Completed</option>
  <option value="In Progress">In Progress</option>
  <option value="Not Available">Not Available</option>
</select>

        <div class="btn-group">
            <input type="submit" value="Cập nhật" />
            <a href="${pageContext.request.contextPath}/ViewRoomServlet">Hủy</a>
        </div>
    </form>
</body>
</html>

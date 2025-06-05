<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thêm Phòng</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .error { color: red; font-weight: bold; }
        .success { color: green; }
        .form-group { margin-bottom: 15px; }
        label { display: inline-block; width: 100px; }
    </style>
</head>
<body>
    <h2>Thêm Phòng Mới</h2>
    <c:if test="${not empty error}">
        <p class="error">${error}</p>
    </c:if>
    <c:if test="${not empty successMessage}">
        <p class="success">${successMessage}</p>
    </c:if>
    <form action="${pageContext.request.contextPath}/AddRoomServlet" method="post">
        <input type="hidden" name="action" value="add">
        <div class="form-group">
            <label>Tên Phòng:</label>
            <input type="text" name="roomName" value="${roomName}" required>
        </div>
        <div class="form-group">
            <label>Mô Tả:</label>
            <textarea name="description">${description}</textarea>
        </div>
        <div class="form-group">
            <label>ID Bác Sĩ:</label>
            <input type="number" name="doctorID" value="${doctorID}" required>
        </div>
        <div class="form-group">
            <label>ID Y Tá:</label>
            <input type="number" name="nurseID" value="${nurseID}" required>
        </div>
        <div class="form-group">
            <label>Trạng Thái:</label>
            <select name="status">
                <option value="Available" ${status == 'Available' ? 'selected' : ''}>Có Sẵn</option>
                <option value="Not Available" ${status == 'Not Available' ? 'selected' : ''}>Không Có Sẵn</option>
                <option value="In Progress" ${status == 'In Progress' ? 'selected' : ''}>Đang Tiến Hành</option>
                <option value="Completed" ${status == 'Completed' ? 'selected' : ''}>Hoàn Thành</option>
            </select>
        </div>
        <div class="form-group">
            <input type="submit" value="Thêm Phòng">
            <a href="${pageContext.request.contextPath}/ViewRoomServlet">Hủy</a>
        </div>
    </form>
</body>
</html>
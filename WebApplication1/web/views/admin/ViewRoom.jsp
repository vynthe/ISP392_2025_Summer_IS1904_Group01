<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Room Management</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f4f4f4;
        }
        h2 {
            color: #333;
            text-align: center;
        }
        .search-container {
            margin-bottom: 20px;
            text-align: center;
        }
        .search-container input[type="text"] {
            padding: 8px;
            width: 200px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .search-container button {
            padding: 8px 15px;
            background-color: #f4a261;
            border: none;
            border-radius: 4px;
            color: white;
            cursor: pointer;
        }
        .search-container button:hover {
            background-color: #e07a5f;
        }
        .add-btn {
            display: inline-block;
            padding: 8px 15px;
            background-color: #f4a261;
            color: white;
            text-decoration: none;
            border-radius: 4px;
        }
        .add-btn:hover {
            background-color: #e07a5f;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f4a261;
            color: white;
        }
        td button {
            padding: 5px 10px;
            margin-right: 5px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        td button.view {
            background-color: #2a9d8f;
            color: white;
        }
        td button.edit {
            background-color: #264653;
            color: white;
        }
        td button.delete {
            background-color: #e76f51;
            color: white;
        }
        td button:hover {
            opacity: 0.8;
        }
    </style>
</head>
<body>
    <h2>Quản lý Phòng</h2>

    <!-- Khu vực tìm kiếm -->
    <form class="search-container" method="get" action="${pageContext.request.contextPath}/ViewRoomServlet">
    <input type="text" name="keyword" placeholder="Tìm theo tên phòng, mã phòng..." value="${param.keyword}">
    <button type="submit">Tìm</button>
    <a href="${pageContext.request.contextPath}/views/admin/AddRoom.jsp" class="add-btn">Thêm Phòng</a>
</form>


    <!-- Bảng danh sách phòng -->
    <table>
        <tr>
            <th>RoomID</th>
            <th>RoomName</th>
            <th>Description</th>
            <th>DoctorID</th>
            <th>NurseID</th>
            <th>Status</th>
            <th>CreateBy</th>
            
            

        </tr>
        <c:forEach var="room" items="${roomList}">
            <tr>
                <td>${room.roomID}</td>
                <td>${room.roomName}</td>
                <td>${room.description}</td>
                <td>${room.doctorID}</td>
                <td>${room.nurseID}</td>
                <td>${room.status}</td>
                <td>${room.createdBy}</td>
                
             <td>
    <a href="${pageContext.request.contextPath}/ViewRoomDetailServlet?id=${room.roomID}">Xem chi tiết</a>
    <a href="${pageContext.request.contextPath}/UpdateRoomServlet?id=${room.roomID}" class="edit" style="text-decoration: none;">Sửa</a>
    <a href="${pageContext.request.contextPath}/DeleteRoomServlet?id=${room.roomID}" 
   onclick="return confirm('Bạn có chắc chắn muốn xóa phòng này không?');" 
   class="delete" style="text-decoration: none;">
   Xóa
</a>

</td>
            </tr>
        </c:forEach>
    </table>
</body>
</html>
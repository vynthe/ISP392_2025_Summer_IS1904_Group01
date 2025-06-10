<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết Phòng</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f9f9f9;
        }
        h2, h3 {
            text-align: center;
            color: #333;
        }
        h3 {
            margin-top: 30px;
            margin-bottom: 15px;
        }
        .container {
            max-width: 700px;
            margin: auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 8px rgba(0,0,0,0.1);
        }
        .detail-row {
            margin-bottom: 12px;
            font-size: 16px;
        }
        .label {
            font-weight: bold;
            color: #555;
            width: 150px;
            display: inline-block;
        }
        .value {
            color: #000;
        }
        .error {
            color: red;
            text-align: center;
            margin-bottom: 15px;
        }
        .services-section {
            margin-top: 25px;
            border-top: 2px solid #e0e0e0;
            padding-top: 20px;
        }
        .services-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        .services-table th,
        .services-table td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }
        .services-table th {
            background-color: #2a9d8f;
            color: white;
            font-weight: bold;
        }
        .services-table tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        .services-table tr:hover {
            background-color: #f1f1f1;
        }
        .no-services {
            text-align: center;
            color: #666;
            font-style: italic;
            margin-top: 15px;
            padding: 20px;
            background-color: #f8f8f8;
            border-radius: 5px;
        }
        a.back-btn {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 15px;
            background-color: #2a9d8f;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        a.back-btn:hover {
            background-color: #21867a;
        }
        .service-price {
            font-weight: bold;
            color: #2a9d8f;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Chi tiết Phòng</h2>
    <c:if test="${not empty error}">
        <div class="error">${error}</div>
    </c:if>
    <c:if test="${not empty room}">
        <div class="detail-row">
            <span class="label">Mã phòng:</span>
            <span class="value">${room.roomID}</span>
        </div>
        <div class="detail-row">
            <span class="label">Tên phòng:</span>
            <span class="value">${room.roomName}</span>
        </div>
        <div class="detail-row">
            <span class="label">Mô tả:</span>
            <span class="value">${room.description}</span>
        </div>
        <div class="detail-row">
            <span class="label">Mã bác sĩ:</span>
            <span class="value">${room.doctorID}</span>
        </div>
        <div class="detail-row">
            <span class="label">Mã y tá:</span>
            <span class="value">${room.nurseID}</span>
        </div>
        <div class="detail-row">
            <span class="label">Trạng thái:</span>
            <span class="value">${room.status}</span>
        </div>
        <div class="detail-row">
            <span class="label">Người tạo:</span>
            <span class="value">${room.createdBy}</span>
        </div>
        <div class="detail-row">
            <span class="label">Ngày tạo:</span>
            <span class="value">${room.createdAt}</span>
        </div>
        <div class="detail-row">
            <span class="label">Ngày cập nhật:</span>
            <span class="value">${room.updatedAt}</span>
        </div>

        <!-- Phần hiển thị dịch vụ -->
        <div class="services-section">
            <h3>Dịch vụ của Phòng</h3>
            <c:choose>
                <c:when test="${not empty roomServices}">
                    <table class="services-table">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Mã dịch vụ</th>
                                <th>Tên dịch vụ</th>
                                <th>Mô tả</th>
                                <th>Giá (VNĐ)</th>
                                <th>Ngày thêm</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="service" items="${roomServices}" varStatus="status">
                                <tr>
                                    <td>${status.index + 1}</td>
                                    <td>${service.serviceID}</td>
                                    <td><strong>${service.serviceName}</strong></td>
                                    <td>${service.description}</td>
                                    <td class="service-price">
                                        <c:choose>
                                            <c:when test="${service.price != null}">
                                                ${String.format("%,.0f", service.price)}
                                            </c:when>
                                            <c:otherwise>
                                                Liên hệ
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${service.createdAt}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="no-services">
                        Phòng này chưa có dịch vụ nào được thêm.
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </c:if>
    <a href="${pageContext.request.contextPath}/ViewRoomServlet" class="back-btn">Quay lại danh sách phòng</a>
</div>
</body>
</html>
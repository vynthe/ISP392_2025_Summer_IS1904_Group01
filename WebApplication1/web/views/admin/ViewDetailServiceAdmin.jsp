<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.entity.Services" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết Dịch Vụ</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', Arial, sans-serif;
            }

            body {
                background: linear-gradient(135deg, #ede7f6, #d1c4e9);
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                padding: 20px;
            }

            .container {
                background: #ffffff;
                padding: 40px;
                border-radius: 15px;
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
                width: 100%;
                max-width: 1000px;
                display: flex;
                position: relative;
                overflow: hidden;
            }

            .container::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 5px;
                background: linear-gradient(to right, #7B1FA2, #AB47BC);
            }

            h2 {
                text-align: center;
                color: #2c3e50;
                margin-bottom: 30px;
                font-size: 28px;
                font-weight: 600;
                letter-spacing: 1px;
            }

            .illustration {
                position: absolute;
                top: 50%; /* Giữ giữa chiều cao */
                left: 30%; /* Điều chỉnh sang phải để tránh đè */
                transform: translate(-50%, -50%); /* Điều chỉnh chính xác vị trí */
                flex: 0 0 40%; /* Tăng kích thước khung */
                padding: 10px;
                text-align: center;
                z-index: 5; /* Đảm bảo ảnh nằm trên các phần khác */
            }

            .illustration img {
                max-width: 100%;
                max-height: 300px; /* Tăng kích thước ảnh */
                border-radius: 10px;
                object-fit: contain;
            }

            .details {
                flex: 1;
                padding: 20px;
                margin-left: 50%; /* Tăng khoảng cách để tránh đè */
            }

            .detail-group {
                display: flex;
                align-items: center;
                margin-bottom: 20px;
            }

            .detail-icon {
                flex: 0 0 50px;
                text-align: center;
                margin-right: 15px;
            }

            .detail-icon i {
                color: #7B1FA2;
                font-size: 24px;
            }

            .detail-content {
                flex: 1;
            }

            .detail-content label {
                display: block;
                font-weight: 500;
                margin-bottom: 8px;
                color: #34495e;
                font-size: 15px;
            }

            .detail-content .detail-value {
                width: 100%;
                padding: 12px 15px;
                border: 1px solid #dfe6e9;
                border-radius: 8px;
                font-size: 14px;
                background: #f9fafb;
                color: #555;
            }

            .detail-content .detail-value.multiline {
                min-height: 100px;
                resize: vertical;
            }

            .btn-primary, .btn-back {
                width: 100%;
                padding: 14px;
                background: linear-gradient(to right, #7B1FA2, #AB47BC);
                color: white;
                border: none;
                border-radius: 8px;
                font-size: 16px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s ease;
                text-transform: uppercase;
                letter-spacing: 1px;
                text-decoration: none;
                text-align: center;
                display: block;
                margin-bottom: 10px;
            }

            .btn-primary:hover, .btn-back:hover {
                background: linear-gradient(to right, #6A1B9A, #9C27B0);
                box-shadow: 0 5px 15px rgba(123, 31, 162, 0.3);
            }

            .error {
                background-color: #ffebee;
                color: #c62828;
                padding: 12px;
                border-radius: 8px;
                margin-bottom: 20px;
                text-align: center;
                font-size: 14px;
                border-left: 4px solid #c62828;
            }

            .home-button {
                position: absolute;
                top: 20px;
                left: 20px;
                width: auto;
                padding: 10px 20px;
                z-index: 10;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp" class="btn btn-primary home-button">Home</a>
            <div class="illustration">
                <c:choose>
                    <c:when test="${not empty requestScope.service}">
                        <c:choose>
                            <c:when test="${requestScope.service.serviceID == 3}">
                                <img src="https://images.pexels.com/photos/6627652/pexels-photo-6627652.jpeg?auto=compress&cs=tinysrgb&w=300" alt="Bọc răng Illustration">
                            </c:when>
                            <c:when test="${requestScope.service.serviceID == 4}">
                                <img src="https://images.pexels.com/photos/3942924/pexels-photo-3942924.jpeg?auto=compress&cs=tinysrgb&w=300" alt="Sửa hàm Illustration">
                            </c:when>
                            <c:when test="${requestScope.service.serviceID == 5}">
                                <img src="https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=300" alt="Sửa đầu Illustration">
                            </c:when>
                            <c:when test="${requestScope.service.serviceID == 6}">
                                <img src="https://images.pexels.com/photos/4065899/pexels-photo-4065899.jpeg?auto=compress&cs=tinysrgb&w=300" alt="Mắc cài Illustration">
                            </c:when>
                            <c:when test="${requestScope.service.serviceID == 7}">
                                <img src="https://images.pexels.com/photos/3996798/pexels-photo-3996798.jpeg?auto=compress&cs=tinysrgb&w=300" alt="Niềng răng Illustration">
                            </c:when>
                            <c:otherwise>
                                <img src="https://via.placeholder.com/300x400?text=Service+${requestScope.service.serviceID}" alt="Service Illustration">
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <img src="https://via.placeholder.com/300x400?text=No+Image+Available" alt="No Image Available">
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="details">
                <h2>Chi tiết Dịch Vụ</h2>
                <c:choose>
                    <c:when test="${not empty requestScope.service}">
                        <div class="detail-group">
                            <div class="detail-icon">
                                <i class="fas fa-id-badge"></i>
                            </div>
                            <div class="detail-content">
                                <label>ID:</label>
                                <div class="detail-value">${requestScope.service.serviceID}</div>
                            </div>
                        </div>
                        <div class="detail-group">
                            <div class="detail-icon">
                                <i class="fas fa-briefcase-medical"></i>
                            </div>
                            <div class="detail-content">
                                <label>Tên dịch vụ:</label>
                                <div class="detail-value">${requestScope.service.serviceName}</div>
                            </div>
                        </div>
                        <div class="detail-group">
                            <div class="detail-icon">
                                <i class="fas fa-align-left"></i>
                            </div>
                            <div class="detail-content">
                                <label>Mô tả:</label>
                                <div class="detail-value multiline">${requestScope.service.description}</div>
                            </div>
                        </div>
                        <div class="detail-group">
                            <div class="detail-icon">
                                <i class="fas fa-money-bill"></i>
                            </div>
                            <div class="detail-content">
                                <label>Giá (VNĐ):</label>
                                <div class="detail-value"><fmt:formatNumber value="${requestScope.service.price}" type="number" pattern="#,##0" /></div>
                            </div>
                        </div>
                        <div class="detail-group">
                            <div class="detail-icon">
                                <i class="fas fa-toggle-on"></i>
                            </div>
                            <div class="detail-content">
                                <label>Trạng thái:</label>
                                <div class="detail-value">${requestScope.service.status}</div>
                            </div>
                        </div>
                        <div class="detail-group">
                            <div class="detail-icon">
                                <i class="fas fa-calendar-plus"></i>
                            </div>
                            <div class="detail-content">
                                <label>Ngày tạo:</label>
                                <div class="detail-value"><fmt:formatDate value="${requestScope.service.createdAt}" pattern="dd/MM/yyyy" /></div>
                            </div>
                        </div>
                        <div class="detail-group">
                            <div class="detail-icon">
                                <i class="fas fa-calendar-check"></i>
                            </div>
                            <div class="detail-content">
                                <label>Ngày cập nhật:</label>
                                <div class="detail-value"><fmt:formatDate value="${requestScope.service.updatedAt}" pattern="dd/MM/yyyy" /></div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="error">Không tìm thấy thông tin dịch vụ!</div>
                    </c:otherwise>
                </c:choose>
                <div class="detail-group">
                    <a href="${pageContext.request.contextPath}/ViewServiceServlet" class="btn btn-back">Quay lại danh sách</a>
                </div>
            </div>
        </div>
    </body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Gán Dịch Vụ Cho Phòng</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .header {
            text-align: center;
            margin-bottom: 40px;
        }

        .header h2 {
            font-size: 2.5rem;
            font-weight: 700;
            background: linear-gradient(135deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 10px;
        }

        .header .subtitle {
            color: #6b7280;
            font-size: 1.1rem;
            font-weight: 400;
        }

        .room-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 14px;
            margin-bottom: 20px;
        }

        .message, .error {
            padding: 16px 20px;
            border-radius: 12px;
            margin-bottom: 24px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 500;
        }

        .message {
            background: linear-gradient(135deg, #d1fae5, #a7f3d0);
            border: 1px solid #6ee7b7;
            color: #065f46;
        }

        .message::before {
            content: "\f00c";
            font-family: "Font Awesome 6 Free";
            font-weight: 900;
        }

        .error {
            background: linear-gradient(135deg, #fef2f2, #fee2e2);
            border: 1px solid #fecaca;
            color: #dc2626;
        }

        .error::before {
            content: "\f071";
            font-family: "Font Awesome 6 Free";
            font-weight: 900;
        }

        .form-card {
            background: #ffffff;
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            border: 1px solid #e5e7eb;
            margin-bottom: 30px;
            position: relative;
            overflow: hidden;
        }

        .form-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, #667eea, #764ba2);
        }

        .form-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 25px;
        }

        .form-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 18px;
        }

        .form-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: #1f2937;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            font-weight: 600;
            color: #374151;
            margin-bottom: 8px;
            font-size: 14px;
        }

        select {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 500;
            color: #1f2937;
            background: #ffffff;
            transition: all 0.3s ease;
            appearance: none;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='m6 8 4 4 4-4'/%3e%3c/svg%3e");
            background-position: right 12px center;
            background-repeat: no-repeat;
            background-size: 16px;
            padding-right: 40px;
        }

        select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        select:hover {
            border-color: #d1d5db;
        }

        .submit-btn {
            width: 100%;
            padding: 16px 24px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            position: relative;
            overflow: hidden;
        }

        .submit-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.5s;
        }

        .submit-btn:hover::before {
            left: 100%;
        }

        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
        }

        .submit-btn:active {
            transform: translateY(0);
        }

        .services-list-card {
            background: #ffffff;
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            border: 1px solid #e5e7eb;
            position: relative;
            overflow: hidden;
        }

        .services-list-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, #10b981, #059669);
        }

        .services-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 25px;
        }

        .services-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #10b981, #059669);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 18px;
        }

        .services-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: #1f2937;
        }

        .services-list {
            list-style: none;
            margin: 0;
            padding: 0;
        }

        .service-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 16px 20px;
            margin-bottom: 10px;
            background: #f9fafb;
            border-radius: 12px;
            border: 1px solid #e5e7eb;
            transition: all 0.2s ease;
        }

        .service-item:hover {
            background: #f3f4f6;
            border-color: #d1d5db;
            transform: translateX(4px);
        }

        .service-item:last-child {
            margin-bottom: 0;
        }

        .service-name {
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 500;
            color: #1f2937;
        }

        .service-name::before {
            content: "\f0ad";
            font-family: "Font Awesome 6 Free";
            font-weight: 900;
            color: #10b981;
            font-size: 14px;
        }

        .service-price {
            font-weight: 600;
            color: #059669;
            background: #d1fae5;
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 13px;
        }

        .empty-state {
            text-align: center;
            color: #9ca3af;
            font-style: italic;
            padding: 30px 20px;
        }

        .empty-state i {
            font-size: 48px;
            margin-bottom: 16px;
            display: block;
            color: #d1d5db;
        }

        .loading {
            display: inline-block;
            width: 16px;
            height: 16px;
            border: 2px solid #ffffff;
            border-radius: 50%;
            border-top-color: transparent;
            animation: spin 0.8s ease-in-out infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .fade-in {
            animation: fadeIn 0.6s ease-out;
        }

        @media (max-width: 768px) {
            .container {
                margin: 10px;
                padding: 24px;
                border-radius: 16px;
            }

            .header h2 {
                font-size: 2rem;
            }

            .form-card, .services-list-card {
                padding: 24px;
            }

            .form-header, .services-header {
                flex-direction: column;
                text-align: center;
                gap: 8px;
            }

            .service-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 8px;
            }

            .service-price {
                align-self: flex-end;
            }
        }

        @media (max-width: 480px) {
            body {
                padding: 10px;
            }

            .container {
                padding: 20px;
            }

            .header h2 {
                font-size: 1.75rem;
            }
        }
    </style>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.querySelector('form');
            const submitBtn = document.querySelector('.submit-btn');
            const originalText = submitBtn.innerHTML;

            form.addEventListener('submit', function(e) {
                submitBtn.innerHTML = '<span class="loading"></span> Đang thêm dịch vụ...';
                submitBtn.disabled = true;
            });

            // Add fade-in animation to cards
            const cards = document.querySelectorAll('.form-card, .services-list-card');
            cards.forEach((card, index) => {
                card.style.animationDelay = `${index * 0.1}s`;
                card.classList.add('fade-in');
            });
        });
    </script>
</head>
<body>
<div class="container">
                            <div style="margin-bottom: 20px; font-size: 14px; color: #6b7280;">
    <a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp" style="text-decoration: none; color: #3b82f6;">
        <i class="fas fa-home"></i> Dashboard
    </a>
    <span style="margin: 0 8px;">&gt;</span>
    <a href="${pageContext.request.contextPath}/ViewRoomServlet" style="text-decoration: none; color: #4b5563;">
        Quản lý Phòng
    </a>
    <span style="margin: 0 8px;">&gt;</span>
    <span style="color: #111827;">thêm dịch vụ</span>
</div>
    <div class="header">
        <h2><i class="fas fa-plus-circle"></i> Gán Dịch Vụ Cho Phòng</h2>
        <p class="subtitle">Thêm và quản lý dịch vụ cho phòng khám</p>
        <div class="room-badge">
            <i class="fas fa-door-open"></i>
            Phòng #${roomId}
        </div>
    </div>

    <c:if test="${not empty param.message && param.error == 'true'}">
        <div class="error">${param.message}</div>
    </c:if>
    <c:if test="${not empty param.message && param.error != 'true'}">
        <div class="message">${param.message}</div>
    </c:if>

    <div class="form-card">
        <div class="form-header">
            <div class="form-icon">
                <i class="fas fa-plus"></i>
            </div>
            <h3 class="form-title">Thêm Dịch Vụ Mới</h3>
        </div>

        <form action="AssignServiceToRoomServlet" method="post">
            <input type="hidden" name="roomId" value="${roomId}"/>
            <div class="form-group">
                <label for="serviceId">
                    <i class="fas fa-list-ul"></i> Chọn Dịch Vụ:
                </label>
                <select name="serviceId" id="serviceId" required>
                    <option value="">-- Chọn dịch vụ để thêm --</option>
                    <c:forEach var="service" items="${availableServices}">
                        <option value="${service.serviceID}">
                            ${service.serviceName} - ${service.price} VND
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <button type="submit" class="submit-btn">
                    <i class="fas fa-plus-circle"></i>
                    Thêm Dịch Vụ
                </button>
            </div>
        </form>
    </div>

    <div class="services-list-card">
        <div class="services-header">
            <div class="services-icon">
                <i class="fas fa-check-circle"></i>
            </div>
            <h3 class="services-title">Dịch Vụ Đã Gán</h3>
        </div>

        <ul class="services-list">
            <c:choose>
                <c:when test="${not empty assignedServices}">
                    <c:forEach var="s" items="${assignedServices}">
                        <li class="service-item">
                            <span class="service-name">${s.serviceName}</span>
                            <span class="service-price">${s.price} VND</span>
                        </li>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <li class="empty-state">
                        <i class="fas fa-inbox"></i>
                        <div>Chưa có dịch vụ nào được gán cho phòng này</div>
                        <small>Sử dụng form bên trên để thêm dịch vụ</small>
                    </li>
                </c:otherwise>
            </c:choose>
        </ul>
    </div>

<a href="${pageContext.request.contextPath}/ViewRoomServlet" style="
    display: inline-flex;
    align-items: center;
    gap: 10px;
    margin-top: 30px;
    padding: 14px 28px;
    font-size: 16px;
    font-weight: 600;
    border-radius: 12px;
    text-decoration: none;
    background: linear-gradient(135deg, #e0e7ff, #c7d2fe);
    color: #3730a3;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
    transition: all 0.3s ease;
">
    <i class="fas fa-arrow-left"></i> Quay lại danh sách phòng
</a>

<style>
    a.back-hover:hover {
        background: linear-gradient(135deg, #c7d2fe, #a5b4fc);
        color: #1e3a8a;
        transform: translateY(-2px);
        box-shadow: 0 8px 18px rgba(102, 126, 234, 0.3);
    }
</style>

</div>
</body>
</html>
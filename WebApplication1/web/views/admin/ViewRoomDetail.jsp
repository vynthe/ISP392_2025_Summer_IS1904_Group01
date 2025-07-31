<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết phòng</title>
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
            background: linear-gradient(135deg, #f0f4ff 0%, #e2e8f0 100%);
            min-height: 100vh;
            padding: 30px;
            line-height: 1.7;
            color: #1f2937;
        }
        .container {
            max-width: 960px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.98);
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
        .header h1 {
            font-size: 2.75rem;
            font-weight: 700;
            background: linear-gradient(135deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 12px;
        }
        .header .subtitle {
            color: #6b7280;
            font-size: 1.2rem;
            font-weight: 400;
        }
        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1rem;
            color: #6b7280;
            margin-bottom: 20px;
        }
        .breadcrumb a {
            color: #3b82f6;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s ease;
        }
        .breadcrumb a:hover {
            color: #1d4ed8;
            text-decoration: underline;
        }
        .breadcrumb span {
            color: #111827;
        }
        .error {
            background: linear-gradient(135deg, #fef2f2, #fee2e2);
            border: 1px solid #fecaca;
            color: #dc2626;
            padding: 16px 20px;
            border-radius: 12px;
            margin-bottom: 24px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .error::before {
            content: "\f071";
            font-family: "Font Awesome 6 Free";
            font-weight: 900;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 24px;
            margin-bottom: 30px;
        }
        .info-card {
            background: #ffffff;
            border-radius: 16px;
            padding: 24px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            border: 1px solid #e5e7eb;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        .info-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, #667eea, #764ba2);
        }
        .info-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.15);
        }
        .card-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 20px;
        }
        .card-icon {
            width: 48px;
            height: 48px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 20px;
        }
        .card-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: #1f2937;
        }
        .info-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #f3f4f6;
            transition: background-color 0.2s ease;
        }
        .info-item:last-child {
            border-bottom: none;
        }
        .info-item:hover {
            background-color: #f9fafb;
            margin: 0 -12px;
            padding: 12px;
            border-radius: 8px;
        }
        .info-label {
            font-weight: 500;
            color: #6b7280;
            font-size: 15px;
        }
        .info-value {
            font-weight: 500;
            color: #1f2937;
            font-size: 15px;
        }
        .status-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .status-available {
            background: linear-gradient(135deg, #d1fae5, #a7f3d0);
            color: #065f46;
            border: 1px solid #6ee7b7;
        }
        .status-completed {
            background: linear-gradient(135deg, #dbeafe, #bfdbfe);
            color: #1e40af;
            border: 1px solid #93c5fd;
        }
        .status-unavailable {
            background: linear-gradient(135deg, #fee2e2, #fecaca);
            color: #dc2626;
            border: 1px solid #f87171;
        }
        .status-progress {
            background: linear-gradient(135deg, #fef3c7, #fde68a);
            color: #d97706;
            border: 1px solid #fbbf24;
        }
        .status-unknown {
            background: linear-gradient(135deg, #f3f4f6, #e5e7eb);
            color: #6b7280;
            border: 1px solid #d1d5db;
        }
        .list {
            list-style: none;
            margin: 0;
            padding: 0;
        }
        .list-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 16px;
            margin-bottom: 8px;
            background: #f9fafb;
            border-radius: 10px;
            border: 1px solid #e5e7eb;
            transition: all 0.2s ease;
        }
        .list-item:hover {
            background: #f3f4f6;
            border-color: #d1d5db;
        }
        .list-item::before {
            content: "\f0ad";
            font-family: "Font Awesome 6 Free";
            font-weight: 900;
            color: #667eea;
            font-size: 16px;
        }
        .empty-state {
            text-align: center;
            color: #9ca3af;
            font-style: italic;
            padding: 24px;
            font-size: 1.1rem;
        }
        .empty-state i {
            font-size: 32px;
            margin-bottom: 12px;
            display: block;
            opacity: 0.5;
        }
        .service-buttons {
            margin-top: 24px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 16px;
        }
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 12px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.5s;
        }
        .btn:hover::before {
            left: 100%;
        }
        .service-btn {
            background: linear-gradient(135deg, #10b981, #059669);
            color: #fff;
            border: 2px solid transparent;
        }
        .service-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(16, 185, 129, 0.4);
        }
        .back-btn {
            background: linear-gradient(135deg, #6b7280, #4b5563);
            color: #fff;
            margin-top: 40px;
            width: fit-content;
            margin-left: auto;
            margin-right: auto;
            display: flex;
        }
        .back-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(107, 114, 128, 0.4);
        }
        .loading {
            display: inline-block;
            width: 18px;
            height: 18px;
            border: 3px solid #ffffff;
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
                margin: 15px;
                padding: 24px;
                border-radius: 16px;
            }
            .header h1 {
                font-size: 2.25rem;
            }
            .info-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }
            .service-buttons {
                grid-template-columns: 1fr;
            }
            .card-header {
                flex-direction: column;
                text-align: center;
                gap: 10px;
            }
        }
        @media (max-width: 480px) {
            body {
                padding: 15px;
            }
            .container {
                padding: 20px;
            }
            .header h1 {
                font-size: 1.75rem;
            }
            .header .subtitle {
                font-size: 1rem;
            }
            .info-card {
                padding: 20px;
            }
            .info-label, .info-value {
                font-size: 14px;
            }
        }
    </style>
    <script>
        function addService(serviceName) {
            const roomID = document.querySelector('input[name="roomID"]').value;
            const button = event.target;
            const originalText = button.innerHTML;
            button.innerHTML = '<span class="loading"></span> Đang thêm...';
            button.disabled = true;
            const xhr = new XMLHttpRequest();
            xhr.open("POST", "${pageContext.request.contextPath}/AddServiceServlet", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200) {
                        const response = JSON.parse(xhr.responseText);
                        if (response.success) {
                            const serviceList = document.getElementById("service-list");
                            const emptyState = serviceList.querySelector('.empty-state');
                            if (emptyState) {
                                emptyState.remove();
                            }
                            const newService = document.createElement("li");
                            newService.className = "list-item fade-in";
                            newService.textContent = serviceName;
                            serviceList.appendChild(newService);
                            button.style.background = 'linear-gradient(135deg, #10b981, #059669)';
                            button.innerHTML = '<i class="fas fa-check"></i> Đã thêm';
                            setTimeout(() => {
                                button.innerHTML = originalText;
                                button.style.background = '';
                                button.disabled = false;
                            }, 2000);
                        } else {
                            alert("Lỗi khi thêm dịch vụ: " + response.error);
                            button.innerHTML = originalText;
                            button.disabled = false;
                        }
                    } else {
                        alert("Có lỗi xảy ra khi kết nối với server");
                        button.innerHTML = originalText;
                        button.disabled = false;
                    }
                }
            };
            const data = "roomID=" + encodeURIComponent(roomID) + "&service=" + encodeURIComponent(serviceName);
            xhr.send(data);
        }

        document.addEventListener('DOMContentLoaded', function() {
            const elements = document.querySelectorAll('.info-card, .list-item');
            elements.forEach((el, index) => {
                el.style.animationDelay = `${index * 0.1}s`;
                el.classList.add('fade-in');
            });

            // Ensure accessibility for keyboard navigation
            document.querySelectorAll('.btn').forEach(btn => {
                btn.addEventListener('keypress', function(e) {
                    if (e.key === 'Enter' || e.key === ' ') {
                        e.preventDefault();
                        this.click();
                    }
                });
            });
        });
    </script>
</head>
<body>
    <div class="container">
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp">
                <i class="fas fa-home"></i> Trang Chủ
            </a>
            <span>></span>
            <a href="${pageContext.request.contextPath}/ViewRoomServlet">Quản lý Phòng</a>
            <span>></span>
            <span>Xem chi tiết</span>
        </div>
        <div class="header">
            <h1><i class="fas fa-door-open"></i> Chi tiết phòng</h1>
            <p class="subtitle">Thông tin chi tiết và quản lý phòng khám</p>
        </div>
        <c:if test="${not empty error}">
            <div class="error" role="alert">${error}</div>
        </c:if>
        <c:if test="${not empty room}">
            <div class="info-grid">
                <div class="info-card">
                    <div class="card-header">
                        <div class="card-icon">
                            <i class="fas fa-info-circle"></i>
                        </div>
                        <h3 class="card-title">Thông tin phòng</h3>
                    </div>
                    <div class="info-item">
                        <span class="info-label">ID phòng:</span>
                        <span class="info-value">${room.roomID}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Tên phòng:</span>
                        <span class="info-value">${room.roomName}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Mô tả:</span>
                        <span class="info-value">
                            <c:out value="${empty room.description ? 'Không có mô tả' : room.description}"/>
                        </span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Trạng thái:</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${room.status == 'Available'}">
                                    <span class="status-badge status-available">Còn Phòng</span>
                                </c:when>
                                <c:when test="${room.status == 'Completed'}">
                                    <span class="status-badge status-completed">Hoàn Thành</span>
                                </c:when>
                                <c:when test="${room.status == 'Not Available'}">
                                    <span class="status-badge status-unavailable">Hết Phòng</span>
                                </c:when>
                                <c:when test="${room.status == 'In Progress'}">
                                    <span class="status-badge status-progress">Đang Khám</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-badge status-unknown">Không xác định</span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>
                <div class="info-card">
                    <div class="card-header">
                        <div class="card-icon">
                            <i class="fas fa-cogs"></i>
                        </div>
                        <h3 class="card-title">Dịch vụ</h3>
                    </div>
                    <ul class="list" id="service-list">
                        <c:choose>
                            <c:when test="${not empty serviceNames}">
                                <c:forEach var="serviceName" items="${serviceNames}">
                                    <li class="list-item">${serviceName}</li>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <li class="empty-state">
                                    <i class="fas fa-tools"></i>
                                    Chưa có dịch vụ nào được thêm
                                </li>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                    <c:if test="${isAdmin}">
                        <div class="service-buttons">
                            <input type="hidden" name="roomID" value="${room.roomID}">
                            <button class="btn service-btn" onclick="addService('Chụp X-quang răng')">Chụp X-quang răng</button>
                            <button class="btn service-btn" onclick="addService('Khám răng chi tiết')">Khám răng chi tiết</button>
                            <button class="btn service-btn" onclick="addService('Nhổ răng')">Nhổ răng</button>
                            <button class="btn service-btn" onclick="addService('Cạo vôi răng')">Cạo vôi răng</button>
                        </div>
                    </c:if>
                </div>
            </div>
        </c:if>
        <a href="${pageContext.request.contextPath}/ViewRoomServlet" class="btn back-btn">
            <i class="fas fa-arrow-left"></i> Quay lại danh sách phòng
        </a>
    </div>
             <div style="height: 200px;"></div>
    <jsp:include page="/assets/footer.jsp" />
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 900px;
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

        .header h1 {
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

        .card-title {
            font-size: 1.25rem;
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
            font-size: 14px;
        }

        .info-value {
            font-weight: 500;
            color: #1f2937;
            font-size: 14px;
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
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
            content: "\f007";
            font-family: "Font Awesome 6 Free";
            font-weight: 900;
            color: #667eea;
            font-size: 14px;
        }

        .service-item::before {
            content: "\f0ad";
        }

        .empty-state {
            text-align: center;
            color: #9ca3af;
            font-style: italic;
            padding: 20px;
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
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
            transition: left 0.5s ease;
        }

        .btn:hover::before {
            left: 100%;
        }

        .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
        }

        .btn:active {
            transform: translateY(0);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .edit-room-btn {
            background: linear-gradient(135deg, #f59e0b, #d97706);
            color: #fff;
        }

        .edit-room-btn:hover {
            background: linear-gradient(135deg, #fbbf24, #f59e0b);
        }

        .delete-room-btn {
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: #fff;
        }

        .delete-room-btn:hover {
            background: linear-gradient(135deg, #f87171, #ef4444);
        }

        .service-btn {
            background: linear-gradient(135deg, #10b981, #059669);
            color: #fff;
            margin-top: 20px;
            width: fit-content;
        }

        .service-btn:hover {
            background: linear-gradient(135deg, #34d399, #10b981);
        }

        .back-btn {
            background: linear-gradient(135deg, #6b7280, #4b5563);
            color: #fff;
            margin-top: 30px;
            width: fit-content;
            margin-left: auto;
            margin-right: auto;
            display: flex;
        }

        .back-btn:hover {
            background: linear-gradient(135deg, #9ca3af, #6b7280);
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(107, 114, 128, 0.4);
        }

        .room-actions {
            display: flex;
            gap: 16px;
            justify-content: center;
            margin-bottom: 30px;
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

            .header h1 {
                font-size: 2rem;
            }

            .info-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .room-actions {
                flex-direction: column;
                gap: 12px;
            }
        }

        @media (max-width: 480px) {
            body {
                padding: 10px;
            }

            .container {
                padding: 20px;
            }

            .header h1 {
                font-size: 1.75rem;
            }

            .info-card {
                padding: 20px;
            }

            .btn {
                padding: 10px 18px;
                font-size: 14px;
            }
        }
    </style>
    <script>
        // Add fade-in animation to elements on page load
        document.addEventListener('DOMContentLoaded', function() {
            const elements = document.querySelectorAll('.info-card');
            elements.forEach((el, index) => {
                el.style.animationDelay = `${index * 0.1}s`;
                el.classList.add('fade-in');
            });
        });
    </script>
</head>
<body>
<div class="container">
    <div class="header">
        <h1><i class="fas fa-door-open"></i> Chi tiết phòng</h1>
        <p class="subtitle">Thông tin chi tiết và quản lý phòng khám</p>
    </div>

    <div class="room-actions">
        <a href="${pageContext.request.contextPath}/UpdateRoomServlet?id=${room.roomID}" 
           class="btn edit-room-btn" 
           title="Chỉnh sửa thông tin phòng">
            <i class="fas fa-edit"></i> Sửa phòng
        </a>
        <a href="${pageContext.request.contextPath}/DeleteRoomServlet?id=${room.roomID}" 
           class="btn delete-room-btn" 
           title="Xóa phòng" 
           onclick="return confirm('Bạn có chắc muốn xóa phòng ${room.roomName}?')">
            <i class="fas fa-trash"></i> Xóa phòng
        </a>
    </div>

    <c:if test="${not empty error}">
        <div class="error">${error}</div>
    </c:if>

    <c:if test="${not empty room}">
        <input type="hidden" name="roomID" value="${room.roomID}">
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
                    <span class="info-value">${empty room.description ? 'Không có mô tả' : room.description}</span>
                </div>
                
                <div class="info-item">
                    <span class="info-label">Trạng thái:</span>
                    <span class="info-value">
                        <c:choose>
                            <c:when test="${room.status == 'Available'}">
                                <span class="status-badge status-available">Còn Phòng</span>
                            </c:when>
                            <c:when test="${room.status == 'completed'}">
                                <span class="status-badge status-completed">Hoàn Thành</span>
                            </c:when>
                            <c:when test="${room.status == 'Not available'}">
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
                        <i class="fas fa-user-md"></i>
                    </div>
                    <h3 class="card-title">Nhân sự</h3>
                </div>
                
                <div class="info-item">
                    <span class="info-label">Bác sĩ:</span>
                    <span class="info-value">${empty doctorName ? 'Chưa phân công' : doctorName}</span>
                </div>
                
                <div class="info-item">
                    <span class="info-label">Y tá:</span>
                    <span class="info-value">${empty nurseName ? 'Chưa phân công' : nurseName}</span>
                </div>
            </div>
        </div>

        <div class="info-grid">
            <div class="info-card">
                <div class="card-header">
                    <div class="card-icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <h3 class="card-title">Bệnh nhân</h3>
                </div>
                
                <ul class="list" id="patient-list">
                    <c:choose>
                        <c:when test="${not empty patients}">
                            <c:forEach var="patient" items="${patients}">
                                <li class="list-item">${patient}</li>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <li class="empty-state">
                                <i class="fas fa-user-slash" style="font-size: 24px; margin-bottom: 8px; display: block;"></i>
                                Không có bệnh nhân
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
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
                        <c:when test="${not empty services}">
                            <c:forEach var="service" items="${services}">
                                <li class="list-item service-item">${service}</li>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <li class="empty-state">
                                <i class="fas fa-tools" style="font-size: 24px; margin-bottom: 8px; display: block;"></i>
                                Không có dịch vụ
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
                
                <a href="${pageContext.request.contextPath}/AssignServiceToRoomServlet?roomId=${room.roomID}" 
                   class="btn service-btn" 
                   title="Quản lý dịch vụ phòng">
                    <i class="fas fa-plus-circle"></i> Thêm dịch vụ
                </a>
            </div>
        </div>
    </c:if>

    <a href="${pageContext.request.contextPath}/ViewRoomServlet" class="btn back-btn">
        <i class="fas fa-arrow-left"></i> Quay lại danh sách phòng
    </a>
</div>
</body>
</html>

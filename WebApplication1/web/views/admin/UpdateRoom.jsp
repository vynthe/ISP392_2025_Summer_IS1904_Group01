<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cập nhật Phòng - Hệ thống Quản lý</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
            line-height: 1.6;
        }

        .container {
            max-width: 700px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            position: relative;
            overflow: hidden;
        }

        .container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2);
        }

        .header {
            text-align: center;
            margin-bottom: 40px;
        }

        .header h1 {
            color: #2d3748;
            font-size: 2.2rem;
            font-weight: 700;
            margin-bottom: 8px;
            letter-spacing: -0.5px;
        }

        .header p {
            color: #718096;
            font-size: 1.1rem;
            font-weight: 400;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
            margin-bottom: 32px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-label {
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 8px;
            font-size: 0.95rem;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .form-input,
        .form-select {
            padding: 14px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: #fff;
            color: #2d3748;
            font-family: inherit;
        }

        .form-input:focus,
        .form-select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            transform: translateY(-1px);
        }

        .form-input:hover,
        .form-select:hover {
            border-color: #cbd5e0;
        }

        .status-select {
            position: relative;
        }

        .status-select::after {
            content: '\f107';
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #718096;
            pointer-events: none;
        }

        .form-select {
            appearance: none;
            cursor: pointer;
            padding-right: 50px;
        }

        .btn-group {
            display: flex;
            gap: 16px;
            justify-content: center;
            margin-top: 40px;
        }

        .btn {
            padding: 14px 32px;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            min-width: 140px;
            justify-content: center;
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
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }

        .btn:hover::before {
            left: 100%;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }

        .btn-secondary {
            background: #f7fafc;
            color: #4a5568;
            border: 2px solid #e2e8f0;
        }

        .btn-secondary:hover {
            background: #edf2f7;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .error-message {
            background: linear-gradient(135deg, #fed7d7 0%, #feb2b2 100%);
            color: #c53030;
            padding: 16px 20px;
            border-radius: 12px;
            margin-bottom: 24px;
            border: 1px solid #fc8181;
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 500;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            margin-left: 8px;
        }

        .status-available { background: #c6f6d5; color: #276749; }
        .status-completed { background: #bee3f8; color: #2c5282; }
        .status-progress { background: #fef5e7; color: #c05621; }
        .status-unavailable { background: #fed7d7; color: #c53030; }

        .form-icon {
            color: #667eea;
            font-size: 1.1rem;
        }

        @media (max-width: 768px) {
            .container {
                padding: 24px;
                margin: 10px;
                border-radius: 16px;
            }

            .header h1 {
                font-size: 1.8rem;
            }

            .form-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .btn-group {
                flex-direction: column;
                gap: 12px;
            }

            .btn {
                width: 100%;
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
                font-size: 1.6rem;
            }
        }

        /* Animation */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .container {
            animation: fadeInUp 0.6s ease-out;
        }

        .form-group {
            animation: fadeInUp 0.6s ease-out;
            animation-fill-mode: both;
        }

        .form-group:nth-child(1) { animation-delay: 0.1s; }
        .form-group:nth-child(2) { animation-delay: 0.2s; }
        .form-group:nth-child(3) { animation-delay: 0.3s; }
        .form-group:nth-child(4) { animation-delay: 0.4s; }
        .form-group:nth-child(5) { animation-delay: 0.5s; }
        .form-group:nth-child(6) { animation-delay: 0.6s; }
    </style>
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
    <span style="color: #111827;">Sửa phòng</span>
</div>
        <div class="header">
            <h1><i class="fas fa-edit"></i> Cập nhật Phòng</h1>
            <p>Chỉnh sửa thông tin chi tiết của phòng khám</p>
        </div>

        <c:if test="${not empty error}">
            <div class="error-message">
                <i class="fas fa-exclamation-triangle"></i>
                ${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/UpdateRoomServlet" method="post">
            <input type="hidden" name="roomID" value="${room.roomID}" />

            <div class="form-grid">
                <div class="form-group full-width">
                    <label for="roomName" class="form-label">
                        <i class="fas fa-door-open form-icon"></i>
                        Tên Phòng
                    </label>
                    <input type="text" id="roomName" name="roomName" value="${room.roomName}" 
                           class="form-input" required placeholder="Nhập tên phòng...">
                </div>

                <div class="form-group full-width">
                    <label for="description" class="form-label">
                        <i class="fas fa-align-left form-icon"></i>
                        Mô Tả
                    </label>
                    <input type="text" id="description" name="description" value="${room.description}" 
                           class="form-input" placeholder="Mô tả chi tiết về phòng...">
                </div>

               <div class="form-group full-width">
                    <label for="status" class="form-label">
                        <i class="fas fa-info-circle form-icon"></i>
                        Trạng Thái
                        <span class="status-badge status-${room.status == 'Available' ? 'available' : room.status == 'Completed' ? 'completed' : room.status == 'In Progress' ? 'progress' : 'unavailable'}">
                            <i class="fas fa-circle"></i>
                            ${room.status == 'Available' ? 'Còn Phòng' : room.status == 'Completed' ? 'Hoàn Thành' : room.status == 'In Progress' ? 'Đang Khám' : 'Hết Phòng'}
                        </span>
                    </label>
                    <div class="status-select">
                        <select name="status" id="status" class="form-select">
                            <option value="Available" ${room.status == 'Available' ? 'selected' : ''}>
                                🟢 Còn Phòng
                            </option>
                            <option value="Completed" ${room.status == 'Completed' ? 'selected' : ''}>
                                🔵 Hoàn Thành
                            </option>
                            <option value="In Progress" ${room.status == 'In Progress' ? 'selected' : ''}>
                                🟡 Đang Khám
                            </option>
                            <option value="Not Available" ${room.status == 'Not Available' ? 'selected' : ''}>
                                🔴 Hết Phòng
                            </option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="btn-group">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i>
                    Cập Nhật
                </button>
                <a href="${pageContext.request.contextPath}/ViewRoomServlet" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i>
                    Quay Lại
                </a>
            </div>
        </form>
    </div>

    <script>
        // Add smooth transitions and interactions
        document.addEventListener('DOMContentLoaded', function() {
            const inputs = document.querySelectorAll('.form-input, .form-select');
            
            inputs.forEach(input => {
                input.addEventListener('focus', function() {
                    this.parentElement.style.transform = 'scale(1.02)';
                });
                
                input.addEventListener('blur', function() {
                    this.parentElement.style.transform = 'scale(1)';
                });
            });

            // Form validation
            const form = document.querySelector('form');
            form.addEventListener('submit', function(e) {
                const roomName = document.getElementById('roomName').value.trim();
                if (!roomName) {
                    e.preventDefault();
                    alert('Vui lòng nhập tên phòng!');
                    document.getElementById('roomName').focus();
                }
            });
        });
    </script>
     <div style="height: 200px;"></div>
    <jsp:include page="/assets/footer.jsp" />
</body>
</html>

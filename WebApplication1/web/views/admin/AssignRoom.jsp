<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gán phòng cho bác sĩ/y tá</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 600px;
            position: relative;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .header {
            text-align: center;
            margin-bottom: 30px;
        }

        h2 {
            color: #2c3e50;
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 10px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .subtitle {
            color: #7f8c8d;
            font-size: 14px;
            font-weight: 400;
        }

        .back-button {
            position: absolute;
            top: 20px;
            left: 20px;
            background: linear-gradient(135deg, #ff6b6b, #ee5a24);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 25px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .back-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(255, 107, 107, 0.3);
        }

        .back-button:before {
            content: "←";
            font-size: 16px;
        }

        .alert {
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-weight: 500;
            animation: slideIn 0.3s ease;
        }

        .alert.error {
            background: linear-gradient(135deg, #ff6b6b, #ee5a24);
            color: white;
            border-left: 4px solid #c0392b;
        }

        .alert.success {
            background: linear-gradient(135deg, #2ecc71, #27ae60);
            color: white;
            border-left: 4px solid #229954;
        }

        .user-info {
            background: linear-gradient(135deg, #74b9ff, #0984e3);
            color: white;
            padding: 20px;
            border-radius: 15px;
            margin-bottom: 25px;
            text-align: center;
        }

        .user-info h3 {
            margin-bottom: 10px;
            font-size: 18px;
            font-weight: 600;
        }

        .user-info p {
            margin: 5px 0;
            font-size: 14px;
            opacity: 0.9;
        }

        .form-grid {
            display: grid;
            gap: 20px;
        }

        .form-group {
            position: relative;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        label {
            display: block;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 8px;
            font-size: 14px;
        }

        .required:after {
            content: " *";
            color: #e74c3c;
        }

        input[type="number"], 
        input[type="date"], 
        select {
            width: 100%;
            padding: 15px 18px;
            border: 2px solid #e1e8ed;
            border-radius: 10px;
            font-size: 15px;
            transition: all 0.3s ease;
            background: white;
        }

        input[type="number"]:focus, 
        input[type="date"]:focus, 
        select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            transform: translateY(-1px);
        }

        input[readonly] {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            cursor: not-allowed;
            color: #6c757d;
        }

        select {
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='M6 8l4 4 4-4'/%3e%3c/svg%3e");
            background-position: right 12px center;
            background-repeat: no-repeat;
            background-size: 16px;
            padding-right: 40px;
        }

        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        .btn {
            flex: 1;
            padding: 15px 25px;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #95a5a6, #7f8c8d);
            color: white;
        }

        .btn-secondary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(149, 165, 166, 0.3);
        }

        .form-section {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 15px;
            margin-bottom: 20px;
            border-left: 4px solid #667eea;
        }

        .section-title {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 15px;
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-title:before {
            content: "🏥";
            font-size: 18px;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @media (max-width: 768px) {
            .container {
                padding: 30px 20px;
                margin: 10px;
            }

            .back-button {
                position: relative;
                top: auto;
                left: auto;
                margin-bottom: 20px;
                align-self: flex-start;
            }

            h2 {
                font-size: 24px;
            }

            .button-group {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Nút quay lại -->
        <button class="back-button" onclick="history.back()">Quay lại</button>

        <div class="header">
            <h2>Gán phòng cho lịch trình</h2>
            <p class="subtitle">Quản lý phân công phòng làm việc</p>
        </div>
        
        <!-- Thông báo lỗi/thành công -->
        <c:if test="${not empty error}">
            <div class="alert error">${error}</div>
        </c:if>
        <c:if test="${not empty message}">
            <div class="alert success">${message}</div>
        </c:if>

        <!-- Thông tin người dùng -->
        <c:if test="${not empty userName and not empty userRole}">
            <div class="user-info">
                <h3>Thông tin người được gán</h3>
                <p><strong>Tên:</strong> ${userName}</p>
                <p><strong>Vai trò:</strong> ${userRole}</p>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/AssignDoctorNurseToRoom" method="post">
            <!-- Thông tin người dùng -->
            <div class="form-section">
                <div class="section-title">Thông tin cơ bản</div>
                <div class="form-group">
                    <label for="userID" class="required">ID người dùng</label>
                    <input type="number" id="userID" name="userID" value="${selectedUserId}" required>
                </div>
            </div>

            <!-- Chọn phòng -->
            <div class="form-section">
                <div class="section-title">Chọn phòng làm việc</div>
                <div class="form-grid">
                    <div class="form-group">
                        <label for="morningRoomId">Phòng cho ca sáng</label>
                        <select id="morningRoomId" name="morningRoomId">
                            <option value="">-- Không chọn --</option>
                            <c:forEach var="room" items="${availableRooms}">
                                <option value="${room.roomID}">${room.roomName} (${room.status})</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="afternoonRoomId">Phòng cho ca chiều</label>
                        <select id="afternoonRoomId" name="afternoonRoomId">
                            <option value="">-- Không chọn --</option>
                            <c:forEach var="room" items="${availableRooms}">
                                <option value="${room.roomID}">${room.roomName} (${room.status})</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
            </div>

            <!-- Thời gian -->
            <div class="form-section">
                <div class="section-title">Thời gian làm việc</div>
                <div class="form-grid">
                    <div class="form-group">
                        <label for="startDate">Ngày bắt đầu</label>
                        <input type="date" id="startDate" name="startDate" value="${startDate}" readonly>
                    </div>

                    <div class="form-group">
                        <label for="endDate">Ngày kết thúc</label>
                        <input type="date" id="endDate" name="endDate" value="${endDate}" readonly>
                    </div>
                </div>
            </div>

            <!-- Nút hành động -->
            <div class="button-group">
                <button type="button" class="btn btn-secondary" onclick="history.back()">Hủy bỏ</button>
                <button type="submit" class="btn btn-primary">Gán phòng</button>
            </div>
        </form>
    </div>

    <script>
        // Thêm hiệu ứng loading khi submit form
        document.querySelector('form').addEventListener('submit', function() {
            const submitBtn = document.querySelector('.btn-primary');
            submitBtn.innerHTML = 'Đang xử lý...';
            submitBtn.disabled = true;
        });

        // Thêm validation client-side
        document.getElementById('userID').addEventListener('input', function() {
            if (this.value < 1) {
                this.setCustomValidity('ID người dùng phải lớn hơn 0');
            } else {
                this.setCustomValidity('');
            }
        });

        // Auto-hide alerts sau 5 giây
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                alert.style.animation = 'slideOut 0.3s ease';
                setTimeout(function() {
                    alert.remove();
                }, 300);
            });
        }, 5000);
    </script>
</body>
</html>
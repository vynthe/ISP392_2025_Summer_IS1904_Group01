<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gán Phòng - Hệ Thống Quản Lý</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }
        
        .container {
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 20px;
        }
        
        .alert {
            padding: 12px;
            margin: 15px 0;
            border-radius: 4px;
            font-weight: bold;
        }
        
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .alert i {
            margin-right: 8px;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        
        .form-control {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        
        .btn {
            display: inline-block;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
            transition: background-color 0.3s;
            text-decoration: none;
            border: none;
            margin-right: 10px;
        }
        
        .btn-primary {
            background: #007bff;
            color: white;
        }
        
        .btn-primary:hover {
            background: #0056b3;
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #545b62;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2><i class="fas fa-user-doctor"></i> Gán Phòng Cho Bác Sĩ/Y Tá</h2>
        
        <!-- Hiển thị thông báo thành công -->
        <c:if test="${not empty message}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> ${message}
            </div>
        </c:if>
        
        <!-- Hiển thị thông báo lỗi -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>
        
        <!-- Form gán phòng -->
        <c:if test="${not empty selectedUserId}">
            <div style="background: #f8f9fa; padding: 15px; border-radius: 4px; margin-bottom: 20px;">
                <h4>Thông tin nhân viên:</h4>
                <p><strong>Tên:</strong> ${userName}</p>
                <p><strong>Vai trò:</strong> ${userRole}</p>
                <p><strong>Khoảng thời gian:</strong> ${startDate} đến ${endDate}</p>
            </div>
            
            <form action="${pageContext.request.contextPath}/AssignDoctorNurseToRoom" method="post">
                <input type="hidden" name="userID" value="${selectedUserId}">
                <input type="hidden" name="startDate" value="${startDate}">
                <input type="hidden" name="endDate" value="${endDate}">
                
                <div class="form-group">
                    <label for="morningRoomId">Phòng ca sáng (7:30-12:30):</label>
                    <select name="morningRoomId" id="morningRoomId" class="form-control">
                        <option value="">-- Chọn phòng sáng --</option>
                        <c:forEach var="room" items="${availableRooms}">
                            <option value="${room.roomID}">Phòng ${room.roomID} - ${room.roomName}</option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="afternoonRoomId">Phòng ca chiều (13:30-17:30):</label>
                    <select name="afternoonRoomId" id="afternoonRoomId" class="form-control">
                        <option value="">-- Chọn phòng chiều --</option>
                        <c:forEach var="room" items="${availableRooms}">
                            <option value="${room.roomID}">Phòng ${room.roomID} - ${room.roomName}</option>
                        </c:forEach>
                    </select>
                </div>
                
                <div style="margin-top: 20px;">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> Gán Phòng
                    </button>
                    <a href="${pageContext.request.contextPath}/ViewSchedulesServlet" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Quay lại
                    </a>
                </div>
            </form>
        </c:if>
        
        <!-- Form tìm kiếm nhân viên -->
        <c:if test="${empty selectedUserId}">
            <form action="${pageContext.request.contextPath}/AssignDoctorNurseToRoom" method="get">
                <div class="form-group">
                    <label for="userID">ID Nhân viên (Bác sĩ/Y tá):</label>
                    <input type="number" name="userID" id="userID" class="form-control" 
                           placeholder="Nhập ID nhân viên" required>
                </div>
                
                <div style="margin-top: 20px;">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-search"></i> Tìm kiếm
                    </button>
                    <a href="${pageContext.request.contextPath}/ViewSchedulesServlet" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Quay lại
                    </a>
                </div>
            </form>
        </c:if>
    </div>

    <script>
        // Tự động ẩn thông báo sau 5 giây
        setTimeout(function() {
            var alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                alert.style.transition = 'opacity 0.5s';
                alert.style.opacity = '0';
                setTimeout(function() {
                    alert.remove();
                }, 500);
            });
        }, 5000);
    </script>
</body>
</html>
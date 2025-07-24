<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Phòng</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 600px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .header {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
            padding: 30px;
            text-align: center;
            position: relative;
        }

        .header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grid" width="10" height="10" patternUnits="userSpaceOnUse"><path d="M 10 0 L 0 0 0 10" fill="none" stroke="rgba(255,255,255,0.1)" stroke-width="0.5"/></pattern></defs><rect width="100" height="100" fill="url(%23grid)"/></svg>');
            opacity: 0.3;
        }

        .header h2 {
            font-size: 2.2em;
            margin-bottom: 10px;
            position: relative;
            z-index: 1;
        }

        .header .subtitle {
            font-size: 1.1em;
            opacity: 0.9;
            position: relative;
            z-index: 1;
        }

        .form-content {
            padding: 40px;
        }

        .alert {
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert.error {
            background: linear-gradient(135deg, #ff6b6b, #ee5a52);
            color: white;
            border: 1px solid #ff5252;
        }

        .alert.success {
            background: linear-gradient(135deg, #51cf66, #40c057);
            color: white;
            border: 1px solid #51cf66;
        }

        .form-group {
            margin-bottom: 25px;
            position: relative;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
            font-size: 1.05em;
        }

        .form-group label i {
            margin-right: 8px;
            color: #667eea;
            width: 20px;
        }

        .form-control {
            width: 100%;
            padding: 15px 20px;
            border: 2px solid #e9ecef;
            border-radius: 12px;
            font-size: 16px;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }

        .form-control:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            transform: translateY(-2px);
        }

        .form-control:hover {
            border-color: #adb5bd;
        }

        textarea.form-control {
            resize: vertical;
            min-height: 100px;
        }

        select.form-control {
            cursor: pointer;
            appearance: none;
            background-image: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6,9 12,15 18,9"/></svg>');
            background-repeat: no-repeat;
            background-position: right 15px center;
            background-size: 20px;
            padding-right: 50px;
        }

        .button-group {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
        }

        .btn {
            padding: 15px 30px;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            min-width: 140px;
            justify-content: center;
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
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(108, 117, 125, 0.3);
        }

        .btn-secondary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(108, 117, 125, 0.4);
        }

        .status-badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
            margin-left: 10px;
        }

        .status-available { background: #d4edda; color: #155724; }
        .status-not-available { background: #f8d7da; color: #721c24; }
        .status-in-progress { background: #fff3cd; color: #856404; }
        .status-completed { background: #d1ecf1; color: #0c5460; }

        @media (max-width: 768px) {
            .container {
                margin: 10px;
                border-radius: 15px;
            }
            
            .header {
                padding: 20px;
            }
            
            .header h2 {
                font-size: 1.8em;
            }
            
            .form-content {
                padding: 20px;
            }
            
            .button-group {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
            }
        }

        .floating-elements {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            overflow: hidden;
        }

        .floating-elements::before,
        .floating-elements::after {
            content: '';
            position: absolute;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.1);
            animation: float 6s ease-in-out infinite;
        }

        .floating-elements::before {
            width: 60px;
            height: 60px;
            top: 20%;
            left: 10%;
            animation-delay: 0s;
        }

        .floating-elements::after {
            width: 40px;
            height: 40px;
            top: 60%;
            right: 10%;
            animation-delay: 3s;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-20px); }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="floating-elements"></div>
            <h2><i class="fas fa-plus-circle"></i> Thêm Phòng Mới</h2>
            <p class="subtitle">Quản lý phòng khám hiệu quả</p>
        </div>
        
        <div class="form-content">
            <c:if test="${not empty error}">
                <div class="alert error">
                    <i class="fas fa-exclamation-circle"></i>
                    ${error}
                </div>
            </c:if>
            
            <c:if test="${not empty successMessage}">
                <div class="alert success">
                    <i class="fas fa-check-circle"></i>
                    ${successMessage}
                </div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/AddRoomServlet" method="post">
                <input type="hidden" name="action" value="add">
                
                <div class="form-group">
                    <label for="roomName">
                        <i class="fas fa-door-open"></i>Tên Phòng
                    </label>
                    <input type="text" id="roomName" name="roomName" value="${roomName}" 
                           class="form-control" placeholder="Nhập tên phòng..." >
                </div>
                
                <div class="form-group">
                    <label for="description">
                        <i class="fas fa-file-alt"></i>Mô Tả
                    </label>
                    <textarea id="description" name="description" class="form-control" 
                              placeholder="Nhập mô tả chi tiết về phòng...">${description}</textarea>              
                <div class="form-group">
                    <label for="status">
                        <i class="fas fa-info-circle"></i>Trạng Thái
                    </label>
                    <select id="status" name="status" class="form-control">
                        <option value="Available" ${status == 'Available' ? 'selected' : ''}>
                            Có Sẵn <span class="status-badge status-available">●</span>
                        </option>
                        <option value="Not Available" ${status == 'Not Available' ? 'selected' : ''}>
                            Không Có Sẵn <span class="status-badge status-not-available">●</span>
                        </option>
                        <option value="In Progress" ${status == 'In Progress' ? 'selected' : ''}>
                            Đang Tiến Hành <span class="status-badge status-in-progress">●</span>
                        </option>
                        <option value="Completed" ${status == 'Completed' ? 'selected' : ''}>
                            Hoàn Thành <span class="status-badge status-completed">●</span>
                        </option>
                    </select>
                </div>
                
                <div class="button-group">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-plus"></i>
                        Thêm Phòng
                    </button>
                    <a href="${pageContext.request.contextPath}/ViewRoomServlet" class="btn btn-secondary">
                        <i class="fas fa-times"></i>
                        Hủy Bỏ
                    </a>
                </div>
            </form>
        </div>
    </div>
  <div style="height: 200px;"></div>
    <jsp:include page="/assets/footer.jsp" />
</body>
</html>

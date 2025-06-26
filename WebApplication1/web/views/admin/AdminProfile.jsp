<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.entity.Admins" %>
<%
    Admins admin = (Admins) request.getAttribute("adminProfile");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông tin Hồ sơ Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            padding: 40px;
            width: 100%;
            max-width: 600px;
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
            background: linear-gradient(90deg, #667eea, #764ba2, #f093fb);
        }

        .header {
            text-align: center;
            margin-bottom: 40px;
            position: relative;
        }

        .profile-avatar {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }

        .profile-avatar i {
            font-size: 32px;
            color: white;
        }

        h2 {
            color: #2d3748;
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 8px;
            letter-spacing: -0.5px;
        }

        .subtitle {
            color: #718096;
            font-size: 16px;
            font-weight: 400;
        }

        .info-grid {
            display: grid;
            gap: 24px;
            margin-bottom: 40px;
        }

        .info-item {
            background: #f7fafc;
            border-radius: 12px;
            padding: 20px;
            border: 1px solid #e2e8f0;
            transition: all 0.3s ease;
position: relative;
        }

        .info-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            border-color: #cbd5e0;
        }

        .info-label {
            display: flex;
            align-items: center;
            margin-bottom: 8px;
            color: #4a5568;
            font-size: 14px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .info-label i {
            margin-right: 8px;
            color: #667eea;
            font-size: 16px;
        }

        .info-value {
            color: #2d3748;
            font-size: 16px;
            font-weight: 500;
            padding: 8px 0;
            word-break: break-word;
        }

        .btn-container {
            display: flex;
            gap: 16px;
            flex-wrap: wrap;
        }

        .btn {
            flex: 1;
            min-width: 200px;
            padding: 16px 24px;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            text-align: center;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
        }

        .btn-secondary {
            background: #f7fafc;
            color: #4a5568;
            border: 2px solid #e2e8f0;
        }

        .btn-secondary:hover {
            background: #edf2f7;
            border-color: #cbd5e0;
            transform: translateY(-2px);
        }

        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-active {
            background: #c6f6d5;
            color: #22543d;
        }

        @media (max-width: 768px) {
            .container {
                padding: 30px 20px;
                margin: 10px;
            }

            .btn-container {
                flex-direction: column;
            }

            .btn {
                min-width: auto;
            }

            h2 {
                font-size: 24px;
            }
        }

        .floating-shapes {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
            pointer-events: none;
            z-index: -1;
}

        .shape {
            position: absolute;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            animation: float 6s ease-in-out infinite;
        }

        .shape:nth-child(1) {
            width: 80px;
            height: 80px;
            top: 20%;
            left: 10%;
            animation-delay: 0s;
        }

        .shape:nth-child(2) {
            width: 120px;
            height: 120px;
            top: 60%;
            right: 10%;
            animation-delay: 2s;
        }

        .shape:nth-child(3) {
            width: 60px;
            height: 60px;
            bottom: 20%;
            left: 20%;
            animation-delay: 4s;
        }

        @keyframes float {
            0%, 100% {
                transform: translateY(0px) rotate(0deg);
            }
            50% {
                transform: translateY(-20px) rotate(180deg);
            }
        }
    </style>
</head>
<body>
    <div class="floating-shapes">
        <div class="shape"></div>
        <div class="shape"></div>
        <div class="shape"></div>
    </div>

    <div class="container">
        <div class="header">
            <div class="profile-avatar">
                <i class="fas fa-user-shield"></i>
            </div>
            <h2>Hồ sơ Quản trị viên</h2>
            <p class="subtitle">Thông tin chi tiết tài khoản</p>
        </div>

        <div class="info-grid">
            <div class="info-item">
                <div class="info-label">
                    <i class="fas fa-id-badge"></i>
                    ID
                </div>
                <div class="info-value"><%= admin.getAdminID() %></div>
            </div>

            <div class="info-item">
                <div class="info-label">
                    <i class="fas fa-user"></i>
                    Tên đăng nhập
                </div>
                <div class="info-value"><%= admin.getUsername() %></div>
            </div>

            <div class="info-item">
                <div class="info-label">
                    <i class="fas fa-user-circle"></i>
                    Họ và tên
                </div>
                <div class="info-value"><%= admin.getFullName() %></div>
            </div>

            <div class="info-item">
                <div class="info-label">
                    <i class="fas fa-envelope"></i>
                    Địa chỉ email
                </div>
                <div class="info-value"><%= admin.getEmail() %></div>
            </div>

            <div class="info-item">
                <div class="info-label">
                    <i class="fas fa-calendar-plus"></i>
                    Ngày tạo tài khoản
                </div>
                <div class="info-value">
                    <i class="fas fa-clock" style="margin-right: 8px; color: #667eea;"></i>
                    <%= admin.getCreatedAt() %>
                </div>
            </div>
<div class="info-item">
                <div class="info-label">
                    <i class="fas fa-shield-alt"></i>
                    Trạng thái
                </div>
                <div class="info-value">
                    <span class="status-badge status-active">Hoạt động</span>
                </div>
            </div>
        </div>

        <div class="btn-container">
            <a href="<%= request.getContextPath() %>/views/admin/dashboard.jsp" class="btn btn-primary">
                <i class="fas fa-home"></i>
                Quay lại trang chủ
            </a>
            
        </div>
    </div>

   
</body>
</html>

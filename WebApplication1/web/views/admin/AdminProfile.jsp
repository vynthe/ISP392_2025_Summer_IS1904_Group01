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
    <title>Thông tin Hồ sơ Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        /* Reset default styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Arial, sans-serif;
        }

        body {
            background: linear-gradient(135deg, #d1fae5, #a7f3d0);
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
            max-width: 550px;
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
            background: linear-gradient(to right, #2e7d32, #66bb6a);
        }

        h2 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 30px;
            font-size: 28px;
            font-weight: 600;
            letter-spacing: 1px;
        }

        .form-group, .input-box {
            margin-bottom: 20px;
            position: relative;
        }

        .form-group label {
            display: block;
            font-weight: 500;
            margin-bottom: 8px;
            color: #34495e;
            font-size: 15px;
        }

        .form-group .info-text {
            width: 100%;
            padding: 12px 40px 12px 15px;
            border: 1px solid #dfe6e9;
            border-radius: 8px;
            font-size: 14px;
            background: #f9fafb;
            color: #34495e;
        }

        .input-box i {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #7f8c8d;
            font-size: 16px;
        }

        .form-group .btn-back {
            width: 100%;
            padding: 14px;
            background: linear-gradient(to right, #2e7d32, #66bb6a);
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
        }

        .form-group .btn-back:hover {
            background: linear-gradient(to right, #27632a, #59a35d);
            box-shadow: 0 5px 15px rgba(46, 125, 50, 0.3);
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Hồ sơ Quản trị viên</h2>
    <div class="form-group">
        <label for="adminID">ID</label>
        <div class="input-box">
            <div class="info-text" id="adminID"><%= admin.getAdminID() %></div>
            <i class="fas fa-id-badge"></i>
        </div>
    </div>
    <div class="form-group">
        <label for="username">Username</label>
        <div class="input-box">
            <div class="info-text" id="username"><%= admin.getUsername() %></div>
            <i class="fas fa-user"></i>
        </div>
    </div>
    <div class="form-group">
        <label for="fullName">Tên đầy đủ</label>
        <div class="input-box">
            <div class="info-text" id="fullName"><%= admin.getFullName() %></div>
            <i class="fas fa-user"></i>
        </div>
    </div>
    <div class="form-group">
        <label for="email">Email</label>
        <div class="input-box">
            <div class="info-text" id="email"><%= admin.getEmail() %></div>
            <i class="fas fa-envelope"></i>
        </div>
    </div>
    <div class="form-group">
        <label for="createdAt">Ngày tạo tài khoản</label>
        <div class="input-box">
            <div class="info-text" id="createdAt"><%= admin.getCreatedAt() %></div>
            <i class="fas fa-calendar-alt"></i>
        </div>
    </div>
    <div class="form-group">
        <a href="<%= request.getContextPath() %>/views/admin/dashboard.jsp" class="btn-back">Quay lại trang chủ</a>
    </div>
</div>
</body>
</html>
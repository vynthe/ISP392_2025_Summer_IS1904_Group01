<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.entity.Admins"%> 
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa hồ sơ Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(120deg, #a8edea, #fed6e3);
            margin: 0;
            padding: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .container {
            width: 100%;
            max-width: 600px;
            background: #ffffff;
            padding: 40px;
            /* Loại bỏ khung, radius, shadow */
        }

        .card-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .avatar {
            font-size: 3rem;
            color: #3b82f6;
            margin-bottom: 10px;
        }

        .card-title {
            font-size: 1.8rem;
            font-weight: bold;
            color: #111827;
        }

        .card-subtitle {
            color: #6b7280;
            font-size: 0.95rem;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            font-weight: 600;
            color: #374151;
            margin-bottom: 6px;
            display: block;
        }

        .form-label i {
            margin-right: 6px;
            color: #10b981;
        }

        .form-input {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid #d1d5db;
            background: #f9fafb;
            font-size: 1rem;
        }

        .form-input:focus {
            border-color: #3b82f6;
            outline: none;
            background: white;
        }

        .button-group {
            display: flex;
            gap: 12px;
            margin-top: 30px;
        }

        .btn {
            padding: 12px;
            font-weight: 600;
            font-size: 1rem;
            border: none;
            cursor: pointer;
            flex: 1;
        }

        .btn-primary {
            background-color: #3b82f6;
            color: white;
        }

        .btn-primary:hover {
            background-color: #2563eb;
        }

        .btn-secondary {
            background-color: #f3f4f6;
            color: #374151;
        }

        .btn-secondary:hover {
            background-color: #e5e7eb;
        }

        .alert {
            padding: 10px 15px;
            margin-bottom: 20px;
            font-size: 0.95rem;
        }

        .alert-success {
            background-color: #d1fae5;
            color: #065f46;
        }

        .alert-error {
            background-color: #fee2e2;
            color: #991b1b;
        }

        @media (max-width: 600px) {
            .button-group {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="card-header">
            <div class="avatar"><i class="fas fa-user-shield"></i></div>
            <h1 class="card-title">Chỉnh sửa hồ sơ</h1>
            <p class="card-subtitle">Cập nhật thông tin admin</p>
        </div>

        <c:if test="${not empty success}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> ${success}
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-triangle"></i> ${error}
            </div>
        </c:if>

        <%
            Admins admin = (Admins) session.getAttribute("admin");
            if (admin == null) {
                response.sendRedirect(request.getContextPath() + "/views/admin/login.jsp");
                return;
            }
            request.setAttribute("admin", admin);
        %>

        <form action="EditProfileAdminController" method="post">
            <div class="form-group">
                <label class="form-label" for="username">
                    <i class="fas fa-user"></i> Tên đăng nhập
                </label>
                <input type="text" id="username" name="username" value="${admin.username}" class="form-input" required>
            </div>

            <div class="form-group">
                <label class="form-label" for="fullName">
                    <i class="fas fa-id-card"></i> Họ và tên
                </label>
                <input type="text" id="fullName" name="fullName" value="${admin.fullName}" class="form-input" required>
            </div>

            <div class="form-group">
                <label class="form-label" for="email">
                    <i class="fas fa-envelope"></i> Email
                </label>
                <input type="email" id="email" name="email" value="${admin.email}" class="form-input" required>
            </div>

            <div class="button-group">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i> Lưu thay đổi
                </button>
                <a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Quay lại
                </a>
            </div>
        </form>
    </div>
</body>
</html>

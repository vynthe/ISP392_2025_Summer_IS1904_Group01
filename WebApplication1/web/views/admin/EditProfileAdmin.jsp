<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.entity.Admins"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chỉnh sửa hồ sơ Admin</title>
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

        .form-group input[type="text"],
        .form-group input[type="email"] {
            width: 100%;
            padding: 12px 40px 12px 15px;
            border: 1px solid #dfe6e9;
            border-radius: 8px;
            font-size: 14px;
            background: #f9fafb;
            transition: all 0.3s ease;
        }

        .form-group input:focus {
            border-color: #2e7d32;
            background: #ffffff;
            box-shadow: 0 0 5px rgba(46, 125, 50, 0.2);
            outline: none;
        }

        .input-box i {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #7f8c8d;
            font-size: 16px;
        }

        .form-group input[type="submit"],
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

        .form-group input[type="submit"]:hover,
        .form-group .btn-back:hover {
            background: linear-gradient(to right, #27632a, #59a35d);
            box-shadow: 0 5px 15px rgba(46, 125, 50, 0.3);
        }

        .error {
            background-color: #ffebee;
            color: #c62828;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
            font-size: 14px;
            border-left: 4px solid #c62828;
        }

        .success {
            background-color: #e8f5e9;
            color: #2e7d32;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
            font-size: 14px;
            border-left: 4px solid #2e7d32;
        }

        .needs-validation.was-validated .form-control:invalid {
            border-color: #c62828;
            background-image: none;
        }

        .needs-validation.was-validated .form-control:valid {
            border-color: #2e7d32;
        }

        .invalid-feedback {
            display: none;
            color: #c62828;
            font-size: 12px;
            margin-top: 5px;
        }

        .was-validated .form-control:invalid ~ .invalid-feedback {
            display: block;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Chỉnh sửa hồ sơ Admin</h2>

        <c:if test="${not empty success}">
            <div class="success">${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>

        <%
            Admins admin = (Admins) session.getAttribute("admin");
            if (admin == null) {
                response.sendRedirect(request.getContextPath() + "/views/admin/login.jsp");
                return;
            }
            request.setAttribute("admin", admin);
        %>
        <form action="EditProfileAdminController" method="post" class="needs-validation" novalidate>
            <div class="form-group">
                <label for="username">Tên đăng nhập</label>
                <div class="input-box">
                    <input type="text" id="username" name="username" value="${admin.username}" placeholder="Nhập tên đăng nhập" required>
                    <i class="fas fa-user"></i>
                </div>
                <div class="invalid-feedback">Vui lòng nhập tên đăng nhập.</div>
            </div>
            <div class="form-group">
                <label for="fullName">Họ tên</label>
                <div class="input-box">
                    <input type="text" id="fullName" name="fullName" value="${admin.fullName}" placeholder="Nhập họ tên" required>
                    <i class="fas fa-user"></i>
                </div>
                <div class="invalid-feedback">Vui lòng nhập họ tên.</div>
            </div>
            <div class="form-group">
                <label for="email">Email</label>
                <div class="input-box">
                    <input type="email" id="email" name="email" value="${admin.email}" placeholder="Nhập email" required>
                    <i class="fas fa-envelope"></i>
                </div>
                <div class="invalid-feedback">Vui lòng nhập email hợp lệ.</div>
            </div>
            <div class="form-group">
                <input type="submit" value="Cập nhật">
            </div>
            <div class="form-group">
                <a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp" class="btn-back">Quay lại trang chủ</a>
            </div>
        </form>
    </div>

    <script>
        (function () {
            'use strict';
            const forms = document.querySelectorAll('.needs-validation');
            Array.from(forms).forEach(form => {
                form.addEventListener('submit', event => {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        })();
    </script>
</body>
</html>
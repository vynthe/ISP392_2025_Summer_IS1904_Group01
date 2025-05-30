<%-- 
    Document   : AddPatient
    Created on : May 26, 2025
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Thêm Bệnh Nhân</title>
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
                background: linear-gradient(135deg, #bbdefb, #90caf9);
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
                background: linear-gradient(to right, #1976D2, #42A5F5);
            }

            h2 {
                text-align: center;
                color: #2c3e50;
                margin-bottom: 30px;
                font-size: 28px;
                font-weight: 600;
                letter-spacing: 1px;
            }

            .form-group, .mb-3, .input-box {
                margin-bottom: 20px;
                position: relative;
            }

            .form-group label, .mb-3 label {
                display: block;
                font-weight: 500;
                margin-bottom: 8px;
                color: #34495e;
                font-size: 15px;
            }

            .form-group input[type="text"],
            .form-group input[type="email"],
            .form-group input[type="password"],
            .form-group input[type="date"],
            .form-group input[type="tel"],
            .form-group select,
            .input-box input,
            .input-box select {
                width: 100%;
                padding: 12px 40px 12px 15px;
                border: 1px solid #dfe6e9;
                border-radius: 8px;
                font-size: 14px;
                background: #f9fafb;
                transition: all 0.3s ease;
            }

            .form-group input:focus,
            .form-group select:focus,
            .input-box input:focus,
            .input-box select:focus {
                border-color: #1976D2;
                background: #ffffff;
                box-shadow: 0 0 5px rgba(25, 118, 210, 0.2);
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
            .form-group input[type="button"] {
                width: 100%;
                padding: 14px;
                background: linear-gradient(to right, #1976D2, #42A5F5);
                color: white;
                border: none;
                border-radius: 8px;
                font-size: 16px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s ease;
                text-transform: uppercase;
                letter-spacing: 1px;
                margin-bottom: 10px;
            }

            .form-group input[type="submit"]:hover,
            .form-group input[type="button"]:hover {
                background: linear-gradient(to right, #1565C0, #2196F3);
                box-shadow: 0 5px 15px rgba(25, 118, 210, 0.3);
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

            select option[disabled] {
                color: #b0bec5;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Thêm Bệnh Nhân Mới</h2>
            <c:if test="${not empty requestScope.error}">
                <div class="error">${requestScope.error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/AddPatientServlet" method="post" id="patientForm">
                <div class="form-group">
                    <label for="fullName">Họ và Tên:</label>
                    <div class="input-box">
                        <input type="text" id="fullName" name="fullName" value="${fullName != null ? fullName : ''}" placeholder="Họ và Tên" required>
                        <i class="fas fa-user"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label for="gender" class="form-label">Giới tính</label>
                    <div class="input-box">
                        <select class="form-select" id="gender" name="gender" required>
                            <option value="" disabled ${empty gender ? 'selected' : ''}>Chọn giới tính</option>
                            <option value="Nam" ${gender == 'Nam' ? 'selected' : ''}>Nam</option>
                            <option value="Nữ" ${gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                            <option value="Khác" ${gender == 'Khác' ? 'selected' : ''}>Khác</option>
                        </select>
                        <i class="fas fa-venus-mars"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label for="dob" class="form-label">Ngày sinh</label>
                    <div class="input-box">
                        <input type="date" class="form-control" id="dob" name="dob" value="${dob != null ? dob : ''}" required>
                        <i class="fas fa-calendar-alt"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label for="username" class="form-label">Tên đăng nhập</label>
                    <div class="input-box">
                        <input type="text" class="form-control" id="username" name="username" value="${username != null ? username : ''}" placeholder="Tên đăng nhập" required>
                        <i class="fas fa-user-circle"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label for="password" class="form-label">Mật khẩu</label>
                    <div class="input-box">
                        <input type="password" class="form-control" id="password" name="password" value="${password != null ? password : ''}" placeholder="Mật khẩu" required>
                        <i class="fas fa-lock"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label for="email" class="form-label">Email</label>
                    <div class="input-box">
                        <input type="email" class="form-control" id="email" name="email" value="${email != null ? email : ''}" placeholder="Email" required>
                        <i class="fas fa-envelope"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label for="phone" class="form-label">Số điện thoại</label>
                    <div class="input-box">
                        <input type="tel" class="form-control" id="phone" name="phone" value="${phone != null ? phone : ''}" placeholder="Nhập số điện thoại (10 chữ số)">
                        <i class="fas fa-phone"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label for="address" class="form-label">Địa chỉ</label>
                    <div class="input-box">
                        <input type="text" class="form-control" id="address" name="address" value="${address != null ? address : ''}" placeholder="Nhập địa chỉ" required>
                        <i class="fas fa-map-marker-alt"></i>
                    </div>
                </div>

                <div class="form-group">
                    <input type="submit" value="Thêm Bệnh Nhân">
                </div>
                <div class="form-group">
                    <input type="button" value="Quay Lại Danh Sách" onclick="window.history.back()">
                </div>
            </form>
        </div>
    </body>
</html>
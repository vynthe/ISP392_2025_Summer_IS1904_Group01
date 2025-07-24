<%-- 
    Document   : AddDoctorNurse
    Created on : May 22, 2025
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Thêm Nhân Viên</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <style>
            /* Reset default styles */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            body {
                background: linear-gradient(135deg, #6f42c1 0%, #8b5cf6 50%, #a855f7 100%);
                min-height: 100vh;
                padding: 0;
            }

            /* Header */
            .header {
                background: rgba(255, 255, 255, 0.15);
                backdrop-filter: blur(10px);
                padding: 20px 0;
                margin-bottom: 30px;
                border-bottom: 1px solid rgba(255, 255, 255, 0.2);
            }

            .header-content {
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 20px;
                display: flex;
                align-items: center;
                justify-content: space-between;
            }

            .breadcrumb {
                display: flex;
                align-items: center;
                gap: 10px;
                color: white;
                font-size: 14px;
            }

            .breadcrumb a {
                color: rgba(255, 255, 255, 0.8);
                text-decoration: none;
                transition: color 0.3s ease;
            }

            .breadcrumb a:hover {
                color: white;
            }

            .breadcrumb .separator {
                color: rgba(255, 255, 255, 0.6);
            }

            .breadcrumb .current {
                color: white;
                font-weight: 500;
            }

            .header-title {
                color: white;
                font-size: 24px;
                font-weight: 600;
            }

            /* Main Container */
            .main-container {
                padding: 0 20px 40px;
                display: flex;
                justify-content: center;
            }

            .container {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(20px);
                padding: 40px;
                border-radius: 20px;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
                width: 100%;
                max-width: 900px;
                position: relative;
                border: 1px solid rgba(255, 255, 255, 0.3);
            }

            h2 {
                text-align: center;
                color: #4c1d95;
                margin-bottom: 40px;
                font-size: 28px;
                font-weight: 600;
                position: relative;
            }

            h2::after {
                content: '';
                position: absolute;
                bottom: -10px;
                left: 50%;
                transform: translateX(-50%);
                width: 60px;
                height: 3px;
                background: linear-gradient(to right, #8b5cf6, #a855f7);
                border-radius: 2px;
            }

            .form-container {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 30px;
            }

            .form-column {
                display: flex;
                flex-direction: column;
                gap: 25px;
            }

            .form-group {
                position: relative;
            }

            .form-group label {
                display: block;
                font-weight: 500;
                margin-bottom: 8px;
                color: #6b46c1;
                font-size: 14px;
            }

            .input-box {
                position: relative;
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
                padding: 14px 40px 14px 16px;
                border: 2px solid rgba(139, 92, 246, 0.2);
                border-radius: 12px;
                font-size: 14px;
                background: rgba(255, 255, 255, 0.9);
                transition: all 0.3s ease;
                color: #4c1d95;
            }

            .form-group input:focus,
            .form-group select:focus,
            .input-box input:focus,
            .input-box select:focus {
                border-color: #8b5cf6;
                outline: none;
                box-shadow: 0 0 0 4px rgba(139, 92, 246, 0.1);
                background: white;
            }

            .input-box i {
                position: absolute;
                right: 16px;
                top: 50%;
                transform: translateY(-50%);
                color: #a855f7;
                font-size: 16px;
                transition: color 0.3s ease;
            }

            .form-group:focus-within .input-box i {
                color: #8b5cf6;
            }

            .buttons-section {
                grid-column: 1 / -1;
                display: flex;
                gap: 15px;
                margin-top: 30px;
            }

            .form-group input[type="submit"],
            .form-group input[type="button"] {
                flex: 1;
                padding: 16px 24px;
                border: none;
                border-radius: 12px;
                font-size: 15px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                text-transform: none;
                margin-bottom: 0;
                position: relative;
                overflow: hidden;
            }

            .form-group input[type="submit"] {
                background: linear-gradient(135deg, #8b5cf6, #a855f7);
                color: white;
                box-shadow: 0 4px 15px rgba(139, 92, 246, 0.3);
            }

            .form-group input[type="submit"]:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(139, 92, 246, 0.4);
                background: linear-gradient(135deg, #7c3aed, #9333ea);
            }

            .form-group input[type="button"] {
                background: rgba(139, 92, 246, 0.1);
                color: #6b46c1;
                border: 2px solid rgba(139, 92, 246, 0.3);
            }

            .form-group input[type="button"]:hover {
                background: rgba(139, 92, 246, 0.2);
                border-color: rgba(139, 92, 246, 0.5);
                transform: translateY(-2px);
            }

            .error {
                grid-column: 1 / -1;
                background: linear-gradient(135deg, #fef2f2, #fee2e2);
                color: #dc2626;
                padding: 16px 20px;
                border-radius: 12px;
                margin-bottom: 20px;
                text-align: center;
                font-size: 14px;
                border: 1px solid rgba(220, 38, 38, 0.2);
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                backdrop-filter: blur(10px);
            }

            .error::before {
                content: '\f071';
                font-family: 'Font Awesome 5 Free';
                font-weight: 900;
                font-size: 16px;
            }

            select option[disabled] {
                color: #a855f7;
            }

            /* Responsive design */
            @media (max-width: 768px) {
                .header-content {
                    flex-direction: column;
                    gap: 15px;
                    text-align: center;
                }

                .header-title {
                    font-size: 20px;
                }

                .container {
                    padding: 30px 20px;
                    margin: 10px;
                    border-radius: 16px;
                }

                .form-container {
                    grid-template-columns: 1fr;
                    gap: 20px;
                }

                .form-column {
                    gap: 20px;
                }

                .buttons-section {
                    flex-direction: column;
                    gap: 12px;
                }

                h2 {
                    font-size: 24px;
                    margin-bottom: 30px;
                }
            }

            /* Enhanced focus states */
            .form-group input:focus + .input-box i,
            .form-group select:focus + .input-box i {
                color: #7c3aed;
            }

            /* Placeholder styling */
            ::placeholder {
                color: rgba(139, 92, 246, 0.6);
                opacity: 1;
            }

            /* Select arrow styling */
            select {
                appearance: none;
                background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%23a855f7' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='m6 8 4 4 4-4'/%3e%3c/svg%3e");
                background-position: right 16px center;
                background-repeat: no-repeat;
                background-size: 16px;
                padding-right: 45px;
            }

            /* Glass effect for inputs */
            .form-group input,
            .form-group select {
                backdrop-filter: blur(10px);
            }

            /* Button ripple effect */
            .form-group input[type="submit"]::before {
                content: '';
                position: absolute;
                top: 50%;
                left: 50%;
                width: 0;
                height: 0;
                border-radius: 50%;
                background: rgba(255, 255, 255, 0.3);
                transition: width 0.6s, height 0.6s, top 0.6s, left 0.6s;
                transform: translate(-50%, -50%);
            }

            .form-group input[type="submit"]:active::before {
                width: 300px;
                height: 300px;
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <div class="header">
            <div class="header-content">
                <div class="breadcrumb">
                    <i class="fas fa-home"></i>
                    <a href="${pageContext.request.contextPath}/">Trang Chủ</a>
                    <span class="separator">></span>
                    <a href="${pageContext.request.contextPath}/employee-management">Quản Lý Nhân Viên</a>
                    <span class="separator">></span>
                    <span class="current">Thêm Nhân Viên</span>
                </div>
                <div class="header-title">
                    <i class="fas fa-user-plus"></i> Quản Lý Nhân Viên
                </div>
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-container">
            <div class="container">
                <h2>Thêm Nhân Viên Mới</h2>
                <form action="${pageContext.request.contextPath}/AddEmployeeServlet" method="post" id="employeeForm">
                    <div class="form-container">
                        <c:if test="${not empty requestScope.error}">
                            <div class="error">${requestScope.error}</div>
                        </c:if>

                        <div class="form-column">
                            <div class="form-group">
                                <label for="fullName">Họ và Tên</label>
                                <div class="input-box">
                                    <input type="text" id="fullName" name="fullName" value="${sessionScope.formData.fullName}" placeholder="Nhập họ và tên đầy đủ" required>
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
                                    <input type="date" class="form-control" id="dob" name="dob" value="${dob}" required>
                                    <i class="fas fa-calendar-alt"></i>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="specialization" class="form-label">Trình độ chuyên môn</label>
                                <div class="input-box">
                                    <select class="form-select" id="specialization" name="specialization">
                                        <option value="" ${empty specialization ? 'selected' : ''}>Chọn trình độ</option>
                                        <option value="Chuyên môn" ${specialization == 'Chuyên môn' ? 'selected' : ''}>Chuyên môn</option>
                                        <option value="Thạc Sỹ" ${specialization == 'Thạc Sỹ' ? 'selected' : ''}>Thạc Sỹ</option>
                                        <option value="Tiến Sỹ" ${specialization == 'Tiến Sỹ' ? 'selected' : ''}>Tiến Sỹ</option>
                                    </select>
                                    <i class="fas fa-graduation-cap"></i>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="role" class="form-label">Vai trò</label>
                                <div class="input-box">
                                    <select name="role" id="role" class="form-select" required>
                                        <option value="" disabled ${requestScope.role == null ? 'selected' : ''}>Chọn vai trò</option>
                                        <option value="doctor" ${requestScope.role == 'doctor' ? 'selected' : ''}>Bác sĩ</option>
                                        <option value="nurse" ${requestScope.role == 'nurse' ? 'selected' : ''}>Y tá</option>
                                        <option value="receptionist" ${requestScope.role == 'receptionist' ? 'selected' : ''}>Tiếp tân</option>
                                    </select>
                                    <i class="fas fa-user-tag"></i>
                                </div>
                            </div>
                        </div>

                        <div class="form-column">
                            <div class="form-group">
                                <label for="username" class="form-label">Tên đăng nhập</label>
                                <div class="input-box">
                                    <input type="text" class="form-control" id="username" name="username" value="${requestScope.username}" placeholder="Nhập tên đăng nhập" required>
                                    <i class="fas fa-user-circle"></i>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="email" class="form-label">Email</label>
                                <div class="input-box">
                                    <input type="email" class="form-control" id="email" name="email" value="${requestScope.email}" placeholder="example@email.com" required>
                                    <i class="fas fa-envelope"></i>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="password" class="form-label">Mật khẩu</label>
                                <div class="input-box">
                                    <input type="password" class="form-control" id="password" name="password" value="${requestScope.password}" placeholder="Nhập mật khẩu" required>
                                    <i class="fas fa-lock"></i>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="phone" class="form-label">Số điện thoại</label>
                                <div class="input-box">
                                    <input type="tel" class="form-control" id="phone" name="phone" value="${phone}" placeholder="0123456789" required>
                                    <i class="fas fa-phone"></i>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="address" class="form-label">Địa chỉ</label>
                                <div class="input-box">
                                    <input type="text" class="form-control" id="address" name="address" value="${address}" placeholder="Nhập địa chỉ đầy đủ" required>
                                    <i class="fas fa-map-marker-alt"></i>
                                </div>
                            </div>
                        </div>

                        <div class="buttons-section">
                            <div class="form-group">
                                <input type="submit" value="Thêm Nhân Viên">
                            </div>
                            <div class="form-group">
                                <input type="button" value="Quay Lại Danh Sách" onclick="window.history.back()">
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
                                         <div style="height: 200px;"></div>
    <jsp:include page="/assets/footer.jsp" />
    </body>
</html>

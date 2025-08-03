<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thêm Bệnh Nhân</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            /* Reset và base styles */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
                background: linear-gradient(135deg, #e3f2fd, #bbdefb);
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                padding: 20px;
                line-height: 1.6;
            }

            /* Header Styles */
            header {
                background: linear-gradient(135deg, #1565C0, #42A5F5);
                color: white;
                padding: 20px 40px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                position: sticky;
                top: 0;
                z-index: 1000;
            }

            .header-content {
                max-width: 1200px;
                margin: 0 auto;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .header-content h1 {
                font-size: 24px;
                font-weight: 700;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .header-content nav a {
                color: white;
                text-decoration: none;
                margin-left: 20px;
                font-size: 16px;
                font-weight: 500;
                transition: opacity 0.3s ease;
            }

            .header-content nav a:hover {
                opacity: 0.8;
            }

            /* Form Container */
            .form-container {
                background: rgba(255, 255, 255, 0.97);
                backdrop-filter: blur(20px);
                border-radius: 24px;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
                width: 100%;
                max-width: 700px;
                margin: 40px auto;
                overflow: hidden;
                border: 1px solid rgba(255, 255, 255, 0.3);
                animation: slideUp 0.6s cubic-bezier(0.4, 0, 0.2, 1);
            }

            .form-header {
                background: linear-gradient(135deg, #1976D2, #64B5F6);
                padding: 30px 40px;
                text-align: center;
                color: white;
                position: relative;
            }

            .form-header::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: linear-gradient(135deg, rgba(25, 118, 210, 0.2), rgba(100, 181, 246, 0.2));
                opacity: 0.4;
            }

            .form-header h2 {
                font-size: 30px;
                font-weight: 700;
                margin-bottom: 10px;
                position: relative;
                z-index: 1;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
            }

            .form-header p {
                font-size: 16px;
                opacity: 0.9;
                position: relative;
                z-index: 1;
            }

            .form-content {
                padding: 40px;
            }

            .error {
                background: linear-gradient(135deg, #fee2e2, #fecaca);
                color: #b91c1c;
                padding: 16px 20px;
                border-radius: 12px;
                margin-bottom: 24px;
                text-align: center;
                font-weight: 500;
                border-left: 4px solid #b91c1c;
                display: flex;
                align-items: center;
                gap: 12px;
                box-shadow: 0 2px 8px rgba(185, 28, 28, 0.1);
            }

            .error i {
                font-size: 18px;
            }

            .form-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 24px;
                margin-bottom: 24px;
            }

            .form-group {
                position: relative;
            }

            .form-group.full-width {
                grid-column: 1 / -1;
            }

            .form-label {
                display: block;
                font-weight: 600;
                color: #1f2937;
                margin-bottom: 8px;
                font-size: 14px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .input-wrapper {
                position: relative;
                display: flex;
                align-items: center;
            }

            .form-input,
            .form-select {
                width: 100%;
                padding: 14px 20px 14px 50px;
                border: 2px solid #e5e7eb;
                border-radius: 12px;
                font-size: 16px;
                background: #f9fafb;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                outline: none;
            }

            .form-input:focus,
            .form-select:focus {
                border-color: #1E88E5;
                background: white;
                box-shadow: 0 0 0 4px rgba(30, 136, 229, 0.15);
                transform: translateY(-1px);
            }

            .input-icon {
                position: absolute;
                left: 18px;
                top: 50%;
                transform: translateY(-50%);
                color: #6b7280;
                font-size: 18px;
                z-index: 2;
                transition: color 0.3s ease;
            }

            .form-input:focus + .input-icon,
            .form-select:focus + .input-icon {
                color: #1E88E5;
            }

            .form-select {
                cursor: pointer;
                appearance: none;
                background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='m6 8 4 4 4-4'/%3e%3c/svg%3e");
                background-position: right 16px center;
                background-repeat: no-repeat;
                background-size: 16px;
                padding-right: 50px;
            }

            .password-toggle {
                position: absolute;
                right: 16px;
                top: 50%;
                transform: translateY(-50%);
                background: none;
                border: none;
                color: #6b7280;
                cursor: pointer;
                font-size: 16px;
                z-index: 3;
                padding: 4px;
                border-radius: 4px;
                transition: color 0.3s ease;
            }

            .password-toggle:hover {
                color: #1E88E5;
            }

            .button-group {
                display: flex;
                gap: 16px;
                margin-top: 32px;
            }

            .btn {
                flex: 1;
                padding: 16px 24px;
                border: none;
                border-radius: 12px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                text-transform: uppercase;
                letter-spacing: 0.5px;
                position: relative;
                overflow: hidden;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
            }

            .btn-primary {
                background: linear-gradient(135deg, #1E88E5, #64B5F6);
                color: white;
                box-shadow: 0 4px 12px rgba(30, 136, 229, 0.3);
            }

            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(30, 136, 229, 0.4);
                background: linear-gradient(135deg, #1565C0, #42A5F5);
            }

            .btn-secondary {
                background: #f3f4f6;
                color: #1f2937;
                border: 2px solid #e5e7eb;
            }

            .btn-secondary:hover {
                background: #e5e7eb;
                transform: translateY(-1px);
                border-color: #d1d5db;
            }

            .btn:active {
                transform: translateY(0);
            }

            /* Footer Styles */
            footer {
                background: linear-gradient(135deg, #1565C0, #42A5F5);
                color: white;
                padding: 40px 20px;
                margin-top: auto;
                text-align: center;
            }

            .footer-content {
                max-width: 1200px;
                margin: 0 auto;
            }

            .footer-content p {
                font-size: 16px;
                margin-bottom: 16px;
            }

            .footer-links a {
                color: white;
                text-decoration: none;
                margin: 0 12px;
                font-size: 14px;
                opacity: 0.9;
                transition: opacity 0.3s ease;
            }

            .footer-links a:hover {
                opacity: 1;
            }

            .footer-social {
                margin-top: 16px;
            }

            .footer-social a {
                color: white;
                font-size: 20px;
                margin: 0 12px;
                transition: transform 0.3s ease;
            }

            .footer-social a:hover {
                transform: scale(1.2);
            }

            /* Responsive design */
            @media (max-width: 768px) {
                .form-container {
                    margin: 20px 10px;
                    border-radius: 16px;
                }

                .form-header {
                    padding: 24px 20px;
                }

                .form-header h2 {
                    font-size: 24px;
                }

                .form-content {
                    padding: 24px 20px;
                }

                .form-grid {
                    grid-template-columns: 1fr;
                    gap: 20px;
                }

                .button-group {
                    flex-direction: column;
                }

                .header-content {
                    flex-direction: column;
                    gap: 16px;
                }

                .header-content nav a {
                    margin: 0 10px;
                }

                footer {
                    padding: 30px 20px;
                }
            }

            /* Animation cho form load */
            @keyframes slideUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <header>
            <div class="header-content">
                <h1><i class="fas fa-hospital"></i> Quản Lý Bệnh Nhân</h1>
                <nav>
                    <a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp">Trang Chủ</a>
                    <a href="${pageContext.request.contextPath}/ViewPatientServlet">Quản Lý Bệnh Nhân</a>
                </nav>
            </div>
        </header>

        <!-- Form Container -->
        <div class="form-container">
            <div class="form-header">
                <h2><i class="fas fa-user-plus"></i> Thêm Bệnh Nhân</h2>
                <p>Vui lòng điền đầy đủ thông tin bệnh nhân</p>
            </div>

            <div class="form-content">
                <c:if test="${not empty requestScope.error}">
                    <div class="error">
                        <i class="fas fa-exclamation-triangle"></i>
                        <span>${requestScope.error}</span>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/AddPatientServlet" method="post">
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="fullName" class="form-label">Họ và Tên</label>
                            <div class="input-wrapper">
                                <input type="text" id="fullName" name="fullName" class="form-input" 
                                       value="${fullName != null ? fullName : ''}" 
                                       placeholder="Nhập họ và tên đầy đủ" required>
                                <i class="fas fa-id-card input-icon"></i>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="gender" class="form-label">Giới tính</label>
                            <div class="input-wrapper">
                                <select class="form-select" id="gender" name="gender" required>
                                    <option value="" disabled ${empty gender ? 'selected' : ''}>Chọn giới tính</option>
                                    <option value="Nam" ${gender == 'Nam' ? 'selected' : ''}>Nam</option>
                                    <option value="Nữ" ${gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                                    <option value="Khác" ${gender == 'Khác' ? 'selected' : ''}>Khác</option>
                                </select>
                                <i class="fas fa-users input-icon"></i>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="dob" class="form-label">Ngày sinh</label>
                            <div class="input-wrapper">
                                <input type="date" class="form-input" id="dob" name="dob" 
                                       value="${dob != null ? dob : ''}" required>
                                <i class="fas fa-birthday-cake input-icon"></i>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="phone" class="form-label">Số điện thoại</label>
                            <div class="input-wrapper">
                                <input type="tel" class="form-input" id="phone" name="phone" 
                                       value="${phone != null ? phone : ''}" 
                                       placeholder="Nhập số điện thoại (10 chữ số)"
                                       pattern="[0-9]{10}" title="Vui lòng nhập 10 chữ số">
                                <i class="fas fa-mobile-alt input-icon"></i>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="username" class="form-label">Tên đăng nhập</label>
                            <div class="input-wrapper">
                                <input type="text" class="form-input" id="username" name="username" 
                                       value="${username != null ? username : ''}" 
                                       placeholder="Nhập tên đăng nhập" required>
                                <i class="fas fa-at input-icon"></i>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="email" class="form-label">Email</label>
                            <div class="input-wrapper">
                                <input type="email" class="form-input" id="email" name="email" 
                                       value="${email != null ? email : ''}" 
                                       placeholder="Nhập địa chỉ email" required>
                                <i class="fas fa-paper-plane input-icon"></i>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="password" class="form-label">Mật khẩu</label>
                            <div class="input-wrapper">
                                <input type="password" class="form-input" id="password" name="password" 
                                       value="${password != null ? password : ''}" 
                                       placeholder="Nhập mật khẩu" required minlength="6">
                                <i class="fas fa-key input-icon"></i>
                                <button type="button" class="password-toggle" onclick="togglePassword('password')">
                                    <i class="fas fa-eye" id="password-eye"></i>
                                </button>
                            </div>
                        </div>

                        <div class="form-group full-width">
                            <label for="address" class="form-label">Địa chỉ</label>
                            <div class="input-wrapper">
                                <input type="text" class="form-input" id="address" name="address" 
                                       value="${address != null ? address : ''}" 
                                       placeholder="Nhập địa chỉ đầy đủ" required>
                                <i class="fas fa-home input-icon"></i>
                            </div>
                        </div>
                    </div>

                    <div class="button-group">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-user-plus"></i> Thêm Bệnh Nhân
                        </button>
                        <button type="button" class="btn btn-secondary" onclick="window.history.back()">
                            <i class="fas fa-arrow-left"></i> Quay Lại
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Footer -->
        <footer>
            <div class="footer-content">
                <p>&copy; 2025 Hệ Thống Quản Lý Bệnh Nhân. All rights reserved.</p>
                <div class="footer-links">
                    <a href="#">Chính Sách Bảo Mật</a>
                    <a href="#">Điều Khoản Sử Dụng</a>
                    <a href="#">Liên Hệ</a>
                </div>
                <div class="footer-social">
                    <a href="#"><i class="fab fa-facebook-f"></i></a>
                    <a href="#"><i class="fab fa-twitter"></i></a>
                    <a href="#"><i class="fab fa-linkedin-in"></i></a>
                </div>
            </div>
        </footer>

        <script>
            function togglePassword(id) {
                const input = document.getElementById(id);
                const eye = document.getElementById(id + '-eye');
                if (input.type === 'password') {
                    input.type = 'text';
                    eye.classList.remove('fa-eye');
                    eye.classList.add('fa-eye-slash');
                } else {
                    input.type = 'password';
                    eye.classList.remove('fa-eye-slash');
                    eye.classList.add('fa-eye');
                }
            }
        </script>
    </body>
</html>
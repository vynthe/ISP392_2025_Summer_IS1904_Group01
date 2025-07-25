<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa hồ sơ bệnh nhân</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', sans-serif;
            background-color: #f8fafc;
            color: #1f2937;
            line-height: 1.6;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        /* Header */
        .header {
            background-color: #1f2937;
            color: white;
            padding: 0;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .header-content {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 16px 24px;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 18px;
            font-weight: 600;
        }

        .logo i {
            font-size: 20px;
            color: #3b82f6;
        }

        .nav-menu {
            display: flex;
            list-style: none;
            gap: 32px;
        }

        .nav-menu a {
            color: #d1d5db;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            padding: 8px 12px;
            border-radius: 6px;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .nav-menu a:hover,
        .nav-menu a.active {
            color: white;
            background-color: rgba(59, 130, 246, 0.1);
        }

        /* Main Content */
        .main-content {
            flex: 1;
            padding: 40px 24px;
            display: flex;
            justify-content: center;
        }

        .container {
            width: 100%;
            max-width: 600px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .header-section {
            background-color: #f9fafb;
            padding: 32px;
            text-align: center;
            border-bottom: 1px solid #e5e7eb;
        }

        .header-section i {
            font-size: 48px;
            color: #6b7280;
            margin-bottom: 12px;
        }

        .header-section h1 {
            font-size: 24px;
            font-weight: 700;
            color: #111827;
            margin-bottom: 4px;
        }

        .header-section p {
            color: #6b7280;
            font-size: 14px;
        }

        .form-content {
            padding: 32px;
        }

        /* Alert Messages */
        .alert {
            padding: 12px 16px;
            margin-bottom: 24px;
            border-radius: 6px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .alert-success {
            background-color: #f0fdf4;
            color: #166534;
            border: 1px solid #bbf7d0;
        }

        .alert-error {
            background-color: #fef2f2;
            color: #991b1b;
            border: 1px solid #fecaca;
        }

        /* Form Styles */
        .form-section {
            margin-bottom: 32px;
        }

        .section-title {
            font-size: 16px;
            font-weight: 600;
            color: #374151;
            margin-bottom: 16px;
            padding-bottom: 8px;
            border-bottom: 1px solid #e5e7eb;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-bottom: 16px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-label {
            font-size: 13px;
            font-weight: 500;
            color: #374151;
            margin-bottom: 6px;
        }

        .required {
            color: #dc2626;
        }

        .form-input,
        .form-select {
            padding: 10px 12px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 14px;
            background-color: white;
            transition: border-color 0.2s ease;
        }

        .form-input:focus,
        .form-select:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        .form-select {
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='m6 8 4 4 4-4'/%3e%3c/svg%3e");
            background-position: right 8px center;
            background-repeat: no-repeat;
            background-size: 16px;
            padding-right: 36px;
        }

        /* Buttons */
        .button-group {
            display: flex;
            gap: 12px;
            margin-top: 24px;
        }

        .btn {
            flex: 1;
            padding: 12px 20px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
            text-decoration: none;
            text-align: center;
            cursor: pointer;
            border: none;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
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
            border: 1px solid #d1d5db;
        }

        .btn-secondary:hover {
            background-color: #e5e7eb;
        }

        /* Footer */
        .footer {
            background-color: #111827;
            color: #d1d5db;
            padding: 32px 0 16px;
            margin-top: auto;
        }

        .footer-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 24px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 32px;
        }

        .footer-section h4 {
            font-size: 14px;
            font-weight: 600;
            color: white;
            margin-bottom: 12px;
        }

        .footer-section p {
            font-size: 13px;
            line-height: 1.5;
            margin-bottom: 8px;
        }

        .footer-section ul {
            list-style: none;
        }

        .footer-section ul li {
            margin-bottom: 6px;
        }

        .footer-section a {
            color: #d1d5db;
            text-decoration: none;
            font-size: 13px;
            transition: color 0.2s ease;
        }

        .footer-section a:hover {
            color: white;
        }

        .footer-bottom {
            border-top: 1px solid #374151;
            margin-top: 24px;
            padding-top: 16px;
            text-align: center;
        }

        .footer-bottom p {
            font-size: 12px;
            color: #9ca3af;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .header-content {
                flex-direction: column;
                gap: 16px;
            }

            .nav-menu {
                gap: 16px;
                flex-wrap: wrap;
                justify-content: center;
            }

            .main-content {
                padding: 24px 16px;
            }

            .container {
                max-width: 100%;
            }

            .header-section,
            .form-content {
                padding: 24px;
            }

            .form-row {
                grid-template-columns: 1fr;
                gap: 12px;
            }

            .button-group {
                flex-direction: column;
            }

            .footer-content {
                grid-template-columns: 1fr;
                gap: 24px;
                text-align: center;
            }
        }

        @media (max-width: 480px) {
            .nav-menu {
                display: none;
            }

            .header-section h1 {
                font-size: 20px;
            }

            .header-section i {
                font-size: 36px;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="header-content">
            <div class="logo">
                <i class="fas fa-tooth"></i>
                <span>Nha Khoa PDC</span>
            </div>
            <nav>
                <ul class="nav-menu">
                    <li><a href="${pageContext.request.contextPath}/views/user/Patient/PatientDashBoard.jsp">Trang Chủ</a></li>
                    <li><a href="${pageContext.request.contextPath}/UserProfileController">Hồ Sơ</a></li>
                    <li><a href="${pageContext.request.contextPath}/EditProfileUserController" class="active">Chỉnh Sửa</a></li>
                </ul>
            </nav>
        </div>
    </header>

    <!-- Main Content -->
    <main class="main-content">
        <div class="container">
            <div class="header-section">
                <i class="fas fa-user-edit"></i>
                <h1>Chỉnh sửa hồ sơ</h1>
                <p>Cập nhật thông tin cá nhân của bạn</p>
            </div>

            <div class="form-content">
                <c:if test="${not empty success}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        ${success}
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-triangle"></i>
                        ${error}
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/EditProfileUserController" method="post">
                    <input type="hidden" name="userID" value="${sessionScope.user.userID}">

                    <div class="form-section">
                        <div class="section-title">Thông tin cá nhân</div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label" for="username">
                                    Tên đăng nhập <span class="required">*</span>
                                </label>
                                <input type="text" id="username" name="username" value="${sessionScope.user.username}" class="form-input" required>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="dob">
                                    Ngày sinh <span class="required">*</span>
                                </label>
                                <input type="date" id="dob" name="dob" value="${sessionScope.user.dob}" class="form-input" required>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label" for="gender">
                                    Giới tính <span class="required">*</span>
                                </label>
                                <select id="gender" name="gender" class="form-select" required>
                                    <option value="">Chọn giới tính</option>
                                    <option value="Male" ${sessionScope.user.gender == 'Male' ? 'selected' : ''}>Nam</option>
                                    <option value="Female" ${sessionScope.user.gender == 'Female' ? 'selected' : ''}>Nữ</option>
                                    <option value="Other" ${sessionScope.user.gender == 'Other' ? 'selected' : ''}>Khác</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="phone">
                                    Số điện thoại <span class="required">*</span>
                                </label>
                                <input type="tel" id="phone" name="phone" value="${sessionScope.user.phone}" class="form-input" required>
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="section-title">Thông tin liên hệ</div>
                        
                        <div class="form-group">
                            <label class="form-label" for="email">
                                Email <span class="required">*</span>
                            </label>
                            <input type="email" id="email" name="email" value="${sessionScope.user.email}" class="form-input" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="address">
                                Địa chỉ <span class="required">*</span>
                            </label>
                            <input type="text" id="address" name="address" value="${sessionScope.user.address}" class="form-input" required>
                        </div>
                    </div>

                    <div class="button-group">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i>
                            Cập nhật
                        </button>
                        <a href="${pageContext.request.contextPath}/views/user/Patient/PatientDashBoard.jsp" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i>
                            Quay lại
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="footer">
        <div class="footer-content">
            <div class="footer-section">
                <h4>Nha Khoa PDC</h4>
                <p>Chăm sóc sức khỏe răng miệng với chất lượng cao và dịch vụ tận tâm.</p>
            </div>
            
            <div class="footer-section">
                <h4>Liên kết</h4>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/views/user/Patient/PatientDashBoard.jsp">Trang Chủ</a></li>
                    <li><a href="${pageContext.request.contextPath}/PatientProfileController">Hồ Sơ</a></li>
                    <li><a href="${pageContext.request.contextPath}/EditProfileUserController">Chỉnh Sửa</a></li>
                </ul>
            </div>
            
            <div class="footer-section">
                <h4>Liên hệ</h4>
                <p>Email: PhongKhamPDC@gmail.com</p>
                <p>Hotline: 0987 123 456</p>
            </div>
        </div>
        
        <div class="footer-bottom">
            <p>© 2025 Nha Khoa PDC. Tất cả quyền được bảo lưu.</p>
        </div>
    </footer>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.querySelector('form');
            const submitBtn = document.querySelector('.btn-primary');
            const originalText = submitBtn.innerHTML;

            form.addEventListener('submit', function() {
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang cập nhật...';
                submitBtn.disabled = true;
            });

            // Auto-hide alerts
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                setTimeout(() => {
                    alert.style.transition = 'opacity 0.3s ease';
                    alert.style.opacity = '0';
                    setTimeout(() => alert.remove(), 300);
                }, 5000);
            });
        });
    </script>
</body>
</html>
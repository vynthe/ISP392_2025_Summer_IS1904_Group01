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
                padding: 0;
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }

            /* Header Styles */
            .header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 20px 0;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }

            .header-content {
                max-width: 1200px;
                margin: 0 auto;
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 0 20px;
            }

            .logo {
                font-size: 1.5rem;
                font-weight: bold;
            }

            .nav-menu {
                display: flex;
                list-style: none;
                margin: 0;
                padding: 0;
                gap: 30px;
            }

            .nav-menu a {
                color: white;
                text-decoration: none;
                transition: color 0.3s;
            }

            .nav-menu a:hover {
                color: #ffd700;
            }

            /* Main Content */
            .main-content {
                flex: 1;
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

            /* Footer Styles */
            .footer {
                background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
                color: white;
                padding: 20px 0;
                margin-top: auto;
            }

            .footer-content {
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 20px;
                display: flex;
                flex-wrap: wrap;
                justify-content: space-between;
                align-items: flex-start;
                gap: 20px;
            }

            .footer-section {
                flex: 1;
                min-width: 200px;
            }

            .footer-section h4 {
                margin-bottom: 15px;
                font-size: 1.1rem;
                color: #ecf0f1;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .footer-section p, .footer-section a {
                margin: 8px 0;
                color: #bdc3c7;
                font-size: 0.9rem;
                text-decoration: none;
            }

            .footer-section a:hover {
                color: #ffd700;
            }

            .footer-section ul {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .footer-section ul li {
                margin-bottom: 8px;
            }

            .footer-bottom {
                border-top: 1px solid #34495e;
                padding-top: 15px;
                margin-top: 20px;
                text-align: center;
                color: #95a5a6;
                font-size: 0.85rem;
            }

            @media (max-width: 600px) {
                .button-group {
                    flex-direction: column;
                }

                .header-content {
                    flex-direction: column;
                    gap: 15px;
                }

                .nav-menu {
                    gap: 15px;
                }

                .footer-content {
                    flex-direction: column;
                    text-align: center;
                }

                .footer-section {
                    min-width: 100%;
                }
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <header class="header">
            <div class="header-content">
                <div class="logo">
                    <i class="fas fa-shield-alt"></i> Admin
                </div>
                <nav>
                    <ul class="nav-menu">
                        <li><a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp"><i class="fas fa-tachometer-alt"></i>Trang Chủ</a></li>
                        <li><a href="${pageContext.request.contextPath}/AdminProfileController"><i class="fas fa-user"></i> Hồ sơ</a></li>
                        <li><a href="${pageContext.request.contextPath}/EditProfileAdminController"><i class="fas fa-cog"></i> Chỉnh Sửa Hồ Sơ</a></li>
                    </ul>
                </nav>
            </div>
        </header>

        <!-- Main Content -->
        <main class="main-content">
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
        </main>

        <!-- Footer -->
        <footer class="footer">
            <div class="footer-content">
                <div class="footer-section">
                    <h4><i class="fas fa-info-circle"></i> Về Chúng Tôi</h4>
                    <p>Chúng tôi cam kết mang đến dịch vụ y tế chất lượng với đội ngũ bác sĩ tận tâm và hệ thống quản lý hiện đại.</p>
                </div>
                <div class="footer-section">
                    <h4><i class="fas fa-link"></i> Liên Kết Nhanh</h4>
                    <ul>
                        <li><a href="/views/admin/dashboard.jsp">Trang Chủ</a></li>
                        <li><a href="/AdminProfileController">Hồ Sơ</a></li>
                        <li><a href="/EditProfileAdminController">Chỉnh Sửa Hồ Sơ</a></li>
                 
                    </ul>
                </div>
                <div class="footer-section">
                    <h4><i class="fas fa-phone"></i> Liên Hệ</h4>
                    <p>Email: PhongKhamPDC@gmail.com</p>
                    <p>Hotline: 0987 123 456</p>
                </div>
            </div>
            <div class="footer-bottom">
                            <p>© 2025 Nha Khoa PDC. Đạt chuẩn Bộ Y tế. Tất cả quyền được bảo lưu.</p>
            </div>
        </footer>
    </body>
</html>
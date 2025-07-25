<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.entity.Admins"%> 
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa hồ sơ Admin - HealthCare System</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #f4f7fc;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* Header Styles */
        .main-header {
            background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%);
            color: white;
            padding: 0;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .header-main {
            padding: 20px 0;
        }

        .header-main .container {
            max-width: 1280px;
            margin: 0 auto;
            padding: 0 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 26px;
            font-weight: 700;
            text-decoration: none;
            color: white;
        }

        .logo i {
            font-size: 36px;
            background: rgba(255, 255, 255, 0.15);
            padding: 12px;
            border-radius: 50%;
        }

        .nav-menu {
            display: flex;
            list-style: none;
            gap: 24px;
        }

        .nav-menu a {
            color: white;
            text-decoration: none;
            font-weight: 500;
            font-size: 16px;
            padding: 10px 16px;
            border-radius: 8px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .nav-menu a:hover {
            background: rgba(255, 255, 255, 0.15);
            transform: translateY(-2px);
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .user-avatar {
            width: 44px;
            height: 44px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.15);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
        }

        .user-info {
            display: flex;
            flex-direction: column;
        }

        .user-name {
            font-weight: 600;
            font-size: 15px;
        }

        .user-role {
            font-size: 13px;
            opacity: 0.7;
        }

        /* Main Content */
        .content-wrapper {
            flex: 1;
            padding: 48px 24px;
        }

        .main-container {
            max-width: 720px;
            margin: 0 auto;
            background: white;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
            overflow: hidden;
            animation: fadeIn 0.5s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .page-header {
            background: #ffffff;
            padding: 32px;
            text-align: center;
            border-bottom: 1px solid #e5e7eb;
        }

        .page-header h1 {
            font-size: 28px;
            font-weight: 700;
            color: #1e3a8a;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
        }

        .page-header p {
            font-size: 16px;
            color: #6b7280;
            max-width: 500px;
            margin: 0 auto;
        }

        .form-container {
            padding: 32px;
        }

        .alert {
            padding: 16px 24px;
            margin-bottom: 24px;
            border-radius: 8px;
            font-weight: 500;
            font-size: 15px;
            display: flex;
            align-items: center;
            gap: 12px;
            animation: slideIn 0.4s ease-out;
        }

        .alert.success {
            background: #ecfdf5;
            color: #065f46;
            border: 1px solid #6ee7b7;
        }

        .alert.error {
            background: #fef2f2;
            color: #991b1b;
            border: 1px solid #f87171;
        }

        @keyframes slideIn {
            from { opacity: 0; transform: translateX(-20px); }
            to { opacity: 1; transform: translateX(0); }
        }

        .form-group {
            margin-bottom: 24px;
        }

        .form-group label {
            display: block;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 8px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .form-group input {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            font-size: 15px;
            transition: all 0.2s ease;
            background: #f9fafb;
        }

        .form-group input:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
            background: white;
        }

        .form-group input:hover {
            border-color: #9ca3af;
        }

        .required {
            color: #ef4444;
            font-size: 14px;
        }

        .button-group {
            display: flex;
            gap: 16px;
            margin-top: 32px;
            justify-content: center;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            position: relative;
            overflow: hidden;
            min-width: 160px;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
            transition: left 0.5s;
        }

        .btn:hover::before {
            left: 100%;
        }

        .btn-primary {
            background: #3b82f6;
            color: white;
        }

        .btn-primary:hover {
            background: #2563eb;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
        }

        .btn-secondary {
            background: #e5e7eb;
            color: #374151;
        }

        .btn-secondary:hover {
            background: #d1d5db;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        /* Footer Styles */
        .main-footer {
            background: #1f2937;
            color: white;
            margin-top: auto;
        }

        .footer-main {
            padding: 48px 0 32px;
        }

        .footer-main .container {
            max-width: 1280px;
            margin: 0 auto;
            padding: 0 24px;
        }

        .footer-content {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr 1fr;
            gap: 32px;
            margin-bottom: 40px;
        }

        .footer-section h3 {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 16px;
            color: #60a5fa;
        }

        .footer-section p {
            line-height: 1.6;
            font-size: 14px;
            opacity: 0.9;
        }

        .contact-info {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 16px;
            font-size: 14px;
        }

        .contact-info i {
            width: 20px;
            color: #60a5fa;
        }

        .footer-bottom {
            border-top: 1px solid #374151;
            padding: 24px 0;
            text-align: center;
        }

        .footer-bottom .container {
            max-width: 1280px;
            margin: 0 auto;
            padding: 0 24px;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .copyright {
            font-size: 14px;
            opacity: 0.8;
        }

        /* Mobile Responsiveness */
        @media (max-width: 768px) {
            .header-main .container {
                flex-direction: column;
                gap: 16px;
            }

            .nav-menu {
                flex-direction: column;
                gap: 8px;
                width: 100%;
                align-items: center;
            }

            .button-group {
                flex-direction: column;
                gap: 12px;
            }

            .btn {
                min-width: 100%;
            }

            .form-container {
                padding: 24px;
            }

            .content-wrapper {
                padding: 24px 16px;
            }

            .footer-content {
                grid-template-columns: 1fr;
                gap: 24px;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="main-header">
        <div class="header-main">
            <div class="container">
                <a href="#" class="logo">
                    <i class="fas fa-heartbeat"></i>
                    <span>Phòng Khám Nha Khoa PDC</span>
                </a>
                <nav>
                    <ul class="nav-menu">
                        <li><a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp"><i class="fas fa-home"></i> Trang chủ</a></li>
                        <li><a href="${pageContext.request.contextPath}/AdminProfileController"><i class="fas fa-user-shield"></i> Xem Hồ Sơ</a></li>
                        <li><a href="${pageContext.request.contextPath}/EditProfileAdminController"><i class="fas fa-user-edit"></i> Chỉnh Sửa Hồ Sơ</a></li>
                    </ul>
                </nav>
                <div class="user-profile">
                    <div class="user-avatar">
                        <i class="fas fa-user-shield"></i>
                    </div>
                    <div class="user-info">
                        <div class="user-name">${sessionScope.admin.username}</div>
                        <div class="user-role">Admin</div>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <div class="content-wrapper">
        <div class="main-container">
            <div class="page-header">
                <h1>
                    <i class="fas fa-user-edit"></i>
                    Chỉnh sửa hồ sơ Admin
                </h1>
                <p>Cập nhật thông tin cá nhân của bạn một cách dễ dàng và bảo mật</p>
            </div>

            <div class="form-container">
                <c:if test="${not empty success}">
                    <div class="alert success">
                        <i class="fas fa-check-circle"></i>
                        ${success}
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert error">
                        <i class="fas fa-exclamation-circle"></i>
                        ${error}
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
                        <label for="username">
                            <i class="fas fa-user"></i>
                            Tên đăng nhập <span class="required">*</span>
                        </label>
                        <input type="text" id="username" name="username" value="${admin.username}" required>
                    </div>

                    <div class="form-group">
                        <label for="fullName">
                            <i class="fas fa-id-card"></i>
                            Họ và tên <span class="required">*</span>
                        </label>
                        <input type="text" id="fullName" name="fullName" value="${admin.fullName}" required>
                    </div>

                    <div class="form-group">
                        <label for="email">
                            <i class="fas fa-envelope"></i>
                            Email <span class="required">*</span>
                        </label>
                        <input type="email" id="email" name="email" value="${admin.email}" required>
                    </div>

                    <div class="button-group">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i>
                            Lưu thay đổi
                        </button>
                        <a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i>
                            Quay lại
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="main-footer">
        <div class="footer-main">
            <div class="container">
                <div class="footer-content">
                    <div class="footer-section">
                        <h3>Về Chúng Tôi</h3>
                        <p>Chúng tôi là phòng khám nha khoa hàng đầu, cam kết mang lại nụ cười khỏe mạnh và tự tin với công nghệ tiên tiến và đội ngũ chuyên gia giàu kinh nghiệm.</p>                      
                    </div>
                    <div class="footer-section">
                        <h3>Liên hệ</h3>
                        <div class="contact-info">
                            <i class="fas fa-map-marker-alt"></i>
                            <span>ĐH FPT, Hòa Lạc</span>
                        </div>
                        <div class="contact-info">
                            <i class="fas fa-phone"></i>
                            <span>0981 234 567</span>
                        </div>
                        <div class="contact-info">
                            <i class="fas fa-envelope"></i>
                            <span>PhongKhamPDC@gmail.com</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="footer-bottom">
            <div class="container">
                <div class="copyright">
                    <p>© 2025 Nha Khoa PDC. Đạt chuẩn Bộ Y tế. Tất cả quyền được bảo lưu.</p>
                </div>
            </div>
        </div>
    </footer>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const inputs = document.querySelectorAll('input');
            
            inputs.forEach(input => {
                input.addEventListener('focus', function() {
                    this.parentElement.style.transform = 'translateY(-2px)';
                });
                
                input.addEventListener('blur', function() {
                    this.parentElement.style.transform = 'translateY(0)';
                });

                input.addEventListener('input', function() {
                    if (this.checkValidity()) {
                        this.style.borderColor = '#10b981';
                    } else {
                        this.style.borderColor = '#ef4444';
                    }
                });
            });

            const form = document.querySelector('form');
            const submitBtn = document.querySelector('.btn-primary');
            
            form.addEventListener('submit', function(e) {
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang cập nhật...';
                submitBtn.disabled = true;
            });

            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                setTimeout(() => {
                    alert.style.animation = 'fadeOut 0.5s ease-out forwards';
                    setTimeout(() => alert.remove(), 500);
                }, 5000);
            });

            const style = document.createElement('style');
            style.textContent = `
                @keyframes fadeOut {
                    from { opacity: 1; transform: translateY(0); }
                    to { opacity: 0; transform: translateY(-10px); }
                }
            `;
            document.head.appendChild(style);

            document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                anchor.addEventListener('click', function(e) {
                    e.preventDefault();
                    const target = document.querySelector(this.getAttribute('href'));
                    if (target) {
                        target.scrollIntoView({
                            behavior: 'smooth',
                            block: 'start'
                        });
                    }
                });
            });

            let lastScrollTop = 0;
            const header = document.querySelector('.main-header');
            
            window.addEventListener('scroll', function() {
                let scrollTop = window.pageYOffset || document.documentElement.scrollTop;
                
                if (scrollTop > lastScrollTop && scrollTop > 100) {
                    header.style.transform = 'translateY(-100%)';
                } else {
                    header.style.transform = 'translateY(0)';
                }
                
                lastScrollTop = scrollTop <= 0 ? 0 : scrollTop;
            });

            document.querySelectorAll('.btn').forEach(btn => {
                btn.addEventListener('click', function(e) {
                    if (this.type !== 'submit') return;
                    
                    const originalText = this.innerHTML;
                    this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
                    this.disabled = true;
                    
                    setTimeout(() => {
                        this.innerHTML = originalText;
                        this.disabled = false;
                    }, 3000);
                });
            });

            const emailInput = document.getElementById('email');
            if (emailInput) {
                emailInput.addEventListener('input', function() {
                    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                    if (!emailRegex.test(this.value) && this.value.length > 0) {
                        this.setCustomValidity('Vui lòng nhập địa chỉ email hợp lệ');
                    } else {
                        this.setCustomValidity('');
                    }
                });
            }

            const observerOptions = {
                threshold: 0.1,
                rootMargin: '0px 0px -50px 0px'
            };

            const observer = new IntersectionObserver(function(entries) {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.animation = 'fadeInUp 0.6s ease-out forwards';
                    }
                });
            }, observerOptions);

            document.querySelectorAll('.footer-section').forEach(section => {
                observer.observe(section);
            });

            function createRipple(event) {
                const button = event.currentTarget;
                const circle = document.createElement('span');
                const diameter = Math.max(button.clientWidth, button.clientHeight);
                const radius = diameter / 2;

                circle.style.width = circle.style.height = `${diameter}px`;
                circle.style.left = `${event.clientX - button.offsetLeft - radius}px`;
                circle.style.top = `${event.clientY - button.offsetTop - radius}px`;
                circle.classList.add('ripple');

                const ripple = button.getElementsByClassName('ripple')[0];
                if (ripple) {
                    ripple.remove();
                }

                button.appendChild(circle);
            }

            document.querySelectorAll('.btn').forEach(btn => {
                btn.addEventListener('click', createRipple);
            });

            const rippleStyle = document.createElement('style');
            rippleStyle.textContent = `
                .btn {
                    position: relative;
                    overflow: hidden;
                }
                
                .ripple {
                    position: absolute;
                    border-radius: 50%;
                    background-color: rgba(255, 255, 255, 0.5);
                    transform: scale(0);
                    animation: ripple-animation 0.6s linear;
                    pointer-events: none;
                }
                
                @keyframes ripple-animation {
                    to {
                        transform: scale(4);
                        opacity: 0;
                    }
                }
                
                @keyframes fadeInUp {
                    from {
                        opacity: 0;
                        transform: translateY(20px);
                    }
                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }
                
                .main-header {
                    transition: transform 0.3s ease-in-out;
                }
                
                @media (prefers-reduced-motion: reduce) {
                    * {
                        animation-duration: 0.01ms !important;
                        animation-iteration-count: 1 !important;
                        transition-duration: 0.01ms !important;
                    }
                }
            `;
            document.head.appendChild(rippleStyle);
        });
    </script>
</body>
</html>
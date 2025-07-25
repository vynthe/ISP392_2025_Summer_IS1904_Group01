<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa hồ sơ bệnh nhân - HealthCare System</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8fafc;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* Header Styles */
        .main-header {
            background: linear-gradient(135deg, #0288d1 0%, #0277bd 100%);
            color: white;
            padding: 0;
            box-shadow: 0 4px 12px rgba(2, 136, 209, 0.2);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .header-top {
            background: rgba(255, 255, 255, 0.1);
            padding: 8px 0;
            font-size: 14px;
        }

        .header-top .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header-info {
            display: flex;
            gap: 30px;
        }

        .header-info span {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .header-main {
            padding: 15px 0;
        }

        .header-main .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 15px;
            font-size: 24px;
            font-weight: 700;
            text-decoration: none;
            color: white;
        }

        .logo i {
            font-size: 32px;
            background: rgba(255, 255, 255, 0.2);
            padding: 10px;
            border-radius: 50%;
        }

        .nav-menu {
            display: flex;
            list-style: none;
            gap: 30px;
        }

        .nav-menu a {
            color: white;
            text-decoration: none;
            font-weight: 500;
            padding: 10px 15px;
            border-radius: 8px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .nav-menu a:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: translateY(-2px);
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
        }

        .user-info {
            display: flex;
            flex-direction: column;
        }

        .user-name {
            font-weight: 600;
            font-size: 14px;
        }

        .user-role {
            font-size: 12px;
            opacity: 0.8;
        }

        /* Main Content */
        .content-wrapper {
            flex: 1;
            padding: 40px 20px;
        }

        .main-container {
            width: 100%;
            max-width: 600px;
            margin: 0 auto;
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            overflow: hidden;
            animation: slideUp 0.8s ease-out;
        }

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

        .page-header {
            background: linear-gradient(135deg, #e0f2fe 0%, #b3e5fc 100%);
            color: #0277bd;
            padding: 30px;
            text-align: center;
            position: relative;
            border-bottom: 1px solid #e1f5fe;
        }

        .page-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="50" cy="50" r="1" fill="white" opacity="0.1"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
            opacity: 0.3;
        }

        .header-content {
            position: relative;
            z-index: 1;
        }

        .page-header h1 {
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
        }

        .page-header p {
            font-size: 16px;
            opacity: 0.9;
        }

        .form-container {
            padding: 40px;
        }

        .alert {
            padding: 15px 20px;
            margin-bottom: 25px;
            border-radius: 12px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: fadeIn 0.5s ease-out;
        }

        .alert.success {
            background: linear-gradient(135deg, #d4edda, #c3e6cb);
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert.error {
            background: linear-gradient(135deg, #f8d7da, #f5c6cb);
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-group {
            position: relative;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-group label {
            display: block;
            font-weight: 600;
            color: #374151;
            margin-bottom: 8px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            font-size: 16px;
            transition: all 0.3s ease;
            background: #ffffff;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #0288d1;
            box-shadow: 0 0 0 3px rgba(2, 136, 209, 0.1);
            transform: translateY(-1px);
        }

        .form-group input:hover,
        .form-group select:hover {
            border-color: #d1d5db;
        }

        .form-group select {
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='m6 8 4 4 4-4'/%3e%3c/svg%3e");
            background-position: right 12px center;
            background-repeat: no-repeat;
            background-size: 16px;
        }

        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
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
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            position: relative;
            overflow: hidden;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.5s;
        }

        .btn:hover::before {
            left: 100%;
        }

        .btn-primary {
            background: linear-gradient(135deg, #0288d1, #0277bd);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(2, 136, 209, 0.3);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #90a4ae, #78909c);
            color: white;
        }

        .btn-secondary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(120, 144, 156, 0.3);
        }

        .form-divider {
            height: 1px;
            background: linear-gradient(90deg, transparent, #e5e7eb, transparent);
            margin: 30px 0;
        }

        .section-title {
            font-size: 18px;
            font-weight: 600;
            color: #374151;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .required {
            color: #ef4444;
        }

        /* Footer Styles */
        .main-footer {
            background: #2c3e50;
            color: white;
            margin-top: auto;
        }

        .footer-main {
            padding: 50px 0 30px;
        }

        .footer-main .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .footer-content {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr 1fr;
            gap: 40px;
            margin-bottom: 40px;
        }

        .footer-section h3 {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 20px;
            color: #3498db;
        }

        .footer-section p {
            line-height: 1.6;
            margin-bottom: 15px;
            opacity: 0.9;
        }

        .footer-links {
            list-style: none;
        }

        .footer-links li {
            margin-bottom: 12px;
        }

        .footer-links a {
            color: white;
            text-decoration: none;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            opacity: 0.9;
        }

        .footer-links a:hover {
            color: #3498db;
            transform: translateX(5px);
        }

        .contact-info {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 15px;
        }

        .contact-info i {
            width: 20px;
            color: #3498db;
        }

        .social-links {
            display: flex;
            gap: 15px;
            margin-top: 20px;
        }

        .social-links a {
            width: 40px;
            height: 40px;
            background: #3498db;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }

        .social-links a:hover {
            background: #2980b9;
            transform: translateY(-3px);
        }

        .footer-bottom {
            border-top: 1px solid #34495e;
            padding: 20px 0;
            text-align: center;
        }

        .footer-bottom .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .copyright {
            opacity: 0.8;
        }

        .footer-nav {
            display: flex;
            gap: 30px;
        }

        .footer-nav a {
            color: white;
            text-decoration: none;
            opacity: 0.8;
            transition: all 0.3s ease;
        }

        .footer-nav a:hover {
            opacity: 1;
            color: #3498db;
        }

        /* Mobile Responsiveness */
        @media (max-width: 768px) {
            .header-top {
                display: none;
            }

            .header-main .container {
                flex-direction: column;
                gap: 20px;
            }

            .nav-menu {
                flex-direction: column;
                gap: 10px;
                width: 100%;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }
            
            .button-group {
                flex-direction: column;
            }
            
            .btn {
                min-width: auto;
            }

            .form-container {
                padding: 30px 20px;
            }

            .content-wrapper {
                padding: 20px 10px;
            }

            .footer-content {
                grid-template-columns: 1fr;
                gap: 30px;
            }

            .footer-bottom .container {
                flex-direction: column;
                gap: 15px;
            }

            .footer-nav {
                flex-wrap: wrap;
                justify-content: center;
                gap: 15px;
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
                        <li><a href="${pageContext.request.contextPath}/views/user/Patient/PatientDashBoard.jsp"><i class="fas fa-home"></i> Trang chủ</a></li>
                        <li><a href="${pageContext.request.contextPath}/UserProfileController"><i class="fas fa-calendar-check"></i> Xem Hồ Sơ</a></li>
                        <li><a href="${pageContext.request.contextPath}/EditProfileUserController"><i class="fas fa-file-medical-alt"></i>Chỉnh Sửa Hồ Sơ</a></li>
                    </ul>
                </nav>
                <div class="user-profile">
                    <div class="user-avatar">
                        <i class="fas fa-user"></i>
                    </div>
                    <div class="user-info">
                        <div class="user-name">${sessionScope.user.username}</div>
                        <div class="user-role">Bệnh nhân</div>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <div class="content-wrapper">
        <div class="main-container">
            <div class="page-header">
                <div class="header-content">
                    <h1>
                        <i class="fas fa-user-edit"></i>
                        Chỉnh sửa hồ sơ
                    </h1>
                    <p>Cập nhật thông tin cá nhân của bạn</p>
                </div>
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

                <form action="${pageContext.request.contextPath}/EditProfileUserController" method="post">
                    <input type="hidden" name="userID" value="${sessionScope.user.userID}">
                   
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="username">
                                <i class="fas fa-user"></i>
                                Tên đăng nhập <span class="required">*</span>
                            </label>
                            <input type="text" id="username" name="username" value="${sessionScope.user.username}" required>
                        </div>

                        <div class="form-group">
                            <label for="dob">
                                <i class="fas fa-calendar-alt"></i>
                                Ngày sinh <span class="required">*</span>
                            </label>
                            <input type="date" id="dob" name="dob" value="${sessionScope.user.dob}" required>
                        </div>

                        <div class="form-group">
                            <label for="gender">
                                <i class="fas fa-venus-mars"></i>
                                Giới tính <span class="required">*</span>
                            </label>
                            <select id="gender" name="gender" required>
                                <option value="">Chọn giới tính</option>
                                <option value="Male" ${sessionScope.user.gender == 'Male' ? 'selected' : ''}>Nam</option>
                                <option value="Female" ${sessionScope.user.gender == 'Female' ? 'selected' : ''}>Nữ</option>
                                <option value="Other" ${sessionScope.user.gender == 'Other' ? 'selected' : ''}>Khác</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="phone">
                                <i class="fas fa-phone"></i>
                                Số điện thoại <span class="required">*</span>
                            </label>
                            <input type="tel" id="phone" name="phone" value="${sessionScope.user.phone}" required>
                        </div>
                    </div>

                    <div class="form-divider"></div>

                    <div class="section-title">
                        <i class="fas fa-address-card"></i>
                        Thông tin liên hệ
                    </div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label for="email">
                                <i class="fas fa-envelope"></i>
                                Email <span class="required">*</span>
                            </label>
                            <input type="email" id="email" name="email" value="${sessionScope.user.email}" required>
                        </div>

                        <div class="form-group full-width">
                            <label for="address">
                                <i class="fas fa-map-marker-alt"></i>
                                Địa chỉ <span class="required">*</span>
                            </label>
                            <input type="text" id="address" name="address" value="${sessionScope.user.address}" required>
                        </div>
                    </div>

                    <div class="button-group">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i>
                            Cập nhật thông tin
                        </button>
                        <a href="${pageContext.request.contextPath}/views/user/Patient/PatientDashBoard.jsp" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i>
                            Quay lại trang chủ
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
                            <span>ĐH FPT , Hòa Lạc</span>
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
                    <p>&copy; 2025 Nha Khoa PDC. Đạt chuẩn Bộ Y tế. Tất cả quyền được bảo lưu.</p>
                </div>
            </div>
        </div>
    </footer>

    <script>
        // Add smooth animations and form validation
        document.addEventListener('DOMContentLoaded', function() {
            const inputs = document.querySelectorAll('input, select');
            
            inputs.forEach(input => {
                // Add focus/blur animations
                input.addEventListener('focus', function() {
                    this.parentElement.style.transform = 'translateY(-2px)';
                });
                
                input.addEventListener('blur', function() {
                    this.parentElement.style.transform = 'translateY(0)';
                });

                // Real-time validation feedback
                input.addEventListener('input', function() {
                    if (this.checkValidity()) {
                        this.style.borderColor = '#4caf50';
                    } else {
                        this.style.borderColor = '#f44336';
                    }
                });
            });

            // Form submission with loading state
            const form = document.querySelector('form');
            const submitBtn = document.querySelector('.btn-primary');
            
            form.addEventListener('submit', function(e) {
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang cập nhật...';
                submitBtn.disabled = true;
            });

            // Auto-hide alerts after 5 seconds
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                setTimeout(() => {
                    alert.style.animation = 'fadeOut 0.5s ease-out forwards';
                    setTimeout(() => alert.remove(), 500);
                }, 5000);
            });

            // Mobile menu toggle (if needed)
            const mobileMenuBtn = document.querySelector('.mobile-menu-btn');
            const navMenu = document.querySelector('.nav-menu');
            
            if (mobileMenuBtn) {
                mobileMenuBtn.addEventListener('click', function() {
                    navMenu.classList.toggle('active');
                });
            }
        });

        // Add fadeOut animation
        const style = document.createElement('style');
        style.textContent = `
            @keyframes fadeOut {
                from { opacity: 1; transform: translateY(0); }
                to { opacity: 0; transform: translateY(-10px); }
            }
        `;
        document.head.appendChild(style);

        // Smooth scroll for anchor links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
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

        // Header scroll effect
        let lastScrollTop = 0;
        const header = document.querySelector('.main-header');
        
        window.addEventListener('scroll', function() {
            let scrollTop = window.pageYOffset || document.documentElement.scrollTop;
            
            if (scrollTop > lastScrollTop && scrollTop > 100) {
                // Scrolling down
                header.style.transform = 'translateY(-100%)';
            } else {
                // Scrolling up
                header.style.transform = 'translateY(0)';
            }
            
            lastScrollTop = scrollTop <= 0 ? 0 : scrollTop;
        });

        // Add loading animation to buttons
        document.querySelectorAll('.btn').forEach(btn => {
            btn.addEventListener('click', function(e) {
                if (this.type !== 'submit') return;
                
                const originalText = this.innerHTML;
                this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
                this.disabled = true;
                
                // Re-enable after form submission or timeout
                setTimeout(() => {
                    this.innerHTML = originalText;
                    this.disabled = false;
                }, 3000);
            });
        });

        // Form field validation with custom messages
        const phoneInput = document.getElementById('phone');
        const emailInput = document.getElementById('email');
        
        if (phoneInput) {
            phoneInput.addEventListener('input', function() {
                const phoneRegex = /^[0-9]{10,11}$/;
                if (!phoneRegex.test(this.value) && this.value.length > 0) {
                    this.setCustomValidity('Số điện thoại phải có 10-11 chữ số');
                } else {
                    this.setCustomValidity('');
                }
            });
        }

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

        // Auto-resize textareas (if any added later)
        function autoResize(textarea) {
            textarea.style.height = 'auto';
            textarea.style.height = textarea.scrollHeight + 'px';
        }

        // Intersection Observer for animations
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

        // Observe footer sections
        document.querySelectorAll('.footer-section').forEach(section => {
            observer.observe(section);
        });

        // Add hover effects to social links
        document.querySelectorAll('.social-links a').forEach(link => {
            link.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-5px) scale(1.1)';
            });
            
            link.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0) scale(1)';
            });
        });

        // Keyboard navigation support
        document.addEventListener('keydown', function(e) {
            // ESC key to close any modals or reset forms
            if (e.key === 'Escape') {
                const alerts = document.querySelectorAll('.alert');
                alerts.forEach(alert => {
                    alert.style.display = 'none';
                });
            }
            
            // Ctrl+S to save form
            if (e.ctrlKey && e.key === 's') {
                e.preventDefault();
                const form = document.querySelector('form');
                if (form) {
                    form.submit();
                }
            }
        });

        // Add ripple effect to buttons
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

        // Add CSS for ripple effect
        const rippleStyle = document.createElement('style');
        rippleStyle.textContent = `
            .btn {
                position: relative;
                overflow: hidden;
            }
            
            .ripple {
                position: absolute;
                border-radius: 50%;
                background-color: rgba(255, 255, 255, 0.6);
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
                    transform: translateY(30px);
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
    </script>
</body>
</html>
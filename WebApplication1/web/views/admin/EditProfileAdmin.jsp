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
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: linear-gradient(135deg, #d2b48c 0%, #deb887 50%, #f5deb3 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            position: relative;
            overflow-x: hidden;
        }

        /* Background Animation */
        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: 
                radial-gradient(circle at 20% 80%, rgba(210, 180, 140, 0.3) 0%, transparent 50%),
                radial-gradient(circle at 80% 20%, rgba(222, 184, 135, 0.3) 0%, transparent 50%),
                radial-gradient(circle at 40% 40%, rgba(245, 222, 179, 0.2) 0%, transparent 50%);
            animation: backgroundFloat 20s ease-in-out infinite;
        }

        @keyframes backgroundFloat {
            0%, 100% { transform: scale(1) rotate(0deg); }
            50% { transform: scale(1.1) rotate(2deg); }
        }

        .container {
            position: relative;
            z-index: 10;
            width: 100%;
            max-width: 450px;
        }

        .profile-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            padding: 0;
            box-shadow: 
                0 25px 50px rgba(0, 0, 0, 0.15),
                0 0 0 1px rgba(255, 255, 255, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.2);
            overflow: hidden;
            transform: translateY(0);
            animation: slideUp 0.8s cubic-bezier(0.16, 1, 0.3, 1);
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(40px) scale(0.95);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        .card-header {
            background: linear-gradient(135deg, #8b7355 0%, #a0845c 100%);
            padding: 32px 24px 24px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .card-header::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent, rgba(255,255,255,0.1), transparent);
            transform: rotate(45deg);
            animation: shimmer 3s linear infinite;
        }

        @keyframes shimmer {
            0% { transform: translateX(-100%) translateY(-100%) rotate(45deg); }
            100% { transform: translateX(100%) translateY(100%) rotate(45deg); }
        }

        .avatar-container {
            position: relative;
            display: inline-block;
            margin-bottom: 16px;
        }

        .avatar {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #cd853f, #daa520);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            color: white;
            border: 4px solid rgba(255, 255, 255, 0.3);
            position: relative;
        }

        .avatar::after {
            content: '';
            position: absolute;
            inset: -4px;
            border-radius: 50%;
            padding: 2px;
            background: linear-gradient(135deg, #cd853f, #daa520, #cd853f);
            mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
            mask-composite: xor;
            animation: borderRotate 3s linear infinite;
        }

        @keyframes borderRotate {
            to { transform: rotate(360deg); }
        }

        .card-title {
            color: white;
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 4px;
            text-shadow: 0 2px 10px rgba(0,0,0,0.2);
        }

        .card-subtitle {
            color: rgba(255, 255, 255, 0.8);
            font-size: 0.9rem;
            font-weight: 500;
        }

        .card-body {
            padding: 32px 24px 24px;
        }

        .alert {
            padding: 12px 16px;
            border-radius: 12px;
            margin-bottom: 20px;
            font-size: 0.875rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
            animation: fadeIn 0.5s ease-out;
        }

        .alert-success {
            background: linear-gradient(135deg, #dcfce7, #bbf7d0);
            color: #166534;
            border: 1px solid #bbf7d0;
        }

        .alert-error {
            background: linear-gradient(135deg, #fef2f2, #fecaca);
            color: #dc2626;
            border: 1px solid #fecaca;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .form-group {
            margin-bottom: 20px;
            position: relative;
        }

        .form-label {
            display: block;
            font-size: 0.875rem;
            font-weight: 600;
            color: #374151;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .form-label i {
            color: #8b7355;
            font-size: 0.875rem;
        }

        .input-container {
            position: relative;
        }

        .form-input {
            width: 100%;
            padding: 14px 48px 14px 16px;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            font-size: 0.95rem;
            background: #fafafa;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            color: #1f2937;
        }

        .form-input:focus {
            outline: none;
            border-color: #8b7355;
            background: white;
            box-shadow: 0 0 0 4px rgba(139, 115, 85, 0.1);
            transform: translateY(-1px);
        }

        .input-icon {
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #9ca3af;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .form-input:focus + .input-icon {
            color: #8b7355;
            transform: translateY(-50%) scale(1.1);
        }

        .invalid-feedback {
            color: #ef4444;
            font-size: 0.75rem;
            margin-top: 6px;
            display: flex;
            align-items: center;
            gap: 4px;
            opacity: 0;
            transform: translateY(-5px);
            transition: all 0.3s ease;
        }

        .invalid-feedback.show {
            opacity: 1;
            transform: translateY(0);
        }

        .button-group {
            display: flex;
            gap: 12px;
            margin-top: 28px;
        }

        .btn {
            flex: 1;
            padding: 14px 20px;
            border: none;
            border-radius: 12px;
            font-size: 0.95rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            text-decoration: none;
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
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }

        .btn:hover::before {
            left: 100%;
        }

        .btn-primary {
            background: linear-gradient(135deg, #8b7355, #a0845c);
            color: white;
            box-shadow: 0 4px 15px rgba(139, 115, 85, 0.3);
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #6f5a42, #8b7355);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(139, 115, 85, 0.4);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #f1f5f9, #e2e8f0);
            color: #475569;
            border: 1px solid #e2e8f0;
        }

        .btn-secondary:hover {
            background: linear-gradient(135deg, #e2e8f0, #cbd5e1);
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        /* Responsive Design */
        @media (max-width: 480px) {
            .container {
                max-width: 100%;
                margin: 0 10px;
            }
            
            .card-body {
                padding: 24px 20px;
            }
            
            .button-group {
                flex-direction: column;
            }
        }

        /* Dark mode support */
        @media (prefers-color-scheme: dark) {
            .profile-card {
                background: rgba(17, 24, 39, 0.95);
                color: #f9fafb;
            }
            
            .form-input {
                background: rgba(31, 41, 55, 0.8);
                border-color: #374151;
                color: #f9fafb;
            }
            
            .form-label {
                color: #d1d5db;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="profile-card">
            <div class="card-header">
                <div class="avatar-container">
                    <div class="avatar">
                        <i class="fas fa-user-shield"></i>
                    </div>
                </div>
                <h1 class="card-title">Cập Nhật Hồ Sơ</h1>
                <p class="card-subtitle">Quản trị viên hệ thống</p>
            </div>

            <div class="card-body">
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
                        <label for="username" class="form-label">
                            <i class="fas fa-user"></i>
                            Tên đăng nhập
                        </label>
                        <div class="input-container">
                            <input type="text" 
                                   id="username" 
                                   name="username" 
                                   value="${admin.username}" 
                                   class="form-input"
                                   placeholder="Nhập tên đăng nhập"
                                   required>
                            <i class="fas fa-user input-icon"></i>
                        </div>
                        <div class="invalid-feedback">
                            <i class="fas fa-exclamation-circle"></i>
                            Vui lòng nhập tên đăng nhập hợp lệ
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="fullName" class="form-label">
                            <i class="fas fa-id-card"></i>
                            Họ và tên
                        </label>
                        <div class="input-container">
                            <input type="text" 
                                   id="fullName" 
                                   name="fullName" 
                                   value="${admin.fullName}" 
                                   class="form-input"
                                   placeholder="Nhập họ và tên đầy đủ"
                                   required>
                            <i class="fas fa-signature input-icon"></i>
                        </div>
                        <div class="invalid-feedback">
                            <i class="fas fa-exclamation-circle"></i>
                            Vui lòng nhập họ và tên
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="email" class="form-label">
                            <i class="fas fa-envelope"></i>
                            Địa chỉ email
                        </label>
                        <div class="input-container">
                            <input type="email" 
                                   id="email" 
                                   name="email" 
                                   value="${admin.email}" 
                                   class="form-input"
                                   placeholder="admin@example.com"
                                   required>
                            <i class="fas fa-at input-icon"></i>
                        </div>
                        <div class="invalid-feedback">
                            <i class="fas fa-exclamation-circle"></i>
                            Vui lòng nhập địa chỉ email hợp lệ
                        </div>
                    </div>

                    <div class="button-group">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i>
                            Lưu thay đổi
                        </button>
                        <a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp" 
                           class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i>
                            Quay lại
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        // Form Validation
        (function() {
            'use strict';
            
            const form = document.querySelector('.needs-validation');
            const inputs = form.querySelectorAll('.form-input');
            
            // Real-time validation
            inputs.forEach(input => {
                input.addEventListener('blur', validateField);
                input.addEventListener('input', clearValidation);
            });
            
            function validateField(e) {
                const input = e.target;
                const feedback = input.closest('.form-group').querySelector('.invalid-feedback');
                
                if (!input.checkValidity()) {
                    input.style.borderColor = '#ef4444';
                    feedback.classList.add('show');
                } else {
                    input.style.borderColor = '#10b981';
                    feedback.classList.remove('show');
                }
            }
            
            function clearValidation(e) {
                const input = e.target;
                const feedback = input.closest('.form-group').querySelector('.invalid-feedback');
                
                if (input.checkValidity()) {
                    input.style.borderColor = '#e5e7eb';
                    feedback.classList.remove('show');
                }
            }
            
            // Form submission
            form.addEventListener('submit', function(e) {
                let isValid = true;
                
                inputs.forEach(input => {
                    const feedback = input.closest('.form-group').querySelector('.invalid-feedback');
                    
                    if (!input.checkValidity()) {
                        input.style.borderColor = '#ef4444';
                        feedback.classList.add('show');
                        isValid = false;
                    } else {
                        input.style.borderColor = '#10b981';
                        feedback.classList.remove('show');
                    }
                });
                
                if (!isValid) {
                    e.preventDefault();
                    e.stopPropagation();
                }
            });
            
            // Auto hide alerts after 5 seconds
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                setTimeout(() => {
                    alert.style.opacity = '0';
                    alert.style.transform = 'translateY(-20px)';
                    setTimeout(() => alert.remove(), 300);
                }, 5000);
            });
        })();
    </script>
</body>
</html>
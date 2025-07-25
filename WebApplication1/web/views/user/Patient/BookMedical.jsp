<%--
    Document   : BookMedical
    Created on : Jun 17, 2025, 11:23:01 AM
    Author     : ASUS
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký Tư Vấn Chuyên Gia</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 50%, #cbd5e1 100%);
            min-height: 100vh;
        }
        
        .professional-card {
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(148, 163, 184, 0.2);
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.08);
        }
        
        .input-group {
            position: relative;
            margin-bottom: 1.75rem;
        }
        
        .input-field {
            width: 100%;
            padding: 1.125rem 1rem 1.125rem 3.5rem;
            border: 2px solid #e2e8f0;
            border-radius: 16px;
            background: #f8fafc;
            font-size: 1rem;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            outline: none;
            color: #1e293b;
            font-weight: 500;
        }
        
        .input-field:focus {
            border-color: #0ea5e9;
            background: #ffffff;
            box-shadow: 0 0 0 4px rgba(14, 165, 233, 0.08);
            transform: translateY(-1px);
        }
        
        .input-field.error {
            border-color: #dc2626;
            background: rgba(220, 38, 38, 0.03);
            box-shadow: 0 0 0 4px rgba(220, 38, 38, 0.05);
        }
        
        .input-icon {
            position: absolute;
            left: 1.25rem;
            top: 50%;
            transform: translateY(-50%);
            color: #64748b;
            font-size: 1.125rem;
            z-index: 10;
            transition: color 0.3s ease;
        }
        
        .input-field:focus + .input-icon {
            color: #0ea5e9;
        }
        
        .floating-label {
            position: absolute;
            left: 3.5rem;
            top: 1.125rem;
            color: #64748b;
            font-size: 1rem;
            font-weight: 500;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            pointer-events: none;
            background: transparent;
        }
        
        .input-field:focus + .input-icon + .floating-label,
        .input-field:valid + .input-icon + .floating-label,
        .input-field:not(:placeholder-shown) + .input-icon + .floating-label {
            top: -0.5rem;
            left: 1rem;
            font-size: 0.8125rem;
            color: #0ea5e9;
            background: white;
            padding: 0 0.625rem;
            font-weight: 600;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 50%, #334155 100%);
            border: none;
            border-radius: 16px;
            padding: 1.25rem 2rem;
            color: white;
            font-weight: 600;
            font-size: 1.125rem;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
            box-shadow: 0 4px 14px 0 rgba(15, 23, 42, 0.2);
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 28px 0 rgba(15, 23, 42, 0.3);
            background: linear-gradient(135deg, #1e293b 0%, #334155 50%, #475569 100%);
        }
        
        .btn-primary:active {
            transform: translateY(0);
            box-shadow: 0 4px 14px 0 rgba(15, 23, 42, 0.2);
        }
        
        .btn-primary::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
            transition: left 0.6s;
        }
        
        .btn-primary:hover::before {
            left: 100%;
        }
        
        .professional-card {
            border-radius: 28px;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        .professional-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 32px 64px -12px rgba(0, 0, 0, 0.12);
        }
        
        .error-message {
            background: linear-gradient(135deg, #dc2626, #b91c1c);
            color: white;
            padding: 1.25rem;
            border-radius: 16px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            animation: slideDown 0.5s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 8px 25px -8px rgba(220, 38, 38, 0.3);
        }
        
        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .title-gradient {
            background: linear-gradient(135deg, #0f172a 0%, #334155 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .professional-badge {
            background: linear-gradient(135deg, #0ea5e9 0%, #0284c7 100%);
            box-shadow: 0 4px 14px 0 rgba(14, 165, 233, 0.25);
        }
        
        .professional-badge:hover {
            transform: scale(1.05);
            box-shadow: 0 8px 25px -8px rgba(14, 165, 233, 0.35);
        }
        
        .trust-indicator {
            color: #64748b;
            font-weight: 500;
            transition: color 0.3s ease;
        }
        
        .trust-indicator:hover {
            color: #0ea5e9;
        }
        
        .floating-shapes::before,
        .floating-shapes::after {
            content: '';
            position: absolute;
            border-radius: 50%;
            background: linear-gradient(135deg, rgba(14, 165, 233, 0.06), rgba(3, 132, 199, 0.04));
            animation: float 8s ease-in-out infinite;
        }
        
        .floating-shapes::before {
            width: 300px;
            height: 300px;
            top: -150px;
            left: -150px;
            animation-delay: 0s;
        }
        
        .floating-shapes::after {
            width: 200px;
            height: 200px;
            bottom: -100px;
            right: -100px;
            animation-delay: 4s;
        }
        
        @keyframes float {
            0%, 100% {
                transform: translateY(0px) rotate(0deg);
            }
            50% {
                transform: translateY(-30px) rotate(180deg);
            }
        }
        
        .input-hint {
            color: #64748b;
            font-size: 0.8125rem;
            font-weight: 500;
            margin-top: 0.5rem;
            margin-left: 3.5rem;
            opacity: 0.8;
        }
        
        .service-option {
            padding: 0.75rem 1rem;
            transition: all 0.2s ease;
        }
        
        .service-option:hover {
            background-color: #f1f5f9;
        }
        
        select.input-field {
            appearance: none;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='m6 8 4 4 4-4'/%3e%3c/svg%3e");
            background-position: right 1rem center;
            background-repeat: no-repeat;
            background-size: 1.5em 1.5em;
            padding-right: 3rem;
        }
        
        .modal-overlay {
            background: rgba(15, 23, 42, 0.7);
            backdrop-filter: blur(8px);
        }
        
        .modal-content {
            background: white;
            border-radius: 24px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
            animation: modalSlideUp 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        @keyframes modalSlideUp {
            from {
                opacity: 0;
                transform: translateY(20px) scale(0.95);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        /* Header Styles */
        .header {
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(148, 163, 184, 0.2);
            box-shadow: 0 4px 14px rgba(0, 0, 0, 0.08);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .nav-link {
            color: #334155;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .nav-link:hover {
            color: #0ea5e9;
            transform: translateY(-1px);
        }

        /* Footer Styles */
        .footer {
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
            color: #f8fafc;
            padding: 4rem 1rem;
        }

        .footer-link {
            color: #cbd5e1;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .footer-link:hover {
            color: #0ea5e9;
            text-decoration: underline;
        }

        .footer-icon {
            color: #0ea5e9;
            transition: transform 0.3s ease;
        }

        .footer-icon:hover {
            transform: scale(1.2);
        }
    </style>
    <script>
        function validateForm() {
            let fullName = document.getElementById("fullName").value.trim();
            let phoneNumber = document.getElementById("phoneNumber").value.trim();
            let email = document.getElementById("email").value.trim();
            let serviceID = document.getElementById("serviceID").value;
            let errors = [];

            // Reset error states
            document.querySelectorAll('.input-field').forEach(field => {
                field.classList.remove('error');
            });

            // Kiểm tra fullName
            if (!fullName) {
                errors.push("Vui lòng nhập họ và tên.");
                document.getElementById("fullName").classList.add("error");
            } else if (!/^[a-zA-ZÀ-ỹà-ỹ\s]+$/.test(fullName) || fullName.length > 100) {
                errors.push("Họ và tên chỉ được chứa chữ cái và khoảng trắng, tối đa 100 ký tự.");
                document.getElementById("fullName").classList.add("error");
            }

            // Kiểm tra phoneNumber
            if (!/^\d{10}$/.test(phoneNumber)) {
                errors.push("Số điện thoại phải là 10 chữ số.");
                document.getElementById("phoneNumber").classList.add("error");
            }

            // Kiểm tra email
            if (email && !/^[a-zA-Z0-9._%+-]+@gmail\.com$/.test(email)) {
                errors.push("Email phải có đuôi @gmail.com (có thể để trống).");
                document.getElementById("email").classList.add("error");
            }

            // Kiểm tra serviceID
            if (!serviceID) {
                errors.push("Vui lòng chọn loại hình dịch vụ.");
                document.getElementById("serviceID").classList.add("error");
            }

            if (errors.length > 0) {
                showErrorModal(errors);
                return false;
            }
            
            showSuccessAnimation();
            return true;
        }
        
        function showErrorModal(errors) {
            const modal = document.createElement('div');
            modal.className = 'fixed inset-0 modal-overlay flex items-center justify-center z-50 p-4';
            
            let errorList = '';
            for (let i = 0; i < errors.length; i++) {
                errorList += '<div class="flex items-start space-x-2 text-slate-700"><i class="fas fa-exclamation-circle text-red-500 mt-0.5 flex-shrink-0"></i><span class="text-sm">' + errors[i] + '</span></div>';
            }
            
            modal.innerHTML = 
                '<div class="modal-content p-8 max-w-md mx-auto">' +
                    '<div class="text-center">' +
                        '<div class="w-16 h-16 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-4">' +
                            '<i class="fas fa-exclamation-triangle text-red-500 text-2xl"></i>' +
                        '</div>' +
                        '<h3 class="text-xl font-bold text-slate-800 mb-2">Thông tin chưa đúng</h3>' +
                        '<p class="text-slate-600 mb-6 text-sm">Vui lòng kiểm tra lại các thông tin sau:</p>' +
                        '<div class="text-left space-y-3 mb-8 bg-slate-50 p-4 rounded-xl">' +
                            errorList +
                        '</div>' +
                        '<button onclick="this.closest(\'.fixed\').remove()" class="bg-slate-800 hover:bg-slate-700 text-white px-8 py-3 rounded-xl font-semibold transition-all duration-200 transform hover:scale-105">' +
                            'Đã hiểu' +
                        '</button>' +
                    '</div>' +
                '</div>';
            
            document.body.appendChild(modal);
        }
        
        function showSuccessAnimation() {
            const submitBtn = document.querySelector('.btn-primary');
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>Đang xử lý...';
            submitBtn.disabled = true;
            submitBtn.style.opacity = '0.8';
        }
        
        // Add input animations
        document.addEventListener('DOMContentLoaded', function() {
            const inputs = document.querySelectorAll('.input-field');
            inputs.forEach(input => {
                // Check if input has value on page load
                if (input.value) {
                    input.parentElement.classList.add('focused');
                }
                
                input.addEventListener('focus', function() {
                    this.parentElement.classList.add('focused');
                });
                
                input.addEventListener('blur', function() {
                    if (!this.value) {
                        this.parentElement.classList.remove('focused');
                    }
                });
                
                input.addEventListener('input', function() {
                    if (this.value) {
                        this.parentElement.classList.add('focused');
                    } else {
                        this.parentElement.classList.remove('focused');
                    }
                });
            });
        });
    </script>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
            <div class="flex items-center justify-between">
                <div class="flex items-center space-x-4">
                    <div class="professional-badge w-12 h-12 rounded-xl flex items-center justify-center">
                        <i class="fas fa-stethoscope text-white text-xl"></i>
                    </div>
                    <span class="text-2xl font-bold title-gradient">Phòng Khám Nha Khoa PDC</span>
                </div>
                <nav class="flex items-center space-x-6">
                    <a href="${pageContext.request.contextPath}/views/common/HomePage.jsp" class="nav-link hover:underline">Trang Chủ</a>
                    <a href="/BookAppointmentGuestServlet" class="btn-primary px-6 py-2">Tư Vấn Thăm Khám</a>
                </nav>
            </div>
        </div>
    </header>

    <div class="floating-shapes"></div>
    <div class="min-h-screen flex items-center justify-center p-4">
        <div class="professional-card w-full max-w-lg p-10 relative">
            <!-- Header -->
            <div class="text-center mb-10">
                <div class="professional-badge w-20 h-20 rounded-2xl flex items-center justify-center mx-auto mb-6 transition-all duration-300">
                    <i class="fas fa-stethoscope text-white text-2xl"></i>
                </div>
                <h1 class="text-3xl font-bold title-gradient mb-3 tracking-tight">
                    Đăng Ký Tư Vấn Chuyên Gia
                </h1>
                <p class="text-slate-600 text-base font-medium leading-relaxed">
                    Điền thông tin để nhận tư vấn chuyên nghiệp<br>
                    <span class="text-sm text-slate-500">Miễn phí • Nhanh chóng • Bảo mật</span>
                </p>
            </div>

            <!-- Error Message -->
            <% if (request.getAttribute("error") != null) { %>
            <div class="error-message">
                <i class="fas fa-exclamation-circle mr-3 text-xl flex-shrink-0"></i>
                <span class="font-medium"><%= request.getAttribute("error") %></span>
            </div>
            <% } %>

            <!-- Form -->
            <form action="BookAppointmentGuestServlet" method="post" onsubmit="return validateForm()">
                <!-- Full Name -->
                <div class="input-group">
                    <input type="text" 
                           id="fullName" 
                           name="fullName" 
                           class="input-field" 
                           placeholder=" "
                           required>
                    <i class="fas fa-user input-icon"></i>
                    <label for="fullName" class="floating-label">Họ và tên *</label>
                </div>

                <!-- Phone Number -->
                <div class="input-group">
                    <input type="tel" 
                           id="phoneNumber" 
                           name="phoneNumber" 
                           class="input-field" 
                           placeholder=" "
                           pattern="\d{10}"
                           required>
                    <i class="fas fa-phone input-icon"></i>
                    <label for="phoneNumber" class="floating-label">Số điện thoại *</label>
                </div>

                <!-- Email -->
                <div class="input-group">
                    <input type="email" 
                           id="email" 
                           name="email" 
                           class="input-field" 
                           placeholder=" ">
                    <i class="fas fa-envelope input-icon"></i>
                    <label for="email" class="floating-label">Email</label>
                </div>

                <!-- Service Type -->
                <div class="input-group">
                    <select id="serviceID" 
                            name="serviceID" 
                            class="input-field" 
                            required>
                        <option value="">Chọn loại hình dịch vụ quan tâm</option>
                        <c:forEach var="service" items="${services}">
                            <c:if test="${service.status == 'Active'}">
                                <option value="${service.serviceID}">${service.serviceName}</option>
                            </c:if>
                        </c:forEach>
                    </select>
                    <i class="fas fa-medical-kit input-icon"></i>
                    <label for="serviceID" class="floating-label">Dịch vụ quan tâm *</label>
                </div>

                <!-- Submit Button -->
                <div class="mt-10">
                    <button type="submit" class="btn-primary w-full">
                        <i class="fas fa-calendar-check mr-3"></i>
                        Đăng Ký Tư Vấn Ngay
                    </button>
                </div>
            </form>

            <!-- Footer -->
            <div class="mt-8 text-center">
                <p class="text-slate-600 text-sm font-medium">
                    Đã có tài khoản? 
                    <a href="${pageContext.request.contextPath}/views/common/login.jsp" class="text-sky-600 hover:text-sky-700 font-semibold transition-colors duration-200 underline decoration-2 underline-offset-2">
                        Đăng nhập tại đây
                    </a>
                </p>
            </div>

            <!-- Trust Indicators -->
            <div class="mt-8 flex justify-center space-x-6 pt-6 border-t border-slate-100">
                <div class="trust-indicator flex items-center text-xs">
                    <i class="fas fa-shield-alt mr-2"></i>
                    <span class="font-semibold">Bảo mật 100%</span>
                </div>
                <div class="trust-indicator flex items-center text-xs">
                    <i class="fas fa-clock mr-2"></i>
                    <span class="font-semibold">Phản hồi 24h</span>
                </div>
                <div class="trust-indicator flex items-center text-xs">
                    <i class="fas fa-award mr-2"></i>
                    <span class="font-semibold">Chuyên gia hàng đầu</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                <!-- Contact Info -->
                <div>
                    <h3 class="text-xl font-bold text-white mb-4">Liên Hệ</h3>
                    <p class="text-slate-300 mb-2">
                        <i class="fas fa-map-marker-alt footer-icon mr-2"></i>
                        DH FPT , HOA LAC , HA NOI
                    </p>
                    <p class="text-slate-300 mb-2">
                        <i class="fas fa-phone footer-icon mr-2"></i>
                        (098) 123-4567
                    </p>
                    <p class="text-slate-300">
                        <i class="fas fa-envelope footer-icon mr-2"></i>
                        PhongKhamPDC@gmail.com
                    </p>
                </div>
                <!-- Quick Links -->
                <div>
                    <h3 class="text-xl font-bold text-white mb-4">Liên Kết Nhanh</h3>
                    <ul class="space-y-2">
                        <li><a href="${pageContext.request.contextPath}/views/common/HomePage.jsp" class="footer-link">Trang Chủ</a></li>
                    </ul>
                </div>
                <!-- Social Media -->
                <div>
                    <h3 class="text-xl font-bold text-white mb-4">Về Chúng Tôi </h3>
                    <div class="flex space-x-4">
                                           <p>Chúng tôi cam kết mang đến dịch vụ y tế chất lượng với đội ngũ bác sĩ tận tâm.</p>

                    </div>
                </div>
            </div>
            <div class="mt-8 pt-8 border-t border-slate-700 text-center">
                <p class="text-slate-300 text-sm">
                    &copy; 2025 Nha Khoa PDC. Đạt chuẩn Bộ Y tế. Tất cả quyền được bảo lưu.
                </p>
            </div>
        </div>
    </footer>
</body>
</html>
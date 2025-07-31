<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa thông tin bệnh nhân - Hệ thống Y tế</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2563eb;
            --primary-dark: #1d4ed8;
            --primary-light: #dbeafe;
            --secondary-color: #64748b;
            --success-color: #059669;
            --danger-color: #dc2626;
            --warning-color: #d97706;
            --info-color: #0891b2;
            --light-bg: #f8fafc;
            --white: #ffffff;
            --border-color: #e2e8f0;
            --text-primary: #1e293b;
            --text-secondary: #64748b;
            --text-muted: #94a3b8;
            --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
            --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
            --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
            --shadow-xl: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);
            --border-radius: 8px;
            --border-radius-lg: 12px;
            --border-radius-xl: 16px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            color: var(--text-primary);
            line-height: 1.6;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1rem;
            position: relative;
        }

        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="%232563eb" opacity="0.05"/><circle cx="75" cy="75" r="1" fill="%232563eb" opacity="0.05"/><circle cx="50" cy="10" r="0.5" fill="%232563eb" opacity="0.08"/><circle cx="10" cy="60" r="0.5" fill="%232563eb" opacity="0.08"/><circle cx="90" cy="40" r="0.5" fill="%232563eb" opacity="0.08"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
            opacity: 0.6;
            pointer-events: none;
            z-index: -1;
        }

        .form-container {
            background: var(--white);
            border-radius: var(--border-radius-xl);
            box-shadow: var(--shadow-xl);
            border: 1px solid var(--border-color);
            width: 100%;
            max-width: 600px;
            position: relative;
            overflow: hidden;
            backdrop-filter: blur(10px);
        }

        .form-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            color: white;
            padding: 2rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .form-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="dots" width="20" height="20" patternUnits="userSpaceOnUse"><circle cx="10" cy="10" r="1.5" fill="white" opacity="0.1"/></pattern></defs><rect width="100" height="100" fill="url(%23dots)"/></svg>');
            opacity: 0.3;
        }

        .form-header h1 {
            font-size: 1.75rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
        }

        .form-header p {
            font-size: 0.95rem;
            opacity: 0.9;
            margin-bottom: 0;
            position: relative;
            z-index: 1;
        }

        .form-body {
            padding: 2rem;
        }

        .breadcrumb-nav {
            margin-bottom: 1.5rem;
            padding: 0.75rem;
            background: var(--light-bg);
            border-radius: var(--border-radius);
            border: 1px solid var(--border-color);
        }

        .breadcrumb {
            background: transparent;
            padding: 0;
            margin: 0;
            font-size: 0.875rem;
        }

        .breadcrumb-item a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
        }

        .breadcrumb-item a:hover {
            color: var(--primary-dark);
            text-decoration: underline;
        }

        .breadcrumb-item.active {
            color: var(--text-secondary);
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            display: block;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--text-primary);
            font-size: 0.875rem;
            text-transform: uppercase;
            letter-spacing: 0.025em;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .form-label .label-icon {
            color: var(--primary-color);
            font-size: 0.8rem;
        }

        .input-wrapper {
            position: relative;
        }

        .form-control, .form-select {
            width: 100%;
            padding: 0.875rem 1rem 0.875rem 2.75rem;
            border: 2px solid var(--border-color);
            border-radius: var(--border-radius);
            font-size: 0.95rem;
            background: var(--white);
            transition: all 0.3s ease;
            color: var(--text-primary);
            font-weight: 400;
        }

        .form-control:focus, .form-select:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 4px rgb(37 99 235 / 0.1);
            background: var(--white);
        }

        .form-control:hover:not(:focus), .form-select:hover:not(:focus) {
            border-color: #cbd5e1;
        }

        .input-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            font-size: 0.9rem;
            transition: color 0.3s ease;
            z-index: 2;
        }

        .form-control:focus + .input-icon,
        .form-select:focus + .input-icon {
            color: var(--primary-color);
        }

        .form-select {
            appearance: none;
            background-image: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="%2364748b"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/></svg>');
            background-repeat: no-repeat;
            background-position: right 1rem center;
            background-size: 1rem;
            padding-right: 3rem;
        }

        .btn {
            font-weight: 600;
            border-radius: var(--border-radius);
            padding: 0.875rem 1.5rem;
            font-size: 0.875rem;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            text-decoration: none;
            text-transform: uppercase;
            letter-spacing: 0.025em;
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
            transition: left 0.5s ease;
        }

        .btn:hover::before {
            left: 100%;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            color: white;
            width: 100%;
            margin-bottom: 1rem;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, var(--primary-dark) 0%, #1e40af 100%);
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
            color: white;
        }

        .btn-secondary {
            background: var(--white);
            color: var(--text-secondary);
            border: 2px solid var(--border-color);
            width: 100%;
        }

        .btn-secondary:hover {
            background: var(--light-bg);
            border-color: var(--primary-color);
            color: var(--primary-color);
            transform: translateY(-1px);
            box-shadow: var(--shadow-md);
        }

        .btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none !important;
        }

        .btn:disabled:hover::before {
            left: -100% !important;
        }

        .alert {
            border: none;
            border-radius: var(--border-radius);
            padding: 1rem 1.25rem;
            margin-bottom: 1.5rem;
            font-size: 0.875rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .alert-danger {
            background: #fef2f2;
            color: #b91c1c;
            border-left: 4px solid var(--danger-color);
        }

        .alert-success {
            background: #f0fdf4;
            color: #15803d;
            border-left: 4px solid var(--success-color);
        }

        .invalid-feedback {
            display: none;
            color: var(--danger-color);
            font-size: 0.8rem;
            margin-top: 0.5rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .was-validated .form-control:invalid,
        .was-validated .form-select:invalid {
            border-color: var(--danger-color);
            box-shadow: 0 0 0 4px rgb(220 38 38 / 0.1);
        }

        .was-validated .form-control:invalid + .input-icon {
            color: var(--danger-color);
        }

        .was-validated .form-control:invalid ~ .invalid-feedback,
        .was-validated .form-select:invalid ~ .invalid-feedback {
            display: flex;
        }

        .was-validated .form-control:valid,
        .was-validated .form-select:valid {
            border-color: var(--success-color);
            box-shadow: 0 0 0 4px rgb(5 150 105 / 0.1);
        }

        .was-validated .form-control:valid + .input-icon {
            color: var(--success-color);
        }

        .loading-spinner {
            display: inline-block;
            width: 1rem;
            height: 1rem;
            border: 2px solid transparent;
            border-top: 2px solid currentColor;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .form-actions {
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 1px solid var(--border-color);
        }

        /* Progress indicator */
        .progress-indicator {
            position: absolute;
            top: 0;
            left: 0;
            height: 4px;
            background: var(--primary-color);
            transition: width 0.3s ease;
            border-radius: 0 0 4px 0;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            body {
                padding: 0.5rem;
            }

            .form-container {
                max-width: none;
                margin: 0;
                border-radius: 0;
                box-shadow: none;
                border: none;
                min-height: 100vh;
            }

            .form-header {
                border-radius: 0;
            }

            .form-header h1 {
                font-size: 1.5rem;
            }

            .form-body {
                padding: 1.5rem;
            }

            .form-control, .form-select {
                padding: 0.75rem 0.875rem 0.75rem 2.5rem;
                font-size: 16px; /* Prevent zoom on iOS */
            }
        }

        /* Custom animations */
        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .form-container {
            animation: slideIn 0.6s ease-out;
        }

        .form-group {
            animation: slideIn 0.6s ease-out;
            animation-fill-mode: both;
        }

        .form-group:nth-child(1) { animation-delay: 0.1s; }
        .form-group:nth-child(2) { animation-delay: 0.2s; }
        .form-group:nth-child(3) { animation-delay: 0.3s; }
        .form-group:nth-child(4) { animation-delay: 0.4s; }
        .form-group:nth-child(5) { animation-delay: 0.5s; }
        .form-group:nth-child(6) { animation-delay: 0.6s; }

        /* Focus management */
        .form-control:focus,
        .form-select:focus {
            position: relative;
            z-index: 2;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <div class="progress-indicator" style="width: 0%"></div>
        
        <div class="form-header">
            <h1>
                <i class="fas fa-user-edit"></i>
                Chỉnh sửa thông tin bệnh nhân
            </h1>
            <p>Cập nhật thông tin chi tiết của bệnh nhân trong hệ thống</p>
        </div>

        <div class="form-body">
            <!-- Breadcrumb -->
            <nav class="breadcrumb-nav" aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp">
                            <i class="fas fa-home"></i> Trang chủ
                        </a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/ViewPatientServlet">
                            <i class="fas fa-users"></i> Danh sách bệnh nhân
                        </a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">
                        <i class="fas fa-edit"></i> Chỉnh sửa
                    </li>
                </ol>
            </nav>

            <!-- Error Messages -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-triangle"></i>
                    ${error}
                </div>
            </c:if>

            <!-- Patient Not Found -->
            <c:if test="${empty patient}">
                <div class="alert alert-danger">
                    <i class="fas fa-user-times"></i>
                    Không tìm thấy thông tin bệnh nhân để chỉnh sửa.
                </div>
                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/ViewPatientServlet" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i>
                        Quay lại danh sách
                    </a>
                </div>
            </c:if>

            <!-- Edit Form -->
            <c:if test="${not empty patient}">
                <form action="${pageContext.request.contextPath}/UpdatePatientServlet" method="post" 
                      class="needs-validation" novalidate id="editPatientForm">
                    <input type="hidden" name="userID" value="${patient.userID}">

                    <!-- Patient ID Display -->
                    <div class="form-group">
                        <label class="form-label">
                            <i class="fas fa-hashtag label-icon"></i>
                            Mã bệnh nhân
                        </label>
                        <div class="input-wrapper">
                            <input type="text" class="form-control" value="#${patient.userID}" readonly 
                                   style="background-color: #f8fafc; color: #64748b; font-weight: 600;">
                            <i class="fas fa-id-card input-icon"></i>
                        </div>
                    </div>

                    <!-- Full Name -->
                    <div class="form-group">
                        <label for="fullName" class="form-label">
                            <i class="fas fa-user label-icon"></i>
                            Họ và tên
                        </label>
                        <div class="input-wrapper">
                            <input type="text" id="fullName" name="fullName" class="form-control"
                                   value="${not empty formFullName ? formFullName : (not empty patient.fullName ? patient.fullName : '')}"
                                   placeholder="Nhập họ và tên đầy đủ" required 
                                   pattern="^[a-zA-ZÀ-ỹ\s]{2,50}$">
                            <i class="fas fa-user input-icon"></i>
                        </div>
                        <div class="invalid-feedback">
                            <i class="fas fa-times-circle"></i>
                            Họ và tên chỉ được chứa chữ cái và dấu cách (2-50 ký tự).
                        </div>
                    </div>

                    <!-- Gender -->
                    <div class="form-group">
                        <label for="gender" class="form-label">
                            <i class="fas fa-venus-mars label-icon"></i>
                            Giới tính
                        </label>
                        <div class="input-wrapper">
                            <select id="gender" name="gender" class="form-select" required>
                                <option value="" disabled ${empty formGender && empty patient.gender ? 'selected' : ''}>
                                    Chọn giới tính
                                </option>
                                <option value="Nam" ${formGender == 'Nam' || (empty formGender && patient.gender == 'Nam') ? 'selected' : ''}>
                                    👨 Nam
                                </option>
                                <option value="Nữ" ${formGender == 'Nữ' || (empty formGender && patient.gender == 'Nữ') ? 'selected' : ''}>
                                    👩 Nữ
                                </option>
                            </select>
                            <i class="fas fa-venus-mars input-icon"></i>
                        </div>
                        <div class="invalid-feedback">
                            <i class="fas fa-times-circle"></i>
                            Vui lòng chọn giới tính.
                        </div>
                    </div>

                    <!-- Date of Birth -->
                    <div class="form-group">
                        <label for="dob" class="form-label">
                            <i class="fas fa-calendar-alt label-icon"></i>
                            Ngày sinh
                        </label>
                        <div class="input-wrapper">
                            <input type="date" id="dob" name="dob" class="form-control"
                                   value="${not empty formDob ? formDob : (not empty patient.dob ? patient.dob : '')}"
                                   required max="${java.time.LocalDate.now()}">
                            <i class="fas fa-calendar-alt input-icon"></i>
                        </div>
                        <div class="invalid-feedback">
                            <i class="fas fa-times-circle"></i>
                            Vui lòng nhập ngày sinh hợp lệ.
                        </div>
                    </div>

                    <!-- Phone -->
                    <div class="form-group">
                        <label for="phone" class="form-label">
                            <i class="fas fa-phone label-icon"></i>
                            Số điện thoại
                        </label>
                        <div class="input-wrapper">
                            <input type="tel" id="phone" name="phone" class="form-control"
                                   value="${not empty formPhone ? formPhone : (not empty patient.phone ? patient.phone : '')}"
                                   placeholder="Nhập số điện thoại" required 
                                   pattern="^(0[3|5|7|8|9])+([0-9]{8})$">
                            <i class="fas fa-phone input-icon"></i>
                        </div>
                        <div class="invalid-feedback">
                            <i class="fas fa-times-circle"></i>
                            Số điện thoại phải bắt đầu bằng 03, 05, 07, 08, 09 và có 10 chữ số.
                        </div>
                    </div>

                    <!-- Address -->
                    <div class="form-group">
                        <label for="address" class="form-label">
                            <i class="fas fa-map-marker-alt label-icon"></i>
                            Địa chỉ
                        </label>
                        <div class="input-wrapper">
                            <input type="text" id="address" name="address" class="form-control"
                                   value="${not empty formAddress ? formAddress : (not empty patient.address ? patient.address : '')}"
                                   placeholder="Nhập địa chỉ chi tiết" required minlength="10" maxlength="200">
                            <i class="fas fa-map-marker-alt input-icon"></i>
                        </div>
                        <div class="invalid-feedback">
                            <i class="fas fa-times-circle"></i>
                            Địa chỉ phải có ít nhất 10 ký tự và không quá 200 ký tự.
                        </div>
                    </div>

                    <!-- Status -->
                    <div class="form-group">
                        <label for="status" class="form-label">
                            <i class="fas fa-toggle-on label-icon"></i>
                            Trạng thái
                        </label>
                        <div class="input-wrapper">
                            <select id="status" name="status" class="form-select" required>
                                <option value="" disabled ${empty formStatus && empty patient.status ? 'selected' : ''}>
                                    Chọn trạng thái
                                </option>
                                <option value="Active" ${formStatus == 'Active' || (empty formStatus && patient.status == 'Active') ? 'selected' : ''}>
                                    ✅ Hoạt động
                                </option>
                                <option value="Inactive" ${formStatus == 'Inactive' || (empty formStatus && patient.status == 'Inactive') ? 'selected' : ''}>
                                    ❌ Không hoạt động
                                </option>
                            </select>
                            <i class="fas fa-toggle-on input-icon"></i>
                        </div>
                        <div class="invalid-feedback">
                            <i class="fas fa-times-circle"></i>
                            Vui lòng chọn trạng thái.
                        </div>
                    </div>

                    <!-- Form Actions -->
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary" id="submitBtn">
                            <i class="fas fa-save"></i>
                            Lưu thay đổi
                        </button>
                        <a href="${pageContext.request.contextPath}/ViewPatientServlet" class="btn btn-secondary">
                            <i class="fas fa-times"></i>
                            Hủy bỏ
                        </a>
                    </div>
                </form>
            </c:if>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Form validation
            const form = document.getElementById('editPatientForm');
            const submitBtn = document.getElementById('submitBtn');
            const progressBar = document.querySelector('.progress-indicator');
            
            if (form) {
                // Bootstrap validation
                form.addEventListener('submit', function(event) {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                        
                        // Scroll to first invalid field
                        const firstInvalidField = form.querySelector('.form-control:invalid, .form-select:invalid');
                        if (firstInvalidField) {
                            firstInvalidField.scrollIntoView({ behavior: 'smooth', block: 'center' });
                            firstInvalidField.focus();
                        }
                    } else {
                        // Show loading state
                        submitBtn.disabled = true;
                        submitBtn.innerHTML = '<span class="loading-spinner"></span> Đang lưu...';
                        
                        // Progress animation
                        let progress = 0;
                        const interval = setInterval(() => {
                            progress += 10;
                            progressBar.style.width = progress + '%';
                            if (progress >= 100) {
                                clearInterval(interval);
                            }
                        }, 100);
                    }
                    
                    form.classList.add('was-validated');
                }, false);

                // Real-time validation
                const inputs = form.querySelectorAll('.form-control, .form-select');
                inputs.forEach(input => {
                    input.addEventListener('blur', function() {
                        this.classList.add('was-validated-field');
                        validateField(this);
                    });
                    
                    input.addEventListener('input', function() {
                        if (this.classList.contains('was-validated-field')) {
                            validateField(this);
                        }
                    });
                });
            }

            // Custom validation function
            function validateField(field) {
                const isValid = field.checkValidity();
                const wrapper = field.closest('.form-group');
                const feedback = wrapper.querySelector('.invalid-feedback');
                
                if (isValid) {
                    field.classList.remove('is-invalid');
                    field.classList.add('is-valid');
                    if (feedback) feedback.style.display = 'none';
                } else {
                    field.classList.remove('is-valid');
                    field.classList.add('is-invalid');
                    if (feedback) feedback.style.display = 'flex';
                }
            }

            // Phone number formatting
            const phoneInput = document.getElementById('phone');
            if (phoneInput) {
                phoneInput.addEventListener('input', function(e) {
                    let value = e.target.value.replace(/\D/g, '');
                    if (value.length > 10) value = value.slice(0, 10);
                    e.target.value = value;
                });
            }

            // Date validation
            const dobInput = document.getElementById('dob');
            if (dobInput) {
                const today = new Date().toISOString().split('T')[0];
                dobInput.setAttribute('max', today);
                
                dobInput.addEventListener('change', function() {
                    const selectedDate = new Date(this.value);
                    const today = new Date();
                    const age = today.getFullYear() - selectedDate.getFullYear();
                    
                    if (age > 150 || selectedDate > today) {
                        this.setCustomValidity('Ngày sinh không hợp lệ');
                    } else {
                        this.setCustomValidity('');
                    }
                });
            }

            // Auto-focus first input
            const firstInput = form?.querySelector('.form-control:not([readonly])');
            if (firstInput) {
                setTimeout(() => firstInput.focus(), 500);
            }

            // Smooth scroll for invalid fields
            form?.addEventListener('invalid', function(e) {
                e.target.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }, true);

            // Progress tracking
            let filledFields = 0;
            const totalFields = form?.querySelectorAll('.form-control:not([readonly]), .form-select').length || 0;
            
            function updateProgress() {
                const validFields = form?.querySelectorAll('.form-control:valid:not([readonly]), .form-select:valid').length || 0;
                const progress = totalFields > 0 ? (validFields / totalFields) * 100 : 0;
                if (progressBar) {
                    progressBar.style.width = progress + '%';
                }
            }

            // Update progress on input change
            inputs.forEach(input => {
                input.addEventListener('input', updateProgress);
                input.addEventListener('change', updateProgress);
            });

            // Initial progress update
            setTimeout(updateProgress, 100);

            // Keyboard shortcuts
            document.addEventListener('keydown', function(e) {
                // Ctrl + S to save
                if (e.ctrlKey && e.key === 's') {
                    e.preventDefault();
                    if (form && !submitBtn.disabled) {
                        form.dispatchEvent(new Event('submit'));
                    }
                }
                
                // Escape to cancel
                if (e.key === 'Escape') {
                    const cancelBtn = document.querySelector('.btn-secondary');
                    if (cancelBtn && confirm('Bạn có chắc chắn muốn hủy bỏ các thay đổi?')) {
                        window.location.href = cancelBtn.href;
                    }
                }
            });

            // Form change detection
            let formChanged = false;
            const originalFormData = new FormData(form);
            
            form?.addEventListener('input', function() {
                formChanged = true;
            });

            // Warn before leaving if form has changes
            window.addEventListener('beforeunload', function(e) {
                if (formChanged && !submitBtn.disabled) {
                    e.preventDefault();
                    e.returnValue = 'Bạn có thay đổi chưa được lưu. Bạn có chắc chắn muốn rời khỏi trang?';
                    return e.returnValue;
                }
            });

            // Remove warning when form is submitted
            form?.addEventListener('submit', function() {
                formChanged = false;
            });

            // Enhanced animations
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.animationPlayState = 'running';
                    }
                });
            });

            document.querySelectorAll('.form-group').forEach(group => {
                observer.observe(group);
            });
        });

        // Auto-resize for mobile
        function adjustForMobile() {
            if (window.innerWidth <= 768) {
                document.body.classList.add('mobile');
            } else {
                document.body.classList.remove('mobile');
            }
        }

        window.addEventListener('resize', adjustForMobile);
        adjustForMobile();
    </script>
</body>
</html>
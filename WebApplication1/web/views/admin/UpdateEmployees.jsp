<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sửa Thông Tin Nhân Viên</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            padding: 0;
            position: relative;
        }

        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="white" opacity="0.05"/><circle cx="75" cy="75" r="1" fill="white" opacity="0.05"/><circle cx="50" cy="10" r="0.5" fill="white" opacity="0.03"/><circle cx="10" cy="60" r="0.5" fill="white" opacity="0.03"/><circle cx="90" cy="40" r="0.5" fill="white" opacity="0.03"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
            z-index: -1;
        }

        .main-container {
            width: 100%;
            max-width: 1400px;
            display: flex;
            gap: 40px;
            align-items: flex-start;
            margin: 0 auto;
            padding: 30px;
            flex: 1;
        }

        .side-panel {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            padding: 35px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            flex: 0 0 350px;
            height: fit-content;
            position: sticky;
            top: 30px;
        }

        .welcome-section {
            text-align: center;
            margin-bottom: 30px;
        }

        .welcome-icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            color: white;
            font-size: 24px;
        }

        .welcome-title {
            font-size: 18px;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 8px;
        }

        .welcome-subtitle {
            font-size: 14px;
            color: #718096;
            line-height: 1.5;
        }

        .info-cards {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .info-card {
            background: linear-gradient(135deg, #f7fafc, #edf2f7);
            border-radius: 12px;
            padding: 20px;
            border-left: 4px solid #667eea;
        }

        .info-card-icon {
            color: #667eea;
            font-size: 20px;
            margin-bottom: 10px;
        }

        .info-card-title {
            font-size: 14px;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 5px;
        }

        .info-card-content {
            font-size: 13px;
            color: #4a5568;
            line-height: 1.4;
        }

        .form-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            padding: 50px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            flex: 1;
            position: relative;
            overflow: hidden;
            min-height: 700px;
        }

        .form-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2, #f093fb);
        }

        .breadcrumb {
            display: flex;
            align-items: center;
            margin-bottom: 25px;
            font-size: 14px;
            color: #718096;
        }

        .breadcrumb a {
            color: #667eea;
            text-decoration: none;
            transition: color 0.2s ease;
        }

        .breadcrumb a:hover {
            color: #5a67d8;
        }

        .breadcrumb-separator {
            margin: 0 10px;
            color: #cbd5e0;
        }

        .breadcrumb-current {
            color: #2d3748;
            font-weight: 500;
        }

        .form-header {
            text-align: center;
            margin-bottom: 35px;
        }

        .form-title {
            font-size: 36px;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 12px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .form-subtitle {
            font-size: 16px;
            color: #718096;
        }

        .alert {
            padding: 16px 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 14px;
            font-weight: 500;
        }

        .alert-error {
            background: linear-gradient(135deg, #fed7d7, #feb2b2);
            color: #c53030;
            border-left: 4px solid #e53e3e;
        }

        .alert-info {
            background: linear-gradient(135deg, #bee3f8, #90cdf4);
            color: #2b6cb0;
            border-left: 4px solid #3182ce;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 35px;
            margin-bottom: 40px;
        }

        .form-group {
            position: relative;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-label {
            display: block;
            font-size: 16px;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 10px;
        }

        .form-label .required {
            color: #e53e3e;
            margin-left: 3px;
        }

        .input-wrapper {
            position: relative;
        }

        .form-input,
        .form-select {
            width: 100%;
            padding: 18px 50px 18px 20px;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 400;
            background: #ffffff;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            color: #2d3748;
            min-height: 56px;
        }

        .form-input:focus,
        .form-select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            transform: translateY(-1px);
        }

        .form-input::placeholder {
            color: #a0aec0;
            font-weight: 400;
        }

        .input-icon {
            position: absolute;
            right: 20px;
            top: 50%;
            transform: translateY(-50%);
            color: #a0aec0;
            font-size: 18px;
            transition: color 0.2s ease;
            pointer-events: none;
        }

        .form-input:focus + .input-icon,
        .form-select:focus + .input-icon {
            color: #667eea;
        }

        .form-actions {
            display: flex;
            gap: 20px;
            justify-content: center;
            margin-top: 50px;
        }

        .btn {
            padding: 16px 40px;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            border: 2px solid transparent;
            min-width: 160px;
            justify-content: center;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.6);
        }

        .btn-secondary {
            background: #ffffff;
            color: #4a5568;
            border-color: #e2e8f0;
        }

        .btn-secondary:hover {
            background: #f7fafc;
            border-color: #cbd5e0;
            transform: translateY(-1px);
        }

        .validation-message {
            position: absolute;
            bottom: -22px;
            left: 0;
            font-size: 12px;
            color: #e53e3e;
            font-weight: 500;
        }

        /* Loading Animation */
        .btn-loading {
            position: relative;
            pointer-events: none;
        }

        .btn-loading::after {
            content: '';
            position: absolute;
            width: 16px;
            height: 16px;
            border: 2px solid transparent;
            border-top: 2px solid currentColor;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        /* Footer positioning */
        .footer-wrapper {
            margin-top: auto;
            width: 100%;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .main-container {
                flex-direction: column;
                max-width: none;
                padding: 20px;
            }

            .side-panel {
                flex: none;
                order: 2;
                position: static;
            }

            .form-container {
                padding: 35px 25px;
                min-height: 600px;
            }

            .form-grid {
                grid-template-columns: 1fr;
                gap: 25px;
            }

            .form-actions {
                flex-direction: column;
            }

            .btn {
                width: 100%;
            }

            .form-title {
                font-size: 28px;
            }
        }

        @media (max-width: 480px) {
            .main-container {
                padding: 15px;
            }

            .form-container {
                padding: 30px 20px;
                min-height: 550px;
            }

            .form-title {
                font-size: 24px;
            }

            .side-panel {
                padding: 25px 20px;
            }
        }

        /* Custom Select Styling */
        .form-select {
            appearance: none;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='m6 8 4 4 4-4'/%3e%3c/svg%3e");
            background-position: right 12px center;
            background-repeat: no-repeat;
            background-size: 16px;
            padding-right: 40px;
        }

        /* Success Animation */
        .form-success {
            animation: successPulse 0.6s ease-out;
        }

        @keyframes successPulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.02); }
            100% { transform: scale(1); }
        }
    </style>
</head>
<body>
    <div class="main-container">
        <!-- Side Panel -->
        <div class="side-panel">
            <div class="welcome-section">
                <div class="welcome-icon">
                    <i class="fas fa-user-edit"></i>
                </div>
                <h3 class="welcome-title">Chỉnh sửa thông tin</h3>
                <p class="welcome-subtitle">Cập nhật thông tin nhân viên một cách dễ dàng và nhanh chóng</p>
            </div>

            <div class="info-cards">
                <div class="info-card">
                    <div class="info-card-icon">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <div class="info-card-title">Bảo mật thông tin</div>
                    <div class="info-card-content">Mọi thông tin của bạn được mã hóa và bảo vệ an toàn</div>
                </div>

                <div class="info-card">
                    <div class="info-card-icon">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="info-card-title">Cập nhật realtime</div>
                    <div class="info-card-content">Thông tin sẽ được cập nhật ngay lập tức sau khi lưu</div>
                </div>

                <div class="info-card">
                    <div class="info-card-icon">
                        <i class="fas fa-headset"></i>
                    </div>
                    <div class="info-card-title">Hỗ trợ 24/7</div>
                    <div class="info-card-content">Liên hệ với chúng tôi nếu bạn cần hỗ trợ</div>
                </div>
            </div>
        </div>

        <!-- Main Form -->
        <div class="form-container">
                        <div class="header-content">
                <div class="breadcrumb">
                    <i class="fas fa-home"></i>
                    <a href="${pageContext.request.contextPath}//views/admin/dashboard.jsp">Trang Chủ</a>
                    <span class="separator">></span>
                    <a href="${pageContext.request.contextPath}/ViewEmployeeServlet">Quản Lý Nhân Viên</a>
                    <span class="separator">></span>
                    <span class="current">Sửa Thông Tin Nhân Viên</span>
                </div>
                <div class="header-title">
                    <i class="fas fa-user-plus"></i> Quản Lý Nhân Viên
                </div>
            </div>

            <div class="form-header">
                <h1 class="form-title">Sửa Thông Tin Nhân Viên</h1>
                <p class="form-subtitle">Vui lòng điền đầy đủ thông tin để cập nhật hồ sơ nhân viên</p>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-triangle"></i>
                    <span>${error}</span>
                </div>
            </c:if>

            <c:if test="${empty employee}">
                <div class="alert alert-error">
                    <i class="fas fa-user-times"></i>
                    <span>Không tìm thấy nhân viên để chỉnh sửa.</span>
                </div>
                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/ViewEmployeeServlet" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i>
                        Quay lại
                    </a>
                </div>
            </c:if>

            <c:if test="${not empty employee}">
                <form action="${pageContext.request.contextPath}/UpdateEmployeeServlet" method="post" id="employeeForm" class="needs-validation" novalidate>
                    <input type="hidden" name="userID" value="${employee.userID}">
                    
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="fullName" class="form-label">
                                Họ và tên<span class="required">*</span>
                            </label>
                            <div class="input-wrapper">
                                <input type="text" 
                                       id="fullName" 
                                       name="fullName" 
                                       class="form-input"
                                       value="${not empty formFullName ? formFullName : (not empty employee.fullName ? employee.fullName : '')}" 
                                       placeholder="Nhập họ và tên đầy đủ" 
                                       required>
                                <i class="fas fa-user input-icon"></i>
                                <div class="validation-message"></div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="gender" class="form-label">
                                Giới tính<span class="required">*</span>
                            </label>
                            <div class="input-wrapper">
                                <select id="gender" name="gender" class="form-select" required>
                                    <option value="" disabled ${empty formGender && empty employee.gender ? 'selected' : ''}>Chọn giới tính</option>
                                    <option value="Nam" ${formGender == 'Nam' || (empty formGender && employee.gender == 'Nam') ? 'selected' : ''}>Nam</option>
                                    <option value="Nữ" ${formGender == 'Nữ' || (empty formGender && employee.gender == 'Nữ') ? 'selected' : ''}>Nữ</option>
                                </select>
                                <i class="fas fa-venus-mars input-icon"></i>
                                <div class="validation-message"></div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="specialization" class="form-label">
                                Chuyên khoa<span class="required">*</span>
                            </label>
                            <div class="input-wrapper">
                                <select id="specialization" name="specialization" class="form-select" required>
                                    <option value="" disabled ${empty formSpecialization && empty employee.specialization ? 'selected' : ''}>Chọn chuyên khoa</option>
                                    <option value="Chuyên môn" ${formSpecialization == 'Chuyên môn' || (empty formSpecialization && employee.specialization == 'Chuyên môn') ? 'selected' : ''}>Chuyên môn</option>
                                    <option value="Thạc sĩ" ${formSpecialization == 'Thạc sĩ' || (empty formSpecialization && employee.specialization == 'Thạc sĩ') ? 'selected' : ''}>Thạc sĩ</option>
                                    <option value="Tiến sĩ" ${formSpecialization == 'Tiến sĩ' || (empty formSpecialization && employee.specialization == 'Tiến sĩ') ? 'selected' : ''}>Tiến sĩ</option>
                                </select>
                                <i class="fas fa-user-md input-icon"></i>
                                <div class="validation-message"></div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="dob" class="form-label">
                                Ngày sinh<span class="required">*</span>
                            </label>
                            <div class="input-wrapper">
                                <input type="date" 
                                       id="dob" 
                                       name="dob" 
                                       class="form-input"
                                       value="${not empty formDob ? formDob : (not empty employee.dob ? employee.dob : '')}" 
                                       required>
                                <i class="fas fa-calendar-alt input-icon"></i>
                                <div class="validation-message"></div>
                            </div>
                        </div>
                                                   <div class="form-group" id="status-wrapper">
                <label for="status">Trạng thái:</label>
                <div class="input-box">
                    <select id="status" name="status" required>
                        <option value="Active" ${formStatus == 'Active' || (empty formStatus && employee.status == 'Active') ? 'selected' : ''}>Đang hoạt động</option>
                        <option value="Inactive" ${formStatus == 'Inactive' || (empty formStatus && employee.status == 'Inactive') ? 'selected' : ''}>Ngưng hoạt động</option>
                    </select>
                    <i class="fas fa-lock"></i>
                </div>
            </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary" id="saveBtn">
                            <i class="fas fa-save"></i>
                            Cập nhật thông tin
                        </button>
                        <a href="${pageContext.request.contextPath}/ViewEmployeeServlet" class="btn btn-secondary">
                            <i class="fas fa-times"></i>
                            Hủy bỏ
                        </a>
                    </div>
                </form>
            </c:if>
        </div>
    </div>

    <script>
        // Form validation
        (function () {
            'use strict';
            
            const form = document.getElementById('employeeForm');
            const saveBtn = document.getElementById('saveBtn');
            
            if (form) {
                // Custom validation messages
                const validationMessages = {
                    fullName: 'Vui lòng nhập họ và tên đầy đủ',
                    gender: 'Vui lòng chọn giới tính',
                    specialization: 'Vui lòng chọn chuyên khoa',
                    dob: 'Vui lòng chọn ngày sinh'
                };

                // Real-time validation
                form.querySelectorAll('input, select').forEach(field => {
                    field.addEventListener('input', validateField);
                    field.addEventListener('blur', validateField);
                });

                function validateField(e) {
                    const field = e.target;
                    const wrapper = field.closest('.input-wrapper');
                    const messageEl = wrapper.querySelector('.validation-message');
                    
                    if (field.checkValidity()) {
                        field.style.borderColor = '#48bb78';
                        messageEl.textContent = '';
                        wrapper.querySelector('.input-icon').style.color = '#48bb78';
                    } else {
                        field.style.borderColor = '#e53e3e';
                        messageEl.textContent = validationMessages[field.name] || 'Vui lòng nhập thông tin hợp lệ';
                        wrapper.querySelector('.input-icon').style.color = '#e53e3e';
                    }
                }

                // Form submission
                form.addEventListener('submit', function(e) {
                    let isValid = true;
                    
                    // Validate all fields
                    form.querySelectorAll('input[required], select[required]').forEach(field => {
                        if (!field.checkValidity()) {
                            isValid = false;
                            validateField({ target: field });
                        }
                    });

                    if (!isValid) {
                        e.preventDefault();
                        e.stopPropagation();
                        
                        // Scroll to first error
                        const firstError = form.querySelector('input:invalid, select:invalid');
                        if (firstError) {
                            firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                            firstError.focus();
                        }
                        return;
                    }

                    // Show loading state
                    saveBtn.classList.add('btn-loading');
                    saveBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang lưu...';
                    saveBtn.disabled = true;
                });

                // Age validation for date of birth
                const dobField = document.getElementById('dob');
                if (dobField) {
                    dobField.addEventListener('change', function() {
                        const birthDate = new Date(this.value);
                        const today = new Date();
                        const age = today.getFullYear() - birthDate.getFullYear();
                        
                        if (age < 18 || age > 65) {
                            this.setCustomValidity('Tuổi phải từ 18 đến 65');
                        } else {
                            this.setCustomValidity('');
                        }
                        
                        validateField({ target: this });
                    });
                }
            }

            // Smooth animations
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.animation = 'fadeInUp 0.6s ease-out forwards';
                    }
                });
            });

            document.querySelectorAll('.form-group').forEach(group => {
                observer.observe(group);
            });
        })();

        // Add fadeInUp animation
        const style = document.createElement('style');
        style.textContent = `
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
        `;
        document.head.appendChild(style);
    </script>

    <div class="footer-wrapper">
        <jsp:include page="/assets/footer.jsp" />
    </div>
</body>
</html>

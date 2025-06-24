<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa hồ sơ bệnh nhân</title>
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
            padding: 20px;
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

        .header {
            background: linear-gradient(135deg, #e0f2fe 0%, #b3e5fc 100%);
            color: #0277bd;
            padding: 30px;
            text-align: center;
            position: relative;
            border-bottom: 1px solid #e1f5fe;
        }

        .header::before {
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

        .header h1 {
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
        }

        .header p {
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

        .input-icon {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #9ca3af;
            pointer-events: none;
        }

        .form-group.has-icon input {
            padding-left: 45px;
        }

        @media (max-width: 768px) {
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

            body {
                padding: 10px;
            }
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
    </style>
</head>
<body>
    <div class="main-container">
        <div class="header">
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
    </script>
</body>
</html>
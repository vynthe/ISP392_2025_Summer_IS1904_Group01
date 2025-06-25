<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hoàn thiện hồ sơ - Receptionist</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        html, body {
            height: 100%;
            overflow-x: hidden;
        }

        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
            position: relative;
        }

        /* Simplified animated background */
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 1px, transparent 1px);
            background-size: 50px 50px;
            animation: float 20s ease-in-out infinite;
            z-index: 0;
            pointer-events: none;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-20px); }
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

        @keyframes slideInScale {
            from {
                opacity: 0;
                transform: scale(0.9);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
        }

        .form-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            padding: 50px 40px;
            border-radius: 25px;
            box-shadow: 
                0 25px 50px rgba(0, 0, 0, 0.15),
                0 0 0 1px rgba(255, 255, 255, 0.1);
            position: relative;
            overflow: hidden;
            z-index: 1;
            width: 100%;
            max-width: 650px;
            animation: slideInScale 0.8s ease-out;
        }

        .form-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(90deg, #667eea, #764ba2, #f093fb, #f5576c);
            background-size: 400% 400%;
            animation: gradientMove 3s ease infinite;
            z-index: 10;
            border-radius: 25px 25px 0 0;
        }

        @keyframes gradientMove {
            0%, 100% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
        }

        .header-section {
            text-align: center;
            margin-bottom: 40px;
            animation: fadeInUp 0.8s ease-out 0.2s both;
        }

        .header-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }

        .header-icon i {
            font-size: 35px;
            color: white;
        }

        h2 {
            color: #2c3e50;
            margin: 0;
            font-size: 32px;
            font-weight: 700;
            letter-spacing: -0.5px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .subtitle {
            color: #6c757d;
            font-size: 16px;
            margin-top: 8px;
            font-weight: 400;
        }

        .form-group {
            margin-bottom: 25px;
            animation: fadeInUp 0.6s ease-out both;
            animation-delay: calc(var(--delay) * 0.1s);
        }

        .form-group:nth-child(1) { --delay: 3; }
        .form-group:nth-child(2) { --delay: 4; }
        .form-group:nth-child(3) { --delay: 5; }
        .form-group:nth-child(4) { --delay: 6; }
        .form-group:nth-child(5) { --delay: 7; }

        .form-label {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            font-size: 15px;
        }

        .form-label i {
            margin-right: 8px;
            color: #667eea;
            width: 16px;
        }

        .input-wrapper {
            position: relative;
        }

        .form-control,
        .form-select {
            width: 100%;
            padding: 16px 20px;
            border: 2px solid rgba(102, 126, 234, 0.1);
            border-radius: 15px;
            background: rgba(255, 255, 255, 0.8);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            font-size: 16px;
            color: #2c3e50;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        .form-control::placeholder {
            color: #adb5bd;
            font-weight: 400;
        }

        .form-control:hover,
        .form-select:hover {
            border-color: rgba(102, 126, 234, 0.3);
            background: rgba(255, 255, 255, 0.95);
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.15);
        }

        .form-control:focus,
        .form-select:focus {
            outline: none;
            border-color: #667eea;
            background: rgba(255, 255, 255, 1);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.2);
        }

        .btn-submit {
            width: 100%;
            padding: 18px;
            border: none;
            border-radius: 15px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            font-size: 18px;
            font-weight: 600;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            position: relative;
            overflow: hidden;
            margin-top: 20px;
            animation: fadeInUp 0.6s ease-out 0.8s both;
        }

        .btn-submit::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }

        .btn-submit:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(102, 126, 234, 0.4);
            background: linear-gradient(135deg, #5a67d8 0%, #6b46c1 100%);
        }

        .btn-submit:hover::before {
            left: 100%;
        }

        .btn-submit:active {
            transform: translateY(-1px);
        }

        .error {
            color: #dc3545;
            background: linear-gradient(135deg, rgba(220, 53, 69, 0.1), rgba(220, 53, 69, 0.05));
            border: 1px solid rgba(220, 53, 69, 0.2);
            padding: 15px 20px;
            border-radius: 12px;
            margin-top: 20px;
            text-align: center;
            font-weight: 500;
            animation: shake 0.5s ease-in-out;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            body {
                padding: 15px;
            }
            
            .form-container {
                padding: 30px 25px;
                border-radius: 20px;
            }

            h2 {
                font-size: 28px;
            }

            .header-icon {
                width: 70px;
                height: 70px;
            }

            .header-icon i {
                font-size: 30px;
            }

            .form-control,
            .form-select {
                padding: 14px 18px;
                font-size: 15px;
            }

            .btn-submit {
                padding: 16px;
                font-size: 16px;
            }
        }

        /* Error state styling */
        .error-input {
            border-color: #dc3545 !important;
            background: rgba(220, 53, 69, 0.05) !important;
        }

        .error-input:focus {
            box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.25) !important;
        }

        /* Loading state for button */
        .btn-submit.loading {
            pointer-events: none;
            opacity: 0.7;
        }

        .btn-submit.loading::after {
            content: '';
            position: absolute;
            width: 20px;
            height: 20px;
            border: 2px solid transparent;
            border-left-color: white;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
        }

        @keyframes spin {
            0% { transform: translate(-50%, -50%) rotate(0deg); }
            100% { transform: translate(-50%, -50%) rotate(360deg); }
        }
    </style>
    <script>
        function trimInput(event) {
            let input = event.target;
            input.value = input.value.trim();
        }

        document.addEventListener('DOMContentLoaded', function() {
            const form = document.querySelector('form');
            const submitBtn = document.querySelector('.btn-submit');
            
            // Add loading state to button on form submit
            form.addEventListener('submit', function() {
                submitBtn.classList.add('loading');
                submitBtn.innerHTML = 'Đang xử lý...';
            });

            // Style invalid inputs for HTML5 validation
            const inputs = document.querySelectorAll('input, select');
            inputs.forEach(input => {
                input.addEventListener('invalid', function() {
                    this.classList.add('error-input');
                });
                
                input.addEventListener('input', function() {
                    this.classList.remove('error-input');
                });
            });
        });
    </script>
</head>
<body>
    <div class="form-container">
        <div class="header-section">
            <div class="header-icon">
                <i class="fas fa-user-edit"></i>
            </div>
            <h2>Hoàn thiện hồ sơ</h2>
            <p class="subtitle">Vui lòng điền đầy đủ thông tin để hoàn tất đăng ký</p>
        </div>
        
        <form action="${pageContext.request.contextPath}/CompleteProfileController" method="post" onsubmit="trimInput(event)">
            <input type="hidden" name="userID" value="${sessionScope.user.userID}">
            
            <div class="form-group">
                <label for="fullName" class="form-label">
                    <i class="fas fa-user"></i>
                    Họ và tên
                </label>
                <div class="input-wrapper">
                    <input type="text" id="fullName" name="fullName" class="form-control" 
                           placeholder="Nhập họ và tên đầy đủ" 
                           maxlength="100" oninput="trimInput(event)" required>
                </div>
            </div>
            
            <div class="form-group">
                <label for="dob" class="form-label">
                    <i class="fas fa-calendar-alt"></i>
                    Ngày sinh
                </label>
                <div class="input-wrapper">
                    <input type="date" id="dob" name="dob" class="form-control" required>
                </div>
            </div>
            
            <div class="form-group">
                <label for="gender" class="form-label">
                    <i class="fas fa-venus-mars"></i>
                    Giới tính
                </label>
                <div class="input-wrapper">
                    <select id="gender" name="gender" class="form-select" required>
                        <option value="" disabled selected>Chọn giới tính</option>
                        <option value="Male">Nam</option>
                        <option value="Female">Nữ</option>
                        <option value="Other">Khác</option>
                    </select>
                </div>
            </div>
            
            <div class="form-group">
                <label for="phone" class="form-label">
                    <i class="fas fa-phone"></i>
                    Số điện thoại
                </label>
                <div class="input-wrapper">
                    <input type="tel" id="phone" name="phone" class="form-control" 
                           placeholder="Nhập số điện thoại (10 chữ số)" 
                           maxlength="10" oninput="trimInput(event)" required>
                </div>
            </div>
            
            <div class="form-group">
                <label for="address" class="form-label">
                    <i class="fas fa-map-marker-alt"></i>
                    Địa chỉ
                </label>
                <div class="input-wrapper">
                    <input type="text" id="address" name="address" class="form-control" 
                           placeholder="Nhập địa chỉ chi tiết" 
                           maxlength="255" oninput="trimInput(event)" required>
                </div>
            </div>
            
            <button type="submit" class="btn-submit">
                Hoàn thiện hồ sơ
            </button>
            
            <c:if test="${not empty error}">
                <div class="error">
                    <i class="fas fa-exclamation-triangle"></i>
                    ${error}
                </div>
            </c:if>
        </form>
    </div>
</body>
</html>
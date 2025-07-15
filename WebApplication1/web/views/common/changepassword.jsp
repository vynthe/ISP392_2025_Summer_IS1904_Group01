<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi Mật Khẩu</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 40px;
            width: 100%;
            max-width: 450px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .container::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent, rgba(255, 255, 255, 0.1), transparent);
            transform: rotate(45deg);
            animation: shimmer 3s infinite;
        }

        @keyframes shimmer {
            0% { transform: translateX(-100%) rotate(45deg); }
            100% { transform: translateX(100%) rotate(45deg); }
        }

        .header {
            position: relative;
            z-index: 1;
            margin-bottom: 30px;
        }

        .header-icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }

        .header-icon::before {
            content: '🔒';
            font-size: 24px;
        }

        h2 {
            color: #333;
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 10px;
        }

        .subtitle {
            color: #666;
            font-size: 14px;
            margin-bottom: 30px;
        }

        .form-content {
            position: relative;
            z-index: 1;
        }

        .form-group {
            margin-bottom: 25px;
            text-align: left;
            position: relative;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #555;
            font-size: 14px;
        }

        .input-wrapper {
            position: relative;
        }

        input[type="password"] {
            width: 100%;
            padding: 15px 20px;
            border: 2px solid #e1e5e9;
            border-radius: 12px;
            font-size: 16px;
            transition: all 0.3s ease;
            background: #fff;
            outline: none;
        }

        input[type="password"]:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            transform: translateY(-2px);
        }

        .input-icon {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
            cursor: pointer;
            font-size: 18px;
        }

        .password-toggle {
            user-select: none;
        }

        .btn {
            width: 100%;
            padding: 15px;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-bottom: 15px;
            position: relative;
            overflow: hidden;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 25px rgba(102, 126, 234, 0.4);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #6c757d, #5a6268);
            color: white;
            box-shadow: 0 8px 20px rgba(108, 117, 125, 0.3);
        }

        .btn-secondary:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 25px rgba(108, 117, 125, 0.4);
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

        .success-message {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            padding: 15px;
            border-radius: 12px;
            margin-bottom: 20px;
            font-weight: 500;
            box-shadow: 0 8px 20px rgba(40, 167, 69, 0.3);
            animation: slideIn 0.5s ease-out;
        }

        .error-message {
            background: linear-gradient(135deg, #dc3545, #e83e8c);
            color: white;
            padding: 15px;
            border-radius: 12px;
            margin-bottom: 20px;
            font-weight: 500;
            box-shadow: 0 8px 20px rgba(220, 53, 69, 0.3);
            animation: slideIn 0.5s ease-out;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .password-strength {
            margin-top: 8px;
            font-size: 12px;
            color: #666;
        }

        .strength-bar {
            width: 100%;
            height: 4px;
            background: #e1e5e9;
            border-radius: 2px;
            margin-top: 5px;
            overflow: hidden;
        }

        .strength-fill {
            height: 100%;
            width: 0%;
            transition: all 0.3s ease;
            border-radius: 2px;
        }

        .strength-weak { background: #dc3545; width: 25%; }
        .strength-fair { background: #ffc107; width: 50%; }
        .strength-good { background: #28a745; width: 75%; }
        .strength-strong { background: #007bff; width: 100%; }

        @media (max-width: 480px) {
            .container {
                padding: 30px 20px;
                margin: 10px;
            }
            
            h2 {
                font-size: 24px;
            }
            
            input[type="password"] {
                padding: 12px 15px;
                font-size: 14px;
            }
            
            .btn {
                padding: 12px;
                font-size: 14px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="header-icon"></div>
            <h2>Đổi Mật Khẩu</h2>
            <p class="subtitle">Cập nhật mật khẩu để bảo vệ tài khoản của bạn</p>
        </div>

        <div class="form-content">
            <!-- Hiển thị thông báo thành công -->
            <c:if test="${not empty successMessage}">
                <div class="success-message">${successMessage}</div>
            </c:if>
            
            <!-- Hiển thị thông báo lỗi -->
            <c:if test="${not empty error}">
                <div class="error-message">${error}</div>
            </c:if>
            
            <!-- Form đổi mật khẩu -->
            <form action="ChangePasswordController" method="post" id="changePasswordForm">
                <div class="form-group">
                    <label for="oldPassword">Mật khẩu hiện tại</label>
                    <div class="input-wrapper">
                        <input type="password" id="oldPassword" name="oldPassword" required>
                        <span class="input-icon password-toggle" onclick="togglePassword('oldPassword')">👁️</span>
                    </div>
                </div>

                <div class="form-group">
                    <label for="newPassword">Mật khẩu mới</label>
                    <div class="input-wrapper">
                        <input type="password" id="newPassword" name="newPassword" required oninput="checkPasswordStrength()">
                        <span class="input-icon password-toggle" onclick="togglePassword('newPassword')">👁️</span>
                    </div>
                    <div class="password-strength">
                        <div class="strength-bar">
                            <div class="strength-fill" id="strengthBar"></div>
                        </div>
                        <span id="strengthText">Nhập mật khẩu để xem độ mạnh</span>
                    </div>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Xác nhận mật khẩu mới</label>
                    <div class="input-wrapper">
                        <input type="password" id="confirmPassword" name="confirmPassword" required oninput="checkPasswordMatch()">
                        <span class="input-icon password-toggle" onclick="togglePassword('confirmPassword')">👁️</span>
                    </div>
                    <div id="matchMessage" style="font-size: 12px; margin-top: 5px;"></div>
                </div>

                <button type="submit" class="btn btn-primary">Đổi Mật Khẩu</button>
                <button type="button" class="btn btn-secondary" onclick="history.back()">Quay Lại</button>
            </form>
        </div>
    </div>

    <script>
        function togglePassword(fieldId) {
            const field = document.getElementById(fieldId);
            const icon = field.nextElementSibling;
            
            if (field.type === 'password') {
                field.type = 'text';
                icon.textContent = '🙈';
            } else {
                field.type = 'password';
                icon.textContent = '👁️';
            }
        }

        function checkPasswordStrength() {
            const password = document.getElementById('newPassword').value;
            const strengthBar = document.getElementById('strengthBar');
            const strengthText = document.getElementById('strengthText');
            
            if (password.length === 0) {
                strengthBar.className = 'strength-fill';
                strengthText.textContent = 'Nhập mật khẩu để xem độ mạnh';
                return;
            }
            
            let strength = 0;
            
            // Kiểm tra độ dài
            if (password.length >= 8) strength++;
            if (password.length >= 12) strength++;
            
            // Kiểm tra ký tự đặc biệt
            if (/[!@#$%^&*(),.?":{}|<>]/.test(password)) strength++;
            
            // Kiểm tra số
            if (/\d/.test(password)) strength++;
            
            // Kiểm tra chữ hoa và chữ thường
            if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength++;
            
            switch (strength) {
                case 0:
                case 1:
                    strengthBar.className = 'strength-fill strength-weak';
                    strengthText.textContent = 'Mật khẩu yếu';
                    strengthText.style.color = '#dc3545';
                    break;
                case 2:
                case 3:
                    strengthBar.className = 'strength-fill strength-fair';
                    strengthText.textContent = 'Mật khẩu trung bình';
                    strengthText.style.color = '#ffc107';
                    break;
                case 4:
                    strengthBar.className = 'strength-fill strength-good';
                    strengthText.textContent = 'Mật khẩu tốt';
                    strengthText.style.color = '#28a745';
                    break;
                case 5:
                    strengthBar.className = 'strength-fill strength-strong';
                    strengthText.textContent = 'Mật khẩu mạnh';
                    strengthText.style.color = '#007bff';
                    break;
            }
        }

        function checkPasswordMatch() {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const matchMessage = document.getElementById('matchMessage');
            
            if (confirmPassword.length === 0) {
                matchMessage.textContent = '';
                return;
            }
            
            if (newPassword === confirmPassword) {
                matchMessage.textContent = '✓ Mật khẩu khớp';
                matchMessage.style.color = '#28a745';
            } else {
                matchMessage.textContent = '✗ Mật khẩu không khớp';
                matchMessage.style.color = '#dc3545';
            }
        }

        // Ngăn submit form nếu mật khẩu không khớp
        document.getElementById('changePasswordForm').addEventListener('submit', function(e) {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (newPassword !== confirmPassword) {
                e.preventDefault();
                alert('Mật khẩu xác nhận không khớp!');
            }
        });
    </script>
</body>
</html>
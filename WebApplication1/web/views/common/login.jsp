<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <title>Đăng nhập - Nha Khoa PDC</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            overflow-x: hidden;
        }

        /* Animated background */
        .bg-animation {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .bg-animation::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><radialGradient id="a" cx=".66" cy=".33" r=".6"><stop offset="0" stop-color="%23ffffff" stop-opacity="0.1"/><stop offset="1" stop-color="%23ffffff" stop-opacity="0"/></radialGradient></defs><circle cx="33" cy="33" r="10" fill="url(%23a)"/><circle cx="66" cy="66" r="15" fill="url(%23a)"/><circle cx="20" cy="80" r="8" fill="url(%23a)"/><circle cx="80" cy="20" r="12" fill="url(%23a)"/></svg>') repeat;
            animation: float 20s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(180deg); }
        }

        /* Header - với glassmorphism effect */
        header {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            position: sticky;
            top: 0;
            z-index: 1000;
            transition: all 0.3s ease;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
        }

        .logo {
            display: flex;
            align-items: center;
            color: white;
        }

        .logo i {
            font-size: 28px;
            margin-right: 12px;
            color: #ffd700;
        }

        .logo h1 {
            font-size: 28px;
            font-weight: 700;
            margin: 0;
            background: linear-gradient(45deg, #fff, #f0f0f0);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .logo span {
            font-size: 14px;
            opacity: 0.9;
            margin-left: 10px;
            color: rgba(255, 255, 255, 0.8);
        }

        nav {
            display: flex;
            gap: 30px;
        }

        nav a {
            color: white;
            text-decoration: none;
            font-weight: 500;
            padding: 8px 16px;
            border-radius: 25px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        nav a::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }

        nav a:hover::before {
            left: 100%;
        }

        nav a:hover {
            background: rgba(255,255,255,0.2);
            transform: translateY(-2px);
        }

        .nav-buttons {
            display: flex;
            gap: 10px;
        }

        .btn {
            padding: 10px 24px;
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-radius: 25px;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            color: white;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .btn:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }

        .btn.active {
            background: rgba(255, 255, 255, 0.3);
            border-color: rgba(255, 255, 255, 0.5);
        }

        /* Main content */
        .main-content {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 50px 20px;
            background: rgba(39, 39, 39, 0.4);
        }

        /* Form Container - với glassmorphism effect */
        .form-container {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 25px 45px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 450px;
            position: relative;
            overflow: hidden;
        }

        .form-container::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
            animation: shimmer 3s ease-in-out infinite;
        }

        @keyframes shimmer {
            0%, 100% { transform: rotate(0deg); }
            50% { transform: rotate(180deg); }
        }

        .form-box {
            position: relative;
            z-index: 2;
            animation: fadeInUp 0.6s ease;
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

        .form-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .form-header h2 {
            font-size: 32px;
            color: #fff;
            margin-bottom: 10px;
            font-weight: 700;
            background: linear-gradient(45deg, #fff, #f0f0f0);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .form-header p {
            color: rgba(255, 255, 255, 0.8);
            font-size: 16px;
        }

        .form-header p a {
            color: #fff;
            text-decoration: none;
            font-weight: 600;
            position: relative;
        }

        .form-header p a::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 0;
            height: 2px;
            background: #fff;
            transition: width 0.3s ease;
        }

        .form-header p a:hover::after {
            width: 100%;
        }

        .input-box {
            position: relative;
            margin-bottom: 20px;
        }

        .input-field {
            width: 100%;
            padding: 15px 20px 15px 50px;
            background: rgba(255, 255, 255, 0.1);
            border: 2px solid rgba(255, 255, 255, 0.2);
            border-radius: 15px;
            color: #fff;
            font-size: 16px;
            outline: none;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
        }

        .input-field:focus {
            border-color: rgba(255, 255, 255, 0.5);
            background: rgba(255, 255, 255, 0.15);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .input-field::placeholder {
            color: rgba(255, 255, 255, 0.7);
        }

        select.input-field option {
            background: #667eea;
            color: #fff;
        }

        .input-box i {
            position: absolute;
            left: 18px;
            top: 50%;
            transform: translateY(-50%);
            color: rgba(255, 255, 255, 0.7);
            font-size: 18px;
            transition: all 0.3s ease;
        }

        .input-field:focus + i {
            color: #fff;
            transform: translateY(-50%) scale(1.1);
        }

        .submit {
            width: 100%;
            padding: 15px;
            background: linear-gradient(45deg, #fff, #f0f0f0);
            border: none;
            border-radius: 15px;
            color: #667eea;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
            position: relative;
            overflow: hidden;
        }

        .submit::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
            transition: left 0.5s ease;
        }

        .submit:hover::before {
            left: 100%;
        }

        .submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
        }

        .two-col {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 20px;
            color: rgba(255, 255, 255, 0.8);
            font-size: 14px;
        }

        .two-col .one {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .two-col input[type="checkbox"] {
            appearance: none;
            width: 18px;
            height: 18px;
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-radius: 4px;
            background: rgba(255, 255, 255, 0.1);
            cursor: pointer;
            position: relative;
            transition: all 0.3s ease;
        }

        .two-col input[type="checkbox"]:checked {
            background: #fff;
            border-color: #fff;
        }

        .two-col input[type="checkbox"]:checked::after {
            content: '✓';
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: #667eea;
            font-weight: bold;
            font-size: 12px;
        }

        .two-col a {
            color: #fff;
            text-decoration: none;
            position: relative;
        }

        .two-col a::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 0;
            height: 1px;
            background: #fff;
            transition: width 0.3s ease;
        }

        .two-col a:hover::after {
            width: 100%;
        }

        /* Message styles */
        .success, .error {
            padding: 15px 20px;
            border-radius: 10px;
            margin-top: 15px;
            font-size: 14px;
            font-weight: 500;
            animation: slideIn 0.3s ease;
        }

        .success {
            background: rgba(76, 175, 80, 0.2);
            border: 1px solid rgba(76, 175, 80, 0.5);
            color: #4caf50;
        }

        .error {
            background: rgba(244, 67, 54, 0.2);
            border: 1px solid rgba(244, 67, 54, 0.5);
            color: #f44336;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Switch forms */
        .form-switch {
            text-align: center;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.2);
        }

        .form-switch .btn {
            background: rgba(255, 255, 255, 0.1);
            color: #fff;
            border: 2px solid rgba(255, 255, 255, 0.3);
            padding: 8px 20px;
            font-size: 14px;
        }

        .form-switch .btn:hover {
            background: rgba(255, 255, 255, 0.2);
            color: #fff;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .header-content {
                flex-direction: column;
                gap: 20px;
            }

            nav {
                flex-wrap: wrap;
                justify-content: center;
                gap: 15px;
            }

            .form-container {
                padding: 30px 20px;
                margin: 0 10px;
            }

            .form-header h2 {
                font-size: 28px;
            }

            .two-col {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
        }

        @media (max-width: 480px) {
            .form-container {
                padding: 25px 15px;
            }

            .form-header h2 {
                font-size: 24px;
            }

            .input-field {
                padding: 12px 15px 12px 45px;
            }

            .input-box i {
                left: 15px;
                font-size: 16px;
            }
        }
    </style>
</head>
<body>
    <!-- Animated Background -->
    <div class="bg-animation"></div>
    
    <!-- Header -->
    <header>
        <div class="container">
            <div class="header-content">
                <!-- Logo -->
                <div class="logo">
                    <i class="fas fa-tooth"></i>
                    <div>
                        <h1>PDC</h1>
                        <span>Nha Khoa PDC</span>
                    </div>
                </div>
                
                <!-- Navigation -->
                <nav>
                    <a href="${pageContext.request.contextPath}/views/common/HomePage.jsp">
                        <i class="fas fa-home"></i> Trang chủ
                    </a>
                    <a href="#">
                        <i class="fas fa-blog"></i> Blog
                    </a>
                    <a href="#">
                        <i class="fas fa-concierge-bell"></i> Dịch vụ
                    </a>
                    <a href="#">
                        <i class="fas fa-info-circle"></i> Về chúng tôi
                    </a>
                </nav>
                
                <!-- Auth Buttons -->
                <div class="nav-buttons">
                    <a href="javascript:void(0)" class="btn" id="loginBtn">
                        <i class="fas fa-sign-in-alt"></i> Đăng nhập
                    </a>
                    <a href="javascript:void(0)" class="btn" id="registerBtn">
                        <i class="fas fa-user-plus"></i> Đăng ký
                    </a>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <div class="main-content">
        <div class="form-container">
            <!-- Login Form -->
            <div class="form-box" id="login" style="display: ${empty param.form || param.form == 'login' ? 'block' : 'none'};">
                <div class="form-header">
                    <h2>Đăng Nhập</h2>
                    <p>Chào mừng bạn trở lại! <a href="javascript:void(0)" onclick="register()">Đăng ký tài khoản mới</a></p>
                </div>
                
                <form action="${pageContext.request.contextPath}/login" method="post">
                    <div class="input-box">
                        <input type="text" class="input-field" name="emailOrUsername" placeholder="Email hoặc Username" maxlength="50" required>
                        <i class="fas fa-user"></i>
                    </div>
                    <div class="input-box">
                        <input type="password" class="input-field" name="password" placeholder="Mật khẩu" maxlength="20" required>
                        <i class="fas fa-lock"></i>
                    </div>
                    <div class="input-box">
                        <input type="submit" class="submit" value="Đăng Nhập">
                    </div>
                    <div class="two-col">
                        <div class="one">
                            <input type="checkbox" id="login-check" name="rememberMe">
                            <label for="login-check">Ghi nhớ đăng nhập</label>
                        </div>
                        <div class="two">
                            <a href="${pageContext.request.contextPath}/ForgotPasswordServlet">Quên mật khẩu?</a>
                        </div>
                    </div>

                    <c:if test="${not empty sessionScope.logoutMessage}">
                        <div class="success">
                            <i class="fas fa-check-circle"></i>
                            ${sessionScope.logoutMessage}
                        </div>
                        <c:remove var="logoutMessage" scope="session" />
                    </c:if>

                    <c:if test="${not empty requestScope.error}">  
                        <div class="error">
                            <i class="fas fa-exclamation-circle"></i>
                            ${requestScope.error}
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty sessionScope.successMessage}">
                        <div class="success">
                            <i class="fas fa-check-circle"></i>
                            ${sessionScope.successMessage}
                        </div>
                        <c:remove var="successMessage" scope="session" />
                    </c:if>
                </form>
            </div>

            <!-- Registration Form -->
            <div class="form-box" id="register" style="display: ${param.form == 'register' ? 'block' : 'none'};">
                <div class="form-header">
                    <h2>Đăng Ký</h2>
                    <p>Tạo tài khoản mới để sử dụng dịch vụ! <a href="javascript:void(0)" onclick="login()">Đã có tài khoản?</a></p>
                </div>
                
                <form action="${pageContext.request.contextPath}/RegistrationServlet" method="post" id="registerForm">
                    <div class="input-box">
                        <input type="text" class="input-field" name="username" value="${requestScope.username}" placeholder="Tên đăng nhập" maxlength="20" required>
                        <i class="fas fa-user"></i>
                    </div>
                    <div class="input-box">        
                        <input type="email" class="input-field" name="email" value="${requestScope.email}" placeholder="Địa chỉ email" maxlength="50" required>
                        <i class="fas fa-envelope"></i>
                    </div>
                    <div class="input-box">
                        <input type="password" class="input-field" name="password" placeholder="Mật khẩu" maxlength="20" required>   
                        <i class="fas fa-lock"></i>
                    </div>
                    <div class="input-box">
                        <select name="role" class="input-field" required>
                            <option value="" disabled ${requestScope.role == null ? 'selected' : ''}>Chọn vai trò</option>
                            <option value="patient" ${requestScope.role == 'patient' ? 'selected' : ''}>Bệnh nhân</option>
                            <option value="doctor" ${requestScope.role == 'doctor' ? 'selected' : ''}>Bác sĩ</option>
                            <option value="nurse" ${requestScope.role == 'nurse' ? 'selected' : ''}>Y tá</option>
                            <option value="receptionist" ${requestScope.role == 'receptionist' ? 'selected' : ''}>Lễ tân</option>
                        </select>
                        <i class="fas fa-user-md"></i>
                    </div>
                    <div class="input-box">
                        <input type="submit" class="submit" value="Đăng Ký">
                    </div>
                    <div class="two-col">
                        <div class="one">
                            <input type="checkbox" id="register-check" name="rememberMe">
                            <label for="register-check">Ghi nhớ đăng nhập</label>
                        </div>
                        <div class="two">
                            <a href="#">Điều khoản sử dụng</a>
                        </div>
                    </div>
                    
                    <c:if test="${not empty requestScope.error}">
                        <div class="error">
                            <i class="fas fa-exclamation-circle"></i>
                            ${requestScope.error}
                        </div>
                    </c:if>
                </form>
            </div>
        </div>
    </div>

    <script>
        function login() {
            document.getElementById('register').style.display = 'none';
            document.getElementById('login').style.display = 'block';
            // Add animation
            document.getElementById('login').style.animation = 'fadeInUp 0.6s ease';
            
            // Update nav buttons
            document.getElementById('loginBtn').classList.add('active');
            document.getElementById('registerBtn').classList.remove('active');
        }

        function register() {
            document.getElementById('login').style.display = 'none';
            document.getElementById('register').style.display = 'block';
            // Add animation
            document.getElementById('register').style.animation = 'fadeInUp 0.6s ease';
            
            // Update nav buttons
            document.getElementById('registerBtn').classList.add('active');
            document.getElementById('loginBtn').classList.remove('active');
        }

        // Add event listeners to navigation buttons
        document.getElementById('loginBtn').addEventListener('click', login);
        document.getElementById('registerBtn').addEventListener('click', register);

        // Set initial active state
        const urlParams = new URLSearchParams(window.location.search);
        const form = urlParams.get('form');
        if (form === 'register') {
            document.getElementById('registerBtn').classList.add('active');
        } else {
            document.getElementById('loginBtn').classList.add('active');
        }

        // Trim whitespace for registration form inputs
        document.getElementById('registerForm').addEventListener('submit', function(event) {
            const inputs = this.querySelectorAll('input[type="text"], input[type="email"], input[type="password"]');
            inputs.forEach(input => {
                input.value = input.value.trim();
            });
        });

        // Add floating animation to form inputs
        document.querySelectorAll('.input-field').forEach(input => {
            input.addEventListener('focus', function() {
                this.parentElement.style.transform = 'translateY(-2px)';
            });
            
            input.addEventListener('blur', function() {
                this.parentElement.style.transform = 'translateY(0)';
            });
        });

        // Smooth navigation scroll effect
        window.addEventListener('scroll', function() {
            const header = document.querySelector('header');
            if (window.scrollY > 50) {
                header.style.background = 'rgba(255, 255, 255, 0.15)';
            } else {
                header.style.background = 'rgba(255, 255, 255, 0.1)';
            }
        });
    </script>
</body>
</html>
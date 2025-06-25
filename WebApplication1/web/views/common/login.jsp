<%-- 
    Document   : login
    Created on : Feb 27, 2025, 2:28:51 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hệ thống quản lí phòng khám đa khoa</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
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

        .wrapper {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background: rgba(39, 39, 39, 0.4);
            padding: 20px;
            width: 100%;
            height: auto;
        }

        /* Navigation */
        .nav {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 70px;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 5%;
            z-index: 1000;
            transition: all 0.3s ease;
        }

        .nav-logo a {
            color: #fff;
            text-decoration: none;
            font-size: 2rem;
            font-weight: 700;
            background: linear-gradient(45deg, #fff, #f0f0f0);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .nav-menu ul {
            display: flex;
            list-style: none;
            gap: 2rem;
        }

        .nav-menu .link {
            color: #fff;
            text-decoration: none;
            font-weight: 500;
            padding: 0.5rem 1rem;
            border-radius: 25px;
            transition: all 0.3s ease;
            position: relative;
        }

        .nav-menu .link:hover,
        .nav-menu .link.active {
            background: rgba(255, 255, 255, 0.2);
            transform: translateY(-2px);
        }

        .nav-button {
            display: flex;
            gap: 1rem;
        }

        .nav-button .btn {
            padding: 0.7rem 1.5rem;
            border: none;
            border-radius: 25px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
            font-size: 0.9rem;
        }

        .nav-button .btn:first-child {
            background: rgba(255, 255, 255, 0.2);
            color: #fff;
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        .nav-button .btn:last-child {
            background: #fff;
            color: #667eea;
            font-weight: 600;
        }

        .nav-button .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }

        /* Form Container */
        .form-container {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 20px;
            padding: 3rem;
            width: 100%;
            max-width: 450px;
            box-shadow: 0 25px 45px rgba(0, 0, 0, 0.1);
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

        .top {
            text-align: center;
            margin-bottom: 2rem;
        }

        .top span {
            color: rgba(255, 255, 255, 0.8);
            font-size: 0.9rem;
            display: block;
            margin-bottom: 0.5rem;
        }

        .top span a {
            color: #fff;
            text-decoration: none;
            font-weight: 600;
            position: relative;
        }

        .top span a::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 0;
            height: 2px;
            background: #fff;
            transition: width 0.3s ease;
        }

        .top span a:hover::after {
            width: 100%;
        }

        header {
            color: #fff;
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            background: linear-gradient(45deg, #fff, #f0f0f0);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .input-box {
            position: relative;
            margin-bottom: 1.5rem;
        }

        .input-field {
            width: 100%;
            padding: 1rem 1rem 1rem 3rem;
            background: rgba(255, 255, 255, 0.1);
            border: 2px solid rgba(255, 255, 255, 0.2);
            border-radius: 15px;
            color: #fff;
            font-size: 1rem;
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
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: rgba(255, 255, 255, 0.7);
            font-size: 1.2rem;
            transition: all 0.3s ease;
        }

        .input-field:focus + i {
            color: #fff;
            transform: translateY(-50%) scale(1.1);
        }

        .submit {
            width: 100%;
            padding: 1rem;
            background: linear-gradient(45deg, #fff, #f0f0f0);
            border: none;
            border-radius: 15px;
            color: #667eea;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 1rem;
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
            margin-top: 1.5rem;
            color: rgba(255, 255, 255, 0.8);
            font-size: 0.9rem;
        }

        .two-col .one {
            display: flex;
            align-items: center;
            gap: 0.5rem;
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
            padding: 0.8rem;
            border-radius: 10px;
            margin-top: 1rem;
            font-size: 0.9rem;
            text-align: center;
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

        /* Responsive Design */
        @media (max-width: 768px) {
            .nav {
                padding: 0 3%;
            }

            .nav-menu {
                display: none;
            }

            .nav-button .btn {
                padding: 0.5rem 1rem;
                font-size: 0.8rem;
            }

            .form-container {
                padding: 2rem;
                margin: 0 1rem;
            }

            header {
                font-size: 2rem;
            }

            .two-col {
                flex-direction: column;
                gap: 1rem;
                text-align: center;
            }
        }

        @media (max-width: 480px) {
            .nav-logo a {
                font-size: 1.5rem;
            }

            .form-container {
                padding: 1.5rem;
            }

            header {
                font-size: 1.8rem;
            }

            .input-field {
                padding: 0.8rem 0.8rem 0.8rem 2.5rem;
            }

            .input-box i {
                left: 0.8rem;
            }
        }
    </style>
</head>
<body>
    <div class="bg-animation"></div>
    
    <div class="wrapper">
        <nav class="nav">
            <div class="nav-logo">
                <a href="${pageContext.request.contextPath}/views/common/HomePage.jsp">PDC</a>
            </div>
            <div class="nav-menu">
                <ul>
                    <li><a href="${pageContext.request.contextPath}/views/common/HomePage.jsp" class="link active">Home</a></li>
                    <li><a href="interface/Blog.jsp" class="link">Blog</a></li>
                    <li><a href="interface/Service.jsp" class="link">Services</a></li>
                    <li><a href="interface/About.jsp" class="link">About</a></li>
                </ul>
            </div>
            <div class="nav-button">
                <button class="btn" id="loginBtn">Sign In</button>
                <button class="btn" id="registerBtn">Sign Up</button>
            </div>
        </nav>

        <div class="form-container">
            <!-- Login Form -->
            <div class="form-box" id="login" style="display: ${empty param.form || param.form == 'login' ? 'block' : 'none'};">
                <div class="top">
                    <span>Không có tài khoản? <a href="javascript:void(0)" onclick="register()">Sign Up</a></span>
                    <header>Đăng Nhập</header>
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
                            <label for="login-check">Ghi nhớ</label>
                        </div>
                        <div class="two">
                            <label><a href="${pageContext.request.contextPath}/ForgotPasswordServlet">Quên mật khẩu?</a></label>
                        </div>
                    </div>

                    <c:if test="${not empty sessionScope.logoutMessage}">
                        <div class="success">
                            ${sessionScope.logoutMessage}
                        </div>
                        <c:remove var="logoutMessage" scope="session" />
                    </c:if>

                    <c:if test="${not empty requestScope.error}">  
                        <div class="error">${requestScope.error}</div>
                    </c:if>
                    
                    <c:if test="${not empty sessionScope.successMessage}">
                        <div class="success">${sessionScope.successMessage}</div>
                        <c:remove var="successMessage" scope="session" />
                    </c:if>
                </form>
            </div>

            <!-- Registration Form -->
            <div class="form-box" id="register" style="display: ${param.form == 'register' ? 'block' : 'none'};">
                <div class="top">
                    <span>Có tài khoản? <a href="javascript:void(0)" onclick="login()">Sign In</a></span>
                    <header>Sign Up</header>
                </div>
                <form action="${pageContext.request.contextPath}/RegistrationServlet" method="post" id="registerForm">
                    <div class="input-box">
                        <input type="text" class="input-field" name="username" value="${requestScope.username}" placeholder="Username" maxlength="20" required>
                        <i class="fas fa-user"></i>
                    </div>
                    <div class="input-box">        
                        <input type="email" class="input-field" name="email" value="${requestScope.email}" placeholder="Email" maxlength="50" required>
                        <i class="fas fa-envelope"></i>
                    </div>
                    <div class="input-box">
                        <input type="password" class="input-field" name="password" placeholder="Password" maxlength="20" required>   
                        <i class="fas fa-lock"></i>
                    </div>
                    <div class="input-box">
                        <select name="role" class="input-field" required>
                            <option value="" disabled ${requestScope.role == null ? 'selected' : ''}>Chọn vai trò</option>
                            <option value="patient" ${requestScope.role == 'patient' ? 'selected' : ''}>Patient</option>
                            <option value="doctor" ${requestScope.role == 'doctor' ? 'selected' : ''}>Doctor</option>
                            <option value="nurse" ${requestScope.role == 'nurse' ? 'selected' : ''}>Nurse</option>
                            <option value="receptionist" ${requestScope.role == 'receptionist' ? 'selected' : ''}>Receptionist</option>
                        </select>
                        <i class="fas fa-user-md"></i>
                    </div>
                    <div class="input-box">
                        <input type="submit" class="submit" value="Register">
                    </div>
                    <div class="two-col">
                        <div class="one">
                            <input type="checkbox" id="register-check" name="rememberMe">
                            <label for="register-check">Remember Me</label>
                        </div>
                        <div class="two">
                            <label><a href="#">Terms & conditions</a></label>
                        </div>
                    </div>
                    
                    <c:if test="${not empty requestScope.error}">
                        <div class="error">${requestScope.error}</div>
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
        }

        function register() {
            document.getElementById('login').style.display = 'none';
            document.getElementById('register').style.display = 'block';
            // Add animation
            document.getElementById('register').style.animation = 'fadeInUp 0.6s ease';
        }

        // Add event listeners to navigation buttons
        document.getElementById('loginBtn').addEventListener('click', login);
        document.getElementById('registerBtn').addEventListener('click', register);

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
            const nav = document.querySelector('.nav');
            if (window.scrollY > 50) {
                nav.style.background = 'rgba(255, 255, 255, 0.15)';
            } else {
                nav.style.background = 'rgba(255, 255, 255, 0.1)';
            }
        });
    </script>
</body>
</html>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quên Mật Khẩu - Hệ thống quản lí phòng khám đa khoa</title>
        <!-- Font Awesome for icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }
            body {
                background: linear-gradient(135deg, #e6f0fa 0%, #b3c6e2 100%);
                font-family: 'Arial', sans-serif;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                justify-content: flex-start;
                align-items: center;
            }
            .wrapper {
                width: 100%;
                min-height: 100vh;
                background: url('path/to/your-background-image.jpg') no-repeat center center fixed;
                background-size: cover;
                display: flex;
                flex-direction: column;
            }
            .nav {
                background: #2c3e50;
                padding: 15px 30px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                width: 100%;
                color: #fff;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
            }
            .nav-logo p {
                font-size: 1.5rem;
                font-weight: bold;
                margin: 0;
            }
            .nav-menu ul {
                list-style: none;
                display: flex;
                margin: 0;
                padding: 0;
            }
            .nav-menu ul li {
                margin: 0 20px;
            }
            .nav-menu ul li a {
                color: #fff;
                text-decoration: none;
                font-size: 1rem;
                transition: color 0.3s ease;
            }
            .nav-menu ul li a:hover {
                color: #3498db;
            }
            .nav-button .btn {
                background: #3498db;
                color: #fff;
                border: none;
                padding: 8px 20px;
                border-radius: 5px;
                cursor: pointer;
                font-size: 1rem;
                margin-left: 10px;
                transition: background 0.3s ease;
            }
            .nav-button .btn:hover {
                background: #2980b9;
            }
            .form-box {
                flex: 1;
                display: flex;
                justify-content: center;
                align-items: center;
                padding: 20px;
            }
            .form-container {
                background: #fff;
                padding: 40px;
                border-radius: 10px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                width: 100%;
                max-width: 500px;
                text-align: center;
            }
            .form-container header {
                font-size: 2.5rem;
                font-weight: 600;
                color: #2c3e50;
                margin-bottom: 30px;
            }
            .input-box {
                position: relative;
                margin: 20px 0;
            }
            .input-field {
                width: 100%;
                padding: 15px 40px 15px 15px;
                border: 1px solid #ddd;
                border-radius: 5px;
                font-size: 1.1rem;
                transition: border-color 0.3s ease, box-shadow 0.3s ease;
            }
            .input-field:focus {
                border-color: #3498db;
                outline: none;
                box-shadow: 0 0 8px rgba(52, 152, 219, 0.2);
            }
            .input-box i {
                position: absolute;
                right: 15px;
                top: 50%;
                transform: translateY(-50%);
                color: #777;
                font-size: 1.3rem;
            }
            .submit {
                width: 100%;
                padding: 15px;
                background: #3498db;
                color: #fff;
                border: none;
                border-radius: 5px;
                font-size: 1.1rem;
                font-weight: 500;
                cursor: pointer;
                transition: background 0.3s ease, transform 0.1s ease;
            }
            .submit:hover {
                background: #2980b9;
                transform: scale(1.02);
            }
            .submit:active {
                transform: scale(0.98);
            }
            .error, .success {
                margin-top: 20px;
                padding: 12px;
                border-radius: 5px;
                font-size: 1rem;
                text-align: center;
            }
            .error {
                background: #f8d7da;
                color: #721c24;
            }
            .success {
                background: #d4edda;
                color: #155724;
            }
            @media (max-width: 600px) {
                .nav {
                    flex-direction: column;
                    align-items: flex-start;
                    padding: 15px;
                }
                .nav-menu ul {
                    flex-direction: column;
                    margin-top: 10px;
                }
                .nav-menu ul li {
                    margin: 10px 0;
                }
                .nav-button {
                    margin-top: 10px;
                }
                .form-container {
                    padding: 20px;
                }
                .form-container header {
                    font-size: 2rem;
                }
                .input-field, .submit {
                    font-size: 1rem;
                }
            }
        </style>
    </head>
    <body>
        <div class="wrapper">
            <nav class="nav">
                <div class="nav-logo">
                    <p>Group 1</p>
                </div>
                <div class="nav-menu">
                    <ul>
                        <li><a href="views/common/login.jsp" class="link">Home</a></li>
                        <li><a href="interface/Blog.jsp" class="link">Blog</a></li>
                        <li><a href="interface/Service.jsp" class="link">Services</a></li>
                        <li><a href="interface/About.jsp" class="link">About</a></li>
                    </ul>
                </div>
                <div class="nav-button">
                    <button class="btn" onclick="window.location.href='${pageContext.request.contextPath}/UserLoginController'">Sign In</button>
                 
                </div>
            </nav>

            <div class="form-box">
                <div class="form-container">
                    <header>Quên Mật Khẩu</header>
                    <form action="${pageContext.request.contextPath}/ForgotPasswordServlet" method="post">
                        <div class="input-box">
                            <input type="email" class="input-field" name="email" placeholder="Nhập email của bạn" value="${email}" required>
                            <i class="fas fa-envelope"></i>
                        </div>
                        <div class="input-box">
                            <input type="submit" class="submit" value="Xác Minh">
                        </div>
                        <c:if test="${not empty error}">
                            <div class="error">${error}</div>
                        </c:if>
                        <c:if test="${not empty success}">
                            <div class="success">${success}</div>
                        </c:if>
                    </form>
                </div>
            </div>
        </div>
    </body>
</html>
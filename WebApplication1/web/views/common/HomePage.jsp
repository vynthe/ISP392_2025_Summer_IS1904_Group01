<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Nha Khoa PDC - Nụ cười tự tin, sức khỏe hoàn hảo</title>
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
                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                position: relative;
            }

            /* Header */
            header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                box-shadow: 0 4px 20px rgba(0,0,0,0.1);
                position: sticky;
                top: 0;
                z-index: 1000;
                backdrop-filter: blur(10px);
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
                text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
            }

            .logo span {
                font-size: 14px;
                opacity: 0.9;
                margin-left: 10px;
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
                border: 2px solid white;
                border-radius: 25px;
                background: transparent;
                color: white;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-block;
            }

            .btn:hover {
                background: white;
                color: #667eea;
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            }

            /* Banner */
            .banner {
                background: linear-gradient(135deg, rgba(102, 126, 234, 0.9), rgba(118, 75, 162, 0.9)),
                    url('https://images.unsplash.com/photo-1606811841689-23dfddce3e95?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80');
                background-size: cover;
                background-position: center;
                background-attachment: fixed;
                padding: 100px 0;
                text-align: center;
                color: white;
                position: relative;
                overflow: hidden;
            }

            .banner::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: linear-gradient(45deg, rgba(102, 126, 234, 0.8), rgba(118, 75, 162, 0.8));
                animation: gradientShift 6s ease-in-out infinite alternate;
            }

            @keyframes gradientShift {
                0% {
                    background: linear-gradient(45deg, rgba(102, 126, 234, 0.8), rgba(118, 75, 162, 0.8));
                }
                100% {
                    background: linear-gradient(45deg, rgba(118, 75, 162, 0.8), rgba(102, 126, 234, 0.8));
                }
            }

            .banner-content {
                position: relative;
                z-index: 2;
            }

            .banner h2 {
                font-size: 48px;
                font-weight: 700;
                margin-bottom: 20px;
                text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
                animation: fadeInUp 1s ease-out;
            }

            .banner p {
                font-size: 20px;
                margin-bottom: 15px;
                opacity: 0.95;
                animation: fadeInUp 1s ease-out 0.3s both;
            }

            .banner .slogan {
                font-size: 24px;
                font-weight: 600;
                margin: 30px 0;
                padding: 20px;
                background: rgba(255,255,255,0.1);
                border-radius: 15px;
                backdrop-filter: blur(10px);
                animation: fadeInUp 1s ease-out 0.6s both;
            }

            /* Banner Actions */
            .banner-actions {
                margin-top: 40px;
                display: flex;
                flex-direction: column;
                align-items: center;
                gap: 20px;
            }

            .cta-button {
                display: inline-block;
                background: linear-gradient(135deg, #ff6b6b, #ee5a24);
                color: white;
                padding: 18px 50px;
                border-radius: 35px;
                text-decoration: none;
                font-weight: 700;
                font-size: 20px;
                box-shadow: 0 10px 30px rgba(238, 90, 36, 0.4);
                transition: all 0.4s ease;
                animation: fadeInUp 1s ease-out 0.9s both;
                position: relative;
                overflow: hidden;
            }

            .cta-button::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
                transition: left 0.6s;
            }

            .cta-button:hover::before {
                left: 100%;
            }

            .cta-button:hover {
                transform: translateY(-4px) scale(1.05);
                box-shadow: 0 15px 40px rgba(238, 90, 36, 0.6);
            }

            .cta-button i {
                margin-right: 10px;
                font-size: 18px;
            }

            /* Success Message */
            .success-message {
                background: linear-gradient(135deg, #4CAF50, #45a049);
                color: white;
                padding: 15px 30px;
                border-radius: 25px;
                font-size: 18px;
                font-weight: 600;
                box-shadow: 0 8px 25px rgba(76, 175, 80, 0.3);
                animation: successPulse 2s ease-in-out;
                backdrop-filter: blur(10px);
                border: 2px solid rgba(255,255,255,0.2);
            }

            @keyframes successPulse {
                0% {
                    transform: scale(0.8);
                    opacity: 0;
                }
                50% {
                    transform: scale(1.05);
                }
                100% {
                    transform: scale(1);
                    opacity: 1;
                }
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

            /* Services Section */
            .services {
                padding: 80px 0;
                background: white;
                position: relative;
            }

            .services::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 100px;
                background: linear-gradient(to bottom, rgba(102, 126, 234, 0.1), transparent);
            }

            .services-header {
                text-align: center;
                margin-bottom: 60px;
            }

            .services h2 {
                font-size: 42px;
                color: #2c3e50;
                margin-bottom: 20px;
                position: relative;
                display: inline-block;
            }

            .services h2::after {
                content: '';
                position: absolute;
                bottom: -10px;
                left: 50%;
                transform: translateX(-50%);
                width: 80px;
                height: 4px;
                background: linear-gradient(135deg, #667eea, #764ba2);
                border-radius: 2px;
            }

            .services-subtitle {
                font-size: 18px;
                color: #7f8c8d;
                max-width: 600px;
                margin: 0 auto;
            }

            .services-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
                gap: 30px;
                margin-top: 50px;
            }

            .service-card {
                background: white;
                padding: 35px 25px;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                text-align: center;
                transition: all 0.4s ease;
                position: relative;
                overflow: hidden;
                border: 1px solid #f0f0f0;
            }

            .service-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(135deg, rgba(102, 126, 234, 0.05), rgba(118, 75, 162, 0.05));
                transition: left 0.5s ease;
            }

            .service-card:hover::before {
                left: 0;
            }

            .service-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 20px 40px rgba(0,0,0,0.15);
            }

            .service-icon {
                width: 70px;
                height: 70px;
                margin: 0 auto 20px;
                background: linear-gradient(135deg, #667eea, #764ba2);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                position: relative;
                z-index: 2;
            }

            .service-icon i {
                font-size: 28px;
                color: white;
            }

            .service-card h3 {
                font-size: 22px;
                color: #2c3e50;
                margin-bottom: 15px;
                font-weight: 600;
                position: relative;
                z-index: 2;
            }

            .service-card p {
                color: #7f8c8d;
                line-height: 1.6;
                position: relative;
                z-index: 2;
            }

            /* Enhanced Chatbot Styles */
            .chatbot-overlay {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.7);
                backdrop-filter: blur(8px);
                z-index: 1002;
                justify-content: center;
                align-items: center;
                animation: fadeIn 0.3s ease;
            }

            .chatbot-overlay.active {
                display: flex;
            }

            .chatbot-box {
                background: linear-gradient(145deg, #ffffff, #f8f9ff);
                padding: 0;
                border-radius: 25px;
                box-shadow: 0 25px 50px rgba(0,0,0,0.2);
                max-width: 450px;
                width: 90%;
                max-height: 600px;
                position: relative;
                overflow: hidden;
                border: 1px solid rgba(102, 126, 234, 0.1);
                animation: slideUp 0.4s ease;
            }

            @keyframes fadeIn {
                from { opacity: 0; }
                to { opacity: 1; }
            }

            @keyframes slideUp {
                from { 
                    opacity: 0;
                    transform: translateY(50px) scale(0.9);
                }
                to { 
                    opacity: 1;
                    transform: translateY(0) scale(1);
                }
            }

            .chatbot-header {
                background: linear-gradient(135deg, #667eea, #764ba2);
                padding: 20px 25px;
                color: white;
                position: relative;
                overflow: hidden;
            }

            .chatbot-header::before {
                content: '';
                position: absolute;
                top: -50%;
                right: -50%;
                width: 100%;
                height: 200%;
                background: linear-gradient(45deg, transparent, rgba(255,255,255,0.1), transparent);
                animation: shimmer 3s infinite;
            }

            @keyframes shimmer {
                0% { transform: translateX(-100%) translateY(-100%) rotate(45deg); }
                100% { transform: translateX(100%) translateY(100%) rotate(45deg); }
            }

            .chatbot-title {
                display: flex;
                align-items: center;
                gap: 12px;
                font-size: 18px;
                font-weight: 600;
                position: relative;
                z-index: 2;
            }

            .chatbot-title i {
                font-size: 20px;
                color: #ffd700;
            }

            .chatbot-status {
                font-size: 12px;
                opacity: 0.9;
                margin-top: 4px;
                display: flex;
                align-items: center;
                gap: 6px;
                position: relative;
                z-index: 2;
            }

            .status-dot {
                width: 8px;
                height: 8px;
                background: #4CAF50;
                border-radius: 50%;
                animation: pulse 2s infinite;
            }

            @keyframes pulse {
                0%, 100% { opacity: 1; }
                50% { opacity: 0.5; }
            }

            #chatBox {
                height: 350px;
                overflow-y: auto;
                padding: 20px;
                background: linear-gradient(to bottom, #fafbff, #f0f2ff);
                position: relative;
            }

            #chatBox::-webkit-scrollbar {
                width: 6px;
            }

            #chatBox::-webkit-scrollbar-track {
                background: rgba(0,0,0,0.05);
                border-radius: 10px;
            }

            #chatBox::-webkit-scrollbar-thumb {
                background: linear-gradient(135deg, #667eea, #764ba2);
                border-radius: 10px;
            }

            #chatBox p {
                margin: 15px 0;
                padding: 12px 18px;
                border-radius: 20px;
                word-wrap: break-word;
                max-width: 85%;
                position: relative;
                animation: messageSlide 0.3s ease;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }

            @keyframes messageSlide {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .user {
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
                margin-left: auto;
                margin-right: 0;
                border-bottom-right-radius: 5px;
                position: relative;
            }

            .user::before {
                content: '';
                position: absolute;
                top: 0;
                left: -10px;
                width: 0;
                height: 0;
                border-top: 10px solid transparent;
                border-bottom: 10px solid transparent;
                border-right: 10px solid #667eea;
            }

            .bot {
                background: linear-gradient(135deg, #ffffff, #f8f9ff);
                color: #2c3e50;
                margin-right: auto;
                margin-left: 0;
                border: 1px solid rgba(102, 126, 234, 0.1);
                border-bottom-left-radius: 5px;
                position: relative;
            }

            .bot::before {
                content: '';
                position: absolute;
                top: 0;
                right: -10px;
                width: 0;
                height: 0;
                border-top: 10px solid transparent;
                border-bottom: 10px solid transparent;
                border-left: 10px solid #ffffff;
            }

            .typing {
                background: linear-gradient(135deg, #e3f2fd, #bbdefb);
                color: #1976d2;
                margin-right: auto;
                margin-left: 0;
                font-style: italic;
                border: 1px solid rgba(25, 118, 210, 0.2);
                position: relative;
            }

            .typing::after {
                content: '';
                display: inline-block;
                width: 4px;
                height: 4px;
                border-radius: 50%;
                background: #1976d2;
                margin-left: 8px;
                animation: typingDot 1.4s infinite;
            }

            @keyframes typingDot {
                0%, 60%, 100% { opacity: 0; }
                30% { opacity: 1; }
            }

            .error-message {
                background: linear-gradient(135deg, #ff6b6b, #ee5a24);
                color: white;
                margin-right: auto;
                margin-left: 0;
                border-bottom-left-radius: 5px;
            }

            .chatbot-input-container {
                padding: 20px;
                background: white;
                border-top: 1px solid rgba(0,0,0,0.1);
                position: relative;
            }

            .chatbot-input {
                display: flex;
                gap: 12px;
                align-items: flex-end;
            }

            .input-wrapper {
                flex: 1;
                position: relative;
            }

            .chatbot-input input[type="text"] {
                width: 100%;
                padding: 15px 20px;
                border: 2px solid #e1e8ed;
                border-radius: 25px;
                font-size: 15px;
                outline: none;
                transition: all 0.3s ease;
                background: #fafbff;
                color: #2c3e50;
            }

            .chatbot-input input[type="text"]:focus {
                border-color: #667eea;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
                background: white;
            }

            .chatbot-input input[type="text"]::placeholder {
                color: #95a5a6;
            }

            .send-button {
                width: 50px;
                height: 50px;
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
                border: none;
                border-radius: 50%;
                font-size: 16px;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                justify-content: center;
                box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
            }

            .send-button:hover:not(:disabled) {
                transform: translateY(-2px) scale(1.05);
                box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
            }

            .send-button:disabled {
                opacity: 0.6;
                cursor: not-allowed;
                transform: none;
                box-shadow: 0 2px 10px rgba(102, 126, 234, 0.2);
            }

            .close-btn {
                position: absolute;
                top: 15px;
                right: 20px;
                font-size: 24px;
                cursor: pointer;
                color: white;
                background: rgba(255,255,255,0.2);
                border: none;
                width: 35px;
                height: 35px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: all 0.3s ease;
                z-index: 3;
            }

            .close-btn:hover {
                background: rgba(255,255,255,0.3);
                transform: rotate(90deg);
            }

            /* Enhanced Chatbot Toggle Button */
            .chatbot-toggle {
                position: fixed;
                bottom: 25px;
                right: 25px;
                width: 65px;
                height: 65px;
                background: linear-gradient(135deg, #667eea, #764ba2);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
                cursor: pointer;
                z-index: 1001;
                transition: all 0.3s ease;
                border: 3px solid white;
                animation: chatbotPulse 3s infinite;
            }

            @keyframes chatbotPulse {
                0%, 100% {
                    box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4), 0 0 0 0 rgba(102, 126, 234, 0.4);
                }
                50% {
                    box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4), 0 0 0 10px rgba(102, 126, 234, 0);
                }
            }

            .chatbot-toggle:hover {
                transform: scale(1.1) rotate(5deg);
                box-shadow: 0 12px 35px rgba(102, 126, 234, 0.6);
            }

            .chatbot-toggle i {
                color: white;
                font-size: 26px;
                transition: transform 0.3s ease;
            }

            .chatbot-toggle:hover i {
                transform: scale(1.1);
            }

            /* Quick Suggestions */
            .quick-suggestions {
                padding: 15px 20px 0;
                display: flex;
                flex-wrap: wrap;
                gap: 8px;
            }

            .suggestion-chip {
                background: rgba(102, 126, 234, 0.1);
                color: #667eea;
                padding: 8px 12px;
                border-radius: 15px;
                font-size: 12px;
                cursor: pointer;
                transition: all 0.3s ease;
                border: 1px solid rgba(102, 126, 234, 0.2);
            }

            .suggestion-chip:hover {
                background: #667eea;
                color: white;
                transform: scale(1.05);
            }

            /* Loading Animation */
            .loading {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: linear-gradient(135deg, #667eea, #764ba2);
                display: flex;
                justify-content: center;
                align-items: center;
                z-index: 9999;
                opacity: 1;
                transition: opacity 0.5s ease;
            }

            .loading.hide {
                opacity: 0;
                pointer-events: none;
            }

            .spinner {
                width: 50px;
                height: 50px;
                border: 3px solid rgba(255,255,255,0.3);
                border-top: 3px solid white;
                border-radius: 50%;
                animation: spin 1s linear infinite;
            }

            @keyframes spin {
                0% {
                    transform: rotate(0deg);
                }
                100% {
                    transform: rotate(360deg);
                }
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

                .banner h2 {
                    font-size: 32px;
                }

                .banner p,
                .banner .slogan {
                    font-size: 16px;
                }

                .cta-button {
                    padding: 15px 35px;
                    font-size: 18px;
                }

                .services-grid {
                    grid-template-columns: 1fr;
                    gap: 20px;
                }

                .chatbot-box {
                    max-width: 95%;
                    max-height: 90vh;
                    margin: 20px;
                }

                #chatBox {
                    height: 280px;
                }

                .chatbot-input {
                    flex-direction: column;
                    gap: 10px;
                }

                .send-button {
                    width: 100%;
                    height: 45px;
                    border-radius: 25px;
                }

                .chatbot-toggle {
                    bottom: 15px;
                    right: 15px;
                    width: 55px;
                    height: 55px;
                }

                .chatbot-toggle i {
                    font-size: 22px;
                }

                .quick-suggestions {
                    padding: 10px 15px 0;
                }

                .suggestion-chip {
                    font-size: 11px;
                    padding: 6px 10px;
                }
            }
        </style>
    </head>
    <body>
        <!-- Loading Screen -->
        <div class="loading" id="loading">
            <div class="spinner"></div>
        </div>

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
                        <a href="${pageContext.request.contextPath}/views/common/login.jsp?form=login" class="btn">
                            <i class="fas fa-sign-in-alt"></i> Đăng nhập
                        </a>
                        <a href="${pageContext.request.contextPath}/views/common/login.jsp?form=register" class="btn">
                            <i class="fas fa-user-plus"></i> Đăng ký
                        </a>
                    </div>
                </div>
            </div>
        </header>

        <!-- Banner -->
        <section class="banner">
            <div class="container">
                <div class="banner-content">
                    <p>PDC là công ty bệnh nha khoa được nhiều người tin tưởng trong lĩnh vực chăm sóc sức khỏe răng miệng.</p>
                    <p class="slogan">"Giải pháp tối ưu, cân thiện tối thiểu" – đó chính là slogan và mục tiêu mà Nha Khoa PDC đang, và sẽ thực hiện trong suốt thời gian hoạt động.</p>

                    <div class="banner-actions">
                        <a href="${pageContext.request.contextPath}/BookAppointmentGuestServlet" class="cta-button">
                            <i class="fas fa-calendar-plus"></i>
                            Đăng Kí Tư Vấn
                        </a>

                        <!-- Success Message -->
                        <% 
                            String successMessage = (String) session.getAttribute("successMessage");
                            if (successMessage != null) {
                        %>
                        <div class="success-message">
                            <i class="fas fa-check-circle"></i>
                            <%= successMessage %>
                        </div>
                        <% 
                            session.removeAttribute("successMessage");
                        }
                        %>
                    </div>
                </div>
            </div>
        </section>

        <!-- Dịch vụ nha khoa -->
        <section class="services">
            <div class="container">
                <div class="services-header">
                    <h2>Dịch vụ nha khoa</h2>
                    <p class="services-subtitle">
                        Chúng tôi cung cấp dịch vụ hàng đầu với triết lý "Giải pháp tối ưu, cân thiện tối thiểu"
                    </p>
                </div>

                <div class="services-grid">
                    <div class="service-card">
                        <div class="service-icon">
                            <i class="fas fa-tooth"></i>
                        </div>
                        <h3>Niềng Răng</h3>
                        <p>Giải pháp phục hồi răng mất, đảm bảo thẩm mỹ và chức năng nhai tốt nhất cho người dùng với công nghệ tiên tiến.</p>
                    </div>

                    <div class="service-card">
                        <div class="service-icon">
                            <i class="fas fa-grip-lines"></i>
                        </div>
                        <h3>Cấy ghép Implant</h3>
                        <p>Cấy ghép Implant mang đến giải pháp phục hồi răng tối ưu với công nghệ tiên tiến, đảm bảo thẩm mỹ và chức năng nhai hoàn hảo</p>
                    </div>

                    <div class="service-card">
                        <div class="service-icon">
                            <i class="fas fa-child"></i>
                        </div>
                        <h3>Nha khoa trẻ em</h3>
                        <p>Mang đến nụ cười khỏe mạnh cho trẻ, giúp trẻ tự tin và có hàm răng đều đẹp từ nhỏ.</p>
                    </div>

                    <div class="service-card">
                        <div class="service-icon">
                            <i class="fas fa-user-md"></i>
                        </div>
                        <h3>Phẫu thuật chỉnh hình xương hàm</h3>
                        <p>Giải quyết các vấn đề chỉnh nắn thẩm mỹ và chức năng hàm, nâng cao chất lượng cuộc sống.</p>
                    </div>

                    <div class="service-card">
                        <div class="service-icon">
                            <i class="fas fa-smile"></i>
                        </div>
                        <h3>Nha khoa thẩm mỹ</h3>
                        <p>Mang đến nụ cười tự nhiên, giúp bạn tự tin với nụ cười trắng sáng và hoàn hảo.</p>
                    </div>

                    <div class="service-card">
                        <div class="service-icon">
                            <i class="fas fa-procedures"></i>
                        </div>
                        <h3>Nhổ răng khôn</h3>
                        <p>Tiến hành an toàn, nhẹ nhàng với công nghệ hiện đại, đảm bảo không đau và nhanh chóng.</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- Enhanced Chatbot Overlay -->
        <div class="chatbot-overlay" id="chatbotOverlay">
            <div class="chatbot-box">
                <div class="chatbot-header">
                    <button class="close-btn" id="closeBtn">&times;</button>
                    <div class="chatbot-title">
                        <i class="fas fa-robot"></i>
                        <div>
                            <div>Trợ lý ảo PDC</div>
                            <div class="chatbot-status">
                                <span class="status-dot"></span>
                                Đang hoạt động
                            </div>
                        </div>
                    </div>
                </div>

                <div class="quick-suggestions">
                    <div class="suggestion-chip" onclick="selectSuggestion('Tư vấn dịch vụ implant')">Implant</div>
                    <div class="suggestion-chip" onclick="selectSuggestion('Giá chỉnh nha mắc cài')">Mắc cài</div>
                    <div class="suggestion-chip" onclick="selectSuggestion('Nha khoa trẻ em')">Trẻ em</div>
                    <div class="suggestion-chip" onclick="selectSuggestion('Bảng giá dịch vụ')">Bảng giá</div>
                </div>

                <div id="chatBox">
                    <p class="bot">
                        <i class="fas fa-hand-paper" style="margin-right: 8px; color: #ffd700;"></i>
                        Xin chào! Tôi là trợ lý ảo của Nha Khoa PDC. Tôi có thể giúp bạn trả lời các câu hỏi về dịch vụ nha khoa. Bạn cần hỗ trợ gì?
                    </p>
                </div>

                <div class="chatbot-input-container">
                    <div class="chatbot-input">
                        <div class="input-wrapper">
                            <input type="text" id="userInput" placeholder="Nhập câu hỏi về dịch vụ nha khoa..." required>
                        </div>
                        <button class="send-button" id="sendButton">
                            <i class="fas fa-paper-plane"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Enhanced Chatbot Toggle Button -->
        <div class="chatbot-toggle" id="chatbotToggle">
            <i class="fas fa-comment-medical"></i>
        </div>

        <!-- Include Footer -->
        <jsp:include page="/assets/footer.jsp" />
        <script>
            // Loading animation
            window.addEventListener('load', function () {
                const loading = document.getElementById('loading');
                setTimeout(() => {
                    loading.classList.add('hide');
                }, 1000);
            });

            // Smooth scrolling for anchor links
            document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                anchor.addEventListener('click', function (e) {
                    e.preventDefault();
                    const target = document.querySelector(this.getAttribute('href'));
                    if (target) {
                        target.scrollIntoView({
                            behavior: 'smooth',
                            block: 'start'
                        });
                    }
                });
            });

            // Add scroll effect to header
            window.addEventListener('scroll', function () {
                const header = document.querySelector('header');
                if (window.scrollY > 100) {
                    header.style.background = 'linear-gradient(135deg, rgba(102, 126, 234, 0.95), rgba(118, 75, 162, 0.95))';
                } else {
                    header.style.background = 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)';
                }
            });

            // Animate service cards on scroll
            const observerOptions = {
                threshold: 0.1,
                rootMargin: '0px 0px -50px 0px'
            };

            const observer = new IntersectionObserver(function (entries) {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.opacity = '1';
                        entry.target.style.transform = 'translateY(0)';
                    }
                });
            }, observerOptions);

            document.querySelectorAll('.service-card').forEach(card => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(30px)';
                card.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
                observer.observe(card);
            });

            // Enhanced Chatbot toggle functionality
            const chatbotToggle = document.getElementById('chatbotToggle');
            const chatbotOverlay = document.getElementById('chatbotOverlay');
            const closeBtn = document.getElementById('closeBtn');

            chatbotToggle.addEventListener('click', () => {
                chatbotOverlay.classList.add('active');
                document.getElementById('userInput').focus();
                // Add welcome sound effect (optional)
                playNotificationSound();
            });

            closeBtn.addEventListener('click', () => {
                chatbotOverlay.classList.remove('active');
            });

            // Close overlay when clicking outside the chatbot box
            chatbotOverlay.addEventListener('click', (e) => {
                if (e.target === chatbotOverlay) {
                    chatbotOverlay.classList.remove('active');
                }
            });

            // Auto-scroll chatbox to bottom with smooth animation
            function scrollChatToBottom() {
                const chatBox = document.getElementById('chatBox');
                if (chatBox) {
                    chatBox.scrollTo({
                        top: chatBox.scrollHeight,
                        behavior: 'smooth'
                    });
                }
            }

            // Initial scroll
            scrollChatToBottom();

            // Quick suggestion selection
            function selectSuggestion(text) {
                const userInput = document.getElementById('userInput');
                userInput.value = text;
                userInput.focus();
                // Add subtle animation to input
                userInput.style.transform = 'scale(1.02)';
                setTimeout(() => {
                    userInput.style.transform = 'scale(1)';
                }, 200);
            }

            // Enhanced message append function with better animations
            function appendMessage(message, className) {
                const chatBox = document.getElementById('chatBox');
                const p = document.createElement('p');
                p.className = className;
                
                // Add icons for different message types
                if (className === 'bot') {
                    const icon = document.createElement('i');
                    icon.className = 'fas fa-robot';
                    icon.style.marginRight = '8px';
                    icon.style.color = '#667eea';
                    p.appendChild(icon);
                }
                
                const textNode = document.createTextNode(message);
                p.appendChild(textNode);
                
                // Add message with animation
                p.style.opacity = '0';
                p.style.transform = 'translateY(20px)';
                chatBox.appendChild(p);
                
                // Trigger animation
                setTimeout(() => {
                    p.style.opacity = '1';
                    p.style.transform = 'translateY(0)';
                }, 10);
                
                scrollChatToBottom();
                return p;
            }

            // Enhanced send message function with better UX
            async function sendMessage() {
                const userInput = document.getElementById('userInput');
                const sendButton = document.getElementById('sendButton');
                const userMessage = userInput.value.trim();

                if (!userMessage) return;

                // Disable input and button
                userInput.disabled = true;
                sendButton.disabled = true;
                sendButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';

                // Add user message with animation
                appendMessage(userMessage, 'user');
                userInput.value = '';

                // Show typing indicator
                const typingMessage = appendMessage('Đang trả lời...', 'typing');

                // Play send sound
                playNotificationSound();

                try {
                    const contextPath = '${pageContext.request.contextPath}';
                    const servletUrl = contextPath + '/ChatbotServlet';

                    console.log('🎯 Calling servlet at:', servletUrl);
                    console.log('📤 Sending message:', userMessage);

                    const response = await fetch(servletUrl, {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json;charset=UTF-8',
                            'Accept': 'application/json'
                        },
                        body: JSON.stringify({
                            message: userMessage
                        })
                    });

                    console.log('📊 Response status:', response.status);

                    const contentType = response.headers.get('content-type');
                    if (!contentType || !contentType.includes('application/json')) {
                        console.warn('⚠️ Response is not JSON:', contentType);
                        const textResponse = await response.text();
                        console.log('📄 Response text:', textResponse);
                        throw new Error('Server trả về không phải JSON: ' + textResponse.substring(0, 100));
                    }

                    if (!response.ok) {
                        const errorText = await response.text();
                        console.error('❌ HTTP Error:', response.status, errorText);
                        throw new Error(`HTTP ${response.status}: ${errorText}`);
                    }

                    const data = await response.json();
                    console.log('✅ Response data:', data);

                    // Remove typing indicator
                    typingMessage.remove();

                    if (data.success) {
                        appendMessage(data.response, 'bot');
                        playSuccessSound();
                    } else {
                        appendMessage(data.response || 'Có lỗi xảy ra, vui lòng thử lại hoặc liên hệ hotline 0854321230.', 'error-message');
                        playErrorSound();
                        if (data.error) {
                            console.error('🔍 Server error details:', data.error);
                        }
                    }

                } catch (error) {
                    console.error('💥 Error details:', error);
                    typingMessage.remove();
                    appendMessage('Xin lỗi, có lỗi xảy ra. Vui lòng thử lại hoặc liên hệ hotline 0854321230.', 'error-message');
                    playErrorSound();
                }

                // Re-enable input and button
                userInput.disabled = false;
                sendButton.disabled = false;
                sendButton.innerHTML = '<i class="fas fa-paper-plane"></i>';
                userInput.focus();
            }

            // Sound effects (optional - can be disabled)
            function playNotificationSound() {
                try {
                    const audio = new Audio('data:audio/wav;base64,UklGRnoGAABXQVZFZm10IBAAAAABAAEAQB8AAEAfAAABAAgAZGF0YQoGAACBhYqFbF1fdJivrJBhNjVgodDbq2EcBj+a2/LDciUOQF');
                    audio.volume = 0.1;
                    audio.play();
                } catch (e) {
                    // Ignore if audio fails
                }
            }

            function playSuccessSound() {
                // Success sound implementation
            }

            function playErrorSound() {
                // Error sound implementation
            }

            // Event listeners with better UX
            document.getElementById('userInput').addEventListener('keypress', function (e) {
                if (e.key === 'Enter' && !e.shiftKey) {
                    e.preventDefault();
                    sendMessage();
                }
            });

            document.getElementById('sendButton').addEventListener('click', sendMessage);

            // Auto-focus on input when chatbot is opened
            chatbotToggle.addEventListener('click', () => {
                setTimeout(() => {
                    document.getElementById('userInput').focus();
                }, 300);
            });

            // Keyboard shortcuts
            document.addEventListener('keydown', function(e) {
                // Escape key to close chatbot
                if (e.key === 'Escape' && chatbotOverlay.classList.contains('active')) {
                    chatbotOverlay.classList.remove('active');
                }
            });
        </script>
    </body>
</html>
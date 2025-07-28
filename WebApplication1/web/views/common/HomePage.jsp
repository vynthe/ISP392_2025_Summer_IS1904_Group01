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

            .service-card a {
                text-decoration: none;
                color: inherit;
            }

            /* Chatbot Overlay */
            .chatbot-overlay {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.5);
                z-index: 1002;
                justify-content: center;
                align-items: center;
            }

            .chatbot-overlay.active {
                display: flex;
            }

            .chatbot-box {
                background: white;
                padding: 20px;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                max-width: 600px;
                width: 90%;
                position: relative;
            }

            #chatBox {
                height: 300px;
                overflow-y: auto;
                border: 1px solid #f0f0f0;
                padding: 15px;
                border-radius: 10px;
                margin-bottom: 20px;
                background: #fafafa;
            }

            #chatBox p {
                margin: 10px 0;
                padding: 8px 12px;
                border-radius: 10px;
                word-wrap: break-word;
            }

            .user {
                background: #667eea;
                color: white;
                margin-left: 20%;
                text-align: right;
            }

            .bot {
                background: #e9ecef;
                color: #2c3e50;
                margin-right: 20%;
            }

            .typing {
                background: #e9ecef;
                color: #7f8c8d;
                margin-right: 20%;
                font-style: italic;
            }

            .chatbot-input {
                display: flex;
                gap: 10px;
            }

            .chatbot-input input[type="text"] {
                flex: 1;
                padding: 12px;
                border: 1px solid #ccc;
                border-radius: 25px;
                font-size: 16px;
                outline: none;
            }

            .chatbot-input input[type="text"]:focus {
                border-color: #667eea;
                box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.2);
            }

            .chatbot-input button {
                padding: 12px 24px;
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
                border: none;
                border-radius: 25px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .chatbot-input button:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            }

            .chatbot-input button:disabled {
                opacity: 0.6;
                cursor: not-allowed;
                transform: none;
            }

            .error-message {
                background: #ff6b6b;
                color: white;
                margin-right: 20%;
            }

            .close-btn {
                position: absolute;
                top: 10px;
                right: 15px;
                font-size: 20px;
                cursor: pointer;
                color: #666;
                background: none;
                border: none;
            }

            .close-btn:hover {
                color: #ff6b6b;
            }

            /* Chatbot Toggle Button */
            .chatbot-toggle {
                position: fixed;
                bottom: 20px;
                right: 20px;
                width: 60px;
                height: 60px;
                background: linear-gradient(135deg, #667eea, #764ba2);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                box-shadow: 0 5px 15px rgba(0,0,0,0.2);
                cursor: pointer;
                z-index: 1001;
                transition: transform 0.3s ease;
            }

            .chatbot-toggle:hover {
                transform: scale(1.1);
            }

            .chatbot-toggle i {
                color: white;
                font-size: 24px;
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
                    padding: 15px;
                }

                .chatbot-input {
                    flex-direction: column;
                }

                .chatbot-input input[type="text"] {
                    width: 100%;
                }

                .chatbot-toggle {
                    bottom: 10px;
                    right: 10px;
                    width: 50px;
                    height: 50px;
                }

                .chatbot-toggle i {
                    font-size: 20px;
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
                    <a href="${pageContext.request.contextPath}/ViewServiceByCategoryServlet?category=implant" class="service-card">
                        <div class="service-icon">
                            <i class="fas fa-tooth"></i>
                        </div>
                        <h3>Cấy ghép Implant</h3>
                        <p>Giải pháp phục hồi răng mất, đảm bảo thẩm mỹ và chức năng nhai tốt nhất cho người dùng với công nghệ tiên tiến.</p>
                    </a>

                    <a href="${pageContext.request.contextPath}/ViewServiceByCategoryServlet?category=mắc cài" class="service-card">
                        <div class="service-icon">
                            <i class="fas fa-grip-lines"></i>
                        </div>
                        <h3>Chỉnh nha mắc cài</h3>
                        <p>Nắn chỉnh răng mọc lệch, giúp bạn có một nụ cười khỏe mạnh và tự tin với hàm răng đều đẹp.</p>
                    </a>

                    <a href="${pageContext.request.contextPath}/ViewServiceByCategoryServlet?category=trẻ em" class="service-card">
                        <div class="service-icon">
                            <i class="fas fa-child"></i>
                        </div>
                        <h3>Nha khoa trẻ em</h3>
                        <p>Mang đến nụ cười khỏe mạnh cho trẻ, giúp trẻ tự tin và có hàm răng đều đẹp từ nhỏ.</p>
                    </a>

                    <a href="${pageContext.request.contextPath}/ViewServiceByCategoryServlet?category=xương hàm" class="service-card">
                        <div class="service-icon">
                            <i class="fas fa-user-md"></i>
                        </div>
                        <h3>Phẫu thuật chỉnh hình xương hàm</h3>
                        <p>Giải quyết các vấn đề chỉnh nắn thẩm mỹ và chức năng hàm, nâng cao chất lượng cuộc sống.</p>
                    </a>

                    <a href="${pageContext.request.contextPath}/ViewServiceByCategoryServlet?category=thẩm mỹ" class="service-card">
                        <div class="service-icon">
                            <i class="fas fa-smile"></i>
                        </div>
                        <h3>Nha khoa thẩm mỹ</h3>
                        <p>Mang đến nụ cười tự nhiên, giúp bạn tự tin với nụ cười trắng sáng và hoàn hảo.</p>
                    </a>

                    <a href="${pageContext.request.contextPath}/ViewServiceByCategoryServlet?category=răng khôn" class="service-card">
                        <div class="service-icon">
                            <i class="fas fa-procedures"></i>
                        </div>
                        <h3>Nhổ răng khôn</h3>
                        <p>Tiến hành an toàn, nhẹ nhàng với công nghệ hiện đại, đảm bảo không đau và nhanh chóng.</p>
                    </a>
                </div>
            </div>
        </section>

        <!-- Chatbot Overlay -->
        <div class="chatbot-overlay" id="chatbotOverlay">
            <div class="chatbot-box">
                <button class="close-btn" id="closeBtn">&times;</button>
                <div id="chatBox">
                    <p class="bot">Xin chào! Tôi là trợ lý ảo của Nha Khoa PDC. Tôi có thể giúp bạn trả lời các câu hỏi về dịch vụ nha khoa. Bạn cần hỗ trợ gì?</p>
                    <c:forEach var="message" items="${sessionScope.chatHistory}">
                        <p class="${fn:startsWith(message, 'Bạn:') ? 'user' : 'bot'}">
                            ${message}
                        </p>
                    </c:forEach>
                </div>
                <div class="chatbot-input">
                    <input type="text" id="userInput" placeholder="Nhập câu hỏi về dịch vụ nha khoa..." required>
                    <button id="sendButton"><i class="fas fa-paper-plane"></i> Gửi</button>
                </div>
            </div>
        </div>

        <!-- Chatbot Toggle Button -->
        <div class="chatbot-toggle" id="chatbotToggle">
            <i class="fas fa-comment"></i>
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

            // Chatbot toggle functionality
            const chatbotToggle = document.getElementById('chatbotToggle');
            const chatbotOverlay = document.getElementById('chatbotOverlay');
            const closeBtn = document.getElementById('closeBtn');

            chatbotToggle.addEventListener('click', () => {
                chatbotOverlay.classList.add('active');
                document.getElementById('userInput').focus();
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

            // Auto-scroll chatbox to bottom
            const chatBox = document.getElementById('chatBox');
            if (chatBox) {
                chatBox.scrollTop = chatBox.scrollHeight;
            }

            // Chatbot send message function - Now calls the actual servlet
            async function sendMessage() {
                const userInput = document.getElementById('userInput');
                const sendButton = document.getElementById('sendButton');
                const userMessage = userInput.value.trim();

                if (!userMessage)
                    return;

                userInput.disabled = true;
                sendButton.disabled = true;

                appendMessage(userMessage, 'user');
                userInput.value = '';

                const typingMessage = appendMessage('Đang trả lời...', 'typing');

                try {
                    // ✅ SỬA LỖI: Đảm bảo đúng context path
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
                    console.log('📊 Response headers:', [...response.headers.entries()]);

                    // Kiểm tra response content type
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

                    typingMessage.remove();

                    if (data.success) {
                        appendMessage(data.response, 'bot');
                    } else {
                        appendMessage(data.response || 'Có lỗi xảy ra', 'error-message');
                        if (data.error) {
                            console.error('🔍 Server error details:', data.error);
                        }
                    }

                } catch (error) {
                    console.error('💥 Error details:', error);
                    typingMessage.remove();

                    // Hiển thị lỗi chi tiết để debug
                    let errorMsg = '❌ Lỗi: ' + error.message;
                    appendMessage(errorMsg, 'error-message');

                    // Fallback response
                    setTimeout(() => {
                        const fallback = getFallbackResponse(userMessage);
                        appendMessage('🤖 Dùng câu trả lời có sẵn: ' + fallback, 'bot');
                    }, 1000);
                }

                userInput.disabled = false;
                sendButton.disabled = false;
                userInput.focus();
            }

            // Fallback responses for when API fails
            function getFallbackResponse(userMessage) {
                const message = userMessage.toLowerCase();

                if (message.includes('implant') || message.includes('cấy ghép')) {
                    return 'Cấy ghép Implant tại PDC sử dụng công nghệ tiên tiến với bảo hành 10 năm. Quy trình an toàn và thẩm mỹ cao. Bạn có thể đặt lịch tư vấn miễn phí để được thăm khám chi tiết.';
                } else if (message.includes('mắc cài') || message.includes('niềng') || message.includes('chỉnh nha')) {
                    return 'PDC cung cấp các loại mắc cài: kim loại, sứ, trong suốt. Thời gian điều trị 18-24 tháng. Chúng tôi có chuyên gia chỉnh nha giàu kinh nghiệm để mang lại nụ cười hoàn hảo cho bạn.';
                } else if (message.includes('trẻ em') || message.includes('bé')) {
                    return 'Nha khoa trẻ em tại PDC có không gian thân thiện, bác sĩ chuyên khoa nhi. Chăm sóc răng miệng cho bé từ 6 tháng tuổi với phương pháp nhẹ nhàng, không đau.';
                } else if (message.includes('giá') || message.includes('chi phí')) {
                    return 'Giá dịch vụ tại PDC phụ thuộc từng trường hợp. Chúng tôi có chính sách tư vấn và báo giá miễn phí. Bạn có thể đặt lịch để được thăm khám và báo giá chi tiết.';
                } else {
                    return 'Xin chào! Tôi là trợ lý ảo của Nha Khoa PDC. Tôi có thể hỗ trợ bạn về các dịch vụ: Cấy ghép Implant, Chỉnh nha mắc cài, Nha khoa trẻ em, Phẫu thuật xương hàm, Nha khoa thẩm mỹ, Nhổ răng khôn. Bạn cần tư vấn dịch vụ nào?';
                }
            }

            function appendMessage(message, className) {
                const chatBox = document.getElementById('chatBox');
                const p = document.createElement('p');
                p.className = className;
                p.textContent = message;
                chatBox.appendChild(p);
                chatBox.scrollTop = chatBox.scrollHeight;
                return p;
            }

            // Event listeners
            document.getElementById('userInput').addEventListener('keypress', function (e) {
                if (e.key === 'Enter' && !e.shiftKey) {
                    e.preventDefault();
                    sendMessage();
                }
            });

            document.getElementById('sendButton').addEventListener('click', sendMessage);

            // Initial focus on input when chatbot is opened
            document.getElementById('userInput').focus();
            
        </script>
        
    </body>
</html>
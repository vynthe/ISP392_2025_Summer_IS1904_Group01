<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Dashboard - Nha Khoa PDC - Nụ cười tự tin, sức khỏe hoàn hảo</title>
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

        /* User Menu Styles */
        .user-menu {
            position: relative;
        }

        .user-menu-btn {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            background: rgba(255, 255, 255, 0.1);
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-radius: 25px;
            color: white;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
        }

        .user-menu-btn:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }

        .user-avatar {
            width: 28px;
            height: 28px;
            background: linear-gradient(135deg, #ffd700, #ffed4a);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #667eea;
            font-weight: 700;
            font-size: 12px;
        }

        .user-menu-dropdown {
            position: absolute;
            right: 0;
            top: calc(100% + 10px);
            width: 200px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            border: 1px solid rgba(0,0,0,0.1);
            overflow: hidden;
            transform: translateY(-10px);
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
        }

        .user-menu-dropdown.show {
            transform: translateY(0);
            opacity: 1;
            visibility: visible;
        }

        .user-menu-dropdown a {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 16px;
            color: #2c3e50;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
            border-bottom: 1px solid #f0f0f0;
        }

        .user-menu-dropdown a:last-child {
            border-bottom: none;
        }

        .user-menu-dropdown a:hover {
            background: #f8f9fa;
            color: #667eea;
        }

        .user-menu-dropdown a.danger:hover {
            background: #ffeaea;
            color: #dc2626;
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
            0% { background: linear-gradient(45deg, rgba(102, 126, 234, 0.8), rgba(118, 75, 162, 0.8)); }
            100% { background: linear-gradient(45deg, rgba(118, 75, 162, 0.8), rgba(102, 126, 234, 0.8)); }
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
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
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
                
                <!-- User Menu (thay thế Auth Buttons) -->
                <div class="user-menu">
                    <button class="user-menu-btn" id="userMenuBtn">
                        <div class="user-avatar">
                            <i class="fas fa-user"></i>
                        </div>
                        <span>Tài khoản</span>
                        <i class="fas fa-chevron-down"></i>
                    </button>
                    <div class="user-menu-dropdown" id="userMenu">
                        <a href="${pageContext.request.contextPath}/UserProfileController">
                            <i class="fas fa-user-circle"></i>
                            Xem hồ sơ
                        </a>
                        <a href="${pageContext.request.contextPath}/EditProfileUserController">
                            <i class="fas fa-edit"></i>
                            Chỉnh sửa hồ sơ
                        </a>
                        <a href="${pageContext.request.contextPath}/LogoutServlet" 
                           class="danger" 
                           onclick="return confirm('Bạn có chắc muốn đăng xuất?')">
                            <i class="fas fa-sign-out-alt"></i>
                            Đăng xuất
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <!-- Banner -->
    <section class="banner">
        <div class="container">
            <div class="banner-content">
                <h2>Chào mừng bạn đến với Nha Khoa PDC</h2>
                <p>PDC là công ty bệnh nha khoa được nhiều người tin tưởng trong lĩnh vực chăm sóc sức khỏe răng miệng.</p>
                <p class="slogan">"Giải pháp tối ưu, cân thiện tối thiểu" – đó chính là slogan và mục tiêu mà Nha Khoa PDC đang, và sẽ thực hiện trong suốt thời gian hoạt động.</p>
                
                <div class="banner-actions">
                    <a href="${pageContext.request.contextPath}/BookMedicalGuestServlet" class="cta-button">
                        <i class="fas fa-calendar-plus"></i>
                        Đặt lịch khám
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

    <!-- Include Footer -->
    <jsp:include page="/assets/footer.jsp" />

    <script>
        // Toggle user menu
        const userMenuBtn = document.getElementById('userMenuBtn');
        const userMenu = document.getElementById('userMenu');
        
        userMenuBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            userMenu.classList.toggle('show');
        });

        // Close menu when clicking outside
        document.addEventListener('click', function(event) {
            if (!userMenuBtn.contains(event.target) && !userMenu.contains(event.target)) {
                userMenu.classList.remove('show');
            }
        });

        // Loading animation
        window.addEventListener('load', function() {
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
        window.addEventListener('scroll', function() {
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

        const observer = new IntersectionObserver(function(entries) {
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
    </script>
</body>
</html>
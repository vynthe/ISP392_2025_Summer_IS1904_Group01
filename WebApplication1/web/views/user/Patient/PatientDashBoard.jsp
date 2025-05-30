<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Dashboard - Nha Khoa PDC</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #F5F5F5; /* Nền xám nhạt */
        }
        /* Header */
        header {
            background: #8B4513; /* Nâu đậm */
            position: sticky;
            top: 0;
            z-index: 50;
            padding: 10px 0;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            color: black;
        }
        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .logo {
            display: flex;
            align-items: center;
        }
        .logo h1 {
            color: #FFF5E1; /* Trắng kem */
            font-size: 24px;
            margin: 0;
        }
        .logo span {
            color: #FFF5E1; /* Trắng kem */
            margin-left: 10px;
        }
        nav a {
            color: #FFF5E1; /* Trắng kem */
            text-decoration: none;
            margin: 0 15px;
            font-size: 16px;
        }
        nav a:hover {
            color: #D2B48C; /* Nâu nhạt */
        }
        /* User Menu */
        .user-menu {
            position: relative;
        }
        .user-menu-btn {
            display: flex;
            align-items: center;
            padding: 8px 20px;
            border: 1px solid #FFF5E1; /* Viền trắng kem */
            border-radius: 20px;
            background: transparent;
            color: #FFF5E1; /* Trắng kem */
            cursor: pointer;
            font-size: 16px;
        }
        .user-menu-btn:hover {
            background: #D2B48C; /* Nâu nhạt */
            color: #8B4513; /* Nâu đậm */
        }
        .user-menu-dropdown {
            position: absolute;
            right: 0;
            top: 100%;
            margin-top: 10px;
            width: 150px; /* Adjusted width to match the right image */
            background: #FFFFFF; /* White background */
            border-radius: 8px; /* Rounded corners */
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); /* Softer shadow */
            display: none;
            z-index: 100;
        }
        .user-menu-dropdown a {
            display: block;
            padding: 10px 15px;
            color: #4B5563; /* Gray text */
            text-decoration: none;
            font-size: 14px;
        }
        .user-menu-dropdown a:hover {
            background: #F3F4F6; /* Light gray hover effect */
            color: #1F2937; /* Darker gray on hover */
        }
        /* Banner */
        .banner {
            background-image: url('https://via.placeholder.com/1920x400?text=Banner+Image'); /* Placeholder cho hình banner */
            background-size: cover;
            background-position: center;
            padding: 60px 0;
            text-align: center;
            color: #FFF5E1; /* Trắng kem */
            background-color: #D2B48C; /* Nâu nhạt làm nền nếu hình không tải */
        }
        .banner p {
            font-size: 18px;
            margin: 0 0 20px;
        }
        .banner .slogan {
            font-size: 24px;
            font-weight: bold;
        }
        .banner a {
            display: inline-block;
            background: #8B4513; /* Nâu đậm */
            color: #FFF5E1; /* Trắng kem */
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            margin-top: 20px;
        }
        .banner a:hover {
            background: #A0522D; /* Nâu đậm hơn khi hover */
        }
        /* Dịch vụ */
        .services {
            padding: 60px 0;
            text-align: center;
            background: #FFF5E1; /* Trắng kem */
        }
        .services h2 {
            font-size: 32px;
            color: #8B4513; /* Nâu đậm */
            margin-bottom: 20px;
        }
        .services p {
            font-size: 18px;
            color: #666666; /* Xám nhạt */
            margin-bottom: 40px;
        }
        .grid {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 20px;
            max-width: 1200px;
            margin: 0 auto;
        }
        .grid-row {
            display: flex;
            justify-content: center;
            gap: 20px;
            width: 100%;
        }
        .service-card {
            background: #FFFFFF; /* White background */
            padding: 20px;
            border-radius: 10px; /* Rounded corners */
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1); /* Subtle shadow */
            text-align: center;
            cursor: pointer; /* Indicate clickable */
            transition: transform 0.2s, box-shadow 0.2s; /* Smooth hover effect */
            flex: 1 1 30%; /* Ensure 3 cards per row */
            max-width: 30%; /* Limit width for 3 cards */
            box-sizing: border-box;
        }
        .service-card:hover {
            transform: translateY(-5px); /* Lift effect */
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.15); /* Enhanced shadow on hover */
        }
        .service-card svg {
            width: 50px;
            height: 50px;
            margin-bottom: 15px;
            color: #D4A017; /* Gold color for icons */
        }
        .service-card h3 {
            font-size: 18px;
            color: #1F2937; /* Dark gray for title */
            margin-bottom: 10px;
            font-weight: 600;
        }
        .service-card p {
            font-size: 14px;
            color: #4B5563; /* Gray for description */
            margin-bottom: 0;
        }
        /* Footer */
        footer {
            background: #8B4513; /* Nâu đậm */
            color: #FFF5E1; /* Trắng kem */
            text-align: center;
            padding: 20px 0;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header>
        <div class="container header-content">
            <!-- Logo -->
            <div class="logo">
                <h1>PDC</h1>
                <span>Nha Khoa PDC</span>
            </div>
            <!-- Navigation -->
            <nav>
                <a href="#">Home</a>
                <a href="#">Blog</a>
                <a href="#">Service</a>
                <a href="#">About</a>
            </nav>
            <!-- User Menu -->
            <div class="user-menu">
                <button class="user-menu-btn" id="userMenuBtn">
                    <span>👤</span>
                </button>
                <div class="user-menu-dropdown" id="userMenu">
                    <a href="${pageContext.request.contextPath}/UserProfileController">View Profile</a>
                    <a href="${pageContext.request.contextPath}/EditProfileUserController">Edit Profile</a>
                    <a href="${pageContext.request.contextPath}/LogoutServlet" onclick="return confirm('Bạn có chắc muốn thoát?')">Sign Out</a>
                </div>
            </div>
        </div>
    </header>

    <!-- Banner -->
    <section class="banner">
        <div class="container">
            <p>PDC là công ty bệnh nha khoa được nhiều người tin tưởng trong lĩnh vực chăm sóc sức khỏe răng miệng.</p>
            <p class="slogan">"Giải pháp tối ưu, cân thiện tối thiểu" – đó chính là slogan và mục tiêu mà Nha Khoa PDC đang, và sẽ thực hiện trong suốt thời gian hoạt động.</p>
            <a href="${pageContext.request.contextPath}/BookAppointmentController">Đặt lịch khám</a>
        </div>
    </section>

    <!-- Dịch vụ nha khoa -->
    <section class="services">
        <div class="container">
            <h2>Dịch vụ nha khoa</h2>
            <p>Chúng tôi cung cấp dịch vụ hàng đầu với triết lý “Giải pháp tối ưu, cân thiện tối thiểu”.</p>
            <div class="grid">
                <!-- Top Row: 3 Cards -->
                <div class="grid-row">
                    <!-- Cấy ghép Implant -->
                    <a href="${pageContext.request.contextPath}/ViewServiceByCategoryServlet?category=mắc cài" class="service-card">
                        <svg class="text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 11c0-1.1-.9-2-2-2s-2 .9-2 2v2c0 1.1.9 2 2 2s2-.9 2-2v-2zm0 0c0-1.1-.9-2-2-2s-2 .9-2 2v2c0 1.1.9 2 2 2s2-.9 2-2v-2zm0 0c0-1.1-.9-2-2-2s-2 .9-2 2v2c0 1.1.9 2 2 2s2-.9 2-2v-2z"></path>
                        </svg>
                        <h3>Cấy ghép Implant</h3>
                        <p>Giải pháp phục hồi răng mất, đảm bảo thẩm mỹ và chức năng nhai tốt nhất cho người dùng.</p>
                    </a>
                    <!-- Chỉnh nha mắc cài -->
                    <a href="${pageContext.request.contextPath}/ViewServiceByCategoryServlet?category=mắc cài" class="service-card">
                        <svg class="text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 11c0-1.1-.9-2-2-2s-2 .9-2 2v2c0 1.1.9 2 2 2s2-.9 2-2v-2zm0 0c0-1.1-.9-2-2-2s-2 .9-2 2v2c0 1.1.9 2 2 2s2-.9 2-2v-2zm0 0c0-1.1-.9-2-2-2s-2 .9-2 2v2c0 1.1.9 2 2 2s2-.9 2-2v-2z"></path>
                        </svg>
                        <h3>Chỉnh nha mắc cài</h3>
                        <p>Nắn chỉnh răng mọc lệch, giúp bạn có một nụ cười khỏe mạnh và tự tin.</p>
                    </a>
                    <!-- Nha khoa trẻ em -->
                    <a href="${pageContext.request.contextPath}/ViewServiceByCategoryServlet?category=trẻ em" class="service-card">
                        <svg class="text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 11c0-1.1-.9-2-2-2s-2 .9-2 2v2c0 1.1.9 2 2 2s2-.9 2-2v-2zm0 0c0-1.1-.9-2-2-2s-2 .9-2 2v2c0 1.1.9 2 2 2s2-.9 2-2v-2zm0 0c0-1.1-.9-2-2-2s-2 .9-2 2v2c0 1.1.9 2 2 2s2-.9 2-2v-2z"></path>
                        </svg>
                        <h3>Nha khoa trẻ em</h3>
                        <p>Mang đến nụ cười khỏe mạnh cho trẻ, giúp trẻ tự tin và có hàm răng đều đẹp.</p>
                    </a>
                </div>
                <!-- Bottom Row: 3 Cards -->
                <div class="grid-row">
                    <!-- Phẫu thuật chỉnh hình xương hàm -->
                    <a href="${pageContext.request.contextPath}/ViewServiceByCategoryServlet?category=xương hàm" class="service-card">
                        <svg class="text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 11c0-1.1-.9-2-2-2s-2 .9-2 2v2c0 1.1.9 2 2 2s2-.9 2-2v-2zm0 0c0-1.1-.9-2-2-2s-2 .9-2 2v2c0 1.1.9 2 2 2s2-.9 2-2v-2zm0 0c0-1.1-.9-2-2-2s-2 .9-2 2v2c0 1.1.9 2 2 2s2-.9 2-2v-2z"></path>
                        </svg>
                        <h3>Phẫu thuật chỉnh hình xương hàm</h3>
                        <p>Giải quyết các vấn đề chỉnh nắn thẩm mỹ và chức năng hàm, nâng cao chất lượng cuộc sống.</p>
                    </a>
                    <!-- Nha khoa thẩm mỹ -->
                    <a href="${pageContext.request.contextPath}/ViewServiceByCategoryServlet?category=thẩm mỹ" class="service-card">
                        <svg class="text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 11c0-1.1-.9-2-2-2s-2 .9-2 2v2c0 1.1.9 2 2 2s2-.9 2-2v-2zm0 0c0-1.1-.9-2-2-2s-2 .9-2 2v2c0 1.1.9 2 2 2s2-.9 2-2v-2zm0 0c0-1.1-.9-2-2-2s-2 .9-2 2v2c0 1.1.9 2 2 2s2-.9 2-2v-2z"></path>
                        </svg>
                        <h3>Nha khoa thẩm mỹ</h3>
                        <p>Mang đến nụ cười tự nhiên, giúp bạn tự tin với nụ cười trắng sáng và hoàn hảo.</p>
                    </a>
                    <!-- Nhổ răng khôn -->
                    <a href="${pageContext.request.contextPath}/ViewServiceByCategoryServlet?category=răng khôn" class="service-card">
                        <svg class="text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 11c0-1.1-.9-2-2-2s-2 .9-2 2v2c0 1.1.9 2 2 2s2-.9 2-2v-2zm0 0c0-1.1-.9-2-2-2s-2 .9-2 2v2c0 1.1.9 2 2 2s2-.9 2-2v-2zm0 0c0-1.1-.9-2-2-2s-2 .9-2 2v2c0 1.1.9 2 2 2s2-.9 2-2v-2z"></path>
                        </svg>
                        <h3>Nhổ răng khôn</h3>
                        <p>Tiến hành an toàn, nhẹ nhàng với công nghệ hiện đại, đảm bảo không đau và nhanh chóng.</p>
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer>
        <div class="container">
            <p>© 2025 Nha Khoa PDC. All rights reserved.</p>
        </div>
    </footer>

    <!-- JavaScript for interactions -->
    <script>
        // Toggle user menu
        const userMenuBtn = document.getElementById('userMenuBtn');
        const userMenu = document.getElementById('userMenu');
        userMenuBtn.addEventListener('click', function() {
            userMenu.style.display = userMenu.style.display === 'block' ? 'none' : 'block';
        });

        // Close menu when clicking outside
        document.addEventListener('click', function(event) {
            if (!userMenuBtn.contains(event.target) && !userMenu.contains(event.target)) {
                userMenu.style.display = 'none';
            }
        });
    </script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng Điều Khiển Bác Sĩ/Y Tá</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            background: linear-gradient(135deg, #fff3e0, #ffcc80);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .search-container {
            max-width: 800px;
            width: 100%;
            margin: 20px 0;
            position: relative;
        }
        .search-container input {
            width: 100%;
            padding: 10px 40px 10px 12px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            outline: none;
            transition: border-color 0.3s;
            background-color: #ffffff;
        }
        .search-container input:focus {
            border-color: #F57C00;
            box-shadow: 0 0 0 2px rgba(245, 124, 0, 0.2);
        }
        .search-icon {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 1.2rem;
            color: #6b7280;
            pointer-events: none;
        }
        .action-card {
            background-color: #ffffff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            max-width: 500px;
            width: 100%;
            margin: 0 auto;
            border: 2px solid #F57C00;
        }
        .action-card h3 {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 16px;
            text-align: center;
            color: #2c3e50;
        }
        .action-card a {
            display: block;
            width: 100%;
            padding: 10px;
            margin-bottom: 8px;
            border-radius: 4px;
            text-align: center;
            color: white;
            text-decoration: none;
            background-color: #F57C00;
            transition: background-color 0.3s ease;
        }
        .action-card a:hover {
            background-color: #EF6C00;
        }
        .container {
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .user-menu-btn {
            background-color: #F57C00;
            color: white;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background-color 0.3s ease;
            border: none;
            cursor: pointer;
            font-size: 1.2rem;
        }
        .user-menu-btn:hover {
            background-color: #EF6C00;
        }
        .user-menu {
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            position: absolute;
            right: 0;
            top: 100%;
            margin-top: 8px;
            min-width: 150px;
            z-index: 10;
            display: none;
        }
        .user-menu a {
            color: #2c3e50;
            padding: 10px 16px;
            display: block;
            transition: background-color 0.3s ease;
        }
        .user-menu a:hover {
            background-color: #fff3e0;
        }
        .user-menu.active {
            display: block;
        }
    </style>
</head>
<body>
    <div class="container mx-auto p-4">
        <!-- Search Bar -->
        <div class="search-container">
             <!-- FORM TÌM KIẾM -->
                <div class="mb-3">
                    <form action="ViewEmployeeServlet" method="get" class="d-flex search-form" style="max-width: 600px;">
                        <input type="text" name="keyword" class="form-control me-2" placeholder="Tìm theo tên, email..."
                               value="${keyword != null ? keyword : ''}">
                        <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                    </form>
                </div>
        </div>
        <!-- Header with User Menu -->
        <div class="flex justify-end mb-6 w-full relative">
            <div class="relative">
                <button id="userMenuBtn" class="user-menu-btn">👤</button>
                <div id="userMenu" class="user-menu">
                    <a href="${pageContext.request.contextPath}/UserProfileController" class="block">View Profile</a>
                    <a href="${pageContext.request.contextPath}/EditProfileUserController" class="block">Edit Profile</a>
                    <a href="${pageContext.request.contextPath}/LogoutServlet" class="block" onclick="return confirm('Bạn có chắc muốn thoát?')">Sign Out</a>
                </div>
            </div>
        </div>
        <!-- Action Buttons -->
        <div class="action-card">
            <h3>Quản Lý Bác Sĩ/Y Tá</h3>
            <a href="#" class="btn-green">Thêm Kết Quả Khám</a>
            <a href="#" class="btn-green">Thêm Đơn Thuốc</a>
            <a href="#" class="btn-green">Xem Lịch Làm Việc</a>
        </div>
    </div>
    <script>
        const userMenuBtn = document.getElementById('userMenuBtn');
        const userMenu = document.getElementById('userMenu');
        userMenuBtn.addEventListener('click', function() {
            userMenu.classList.toggle('active');
        });
        document.addEventListener('click', function(event) {
            if (!userMenuBtn.contains(event.target) && !userMenu.contains(event.target)) {
                userMenu.classList.remove('active');
            }
        });
    </script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng Điều Khiển Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            background: linear-gradient(135deg, #d1fae5, #a7f3d0);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            margin: 0;
            position: relative;
            padding-top: 60px;
        }
        .search-container {
            max-width: 600px;
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
            position: relative;
        }
        .search-container input {
            width: 100%;
            height: 36px;
            padding: 8px 40px 8px 10px;
            border: 1px solid #d1d5db;
            border-radius: 4px 0 0 4px;
            outline: none;
            transition: border-color 0.3s;
            background-color: #ffffff;
            font-size: 0.9rem;
            box-sizing: border-box;
            line-height: normal;
        }
        .search-container input:focus {
            border-color: #10b981;
            box-shadow: 0 0 0 2px rgba(16, 185, 129, 0.2);
        }
        .search-container button {
            height: 36px;
            padding: 0 12px;
            font-size: 0.9rem;
            font-weight: bold;
            background-color: #059669;
            color: white;
            border: 1px solid #059669;
            border-left: none;
            border-radius: 0 4px 4px 0;
            transition: background-color 0.3s ease;
            line-height: normal;
            box-sizing: border-box;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .search-container button:hover {
            background-color: #047857;
        }
        .search-icon {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 0.9rem;
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
            border: 2px solid #10b981;
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
            background-color: #10b981;
            transition: background-color 0.3s ease;
        }
        .action-card a:hover {
            background-color: #059669;
        }
        .container {
            display: flex;
            flex-direction: column;
            align-items: center;
            width: 100%;
            max-width: 1000px;
            margin: 0 auto;
            position: relative;
        }
        .header-bar {
            display: flex;
            justify-content: center;
            align-items: center;
            width: 100%;
            max-width: 1000px;
            position: fixed;
            top: 20px;
            z-index: 10;
        }
        .user-menu-container {
            position: absolute;
            top: 0;
            right: 0;
        }
        .user-menu-btn {
            background-color: #10b981;
            color: white;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background-color 0.3s ease;
            border: none;
            cursor: pointer;
            font-size: 1.1rem;
        }
        .user-menu-btn:hover {
            background-color: #059669;
        }
        .user-menu {
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            position: absolute;
            right: 0; /* Căn phải với nút hình người */
            top: 40px; /* Đặt ngay dưới nút hình người (36px là chiều cao của nút + 4px khoảng cách) */
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
            background-color: #d1fae5;
        }
        .user-menu.active {
            display: block;
        }
    </style>
</head>
<body>
    <div class="header-bar">
        <div class="search-container">
            <form action="ViewEmployeeServlet" method="get" class="flex w-full">
                <div class="relative w-full">
                    <input type="text" name="keyword" class="form-control" placeholder="Tìm theo tên, email..."
                           value="${keyword != null ? keyword : ''}">
                    <span class="search-icon">🔍</span>
                </div>
                <button type="submit" class="btn btn-primary">Tìm kiếm</button>
            </form>
        </div>
        <div class="user-menu-container">
            <button id="userMenuBtn" class="user-menu-btn">👤</button>
            <div id="userMenu" class="user-menu">
                <a href="${pageContext.request.contextPath}/AdminProfileController" class="block">View Profile</a>
                <a href="${pageContext.request.contextPath}/EditProfileAdminController" class="block">Edit Profile</a>
                <a href="${pageContext.request.contextPath}/LogoutServlet" class="block" onclick="return confirm('Bạn có chắc muốn thoát?')">Sign Out</a>
            </div>
        </div>
    </div>
    <div class="container mx-auto p-4" style="margin-top: 80px;">
        <!-- Action Buttons -->
        <div class="action-card">
            <h3>Dental Clinic Management</h3>
            <a href="${pageContext.request.contextPath}/ViewPatientServlet" class="btn-green">View Patients</a>
            <a href="${pageContext.request.contextPath}/ViewEmployeeServlet" class="btn-green">View Employees</a>
            <a href="${pageContext.request.contextPath}/ViewServiceServlet" class="btn-green">View Services</a>
            <a href="ViewAppointments.jsp" class="btn-green">View Appointment List</a>
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
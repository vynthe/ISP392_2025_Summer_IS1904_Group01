<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Dịch Vụ</title>
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
            width: 150px;
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
        /* Detail Section */
        .detail-section {
            padding: 60px 0;
            background: #FFF5E1; /* Trắng kem */
        }
        .detail-section h2 {
            font-size: 32px;
            color: #8B4513; /* Nâu đậm */
            margin-bottom: 20px;
            text-align: center;
        }
        .detail-card {
            background: #FFFFFF; /* White background */
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            margin: 0 auto;
            max-width: 800px;
        }
        .detail-card p {
            font-size: 16px;
            color: #4B5563; /* Gray text */
            margin: 10px 0;
        }
        .detail-card strong {
            color: #1F2937; /* Darker gray for labels */
        }
        .action-buttons {
            margin-top: 20px;
            text-align: center;
        }
        .action-btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin: 0 10px;
            font-size: 16px;
            transition: background 0.2s;
        }
        .back-btn {
            background: #D2B48C; /* Nâu nhạt */
            color: #8B4513; /* Nâu đậm */
        }
        .back-btn:hover {
            background: #A0522D; /* Nâu đậm hơn */
            color: #FFF5E1;
        }
        .book-btn {
            background: #007BFF; /* Blue */
            color: white;
        }
        .book-btn:hover {
            background: #0056B3;
        }
        .no-service {
            text-align: center;
            font-size: 16px;
            color: #666666;
            padding: 20px;
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
                <a href="${pageContext.request.contextPath}/dashboardpatient.jsp">Home</a>
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

    <!-- Detail Section -->
    <section class="detail-section">
        <div class="container">
            <h2>Chi Tiết Dịch Vụ</h2>
            <c:choose>
                <c:when test="${empty service}">
                    <p class="no-service">Không tìm thấy dịch vụ.</p>
                </c:when>
                <c:otherwise>
                    <div class="detail-card">
                        <p><strong>ID:</strong> ${service.serviceID}</p>
                        <p><strong>Tên Dịch Vụ:</strong> ${service.serviceName}</p>
                        <p><strong>Mô Tả:</strong> ${service.description}</p>
                        <p><strong>Giá (VND):</strong> ${service.price}</p>
                        <p><strong>Trạng thái:</strong> ${service.status}</p>
                        <p><strong>Ngày tạo:</strong> <fmt:formatDate value="${service.createdAt}" pattern="dd/MM/yyyy" /></p>
                        <p><strong>Ngày cập nhật:</strong> <fmt:formatDate value="${service.updatedAt}" pattern="dd/MM/yyyy" /></p>
                        <div class="action-buttons">
                            <form action="${pageContext.request.contextPath}/ViewServiceByCategoryServlet" method="get" style="display:inline;">
                                <input type="hidden" name="category" value="${param.category}">
                                <button type="submit" class="action-btn back-btn">Quay lại</button>
                            </form>
                            <form action="${pageContext.request.contextPath}/BookAppointmentController" method="get" style="display:inline;">
                                <input type="hidden" name="serviceId" value="${service.serviceID}">
                                <button type="submit" class="action-btn book-btn">Đặt lịch</button>
                            </form>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>


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
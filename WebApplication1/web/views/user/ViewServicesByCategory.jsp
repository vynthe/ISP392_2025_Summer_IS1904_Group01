<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh Sách Dịch Vụ - ${category}</title>
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
        /* Services Section */
        .services {
            padding: 60px 0;
            background: #FFF5E1; /* Trắng kem */
        }
        .services h2 {
            font-size: 32px;
            color: #8B4513; /* Nâu đậm */
            margin-bottom: 20px;
            text-align: center;
        }
        .services p {
            font-size: 18px;
            color: #666666; /* Xám nhạt */
            margin-bottom: 40px;
            text-align: center;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: #FFFFFF; /* White background */
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }
        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background: #8B4513; /* Nâu đậm */
            color: #FFF5E1; /* Trắng kem */
            font-size: 16px;
        }
        td {
            color: #4B5563; /* Gray text */
            font-size: 14px;
        }
        .action-btn {
            padding: 8px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-right: 10px;
            font-size: 14px;
            transition: background 0.2s;
        }
        .view-btn {
            background: #6F42C1; /* Purple */
            color: white;
        }
        .view-btn:hover {
            background: #5A32A3;
        }
        .book-btn {
            background: #007BFF; /* Blue */
            color: white;
        }
        .book-btn:hover {
            background: #0056B3;
        }
        .back-btn {
            display: inline-block;
            background: #D2B48C; /* Nâu nhạt */
            color: #8B4513; /* Nâu đậm */
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            margin-bottom: 20px;
            font-size: 16px;
        }
        .back-btn:hover {
            background: #A0522D; /* Nâu đậm hơn */
            color: #FFF5E1;
        }
        .no-services {
            text-align: center;
            font-size: 16px;
            color: #666666;
            padding: 20px;
        }
       .nav-buttons .btn {
            padding: 8px 20px;
            margin-left: 10px;
            border: 1px solid #FFF5E1; /* Viền trắng kem */
            border-radius: 20px;
            background: transparent;
            color: #FFF5E1; /* Trắng kem */
            cursor: pointer;
            font-size: 16px;
        }
        .nav-buttons .btn:hover {
            background: #D2B48C; /* Nâu nhạt */
            color: #8B4513; /* Nâu đậm */
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
                <div class="nav-buttons">
                <button class="btn" onclick="window.location.href='${pageContext.request.contextPath}/views/common/login.jsp?form=login'">Sign In</button>
                <button class="btn" onclick="window.location.href='${pageContext.request.contextPath}/views/common/login.jsp?form=register'">Sign Up</button>
            </div>
    </header>

    <!-- Services Section -->
    <section class="services">
        <div class="container">
            <h2>Danh Sách Dịch Vụ - ${category}</h2>
            <a href="${pageContext.request.contextPath}/views/common/HomePage.jsp" class="back-btn">Quay lại</a>
            <c:choose>
                <c:when test="${empty services}">
                    <p class="no-services">Không tìm thấy dịch vụ nào cho danh mục "${category}".</p>
                </c:when>
                <c:otherwise>
                    <table>
                        <thead>
                            <tr>
                                <th>Tên Dịch Vụ</th>
                                <th>Giá (VND)</th>
                                <th>Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="service" items="${services}">
                                <tr>
                                    <td>${service.serviceName}</td>
                                    <td>${service.price} VND</td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/ViewDetailServicePatientServlet" method="get" style="display:inline;">
                                            <input type="hidden" name="id" value="${service.serviceID}">
                                            <input type="hidden" name="category" value="${category}">
                                            <button type="submit" class="action-btn view-btn">Xem chi tiết</button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/BookAppointmentController" method="get" style="display:inline;">
                                            <input type="hidden" name="serviceId" value="${service.serviceID}">
                                            <button type="submit" class="action-btn book-btn">Đặt lịch ngay</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

>

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
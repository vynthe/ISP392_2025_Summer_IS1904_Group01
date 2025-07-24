<%-- 
    Document   : AddService
    Created on : May 23, 2025
    Author     : Grok
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Thêm Dịch Vụ</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <style>
            /* Reset default styles */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', Arial, sans-serif;
            }

            body {
                background: linear-gradient(135deg, #ede7f6, #d1c4e9);
                min-height: 100vh;
                display: flex;
                flex-direction: column;
            }

            /* Header Styles */
            .header {
                background: linear-gradient(135deg, #7B1FA2, #AB47BC);
                color: white;
                padding: 20px 0;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                position: sticky;
                top: 0;
                z-index: 1000;
            }

            .header-container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 20px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .logo {
                display: flex;
                align-items: center;
                font-size: 24px;
                font-weight: bold;
            }

            .logo i {
                margin-right: 10px;
                font-size: 28px;
            }

            .nav-menu {
                display: flex;
                list-style: none;
                gap: 30px;
            }

            .nav-menu li a {
                color: white;
                text-decoration: none;
                font-weight: 500;
                transition: all 0.3s ease;
                padding: 8px 16px;
                border-radius: 5px;
            }

            .nav-menu li a:hover {
                background: rgba(255, 255, 255, 0.2);
                transform: translateY(-2px);
            }

            .user-info {
                display: flex;
                align-items: center;
                gap: 15px;
            }

            .user-avatar {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background: rgba(255, 255, 255, 0.2);
                display: flex;
                align-items: center;
                justify-content: center;
            }

            /* Main Content */
            .main-content {
                flex: 1;
                display: flex;
                justify-content: center;
                align-items: center;
                padding: 40px 20px;
            }

            .container {
                background: #ffffff;
                padding: 40px;
                border-radius: 15px;
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
                width: 100%;
                max-width: 550px;
                position: relative;
                overflow: hidden;
            }

            .container::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 5px;
                background: linear-gradient(to right, #7B1FA2, #AB47BC);
            }

            h2 {
                text-align: center;
                color: #2c3e50;
                margin-bottom: 30px;
                font-size: 28px;
                font-weight: 600;
                letter-spacing: 1px;
            }

            .form-group, .mb-3, .input-box {
                margin-bottom: 20px;
                position: relative;
            }

            .form-group label, .mb-3 label {
                display: block;
                font-weight: 500;
                margin-bottom: 8px;
                color: #34495e;
                font-size: 15px;
            }

            .form-group input[type="text"],
            .form-group input[type="number"],
            .form-group textarea,
            .form-group select,
            .input-box input,
            .input-box select,
            .input-box textarea {
                width: 100%;
                padding: 12px 40px 12px 15px;
                border: 1px solid #dfe6e9;
                border-radius: 8px;
                font-size: 14px;
                background: #f9fafb;
                transition: all 0.3s ease;
            }

            .form-group textarea {
                resize: vertical;
                min-height: 100px;
            }

            .form-group input:focus,
            .form-group textarea:focus,
            .form-group select:focus,
            .input-box input:focus,
            .input-box select:focus,
            .input-box textarea:focus {
                border-color: #7B1FA2;
                background: #ffffff;
                box-shadow: 0 0 5px rgba(123, 31, 162, 0.2);
                outline: none;
            }

            .input-box i {
                position: absolute;
                right: 15px;
                top: 50%;
                transform: translateY(-50%);
                color: #7f8c8d;
                font-size: 16px;
            }

            .form-group input[type="submit"],
            .form-group input[type="button"] {
                width: 100%;
                padding: 14px;
                background: linear-gradient(to right, #7B1FA2, #AB47BC);
                color: white;
                border: none;
                border-radius: 8px;
                font-size: 16px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s ease;
                text-transform: uppercase;
                letter-spacing: 1px;
                margin-bottom: 10px;
            }

            .form-group input[type="submit"]:hover,
            .form-group input[type="button"]:hover {
                background: linear-gradient(to right, #6A1B9A, #9C27B0);
                box-shadow: 0 5px 15px rgba(123, 31, 162, 0.3);
            }

            .error {
                background-color: #ffebee;
                color: #c62828;
                padding: 12px;
                border-radius: 8px;
                margin-bottom: 20px;
                text-align: center;
                font-size: 14px;
                border-left: 4px solid #c62828;
            }

            select option[disabled] {
                color: #b0bec5;
            }

            /* Footer Styles */
            .footer {
                background: #2c3e50;
                color: white;
                padding: 40px 0 20px 0;
                margin-top: auto;
            }

            .footer-container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 20px;
            }

            .footer-content {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 40px;
                margin-bottom: 30px;
            }

            .footer-section h3 {
                color: #AB47BC;
                margin-bottom: 20px;
                font-size: 18px;
                font-weight: 600;
            }

            .footer-section p,
            .footer-section li {
                line-height: 1.8;
                color: #bdc3c7;
                margin-bottom: 8px;
            }

            .footer-section ul {
                list-style: none;
            }

            .footer-section ul li a {
                color: #bdc3c7;
                text-decoration: none;
                transition: color 0.3s ease;
            }

            .footer-section ul li a:hover {
                color: #AB47BC;
            }

            .social-links {
                display: flex;
                gap: 15px;
                margin-top: 15px;
            }

            .social-links a {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background: #34495e;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                text-decoration: none;
                transition: all 0.3s ease;
            }

            .social-links a:hover {
                background: #AB47BC;
                transform: translateY(-3px);
            }

            .footer-bottom {
                border-top: 1px solid #34495e;
                padding-top: 20px;
                text-align: center;
                color: #7f8c8d;
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .header-container {
                    flex-direction: column;
                    gap: 20px;
                }

                .nav-menu {
                    gap: 15px;
                }

                .nav-menu li a {
                    padding: 5px 10px;
                    font-size: 14px;
                }

                .container {
                    margin: 20px;
                    padding: 30px 20px;
                }

                .footer-content {
                    grid-template-columns: 1fr;
                    gap: 30px;
                }
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <header class="header">
            <div class="header-container">
                <div class="logo">
                    <i class="fas fa-hospital"></i>
                    <span>HealthCare System</span>
                </div>
                <nav>
                    <ul class="nav-menu">
                        <li><a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp"><i class="fas fa-home"></i> Trang Chủ</a></li>
                        <li><a href="${pageContext.request.contextPath}/ViewServiceServlet"><i class="fas fa-list"></i> Dịch Vụ</a></li>
                        <li><a href="${pageContext.request.contextPath}/AddServiceServlet"><i class="fas fa-calendar"></i> Thêm Dịch Vụ</a></li>
                    </ul>
                </nav>
                <div class="user-info">
                    <div class="user-avatar">
                        <i class="fas fa-user"></i>
                    </div>
                    <span>Admin</span>
                </div>
            </div>
        </header>

        <!-- Main Content -->
        <main class="main-content">
            <div class="container">
                <h2>Thêm Dịch Vụ</h2>
                <c:if test="${not empty requestScope.error}">
                    <div class="error">${requestScope.error}</div>
                </c:if>
                <form action="${pageContext.request.contextPath}/AddServiceServlet" method="post" id="serviceForm">
                    <div class="form-group">
                        <label for="serviceName">Tên Dịch Vụ:</label>
                        <div class="input-box">
                            <input type="text" id="serviceName" name="serviceName" value="${sessionScope.formData.serviceName}" placeholder="Nhập tên dịch vụ" required>
                            <i class="fas fa-briefcase-medical"></i>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="description">Mô Tả:</label>
                        <div class="input-box">
                            <textarea id="description" name="description" placeholder="Nhập mô tả dịch vụ">${sessionScope.formData.description}</textarea>
                            <i class="fas fa-align-left"></i>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="price">Giá (VNĐ):</label>
                        <div class="input-box">
                            <input type="number" id="price" name="price" value="${sessionScope.formData.price}" placeholder="Nhập giá dịch vụ" min="0" step="1000" required>
                            <i class="fas fa-money-bill"></i>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="status">Trạng Thái:</label>
                        <div class="input-box">
                            <select id="status" name="status" required>
                                <option value="" disabled ${empty sessionScope.formData.status ? 'selected' : ''}>Chọn trạng thái</option>
                                <option value="Active" ${sessionScope.formData.status == 'Active' ? 'selected' : ''}>Active</option>
                                <option value="Inactive" ${sessionScope.formData.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                            </select>
                            <i class="fas fa-toggle-on"></i>
                        </div>
                    </div>
                    <div class="form-group">
                        <input type="submit" value="Thêm Dịch Vụ">
                    </div>
                    <div class="form-group">
                        <input type="button" value="Quay Lại Danh Sách" onclick="window.history.back()">
                    </div> 
                </form>
            </div>
        </main>

        <!-- Footer -->
        <footer class="footer">
            <div class="footer-container">
                <div class="footer-content">
                    <div class="footer-section">
                        <h3>Về Chúng Tôi</h3>
                        <p>HealthCare System là hệ thống quản lý dịch vụ y tế hàng đầu, cung cấp các giải pháp toàn diện cho việc quản lý bệnh viện và phòng khám.</p>
                        <div class="social-links">
                            <a href="#"><i class="fab fa-facebook-f"></i></a>
                            <a href="#"><i class="fab fa-twitter"></i></a>
                            <a href="#"><i class="fab fa-linkedin-in"></i></a>
                            <a href="#"><i class="fab fa-instagram"></i></a>
                        </div>
                    </div>
                    <div class="footer-section">
                        <h3>Dịch Vụ</h3>
                        <ul>
                            <li><a href="#">Quản lý bệnh nhân</a></li>
                            <li><a href="#">Đặt lịch hẹn</a></li>
                            <li><a href="#">Quản lý dịch vụ y tế</a></li>
                            <li><a href="#">Báo cáo thống kê</a></li>
                            <li><a href="#">Hỗ trợ kỹ thuật</a></li>
                        </ul>
                    </div>
                    <div class="footer-section">
                        <h3>Liên Hệ</h3>
                        <ul>
                            <li><i class="fas fa-map-marker-alt"></i> 123 Đường ABC, Quận 1, TP.HCM</li>
                            <li><i class="fas fa-phone"></i> (028) 1234-5678</li>
                            <li><i class="fas fa-envelope"></i> info@healthcare.com</li>
                            <li><i class="fas fa-clock"></i> 24/7 Hỗ trợ khách hàng</li>
                        </ul>
                    </div>
                    <div class="footer-section">
                        <h3>Liên Kết Nhanh</h3>
                        <ul>
                            <li><a href="#">Trang chủ</a></li>
                            <li><a href="#">Chính sách bảo mật</a></li>
                            <li><a href="#">Điều khoản sử dụng</a></li>
                            <li><a href="#">Hỗ trợ</a></li>
                            <li><a href="#">FAQ</a></li>
                        </ul>
                    </div>
                </div>
                <div class="footer-bottom">
                    <p>&copy; 2025 HealthCare System. Tất cả quyền được bảo lưu. | Phát triển bởi Your Company</p>
                </div>
            </div>
        </footer>
    </body>
</html>
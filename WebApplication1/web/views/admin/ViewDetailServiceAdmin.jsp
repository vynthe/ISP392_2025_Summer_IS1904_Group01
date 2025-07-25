<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.entity.Services" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết Dịch Vụ</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <style>
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
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }

            .header .container-fluid {
                max-width: 1200px;
                margin: 0 auto;
            }

            .header .nav-brand {
                font-size: 28px;
                font-weight: 700;
                text-decoration: none;
                color: white;
                display: flex;
                align-items: center;
            }

            .header .nav-brand i {
                margin-right: 10px;
                font-size: 32px;
            }

            .header .nav-brand:hover {
                color: #f8f9fa;
                text-decoration: none;
            }

            .header .nav-links {
                display: flex;
                align-items: center;
                gap: 30px;
            }

            .header .nav-links a {
                color: white;
                text-decoration: none;
                font-weight: 500;
                padding: 8px 16px;
                border-radius: 5px;
                transition: all 0.3s ease;
            }

            .header .nav-links a:hover {
                background: rgba(255,255,255,0.1);
                color: white;
                text-decoration: none;
            }

            .header .nav-links .btn-home {
                background: rgba(255,255,255,0.2);
                border: 1px solid rgba(255,255,255,0.3);
            }

            .header .nav-links .btn-home:hover {
                background: rgba(255,255,255,0.3);
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
                max-width: 1000px;
                display: flex;
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

            .illustration {
                position: absolute;
                top: 50%;
                left: 30%;
                transform: translate(-50%, -50%);
                flex: 0 0 40%;
                padding: 10px;
                text-align: center;
                z-index: 5;
            }

            .illustration img {
                max-width: 100%;
                max-height: 300px;
                border-radius: 10px;
                object-fit: contain;
            }

            .details {
                flex: 1;
                padding: 20px;
                margin-left: 50%;
            }

            .detail-group {
                display: flex;
                align-items: center;
                margin-bottom: 20px;
            }

            .detail-icon {
                flex: 0 0 50px;
                text-align: center;
                margin-right: 15px;
            }

            .detail-icon i {
                color: #7B1FA2;
                font-size: 24px;
            }

            .detail-content {
                flex: 1;
            }

            .detail-content label {
                display: block;
                font-weight: 500;
                margin-bottom: 8px;
                color: #34495e;
                font-size: 15px;
            }

            .detail-content .detail-value {
                width: 100%;
                padding: 12px 15px;
                border: 1px solid #dfe6e9;
                border-radius: 8px;
                font-size: 14px;
                background: #f9fafb;
                color: #555;
            }

            .detail-content .detail-value.multiline {
                min-height: 100px;
                resize: vertical;
            }

            .btn-primary, .btn-back {
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
                text-decoration: none;
                text-align: center;
                display: block;
                margin-bottom: 10px;
            }

            .btn-primary:hover, .btn-back:hover {
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

            /* Footer Styles */
            .footer {
                background: linear-gradient(135deg, #2c3e50, #34495e);
                color: white;
                padding: 40px 0 20px 0;
                margin-top: auto;
            }

            .footer .container-fluid {
                max-width: 1200px;
                margin: 0 auto;
            }

            .footer-content {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 30px;
                margin-bottom: 30px;
            }

            .footer-section h4 {
                color: #AB47BC;
                margin-bottom: 15px;
                font-size: 18px;
                font-weight: 600;
            }

            .footer-section p, .footer-section li {
                color: #bdc3c7;
                line-height: 1.6;
                margin-bottom: 8px;
            }

            .footer-section ul {
                list-style: none;
                padding: 0;
            }

            .footer-section ul li a {
                color: #bdc3c7;
                text-decoration: none;
                transition: color 0.3s ease;
            }

            .footer-section ul li a:hover {
                color: #AB47BC;
            }

            .footer-section .social-links {
                display: flex;
                gap: 15px;
                margin-top: 15px;
            }

            .footer-section .social-links a {
                display: inline-block;
                width: 40px;
                height: 40px;
                background: #AB47BC;
                color: white;
                text-align: center;
                line-height: 40px;
                border-radius: 50%;
                transition: all 0.3s ease;
            }

            .footer-section .social-links a:hover {
                background: #7B1FA2;
                transform: translateY(-2px);
            }

            .footer-bottom {
                border-top: 1px solid #34495e;
                padding-top: 20px;
                text-align: center;
                color: #95a5a6;
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .header .container-fluid {
                    flex-direction: column;
                    gap: 15px;
                }

                .header .nav-links {
                    justify-content: center;
                    flex-wrap: wrap;
                }

                .container {
                    flex-direction: column;
                    padding: 20px;
                }

                .illustration {
                    position: relative;
                    top: auto;
                    left: auto;
                    transform: none;
                    margin-bottom: 30px;
                }

                .details {
                    margin-left: 0;
                }

                .footer-content {
                    grid-template-columns: 1fr;
                    text-align: center;
                }
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <header class="header">
            <div class="container-fluid d-flex justify-content-between align-items-center">
                <a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp" class="nav-brand">
                    <i class="fas fa-tooth"></i>
                    Nha Khoa Smile
                </a>
                <nav class="nav-links">
                    <a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp">
                        <i class="fas fa-home"></i> Trang chủ
                    </a>
                    <a href="${pageContext.request.contextPath}/ViewServiceServlet">
                        <i class="fas fa-list"></i> Dịch vụ
                    </a>
                    
                </nav>
            </div>
        </header>

        <!-- Main Content -->
        <main class="main-content">
            <div class="container">
                <div class="illustration">
                    <c:choose>
                        <c:when test="${not empty requestScope.service}">
                            <c:choose>
                                <c:when test="${requestScope.service.serviceID == 1}">
                                    <img src="https://nhakhoanhantam.com/stmresource/files/nho-rang/nho-rang-khon-co-dau-khong.jpg" 
                                         alt="Nhổ răng" width="300" height="200" />
                                </c:when>
                                <c:when test="${requestScope.service.serviceID == 2}">
                                    <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS-uN-5wAcHTV9lvb6sn9H5Vm49JjpCuBZQbQ&s"
                                         alt="Dịch vụ răng 2" width="300" height="200" />
                                </c:when>
                                <c:when test="${requestScope.service.serviceID == 4}">
                                    <img src="https://images.pexels.com/photos/3942924/pexels-photo-3942924.jpeg?auto=compress&cs=tinysrgb&w=300" alt="Sửa hàm Illustration">
                                </c:when>
                                <c:when test="${requestScope.service.serviceID == 5}">
                                    <img src="https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=300" alt="Sửa đầu Illustration">
                                </c:when>
                                <c:when test="${requestScope.service.serviceID == 6}">
                                    <img src="https://images.pexels.com/photos/4065899/pexels-photo-4065899.jpeg?auto=compress&cs=tinysrgb&w=300" alt="Mắc cài Illustration">
                                </c:when>
                                <c:when test="${requestScope.service.serviceID == 7}">
                                    <img src="https://images.pexels.com/photos/3996798/pexels-photo-3996798.jpeg?auto=compress&cs=tinysrgb&w=300" alt="Niềng răng Illustration">
                                </c:when>
                                <c:otherwise>
                                    <img src="https://via.placeholder.com/300x400?text=Service+${requestScope.service.serviceID}" alt="Service Illustration">
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                        <c:otherwise>
                            <img src="https://via.placeholder.com/300x400?text=No+Image+Available" alt="No Image Available">
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="details">
                    <h2>Chi tiết Dịch Vụ</h2>
                    <c:choose>
                        <c:when test="${not empty requestScope.service}">
                            <div class="detail-group">
                                <div class="detail-icon">
                                    <i class="fas fa-id-badge"></i>
                                </div>
                                <div class="detail-content">
                                    <label>ID:</label>
                                    <div class="detail-value">${requestScope.service.serviceID}</div>
                                </div>
                            </div>
                            <div class="detail-group">
                                <div class="detail-icon">
                                    <i class="fas fa-briefcase-medical"></i>
                                </div>
                                <div class="detail-content">
                                    <label>Tên dịch vụ:</label>
                                    <div class="detail-value">${requestScope.service.serviceName}</div>
                                </div>
                            </div>
                            <div class="detail-group">
                                <div class="detail-icon">
                                    <i class="fas fa-align-left"></i>
                                </div>
                                <div class="detail-content">
                                    <label>Mô tả:</label>
                                    <div class="detail-value multiline">${requestScope.service.description}</div>
                                </div>
                            </div>
                            <div class="detail-group">
                                <div class="detail-icon">
                                    <i class="fas fa-money-bill"></i>
                                </div>
                                <div class="detail-content">
                                    <label>Giá (VNĐ):</label>
                                    <div class="detail-value"><fmt:formatNumber value="${requestScope.service.price}" type="number" pattern="#,##0" /></div>
                                </div>
                            </div>
                            <div class="detail-group">
                                <div class="detail-icon">
                                    <i class="fas fa-toggle-on"></i>
                                </div>
                                <div class="detail-content">
                                    <label>Trạng thái:</label>
                                    <div class="detail-value">${requestScope.service.status}</div>
                                </div>
                            </div>
                            <div class="detail-group">
                                <div class="detail-icon">
                                    <i class="fas fa-calendar-plus"></i>
                                </div>
                                <div class="detail-content">
                                    <label>Ngày tạo:</label>
                                    <div class="detail-value"><fmt:formatDate value="${requestScope.service.createdAt}" pattern="dd/MM/yyyy" /></div>
                                </div>
                            </div>
                            <div class="detail-group">
                                <div class="detail-icon">
                                    <i class="fas fa-calendar-check"></i>
                                </div>
                                <div class="detail-content">
                                    <label>Ngày cập nhật:</label>
                                    <div class="detail-value"><fmt:formatDate value="${requestScope.service.updatedAt}" pattern="dd/MM/yyyy" /></div>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="error">Không tìm thấy thông tin dịch vụ!</div>
                        </c:otherwise>
                    </c:choose>
<!--                    <div class="detail-group">
                        <a href="${pageContext.request.contextPath}/ViewServiceServlet" class="btn btn-back">Quay lại danh sách</a>
                    </div>-->
                </div>
            </div>
        </main>

        <!-- Footer -->
        <footer class="footer">
            <div class="container-fluid">
                <div class="footer-content">
                    <div class="footer-section">
                        <h4><i class="fas fa-tooth"></i> Nha Khoa Smile</h4>
                        <p>Chúng tôi cam kết mang đến dịch vụ nha khoa chất lượng cao với đội ngũ bác sĩ giàu kinh nghiệm và trang thiết bị hiện đại.</p>
                        <div class="social-links">
                            <a href="#"><i class="fab fa-facebook-f"></i></a>
                            <a href="#"><i class="fab fa-instagram"></i></a>
                            <a href="#"><i class="fab fa-youtube"></i></a>
                            <a href="#"><i class="fab fa-linkedin-in"></i></a>
                        </div>
                    </div>
                    
                    <div class="footer-section">
                        <h4><i class="fas fa-stethoscope"></i> Dịch Vụ</h4>
                        <ul>
                            <li><a href="#">Nhổ răng khôn</a></li>
                            <li><a href="#">Trám răng</a></li>
                            <li><a href="#">Niềng răng</a></li>
                            <li><a href="#">Tẩy trắng răng</a></li>
                            <li><a href="#">Cấy ghép implant</a></li>
                            <li><a href="#">Điều trị nướu</a></li>
                        </ul>
                    </div>
                    
                    <div class="footer-section">
                        <h4><i class="fas fa-map-marker-alt"></i> Liên Hệ</h4>
                        <p><i class="fas fa-home"></i> 123 Đường ABC, Quận 1, TP.HCM</p>
                        <p><i class="fas fa-phone"></i> +84 123 456 789</p>
                        <p><i class="fas fa-envelope"></i> info@nhakhoasmile.com</p>
                        <p><i class="fas fa-clock"></i> Thứ 2 - Chủ nhật: 8:00 - 20:00</p>
                    </div>
                    
                    <div class="footer-section">
                        <h4><i class="fas fa-info-circle"></i> Thông Tin</h4>
                        <ul>
                            <li><a href="#">Về chúng tôi</a></li>
                            <li><a href="#">Đội ngũ bác sĩ</a></li>
                            <li><a href="#">Tin tức</a></li>
                            <li><a href="#">Chính sách bảo mật</a></li>
                            <li><a href="#">Điều khoản sử dụng</a></li>
                            <li><a href="#">Hỗ trợ khách hàng</a></li>
                        </ul>
                    </div>
                </div>
                
                <div class="footer-bottom">
                    <p>&copy; 2024 Nha Khoa Smile. Tất cả quyền được bảo lưu. | Thiết kế bởi <strong>Smile Team</strong></p>
                </div>
            </div>
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
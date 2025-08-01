<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.entity.Users" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết Nhân Viên</title>
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
                background: linear-gradient(135deg, #fff3e0, #ffe082);
                min-height: 100vh;
                display: flex;
                flex-direction: column;
            }

            /* Header Styles */
            .header {
                background: linear-gradient(135deg, #f57f17, #ffca28);
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
                padding: 40px 20px;
            }

            .container {
                background: #ffffff;
                padding: 40px;
                border-radius: 15px;
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
                max-width: 1000px;
                margin: 0 auto;
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
                background: linear-gradient(to right, #f57f17, #ffca28);
            }

            h2 {
                text-align: center;
                color: #2c3e50;
                margin-bottom: 30px;
                font-size: 28px;
                font-weight: 600;
                letter-spacing: 1px;
            }

            .employee-avatar {
                text-align: center;
                margin-bottom: 30px;
            }

            .employee-avatar .avatar-icon {
                width: 120px;
                height: 120px;
                background: linear-gradient(135deg, #f57f17, #ffca28);
                border-radius: 50%;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 48px;
                margin-bottom: 15px;
                box-shadow: 0 5px 15px rgba(245, 127, 23, 0.3);
            }

            .employee-name {
                font-size: 24px;
                font-weight: 600;
                color: #2c3e50;
                margin-bottom: 5px;
            }

            .employee-role {
                color: #f57f17;
                font-size: 16px;
                font-weight: 500;
                text-transform: uppercase;
                letter-spacing: 1px;
            }

            .employee-id {
                color: #7f8c8d;
                font-size: 14px;
                margin-top: 5px;
            }

            .detail-card {
                background-color: #fff;
                border-radius: 12px;
                padding: 25px;
                margin-bottom: 20px;
                border-left: 4px solid #f57f17;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }

            .detail-row {
                display: flex;
                align-items: center;
                margin-bottom: 20px;
                padding: 10px 0;
                border-bottom: 1px solid #ecf0f1;
            }

            .detail-row:last-child {
                border-bottom: none;
                margin-bottom: 0;
            }

            .detail-icon {
                flex: 0 0 50px;
                text-align: center;
                margin-right: 20px;
            }

            .detail-icon i {
                color: #f57f17;
                font-size: 20px;
            }

            .detail-content {
                flex: 1;
                display: flex;
                flex-wrap: wrap;
                align-items: center;
            }

            .detail-label {
                font-weight: 600;
                color: #2c3e50;
                min-width: 150px;
                margin-bottom: 5px;
                font-size: 15px;
            }

            .detail-value {
                color: #555;
                font-size: 14px;
                flex: 1;
                padding: 8px 12px;
                background: #fff8e1;
                border-radius: 6px;
                border: 1px solid #ffecb3;
            }

            .role-badge {
                display: inline-block;
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 500;
                text-transform: uppercase;
            }

            .role-doctor {
                background: #e8f5e8;
                color: #2e7d32;
                border: 1px solid #c8e6c9;
            }

            .role-nurse {
                background: #e3f2fd;
                color: #1565c0;
                border: 1px solid #bbdefb;
            }

            .role-staff {
                background: #fff3e0;
                color: #ef6c00;
                border: 1px solid #ffcc02;
            }

            .status-badge {
                display: inline-block;
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 500;
                text-transform: uppercase;
            }

            .status-active {
                background: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }

            .status-inactive {
                background: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }

            .specialization-badge {
                display: inline-block;
                background: linear-gradient(135deg, #f57f17, #ffca28);
                color: white;
                padding: 8px 15px;
                border-radius: 20px;
                font-size: 13px;
                font-weight: 500;
                box-shadow: 0 2px 5px rgba(245, 127, 23, 0.2);
            }

            .btn-primary {
                background: linear-gradient(to right, #f57f17, #ffca28);
                border: none;
                padding: 12px 30px;
                border-radius: 8px;
                font-weight: 500;
                text-transform: uppercase;
                letter-spacing: 1px;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-block;
                color: white;
            }

            .btn-primary:hover {
                background: linear-gradient(to right, #e65100, #ffb300);
                box-shadow: 0 5px 15px rgba(245, 127, 23, 0.3);
                color: white;
                text-decoration: none;
            }

            .alert {
                border-radius: 10px;
                border: none;
                padding: 20px;
                font-size: 16px;
            }

            .alert-danger {
                background: linear-gradient(135deg, #ffebee, #ffcdd2);
                color: #c62828;
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
                color: #ffca28;
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
                color: #ffca28;
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
                background: #ffca28;
                color: white;
                text-align: center;
                line-height: 40px;
                border-radius: 50%;
                transition: all 0.3s ease;
            }

            .footer-section .social-links a:hover {
                background: #f57f17;
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
                    margin: 20px;
                    padding: 20px;
                }

                .detail-content {
                    flex-direction: column;
                    align-items: flex-start;
                }

                .detail-label {
                    min-width: auto;
                    width: 100%;
                }

                .detail-value {
                    width: 100%;
                    margin-top: 5px;
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

                    <a href="${pageContext.request.contextPath}/ViewEmployeeServlet">
                        <i class="fas fa-user-md"></i> Nhân viên
                    </a>

                </nav>
            </div>
        </header>

        <!-- Main Content -->
        <main class="main-content">
            <div class="container">
                <h2>Chi tiết Nhân Viên</h2>
                
                <c:choose>
                    <c:when test="${not empty requestScope.user}">
                        <!-- Employee Avatar Section -->
                        <div class="employee-avatar">
                            <div class="avatar-icon">
                                <c:choose>
                                    <c:when test="${requestScope.user.role == 'doctor'}">
                                        <i class="fas fa-user-md"></i>
                                    </c:when>
                                    <c:when test="${requestScope.user.role == 'nurse'}">
                                        <i class="fas fa-user-nurse"></i>
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fas fa-user-tie"></i>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="employee-name">${requestScope.user.fullName}</div>
                            <div class="employee-role">${requestScope.user.role}</div>
                            <div class="employee-id">ID: ${requestScope.user.userID}</div>
                        </div>

                        <!-- Employee Details -->
                        <div class="detail-card">
                            <div class="detail-row">
                                <div class="detail-icon">
                                    <i class="fas fa-id-badge"></i>
                                </div>
                                <div class="detail-content">
                                    <div class="detail-label">ID:</div>
                                    <div class="detail-value">${requestScope.user.userID}</div>
                                </div>
                            </div>

                            <div class="detail-row">
                                <div class="detail-icon">
                                    <i class="fas fa-user"></i>
                                </div>
                                <div class="detail-content">
                                    <div class="detail-label">Tên đầy đủ:</div>
                                    <div class="detail-value">${requestScope.user.fullName}</div>
                                </div>
                            </div>

                            <div class="detail-row">
                                <div class="detail-icon">
                                    <i class="fas fa-user-circle"></i>
                                </div>
                                <div class="detail-content">
                                    <div class="detail-label">Tên đăng nhập:</div>
                                    <div class="detail-value">${requestScope.user.username}</div>
                                </div>
                            </div>

                            <div class="detail-row">
                                <div class="detail-icon">
                                    <i class="fas fa-envelope"></i>
                                </div>
                                <div class="detail-content">
                                    <div class="detail-label">Email:</div>
                                    <div class="detail-value">${requestScope.user.email}</div>
                                </div>
                            </div>

                            <div class="detail-row">
                                <div class="detail-icon">
                                    <i class="fas fa-venus-mars"></i>
                                </div>
                                <div class="detail-content">
                                    <div class="detail-label">Giới tính:</div>
                                    <div class="detail-value">${requestScope.user.gender}</div>
                                </div>
                            </div>

                            <div class="detail-row">
                                <div class="detail-icon">
                                    <i class="fas fa-stethoscope"></i>
                                </div>
                                <div class="detail-content">
                                    <div class="detail-label">Chuyên khoa:</div>
                                    <div class="detail-value">
                                        <span class="specialization-badge">${requestScope.user.specialization}</span>
                                    </div>
                                </div>
                            </div>

                            <div class="detail-row">
                                <div class="detail-icon">
                                    <i class="fas fa-birthday-cake"></i>
                                </div>
                                <div class="detail-content">
                                    <div class="detail-label">Ngày sinh:</div>
                                    <div class="detail-value">
                                        <fmt:formatDate value="${requestScope.user.dob}" pattern="dd/MM/yyyy" />
                                    </div>
                                </div>
                            </div>

                            <div class="detail-row">
                                <div class="detail-icon">
                                    <i class="fas fa-phone"></i>
                                </div>
                                <div class="detail-content">
                                    <div class="detail-label">Số điện thoại:</div>
                                    <div class="detail-value">${requestScope.user.phone}</div>
                                </div>
                            </div>

                            <div class="detail-row">
                                <div class="detail-icon">
                                    <i class="fas fa-map-marker-alt"></i>
                                </div>
                                <div class="detail-content">
                                    <div class="detail-label">Địa chỉ:</div>
                                    <div class="detail-value">${requestScope.user.address}</div>
                                </div>
                            </div>

                            <div class="detail-row">
                                <div class="detail-icon">
                                    <i class="fas fa-user-tag"></i>
                                </div>
                                <div class="detail-content">
                                    <div class="detail-label">Vai trò:</div>
                                    <div class="detail-value">
                                        <span class="role-badge ${requestScope.user.role == 'doctor' ? 'role-doctor' : (requestScope.user.role == 'nurse' ? 'role-nurse' : 'role-staff')}">
                                            ${requestScope.user.role}
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <div class="detail-row">
                                <div class="detail-icon">
                                    <i class="fas fa-toggle-on"></i>
                                </div>
                                <div class="detail-content">
                                    <div class="detail-label">Trạng thái:</div>
                                    <div class="detail-value">
                                        <span class="status-badge ${requestScope.user.status == 'active' ? 'status-active' : 'status-inactive'}">
                                            ${requestScope.user.status}
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <div class="detail-row">
                                <div class="detail-icon">
                                    <i class="fas fa-calendar-plus"></i>
                                </div>
                                <div class="detail-content">
                                    <div class="detail-label">Ngày tạo:</div>
                                    <div class="detail-value">
                                        <fmt:formatDate value="${requestScope.user.createdAt}" pattern="dd/MM/yyyy HH:mm:ss" />
                                    </div>
                                </div>
                            </div>

                            <div class="detail-row">
                                <div class="detail-icon">
                                    <i class="fas fa-calendar-check"></i>
                                </div>
                                <div class="detail-content">
                                    <div class="detail-label">Ngày cập nhật:</div>
                                    <div class="detail-value">
                                        <fmt:formatDate value="${requestScope.user.updatedAt}" pattern="dd/MM/yyyy HH:mm:ss" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-danger text-center" role="alert">
                            <i class="fas fa-exclamation-triangle"></i>
                            Không tìm thấy thông tin bác sĩ/y tá!
                        </div>
                    </c:otherwise>
                </c:choose>

                <div class="text-center">
                    <a href="${pageContext.request.contextPath}/ViewEmployeeServlet" class="btn btn-primary">
                        <i class="fas fa-arrow-left"></i> Quay lại danh sách
                    </a>
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
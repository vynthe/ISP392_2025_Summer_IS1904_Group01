<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách bác sĩ - Phòng khám PDC</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 50%, #f8fafc 100%);
            color: #334155;
            line-height: 1.6;
            min-height: 100vh;
        }

        /* Header */
        .main-header {
            background: linear-gradient(135deg, #2c3e50 0%, #3498db 100%);
            color: white;
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .header-top {
            background: rgba(0,0,0,0.1);
            padding: 10px 0;
            font-size: 14px;
        }

        .header-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header-contact {
            display: flex;
            gap: 25px;
        }

        .header-contact span {
            display: flex;
            align-items: center;
            gap: 6px;
            opacity: 0.9;
            transition: opacity 0.3s;
        }

        .header-contact span:hover {
            opacity: 1;
        }

        .header-user {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 8px;
            background: rgba(255,255,255,0.1);
            padding: 6px 12px;
            border-radius: 20px;
            transition: background 0.3s;
        }

        .user-info:hover {
            background: rgba(255,255,255,0.2);
        }

        .header-main {
            padding: 20px 0;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 24px;
            font-weight: bold;
            text-decoration: none;
            color: white;
        }

        .logo i {
            font-size: 32px;
            color: #ecf0f1;
        }

        .main-nav {
            display: flex;
            list-style: none;
            gap: 5px;
        }

        .main-nav a {
            color: white;
            text-decoration: none;
            padding: 12px 18px;
            border-radius: 8px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 500;
        }

        .main-nav a:hover {
            background: rgba(255,255,255,0.15);
            transform: translateY(-2px);
        }

        .main-nav a.active {
            background: #e74c3c;
            box-shadow: 0 4px 15px rgba(231, 76, 60, 0.3);
        }

        /* Main Content */
        .main {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem 1rem;
        }

        .page-title {
            text-align: center;
            margin-bottom: 2rem;
        }

        .page-title h1 {
            font-size: 2rem;
            color: #111827;
            margin-bottom: 0.5rem;
        }

        .page-title p {
            color: #6b7280;
            font-size: 1.1rem;
        }

        /* Messages */
        .message {
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .message.success {
            background: #dcfce7;
            color: #166534;
            border: 1px solid #bbf7d0;
        }

        .message.error {
            background: #fef2f2;
            color: #dc2626;
            border: 1px solid #fecaca;
        }

        /* Stats */
        .stats {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            padding: 1.5rem;
            text-align: center;
            margin-bottom: 2rem;
        }

        .stats-number {
            font-size: 2.5rem;
            font-weight: 700;
            color: #2563eb;
            margin-bottom: 0.5rem;
        }

        /* Search */
        .search-container {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }

        .search-box {
            position: relative;
            max-width: 400px;
            margin: 0 auto;
        }

        .search-input {
            width: 100%;
            padding: 0.75rem 1rem 0.75rem 2.5rem;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 1rem;
            outline: none;
            transition: border-color 0.2s;
        }

        .search-input:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .search-icon {
            position: absolute;
            left: 0.75rem;
            top: 50%;
            transform: translateY(-50%);
            color: #9ca3af;
        }

        /* Doctor Grid */
        .doctors-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1.5rem;
        }

        .doctor-card {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            padding: 1.5rem;
            transition: box-shadow 0.2s;
        }

        .doctor-card:hover {
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .doctor-name {
            font-size: 1.25rem;
            font-weight: 600;
            color: #111827;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .specialization {
            background: #dbeafe;
            color: #1e40af;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.875rem;
            font-weight: 500;
            display: inline-block;
            margin-bottom: 1rem;
        }

        .doctor-info {
            color: #6b7280;
            font-size: 0.9rem;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .doctor-info i {
            width: 16px;
            color: #9ca3af;
        }

        .book-btn {
            background: #2563eb;
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            margin-top: 1rem;
            transition: background 0.2s;
        }

        .book-btn:hover {
            background: #1d4ed8;
        }

        /* No Data */
        .no-data {
            text-align: center;
            padding: 3rem 2rem;
            color: #6b7280;
        }

        .no-data i {
            font-size: 3rem;
            color: #d1d5db;
            margin-bottom: 1rem;
        }

        .no-data h3 {
            font-size: 1.25rem;
            color: #374151;
            margin-bottom: 0.5rem;
        }

        /* Footer */
        .main-footer {
            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
            color: white;
            margin-top: auto;
            width: 100vw;
            position: relative;
            left: 50%;
            right: 50%;
            margin-left: -50vw;
            margin-right: -50vw;
        }

        .footer-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 50px 20px 20px;
        }

        .footer-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 40px;
            margin-bottom: 40px;
        }

        .footer-section h4 {
            color: #3498db;
            margin-bottom: 20px;
            font-size: 18px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
        }

        .footer-section ul {
            list-style: none;
        }

        .footer-section ul li {
            margin-bottom: 10px;
        }

        .footer-section ul li a {
            color: #bdc3c7;
            text-decoration: none;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 5px 0;
        }

        .footer-section ul li a:hover {
            color: #3498db;
            padding-left: 10px;
        }

        .footer-section p {
            color: #bdc3c7;
            line-height: 1.7;
            margin-bottom: 12px;
        }

        .social-links {
            display: flex;
            gap: 15px;
            margin-top: 20px;
        }

        .social-links a {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 45px;
            height: 45px;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
            color: white;
            font-size: 18px;
            transition: all 0.3s;
            text-decoration: none;
        }

        .social-links a:hover {
            background: #3498db;
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(52, 152, 219, 0.3);
        }

        .footer-bottom {
            border-top: 1px solid rgba(255,255,255,0.1);
            padding-top: 25px;
            text-align: center;
            color: #95a5a6;
        }

        .footer-bottom p {
            margin: 8px 0;
        }

        html, body {
            overflow-x: hidden;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .header-container {
                flex-direction: column;
                gap: 20px;
                padding: 0 15px;
            }

            .main-nav {
                flex-wrap: wrap;
                justify-content: center;
                gap: 8px;
            }

            .main-nav a {
                padding: 10px 14px;
                font-size: 14px;
            }

            .main {
                padding: 1rem;
            }

            .page-title h1 {
                font-size: 1.5rem;
            }

            .doctors-grid {
                grid-template-columns: 1fr;
            }

            .footer-grid {
                grid-template-columns: 1fr;
                gap: 30px;
            }

            .social-links {
                justify-content: center;
            }
        }

        @media (max-width: 480px) {
            .logo {
                font-size: 20px;
            }

            .logo i {
                font-size: 28px;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="main-header">

        <div class="header-main">
            <div class="header-container">
                <a href="${pageContext.request.contextPath}/" class="logo">
                    <i class="fas fa-hospital"></i>
                    <span>Phòng Khám PDC</span>
                </a>
                <nav>
                    <ul class="main-nav">
                        <li><a href="${pageContext.request.contextPath}/views/user/Patient/PatientDashBoard.jsp"><i class="fas fa-home"></i> Trang chủ</a></li>
                        <li><a href="${pageContext.request.contextPath}/ViewMedicalAppointmentServlet" class="active"><i class="fas fa-user-md"></i> Chọn Bác Sĩ</a></li>
                    </ul>
                </nav>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="main">
        <!-- Page Title -->
        <div class="page-title">
            <h1>Danh sách bác sĩ</h1>
            <p>Tìm và đặt lịch hẹn với các bác sĩ chuyên khoa</p>
        </div>

        <!-- Messages -->
        <c:if test="${not empty success}">
            <div class="message success">
                <i class="fas fa-check-circle"></i>
                ${success}
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="message error">
                <i class="fas fa-exclamation-triangle"></i>
                ${error}
            </div>
        </c:if>

        <!-- Search -->
        <div class="search-container">
            <div class="search-box">
                <input type="text" class="search-input" id="searchInput" 
                       placeholder="Tìm kiếm theo tên bác sĩ hoặc chuyên khoa...">
                <i class="fas fa-search search-icon"></i>
            </div>
        </div>

        <!-- Doctor List -->
        <c:choose>
            <c:when test="${not empty doctors}">
                <div class="doctors-grid" id="doctorsGrid">
                    <c:forEach var="doctor" items="${doctors}">
                        <div class="doctor-card" data-name="${doctor.fullName}" data-specialization="${doctor.specialization}">
                            <div class="doctor-name">
                                <i class="fas fa-user-md"></i>
                                ${doctor.fullName}
                            </div>
                            
                            <span class="specialization">${doctor.specialization}</span>
                            
                            <div class="doctor-info">
                                <i class="fas fa-id-card"></i>
                                <span>Mã BS: ${doctor.userID}</span>
                            </div>
                            
                            <div class="doctor-info">
                                <i class="fas fa-envelope"></i>
                                <span>${doctor.email}</span>
                            </div>
                            
                            <div class="doctor-info">
                                <i class="fas fa-phone"></i>
                                <span>${doctor.phone}</span>
                            </div>
                            
                            <a href="${pageContext.request.contextPath}/ViewDetailBookServlet?doctorId=${doctor.userID}" class="book-btn">
                                <i class="fas fa-calendar-plus"></i>
                                Đặt lịch hẹn
                            </a>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="no-data">
                    <i class="fas fa-user-md"></i>
                    <h3>Không có bác sĩ nào</h3>
                    <p>Hiện tại chưa có bác sĩ nào trong hệ thống</p>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

    <!-- Footer -->
    <footer class="main-footer">
        <div class="footer-content">
            <div class="footer-grid">
                <div class="footer-section">
                    <h4><i class="fas fa-hospital"></i> Về Chúng Tôi</h4>
                    <p>Chúng tôi là phòng khám nha khoa hàng đầu, cam kết mang lại nụ cười khỏe mạnh và tự tin với công nghệ tiên tiến và đội ngũ chuyên gia giàu kinh nghiệm.</p>
                </div>

                <div class="footer-section">
                    <h4><i class="fas fa-link"></i> Liên Kết Nhanh</h4>
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/"><i class="fas fa-home"></i> Trang chủ</a></li>
                        <li><a href="${pageContext.request.contextPath}/ViewMedicalAppointmentServlet"><i class="fas fa-user-md"></i> Chọn Bác sĩ</a></li>
                        <li><a href="${pageContext.request.contextPath}/ViewDetailBookServlet"><i class="fas fa-calendar-alt"></i> Đặt lịch Khám</a></li>
                    </ul>
                </div>

                <div class="footer-section">
                    <h4><i class="fas fa-map-marker-alt"></i> Liên Hệ</h4>
                    <p><i class="fas fa-map-marker-alt"></i> ĐH FPT, HOA LAC</p>
                    <p><i class="fas fa-phone"></i> (098) 123 4567</p>
                    <p><i class="fas fa-envelope"></i> PhongKhamPDC@gmail.com</p>
                </div>
            </div>

            <div class="footer-bottom">
                <p>© 2025 Nha Khoa PDC. Đạt chuẩn Bộ Y tế. Tất cả quyền được bảo lưu.</p>
            </div>
        </div>
    </footer>

    <script>
        // Search functionality
        document.getElementById('searchInput').addEventListener('input', function(e) {
            const searchTerm = e.target.value.toLowerCase();
            const doctorCards = document.querySelectorAll('.doctor-card');
            
            doctorCards.forEach(card => {
                const name = card.getAttribute('data-name').toLowerCase();
                const specialization = card.getAttribute('data-specialization').toLowerCase();
                
                if (name.includes(searchTerm) || specialization.includes(searchTerm)) {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });
        });
    </script>
</body>
</html>
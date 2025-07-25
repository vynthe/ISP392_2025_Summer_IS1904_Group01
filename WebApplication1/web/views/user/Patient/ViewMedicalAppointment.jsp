<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách bác sĩ - Phòng khám PDC</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 50%, #f8fafc 100%);
            color: #333;
            line-height: 1.6;
            min-height: 100vh;
        }

        /* Header */
        .header {
            background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);
            border-bottom: 1px solid #e1e8ed;
            padding: 1rem 0;
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: 0 2px 10px rgba(59, 130, 246, 0.08);
        }

        .header-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 1rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.25rem;
            font-weight: 600;
            color: #2563eb;
            text-decoration: none;
        }

        .nav {
            display: flex;
            gap: 2rem;
            align-items: center;
        }

        .nav-link {
            color: #6b7280;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s;
        }

        .nav-link:hover {
            color: #2563eb;
        }

        .btn-primary {
            background: #2563eb;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 500;
            transition: background 0.2s;
        }

        .btn-primary:hover {
            background: #1d4ed8;
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
        .footer {
            background: #111827;
            color: #9ca3af;
            padding: 3rem 1rem 1rem;
            margin-top: 4rem;
        }

        .footer-container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .footer-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
            margin-bottom: 2rem;
        }

        .footer-section h3 {
            color: white;
            font-size: 1.125rem;
            font-weight: 600;
            margin-bottom: 1rem;
        }

        .footer-section p, .footer-section li {
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .footer-section a {
            color: #9ca3af;
            text-decoration: none;
            transition: color 0.2s;
        }

        .footer-section a:hover {
            color: #2563eb;
        }

        .footer-bottom {
            border-top: 1px solid #374151;
            padding-top: 1rem;
            text-align: center;
            font-size: 0.875rem;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .header-container {
                flex-direction: column;
                gap: 1rem;
            }

            .nav {
                gap: 1rem;
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
                gap: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="header-container">
            <a href="#" class="logo">
                <i class="fas fa-tooth"></i>
                Phòng Khám Nha Khoa PDC
            </a>
            <nav class="nav">
                <a href="${pageContext.request.contextPath}/views/common/HomePage.jsp" class="nav-link">Trang chủ</a>
                <a href="/BookAppointmentGuestServlet" class="btn-primary">Đặt lịch khám</a>
            </nav>
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

        <!-- Stats -->
        <c:if test="${not empty doctors}">
            <div class="stats">
                <div class="stats-number">${doctors.size()}</div>
                <p>Bác sĩ có sẵn</p>
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
    <footer class="footer">
        <div class="footer-container">
            <div class="footer-grid">
                <div class="footer-section">
                    <h3>Liên hệ</h3>
                    <p><i class="fas fa-map-marker-alt"></i> DH FPT, Hòa Lạc, Hà Nội</p>
                    <p><i class="fas fa-phone"></i> (098) 123-4567</p>
                    <p><i class="fas fa-envelope"></i> PhongKhamPDC@gmail.com</p>
                </div>

                <div class="footer-section">
                    <h3>Về chúng tôi</h3>
                    <p>Phòng khám nha khoa PDC cam kết mang đến dịch vụ chăm sóc răng miệng chất lượng cao với đội ngũ bác sĩ giàu kinh nghiệm.</p>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2025 Phòng Khám Nha Khoa PDC. Tất cả quyền được bảo lưu.</p>
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
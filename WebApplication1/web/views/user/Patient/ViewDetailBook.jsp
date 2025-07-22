<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chi Tiết Bác Sĩ</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            :root {
                --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                --secondary-gradient: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
                --success-gradient: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
                --warning-gradient: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
                --glass-bg: rgba(255, 255, 255, 0.1);
                --glass-border: rgba(255, 255, 255, 0.2);
                --text-primary: #1a1a2e;
                --text-secondary: #6b7280;
                --shadow-soft: 0 10px 40px rgba(0, 0, 0, 0.1);
                --shadow-medium: 0 20px 60px rgba(0, 0, 0, 0.15);
                --shadow-strong: 0 30px 80px rgba(0, 0, 0, 0.2);
                --border-radius: 20px;
                --transition: all 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
                background: var(--primary-gradient);
                min-height: 100vh;
                color: var(--text-primary);
                line-height: 1.7;
                overflow-x: hidden;
            }

            body::before {
                content: '';
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: 
                    radial-gradient(circle at 20% 80%, rgba(120, 119, 198, 0.3) 0%, transparent 50%),
                    radial-gradient(circle at 80% 20%, rgba(255, 119, 198, 0.3) 0%, transparent 50%),
                    radial-gradient(circle at 40% 40%, rgba(120, 219, 226, 0.2) 0%, transparent 50%);
                z-index: -1;
                animation: backgroundShift 20s ease-in-out infinite;
            }

            @keyframes backgroundShift {
                0%, 100% { transform: scale(1) rotate(0deg); }
                50% { transform: scale(1.1) rotate(0.5deg); }
            }

            /* Enhanced Header */
            .header {
                background: rgba(255, 255, 255, 0.1);
                backdrop-filter: blur(30px);
                box-shadow: 0 8px 40px rgba(0, 0, 0, 0.1);
                border-bottom: 1px solid var(--glass-border);
                position: sticky;
                top: 0;
                z-index: 1000;
                transition: var(--transition);
            }

            .header-container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 1.5rem 2rem;
            }

            .nav-menu {
                display: flex;
                gap: 1rem;
                align-items: center;
                justify-content: center;
            }

            .nav-link {
                text-decoration: none;
                color: rgba(255, 255, 255, 0.9);
                padding: 1rem 2rem;
                border-radius: 50px;
                transition: var(--transition);
                font-weight: 500;
                font-size: 0.95rem;
                display: flex;
                align-items: center;
                gap: 0.7rem;
                background: rgba(255, 255, 255, 0.1);
                border: 1px solid rgba(255, 255, 255, 0.2);
                backdrop-filter: blur(10px);
            }

            .nav-link:hover {
                background: rgba(255, 255, 255, 0.2);
                transform: translateY(-2px);
                box-shadow: var(--shadow-soft);
                color: white;
            }

            .nav-link.active {
                background: rgba(255, 255, 255, 0.25);
                color: white;
                box-shadow: 0 8px 25px rgba(255, 255, 255, 0.2);
                transform: translateY(-1px);
            }

            /* Container */
            .container {
                max-width: 1400px;
                margin: 3rem auto;
                padding: 0 2rem;
            }

            /* Enhanced Alert Messages */
            .alert-container {
                display: flex;
                flex-direction: column;
                gap: 1rem;
                margin-bottom: 2rem;
            }

            .alert {
                padding: 1.5rem 2rem;
                border-radius: var(--border-radius);
                display: flex;
                align-items: center;
                gap: 1rem;
                font-weight: 500;
                box-shadow: var(--shadow-soft);
                animation: slideInDown 0.6s cubic-bezier(0.25, 0.46, 0.45, 0.94);
                position: relative;
                overflow: hidden;
            }

            .alert::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                opacity: 0.1;
                background: linear-gradient(45deg, transparent, rgba(255, 255, 255, 0.5), transparent);
                transform: translateX(-100%);
                animation: shimmer 2s infinite;
            }

            @keyframes shimmer {
                0% { transform: translateX(-100%); }
                100% { transform: translateX(100%); }
            }

            .alert-error {
                background: var(--warning-gradient);
                color: white;
                border: 1px solid rgba(255, 255, 255, 0.3);
            }

            .alert-success {
                background: var(--success-gradient);
                color: white;
                border: 1px solid rgba(255, 255, 255, 0.3);
            }

            .alert-icon {
                font-size: 1.2rem;
                opacity: 0.9;
            }

            /* Enhanced Two-Column Layout */
            .details-section {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 4rem;
                align-items: start;
                margin-top: 2rem;
            }

            .left-column, .right-column {
                display: flex;
                flex-direction: column;
                gap: 2.5rem;
                height: fit-content;
            }

            .left-column {
                position: sticky;
                top: 120px;
            }

            .column-header {
                text-align: center;
                margin-bottom: 1.5rem;
                padding: 1rem;
                background: rgba(255, 255, 255, 0.1);
                border-radius: 15px;
                backdrop-filter: blur(20px);
                border: 1px solid rgba(255, 255, 255, 0.2);
            }

            .column-title {
                color: white;
                font-size: 1.3rem;
                font-weight: 700;
                margin: 0;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 0.8rem;
            }

            .column-subtitle {
                color: rgba(255, 255, 255, 0.7);
                font-size: 0.9rem;
                margin-top: 0.5rem;
                font-weight: 400;
            }

            /* Enhanced Cards */
            .card {
                background: rgba(255, 255, 255, 0.15);
                backdrop-filter: blur(30px);
                padding: 2.5rem;
                border-radius: var(--border-radius);
                box-shadow: var(--shadow-medium);
                border: 1px solid var(--glass-border);
                transition: var(--transition);
                animation: fadeInUp 0.8s cubic-bezier(0.25, 0.46, 0.45, 0.94);
                position: relative;
                overflow: hidden;
            }

            .card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 2px;
                background: var(--primary-gradient);
            }

            .card:hover {
                transform: translateY(-8px);
                box-shadow: var(--shadow-strong);
                background: rgba(255, 255, 255, 0.2);
            }

            .card-header {
                display: flex;
                align-items: center;
                gap: 1rem;
                margin-bottom: 2rem;
                padding-bottom: 1rem;
                border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            }

            .card-title {
                color: white;
                font-size: 1.5rem;
                font-weight: 700;
                margin: 0;
            }

            .card-icon {
                width: 50px;
                height: 50px;
                background: var(--primary-gradient);
                border-radius: 15px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 1.2rem;
                box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
            }

            /* Enhanced Detail Items */
            .detail-item {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 1.2rem 0;
                border-bottom: 1px solid rgba(255, 255, 255, 0.1);
                transition: var(--transition);
            }

            .detail-item:last-child {
                border-bottom: none;
            }

            .detail-item:hover {
                background: rgba(255, 255, 255, 0.1);
                margin: 0 -1.5rem;
                padding: 1.2rem 1.5rem;
                border-radius: 12px;
                transform: translateX(5px);
            }

            .detail-label {
                font-weight: 500;
                color: rgba(255, 255, 255, 0.8);
                flex: 1;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .detail-value {
                font-weight: 600;
                color: white;
                flex: 2;
                text-align: right;
                font-size: 1.05rem;
            }

            /* Enhanced Services List */
            .services-list {
                list-style: none;
                display: flex;
                flex-direction: column;
                gap: 1rem;
            }

            .service-item {
                background: rgba(255, 255, 255, 0.1);
                padding: 1.5rem;
                border-radius: 15px;
                border: 1px solid rgba(255, 255, 255, 0.2);
                display: flex;
                justify-content: space-between;
                align-items: center;
                transition: var(--transition);
                position: relative;
                overflow: hidden;
            }

            .service-item::before {
                content: '';
                position: absolute;
                left: 0;
                top: 0;
                width: 4px;
                height: 100%;
                background: var(--success-gradient);
            }

            .service-item:hover {
                background: rgba(255, 255, 255, 0.15);
                transform: translateX(8px);
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
            }

            .service-name {
                color: white;
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 0.8rem;
            }

            .service-price {
                color: rgba(255, 255, 255, 0.9);
                font-weight: 600;
                background: rgba(255, 255, 255, 0.1);
                padding: 0.5rem 1rem;
                border-radius: 20px;
                font-size: 0.9rem;
            }

            /* Enhanced Schedule */
            .schedule-list {
                list-style: none;
                display: flex;
                flex-direction: column;
                gap: 1.5rem;
            }

            .schedule-item {
                background: rgba(255, 255, 255, 0.1);
                padding: 2rem;
                border-radius: var(--border-radius);
                border: 1px solid rgba(255, 255, 255, 0.2);
                display: flex;
                justify-content: space-between;
                align-items: center;
                transition: var(--transition);
                position: relative;
            }

            .schedule-item:hover {
                transform: translateY(-3px);
                box-shadow: var(--shadow-medium);
                background: rgba(255, 255, 255, 0.15);
            }

            .schedule-info {
                flex: 1;
                color: white;
            }

            .schedule-date {
                font-size: 1.1rem;
                font-weight: 600;
                margin-bottom: 0.5rem;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .schedule-time {
                color: rgba(255, 255, 255, 0.8);
                font-size: 0.95rem;
                display: flex;
                align-items: center;
                gap: 0.5rem;
                margin-bottom: 0.8rem;
            }

            /* Status Badges */
            .status-badge {
                display: inline-block;
                padding: 0.5rem 1rem;
                border-radius: 20px;
                font-size: 0.8rem;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .status-available {
                background: var(--success-gradient);
                color: white;
                box-shadow: 0 4px 15px rgba(79, 172, 254, 0.3);
            }

            .status-unavailable {
                background: var(--warning-gradient);
                color: white;
                box-shadow: 0 4px 15px rgba(250, 112, 154, 0.3);
            }

            /* Enhanced Booking Button */
            .book-btn {
                background: var(--success-gradient);
                color: white;
                border: none;
                padding: 1rem 2rem;
                border-radius: 25px;
                cursor: pointer;
                font-weight: 600;
                font-size: 0.95rem;
                display: flex;
                align-items: center;
                gap: 0.8rem;
                transition: var(--transition);
                box-shadow: 0 8px 25px rgba(79, 172, 254, 0.4);
                position: relative;
                overflow: hidden;
            }

            .book-btn::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
                transition: var(--transition);
            }

            .book-btn:hover::before {
                left: 100%;
            }

            .book-btn:hover {
                transform: translateY(-3px);
                box-shadow: 0 12px 35px rgba(79, 172, 254, 0.5);
            }

            .book-btn:active {
                transform: translateY(-1px);
            }

            /* Back Button */
            .back-button-container {
                grid-column: 1 / -1;
                text-align: center;
                margin-top: 3rem;
            }

            .back-button {
                display: inline-flex;
                align-items: center;
                gap: 0.8rem;
                background: rgba(255, 255, 255, 0.15);
                color: white;
                text-decoration: none;
                padding: 1.2rem 2.5rem;
                border-radius: 50px;
                font-weight: 600;
                transition: var(--transition);
                box-shadow: var(--shadow-soft);
                border: 1px solid rgba(255, 255, 255, 0.2);
                backdrop-filter: blur(10px);
            }

            .back-button:hover {
                transform: translateY(-3px);
                box-shadow: var(--shadow-medium);
                background: rgba(255, 255, 255, 0.2);
            }

            /* Enhanced Footer */
            .footer {
                background: rgba(0, 0, 0, 0.1);
                backdrop-filter: blur(30px);
                margin-top: 6rem;
                border-top: 1px solid rgba(255, 255, 255, 0.1);
            }

            .footer-container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 4rem 2rem 2rem;
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                gap: 3rem;
            }

            .footer-section h4 {
                color: white;
                margin-bottom: 1.5rem;
                font-weight: 700;
                font-size: 1.2rem;
                display: flex;
                align-items: center;
                gap: 0.8rem;
            }

            .footer-section p,
            .footer-section ul {
                color: rgba(255, 255, 255, 0.8);
                line-height: 1.8;
            }

            .footer-section ul {
                list-style: none;
            }

            .footer-section ul li {
                margin-bottom: 0.8rem;
                display: flex;
                align-items: center;
                gap: 0.8rem;
                transition: var(--transition);
            }

            .footer-section ul li:hover {
                transform: translateX(5px);
                color: white;
            }

            .footer-section ul li a {
                color: rgba(255, 255, 255, 0.8);
                text-decoration: none;
                transition: var(--transition);
            }

            .footer-section ul li a:hover {
                color: white;
            }

            /* Animations */
            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(40px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            @keyframes slideInDown {
                from {
                    opacity: 0;
                    transform: translateY(-40px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Loading Animation */
            .loading {
                display: inline-block;
                width: 24px;
                height: 24px;
                border: 3px solid rgba(255, 255, 255, 0.3);
                border-radius: 50%;
                border-top-color: #fff;
                animation: spin 1s ease-in-out infinite;
            }

            @keyframes spin {
                to { transform: rotate(360deg); }
            }

            /* Responsive Design */
            @media (max-width: 1024px) {
                .details-section {
                    grid-template-columns: 1fr;
                    gap: 2rem;
                }

                .container {
                    padding: 0 1.5rem;
                }

                .card {
                    padding: 2rem;
                }
            }

            @media (max-width: 768px) {
                .header-container {
                    padding: 1rem;
                }

                .nav-menu {
                    flex-direction: column;
                    gap: 0.8rem;
                    padding: 1rem 0;
                }

                .nav-link {
                    padding: 0.8rem 1.5rem;
                    font-size: 0.9rem;
                }

                .container {
                    margin: 2rem auto;
                    padding: 0 1rem;
                }

                .card {
                    padding: 1.5rem;
                }

                .card-title {
                    font-size: 1.3rem;
                }

                .detail-item {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 0.8rem;
                    padding: 1rem 0;
                }

                .detail-value {
                    text-align: left;
                }

                .schedule-item {
                    flex-direction: column;
                    gap: 1.5rem;
                    text-align: center;
                    padding: 1.5rem;
                }

                .footer-container {
                    grid-template-columns: 1fr;
                    text-align: center;
                    padding: 3rem 1rem 2rem;
                }

                .service-item {
                    flex-direction: column;
                    gap: 1rem;
                    text-align: center;
                }
            }

            @media (max-width: 480px) {
                .card {
                    padding: 1.2rem;
                }

                .book-btn {
                    width: 100%;
                    justify-content: center;
                    padding: 1rem;
                }

                .back-button {
                    padding: 1rem 2rem;
                    font-size: 0.9rem;
                }
            }
        </style>
    </head>
    <body>
        <header class="header">
            <div class="header-container">
                <nav class="nav-menu">
                    <a href="${pageContext.request.contextPath}/views/user/Patient/PatientDashBoard.jsp" class="nav-link">
                        <i class="fas fa-home"></i> Trang Chủ
                    </a>
                    <a href="${pageContext.request.contextPath}/BookMedicalAppointmentServlet" class="nav-link active">
                        <i class="fas fa-calendar-check"></i> Đặt Lịch Khám
                    </a>
                </nav>
            </div>
        </header>

        <div class="container">
            <!-- Alert Messages -->
            <div class="alert-container">
                <c:if test="${not empty error}">
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-triangle alert-icon"></i>
                        <span>${fn:escapeXml(error)}</span>
                    </div>
                </c:if>
                <c:if test="${not empty success}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle alert-icon"></i>
                        <span>${fn:escapeXml(success)}</span>
                    </div>
                </c:if>
                <c:if test="${empty patientId}">
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-triangle alert-icon"></i>
                        <span>Lỗi: Không tìm thấy ID bệnh nhân. Vui lòng đăng nhập lại.</span>
                    </div>
                </c:if>
            </div>

            <div class="details-section">
                <c:choose>
                    <c:when test="${empty doctorDetails}">
                        <div class="alert alert-error" style="grid-column: 1 / -1;">
                            <i class="fas fa-user-md-slash alert-icon"></i>
                            <span>Không tìm thấy thông tin bác sĩ.</span>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Left Column - Doctor Info & Services -->
                        <div class="left-column">
                            <div class="column-header">
                                <h3 class="column-title">
                                    <i class="fas fa-user-md"></i>
                                    Thông Tin Bác Sĩ
                                </h3>
                                <p class="column-subtitle">Chi tiết về bác sĩ và dịch vụ khám</p>
                            </div>

                            <!-- Doctor Basic Info Card -->
                            <div class="card">
                                <div class="card-header">
                                    <div class="card-icon">
                                        <i class="fas fa-id-card"></i>
                                    </div>
                                    <h2 class="card-title">Hồ Sơ Bác Sĩ</h2>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">
                                        <i class="fas fa-user"></i> Họ và Tên
                                    </span>
                                    <span class="detail-value">${fn:escapeXml(doctorDetails.doctorName)}</span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">
                                        <i class="fas fa-stethoscope"></i> Chuyên Khoa
                                    </span>
                                    <span class="detail-value">${fn:escapeXml(doctorDetails.specialization)}</span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">
                                        <i class="fas fa-door-open"></i> Phòng Khám
                                    </span>
                                    <span class="detail-value">${fn:escapeXml(doctorDetails.roomName)}</span>
                                </div>
                            </div>

                            <!-- Services Card -->
                            <div class="card">
                                <div class="card-header">
                                    <div class="card-icon">
                                        <i class="fas fa-concierge-bell"></i>
                                    </div>
                                    <h2 class="card-title">Dịch Vụ Khám Bệnh</h2>
                                </div>
                                <ul class="services-list">
                                    <c:choose>
                                        <c:when test="${not empty doctorDetails.services and fn:length(doctorDetails.services) > 0 and doctorDetails.services[0].serviceName != 'N/A'}">
                                            <c:forEach var="service" items="${doctorDetails.services}">
                                                <li class="service-item">
                                                    <div class="service-name">
                                                        <i class="fas fa-medical-kit"></i>
                                                        ${fn:escapeXml(service.serviceName)}
                                                    </div>
                                                    <div class="service-price">
                                                        <i class="fas fa-money-bill-wave"></i>
                                                        <fmt:formatNumber value="${service.price}" pattern="#,##0"/> VND
                                                    </div>
                                                </li>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <li class="service-item">
                                                <div class="service-name">
                                                    <i class="fas fa-info-circle"></i>
                                                    Đang cập nhật thông tin dịch vụ
                                                </div>
                                            </li>
                                        </c:otherwise>
                                    </c:choose>
                                </ul>
                            </div>
                        </div>

                        <!-- Right Column - Schedule & Booking -->
                        <div class="right-column">
                            <div class="column-header">
                                <h3 class="column-title">
                                    <i class="fas fa-calendar-check"></i>
                                    Đặt Lịch Khám
                                </h3>
                                <p class="column-subtitle">Chọn thời gian phù hợp để đặt lịch</p>
                            </div>

                            <!-- Schedule Card -->
                            <div class="card">
                                <div class="card-header">
                                    <div class="card-icon">
                                        <i class="fas fa-calendar-alt"></i>
                                    </div>
                                    <h2 class="card-title">Lịch Khám Có Sẵn</h2>
                                </div>
                                <ul class="schedule-list">
                                    <jsp:useBean id="now" class="java.util.Date" />
                                    <c:choose>
                                        <c:when test="${not empty doctorDetails.schedules and fn:length(doctorDetails.schedules) > 0}">
                                            <c:set var="hasAvailableSlots" value="false" />
                                            <c:forEach var="schedule" items="${doctorDetails.schedules}">
                                                <fmt:parseDate value="${schedule.slotDate}" pattern="yyyy-MM-dd" var="scheduleDateObj" />
                                                <c:if test="${schedule.status == 'Available' and scheduleDateObj >= now}">
                                                    <c:set var="hasAvailableSlots" value="true" />
                                                </c:if>
                                                <li class="schedule-item">
                                                    <div class="schedule-info">
                                                        <fmt:parseDate value="${schedule.slotDate}" pattern="yyyy-MM-dd" var="parsedDate" />
                                                        <fmt:formatDate value="${parsedDate}" pattern="EEEE, dd/MM/yyyy" var="formattedDate" />
                                                        <div class="schedule-date">
                                                            <i class="fas fa-calendar-day"></i>
                                                            ${fn:escapeXml(formattedDate)}
                                                        </div>
                                                        <div class="schedule-time">
                                                            <i class="fas fa-clock"></i>
                                                            ${fn:escapeXml(schedule.startTime)} - ${fn:escapeXml(schedule.endTime)}
                                                        </div>
                                                        <c:choose>
                                                            <c:when test="${schedule.status == 'Available'}">
                                                                <c:choose>
                                                                    <c:when test="${scheduleDateObj >= now}">
                                                                        <span class="status-badge status-available">
                                                                            <i class="fas fa-check"></i> Có thể đặt
                                                                        </span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="status-badge status-unavailable">
                                                                            <i class="fas fa-clock"></i> Đã qua
                                                                        </span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="status-badge status-unavailable">
                                                                    <i class="fas fa-times"></i> ${fn:escapeXml(schedule.status)}
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <c:if test="${schedule.status == 'Available' and not empty schedule.slotDate and not empty schedule.startTime and scheduleDateObj >= now}">
                                                        <form action="${pageContext.request.contextPath}/BookAppointmentServlet" method="post">
                                                            <input type="hidden" name="doctorId" value="${fn:escapeXml(param.doctorId)}">
                                                            <input type="hidden" name="slotId" value="${fn:escapeXml(schedule.slotId)}">
                                                            <input type="hidden" name="roomId" value="${fn:escapeXml(doctorDetails.roomId)}">
                                                            <input type="hidden" name="patientId" value="${fn:escapeXml(patientId)}">
                                                            <button type="submit" class="book-btn" onclick="return checkFormValues(this.form);">
                                                                <i class="fas fa-calendar-check"></i>
                                                                Đặt Lịch Ngay
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                </li>
                                            </c:forEach>
                                            
                                            <c:if test="${not hasAvailableSlots}">
                                                <li class="schedule-item" style="opacity: 0.7;">
                                                    <div class="schedule-info" style="text-align: center;">
                                                        <i class="fas fa-calendar-times" style="font-size: 2rem; margin-bottom: 1rem; opacity: 0.5;"></i>
                                                        <div class="schedule-date">Hiện tại không có lịch trống</div>
                                                        <div class="schedule-time">Vui lòng quay lại sau hoặc liên hệ trực tiếp</div>
                                                    </div>
                                                </li>
                                            </c:if>
                                        </c:when>
                                        <c:otherwise>
                                            <li class="schedule-item">
                                                <div class="schedule-info" style="text-align: center;">
                                                    <i class="fas fa-calendar-times" style="font-size: 2rem; margin-bottom: 1rem; opacity: 0.5;"></i>
                                                    <div class="schedule-date">Chưa có lịch làm việc</div>
                                                    <div class="schedule-time">Bác sĩ chưa thiết lập lịch khám</div>
                                                </div>
                                            </li>
                                        </c:otherwise>
                                    </c:choose>
                                </ul>
                            </div>

                            <!-- Quick Actions Card -->
                            <div class="card">
                                <div class="card-header">
                                    <div class="card-icon">
                                        <i class="fas fa-tools"></i>
                                    </div>
                                    <h2 class="card-title">Hỗ Trợ Nhanh</h2>
                                </div>
                                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                                    <a href="tel:+84981234567" style="
                                        display: flex;
                                        align-items: center;
                                        gap: 0.5rem;
                                        padding: 1rem;
                                        background: rgba(255, 255, 255, 0.1);
                                        color: white;
                                        text-decoration: none;
                                        border-radius: 12px;
                                        transition: var(--transition);
                                        border: 1px solid rgba(255, 255, 255, 0.2);
                                    " onmouseover="this.style.background='rgba(255, 255, 255, 0.2)'" onmouseout="this.style.background='rgba(255, 255, 255, 0.1)'">
                                        <i class="fas fa-phone"></i>
                                        <span>Gọi ngay</span>
                                    </a>
                                    <a href="#" style="
                                        display: flex;
                                        align-items: center;
                                        gap: 0.5rem;
                                        padding: 1rem;
                                        background: rgba(255, 255, 255, 0.1);
                                        color: white;
                                        text-decoration: none;
                                        border-radius: 12px;
                                        transition: var(--transition);
                                        border: 1px solid rgba(255, 255, 255, 0.2);
                                    " onmouseover="this.style.background='rgba(255, 255, 255, 0.2)'" onmouseout="this.style.background='rgba(255, 255, 255, 0.1)'">
                                        <i class="fas fa-comments"></i>
                                        <span>Chat</span>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>

                <div class="back-button-container">
                    <a href="${pageContext.request.contextPath}/BookMedicalAppointmentServlet" class="back-button">
                        <i class="fas fa-arrow-left"></i> 
                        Quay Lại Danh Sách Bác Sĩ
                    </a>
                </div>
            </div>
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
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
                background-color: #f8fafc;
                color: #334155;
                line-height: 1.6;
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

            /* Container */
            .container {
                max-width: 1200px;
                margin: 2rem auto;
                padding: 0 2rem;
            }

            /* Alert Messages */
            .alert-container {
                margin-bottom: 2rem;
            }

            .alert {
                padding: 1rem 1.5rem;
                margin-bottom: 1rem;
                border-left: 4px solid;
                background: #ffffff;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                display: flex;
                align-items: center;
                gap: 0.75rem;
            }

            .alert-error {
                border-left-color: #dc2626;
                background: #fef2f2;
                color: #991b1b;
            }

            .alert-success {
                border-left-color: #059669;
                background: #f0fdf4;
                color: #065f46;
            }

            /* Page Title */
            .page-title {
                margin-bottom: 2rem;
                text-align: center;
            }

            .page-title h1 {
                font-size: 2rem;
                font-weight: 700;
                color: #0f172a;
                margin-bottom: 0.5rem;
            }

            .page-title p {
                color: #64748b;
                font-size: 1rem;
            }

            /* Layout */
            .details-section {
                display: flex;
                flex-wrap: wrap;
                gap: 2rem;
                margin-primer: 2rem;
            }

            .info-service-container {
                display: flex;
                flex-wrap: wrap;
                gap: 2rem;
                width: 100%;
            }

            .info-card, .services-card {
                flex: 1;
                min-width: 300px;
                max-width: 580px;
            }

            .schedule-card {
                width: 100%;
                max-width: 1200px; /* Matches the container max-width */
            }

            /* Cards */
            .card {
                background: #ffffff;
                border: 1px solid #e2e8f0;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            }

            .card-header {
                padding: 1.5rem;
                border-bottom: 1px solid #e2e8f0;
                background: #f8fafc;
            }

            .card-title {
                font-size: 1.25rem;
                font-weight: 600;
                color: #0f172a;
                display: flex;
                align-items: center;
                gap: 0.75rem;
            }

            .card-icon {
                width: 40px;
                height: 40px;
                background: #1e40af;
                color: white;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1rem;
            }

            .card-body {
                padding: 1.5rem;
            }

            /* Detail Items */
            .detail-item {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 0.75rem 0;
                border-bottom: 1px solid #f1f5f9;
            }

            .detail-item:last-child {
                border-bottom: none;
            }

            .detail-label {
                font-weight: 500;
                color: #475569;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .detail-value {
                font-weight: 600;
                color: #0f172a;
            }

            /* Tables */
            .services-table,
            .schedule-table {
                width: 100%;
                border-collapse: collapse;
            }

            .services-table th,
            .services-table td,
            .schedule-table th,
            .schedule-table td {
                padding: 0.75rem 1rem;
                text-align: left;
                border-bottom: 1px solid #e2e8f0;
                vertical-align: middle;
            }

            .services-table th,
            .schedule-table th {
                background: #f8fafc;
                font-weight: 600;
                color: #374151;
                font-size: 0.875rem;
            }

            .services-table td,
            .schedule-table td {
                color: #475569;
            }

            .price-cell {
                font-weight: 600;
                color: #059669;
            }

            /* Status Badge */
            .status-badge {
                display: inline-flex;
                align-items: center;
                gap: 0.25rem;
                padding: 0.25rem 0.75rem;
                font-size: 0.75rem;
                font-weight: 500;
                text-transform: uppercase;
                letter-spacing: 0.025em;
            }

            .status-available {
                background: #dcfce7;
                color: #166534;
                border: 1px solid #bbf7d0;
            }

            .status-unavailable {
                background: #fef2f2;
                color: #991b1b;
                border: 1px solid #fecaca;
            }

            .status-past {
                background: #f3f4f6;
                color: #6b7280;
                border: 1px solid #d1d5db;
            }

            /* Buttons */
            .btn {
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                padding: 0.5rem 1rem;
                border: 1px solid;
                background: #ffffff;
                color: #374151;
                text-decoration: none;
                font-weight: 500;
                font-size: 0.875rem;
                cursor: pointer;
                transition: all 0.2s ease;
            }

            .btn:hover {
                background: #f9fafb;
            }

            .btn-primary {
                background: #1e40af;
                color: white;
                border-color: #1e40af;
            }

            .btn-primary:hover {
                background: #1d4ed8;
                border-color: #1d4ed8;
            }

            .btn-primary:disabled {
                background: #9ca3af;
                border-color: #9ca3af;
                cursor: not-allowed;
            }

            .btn-secondary {
                background: #64748b;
                color: white;
                border-color: #64748b;
            }

            .btn-secondary:hover {
                background: #475569;
                border-color: #475569;
            }

            .back-button-container {
                text-align: center;
                margin-top: 3rem;
            }

            .back-button {
                display: inline-flex;
                align-items: center;
                gap: 0.75rem;
                padding: 1rem 2rem;
                background: #64748b;
                color: white;
                text-decoration: none;
                font-weight: 500;
                border: 1px solid #64748b;
                transition: all 0.2s ease;
            }

            .back-button:hover {
                background: #475569;
                border-color: #475569;
            }

            /* Footer */
            .main-footer {
                background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
                color: white;
                margin-top: auto;
                width: 100vw; /* Full viewport width */
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

            .container {
                max-width: 1200px;
                margin: 2rem auto;
                padding: 0 2rem;
                position: relative; 
            }
            @media (max-width: 1024px) {
                .container {
                    padding: 0 1rem;
                }

                .info-service-container {
                    flex-direction: column;
                }

                .info-card, .services-card {
                    max-width: 100%;
                }

                .schedule-card {
                    max-width: 100%;
                }
            }

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

                .container {
                    margin: 1rem auto;
                }

                .card-header,
                .card-body {
                    padding: 1rem;
                }

                .services-table,
                .schedule-table {
                    font-size: 0.875rem;
                }

                .services-table th,
                .services-table td,
                .schedule-table th,
                .schedule-table td {
                    padding: 0.75rem 0.5rem;
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
                .page-title h1 {
                    font-size: 1.5rem;
                }

                .services-table,
                .schedule-table {
                    font-size: 0.8rem;
                }

                .btn {
                    padding: 0.5rem 0.75rem;
                    font-size: 0.8rem;
                }

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
        <header class="main-header">
            <div class="header-top">
                <div class="header-container">
                    <div class="header-user">
                        <c:if test="${not empty currentUser}">
                            <div class="user-info">
                                <i class="fas fa-user-circle"></i>
                                <span>Xin chào, ${fn:escapeXml(currentUser.fullName)}</span>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

            <div class="header-main">
                <div class="header-container">
                    <a href="${pageContext.request.contextPath}/" class="logo">
                        <i class="fas fa-hospital"></i>
                        <span>Phòng Khám PDC</span>
                    </a>
                    <nav>
                        <ul class="main-nav">
                            <li><a href="${pageContext.request.contextPath}/views/user/Patient/PatientDashBoard.jsp"><i class="fas fa-home"></i> Trang chủ</a></li>
                            <li><a href="${pageContext.request.contextPath}/ViewMedicalAppointmentServlet"><i class="fas fa-calendar-alt"></i>Chọn Bác Sĩ</a></li>
                            <li><a href="${pageContext.request.contextPath}/ViewDetailBookServlet" class="active"><i class="fas fa-calendar-alt"></i>Đặt Lịch Khám</a></li>
                        </ul>
                    </nav>
                </div>
            </div>
        </header>

        <div class="container">
            <!-- Page Title -->
            <div class="page-title">
                <h1><i class="fas fa-user-md"></i> Đặt Lịch Khám</h1>
                <p>Thông tin chi tiết và đặt lịch khám bệnh</p>
            </div>

            <!-- Alert Messages -->
            <div class="alert-container">
                <c:if test="${not empty error}">
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-triangle"></i>
                        <span>${fn:escapeXml(error)}</span>
                    </div>
                </c:if>
                <c:if test="${not empty success}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        <span>${fn:escapeXml(success)}</span>
                    </div>
                </c:if>
                <c:if test="${empty patientId}">
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-triangle"></i>
                        <span>Lỗi: Không tìm thấy ID bệnh nhân. Vui lòng đăng nhập lại.</span>
                    </div>
                </c:if>
            </div>

            <div class="details-section">
                <c:choose>
                    <c:when test="${empty doctorDetails}">
                        <div class="alert alert-error" style="grid-column: 1 / -1;">
                            <i class="fas fa-user-md-slash"></i>
                            <span>Không tìm thấy thông tin bác sĩ.</span>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Doctor Info and Services Container -->
                        <div class="info-service-container">
                            <!-- Doctor Info Table -->
                            <div class="card info-card">
                                <div class="card-header">
                                    <div class="card-icon">
                                        <i class="fas fa-user-md"></i>
                                    </div>
                                    <h2 class="card-title">Thông Tin Bác Sĩ</h2>
                                </div>
                                <div class="card-body">
                                    <table class="services-table">
                                        <thead>
                                            <tr>
                                                <th><i class="fas fa-info-circle"></i> Thông Tin</th>
                                                <th><i class="fas fa-clipboard"></i> Chi Tiết</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><i class="fas fa-user"></i> Họ và Tên</td>
                                                <td class="detail-value">${fn:escapeXml(doctorDetails.doctorName)}</td>
                                            </tr>
                                            <tr>
                                                <td><i class="fas fa-stethoscope"></i> Chuyên Khoa</td>
                                                <td class="detail-value">${fn:escapeXml(doctorDetails.specialization)}</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <!-- Services Table -->
                            <div class="card services-card">
                                <div class="card-header">
                                    <div class="card-icon">
                                        <i class="fas fa-tooth"></i>
                                    </div>
                                    <h2 class="card-title">Dịch Vụ Khám Bệnh</h2>
                                </div>
                                <div class="card-body">
                                    <c:choose>
                                        <c:when test="${not empty doctorDetails.services and fn:length(doctorDetails.services) > 0 and doctorDetails.services[0].serviceName != 'N/A'}">
                                            <table class="services-table">
                                                <thead>
                                                    <tr>
                                                        <th><i class="fas fa-medical-kit"></i> Tên Dịch Vụ</th>
                                                        <th><i class="fas fa-money-bill-wave"></i> Giá Tiền</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="service" items="${doctorDetails.services}">
                                                        <tr>
                                                            <td>${fn:escapeXml(service.serviceName)}</td>
                                                            <td class="price-cell">
                                                                <fmt:formatNumber value="${service.price}" pattern="#,##0"/> VND
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </c:when>
                                        <c:otherwise>
                                            <p style="text-align: center; color: #64748b; padding: 2rem;">
                                                <i class="fas fa-info-circle"></i>
                                                Đang cập nhật thông tin dịch vụ
                                            </p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <!-- Schedule Table -->
                        <div class="card schedule-card">
                            <div class="card-header">
                                <div class="card-icon">
                                    <i class="fas fa-calendar-alt"></i>
                                </div>
                                <h2 class="card-title">Lịch Khám Có Sẵn</h2>
                            </div>
                            <div class="card-body">
                                <jsp:useBean id="now" class="java.util.Date" />
                                <c:choose>
                                    <c:when test="${not empty doctorDetails.schedules and fn:length(doctorDetails.schedules) > 0}">
                                        <!-- Filter available schedules -->
                                        <c:set var="hasAvailableSlots" value="false" />
                                        <c:forEach var="schedule" items="${doctorDetails.schedules}">
                                            <fmt:parseDate value="${schedule.slotDate}" pattern="yyyy-MM-dd" var="scheduleDateObj" />
                                            <c:if test="${schedule.status == 'Available' and scheduleDateObj >= now}">
                                                <c:set var="hasAvailableSlots" value="true" />
                                            </c:if>
                                        </c:forEach>

                                        <c:choose>
                                            <c:when test="${hasAvailableSlots}">
                                                <table class="schedule-table">
                                                    <thead>
                                                        <tr>
                                                            <th><i class="fas fa-calendar-day"></i> Ngày Khám</th>
                                                            <th><i class="fas fa-clock"></i> Giờ Khám</th>
                                                            <th><i class="fas fa-door-open"></i> Phòng</th>
                                                            <th><i class="fas fa-info-circle"></i> Trạng Thái</th>
                                                            <th><i class="fas fa-calendar-check"></i> Hành Động</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="schedule" items="${doctorDetails.schedules}">
                                                            <fmt:parseDate value="${schedule.slotDate}" pattern="yyyy-MM-dd" var="scheduleDateObj" />
                                                            <c:if test="${schedule.status == 'Available' and scheduleDateObj >= now}">
                                                                <tr>
                                                                    <td>
                                                                        <fmt:parseDate value="${schedule.slotDate}" pattern="yyyy-MM-dd" var="parsedDate" />
                                                                        <fmt:formatDate value="${parsedDate}" pattern="EEEE, dd/MM/yyyy" var="formattedDate" />
                                                                        ${fn:escapeXml(formattedDate)}
                                                                    </td>
                                                                    <td>
                                                                        ${fn:escapeXml(schedule.startTime)} - ${fn:escapeXml(schedule.endTime)}
                                                                    </td>
                                                                    <td>
                                                                        <c:choose>
                                                                            <c:when test="${not empty schedule.roomName}">
                                                                                ${fn:escapeXml(schedule.roomName)}
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                Phòng không xác định
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </td>
                                                                    <td>
                                                                        <span class="status-badge status-available">
                                                                            <i class="fas fa-check"></i> Có thể đặt
                                                                        </span>
                                                                    </td>
                                                                    <td>
                                                                        <c:if test="${not empty schedule.slotDate and not empty schedule.startTime}">
                                                                            <form action="${pageContext.request.contextPath}/BookAppointmentServlet" method="post" onsubmit="return validateForm(this);" style="display: inline;">
                                                                                <input type="hidden" name="doctorId" value="${fn:escapeXml(param.doctorId)}">
                                                                                <input type="hidden" name="slotId" value="${fn:escapeXml(schedule.slotId)}">
                                                                                <input type="hidden" name="roomId" value="${fn:escapeXml(schedule.roomId)}">
                                                                                <input type="hidden" name="patientId" value="${fn:escapeXml(patientId)}">
                                                                                <button type="submit" class="btn btn-primary">
                                                                                    <i class="fas fa-calendar-check"></i>
                                                                                    Đặt Lịch
                                                                                </button>
                                                                            </form>
                                                                        </c:if>
                                                                    </td>
                                                                </tr>
                                                            </c:if>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </c:when>
                                            <c:otherwise>
                                                <div style="text-align: center; padding: 2rem; color: #64748b;">
                                                    <i class="fas fa-calendar-times" style="font-size: 2rem; margin-bottom: 1rem; opacity: 0.5;"></i>
                                                    <p><strong>Hiện tại không có lịch trống</strong></p>
                                                    <p>Vui lòng quay lại sau hoặc liên hệ trực tiếp</p>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <div style="text-align: center; padding: 2rem; color: #64748b;">
                                            <i class="fas fa-calendar-times" style="font-size: 2rem; margin-bottom: 1rem; opacity: 0.5;"></i>
                                            <p><strong>Chưa có lịch làm việc</strong></p>
                                            <p>Bác sĩ chưa thiết lập lịch khám</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>



                <footer class="main-footer">
                    <div class="footer-content">
                        <div class="footer-grid">
                            <div class="footer-section">
                                <h4><i class="fas fa-hospital"></i>Về Chúng Tôi</h4>
                                <p>Chúng tôi là phòng khám nha khoa hàng đầu, cam kết mang lại nụ cười khỏe mạnh và tự tin với công nghệ tiên tiến và đội ngũ chuyên gia giàu kinh nghiệm.</p>
                          
                            </div>



                            <div class="footer-section">
                                <h4><i class="fas fa-link"></i> Liên Kết Nhanh</h4>
                                <ul>
                                    <li><a href="${pageContext.request.contextPath}/"><i class="fas fa-home"></i> Trang chủ</a></li>
                                    <li><a href="${pageContext.request.contextPath}/doctors"><i class="fas fa-user-md"></i>Chọn Bác sĩ</a></li>
                                    <li><a href="${pageContext.request.contextPath}/appointments"><i class="fas fa-calendar-alt"></i> Đặt lịch Khám</a></li>
              
                                </ul>
                            </div>

                            <div class="footer-section">
                                <h4><i class="fas fa-map-marker-alt"></i> Liên Hệ</h4>
                                <p><i class="fas fa-map-marker-alt"></i>ĐH FPT , HOA LAC</p>
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
                    function validateForm(form) {
                        const slotId = form.slotId.value.trim();
                        const roomId = form.roomId.value.trim();
                        console.log("Validating slotId: ", slotId, "roomId: ", roomId);
                        if (!slotId || isNaN(slotId) || parseInt(slotId) <= 0) {
                            alert('Vui lòng chọn một khung giờ hợp lệ!');
                            return false;
                        }
                        if (!roomId || isNaN(roomId) || parseInt(roomId) <= 0) {
                            alert('Vui lòng chọn một phòng hợp lệ!');
                            return false;
                        }
                        return true;
                    }

                    document.addEventListener('DOMContentLoaded', function () {
                        const forms = document.querySelectorAll('form');
                        forms.forEach(form => {
                            const slotIdInput = form.querySelector('input[name="slotId"]');
                            const roomIdInput = form.querySelector('input[name="roomId"]');
                            if (slotIdInput && roomIdInput) {
                                const slotId = slotIdInput.value;
                                const roomId = roomIdInput.value;
                                console.log("SlotId from form: ", slotId, "RoomId from form: ", roomId);
                            }
                        });
                    });
                </script>
                </body>
                </html>
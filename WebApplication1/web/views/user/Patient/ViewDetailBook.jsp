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
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-teal: #14b8a6;
            --primary-teal-dark: #0f766e;
            --primary-teal-light: #ccfbf1;
            --accent-coral: #f87171;
            --neutral-50: #fafafa;
            --neutral-100: #f5f5f5;
            --neutral-200: #e5e7eb;
            --neutral-600: #4b5563;
            --neutral-900: #111827;
            --error-red: #dc2626;
            --success-green: #16a34a;
            --white: #ffffff;
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            --border-radius: 10px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            color: var(--neutral-900);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            background: var(--neutral-100);
        }

        .header {
            background: var(--primary-teal);
            color: var(--white);
            padding: 1.5rem 2rem;
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: var(--shadow-md);
        }

        .header-container {
            max-width: 1400px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1rem;
        }

        .nav-menu {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .nav-link {
            color: var(--white);
            text-decoration: none;
            font-weight: 500;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            transition: background 0.2s ease, transform 0.2s ease;
        }

        .nav-link:hover {
            background: var(--primary-teal-dark);
            transform: translateY(-2px);
        }

        .nav-link.active {
            background: var(--primary-teal-dark);
        }

        .nav-link i {
            margin-right: 0.5rem;
        }

        .container {
            max-width: 800px;
            margin: 2rem auto;
            background: var(--white);
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-lg);
            flex: 1;
        }

        .details-section {
            padding: 2rem;
        }

        .detail-card {
            background: var(--neutral-50);
            border: 1px solid var(--neutral-200);
            border-radius: var(--border-radius);
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: var(--shadow-md);
            transition: all 0.2s ease;
        }

        .detail-card:hover {
            transform: translateY(-2px);
        }

        .detail-card h2 {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--neutral-900);
            margin-bottom: 1rem;
            border-bottom: 2px solid var(--primary-teal-light);
            padding-bottom: 0.5rem;
        }

        .detail-item {
            display: flex;
            justify-content: space-between;
            padding: 0.75rem 0;
            border-bottom: 1px solid var(--neutral-200);
        }

        .detail-item:last-child {
            border-bottom: none;
        }

        .detail-label {
            font-weight: 500;
            color: var(--neutral-600);
        }

        .detail-value {
            font-weight: 600;
            color: var(--neutral-900);
            text-align: right;
        }

        .services-list, .schedule-list {
            list-style: none;
            padding-left: 0;
        }

        .services-list li, .schedule-list li {
            padding: 0.5rem 0;
            color: var(--neutral-600);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 0.5rem;
        }

        .services-list li::before {
            content: "•";
            color: var(--primary-teal);
            font-weight: bold;
            margin-right: 0.5rem;
        }

        .schedule-list li::before {
            content: "•";
            color: var(--primary-teal);
            font-weight: bold;
            margin-right: 0.5rem;
        }

        .schedule-book-btn {
            background: var(--accent-coral);
            color: var(--white);
            padding: 0.5rem 1rem;
            border-radius: 8px;
            border: none;
            font-weight: 500;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.2s ease;
            text-decoration: none;
        }

        .schedule-book-btn:hover {
            background: #ef4444;
            transform: translateY(-2px);
        }

        .schedule-book-btn:disabled {
            background: var(--neutral-600);
            cursor: not-allowed;
        }

        .back-button {
            display: inline-block;
            padding: 0.85rem 1.75rem;
            background: var(--neutral-600);
            color: var(--white);
            text-decoration: none;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.2s ease;
            margin-top: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .back-button:hover {
            background: var(--neutral-900);
            transform: translateY(-2px);
        }

        .error-message {
            padding: 1.25rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            font-weight: 500;
            background: #fee2e2;
            color: #b91c1c;
            border: 1px solid #fecaca;
        }

        .footer {
            background: var(--neutral-900);
            color: var(--neutral-100);
            padding: 3rem 2rem;
            margin-top: auto;
        }

        .footer-container {
            max-width: 1400px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 2rem;
        }

        .footer-section h4 {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 1rem;
        }

        .footer-section p, .footer-section ul li {
            font-size: 0.9rem;
            line-height: 1.6;
        }

        .footer-section ul {
            list-style: none;
        }

        .footer-section ul li {
            margin-bottom: 0.75rem;
        }

        .footer-section a {
            color: var(--neutral-100);
            text-decoration: none;
        }

        .footer-section a:hover {
            color: var(--primary-teal-light);
        }

        @media (max-width: 768px) {
            .container {
                margin: 1rem;
            }

            .header-container {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
            }

            .nav-menu {
                width: 100%;
                justify-content: center;
            }

            .nav-link {
                flex: 1;
                text-align: center;
            }

            .detail-item {
                flex-direction: column;
                text-align: left;
                gap: 0.5rem;
            }

            .detail-value {
                text-align: left;
            }

            .schedule-list li {
                flex-direction: column;
                align-items: flex-start;
            }

            .schedule-book-btn {
                width: 100%;
                justify-content: center;
                margin-top: 0.5rem;
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
                    <i class="fas fa-calendar-check"></i> Đặt Lịch
                </a>
            </nav>
        </div>
    </header>

    <div class="container">
        <div class="details-section">
            <c:if test="${not empty error}">
                <div class="error-message">
                    <i class="fas fa-exclamation-triangle"></i>
                    ${fn:escapeXml(error)}
                </div>
            </c:if>

            <c:choose>
                <c:when test="${empty doctorDetails}">
                    <div class="error-message">
                        <i class="fas fa-exclamation-triangle"></i>
                        Không tìm thấy thông tin bác sĩ.
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="detail-card">
                        <h2>Thông Tin Cơ Bản</h2>
                        <div class="detail-item">
                            <span class="detail-label">Tên Bác Sĩ:</span>
                            <span class="detail-value">${fn:escapeXml(doctorDetails.doctorName)}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Chuyên Môn:</span>
                            <span class="detail-value">${fn:escapeXml(doctorDetails.specialization)}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Phòng Khám:</span>
                            <span class="detail-value">${fn:escapeXml(doctorDetails.roomName)}</span>
                        </div>
                    </div>

                    <div class="detail-card">
                        <h2>Dịch Vụ Cung Cấp</h2>
                        <ul class="services-list">
                            <c:choose>
                                <c:when test="${not empty doctorDetails.services and fn:length(doctorDetails.services) > 0 and doctorDetails.services[0].serviceName != 'N/A'}">
                                    <c:forEach var="service" items="${doctorDetails.services}">
                                        <li>
                                            ${fn:escapeXml(service.serviceName)}
                                            <span class="detail-value">Giá: <fmt:formatNumber value="${service.price}" pattern="#,##0"/> VND</span>
                                        </li>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <li>Không có dịch vụ nào</li>
                                </c:otherwise>
                            </c:choose>
                        </ul>
                    </div>

                    <div class="detail-card">
                        <h2>Lịch Làm Việc</h2>
                        <ul class="schedule-list">
                            <c:choose>
                                <c:when test="${not empty doctorDetails.schedules and fn:length(doctorDetails.schedules) > 0 and doctorDetails.schedules[0].scheduleID != null}">
                                    <c:forEach var="schedule" items="${doctorDetails.schedules}">
                                        <li>
                                            <span>
                                                <fmt:parseDate value="${schedule.slotDate}" pattern="yyyy-MM-dd" var="parsedDate"/>
                                                <fmt:formatDate value="${parsedDate}" pattern="EEEE, dd/MM/yyyy" var="formattedDate"/>
                                                ${fn:escapeXml(formattedDate)}:
                                                ${fn:escapeXml(schedule.startTime)} - ${fn:escapeXml(schedule.endTime)}
                                            </span>
                                            <c:if test="${schedule.status == 'Available'}">
                                                <form action="${pageContext.request.contextPath}/BookMedicalAppointmentServlet" method="post">
                                                    <input type="hidden" name="doctorId" value="${fn:escapeXml(param.doctorId)}">
                                                    <input type="hidden" name="scheduleId" value="${fn:escapeXml(schedule.scheduleID)}">
                                                    <input type="hidden" name="roomId" value="${fn:escapeXml(doctorDetails.roomID)}">
                                                    <input type="hidden" name="action" value="bookAppointment">
                                                    <button type="submit" class="schedule-book-btn" onclick="return confirm('Bạn có chắc muốn đặt lịch này?');">
                                                        <i class="fas fa-calendar-check"></i> Đặt
                                                    </button>
                                                </form>
                                            </c:if>
                                        </li>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <li>Không có lịch làm việc</li>
                                </c:otherwise>
                            </c:choose>
                        </ul>
                    </div>
                </c:otherwise>
            </c:choose>

            <a href="${pageContext.request.contextPath}/BookMedicalAppointmentServlet" class="back-button">
                <i class="fas fa-arrow-left"></i> Quay Lại
            </a>
        </div>
    </div>

    <footer class="footer">
        <div class="footer-container">
            <div class="footer-section">
                <h4>Về Chúng Tôi</h4>
                <p>Chúng tôi cam kết mang đến dịch vụ y tế chất lượng với đội ngũ bác sĩ tận tâm.</p>
            </div>
            <div class="footer-section">
                <h4>Liên Kết</h4>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/views/user/Patient/PatientDashBoard.jsp">Trang Chủ</a></li>
                </ul>
            </div>
            <div class="footer-section">
                <h4>Liên Hệ</h4>
                <ul>
                    <li><i class="fas fa-map-marker-alt"></i> DH FPT, HOA LAC</li>
                    <li><i class="fas fa-phone"></i> (098) 1234-5678</li>
                    <li><i class="fas fa-envelope"></i> NhaKhoaPDC@benhvien.com</li>
                </ul>
            </div>
        </div>
    </footer>
</body>
</html>
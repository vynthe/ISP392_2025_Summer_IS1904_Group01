<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<html>
<head>
    <title>Đặt Lịch Hẹn Khám - Bệnh Viện</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
            --success-green: #10b981;
            --success-green-light: #d1fae5;
            --success-green-border: #6ee7b7;
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
        }

        .header-container {
            max-width: 1400px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            text-decoration: none;
        }

        .logo img {
            width: 48px;
            height: 48px;
            border-radius: 8px;
        }

        .logo-text {
            font-size: 1.75rem;
            font-weight: 600;
        }

        .nav-menu {
            display: flex;
            gap: 1rem;
        }

        .nav-link {
            color: var(--white);
            text-decoration: none;
            font-weight: 500;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            transition: background 0.2s ease;
        }

        .nav-link:hover {
            background: var(--primary-teal-dark);
        }

        .main-container {
            max-width: 1400px;
            margin: 2rem auto;
            background: var(--white);
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-lg);
            flex: 1;
        }

        .page-header {
            background: var(--primary-teal-light);
            padding: 2.5rem;
            text-align: center;
        }

        .page-title {
            font-size: 2.25rem;
            font-weight: 700;
            color: var(--neutral-900);
        }

        .page-subtitle {
            font-size: 1rem;
            color: var(--neutral-600);
            margin-top: 0.5rem;
        }

        .stats-section {
            padding: 2rem;
            background: var(--neutral-50);
            border-bottom: 1px solid var(--neutral-200);
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 1.5rem;
        }

        .stat-card {
            background: var(--white);
            padding: 1.75rem;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-md);
            text-align: center;
            transition: transform 0.2s ease;
        }

        .stat-card:hover {
            transform: translateY(-4px);
        }

        .stat-value {
            font-size: 2rem;
            font-weight: 600;
            color: var(--primary-teal);
        }

        .stat-label {
            font-size: 0.9rem;
            color: var(--neutral-600);
            margin-top: 0.5rem;
        }

        .content-section {
            padding: 2.5rem;
        }

        .search-form {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
            flex-wrap: wrap;
            justify-content: center;
        }

        .search-input {
            flex: 1;
            padding: 0.85rem 1.25rem;
            border-radius: 8px;
            border: 1px solid var(--neutral-200);
            font-size: 0.95rem;
            min-width: 250px;
            transition: border-color 0.2s ease;
        }

        .search-input:focus {
            outline: none;
            border-color: var(--primary-teal);
        }

        .search-button {
            background: var(--accent-coral);
            color: var(--white);
            padding: 0.85rem 1.75rem;
            border-radius: 8px;
            border: none;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .search-button:hover {
            background: #ef4444;
        }

        .alert {
            padding: 1.25rem;
            border-radius: 8px;
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            font-weight: 500;
            font-size: 0.95rem;
            transition: all 0.3s ease;
        }

        .alert-success {
            background: var(--success-green-light);
            color: var(--success-green);
            border: 2px solid var(--success-green-border);
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .alert-success i {
            font-size: 1.5rem;
            color: var(--success-green);
            margin-right: 0.75rem;
        }

        .alert-error {
            background: #fee2e2;
            color: #b91c1c;
            border: 1px solid #fecaca;
        }

        .table-container {
            border-radius: var(--border-radius);
            overflow: hidden;
            box-shadow: var(--shadow-md);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead th {
            background: var(--primary-teal-light);
            color: var(--neutral-600);
            font-weight: 600;
            padding: 1.25rem;
            text-align: left;
        }

        tbody tr {
            border-bottom: 1px solid var(--neutral-200);
            transition: background 0.2s ease;
        }

        tbody tr:hover {
            background: var(--neutral-50);
        }

        td {
            padding: 1.25rem;
        }

        .action-btn {
            padding: 0.6rem 1.25rem;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.2s ease;
        }

        .btn-select {
            background: #fee2e2;
            color: var(--accent-coral);
        }

        .btn-select:hover {
            background: var(--accent-coral);
            color: var(--white);
        }

        .pagination-section {
            padding: 1.5rem;
            background: var(--neutral-50);
            border-top: 1px solid var(--neutral-200);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .pagination-info {
            color: var(--neutral-600);
            font-size: 0.9rem;
        }

        .pagination-controls {
            display: flex;
            gap: 0.5rem;
        }

        .page-btn {
            padding: 0.6rem 1.25rem;
            border-radius: 8px;
            border: 1px solid var(--neutral-200);
            background: var(--white);
            color: var(--neutral-600);
            text-decoration: none;
            font-size: 0.9rem;
        }

        .page-btn.active {
            background: var(--primary-teal);
            color: var(--white);
            border-color: var(--primary-teal);
        }

        .page-btn:hover:not(.disabled) {
            background: var(--primary-teal);
            color: var(--white);
        }

        .page-btn.disabled {
            color: var(--neutral-600);
            background: var(--neutral-100);
            cursor: not-allowed;
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

        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: var(--neutral-600);
        }

        .empty-icon {
            font-size: 3.5rem;
            color: var(--neutral-200);
            margin-bottom: 1rem;
        }

        .empty-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        @media (max-width: 768px) {
            .header-container {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
            }

            .table-container {
                display: none;
            }

            .mobile-cards {
                display: block;
            }

            .doctor-card {
                background: var(--white);
                border: 1px solid var(--neutral-200);
                border-radius: var(--border-radius);
                padding: 1.5rem;
                margin-bottom: 1.5rem;
                box-shadow: var(--shadow-md);
            }

            .doctor-card:hover {
                transform: translateY(-2px);
            }

            .card-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 1rem;
            }

            .card-number {
                background: var(--primary-teal-light);
                color: var(--primary-teal);
                padding: 0.3rem 0.6rem;
                border-radius: 6px;
                font-size: 0.85rem;
            }

            .card-body {
                margin-bottom: 1rem;
            }

            .card-field {
                display: flex;
                justify-content: space-between;
                padding: 0.5rem 0;
                border-bottom: 1px solid var(--neutral-200);
            }

            .card-field:last-child {
                border-bottom: none;
            }

            .field-label {
                font-weight: 600;
                color: var(--neutral-900);
            }

            .field-value {
                color: var(--neutral-600);
            }

            .card-actions {
                display: flex;
                flex-direction: column;
                gap: 0.75rem;
            }

            .action-btn {
                width: 100%;
                text-align: center;
            }

            .pagination-section {
                flex-direction: column;
                text-align: center;
            }

            .pagination-controls {
                flex-wrap: wrap;
                justify-content: center;
            }
        }

        @media (min-width: 769px) {
            .mobile-cards {
                display: none;
            }
        }
    </style>
</head>
<body>
    <header class="header">
        <div class="header-container">            
            <nav class="nav-menu">
                <a href="${pageContext.request.contextPath}/views/user/Patient/PatientDashBoard.jsp" 
                   class="nav-link active">
                    <i class="fas fa-home"></i> Trang Chủ
                </a>
                <a href="${pageContext.request.contextPath}/BookMedicalAppointmentServlet" 
                   class="nav-link">
                    <i class="fas fa-calendar-check"></i> Đặt Lịch
                </a>
            </nav>
        </div>
    </header>
    <div class="main-container">
        <div class="page-header">
            <h1 class="page-title">Đặt Lịch Hẹn Khám</h1>
            <p class="page-subtitle">Tìm và đặt lịch với bác sĩ phù hợp</p>
        </div>

        <div class="stats-section">
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-value">${not empty totalRecords ? totalRecords : 0}</div>
                    <div class="stat-label">Tổng số bác sĩ</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">${not empty currentPage ? currentPage : 1}</div>
                    <div class="stat-label">Trang hiện tại</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">${not empty totalPages ? totalPages : 1}</div>
                    <div class="stat-label">Tổng số trang</div>
                </div>
            </div>
        </div>

        <div class="content-section">
            <form action="${pageContext.request.contextPath}/BookMedicalAppointmentServlet" method="get" class="search-form">
                <input type="text" name="nameKeyword" placeholder="Tìm theo tên bác sĩ..." 
                       value="${fn:escapeXml(param.nameKeyword)}" class="search-input">
                <input type="text" name="specialtyKeyword" placeholder="Tìm theo chuyên môn..." 
                       value="${fn:escapeXml(param.specialtyKeyword)}" class="search-input">
                <button type="submit" class="search-button">
                    <i class="fas fa-search"></i> Tìm kiếm
                </button>
            </form>

            <c:if test="${not empty sessionScope.statusMessage}">
                <div class="alert ${fn:contains(sessionScope.statusMessage, 'thành công') ? 'alert-success' : 'alert-error'}">
                    <i class="fas ${fn:contains(sessionScope.statusMessage, 'thành công') ? 'fa-check-circle' : 'fa-exclamation-circle'}"></i>
                    ${fn:escapeXml(sessionScope.statusMessage)}
                </div>
                <c:remove var="statusMessage" scope="session"/>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-triangle"></i>
                    ${fn:escapeXml(errorMessage)}
                </div>
            </c:if>

            <div class="table-container">
                <c:choose>
                    <c:when test="${empty doctors}">
                        <div class="empty-state">
                            <i class="fas fa-user-md empty-icon"></i>
                            <h3 class="empty-title">Chưa có bác sĩ nào</h3>
                            <p class="empty-description">Hiện tại không có bác sĩ nào trong hệ thống${not empty errorMessage ? ' hoặc có lỗi: ' + errorMessage : ''}</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table>
                            <thead>
                                <tr>
                                    <th>STT</th>
                                    <th>Tên Bác Sĩ</th>
                                    <th>Chuyên Môn</th>
                                    <th>Thao Tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="doctor" items="${doctors}" varStatus="status">
                                    <tr>
                                        <td>${(currentPage - 1) * 10 + status.count}</td>
                                        <td>${fn:escapeXml(doctor.fullName)}</td>
                                        <td>${fn:escapeXml(doctor.specialization)}</td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/ViewDetailBookServlet?doctorId=${doctor.userID}" 
                                               class="action-btn btn-select">
                                                <i class="fas fa-check"></i> Chọn
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        <div class="mobile-cards">
                            <c:forEach var="doctor" items="${doctors}" varStatus="status">
                                <div class="doctor-card">
                                    <div class="card-header">
                                        <div class="doctor-name">${fn:escapeXml(doctor.fullName)}</div>
                                        <div class="card-number">#${(currentPage - 1) * 10 + status.count}</div>
                                    </div>
                                    <div class="card-body">
                                        <div class="card-field">
                                            <span class="field-label">Chuyên môn:</span>
                                            <span class="field-value">${fn:escapeXml(doctor.specialization)}</span>
                                        </div>
                                    </div>
                                    <div class="card-actions">
                                        <a href="${pageContext.request.contextPath}/ViewDetailBookServlet?doctorId=${doctor.userID}" 
                                           class="action-btn btn-select">
                                            <i class="fas fa-check"></i> Chọn
                                        </a>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <c:if test="${not empty doctors and totalPages > 1}">
                <div class="pagination-section">
                    <div class="pagination-info">
                        Hiển thị <strong>${(currentPage - 1) * 10 + 1}</strong> - 
                        <strong>${currentPage * 10 > totalRecords ? totalRecords : currentPage * 10}</strong> 
                        trong tổng số <strong>${totalRecords}</strong> bác sĩ
                    </div>
                    <div class="pagination-controls">
                        <c:choose>
                            <c:when test="${currentPage > 1}">
                                <a href="${pageContext.request.contextPath}/BookMedicalAppointmentServlet?page=1&nameKeyword=${fn:escapeXml(param.nameKeyword)}&specialtyKeyword=${fn:escapeXml(param.specialtyKeyword)}" 
                                   class="page-btn"><i class="fas fa-angle-double-left"></i></a>
                                <a href="${pageContext.request.contextPath}/BookMedicalAppointmentServlet?page=${currentPage - 1}&nameKeyword=${fn:escapeXml(param.nameKeyword)}&specialtyKeyword=${fn:escapeXml(param.specialtyKeyword)}" 
                                   class="page-btn"><i class="fas fa-angle-left"></i></a>
                            </c:when>
                            <c:otherwise>
                                <span class="page-btn disabled"><i class="fas fa-angle-double-left"></i></span>
                                <span class="page-btn disabled"><i class="fas fa-angle-left"></i></span>
                            </c:otherwise>
                        </c:choose>
                        <c:forEach var="i" begin="${currentPage - 2 > 0 ? currentPage - 2 : 1}" 
                                  end="${currentPage + 2 < totalPages ? currentPage + 2 : totalPages}">
                            <c:choose>
                                <c:when test="${i == currentPage}">
                                    <span class="page-btn active">${i}</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/BookMedicalAppointmentServlet?page=${i}&nameKeyword=${fn:escapeXml(param.nameKeyword)}&specialtyKeyword=${fn:escapeXml(param.specialtyKeyword)}" 
                                       class="page-btn">${i}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                        <c:choose>
                            <c:when test="${currentPage < totalPages}">
                                <a href="${pageContext.request.contextPath}/BookMedicalAppointmentServlet?page=${currentPage + 1}&nameKeyword=${fn:escapeXml(param.nameKeyword)}&specialtyKeyword=${fn:escapeXml(param.specialtyKeyword)}" 
                                   class="page-btn"><i class="fas fa-angle-right"></i></a>
                                <a href="${pageContext.request.contextPath}/BookMedicalAppointmentServlet?page=${totalPages}&nameKeyword=${fn:escapeXml(param.nameKeyword)}&specialtyKeyword=${fn:escapeXml(param.specialtyKeyword)}" 
                                   class="page-btn"><i class="fas fa-angle-double-right"></i></a>
                            </c:when>
                            <c:otherwise>
                                <span class="page-btn disabled"><i class="fas fa-angle-right"></i></span>
                                <span class="page-btn disabled"><i class="fas fa-angle-double-right"></i></span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:if>
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
                        <li><i class="fas fa-map-marker-alt"></i> DH FPT , HOA LAC</li>
                        <li><i class="fas fa-phone"></i> (098) 1234-5678</li>
                        <li><i class="fas fa-envelope"></i> PhongKhamPDC@benhvien.com</li>
                    </ul>
                </div>
            </div>
        </footer>
    </body>
</html>
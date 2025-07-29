<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<html>
    <head>
        <title>Danh Sách Kết Quả Khám và Toa Thuốc</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            :root {
                --primary: #3b82f6;
                --primary-dark: #2563eb;
                --secondary: #6b7280;
                --accent: #a855f7;
                --success: #10b981;
                --error: #ef4444;
                --white: #ffffff;
                --gray-50: #f9fafb;
                --gray-100: #f3f4f6;
                --gray-200: #e5e7eb;
                --gray-300: #d1d5db;
                --gray-400: #9ca3af;
                --gray-500: #6b7280;
                --gray-600: #4b5563;
                --gray-700: #374151;
                --gray-800: #1f2937;
                --gray-900: #111827;
                --gradient-primary: linear-gradient(135deg, #3b82f6 0%, #a855f7 100%);
                --shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.05);
                --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -2px rgba(0, 0, 0, 0.1);
                --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.1);
                --border-radius: 12px;
                --border-radius-lg: 16px;
                --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
                background-color: var(--gray-50);
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                color: var(--gray-900);
            }

            /* Header Styles */
            .main-header {
                background: var(--white);
                box-shadow: var(--shadow-sm);
                position: sticky;
                top: 0;
                z-index: 1000;
                border-bottom: 1px solid var(--gray-200);
            }

            .header-container {
                max-width: 1280px;
                margin: 0 auto;
                padding: 0 2rem;
                display: flex;
                justify-content: space-between;
                align-items: center;
                height: 70px;
            }

            .logo-section {
                display: flex;
                align-items: center;
                gap: 1rem;
            }

            .logo {
                width: 40px;
                height: 40px;
                background: var(--gradient-primary);
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: var(--white);
                font-size: 1.25rem;
                font-weight: bold;
            }

            .brand-name {
                font-size: 1.5rem;
                font-weight: 700;
                color: var(--gray-900);
            }

            .nav-menu {
                display: flex;
                align-items: center;
                gap: 2rem;
            }

            .nav-item {
                color: var(--gray-600);
                text-decoration: none;
                font-weight: 500;
                font-size: 0.875rem;
                padding: 0.5rem 1rem;
                border-radius: var(--border-radius);
                transition: var(--transition);
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .nav-item:hover {
                color: var(--primary);
                background-color: rgba(59, 130, 246, 0.1);
            }

            .nav-item.active {
                color: var(--primary);
                background-color: rgba(59, 130, 246, 0.1);
            }

            /* Main Content Wrapper */
            .main-wrapper {
                flex: 1;
                padding: 2rem;
            }

            .dental-container {
                background: var(--white);
                border-radius: var(--border-radius-lg);
                box-shadow: var(--shadow-lg);
                max-width: 1280px;
                margin: 0 auto;
                overflow: hidden;
                animation: fadeIn 0.5s ease-out;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .dental-header {
                background: var(--gradient-primary);
                padding: 2rem;
                position: relative;
                color: var(--white);
            }

            .header-content {
                display: flex;
                justify-content: center;
                align-items: center;
                flex-wrap: wrap;
                gap: 1.5rem;
            }

            .title-group {
                display: flex;
                align-items: center;
                gap: 1rem;
                text-align: center;
            }

            .dental-logo {
                width: 48px;
                height: 48px;
                background: rgba(255, 255, 255, 0.15);
                border-radius: 10px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.5rem;
            }

            .page-title {
                font-size: 1.875rem;
                font-weight: 700;
                letter-spacing: -0.025em;
            }

            .page-subtitle {
                font-size: 0.875rem;
                opacity: 0.9;
                font-weight: 400;
            }

            .add-medication-btn {
                background: var(--white);
                color: var(--primary-dark);
                padding: 0.75rem 1.25rem;
                border-radius: var(--border-radius);
                font-weight: 600;
                font-size: 0.875rem;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                transition: var(--transition);
                box-shadow: var(--shadow-sm);
            }

            .add-medication-btn:hover {
                background: var(--primary);
                color: var(--white);
                transform: translateY(-2px);
                box-shadow: var(--shadow-md);
            }

            .stats-section {
                padding: 1.5rem 2rem;
                background: var(--gray-50);
                border-bottom: 1px solid var(--gray-200);
            }

            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
                gap: 1rem;
            }

            .stat-card {
                background: var(--white);
                padding: 1.25rem;
                border-radius: var(--border-radius);
                box-shadow: var(--shadow-sm);
                transition: var(--transition);
            }

            .stat-card:hover {
                transform: translateY(-2px);
                box-shadow: var(--shadow-md);
            }

            .stat-value {
                font-size: 1.75rem;
                font-weight: 700;
                color: var(--primary-dark);
            }

            .stat-label {
                font-size: 0.875rem;
                color: var(--gray-600);
                margin-top: 0.25rem;
            }

            .content-section {
                padding: 2rem;
            }

            .search-form {
                margin-bottom: 2rem;
                display: flex;
                gap: 1rem;
                flex-wrap: wrap;
            }

            .search-input {
                flex: 1;
                padding: 0.75rem 1rem;
                border-radius: var(--border-radius);
                border: 1px solid var(--gray-200);
                font-size: 0.875rem;
                transition: var(--transition);
            }

            .search-input:focus {
                outline: none;
                border-color: var(--primary);
                box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
            }

            .search-button {
                background: var(--primary);
                color: var(--white);
                padding: 0.75rem 1.5rem;
                border-radius: var(--border-radius);
                border: none;
                font-weight: 600;
                font-size: 0.875rem;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 0.5rem;
                transition: var(--transition);
            }

            .search-button:hover {
                background: var(--primary-dark);
                transform: translateY(-2px);
            }

            .clear-button {
                background: var(--gray-500);
                color: var(--white);
                padding: 0.75rem 1.5rem;
                border-radius: var(--border-radius);
                border: none;
                font-weight: 600;
                font-size: 0.875rem;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 0.5rem;
                transition: var(--transition);
                text-decoration: none;
            }

            .clear-button:hover {
                background: var(--gray-600);
                transform: translateY(-2px);
            }

            .alert {
                padding: 1rem;
                border-radius: var(--border-radius);
                margin-bottom: 1.5rem;
                display: flex;
                align-items: center;
                gap: 0.75rem;
                font-weight: 500;
                animation: fadeIn 0.3s ease;
            }

            .alert-success {
                background: rgba(16, 185, 129, 0.1);
                color: var(--success);
                border: 1px solid rgba(16, 185, 129, 0.2);
            }

            .alert-error {
                background: rgba(239, 68, 68, 0.1);
                color: var(--error);
                border: 1px solid rgba(239, 68, 68, 0.2);
            }

            .table-container {
                background: var(--white);
                border-radius: var(--border-radius);
                box-shadow: var(--shadow-sm);
                overflow: hidden;
            }

            .table-wrapper {
                overflow-x: auto;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                font-size: 0.875rem;
            }

            thead th {
                background: var(--gray-50);
                color: var(--gray-700);
                font-weight: 600;
                text-transform: uppercase;
                font-size: 0.75rem;
                letter-spacing: 0.05em;
                padding: 1rem 1.5rem;
                text-align: left;
                border-bottom: 1px solid var(--gray-200);
            }

            tbody tr {
                border-bottom: 1px solid var(--gray-100);
                transition: var(--transition);
            }

            tbody tr:hover {
                background-color: var(--gray-50);
            }

            td {
                padding: 1rem 1.5rem;
                vertical-align: middle;
            }

            .row-number {
                font-weight: 600;
                color: var(--gray-500);
            }

            .prescription-details {
                font-weight: 500;
                color: var(--gray-900);
            }

            .diagnosis-cell {
                max-width: 200px;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }

            .notes-cell {
                max-width: 150px;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }

            .action-buttons {
                display: flex;
                gap: 0.75rem;
                justify-content: flex-start;
                align-items: center;
                flex-wrap: wrap;
            }

            .action-btn {
                padding: 0.65rem 1.25rem;
                border-radius: 8px;
                font-size: 0.875rem;
                font-weight: 500;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                transition: var(--transition);
                min-width: 120px;
                justify-content: center;
                border: 1px solid transparent;
                box-shadow: var(--shadow-sm);
            }

            .btn-prescribe {
                background: var(--success);
                color: var(--white);
                border: 1px solid var(--success);
            }

            .btn-prescribe:hover {
                background: #0d9b6f;
                border-color: #0d9b6f;
                transform: translateY(-2px);
                box-shadow: var(--shadow-md);
            }

            .btn-view {
                background: var(--primary);
                color: var(--white);
                border: 1px solid var(--primary);
            }

            .btn-view:hover {
                background: var(--primary-dark);
                border-color: var(--primary-dark);
                transform: translateY(-2px);
                box-shadow: var(--shadow-md);
            }

            .btn-edit {
                background: var(--accent);
                color: var(--white);
                border: 1px solid var(--accent);
            }

            .btn-edit:hover {
                background: #9333ea;
                border-color: #9333ea;
                transform: translateY(-2px);
                box-shadow: var(--shadow-md);
            }

            .empty-state {
                text-align: center;
                padding: 3rem;
                color: var(--gray-600);
            }

            .empty-icon {
                font-size: 3rem;
                color: var(--gray-300);
                margin-bottom: 1rem;
            }

            .empty-title {
                font-size: 1.25rem;
                font-weight: 600;
                margin-bottom: 0.5rem;
            }

            .pagination-section {
                padding: 1.5rem 2rem;
                background: var(--gray-50);
                border-top: 1px solid var(--gray-200);
                display: flex;
                justify-content: space-between;
                align-items: center;
                flex-wrap: wrap;
                gap: 1rem;
            }

            .pagination-info {
                font-size: 0.875rem;
                color: var(--gray-600);
            }

            .pagination-controls {
                display: flex;
                gap: 0.5rem;
                flex-wrap: wrap;
            }

            .page-btn {
                padding: 0.5rem 1rem;
                border-radius: var(--border-radius);
                border: 1px solid var(--gray-200);
                background: var(--white);
                color: var(--gray-700);
                font-size: 0.875rem;
                text-decoration: none;
                transition: var(--transition);
                min-width: 36px;
                text-align: center;
            }

            .page-btn:hover:not(.disabled):not(.active) {
                background: var(--primary);
                color: var(--white);
                border-color: var(--primary);
            }

            .page-btn.active {
                background: var(--primary);
                color: var(--white);
                border-color: var(--primary);
            }

            .page-btn.disabled {
                color: var(--gray-400);
                cursor: not-allowed;
            }

            /* Footer Styles */
            .main-footer {
                background: var(--gray-800);
                color: var(--gray-200);
                margin-top: auto;
            }

            .footer-content {
                max-width: 1280px;
                margin: 0 auto;
                padding: 3rem 2rem 2rem;
            }

            .footer-sections {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 2rem;
                margin-bottom: 2rem;
            }

            .footer-section h3 {
                font-size: 1.125rem;
                font-weight: 600;
                margin-bottom: 1rem;
                color: var(--white);
            }

            .footer-section p {
                font-size: 0.875rem;
                line-height: 1.6;
                margin-bottom: 1rem;
            }

            .footer-links {
                list-style: none;
            }

            .footer-links li {
                margin-bottom: 0.5rem;
            }

            .footer-links a {
                color: var(--gray-300);
                text-decoration: none;
                font-size: 0.875rem;
                transition: var(--transition);
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .footer-links a:hover {
                color: var(--primary);
            }

            .contact-info {
                display: flex;
                flex-direction: column;
                gap: 0.75rem;
            }

            .contact-item {
                display: flex;
                align-items: center;
                gap: 0.75rem;
                font-size: 0.875rem;
            }

            .contact-icon {
                width: 20px;
                text-align: center;
                color: var(--primary);
            }

            .social-links {
                display: flex;
                gap: 1rem;
                margin-top: 1rem;
            }

            .social-link {
                width: 40px;
                height: 40px;
                background: var(--gray-700);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                color: var(--gray-300);
                text-decoration: none;
                transition: var(--transition);
            }

            .social-link:hover {
                background: var(--primary);
                color: var(--white);
                transform: translateY(-2px);
            }

            .footer-bottom {
                border-top: 1px solid var(--gray-700);
                padding-top: 2rem;
                display: flex;
                justify-content: space-between;
                align-items: center;
                flex-wrap: wrap;
                gap: 1rem;
            }

            .copyright {
                font-size: 0.875rem;
                color: var(--gray-400);
            }

            .footer-bottom-links {
                display: flex;
                gap: 2rem;
            }

            .footer-bottom-links a {
                color: var(--gray-400);
                text-decoration: none;
                font-size: 0.875rem;
                transition: var(--transition);
            }

            .footer-bottom-links a:hover {
                color: var(--primary);
            }

            /* Mobile Styles */
            @media (max-width: 768px) {
                .main-wrapper {
                    padding: 1rem;
                }

                .header-container {
                    padding: 0 1rem;
                    height: auto;
                    min-height: 70px;
                    flex-direction: column;
                    gap: 1rem;
                    padding-top: 1rem;
                    padding-bottom: 1rem;
                }

                .nav-menu {
                    flex-wrap: wrap;
                    justify-content: center;
                    gap: 1rem;
                }

                .user-menu {
                    order: -1;
                    width: 100%;
                    justify-content: flex-end;
                }

                .dental-container {
                    border-radius: var(--border-radius);
                }

                .header-content {
                    flex-direction: column;
                    text-align: center;
                }

                .add-medication-btn {
                    width: 100%;
                    justify-content: center;
                }

                .table-wrapper {
                    display: none;
                }

                .mobile-cards {
                    display: block;
                }

                .prescription-card {
                    background: var(--white);
                    border: 1px solid var(--gray-200);
                    border-radius: var(--border-radius);
                    padding: 1.25rem;
                    margin-bottom: 1rem;
                    box-shadow: var(--shadow-sm);
                    transition: var(--transition);
                }

                .prescription-card:hover {
                    transform: translateY(-2px);
                    box-shadow: var(--shadow-md);
                }

                .card-header {
                    display: flex;
                    justify-content: space-between;
                    margin-bottom: 1rem;
                }

                .card-number {
                    background: var(--primary);
                    color: var(--white);
                    padding: 0.25rem 0.75rem;
                    border-radius: 6px;
                    font-size: 0.75rem;
                    font-weight: 600;
                }

                .card-body {
                    display: grid;
                    gap: 0.75rem;
                }

                .card-field {
                    display: flex;
                    justify-content: space-between;
                    padding-bottom: 0.5rem;
                    border-bottom: 1px solid var(--gray-100);
                }

                .card-field:last-child {
                    border-bottom: none;
                }

                .field-label {
                    font-weight: 600;
                    color: var(--gray-700);
                    font-size: 0.875rem;
                }

                .field-value {
                    font-weight: 500;
                    color: var(--gray-600);
                    text-align: right;
                    max-width: 200px;
                    overflow: hidden;
                    text-overflow: ellipsis;
                    white-space: nowrap;
                }

                .card-actions {
                    margin-top: 1rem;
                    padding-top: 1rem;
                    border-top: 1px solid var(--gray-100);
                }

                .action-buttons {
                    flex-direction: column;
                    gap: 0.75rem;
                }

                .action-btn {
                    width: 100%;
                    justify-content: center;
                    padding: 0.75rem 1.5rem;
                    min-width: unset;
                }

                .pagination-section {
                    flex-direction: column;
                    text-align: center;
                }

                .footer-content {
                    padding: 2rem 1rem 1rem;
                }

                .footer-sections {
                    grid-template-columns: 1fr;
                    gap: 1.5rem;
                }

                .footer-bottom {
                    flex-direction: column;
                    text-align: center;
                }

                .footer-bottom-links {
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
        <!-- Main Header -->
        <header class="main-header">
            <div class="header-container">
                <div class="logo-section">
                    <div class="logo">PDC</div>
                    <div class="brand-name">Phòng Khám Nha Khoa</div>
                </div>

                <nav class="nav-menu">
                    <a href="${pageContext.request.contextPath}/views/user/DoctorNurse/EmployeeDashBoard.jsp" class="nav-item">
                        <i class="fas fa-home"></i> Trang chủ
                    </a>
                    <a href="${pageContext.request.contextPath}/ViewPatientResultServlet" class="nav-item active">
                        <i class="fas fa-stethoscope"></i> Danh Sách Đơn Thuốc
                    </a>
                </nav>
            </div>
        </header>

        <!-- Main Content -->
        <main class="main-wrapper">
            <div class="dental-container">
                <!-- Dental Header Section -->
                <div class="dental-header">
                    <div class="header-content">
                        <div class="title-group">
                            <div class="dental-logo">🩺</div>
                            <div>
                                <h1 class="page-title">Danh Sách Kết Quả Khám và Toa Thuốc</h1>
                                <p class="page-subtitle">Quản lý thông tin khám bệnh và toa thuốc</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Stats Section -->
                <div class="stats-section">
                    <div class="stats-grid">
                        <div class="stat-card">
                            <div class="stat-value">${totalRecords}</div>
                            <div class="stat-label">Tổng số kết quả</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-value">${currentPage}</div>
                            <div class="stat-label">Trang hiện tại</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-value">${totalPages}</div>
                            <div class="stat-label">Tổng số trang</div>
                        </div>
                    </div>
                </div>

                <!-- Content Section -->
                <div class="content-section">
                    <!-- Search Form -->
                    <form action="${pageContext.request.contextPath}/ViewPatientResultServlet" method="get" class="search-form">
                        <input type="text" name="patientName" placeholder="Tìm theo tên bệnh nhân..." 
                               value="${patientName}" class="search-input">
                        <button type="submit" class="search-button">
                            <i class="fas fa-search"></i> Tìm kiếm
                        </button>
                        <c:if test="${not empty patientName}">
                            <a href="${pageContext.request.contextPath}/ViewPatientResultServlet" class="clear-button">
                                <i class="fas fa-times"></i> Xóa bộ lọc
                            </a>
                        </c:if>
                    </form>

                    <!-- Alert Messages -->
                    <c:if test="${not empty message}">
                        <c:choose>
                            <c:when test="${message.contains('successfully')}">
                                <div class="alert alert-success">
                                    <i class="fas fa-check-circle"></i> ${message}
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-error">
                                    <i class="fas fa-exclamation-circle"></i> ${message}
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </c:if>

                    <!-- Table Container -->
                    <div class="table-container">
                        <c:choose>
                            <c:when test="${empty results}">
                                <div class="empty-state">
                                    <div class="empty-icon"><i class="fas fa-stethoscope"></i></div>
                                    <h3 class="empty-title">
                                        <c:choose>
                                            <c:when test="${not empty patientName}">
                                                Không tìm thấy kết quả khám cho "${patientName}"
                                            </c:when>
                                            <c:otherwise>
                                                Chưa có kết quả khám
                                            </c:otherwise>
                                        </c:choose>
                                    </h3>
                                    <p class="empty-description">
                                        <c:choose>
                                            <c:when test="${not empty patientName}">
                                                Vui lòng thử tìm kiếm với từ khóa khác
                                            </c:when>
                                            <c:otherwise>
                                                Hãy thêm kết quả khám hoặc toa thuốc đầu tiên
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <!-- Desktop Table -->
                                <div class="table-wrapper">
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>STT</th>
                                                <th>Mã Lịch Hẹn</th> 
                                                <th>Mã Đơn Thuốc</th>
                                                <th>Tên Bệnh Nhân</th>
                                                <th>Tên Bác Sĩ</th>
                                                <th>Tên Y Tá</th>
                                                <th>Chẩn Đoán</th>
                                                <th>Ghi Chú</th>
                                                <th>Thao Tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="result" items="${results}" varStatus="status">
                                                <tr>
                                                    <td><span class="row-number">${(currentPage - 1) * pageSize + status.count}</span></td>
                                                    <td><div class="prescription-details">${result.appointmentId != null ? result.appointmentId : 'N/A'}</div></td>
                                                    <td><div class="prescription-details">${result.prescriptionId != null ? result.prescriptionId : 'Chưa có đơn thuốc'}</div></td>
                                                    <td><div class="prescription-details">${result.patientName}</div></td>
                                                    <td><div class="prescription-details">${result.doctorName}</div></td>
                                                    <td><div class="prescription-details">${result.nurseName != null ? result.nurseName : 'Chưa có y tá'}</div></td>
                                                    <td>
                                                        <div class="prescription-details diagnosis-cell" title="${result.diagnosis}">
                                                            ${result.diagnosis != null ? result.diagnosis : 'Chưa có chẩn đoán'}
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div class="prescription-details notes-cell" title="${result.notes}">
                                                            ${result.notes != null ? result.notes : 'Chưa có ghi chú'}
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div class="action-buttons">
                                                            <c:if test="${not result.hasPrescription}">
                                                                <a href="${pageContext.request.contextPath}/AddPrescriptionServlet?patientId=${result.patientId}&doctorId=${result.doctorId != null ? result.doctorId : 0}&resultId=${result.resultId}&appointmentId=${result.appointmentId != null ? result.appointmentId : ''}&patientName=${fn:escapeXml(result.patientName)}&doctorName=${fn:escapeXml(result.doctorName)}&diagnosis=${fn:escapeXml(result.diagnosis)}&notes=${fn:escapeXml(result.notes)}" 
                                                                   class="action-btn btn-prescribe">
                                                                    <i class="fas fa-prescription-bottle-alt"></i> Kê Đơn
                                                                </a>
                                                            </c:if>
                                                            <c:if test="${result.hasPrescription && result.prescriptionId != null}">
                                                                <a href="${pageContext.request.contextPath}/ViewPrescriptionDetailServlet?prescriptionId=${result.prescriptionId}" 
                                                                   class="action-btn btn-view">
                                                                    <i class="fas fa-eye"></i> Xem Chi Tiết
                                                                </a>
                                                            </c:if>
                                                            
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Mobile Cards -->
                                <div class="mobile-cards">
                                    <c:forEach var="result" items="${results}" varStatus="status">
                                        <div class="prescription-card">
                                            <div class="card-header">
                                                <div class="prescription-details">Result #${result.resultId}</div>
                                                <div class="card-number">#${(currentPage - 1) * pageSize + status.count}</div>
                                            </div>
                                            <div class="card-body">
                                                <div class="card-field">
                                                    <span class="field-label">Mã Lịch Hẹn:</span>
                                                    <span class="field-value">${result.appointmentId != null ? result.appointmentId : 'N/A'}</span>
                                                </div>
                                                <div class="card-field">
                                                    <span class="field-label">Mã Đơn Thuốc:</span>
                                                    <span class="field-value">${result.prescriptionId != null ? result.prescriptionId : 'Chưa có đơn thuốc'}</span>
                                                </div>
                                                <div class="card-field">
                                                    <span class="field-label">Bệnh nhân:</span>
                                                    <span class="field-value">${result.patientName}</span>
                                                </div>
                                                <div class="card-field">
                                                    <span class="field-label">Bác sĩ:</span>
                                                    <span class="field-value">${result.doctorName}</span>
                                                </div>
                                                <div class="card-field">
                                                    <span class="field-label">Y tá:</span>
                                                    <span class="field-value">${result.nurseName != null ? result.nurseName : 'Chưa có y tá'}</span>
                                                </div>
                                                <div class="card-field">
                                                    <span class="field-label">Chẩn đoán:</span>
                                                    <span class="field-value" title="${result.diagnosis}">
                                                        ${result.diagnosis != null ? result.diagnosis : 'Chưa có chẩn đoán'}
                                                    </span>
                                                </div>
                                                <div class="card-field">
                                                    <span class="field-label">Ghi chú:</span>
                                                    <span class="field-value" title="${result.notes}">
                                                        ${result.notes != null ? result.notes : 'Chưa có ghi chú'}
                                                    </span>
                                                </div>
                                            </div>
                                            <div class="card-actions">
                                                <div class="action-buttons">
                                                    <c:if test="${not result.hasPrescription}">
                                                        <a href="${pageContext.request.contextPath}/AddPrescriptionServlet?patientId=${result.patientId}&doctorId=${result.doctorId != null ? result.doctorId : 0}&resultId=${result.resultId}&appointmentId=${result.appointmentId != null ? result.appointmentId : ''}&patientName=${fn:escapeXml(result.patientName)}&doctorName=${fn:escapeXml(result.doctorName)}&diagnosis=${fn:escapeXml(result.diagnosis)}&notes=${fn:escapeXml(result.notes)}" 
                                                           class="action-btn btn-prescribe">
                                                            <i class="fas fa-prescription-bottle-alt"></i> Kê Đơn
                                                        </a>
                                                    </c:if>
                                                    <c:if test="${result.hasPrescription && result.prescriptionId != null}">
                                                        <a href="${pageContext.request.contextPath}/ViewPrescriptionDetailServlet?prescriptionId=${result.prescriptionId}" 
                                                           class="action-btn btn-view">
                                                            <i class="fas fa-eye"></i> Xem Chi Tiết
                                                        </a>
                                                    </c:if>
                                                    <a href="${pageContext.request.contextPath}/EditPrescriptionNoteServlet?resultId=${result.resultId}&patientId=${result.patientId}&doctorId=${result.doctorId}" 
                                                       class="action-btn btn-edit">
                                                        <i class="fas fa-edit"></i> Sửa
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Pagination Section -->
                <c:if test="${not empty results and totalPages > 1}">
                    <div class="pagination-section">
                        <div class="pagination-info">
                            Hiển thị <strong>${(currentPage - 1) * pageSize + 1}</strong> - 
                            <strong>${currentPage * pageSize > totalRecords ? totalRecords : currentPage * pageSize}</strong> 
                            trong tổng số <strong>${totalRecords}</strong> kết quả
                            <c:if test="${not empty patientName}">
                                cho "<strong>${patientName}</strong>"
                            </c:if>
                        </div>
                        <div class="pagination-controls">
                            <c:choose>
                                <c:when test="${currentPage > 1}">
                                    <a href="${pageContext.request.contextPath}/ViewPatientResultServlet?page=1${not empty patientName ? '&patientName=' : ''}${not empty patientName ? fn:escapeXml(patientName) : ''}" 
                                       class="page-btn"><i class="fas fa-angle-double-left"></i></a>
                                    <a href="${pageContext.request.contextPath}/ViewPatientResultServlet?page=${currentPage - 1}${not empty patientName ? '&patientName=' : ''}${not empty patientName ? fn:escapeXml(patientName) : ''}" 
                                       class="page-btn"><i class="fas fa-angle-left"></i></a>
                                </c:when>
                                <c:otherwise>
                                    <span class="page-btn disabled"><i class="fas fa-angle-double-left"></i></span>
                                    <span class="page-btn disabled"><i class="fas fa-angle-left"></i></span>
                                </c:otherwise>
                            </c:choose>

                            <c:set var="startPage" value="${currentPage - 2 > 0 ? currentPage - 2 : 1}"/>
                            <c:set var="endPage" value="${currentPage + 2 < totalPages ? currentPage + 2 : totalPages}"/>
                            <c:if test="${startPage > 1}">
                                <a href="${pageContext.request.contextPath}/ViewPatientResultServlet?page=1${not empty patientName ? '&patientName=' : ''}${not empty patientName ? fn:escapeXml(patientName) : ''}" 
                                   class="page-btn">1</a>
                                <c:if test="${startPage > 2}">
                                    <span class="page-btn">...</span>
                                </c:if>
                            </c:if>
                            <c:forEach var="i" begin="${startPage}" end="${endPage}">
                                <c:choose>
                                    <c:when test="${i == currentPage}">
                                        <span class="page-btn active">${i}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/ViewPatientResultServlet?page=${i}${not empty patientName ? '&patientName=' : ''}${not empty patientName ? fn:escapeXml(patientName) : ''}" 
                                           class="page-btn">${i}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                            <c:if test="${endPage < totalPages}">
                                <c:if test="${endPage < totalPages - 1}">
                                    <span class="page-btn">...</span>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/ViewPatientResultServlet?page=${totalPages}${not empty patientName ? '&patientName=' : ''}${not empty patientName ? fn:escapeXml(patientName) : ''}" 
                                   class="page-btn">${totalPages}</a>
                            </c:if>

                            <c:choose>
                                <c:when test="${currentPage < totalPages}">
                                    <a href="${pageContext.request.contextPath}/ViewPatientResultServlet?page=${currentPage + 1}${not empty patientName ? '&patientName=' : ''}${not empty patientName ? fn:escapeXml(patientName) : ''}" 
                                       class="page-btn"><i class="fas fa-angle-right"></i></a>
                                    <a href="${pageContext.request.contextPath}/ViewPatientResultServlet?page=${totalPages}${not empty patientName ? '&patientName=' : ''}${not empty patientName ? fn:escapeXml(patientName) : ''}" 
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
        </main>

        <!-- Footer -->
        <footer class="main-footer">
            <div class="footer-content">
                <div class="footer-sections">
                    <div class="footer-section">
                        <h3>Về Chúng Tôi</h3>
                        <p>Chúng tôi cam kết mang đến dịch vụ y tế chất lượng với đội ngũ bác sĩ tận tâm.</p>
                    </div>
                    <div class="footer-section">
                        <h3>Liên Kết Nhanh</h3>
                        <ul class="footer-links">
                            <li><a href="/ViewExaminationResults"><i class="fas fa-stethoscope"></i> Kết Quả Khám</a></li>
                            <li><a href="/ViewMedicationsServlet"><i class="fas fa-pills"></i> Danh Sách Thuốc</a></li>
                            <li><a href="/ViewPatientResults"><i class="fas fa-prescription"></i> Kê Đơn Thuốc</a></li>
                            <li><a href="/ViewScheduleUserServlet"><i class="fas fa-calendar-check"></i> Lịch Làm Việc</a></li>
                            <li><a href="/ViewRoomServlet"><i class="fas fa-door-open"></i> Quản Lý Phòng</a></li>
                        </ul>
                    </div>

                    <div class="footer-section">
                        <h3>Liên Hệ</h3>
                        <div class="contact-info">
                            <div class="contact-item">
                                <i class="fas fa-map-marker-alt contact-icon"></i>
                                <span>DH FPT, Hòa Lạc</span>
                            </div>
                            <div class="contact-item">
                                <i class="fas fa-phone contact-icon"></i>
                                <span>(098) 1234 5678</span>
                            </div>
                            <div class="contact-item">
                                <i class="fas fa-envelope contact-icon"></i>
                                <span>PhongKhamPDC@gmail.com</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="footer-bottom">
                    <div class="copyright">
                        © 2025 Phòng Khám PDC. Tất cả quyền được bảo lưu.
                    </div>
                </div>
            </div>
        </footer>
    </body>
</html>
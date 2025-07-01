<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
    <head>
        <title>Danh Sách Toa Thuốc</title>
        <link href="https://fonts.googleapis.com/css2?family=Satoshi:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            :root {
                --primary: #667eea;
                --primary-dark: #5a67d8;
                --secondary: #764ba2;
                --accent: #f093fb;
                --success: #10b981;
                --warning: #f59e0b;
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
                --gradient-primary: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                --gradient-surface: linear-gradient(145deg, #ffffff 0%, #f8fafc 100%);
                --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
                --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
                --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
                --shadow-xl: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);
                --shadow-2xl: 0 25px 50px -12px rgb(0 0 0 / 0.25);
                --border-radius: 20px;
                --border-radius-lg: 24px;
                --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Satoshi', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
                background-color: #f4f7fa;
                min-height: 100vh;
                padding: 2rem;
                position: relative;
                overflow-x: hidden;
            }

            .dental-container {
                background: #ffffff;
                border: 1px solid #e5e7eb;
                border-radius: var(--border-radius-lg);
                box-shadow: var(--shadow-2xl);
                width: 100%;
                max-width: 1400px;
                margin: 0 auto;
                position: relative;
                overflow: hidden;
                animation: slideUp 0.6s cubic-bezier(0.16, 1, 0.3, 1);
            }

            @keyframes slideUp {
                from {
                    opacity: 0;
                    transform: translateY(40px) scale(0.98);
                }
                to {
                    opacity: 1;
                    transform: translateY(0) scale(1);
                }
            }

            .dental-header {
                background: var(--gradient-primary);
                padding: 2rem 3rem 1.5rem;
                position: relative;
                overflow: hidden;
            }

            .dental-header::before {
                content: '';
                position: absolute;
                top: -50%;
                right: -20%;
                width: 300px;
                height: 300px;
                background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
                border-radius: 50%;
            }

            .header-content {
                position: relative;
                z-index: 2;
                display: flex;
                justify-content: space-between;
                align-items: center;
                gap: 2rem;
            }

            .title-group {
                display: flex;
                align-items: center;
                gap: 1rem;
            }

            .dental-logo {
                width: 50px;
                height: 50px;
                background: rgba(255, 255, 255, 0.2);
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                backdrop-filter: blur(10px);
                border: 1px solid rgba(255, 255, 255, 0.3);
            }

            .dental-logo::before {
                content: '🦷';
                font-size: 1.5rem;
                filter: drop-shadow(0 2px 4px rgba(0,0,0,0.1));
            }

            .page-title {
                color: var(--white);
                font-size: 2rem;
                font-weight: 700;
                margin-bottom: 0.25rem;
                text-shadow: 0 2px 4px rgba(0,0,0,0.1);
                letter-spacing: -0.025em;
            }

            .page-subtitle {
                color: rgba(255, 255, 255, 0.9);
                font-size: 1rem;
                font-weight: 400;
                opacity: 0.9;
            }

            .add-medication-btn {
                background: var(--gradient-primary);
                color: var(--white);
                padding: 0.875rem 1.5rem;
                border: none;
                border-radius: var(--border-radius);
                font-weight: 600;
                font-size: 0.875rem;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                transition: var(--transition);
                box-shadow: var(--shadow-md);
            }

            .add-medication-btn:hover {
                transform: translateY(-2px);
                box-shadow: var(--shadow-lg);
                background: linear-gradient(135deg, var(--primary-dark), var(--secondary));
            }

            .stats-section {
                padding: 2rem;
                background: var(--gray-50);
                border-bottom: 1px solid var(--gray-200);
            }

            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 1.5rem;
            }

            .stat-card {
                background: var(--white);
                padding: 1.5rem;
                border-radius: var(--border-radius);
                box-shadow: var(--shadow-sm);
                border: 1px solid var(--gray-200);
                transition: var(--transition);
            }

            .stat-card:hover {
                box-shadow: var(--shadow-md);
                transform: translateY(-1px);
            }

            .stat-value {
                font-size: 2rem;
                font-weight: 700;
                color: var(--primary);
                line-height: 1;
            }

            .stat-label {
                font-size: 0.875rem;
                color: var(--gray-600);
                margin-top: 0.5rem;
            }

            .content-section {
                padding: 2rem;
            }

            .alert {
                padding: 1rem 1.25rem;
                border-radius: var(--border-radius);
                margin-bottom: 1.5rem;
                display: flex;
                align-items: center;
                gap: 0.75rem;
                font-weight: 500;
                animation: fadeIn 0.3s ease;
            }

            .alert-success {
                background: linear-gradient(135deg, rgba(16, 185, 129, 0.1) 0%, rgba(52, 211, 153, 0.1) 100%);
                color: var(--success);
                border: 1px solid rgba(16, 185, 129, 0.2);
            }

            .alert-error {
                background: linear-gradient(135deg, rgba(239, 68, 68, 0.1) 0%, rgba(248, 113, 113, 0.1) 100%);
                color: var(--error);
                border: 1px solid rgba(239, 68, 68, 0.2);
            }

            .alert-icon {
                font-size: 1.125rem;
            }

            .table-container {
                background: var(--white);
                border-radius: var(--border-radius-lg);
                overflow: hidden;
                box-shadow: var(--shadow-sm);
                border: 1px solid var(--gray-200);
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
                background: var(--gradient-surface);
                color: var(--gray-700);
                font-weight: 600;
                text-transform: uppercase;
                font-size: 0.75rem;
                letter-spacing: 0.05em;
                padding: 1.25rem 1.5rem;
                text-align: left;
                border-bottom: 2px solid var(--gray-200);
                position: sticky;
                top: 0;
                z-index: 10;
            }

            tbody tr {
                border-bottom: 1px solid var(--gray-100);
                transition: var(--transition);
            }

            tbody tr:hover {
                background-color: var(--gray-50);
                transform: scale(1.001);
            }

            tbody tr:last-child {
                border-bottom: none;
            }

            td {
                padding: 1.25rem 1.5rem;
                vertical-align: middle;
            }

            .row-number {
                font-weight: 600;
                color: var(--gray-500);
                font-size: 0.8125rem;
            }

            .prescription-details {
                font-weight: 600;
                color: var(--gray-900);
                font-size: 0.9375rem;
            }

            .status {
                display: inline-flex;
                align-items: center;
                padding: 0.375rem 0.75rem;
                background: rgba(102, 126, 234, 0.1);
                color: var(--primary);
                border-radius: 20px;
                font-size: 0.75rem;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.025em;
            }

            .action-buttons {
                display: flex;
                gap: 0.5rem;
                align-items: center;
            }

            .action-btn {
                padding: 0.5rem 1rem;
                border-radius: 8px;
                font-size: 0.8125rem;
                font-weight: 500;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 0.375rem;
                transition: var(--transition);
                border: 1px solid transparent;
                white-space: nowrap;
            }

            .btn-view {
                background: rgba(102, 126, 234, 0.1);
                color: var(--primary);
                border-color: rgba(102, 126, 234, 0.1);
            }

            .btn-view:hover {
                background: var(--primary);
                color: var(--white);
                transform: translateY(-1px);
                box-shadow: var(--shadow-md);
            }

            .empty-state {
                text-align: center;
                padding: 4rem 2rem;
                color: var(--gray-500);
            }

            .empty-icon {
                font-size: 4rem;
                color: var(--gray-300);
                margin-bottom: 1rem;
            }

            .empty-title {
                font-size: 1.25rem;
                font-weight: 600;
                color: var(--gray-700);
                margin-bottom: 0.5rem;
            }

            .empty-description {
                font-size: 0.875rem;
                color: var(--gray-500);
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
                color: var(--gray-600);
                font-size: 0.875rem;
                font-weight: 500;
            }

            .pagination-controls {
                display: flex;
                gap: 0.25rem;
                align-items: center;
            }

            .page-btn {
                padding: 0.5rem 0.75rem;
                border-radius: 8px;
                border: 1px solid var(--gray-200);
                background: var(--white);
                color: var(--gray-700);
                text-decoration: none;
                font-weight: 500;
                font-size: 0.875rem;
                transition: var(--transition);
                min-width: 40px;
                text-align: center;
                display: inline-flex;
                align-items: center;
                justify-content: center;
            }

            .page-btn:hover:not(.disabled):not(.active) {
                background: var(--gray-100);
                border-color: var(--gray-300);
                transform: translateY(-1px);
            }

            .page-btn.active {
                background: var(--primary);
                color: var(--white);
                border-color: var(--primary);
                box-shadow: var(--shadow-sm);
            }

            .page-btn.disabled {
                background: var(--gray-100);
                color: var(--gray-400);
                cursor: not-allowed;
                border-color: var(--gray-200);
            }

            .page-dots {
                color: var(--gray-400);
                padding: 0.5rem;
                font-weight: 600;
            }

            @media (max-width: 1024px) {
                .header-content {
                    flex-direction: column;
                    text-align: center;
                    gap: 1.5rem;
                }

                .stats-grid {
                    grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
                }
            }

            @media (max-width: 768px) {
                body {
                    padding: 1rem 0.5rem;
                }

                .dental-container {
                    border-radius: var(--border-radius);
                }

                .dental-header {
                    padding: 2rem 1.5rem;
                }

                .content-section {
                    padding: 1.5rem;
                }

                .page-title {
                    font-size: 1.75rem;
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
                    gap: 1rem;
                }

                .prescription-card {
                    background: var(--white);
                    border: 1px solid var(--gray-200);
                    border-radius: var(--border-radius);
                    padding: 1.5rem;
                    margin-bottom: 1rem;
                    box-shadow: var(--shadow-sm);
                    transition: var(--transition);
                }

                .prescription-card:hover {
                    box-shadow: var(--shadow-md);
                    transform: translateY(-1px);
                }

                .card-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: flex-start;
                    margin-bottom: 1rem;
                }

                .card-number {
                    background: rgba(102, 126, 234, 0.1);
                    color: var(--primary);
                    padding: 0.25rem 0.5rem;
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
                    align-items: center;
                    padding-bottom: 0.5rem;
                    border-bottom: 1px solid var(--gray-100);
                }

                .card-field:last-child {
                    border-bottom: none;
                    padding-bottom: 0;
                }

                .field-label {
                    font-weight: 600;
                    color: var(--gray-700);
                    font-size: 0.8125rem;
                }

                .field-value {
                    font-weight: 500;
                    color: var(--gray-600);
                    text-align: right;
                    max-width: 60%;
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
                    padding: 0.75rem 1rem;
                }

                .pagination-section {
                    flex-direction: column;
                    text-align: center;
                    padding: 1.5rem;
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

            .loading {
                display: inline-block;
                width: 20px;
                height: 20px;
                border: 2px solid var(--gray-300);
                border-radius: 50%;
                border-top-color: var(--primary);
                animation: spin 1s ease-in-out infinite;
            }

            @keyframes spin {
                to {
                    transform: rotate(360deg);
                }
            }
        </style>
    </head>
    <body>
        <div class="dental-container">
            <!-- Header Section -->
            <div class="dental-header">
                <div class="header-content">
                    <div class="title-group">
                        <div class="dental-logo"></div>
                        <div>
                            <h1 class="page-title">Danh Sách Toa Thuốc</h1>
                            <p class="page-subtitle">Quản lý thông tin toa thuốc trong hệ thống</p>
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}/AddPrescriptionServlet" class="add-medication-btn">
                        <i class="fas fa-plus"></i>
                        Thêm Toa Thuốc
                    </a>
                </div>
            </div>

            <!-- Stats Section -->
            <div class="stats-section">
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-value">${totalRecords}</div>
                        <div class="stat-label">Tổng số toa thuốc</div>
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
                <form action="${pageContext.request.contextPath}/SearchPrescriptionsServlet" method="get" style="margin-bottom: 2rem;">
                    <div style="display: flex; gap: 1rem; flex-wrap: wrap; align-items: center;">
                        <input type="text" name="keyword" placeholder="Tìm theo chi tiết toa thuốc, tên bệnh nhân, hoặc tên bác sĩ..." 
                               value="${param.keyword}" 
                               style="flex: 1; padding: 0.75rem 1rem; border-radius: 8px; border: 1px solid var(--gray-200); font-size: 0.9rem;">
                        <button type="submit" style="background: var(--primary); color: var(--white); padding: 0.75rem 1.25rem; border-radius: 8px; border: none; font-weight: 600; cursor: pointer;">
                            <i class="fas fa-search"></i> Tìm kiếm
                        </button>
                    </div>
                </form>

                <!-- Alert Messages -->
                <c:if test="${not empty sessionScope.statusMessage}">
                    <c:choose>
                        <c:when test="${sessionScope.statusMessage == 'Tạo thành công'}">
                            <div class="alert alert-success">
                                <i class="fas fa-check-circle alert-icon"></i>
                                ${sessionScope.statusMessage}
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-error">
                                <i class="fas fa-exclamation-circle alert-icon"></i>
                                ${sessionScope.statusMessage}
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <c:remove var="statusMessage" scope="session"/>
                </c:if>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-triangle alert-icon"></i>
                        ${errorMessage}
                    </div>
                </c:if>

                <!-- Table Container -->
                <div class="table-container">
                    <c:choose>
                        <c:when test="${empty prescriptions}">
                            <div class="empty-state">
                                <div class="empty-icon">
                                    <i class="fas fa-prescription"></i>
                                </div>
                                <h3 class="empty-title">Chưa có toa thuốc nào</h3>
                                <p class="empty-description">Hãy thêm toa thuốc đầu tiên vào hệ thống</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Desktop Table -->
                            <div class="table-wrapper">
                                <table>
                                    <thead>
                                        <tr>
                                            <th>STT</th>
                                            <th>ID Toa Thuốc</th>
                                            <th>Tên Bệnh Nhân</th>
                                            <th>Tên Bác Sĩ</th>
                                            <th>Trạng Thái</th>
                                            <th>Thao Tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="prescription" items="${prescriptions}" varStatus="status">
                                            <tr>
                                                <td>
                                                    <span class="row-number">
                                                        ${(currentPage - 1) * 10 + status.count}
                                                    </span>
                                                </td>
                                                <td>
                                                    <div class="prescription-details">${prescription.prescriptionId}</div>
                                                </td>
                                                <td>
                                                    <div class="prescription-details">${prescription.patientName}</div>
                                                </td>
                                                <td>
                                                    <div class="prescription-details">${prescription.doctorName}</div>
                                                </td>
                                                <td>
                                                    <span class="status">${prescription.status}</span>
                                                </td>
                                                <td>
                                                    <div class="action-buttons">
                                                        <a href="${pageContext.request.contextPath}/ViewPrescriptionDetailsServlet?id=${prescription.prescriptionId}" 
                                                           class="action-btn btn-view">
                                                            <i class="fas fa-eye"></i>
                                                            Chi tiết
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <!-- Mobile Cards -->
                            <div class="mobile-cards">
                                <c:forEach var="prescription" items="${prescriptions}" varStatus="status">
                                    <div class="prescription-card">
                                        <div class="card-header">
                                            <div class="prescription-details">${prescription.prescriptionId}</div>
                                            <div class="card-number">#${(currentPage - 1) * 10 + status.count}</div>
                                        </div>
                                        <div class="card-body">
                                            <div class="card-field">
                                                <span class="field-label">Tên Bệnh Nhân:</span>
                                                <span class="field-value">${prescription.patientName}</span>
                                            </div>
                                            <div class="card-field">
                                                <span class="field-label">Tên Bác Sĩ:</span>
                                                <span class="field-value">${prescription.doctorName}</span>
                                            </div>
                                            <div class="card-field">
                                                <span class="field-label">Trạng Thái:</span>
                                                <span class="status">${prescription.status}</span>
                                            </div>
                                        </div>
                                        <div class="card-actions">
                                            <div class="action-buttons">
                                                <a href="${pageContext.request.contextPath}/ViewPrescriptionDetailsServlet?id=${prescription.prescriptionId}" 
                                                   class="action-btn btn-view">
                                                    <i class="fas fa-eye"></i>
                                                    Xem chi tiết
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
            <c:if test="${not empty prescriptions and totalPages > 1}">
                <div class="pagination-section">
                    <div class="pagination-info">
                        Hiển thị <strong>${(currentPage - 1) * 10 + 1}</strong> - 
                        <strong>${currentPage * 10 > totalRecords ? totalRecords : currentPage * 10}</strong> 
                        trong tổng số <strong>${totalRecords}</strong> toa thuốc
                    </div>
                    <div class="pagination-controls">
                        <!-- First & Previous -->
                        <c:choose>
                            <c:when test="${currentPage > 1}">
                                <a href="${pageContext.request.contextPath}/ViewPrescriptionsServlet?page=1" class="page-btn">
                                    <i class="fas fa-angle-double-left"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/ViewPrescriptionsServlet?page=${currentPage - 1}" class="page-btn">
                                    <i class="fas fa-angle-left"></i>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <span class="page-btn disabled">
                                    <i class="fas fa-angle-double-left"></i>
                                </span>
                                <span class="page-btn disabled">
                                    <i class="fas fa-angle-left"></i>
                                </span>
                            </c:otherwise>
                        </c:choose>

                        <!-- Page Numbers -->
                        <c:set var="startPage" value="${currentPage - 2 > 0 ? currentPage - 2 : 1}"/>
                        <c:set var="endPage" value="${currentPage + 2 < totalPages ? currentPage + 2 : totalPages}"/>
                        <c:if test="${startPage > 1}">
                            <a href="${pageContext.request.contextPath}/ViewPrescriptionsServlet?page=1" class="page-btn">1</a>
                            <c:if test="${startPage > 2}">
                                <span class="page-dots">...</span>
                            </c:if>
                        </c:if>
                        <c:forEach var="i" begin="${startPage}" end="${endPage}">
                            <c:choose>
                                <c:when test="${i == currentPage}">
                                    <span class="page-btn active">${i}</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/ViewPrescriptionsServlet?page=${i}" class="page-btn">${i}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                        <c:if test="${endPage < totalPages}">
                            <c:if test="${endPage < totalPages - 1}">
                                <span class="page-dots">...</span>
                            </c:if>
                            <a href="${pageContext.request.contextPath}/ViewPrescriptionsServlet?page=${totalPages}" class="page-btn">${totalPages}</a>
                        </c:if>

                        <!-- Next & Last -->
                        <c:choose>
                            <c:when test="${currentPage < totalPages}">
                                <a href="${pageContext.request.contextPath}/ViewPrescriptionsServlet?page=${currentPage + 1}" class="page-btn">
                                    <i class="fas fa-angle-right"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/ViewPrescriptionsServlet?page=${totalPages}" class="page-btn">
                                    <i class="fas fa-angle-double-right"></i>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <span class="page-btn disabled">
                                    <i class="fas fa-angle-right"></i>
                                </span>
                                <span class="page-btn disabled">
                                    <i class="fas fa-angle-double-right"></i>
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:if>
        </div>
    </body>
</html>
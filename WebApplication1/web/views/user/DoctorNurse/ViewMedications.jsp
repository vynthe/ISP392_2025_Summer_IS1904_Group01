<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
    <head>
        <title>Danh Sách Thuốc</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            :root {
                --primary-blue: #2563eb;
                --primary-blue-dark: #1d4ed8;
                --primary-blue-light: #dbeafe;
                --secondary-indigo: #4f46e5;
                --accent-emerald: #10b981;
                --accent-amber: #f59e0b;
                --neutral-50: #f8fafc;
                --neutral-100: #f1f5f9;
                --neutral-200: #e2e8f0;
                --neutral-300: #cbd5e1;
                --neutral-400: #94a3b8;
                --neutral-600: #475569;
                --neutral-700: #334155;
                --neutral-800: #1e293b;
                --neutral-900: #0f172a;
                --error-red: #ef4444;
                --success-green: #22c55e;
                --warning-orange: #f97316;
                --white: #ffffff;
                --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
                --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
                --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
                --shadow-xl: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);
                --border-radius: 12px;
                --border-radius-lg: 16px;
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                background: linear-gradient(135deg, var(--primary-blue) 0%, var(--secondary-indigo) 100%);
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
                color: var(--neutral-800);
                min-height: 100vh;
                padding: 2rem 1rem;
                line-height: 1.6;
            }

            .main-container {
                max-width: 1400px;
                margin: 0 auto;
                background: var(--white);
                border-radius: var(--border-radius-lg);
                box-shadow: var(--shadow-xl);
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

            /* Header Section */
            .header-section {
                background: linear-gradient(135deg, var(--neutral-50) 0%, var(--primary-blue-light) 100%);
                padding: 2.5rem 2rem;
                border-bottom: 1px solid var(--neutral-200);
            }

            .header-content {
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

            .title-icon {
                width: 48px;
                height: 48px;
                background: linear-gradient(135deg, var(--primary-blue), var(--secondary-indigo));
                border-radius: var(--border-radius);
                display: flex;
                align-items: center;
                justify-content: center;
                color: var(--white);
                font-size: 1.5rem;
            }

            .page-title {
                font-size: 2rem;
                font-weight: 700;
                color: var(--neutral-900);
                letter-spacing: -0.025em;
            }

            .page-subtitle {
                font-size: 0.875rem;
                color: var(--neutral-600);
                margin-top: 0.25rem;
            }

            .add-medication-btn {
                background: linear-gradient(135deg, var(--primary-blue), var(--primary-blue-dark));
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
                transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
                box-shadow: var(--shadow-md);
            }

            .add-medication-btn:hover {
                transform: translateY(-2px);
                box-shadow: var(--shadow-lg);
                background: linear-gradient(135deg, var(--primary-blue-dark), var(--secondary-indigo));
            }

            /* Stats Cards */
            .stats-section {
                padding: 2rem;
                background: var(--neutral-50);
                border-bottom: 1px solid var(--neutral-200);
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
                border: 1px solid var(--neutral-200);
                transition: all 0.2s ease;
            }

            .stat-card:hover {
                box-shadow: var(--shadow-md);
                transform: translateY(-1px);
            }

            .stat-value {
                font-size: 2rem;
                font-weight: 700;
                color: var(--primary-blue);
                line-height: 1;
            }

            .stat-label {
                font-size: 0.875rem;
                color: var(--neutral-600);
                margin-top: 0.5rem;
            }

            /* Content Section */
            .content-section {
                padding: 2rem;
            }

            /* Alert Messages */
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
                background-color: #ecfdf5;
                color: #065f46;
                border: 1px solid #a7f3d0;
            }

            .alert-error {
                background-color: #fef2f2;
                color: #991b1b;
                border: 1px solid #fecaca;
            }

            .alert-icon {
                font-size: 1.125rem;
            }

            /* Table Container */
            .table-container {
                background: var(--white);
                border-radius: var(--border-radius-lg);
                overflow: hidden;
                box-shadow: var(--shadow-sm);
                border: 1px solid var(--neutral-200);
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
                background: linear-gradient(135deg, var(--neutral-100), var(--neutral-50));
                color: var(--neutral-700);
                font-weight: 600;
                text-transform: uppercase;
                font-size: 0.75rem;
                letter-spacing: 0.05em;
                padding: 1.25rem 1.5rem;
                text-align: left;
                border-bottom: 2px solid var(--neutral-200);
                position: sticky;
                top: 0;
                z-index: 10;
            }

            tbody tr {
                border-bottom: 1px solid var(--neutral-100);
                transition: all 0.15s ease;
            }

            tbody tr:hover {
                background-color: var(--neutral-50);
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
                color: var(--neutral-500);
                font-size: 0.8125rem;
            }

            .medication-name {
                font-weight: 600;
                color: var(--neutral-900);
                font-size: 0.9375rem;
            }

            .dosage-info {
                color: var(--neutral-600);
                font-weight: 500;
            }

            .dosage-form {
                display: inline-flex;
                align-items: center;
                padding: 0.375rem 0.75rem;
                background: var(--primary-blue-light);
                color: var(--primary-blue);
                border-radius: 20px;
                font-size: 0.75rem;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.025em;
            }

            .manufacturer {
                color: var(--neutral-700);
                font-weight: 500;
            }

            /* Action Buttons */
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
                transition: all 0.2s ease;
                border: 1px solid transparent;
                white-space: nowrap;
            }

            .btn-view {
                background: var(--primary-blue-light);
                color: var(--primary-blue);
                border-color: var(--primary-blue-light);
            }

            .btn-view:hover {
                background: var(--primary-blue);
                color: var(--white);
                transform: translateY(-1px);
                box-shadow: var(--shadow-md);
            }

            .btn-import {
                background: #ecfdf5;
                color: var(--accent-emerald);
                border-color: #a7f3d0;
            }

            .btn-import:hover {
                background: var(--accent-emerald);
                color: var(--white);
                transform: translateY(-1px);
                box-shadow: var(--shadow-md);
            }

            /* Empty State */
            .empty-state {
                text-align: center;
                padding: 4rem 2rem;
                color: var(--neutral-500);
            }

            .empty-icon {
                font-size: 4rem;
                color: var(--neutral-300);
                margin-bottom: 1rem;
            }

            .empty-title {
                font-size: 1.25rem;
                font-weight: 600;
                color: var(--neutral-700);
                margin-bottom: 0.5rem;
            }

            .empty-description {
                font-size: 0.875rem;
                color: var(--neutral-500);
            }

            /* Pagination */
            .pagination-section {
                padding: 1.5rem 2rem;
                background: var(--neutral-50);
                border-top: 1px solid var(--neutral-200);
                display: flex;
                justify-content: between;
                align-items: center;
                flex-wrap: wrap;
                gap: 1rem;
            }

            .pagination-info {
                color: var(--neutral-600);
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
                border: 1px solid var(--neutral-200);
                background: var(--white);
                color: var(--neutral-700);
                text-decoration: none;
                font-weight: 500;
                font-size: 0.875rem;
                transition: all 0.2s ease;
                min-width: 40px;
                text-align: center;
                display: inline-flex;
                align-items: center;
                justify-content: center;
            }

            .page-btn:hover:not(.disabled):not(.active) {
                background: var(--neutral-100);
                border-color: var(--neutral-300);
                transform: translateY(-1px);
            }

            .page-btn.active {
                background: var(--primary-blue);
                color: var(--white);
                border-color: var(--primary-blue);
                box-shadow: var(--shadow-sm);
            }

            .page-btn.disabled {
                background: var(--neutral-100);
                color: var(--neutral-400);
                cursor: not-allowed;
                border-color: var(--neutral-200);
            }

            .page-dots {
                color: var(--neutral-400);
                padding: 0.5rem;
                font-weight: 600;
            }

            /* Responsive Design */
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

                .main-container {
                    border-radius: var(--border-radius);
                }

                .header-section {
                    padding: 2rem 1.5rem;
                }

                .content-section,
                .stats-section {
                    padding: 1.5rem;
                }

                .page-title {
                    font-size: 1.75rem;
                }

                .add-medication-btn {
                    width: 100%;
                    justify-content: center;
                }

                /* Mobile Table */
                .table-wrapper {
                    display: none;
                }

                .mobile-cards {
                    display: block;
                    gap: 1rem;
                }

                .medication-card {
                    background: var(--white);
                    border: 1px solid var(--neutral-200);
                    border-radius: var(--border-radius);
                    padding: 1.5rem;
                    margin-bottom: 1rem;
                    box-shadow: var(--shadow-sm);
                    transition: all 0.2s ease;
                }

                .medication-card:hover {
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
                    background: var(--primary-blue-light);
                    color: var(--primary-blue);
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
                    border-bottom: 1px solid var(--neutral-100);
                }

                .card-field:last-child {
                    border-bottom: none;
                    padding-bottom: 0;
                }

                .field-label {
                    font-weight: 600;
                    color: var(--neutral-700);
                    font-size: 0.8125rem;
                }

                .field-value {
                    font-weight: 500;
                    color: var(--neutral-600);
                    text-align: right;
                    max-width: 60%;
                }

                .card-actions {
                    margin-top: 1rem;
                    padding-top: 1rem;
                    border-top: 1px solid var(--neutral-100);
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

            /* Loading Animation */
            .loading {
                display: inline-block;
                width: 20px;
                height: 20px;
                border: 2px solid var(--neutral-300);
                border-radius: 50%;
                border-top-color: var(--primary-blue);
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
        <div class="main-container">
            <!-- Header Section -->
            <div class="header-section">
                <div class="header-content">
                    <div class="title-group">
                        <a href="${pageContext.request.contextPath}/views/user/DoctorNurse/EmployeeDashBoard.jsp" 
                           style="background: linear-gradient(to right, #1e90ff, #63b3ed); color: white;
                           padding: 8px 20px; border-radius: 12px; text-decoration: none; font-weight: bold; margin-right: 20px;">
                            Home
                        </a>
                        <div style="margin-left: 1rem;">
                            <h1 class="page-title">Danh Sách Thuốc</h1>
                            <p class="page-subtitle">Quản lý thông tin thuốc trong hệ thống</p>
                        </div>
                    </div>



                </div>
            </div>

            <!-- Stats Section -->
            <div class="stats-section">
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-value">${totalRecords}</div>
                        <div class="stat-label">Tổng số thuốc</div>
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
                <form action="${pageContext.request.contextPath}/ViewMedicationsServlet" method="get" style="margin-bottom: 2rem;">
                    <div style="display: flex; gap: 1rem; flex-wrap: wrap; align-items: center;">
                        <!-- Ô tìm theo tên thuốc -->
                        <input type="text" name="nameKeyword" placeholder="Tìm theo tên thuốc..." 
                               value="${param.nameKeyword}" 
                               style="flex: 1; padding: 0.75rem 1rem; border-radius: 8px; border: 1px solid #ccc; font-size: 0.9rem;">

                        <!-- Ô tìm theo dạng bào chế -->
                        <input type="text" name="dosageFormKeyword" placeholder="Tìm theo dạng bào chế..." 
                               value="${param.dosageFormKeyword}" 
                               style="flex: 1; padding: 0.75rem 1rem; border-radius: 8px; border: 1px solid #ccc; font-size: 0.9rem;">

                        <!-- Nút tìm kiếm -->
                        <button type="submit" style="background: var(--primary-blue); color: white; padding: 0.75rem 1.25rem; border-radius: 8px; border: none; font-weight: 600; cursor: pointer;">
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
                        <c:when test="${empty medications}">
                            <div class="empty-state">
                                <div class="empty-icon">
                                    <i class="fas fa-pills"></i>
                                </div>
                                <h3 class="empty-title">Chưa có thuốc nào</h3>
                                <p class="empty-description">Hãy thêm thuốc đầu tiên vào hệ thống</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Desktop Table -->
                            <div class="table-wrapper">
                                <table>
                                    <thead>
                                        <tr>
                                            <th>STT</th>
                                            <th>Tên Thuốc</th>
                                            <th>Hàm Lượng</th>
                                            <th>Dạng Bào Chế</th>
                                            <th>Nhà Sản Xuất</th>
                                            <th>Thao Tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="medication" items="${medications}" varStatus="status">
                                            <tr>
                                                <td>
                                                    <span class="row-number">
                                                        ${(currentPage - 1) * 10 + status.count}
                                                    </span>
                                                </td>
                                                <td>
                                                    <div class="medication-name">${medication.name}</div>
                                                </td>
                                                <td>
                                                    <div class="dosage-info">
                                                        <c:choose>
                                                            <c:when test="${not empty medication.dosage and medication.dosage.length() > 50}">
                                                                <span title="${medication.dosage}">
                                                                    ${medication.dosage.substring(0, 50)}...
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>${medication.dosage}</c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="dosage-form">${medication.dosageForm}</span>
                                                </td>
                                                <td>
                                                    <div class="manufacturer">${medication.manufacturer}</div>
                                                </td>
                                                <td>
                                                    <div class="action-buttons">
                                                        <a href="${pageContext.request.contextPath}/ViewMedicationDetailsServlet?id=${medication.medicationID}" 
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
                                <c:forEach var="medication" items="${medications}" varStatus="status">
                                    <div class="medication-card">
                                        <div class="card-header">
                                            <div class="medication-name">${medication.name}</div>
                                            <div class="card-number">#${(currentPage - 1) * 10 + status.count}</div>
                                        </div>

                                        <div class="card-body">
                                            <div class="card-field">
                                                <span class="field-label">Hàm lượng:</span>
                                                <span class="field-value">
                                                    <c:choose>
                                                        <c:when test="${not empty medication.dosage and medication.dosage.length() > 30}">
                                                            <span title="${medication.dosage}">
                                                                ${medication.dosage.substring(0, 30)}...
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>${medication.dosage}</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>

                                            <div class="card-field">
                                                <span class="field-label">Dạng bào chế:</span>
                                                <span class="dosage-form">${medication.dosageForm}</span>
                                            </div>

                                            <div class="card-field">
                                                <span class="field-label">Nhà sản xuất:</span>
                                                <span class="field-value">${medication.manufacturer}</span>
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
            <c:if test="${not empty medications and totalPages > 1}">
                <div class="pagination-section">
                    <div class="pagination-info">
                        Hiển thị <strong>${(currentPage - 1) * 10 + 1}</strong> - 
                        <strong>${currentPage * 10 > totalRecords ? totalRecords : currentPage * 10}</strong> 
                        trong tổng số <strong>${totalRecords}</strong> thuốc
                    </div>

                    <div class="pagination-controls">
                        <!-- First & Previous -->
                        <c:choose>
                            <c:when test="${currentPage > 1}">
                                <a href="${pageContext.request.contextPath}/ViewMedicationsServlet?page=1" class="page-btn">
                                    <i class="fas fa-angle-double-left"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/ViewMedicationsServlet?page=${currentPage - 1}" class="page-btn">
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
                            <a href="${pageContext.request.contextPath}/ViewMedicationsServlet?page=1" class="page-btn">1</a>
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
                                    <a href="${pageContext.request.contextPath}/ViewMedicationsServlet?page=${i}" class="page-btn">${i}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>

                        <c:if test="${endPage < totalPages}">
                            <c:if test="${endPage < totalPages - 1}">
                                <span class="page-dots">...</span>
                            </c:if>
                            <a href="${pageContext.request.contextPath}/ViewMedicationsServlet?page=${totalPages}" class="page-btn">${totalPages}</a>
                        </c:if>

                        <!-- Next & Last -->
                        <c:choose>
                            <c:when test="${currentPage < totalPages}">
                                <a href="${pageContext.request.contextPath}/ViewMedicationsServlet?page=${currentPage + 1}" class="page-btn">
                                    <i class="fas fa-angle-right"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/ViewMedicationsServlet?page=${totalPages}" class="page-btn">
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
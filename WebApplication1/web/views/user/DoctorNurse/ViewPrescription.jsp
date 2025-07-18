<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
    <head>
        <title>Danh Sách Toa Thuốc</title>
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
                padding: 2rem;
                color: var(--gray-900);
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
                from { opacity: 0; transform: translateY(20px); }
                to { opacity: 1; transform: translateY(0); }
            }

            .dental-header {
                background: var(--gradient-primary);
                padding: 2rem;
                position: relative;
                color: var(--white);
            }

            .header-content {
                display: flex;
                justify-content: space-between;
                align-items: center;
                flex-wrap: wrap;
                gap: 1.5rem;
            }

            .title-group {
                display: flex;
                align-items: center;
                gap: 1rem;
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

            .action-buttons {
                display: flex;
                gap: 0.5rem;
            }

            .action-btn {
                padding: 0.5rem 1rem;
                border-radius: var(--border-radius);
                font-size: 0.875rem;
                font-weight: 500;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                transition: var(--transition);
            }

            .btn-view {
                background: var(--primary);
                color: var(--white);
                border: none;
            }

            .btn-view:hover {
                background: var(--primary-dark);
                transform: translateY(-1px);
                box-shadow: var(--shadow-sm);
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

            @media (max-width: 768px) {
                body {
                    padding: 1rem;
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
                }

                .card-actions {
                    margin-top: 1rem;
                    padding-top: 1rem;
                    border-top: 1px solid var(--gray-100);
                }

                .action-buttons {
                    flex-direction: column;
                }

                .action-btn {
                    width: 100%;
                    justify-content: center;
                }

                .pagination-section {
                    flex-direction: column;
                    text-align: center;
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
        <div class="dental-container">
            <!-- Header Section -->
            <div class="dental-header">
                <div class="header-content">
                    <div class="title-group">
                        <div class="dental-logo">🦷</div>
                        <div>
                            <h1 class="page-title">Danh Sách Toa Thuốc</h1>
                            <p class="page-subtitle">Quản lý thông tin toa thuốc trong hệ thống</p>
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}/AddPrescriptionServlet" class="add-medication-btn">
                        <i class="fas fa-plus"></i> Thêm Toa Thuốc
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
                <form action="${pageContext.request.contextPath}/ViewPrescriptionServlet" method="get" class="search-form">
                    <input type="text" name="patientNameKeyword" placeholder="Tìm theo tên bệnh nhân..." 
                           value="${patientNameKeyword}" class="search-input">
                    <input type="text" name="medicationNameKeyword" placeholder="Tìm theo tên thuốc..." 
                           value="${medicationNameKeyword}" class="search-input">
                    <button type="submit" class="search-button">
                        <i class="fas fa-search"></i> Tìm kiếm
                    </button>
                </form>

                <!-- Alert Messages -->
                <c:if test="${not empty sessionScope.statusMessage}">
                    <c:choose>
                        <c:when test="${sessionScope.statusMessage == 'Tạo thành công'}">
                            <div class="alert alert-success">
                                <i class="fas fa-check-circle"></i> ${sessionScope.statusMessage}
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-error">
                                <i class="fas fa-exclamation-circle"></i> ${sessionScope.statusMessage}
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <c:remove var="statusMessage" scope="session"/>
                </c:if>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i> ${errorMessage}
                    </div>
                </c:if>

                <!-- Table Container -->
                <div class="table-container">
                    <c:choose>
                        <c:when test="${empty prescriptions}">
                            <div class="empty-state">
                                <div class="empty-icon"><i class="fas fa-prescription"></i></div>
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
                                            <th>Thao Tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="prescription" items="${prescriptions}" varStatus="status">
                                            <tr>
                                                <td><span class="row-number">${(currentPage - 1) * pageSize + status.count}</span></td>
                                                <td><div class="prescription-details">${prescription.prescriptionId}</div></td>
                                                <td><div class="prescription-details">${patientNames[prescription.patientId]}</div></td>
                                                <td><div class="prescription-details">${doctorNames[prescription.doctorId]}</div></td>
                                                <td>
                                                    <div class="action-buttons">
                                                        <a href="${pageContext.request.contextPath}/ViewPrescriptionDetailServlet?id=${prescription.prescriptionId}" 
                                                           class="action-btn btn-view">
                                                            <i class="fas fa-eye"></i> Chi tiết
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
                                            <div class="card-number">#${(currentPage - 1) * pageSize + status.count}</div>
                                        </div>
                                        <div class="card-body">
                                            <div class="card-field">
                                                <span class="field-label">Tên Bệnh Nhân:</span>
                                                <span class="field-value">${patientNames[prescription.patientId]}</span>
                                            </div>
                                            <div class="card-field">
                                                <span class="field-label">Tên Bác Sĩ:</span>
                                                <span class="field-value">${doctorNames[prescription.doctorId]}</span>
                                            </div>
                                        </div>
                                        <div class="card-actions">
                                            <div class="action-buttons">
                                                <a href="${pageContext.request.contextPath}/ViewPrescriptionDetailsServlet?id=${prescription.prescriptionId}" 
                                                   class="action-btn btn-view">
                                                    <i class="fas fa-eye"></i> Xem chi tiết
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
                        Hiển thị <strong>${(currentPage - 1) * pageSize + 1}</strong> - 
                        <strong>${currentPage * pageSize > totalRecords ? totalRecords : currentPage * pageSize}</strong> 
                        trong tổng số <strong>${totalRecords}</strong> toa thuốc
                    </div>
                    <div class="pagination-controls">
                        <c:choose>
                            <c:when test="${currentPage > 1}">
                                <a href="${pageContext.request.contextPath}/ViewPrescriptionServlet?page=1${patientNameKeyword != null && !patientNameKeyword.isEmpty() ? '&patientNameKeyword=' += patientNameKeyword : ''}${medicationNameKeyword != null && !medicationNameKeyword.isEmpty() ? '&medicationNameKeyword=' += medicationNameKeyword : ''}" 
                                   class="page-btn"><i class="fas fa-angle-double-left"></i></a>
                                <a href="${pageContext.request.contextPath}/ViewPrescriptionServlet?page=${currentPage - 1}${patientNameKeyword != null && !patientNameKeyword.isEmpty() ? '&patientNameKeyword=' += patientNameKeyword : ''}${medicationNameKeyword != null && !medicationNameKeyword.isEmpty() ? '&medicationNameKeyword=' += medicationNameKeyword : ''}" 
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
                            <a href="${pageContext.request.contextPath}/ViewPrescriptionServlet?page=1${patientNameKeyword != null && !patientNameKeyword.isEmpty() ? '&patientNameKeyword=' += patientNameKeyword : ''}${medicationNameKeyword != null && !medicationNameKeyword.isEmpty() ? '&medicationNameKeyword=' += medicationNameKeyword : ''}" 
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
                                    <a href="${pageContext.request.contextPath}/ViewPrescriptionServlet?page=${i}${patientNameKeyword != null && !patientNameKeyword.isEmpty() ? '&patientNameKeyword=' += patientNameKeyword : ''}${medicationNameKeyword != null && !medicationNameKeyword.isEmpty() ? '&medicationNameKeyword=' += medicationNameKeyword : ''}" 
                                       class="page-btn">${i}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                        <c:if test="${endPage < totalPages}">
                            <c:if test="${endPage < totalPages - 1}">
                                <span class="page-btn">...</span>
                            </c:if>
                            <a href="${pageContext.request.contextPath}/ViewPrescriptionServlet?page=${totalPages}${patientNameKeyword != null && !patientNameKeyword.isEmpty() ? '&patientNameKeyword=' += patientNameKeyword : ''}${medicationNameKeyword != null && !medicationNameKeyword.isEmpty() ? '&medicationNameKeyword=' += medicationNameKeyword : ''}" 
                               class="page-btn">${totalPages}</a>
                        </c:if>

                        <c:choose>
                            <c:when test="${currentPage < totalPages}">
                                <a href="${pageContext.request.contextPath}/ViewPrescriptionServlet?page=${currentPage + 1}${patientNameKeyword != null && !patientNameKeyword.isEmpty() ? '&patientNameKeyword=' += patientNameKeyword : ''}${medicationNameKeyword != null && !medicationNameKeyword.isEmpty() ? '&medicationNameKeyword=' += medicationNameKeyword : ''}" 
                                   class="page-btn"><i class="fas fa-angle-right"></i></a>
                                <a href="${pageContext.request.contextPath}/ViewPrescriptionServlet?page=${totalPages}${patientNameKeyword != null && !patientNameKeyword.isEmpty() ? '&patientNameKeyword=' += patientNameKeyword : ''}${medicationNameKeyword != null && !medicationNameKeyword.isEmpty() ? '&medicationNameKeyword=' += medicationNameKeyword : ''}" 
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
    </body>
</html>
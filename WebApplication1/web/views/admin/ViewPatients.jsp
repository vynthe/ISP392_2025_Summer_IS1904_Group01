<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.entity.Users" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý Bệnh nhân - Hệ thống Y tế</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <style>
            :root {
                --primary-color: #2563eb;
                --primary-dark: #1d4ed8;
                --secondary-color: #64748b;
                --success-color: #059669;
                --danger-color: #dc2626;
                --warning-color: #d97706;
                --info-color: #0891b2;
                --light-bg: #f8fafc;
                --white: #ffffff;
                --border-color: #e2e8f0;
                --text-primary: #1e293b;
                --text-secondary: #64748b;
                --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
                --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
                --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
                --border-radius: 8px;
                --border-radius-lg: 12px;
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
                background-color: var(--light-bg);
                color: var(--text-primary);
                line-height: 1.6;
            }

            /* Header Section */
            .page-header {
                background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
                color: white;
                padding: 2rem 0;
                margin-bottom: 2rem;
                position: relative;
                overflow: hidden;
            }

            .page-header::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="white" opacity="0.1"/><circle cx="75" cy="75" r="1" fill="white" opacity="0.1"/><circle cx="50" cy="10" r="0.5" fill="white" opacity="0.15"/><circle cx="10" cy="60" r="0.5" fill="white" opacity="0.15"/><circle cx="90" cy="40" r="0.5" fill="white" opacity="0.15"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
                opacity: 0.1;
            }

            .page-header .container {
                position: relative;
                z-index: 1;
            }

            .page-title {
                font-size: 2rem;
                font-weight: 700;
                margin-bottom: 0.5rem;
                display: flex;
                align-items: center;
                gap: 0.75rem;
            }

            .page-subtitle {
                font-size: 1rem;
                opacity: 0.9;
                font-weight: 400;
            }

            /* Main Container */
            .main-container {
                max-width: 1400px;
                margin: 0 auto;
                padding: 0 1rem;
            }

            .content-card {
                background: var(--white);
                border-radius: var(--border-radius-lg);
                box-shadow: var(--shadow-lg);
                border: 1px solid var(--border-color);
                overflow: hidden;
            }

            .card-header {
                background: var(--white);
                border-bottom: 1px solid var(--border-color);
                padding: 1.5rem;
            }

            .card-body {
                padding: 1.5rem;
            }

            /* Toolbar */
            .toolbar {
                display: flex;
                flex-wrap: wrap;
                gap: 1rem;
                align-items: center;
                justify-content: space-between;
                margin-bottom: 1.5rem;
            }

            .search-container {
                flex: 1;
                min-width: 300px;
                max-width: 500px;
            }

            .search-form {
                position: relative;
            }

            .search-input {
                border: 1px solid var(--border-color);
                border-radius: var(--border-radius);
                padding: 0.75rem 1rem 0.75rem 2.5rem;
                font-size: 0.875rem;
                transition: all 0.2s ease;
                width: 100%;
            }

            .search-input:focus {
                outline: none;
                border-color: var(--primary-color);
                box-shadow: 0 0 0 3px rgb(37 99 235 / 0.1);
            }

            .search-icon {
                position: absolute;
                left: 0.75rem;
                top: 50%;
                transform: translateY(-50%);
                color: var(--text-secondary);
                font-size: 0.875rem;
            }

            /* Buttons */
            .btn {
                font-weight: 500;
                border-radius: var(--border-radius);
                padding: 0.625rem 1.25rem;
                font-size: 0.875rem;
                border: none;
                cursor: pointer;
                transition: all 0.2s ease;
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                text-decoration: none;
            }

            .btn:focus {
                outline: none;
                box-shadow: 0 0 0 3px rgb(0 0 0 / 0.1);
            }

            .btn-primary {
                background-color: var(--primary-color);
                color: white;
            }

            .btn-primary:hover {
                background-color: var(--primary-dark);
                transform: translateY(-1px);
                box-shadow: var(--shadow-md);
                color: white;
            }

            .btn-success {
                background-color: var(--success-color);
                color: white;
            }

            .btn-success:hover {
                background-color: #047857;
                transform: translateY(-1px);
                box-shadow: var(--shadow-md);
                color: white;
            }

            .btn-info {
                background-color: var(--info-color);
                color: white;
            }

            .btn-info:hover {
                background-color: #0e7490;
                transform: translateY(-1px);
                color: white;
            }

            .btn-sm {
                padding: 0.375rem 0.75rem;
                font-size: 0.8rem;
            }

            .btn-outline {
                background: transparent;
                border: 1px solid var(--border-color);
                color: var(--text-primary);
            }

            .btn-outline:hover {
                background-color: var(--light-bg);
                border-color: var(--primary-color);
                color: var(--primary-color);
            }

            /* Table */
            .table-container {
                border-radius: var(--border-radius);
                overflow: hidden;
                border: 1px solid var(--border-color);
            }

            .table {
                margin-bottom: 0;
                font-size: 0.875rem;
            }

            .table thead th {
                background-color: #f1f5f9;
                border-bottom: 2px solid var(--border-color);
                color: var(--text-primary);
                font-weight: 600;
                padding: 1rem 0.75rem;
                text-align: center;
                font-size: 0.8rem;
                text-transform: uppercase;
                letter-spacing: 0.025em;
            }

            .table tbody td {
                padding: 1rem 0.75rem;
                vertical-align: middle;
                border-bottom: 1px solid #f1f5f9;
                color: var(--text-primary);
            }

            .table tbody tr {
                transition: background-color 0.2s ease;
            }

            .table tbody tr:hover {
                background-color: #f8fafc;
            }

            .table tbody tr:last-child td {
                border-bottom: none;
            }

            /* Status badges */
            .status-badge {
                display: inline-flex;
                align-items: center;
                padding: 0.25rem 0.75rem;
                border-radius: 9999px;
                font-size: 0.75rem;
                font-weight: 500;
                text-transform: uppercase;
                letter-spacing: 0.025em;
            }

            .status-active {
                background-color: #dcfce7;
                color: #166534;
            }

            .status-inactive {
                background-color: #fef2f2;
                color: #991b1b;
            }

            /* Action buttons */
            .action-buttons {
                display: flex;
                gap: 0.5rem;
                justify-content: center;
            }

            /* Pagination */
            .pagination-container {
                display: flex;
                justify-content: center;
                align-items: center;
                margin-top: 2rem;
                padding-top: 1.5rem;
                border-top: 1px solid var(--border-color);
            }

            .pagination {
                display: flex;
                gap: 0.25rem;
                margin: 0;
            }

            .page-item .page-link {
                border: 1px solid var(--border-color);
                color: var(--text-primary);
                padding: 0.5rem 0.75rem;
                border-radius: var(--border-radius);
                text-decoration: none;
                transition: all 0.2s ease;
                font-size: 0.875rem;
            }

            .page-item .page-link:hover {
                background-color: var(--light-bg);
                border-color: var(--primary-color);
                color: var(--primary-color);
            }

            .page-item.active .page-link {
                background-color: var(--primary-color);
                border-color: var(--primary-color);
                color: white;
            }

            .page-item.disabled .page-link {
                opacity: 0.5;
                cursor: not-allowed;
            }

            /* Empty state */
            .empty-state {
                text-align: center;
                padding: 3rem 1rem;
                color: var(--text-secondary);
            }

            .empty-state-icon {
                font-size: 3rem;
                margin-bottom: 1rem;
                opacity: 0.5;
            }

            .empty-state-title {
                font-size: 1.25rem;
                font-weight: 600;
                margin-bottom: 0.5rem;
            }

            .empty-state-description {
                font-size: 0.875rem;
            }

            /* Responsive design */
            @media (max-width: 768px) {
                .page-title {
                    font-size: 1.5rem;
                }

                .toolbar {
                    flex-direction: column;
                    align-items: stretch;
                }

                .search-container {
                    min-width: auto;
                    max-width: none;
                }

                .table-container {
                    overflow-x: auto;
                }

                .table {
                    min-width: 800px;
                }

                .action-buttons {
                    flex-direction: column;
                    gap: 0.25rem;
                }

                .btn-sm {
                    font-size: 0.75rem;
                    padding: 0.25rem 0.5rem;
                }
            }

            /* Loading animation */
            .loading {
                display: inline-block;
                width: 1rem;
                height: 1rem;
                border: 2px solid #f3f3f3;
                border-top: 2px solid var(--primary-color);
                border-radius: 50%;
                animation: spin 1s linear infinite;
            }

            @keyframes spin {
                0% { transform: rotate(0deg); }
                100% { transform: rotate(360deg); }
            }

            /* Breadcrumb */
            .breadcrumb-container {
                margin-bottom: 1rem;
            }

            .breadcrumb {
                background: transparent;
                padding: 0;
                margin: 0;
                font-size: 0.875rem;
            }

            .breadcrumb-item a {
                color: white;
                text-decoration: none;
                opacity: 0.8;
            }

            .breadcrumb-item a:hover {
                opacity: 1;
            }

            .breadcrumb-item.active {
                color: white;
                opacity: 0.9;
            }
        </style>
    </head>
    <body>
        <!-- Page Header -->
        <div class="page-header">
            <div class="container">
                <div class="breadcrumb-container">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp">
                                    <i class="fas fa-home"></i> Trang chủ
                                </a>
                            </li>
                            <li class="breadcrumb-item active" aria-current="page">Quản lý bệnh nhân</li>
                        </ol>
                    </nav>
                </div>
                <h1 class="page-title">
                    <i class="fas fa-users"></i>
                    Quản lý Bệnh nhân
                </h1>
                <p class="page-subtitle">Danh sách và thông tin chi tiết các bệnh nhân trong hệ thống</p>
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-container">
            <div class="content-card">
                <div class="card-header">
                    <div class="toolbar">
                        <!-- Search -->
                        <div class="search-container">
                            <form action="ViewPatientServlet" method="get" class="search-form">
                                <i class="fas fa-search search-icon"></i>
                                <input type="text" 
                                       name="keyword" 
                                       class="form-control search-input" 
                                       placeholder="Tìm kiếm theo tên, email, số điện thoại..."
                                       value="${keyword != null ? keyword : ''}">
                            </form>
                        </div>
                        
                        <!-- Actions -->
                        <div class="d-flex gap-2">
                            <button type="button" class="btn btn-outline" onclick="window.location.reload()">
                                <i class="fas fa-sync-alt"></i>
                                Làm mới
                            </button>
                            <a href="${pageContext.request.contextPath}/views/admin/AddPatient.jsp" class="btn btn-success">
                                <i class="fas fa-plus"></i>
                                Thêm bệnh nhân
                            </a>
                        </div>
                    </div>
                </div>

                <div class="card-body">
                    <!-- Table -->
                    <div class="table-container">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th style="width: 80px;">ID</th>
                                    <th style="width: 200px;">Họ và tên</th>
                                    <th style="width: 100px;">Giới tính</th>
                                    <th style="width: 120px;">Ngày sinh</th>
                                    <th style="width: 130px;">Số điện thoại</th>
                                    <th style="width: 200px;">Địa chỉ</th>
                                    <th style="width: 100px;">Trạng thái</th>
                                    <th style="width: 180px;">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty patients}">
                                        <!-- Pagination Logic -->
                                        <c:set var="page" value="${param.page != null ? param.page : 1}" />
                                        <c:set var="pageSize" value="10" />
                                        <c:set var="totalItems" value="${patients.size()}" />
                                        <c:set var="totalPages" value="${(totalItems + pageSize - 1) / pageSize}" />
                                        <c:set var="startIndex" value="${(page - 1) * pageSize}" />
                                        <c:set var="endIndex" value="${startIndex + pageSize - 1}" />
                                        <c:if test="${endIndex >= totalItems}">
                                            <c:set var="endIndex" value="${totalItems - 1}" />
                                        </c:if>

                                        <c:forEach var="patient" items="${patients}" begin="${startIndex}" end="${endIndex}">
                                            <tr>
                                                <td class="text-center">
                                                    <span class="badge bg-light text-dark">#${patient.userID}</span>
                                                </td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <div class="avatar-placeholder bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-2" 
                                                             style="width: 32px; height: 32px; font-size: 0.8rem; font-weight: 600;">
                                                            ${patient.fullName.substring(0, 1).toUpperCase()}
                                                        </div>
                                                        <div>
                                                            <div class="fw-semibold">${patient.fullName}</div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <!-- Fixed Gender Display Logic -->
                                                    <c:choose>
                                                        <c:when test="${fn:toLowerCase(patient.gender) eq 'nam' || fn:toLowerCase(patient.gender) eq 'male'}">
                                                            <i class="fas fa-mars text-primary"></i> Nam
                                                        </c:when>
                                                        <c:when test="${fn:toLowerCase(patient.gender) eq 'nữ' || fn:toLowerCase(patient.gender) eq 'female'}">
                                                            <i class="fas fa-venus text-danger"></i> Nữ
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="fas fa-question-circle text-secondary"></i> ${patient.gender != null ? patient.gender : 'Chưa xác định'}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-center">
                                                    <fmt:formatDate value="${patient.dob}" pattern="dd/MM/yyyy" />
                                                </td>
                                                <td class="text-center">
                                                    <i class="fas fa-phone text-success me-1"></i>
                                                    ${patient.phone}
                                                </td>
                                                <td>
                                                    <i class="fas fa-map-marker-alt text-warning me-1"></i>
                                                    ${patient.address}
                                                </td>
                                                <td class="text-center">
                                                    <c:choose>
                                                        <c:when test="${patient.status eq 'Active'}">
                                                            <span class="status-badge status-active">
                                                                <i class="fas fa-check-circle me-1"></i>
                                                                Hoạt động
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge status-inactive">
                                                                <i class="fas fa-times-circle me-1"></i>
                                                                Không hoạt động
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="action-buttons">
                                                        <a href="${pageContext.request.contextPath}/ViewPatientDetailServlet?id=${patient.userID}" 
                                                           class="btn btn-sm btn-info" 
                                                           title="Xem chi tiết">
                                                            <i class="fas fa-eye"></i>
                                                            Chi tiết
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/UpdatePatientServlet?id=${patient.userID}" 
                                                           class="btn btn-sm btn-primary" 
                                                           title="Chỉnh sửa">
                                                            <i class="fas fa-edit"></i>
                                                            Sửa
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="8">
                                                <div class="empty-state">
                                                    <i class="fas fa-user-injured empty-state-icon"></i>
                                                    <div class="empty-state-title">Không có dữ liệu bệnh nhân</div>
                                                    <div class="empty-state-description">
                                                        Hiện tại chưa có bệnh nhân nào trong hệ thống hoặc không có kết quả phù hợp với từ khóa tìm kiếm.
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${not empty patients and totalItems > pageSize}">
                        <div class="pagination-container">
                            <nav aria-label="Phân trang">
                                <ul class="pagination">
                                    <c:set var="prevPage" value="${page - 1}" />
                                    <c:set var="nextPage" value="${page + 1}" />
                                    
                                    <li class="page-item ${page == 1 ? 'disabled' : ''}">
                                        <a class="page-link" 
                                           href="${page == 1 ? '#' : pageContext.request.contextPath.concat('/ViewPatientServlet?page=').concat(prevPage)}" 
                                           ${page == 1 ? 'tabindex="-1" aria-disabled="true"' : ''}>
                                            <i class="fas fa-chevron-left"></i>
                                            Trước
                                        </a>
                                    </li>
                                    
                                    <c:forEach var="i" begin="1" end="${totalPages}">
                                        <li class="page-item ${page == i ? 'active' : ''}">
                                            <a class="page-link" 
                                               href="${pageContext.request.contextPath}/ViewPatientServlet?page=${i}">
                                                ${i}
                                            </a>
                                        </li>
                                    </c:forEach>
                                    
                                    <li class="page-item ${page == totalPages ? 'disabled' : ''}">
                                        <a class="page-link" 
                                           href="${page == totalPages ? '#' : pageContext.request.contextPath.concat('/ViewPatientServlet?page=').concat(nextPage)}" 
                                           ${page == totalPages ? 'tabindex="-1" aria-disabled="true"' : ''}>
                                            Sau
                                            <i class="fas fa-chevron-right"></i>
                                        </a>
                                    </li>
                                </ul>
                            </nav>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        
        <!-- Custom JavaScript -->
        <script>
            // Auto-submit search form on Enter key
            document.querySelector('.search-input').addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    this.closest('form').submit();
                }
            });

            // Add loading state to buttons on click
            document.querySelectorAll('.btn').forEach(btn => {
                btn.addEventListener('click', function() {
                    if (this.type === 'submit' || this.tagName === 'A') {
                        const originalContent = this.innerHTML;
                        this.innerHTML = '<span class="loading"></span> Đang tải...';
                        this.disabled = true;
                        
                        // Re-enable after 3 seconds (failsafe)
                        setTimeout(() => {
                            this.innerHTML = originalContent;
                            this.disabled = false;
                        }, 3000);
                    }
                });
            });

            // Smooth scroll to top when pagination is clicked
            document.querySelectorAll('.pagination .page-link').forEach(link => {
                link.addEventListener('click', function() {
                    setTimeout(() => {
                        window.scrollTo({ top: 0, behavior: 'smooth' });
                    }, 100);
                });
            });
        </script>
    </body>
</html>
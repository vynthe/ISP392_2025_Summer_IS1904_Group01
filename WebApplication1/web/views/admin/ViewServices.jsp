<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.entity.Services" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản Lý Dịch Vụ | Admin Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', sans-serif;
                background-color: #f8f9fa;
                color: #212529;
                line-height: 1.6;
            }

            /* Header Styles */
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

            /* Main Content */
            .main-content {
                min-height: calc(100vh - 120px);
                padding: 2rem 0;
            }

            .page-title {
                background: white;
                padding: 1.5rem;
                margin-bottom: 2rem;
                border: 1px solid #dee2e6;
                box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            }

            .page-title h1 {
                font-size: 2rem;
                font-weight: 700;
                color: #212529;
                margin: 0;
                display: flex;
                align-items: center;
                gap: 1rem;
            }

            .page-title .breadcrumb {
                background: none;
                padding: 0;
                margin: 0.5rem 0 0 0;
            }

            .breadcrumb-item a {
                color: #6c757d;
                text-decoration: none;
            }

            .breadcrumb-item.active {
                color: #495057;
            }

            /* Content Sections */
            .content-section {
                background: white;
                border: 1px solid #dee2e6;
                margin-bottom: 2rem;
                box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            }

            .section-header {
                background: #f8f9fa;
                padding: 1rem 1.5rem;
                border-bottom: 1px solid #dee2e6;
                font-weight: 600;
                color: #495057;
            }

            .section-body {
                padding: 1.5rem;
            }

            /* Alert Styles */
            .alert {
                border: 0;
                margin-bottom: 1.5rem;
            }

            .alert-success {
                background: #d1edcc;
                color: #0f5132;
                border-left: 4px solid #198754;
            }

            /* Form Styles */
            .form-control {
                border: 1px solid #ced4da;
                padding: 0.75rem;
                font-size: 0.9rem;
            }

            .form-control:focus {
                border-color: #495057;
                box-shadow: 0 0 0 2px rgba(73, 80, 87, 0.25);
            }

            .form-label {
                font-weight: 500;
                color: #495057;
                margin-bottom: 0.5rem;
            }

            /* Button Styles */
            .btn {
                border: 0;
                padding: 0.75rem 1.5rem;
                font-weight: 500;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                transition: all 0.3s ease;
            }

            .btn-primary {
                background: #495057;
                color: white;
            }

            .btn-primary:hover {
                background: #343a40;
                color: white;
            }

            .btn-success {
                background: #198754;
                color: white;
            }

            .btn-success:hover {
                background: #157347;
                color: white;
            }

            .btn-warning {
                background: #fd7e14;
                color: white;
            }

            .btn-warning:hover {
                background: #e35d04;
                color: white;
            }

            .btn-danger {
                background: #dc3545;
                color: white;
            }

            .btn-danger:hover {
                background: #bb2d3b;
                color: white;
            }

            .btn-info {
                background: #0dcaf0;
                color: white;
            }

            .btn-info:hover {
                background: #31d2f2;
                color: white;
            }

            .btn-sm {
                padding: 0.5rem 1rem;
                font-size: 0.8rem;
            }

            /* Table Styles */
            .table-container {
                border: 1px solid #dee2e6;
                overflow-x: auto;
            }

            .table {
                margin: 0;
                font-size: 0.9rem;
            }

            .table thead th {
                background: #495057;
                color: white;
                border: 0;
                padding: 1rem;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .table tbody td {
                padding: 1rem;
                border-bottom: 1px solid #dee2e6;
                vertical-align: middle;
            }

            .table tbody tr:hover {
                background: #f8f9fa;
            }

            .table tbody tr:last-child td {
                border-bottom: 0;
            }

            /* Status Badge */
            .status-badge {
                padding: 0.4rem 0.8rem;
                font-size: 0.75rem;
                font-weight: 600;
                text-transform: uppercase;
                border: 1px solid;
            }

            .status-active {
                background: #d1edcc;
                color: #0f5132;
                border-color: #198754;
            }

            .status-inactive {
                background: #f8d7da;
                color: #721c24;
                border-color: #dc3545;
            }

            /* Utilities */
            .service-id {
                font-weight: 700;
                color: #495057;
                font-family: monospace;
            }

            .service-name {
                font-weight: 600;
                color: #212529;
            }

            .price-display {
                font-weight: 600;
                color: #198754;
                font-family: monospace;
            }

            .date-display {
                color: #6c757d;
                font-size: 0.85rem;
            }

            .action-buttons {
                display: flex;
                gap: 0.5rem;
                flex-wrap: wrap;
            }

            /* Empty State */
            .empty-state {
                text-align: center;
                padding: 3rem;
                color: #6c757d;
            }

            .empty-state .icon {
                font-size: 3rem;
                margin-bottom: 1rem;
                opacity: 0.5;
            }

            /* Pagination */
            .pagination {
                justify-content: center;
                margin-top: 2rem;
            }

            .page-link {
                color: #495057;
                border: 1px solid #dee2e6;
                padding: 0.75rem 1rem;
            }

            .page-link:hover {
                background: #495057;
                color: white;
                border-color: #495057;
            }

            .page-item.active .page-link {
                background: #495057;
                border-color: #495057;
            }

            /* Footer */
            .main-footer {
                background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
                color: white;
                margin-top: auto;
                width: 100vw;
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

            /* Responsive */
            @media (max-width: 768px) {
                .main-content {
                    padding: 1rem 0;
                }

                .page-title {
                    padding: 1rem;
                }

                .section-body {
                    padding: 1rem;
                }

                .header-nav {
                    flex-direction: column;
                    gap: 1rem;
                }

                .user-info {
                    margin-top: 1rem;
                }

                .action-buttons {
                    flex-direction: column;
                }

                .table-container {
                    font-size: 0.8rem;
                }

                .table thead th,
                .table tbody td {
                    padding: 0.75rem 0.5rem;
                }
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <header class="main-header">

            <div class="header-main">
                <div class="header-container">
                    <a href="${pageContext.request.contextPath}/" class="logo">
                        <i class="fas fa-hospital"></i>
                        <span>Phòng Khám Nha Khoa PDC</span>
                    </a>
                    <nav>
                        <ul class="main-nav">
                            <li><a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp">
                                    <i class="fas fa-home"></i> Trang Chủ</a></li>
                            <li><a href="${pageContext.request.contextPath}/ViewServiceServlet" class="active">
                                    <i class="fas fa-cogs"></i> Quản Lý Dịch Vụ</a></li>
                        </ul>
                    </nav>
                </div>
            </div>
        </header>

        <!-- Main Content -->
        <main class="main-content">

            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle me-2"></i>
                    ${sessionScope.successMessage}
                    <button type="button" class="btn-close float-end" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>

            <!-- Error Alert -->
            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    ${sessionScope.error}
                    <button type="button" class="btn-close float-end" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="error" scope="session"/>
            </c:if>

            <!-- Error Alert from request scope (for other errors) -->
            <c:if test="${not empty requestScope.error}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    ${requestScope.error}
                    <button type="button" class="btn-close float-end" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Action Section -->
            <div class="content-section">
                <div class="section-body">
                    <a href="${pageContext.request.contextPath}/views/admin/AddService.jsp" 
                       class="btn btn-success">
                        <i class="fas fa-plus"></i>
                        THÊM DỊCH VỤ MỚI
                    </a>
                </div>
            </div>

            <!-- Search Section -->
            <div class="content-section">
                <div class="section-body">
                    <form action="${pageContext.request.contextPath}/ViewServiceServlet" method="get">
                        <div class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label">
                                    <i class="fas fa-search me-1"></i>
                                    Tìm kiếm 
                                </label>
                                <input type="text" class="form-control" 
                                       name="keyword" value="${param.keyword}" 
                                       placeholder="Tìm kiếm">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">
                                    <i class="fas fa-money-bill-wave me-1"></i>
                                    Giá từ (VNĐ)
                                </label>
                                <input type="number" step="1000" min="0" 
                                       class="form-control" 
                                       name="minPrice" value="${param.minPrice}" 
                                       placeholder="0">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">
                                    <i class="fas fa-money-bill-wave me-1"></i>
                                    Giá đến (VNĐ)
                                </label>
                                <input type="number" step="1000" min="0" 
                                       class="form-control" 
                                       name="maxPrice" value="${param.maxPrice}" 
                                       placeholder="1,000,000">
                            </div>
                            <div class="col-md-2">
                                <label class="form-label">&nbsp;</label>
                                <button type="submit" class="btn btn-primary w-100">
                                    <i class="fas fa-search"></i>
                                    TÌM KIẾM
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Services Table -->
            <div class="content-section">
                <div class="section-header">
                    <i class="fas fa-list me-2"></i>
                    DANH SÁCH DỊCH VỤ
                </div>
                <div class="section-body">
                    <div class="table-container">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>
                                        <i class="fas fa-hashtag me-2"></i>
                                        ID
                                    </th>
                                    <th>
                                        <i class="fas fa-tag me-2"></i>
                                        TÊN DỊCH VỤ
                                    </th>
                                    <th>
                                        <i class="fas fa-dollar-sign me-2"></i>
                                        GIÁ TIỀN
                                    </th>
                                    <th>
                                        <i class="fas fa-toggle-on me-2"></i>
                                        TRẠNG THÁI
                                    </th>
                                    <th>
                                        <i class="fas fa-calendar-plus me-2"></i>
                                        NGÀY TạO
                                    </th>
                                    <th>
                                        <i class="fas fa-calendar-edit me-2"></i>
                                        CẬP NHẬT
                                    </th>
                                    <th>
                                        <i class="fas fa-cog me-2"></i>
                                        THAO TÁC
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty services}">
                                        <c:set var="page" value="${param.page != null ? param.page : 1}" />
                                        <c:set var="pageSize" value="10" />
                                        <c:set var="totalItems" value="${services.size()}" />
                                        <c:set var="totalPages" value="${(totalItems + pageSize - 1) / pageSize}" />
                                        <c:set var="startIndex" value="${(page - 1) * pageSize}" />
                                        <c:set var="endIndex" value="${startIndex + pageSize - 1}" />
                                        <c:if test="${endIndex >= totalItems}">
                                            <c:set var="endIndex" value="${totalItems - 1}" />
                                        </c:if>

                                        <c:forEach var="service" items="${services}" begin="${startIndex}" end="${endIndex}">
                                            <tr>
                                                <td>
                                                    <span class="service-id">#${service.serviceID}</span>
                                                </td>
                                                <td>
                                                    <div class="service-name">${service.serviceName}</div>
                                                </td>
                                                <td>
                                                    <span class="price-display">
                                                        <fmt:formatNumber value="${service.price}" type="number" pattern="#,##0" /> ₫
                                                    </span>
                                                </td>
                                                <td>
                                                    <span class="status-badge ${service.status == 'Active' ? 'status-active' : 'status-inactive'}">
                                                        ${service.status == 'Active' ? 'HOẠT ĐỘNG' : 'TẠM DỪNG'}
                                                    </span>
                                                </td>
                                                <td>
                                                    <div class="date-display">
                                                        <fmt:formatDate value="${service.createdAt}" pattern="dd/MM/yyyy" />
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="date-display">
                                                        <fmt:formatDate value="${service.updatedAt}" pattern="dd/MM/yyyy" />
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="action-buttons">
                                                        <a href="${pageContext.request.contextPath}/ViewDetailServiceAdminServlet?id=${service.serviceID}" 
                                                           class="btn btn-info btn-sm" 
                                                           title="Xem chi tiết">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/UpdateServiceServlet?id=${service.serviceID}" 
                                                           class="btn btn-warning btn-sm" 
                                                           title="Chỉnh sửa">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/DeleteServiceServlet?id=${service.serviceID}" 
                                                           class="btn btn-danger btn-sm" 
                                                           title="Xóa dịch vụ"
                                                           onclick="return confirm('Bạn có chắc chắn muốn xóa dịch vụ này không?');">
                                                            <i class="fas fa-trash"></i>
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="7">
                                                <div class="empty-state">
                                                    <div class="icon">
                                                        <i class="fas fa-folder-open"></i>
                                                    </div>
                                                    <h5>KHÔNG CÓ DỮ LIỆU</h5>
                                                    <p>Hiện tại không có dịch vụ nào trong hệ thống.</p>
                                                    <a href="${pageContext.request.contextPath}/views/admin/AddService.jsp" 
                                                       class="btn btn-success">
                                                        <i class="fas fa-plus"></i>
                                                        THÊM DỊCH VỤ ĐẦU TIÊN
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>

                        <!-- Pagination -->
                        <c:if test="${not empty services and totalItems > pageSize}">
                            <nav aria-label="Pagination">
                                <ul class="pagination">
                                    <c:set var="prevPage" value="${page - 1}" />
                                    <c:set var="nextPage" value="${page + 1}" />

                                    <li class="page-item ${page == 1 ? 'disabled' : ''}">
                                        <a class="page-link" 
                                           href="${pageContext.request.contextPath}/ViewServiceServlet?page=${prevPage}&keyword=${param.keyword}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}">
                                            <i class="fas fa-chevron-left"></i>
                                        </a>
                                    </li>

                                    <c:forEach var="i" begin="1" end="${totalPages}">
                                        <li class="page-item ${page == i ? 'active' : ''}">
                                            <a class="page-link" 
                                               href="${pageContext.request.contextPath}/ViewServiceServlet?page=${i}&keyword=${param.keyword}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}">
                                                ${i}
                                            </a>
                                        </li>
                                    </c:forEach>

                                    <li class="page-item ${page == totalPages ? 'disabled' : ''}">
                                        <a class="page-link" 
                                           href="${pageContext.request.contextPath}/ViewServiceServlet?page=${nextPage}&keyword=${param.keyword}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}">
                                            <i class="fas fa-chevron-right"></i>
                                        </a>
                                    </li>
                                </ul>
                            </nav>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="main-footer">
        <div class="footer-content">
            <div class="footer-grid">
                <div class="footer-section">
                    <h4><i class="fas fa-hospital"></i>Về Chúng Tôi</h4>
                    <p>Chúng tôi là hệ thống quản lý dịch vụ y tế hàng đầu, cam kết mang lại sự chăm sóc tốt nhất với công nghệ tiên tiến và đội ngũ chuyên gia giàu kinh nghiệm.</p>
                </div>

                <div class="footer-section">
                    <h4><i class="fas fa-link"></i>Liên Kết Nhanh</h4>
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp">
                                <i class="fas fa-home"></i> Trang Chủ</a></li>
                        <li><a href="${pageContext.request.contextPath}/ViewServiceServlet">
                                <i class="fas fa-cogs"></i> Quản Lý Dịch Vụ</a></li>
                    </ul>
                </div>

                <div class="footer-section">
                    <h4><i class="fas fa-map-marker-alt"></i> Liên Hệ</h4>
                    <p><i class="fas fa-map-marker-alt"></i> ĐH FPT, HOA LAC</p>
                    <p><i class="fas fa-phone"></i> (098) 123 4567</p>
                    <p><i class="fas fa-envelope"></i> PhongKhamPDC@gmail.com</p>
                </div>
            </div>

            <div class="footer-bottom">
                <p>© 2025 Hệ Thống Quản Lý PDC. Đạt chuẩn Bộ Y tế. Tất cả quyền được bảo lưu.</p>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
                                                               document.addEventListener('DOMContentLoaded', function () {
                                                                   // Auto-hide alerts
                                                                   const alerts = document.querySelectorAll('.alert');
                                                                   alerts.forEach(alert => {
                                                                       setTimeout(() => {
                                                                           if (alert) {
                                                                               alert.style.opacity = '0';
                                                                               setTimeout(() => alert.remove(), 300);
                                                                           }
                                                                       }, 5000);
                                                                   });

                                                                   // Confirm delete
                                                                   const deleteLinks = document.querySelectorAll('a[href*="DeleteServiceServlet"]');
                                                                   deleteLinks.forEach(link => {
                                                                       link.addEventListener('click', function (e) {
                                                                           if (!confirm('Bạn có chắc chắn muốn xóa dịch vụ này không?')) {
                                                                               e.preventDefault();
                                                                           }
                                                                       });
                                                                   });

                                                                   // Form validation
                                                                   const forms = document.querySelectorAll('form');
                                                                   forms.forEach(form => {
                                                                       form.addEventListener('submit', function () {
                                                                           const submitBtn = this.querySelector('button[type="submit"]');
                                                                           if (submitBtn) {
                                                                               submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
                                                                               submitBtn.disabled = true;
                                                                           }
                                                                       });
                                                                   });
                                                               });
    </script>
</body>
</html>
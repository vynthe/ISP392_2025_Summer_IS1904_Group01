<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.entity.Users" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Nhân Viên - Hệ Thống Phòng Khám</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #4f46e5;
            --secondary-color: #64748b;
            --success-color: #10b981;
            --danger-color: #ef4444;
            --warning-color: #f59e0b;
            --light-bg: #f8fafc;
            --border-color: #e2e8f0;
            --text-dark: #1e293b;
            --text-muted: #64748b;
            --header-gradient: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
        }

        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif;
            color: var(--text-dark);
            line-height: 1.6;
            min-height: 100vh;
        }

        /* Simplified Header Styles */
        .main-header {
            background: linear-gradient(135deg, #1e40af 0%, #3b82f6 100%);
            color: white;
            padding: 2rem 0;
            box-shadow: 0 4px 20px rgba(30, 64, 175, 0.2);
            margin-bottom: 2rem;
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .header-icon {
            background: rgba(255, 255, 255, 0.2);
            padding: 1rem;
            border-radius: 12px;
            backdrop-filter: blur(10px);
        }

        .header-icon i {
            font-size: 2rem;
        }

        .header-text h1 {
            font-size: 2rem;
            font-weight: 700;
            margin: 0 0 0.25rem 0;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .header-text p {
            font-size: 1rem;
            margin: 0;
            opacity: 0.9;
        }

        .breadcrumb-nav {
            background: rgba(255, 255, 255, 0.15);
            padding: 0.75rem 1rem;
            border-radius: 8px;
            backdrop-filter: blur(10px);
            font-size: 0.875rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .breadcrumb-nav a {
            color: rgba(255, 255, 255, 0.9);
            text-decoration: none;
            transition: color 0.2s;
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }

        .breadcrumb-nav a:hover {
            color: white;
        }

        .breadcrumb-nav .separator {
            color: rgba(255, 255, 255, 0.6);
            margin: 0 0.25rem;
        }

        .breadcrumb-nav .current {
            color: white;
            font-weight: 500;
        }

        /* Main Content */
        .main-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 1rem;
        }

        .content-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.2);
            overflow: hidden;
        }

        .card-header {
            padding: 2rem;
            background: linear-gradient(135deg, #fafbfc 0%, #f8fafc 100%);
            border-bottom: 1px solid var(--border-color);
        }

        .card-body {
            padding: 2rem;
        }

        .page-title {
            font-size: 1.75rem;
            font-weight: 600;
            color: var(--text-dark);
            margin: 0;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .page-title i {
            color: var(--primary-color);
            background: rgba(79, 70, 229, 0.1);
            padding: 8px;
            border-radius: 8px;
        }

        /* Buttons */
        .btn {
            font-weight: 500;
            border-radius: 10px;
            padding: 0.625rem 1.25rem;
            transition: all 0.3s ease;
            border: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            position: relative;
            overflow: hidden;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s ease;
        }

        .btn:hover::before {
            left: 100%;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color) 0%, #6366f1 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(79, 70, 229, 0.4);
            color: white;
        }

        .btn-success {
            background: linear-gradient(135deg, var(--success-color) 0%, #059669 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(16, 185, 129, 0.4);
            color: white;
        }

        .btn-info {
            background: linear-gradient(135deg, #0ea5e9 0%, #0284c7 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(14, 165, 233, 0.3);
        }

        .btn-info:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(14, 165, 233, 0.4);
            color: white;
        }

        .btn-danger {
            background: linear-gradient(135deg, var(--danger-color) 0%, #dc2626 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
        }

        .btn-danger:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(239, 68, 68, 0.4);
            color: white;
        }

        .btn-sm {
            padding: 0.5rem 1rem;
            font-size: 0.875rem;
        }

        /* Search Form */
        .search-section {
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            padding: 1.5rem;
            border-radius: 12px;
            margin-bottom: 1.5rem;
            border: 1px solid var(--border-color);
        }

        .search-form {
            display: flex;
            gap: 1rem;
            max-width: 600px;
            margin: 0 auto;
        }

        .form-control {
            border: 2px solid var(--border-color);
            border-radius: 10px;
            padding: 0.75rem 1rem;
            transition: all 0.3s ease;
            background: white;
            font-size: 1rem;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1);
            background: white;
        }

        .form-control::placeholder {
            color: var(--text-muted);
        }

        /* Table */
        .table-container {
            overflow-x: auto;
            border-radius: 12px;
            border: 1px solid var(--border-color);
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        .table {
            margin: 0;
            font-size: 0.9rem;
        }

        .table thead th {
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            border-bottom: 2px solid var(--border-color);
            font-weight: 600;
            color: var(--text-dark);
            padding: 1.25rem 1rem;
            text-align: center;
            white-space: nowrap;
            position: relative;
        }

        .table thead th::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 2px;
            background: linear-gradient(90deg, transparent, var(--primary-color), transparent);
        }

        .table tbody td {
            padding: 1rem;
            vertical-align: middle;
            border-bottom: 1px solid #f1f5f9;
            text-align: center;
            transition: all 0.2s ease;
        }

        .table tbody tr:hover {
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .table tbody tr:last-child td {
            border-bottom: none;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 0.5rem;
            justify-content: center;
            flex-wrap: wrap;
        }

        /* Success Message */
        .success-message {
            background: linear-gradient(135deg, #dcfce7 0%, #bbf7d0 100%);
            color: #166534;
            padding: 1.25rem;
            border-radius: 12px;
            margin-bottom: 1.5rem;
            border-left: 4px solid var(--success-color);
            display: flex;
            align-items: center;
            gap: 0.75rem;
            box-shadow: 0 2px 10px rgba(16, 185, 129, 0.1);
        }

        .success-message i {
            font-size: 1.25rem;
        }

        /* Status Badge */
        .status-badge {
            padding: 0.375rem 0.875rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .status-active {
            background: linear-gradient(135deg, #dcfce7 0%, #bbf7d0 100%);
            color: #166534;
        }

        .status-inactive {
            background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%);
            color: #991b1b;
        }

        .status-badge::before {
            content: '';
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: currentColor;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: var(--text-muted);
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1.5rem;
            opacity: 0.5;
            color: var(--primary-color);
        }

        .empty-state h5 {
            font-size: 1.5rem;
            margin-bottom: 1rem;
            color: var(--text-dark);
        }

        /* Pagination */
        .pagination-container {
            display: flex;
            justify-content: center;
            margin-top: 2rem;
        }

        .pagination .page-link {
            color: var(--primary-color);
            background-color: white;
            border: 1px solid var(--border-color);
            padding: 0.75rem 1rem;
            margin: 0 3px;
            border-radius: 8px;
            text-decoration: none;
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .pagination .page-link:hover {
            background: linear-gradient(135deg, var(--primary-color) 0%, #6366f1 100%);
            border-color: var(--primary-color);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
        }

        .pagination .page-item.active .page-link {
            background: linear-gradient(135deg, var(--primary-color) 0%, #6366f1 100%);
            border-color: var(--primary-color);
            color: white;
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
        }

        .pagination .page-item.disabled .page-link {
            color: var(--text-muted);
            background-color: #f8fafc;
            border-color: var(--border-color);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .header-content {
                flex-direction: column;
                gap: 1rem;
                align-items: flex-start;
            }

            .header-left {
                align-self: center;
            }

            .breadcrumb-nav {
                align-self: stretch;
                justify-content: center;
            }

            .search-form {
                flex-direction: column;
                max-width: 100%;
            }

            .action-buttons {
                flex-direction: column;
                gap: 0.25rem;
            }

            .btn-sm {
                font-size: 0.8rem;
                padding: 0.375rem 0.75rem;
            }

            .table-container {
                font-size: 0.8rem;
            }

            .card-header,
            .card-body {
                padding: 1.5rem;
            }
        }

        @media (max-width: 480px) {
            .header-text h1 {
                font-size: 1.5rem;
            }

            .main-container {
                padding: 0 0.5rem;
            }

            .card-header,
            .card-body {
                padding: 1rem;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="main-header">
        <div class="container">
            <div class="header-content">
                <div class="header-left">
                    <div class="header-icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="header-text">
                        <h1>Quản Lý Nhân Viên</h1>
                        <p>Hệ Thống Phòng Khám</p>
                    </div>
                </div>
                <nav class="breadcrumb-nav">
                    <a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp">
                        <i class="fas fa-home"></i>
                        Trang chủ
                    </a>
                    <span class="separator">></span>
                    <span class="current">Danh sách Nhân Viên</span>
                </nav>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <div class="main-container">
        <div class="content-card">
            <div class="card-header">
                <div class="d-flex justify-content-between align-items-center">
                    <h2 class="page-title">
                        <i class="fas fa-list"></i>
                        Danh Sách Nhân Viên
                    </h2>
                    <a href="${pageContext.request.contextPath}/views/admin/AddEmployees.jsp" class="btn btn-success">
                        <i class="fas fa-user-plus"></i>
                        Thêm Nhân Viên Mới
                    </a>
                </div>
            </div>

            <div class="card-body">
                <!-- Success Message -->
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="success-message">
                        <i class="fas fa-check-circle"></i>
                        <span>${sessionScope.successMessage}</span>
                    </div>
                    <% session.removeAttribute("successMessage"); %>
                </c:if>

                <!-- Search Section -->
                <div class="search-section">
                    <form action="ViewEmployeeServlet" method="get" class="search-form">
                        <input type="text" name="keyword" class="form-control flex-grow-1" 
                               placeholder="🔍 Tìm kiếm theo tên, email, số điện thoại, chuyên khoa..."
                               value="${keyword != null ? keyword : ''}">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-search"></i>
                            Tìm Kiếm
                        </button>
                    </form>
                </div>

                <!-- Table -->
                <div class="table-container">
                    <table class="table">
                        <thead>
                            <tr>
                                <th><i class="fas fa-hashtag me-2"></i>ID</th>
                                <th><i class="fas fa-user me-2"></i>Họ và Tên</th>
                                <th><i class="fas fa-venus-mars me-2"></i>Giới tính</th>
                                <th><i class="fas fa-stethoscope me-2"></i>Chuyên khoa</th>
                                <th><i class="fas fa-calendar me-2"></i>Ngày sinh</th>
                                <th><i class="fas fa-phone me-2"></i>Số điện thoại</th>
                                <th><i class="fas fa-toggle-on me-2"></i>Trạng thái</th>
                                <th><i class="fas fa-tools me-2"></i>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty employees}">
                                    <c:set var="page" value="${param.page != null ? param.page : 1}" />
                                    <c:set var="pageSize" value="10" />
                                    <c:set var="totalItems" value="${employees.size()}" />
                                    <c:set var="totalPages" value="${(totalItems + pageSize - 1) / pageSize}" />
                                    <c:set var="startIndex" value="${(page - 1) * pageSize}" />
                                    <c:set var="endIndex" value="${startIndex + pageSize - 1}" />
                                    <c:if test="${endIndex >= totalItems}">
                                        <c:set var="endIndex" value="${totalItems - 1}" />
                                    </c:if>

                                    <c:forEach var="user" items="${employees}" begin="${startIndex}" end="${endIndex}">
                                        <tr>
                                            <td><strong>#${user.userID}</strong></td>
                                            <td>
                                                <div class="d-flex align-items-center justify-content-center">
                                                    <div class="me-2">
                                                        <i class="fas fa-user-circle text-primary" style="font-size: 1.5rem;"></i>
                                                    </div>
                                                    <strong>${user.fullName}</strong>
                                                </div>
                                            </td>
                                            <td>
                                                <i class="fas ${user.gender == 'Nam' ? 'fa-mars text-primary' : 'fa-venus text-danger'} me-2"></i>
                                                ${user.gender}
                                            </td>
                                            <td>
                                                <span class="badge bg-light text-dark border px-3 py-2">
                                                    <i class="fas fa-stethoscope me-1"></i>
                                                    ${user.specialization}
                                                </span>
                                            </td>
                                            <td>
                                                <i class="fas fa-calendar-alt text-muted me-2"></i>
                                                <fmt:formatDate value="${user.dob}" pattern="dd/MM/yyyy" />
                                            </td>
                                            <td>
                                                <i class="fas fa-phone-alt text-muted me-2"></i>
                                                <strong>${user.phone}</strong>
                                            </td>
                                            <td>
                                                <span class="status-badge ${user.status == 'Hoạt động' ? 'status-active' : 'status-inactive'}">
                                                    ${user.status}
                                                </span>
                                            </td>
                                            <td>
                                                <div class="action-buttons">
                                                    <a href="${pageContext.request.contextPath}/ViewDetailEmployeesServlet?id=${user.userID}" 
                                                       class="btn btn-sm btn-info" title="Xem chi tiết">
                                                        <i class="fas fa-eye"></i>
                                                        Chi tiết
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/UpdateEmployeeServlet?id=${user.userID}" 
                                                       class="btn btn-sm btn-primary" title="Chỉnh sửa">
                                                        <i class="fas fa-edit"></i>
                                                        Sửa
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/DeleteEmployeeServlet?id=${user.userID}" 
                                                       class="btn btn-sm btn-danger" title="Xóa nhân viên"
                                                       onclick="return confirm('⚠️ Bạn có chắc chắn muốn xóa nhân viên ${user.fullName} không?\n\nHành động này không thể hoàn tác!');">
                                                        <i class="fas fa-trash"></i>
                                                        Xóa
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
                                                <i class="fas fa-users-slash"></i>
                                                <h5>Chưa Có Dữ Liệu Nhân Viên</h5>
                                                <p class="mb-3">Hiện tại chưa có nhân viên nào trong hệ thống.</p>
                                                <a href="${pageContext.request.contextPath}/views/admin/AddEmployees.jsp" 
                                                   class="btn btn-success">
                                                    <i class="fas fa-user-plus"></i>
                                                    Thêm Nhân Viên Đầu Tiên
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
</body>
<div style="height: 200px;"></div>
    <jsp:include page="/assets/footer.jsp" />
            </html>
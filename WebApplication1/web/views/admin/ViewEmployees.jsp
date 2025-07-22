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
    <title>Quản Lý Nhân Viên - Hệ Thống</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2563eb;
            --secondary-color: #64748b;
            --success-color: #10b981;
            --danger-color: #ef4444;
            --warning-color: #f59e0b;
            --light-bg: #f8fafc;
            --border-color: #e2e8f0;
            --text-dark: #1e293b;
            --text-muted: #64748b;
        }

        body {
            background-color: var(--light-bg);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif;
            color: var(--text-dark);
            line-height: 1.6;
        }

        /* Header Styles */
        .main-header {
            background: linear-gradient(135deg, #1e40af 0%, #3b82f6 100%);
            color: white;
            padding: 1rem 0;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .breadcrumb-nav {
            background: none;
            padding: 0;
            margin: 0;
            font-size: 0.875rem;
        }

        .breadcrumb-nav .breadcrumb-item {
            color: rgba(255, 255, 255, 0.8);
        }

        .breadcrumb-nav .breadcrumb-item.active {
            color: white;
            font-weight: 500;
        }

        .breadcrumb-nav .breadcrumb-item + .breadcrumb-item::before {
            content: "›";
            color: rgba(255, 255, 255, 0.6);
        }

        .breadcrumb-nav .breadcrumb-item a {
            color: rgba(255, 255, 255, 0.9);
            text-decoration: none;
            transition: color 0.2s;
        }

        .breadcrumb-nav .breadcrumb-item a:hover {
            color: white;
        }

        /* Main Content */
        .main-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 1rem;
        }

        .content-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            border: 1px solid var(--border-color);
        }

        .card-header {
            padding: 1.5rem;
            border-bottom: 1px solid var(--border-color);
            background: #fafbfc;
            border-radius: 12px 12px 0 0;
        }

        .card-body {
            padding: 1.5rem;
        }

        .page-title {
            font-size: 1.75rem;
            font-weight: 600;
            color: var(--text-dark);
            margin: 0;
        }

        /* Buttons */
        .btn {
            font-weight: 500;
            border-radius: 8px;
            padding: 0.5rem 1rem;
            transition: all 0.2s;
            border: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary {
            background-color: var(--primary-color);
            color: white;
        }

        .btn-primary:hover {
            background-color: #1d4ed8;
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(37, 99, 235, 0.25);
        }

        .btn-success {
            background-color: var(--success-color);
            color: white;
        }

        .btn-success:hover {
            background-color: #059669;
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(16, 185, 129, 0.25);
        }

        .btn-info {
            background-color: #0ea5e9;
            color: white;
        }

        .btn-info:hover {
            background-color: #0284c7;
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(14, 165, 233, 0.25);
        }

        .btn-danger {
            background-color: var(--danger-color);
            color: white;
        }

        .btn-danger:hover {
            background-color: #dc2626;
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(239, 68, 68, 0.25);
        }

        .btn-sm {
            padding: 0.375rem 0.75rem;
            font-size: 0.875rem;
        }

        /* Search Form */
        .search-section {
            background: #f8fafc;
            padding: 1.25rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            border: 1px solid var(--border-color);
        }

        .search-form {
            display: flex;
            gap: 0.75rem;
            max-width: 500px;
        }

        .form-control {
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 0.625rem 0.875rem;
            transition: all 0.2s;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        /* Table */
        .table-container {
            overflow-x: auto;
            border-radius: 8px;
            border: 1px solid var(--border-color);
        }

        .table {
            margin: 0;
            font-size: 0.875rem;
        }

        .table thead th {
            background-color: #f8fafc;
            border-bottom: 2px solid var(--border-color);
            font-weight: 600;
            color: var(--text-dark);
            padding: 1rem 0.75rem;
            text-align: center;
            white-space: nowrap;
        }

        .table tbody td {
            padding: 0.875rem 0.75rem;
            vertical-align: middle;
            border-bottom: 1px solid #f1f5f9;
            text-align: center;
        }

        .table tbody tr:hover {
            background-color: #f8fafc;
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
            background-color: #dcfce7;
            color: #166534;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            border-left: 4px solid var(--success-color);
            display: flex;
            align-items: center;
            gap: 0.75rem;
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
            padding: 0.5rem 0.75rem;
            margin: 0 2px;
            border-radius: 6px;
            text-decoration: none;
            transition: all 0.2s;
        }

        .pagination .page-link:hover {
            background-color: #f1f5f9;
            border-color: var(--primary-color);
        }

        .pagination .page-item.active .page-link {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
        }

        .pagination .page-item.disabled .page-link {
            color: var(--text-muted);
            background-color: #f8fafc;
            border-color: var(--border-color);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 3rem 1rem;
            color: var(--text-muted);
        }

        .empty-state i {
            font-size: 3rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .header-content {
                flex-direction: column;
                gap: 1rem;
                align-items: flex-start;
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
                font-size: 0.75rem;
                padding: 0.25rem 0.5rem;
            }
        }

        /* Status Badge */
        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 500;
            display: inline-block;
        }

        .status-active {
            background-color: #dcfce7;
            color: #166534;
        }

        .status-inactive {
            background-color: #fee2e2;
            color: #991b1b;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="main-header">
        <div class="container">
            <div class="header-content">
                <h1 class="header-title">
                    <i class="fas fa-users"></i>
                    Hệ Thống Quản Lý
                </h1>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb breadcrumb-nav">
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp">
                                <i class="fas fa-home"></i> Trang chủ
                            </a>
                        </li>
                        <li class="breadcrumb-item active" aria-current="page">Danh sách Nhân Viên</li>
                    </ol>
                </nav>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <div class="main-container">
        <div class="content-card">
            <div class="card-header">
                <div class="d-flex justify-content-between align-items-center">
                    <h2 class="page-title">Danh sách Nhân Viên</h2>
                    <a href="${pageContext.request.contextPath}/views/admin/AddEmployees.jsp" class="btn btn-success">
                        <i class="fas fa-plus"></i>
                        Thêm Nhân Viên
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
                               placeholder="Tìm kiếm theo tên, email, số điện thoại..."
                               value="${keyword != null ? keyword : ''}">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-search"></i>
                            Tìm kiếm
                        </button>
                    </form>
                </div>

                <!-- Table -->
                <div class="table-container">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Họ và Tên</th>
                                <th>Giới tính</th>
                                <th>Chuyên khoa</th>
                                <th>Ngày sinh</th>
                                <th>Số điện thoại</th>
                                <th>Trạng thái</th>
                                <th>Hành động</th>
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
                                            <td>${user.fullName}</td>
                                            <td>
                                                <i class="fas ${user.gender == 'Nam' ? 'fa-mars text-primary' : 'fa-venus text-danger'}"></i>
                                                ${user.gender}
                                            </td>
                                            <td>
                                                <span class="badge bg-light text-dark">${user.specialization}</span>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${user.dob}" pattern="dd/MM/yyyy" />
                                            </td>
                                            <td>
                                                <i class="fas fa-phone-alt text-muted me-1"></i>
                                                ${user.phone}
                                            </td>
                                            <td>
                                                <span class="status-badge ${user.status == 'Hoạt động' ? 'status-active' : 'status-inactive'}">
                                                    ${user.status}
                                                </span>
                                            </td>
                                            <td>
                                                <div class="action-buttons">
                                                    <a href="${pageContext.request.contextPath}/ViewDetailEmployeesServlet?id=${user.userID}" 
                                                       class="btn btn-sm btn-info">
                                                        <i class="fas fa-eye"></i>
                                                        Chi tiết
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/UpdateEmployeeServlet?id=${user.userID}" 
                                                       class="btn btn-sm btn-primary">
                                                        <i class="fas fa-edit"></i>
                                                        Sửa
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/DeleteEmployeeServlet?id=${user.userID}" 
                                                       class="btn btn-sm btn-danger" 
                                                       onclick="return confirm('Bạn có chắc muốn xóa nhân viên này không?');">
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
                                                <h5>Không có dữ liệu</h5>
                                                <p>Hiện tại chưa có nhân viên nào trong hệ thống.</p>
                                                <a href="${pageContext.request.contextPath}/views/admin/AddEmployees.jsp" 
                                                   class="btn btn-success">
                                                    <i class="fas fa-plus"></i>
                                                    Thêm nhân viên đầu tiên
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <c:if test="${not empty employees and totalItems > pageSize}">
                    <div class="pagination-container">
                        <nav aria-label="Page navigation">
                            <ul class="pagination">
                                <c:set var="prevPage" value="${page - 1}" />
                                <c:set var="nextPage" value="${page + 1}" />
                                
                                <li class="page-item ${page == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/ViewEmployeeServlet?page=${prevPage}${keyword != null ? '&keyword=' : ''}${keyword}">
                                        <i class="fas fa-chevron-left"></i>
                                        Trước
                                    </a>
                                </li>
                                
                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <li class="page-item ${page == i ? 'active' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/ViewEmployeeServlet?page=${i}${keyword != null ? '&keyword=' : ''}${keyword}">
                                            ${i}
                                        </a>
                                    </li>
                                </c:forEach>
                                
                                <li class="page-item ${page == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/ViewEmployeeServlet?page=${nextPage}${keyword != null ? '&keyword=' : ''}${keyword}">
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
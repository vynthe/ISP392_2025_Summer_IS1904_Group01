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
        /* Giữ nguyên toàn bộ CSS của bạn */
        :root {
            --primary-color: #6366f1;
            --primary-light: #8b5cf6;
            --primary-dark: #4338ca;
            --secondary-color: #64748b;
            --accent-color: #0ea5e9;
            --success-color: #22c55e;
            --success-light: #86efac;
            --warning-color: #f59e0b;
            --warning-light: #fde68a;
            --danger-color: #ef4444;
            --danger-light: #fca5a5;
            --info-color: #06b6d4;
            --info-light: #7dd3fc;
            
            --text-primary: #1e293b;
            --text-secondary: #64748b;
            --text-muted: #94a3b8;
            
            --bg-primary: #ffffff;
            --bg-secondary: #f8fafc;
            --bg-tertiary: #f1f5f9;
            --bg-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --bg-soft: linear-gradient(135deg, #e0e7ff 0%, #f3e8ff 100%);
            
            --border-color: #e2e8f0;
            --border-light: #f1f5f9;
            --border-dark: #cbd5e1;
            
            --shadow-xs: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
            --shadow-sm: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px -1px rgba(0, 0, 0, 0.1);
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -2px rgba(0, 0, 0, 0.1);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.1);
            --shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1);
            
            --border-radius-sm: 6px;
            --border-radius: 8px;
            --border-radius-lg: 12px;
            --border-radius-xl: 16px;
            --border-radius-2xl: 20px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: var(--bg-secondary);
            color: var(--text-primary);
            line-height: 1.6;
            font-weight: 400;
            min-height: 100vh;
        }

        .main-container {
            min-height: 100vh;
            padding: 1.5rem;
            background: var(--bg-soft);
        }

        .content-wrapper {
            max-width: 1400px;
            margin: 0 auto;
            background: var(--bg-primary);
            border-radius: var(--border-radius-2xl);
            box-shadow: var(--shadow-lg);
            overflow: hidden;
            border: 1px solid var(--border-light);
        }

        /* Header Styles */
        .header-section {
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            padding: 2.5rem 2rem;
            position: relative;
            border-bottom: 1px solid var(--border-light);
        }

        .header-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%236366f1' fill-opacity='0.03'%3E%3Ccircle cx='30' cy='30' r='2'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
        }

        .header-content {
            position: relative;
            z-index: 1;
        }

        .header-title {
            color: var(--text-primary);
            font-size: 2.25rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .header-title .icon-wrapper {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, var(--primary-color), var(--primary-light));
            border-radius: var(--border-radius-lg);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.25rem;
            box-shadow: var(--shadow-md);
        }

        .header-subtitle {
            color: var(--text-secondary);
            font-size: 1rem;
            font-weight: 400;
            margin-left: 66px;
        }

        .breadcrumb-nav {
            margin-top: 1.5rem;
            padding: 0.75rem 1.25rem;
            background: var(--bg-primary);
            border-radius: var(--border-radius-lg);
            border: 1px solid var(--border-color);
            display: inline-flex;
            align-items: center;
            gap: 0.75rem;
            box-shadow: var(--shadow-xs);
        }

        .breadcrumb-nav a {
            color: var(--text-secondary);
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s ease;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .breadcrumb-nav a:hover {
            color: var(--primary-color);
        }

        .breadcrumb-nav .current {
            color: var(--primary-color);
            font-weight: 600;
        }

        /* Content Section */
        .content-section {
            padding: 2rem;
        }

        /* Alert Styles */
        .alert-modern {
            border: none;
            border-radius: var(--border-radius-lg);
            padding: 1rem 1.5rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            position: relative;
            box-shadow: var(--shadow-sm);
        }

        .alert-success {
            background: linear-gradient(135deg, #f0fdf4, #dcfce7);
            color: #15803d;
            border-left: 4px solid var(--success-color);
        }

        .alert-success .btn-close {
            background: none;
            border: none;
            color: #15803d;
            opacity: 0.7;
            font-size: 1.2rem;
            cursor: pointer;
            transition: opacity 0.2s ease;
        }

        .alert-success .btn-close:hover {
            opacity: 1;
        }

        /* Action Bar */
        .action-bar {
            background: var(--bg-tertiary);
            padding: 1.5rem;
            border-radius: var(--border-radius-lg);
            margin-bottom: 2rem;
            border: 1px solid var(--border-light);
            display: flex;
            justify-content: between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .action-title {
            font-size: 1.125rem;
            font-weight: 600;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin: 0;
        }

        /* Search Section */
        .search-section {
            background: var(--bg-primary);
            padding: 1.5rem;
            border-radius: var(--border-radius-lg);
            border: 1px solid var(--border-color);
            margin-bottom: 2rem;
            box-shadow: var(--shadow-sm);
        }

        .search-header {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--border-light);
        }

        .search-title {
            font-size: 1.125rem;
            font-weight: 600;
            color: var(--text-primary);
            margin: 0;
        }

        /* Form Controls */
        .form-label {
            font-weight: 500;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
            font-size: 0.875rem;
        }

        .form-control-modern {
            border: 1px solid var(--border-color);
            border-radius: var(--border-radius);
            padding: 0.75rem 1rem;
            font-size: 0.875rem;
            transition: all 0.2s ease;
            background-color: var(--bg-primary);
            color: var(--text-primary);
        }

        .form-control-modern:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
            outline: none;
            background-color: var(--bg-primary);
        }

        .form-control-modern::placeholder {
            color: var(--text-muted);
        }

        /* Button Styles */
        .btn-modern {
            padding: 0.75rem 1.5rem;
            border-radius: var(--border-radius);
            font-weight: 500;
            font-size: 0.875rem;
            border: none;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            transition: all 0.2s ease;
            position: relative;
            overflow: hidden;
        }

        .btn-modern::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s ease;
        }

        .btn-modern:hover::before {
            left: 100%;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-light));
            color: white;
            box-shadow: var(--shadow-sm);
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, var(--primary-dark), var(--primary-color));
            transform: translateY(-1px);
            box-shadow: var(--shadow-md);
            color: white;
        }

        .btn-success {
            background: linear-gradient(135deg, var(--success-color), #10b981);
            color: white;
            box-shadow: var(--shadow-sm);
        }

        .btn-success:hover {
            background: linear-gradient(135deg, #16a34a, var(--success-color));
            transform: translateY(-1px);
            box-shadow: var(--shadow-md);
            color: white;
        }

        .btn-warning {
            background: linear-gradient(135deg, var(--warning-color), #eab308);
            color: white;
            box-shadow: var(--shadow-sm);
        }

        .btn-warning:hover {
            background: linear-gradient(135deg, #d97706, var(--warning-color));
            transform: translateY(-1px);
            box-shadow: var(--shadow-md);
            color: white;
        }

        .btn-danger {
            background: linear-gradient(135deg, var(--danger-color), #dc2626);
            color: white;
            box-shadow: var(--shadow-sm);
        }

        .btn-danger:hover {
            background: linear-gradient(135deg, #b91c1c, var(--danger-color));
            transform: translateY(-1px);
            box-shadow: var(--shadow-md);
            color

: white;
        }

        .btn-info {
            background: linear-gradient(135deg, var(--info-color), #0891b2);
            color: white;
            box-shadow: var(--shadow-sm);
        }

        .btn-info:hover {
            background: linear-gradient(135deg, #0e7490, var(--info-color));
            transform: translateY(-1px);
            box-shadow: var(--shadow-md);
            color: white;
        }

        .btn-sm {
            padding: 0.5rem 1rem;
            font-size: 0.75rem;
        }

        /* Table Styles */
        .table-container {
            background: var(--bg-primary);
            border-radius: var(--border-radius-lg);
            overflow: hidden;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
        }

        .table-modern {
            margin: 0;
            width: 100%;
        }

        .table-modern thead {
            background: linear-gradient(135deg, var(--bg-tertiary), var(--bg-secondary));
        }

        .table-modern th {
            padding: 1rem 1.5rem;
            font-weight: 600;
            font-size: 0.875rem;
            color: var(--text-primary);
            border: none;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            border-bottom: 1px solid var(--border-color);
        }

        .table-modern td {
            padding: 1rem 1.5rem;
            border: none;
            border-bottom: 1px solid var(--border-light);
            vertical-align: middle;
            font-size: 0.875rem;
        }

        .table-modern tbody tr {
            transition: all 0.2s ease;
        }

        .table-modern tbody tr:hover {
            background: var(--bg-secondary);
            transform: scale(1.001);
        }

        .table-modern tbody tr:last-child td {
            border-bottom: none;
        }

        /* Status Badges */
        .status-badge {
            padding: 0.375rem 0.875rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            display: inline-flex;
            align-items: center;
            gap: 0.375rem;
        }

        .status-active {
            background: linear-gradient(135deg, #dcfce7, #bbf7d0);
            color: #15803d;
            border: 1px solid #86efac;
        }

        .status-inactive {
            background: linear-gradient(135deg, #fee2e2, #fecaca);
            color: #b91c1c;
            border: 1px solid #fca5a5;
        }

        .status-badge i {
            font-size: 0.5rem;
        }

        /* Price Display */
        .price-display {
            font-weight: 600;
            color: var(--success-color);
            font-size: 0.875rem;
            font-family: 'Inter', monospace;
        }

        /* ID Display */
        .id-display {
            font-weight: 700;
            color: var(--primary-color);
            font-family: 'Inter', monospace;
        }

        /* Service Name */
        .service-name {
            font-weight: 600;
            color: var(--text-primary);
        }

        /* Date Display */
        .date-display {
            color: var(--text-secondary);
            font-size: 0.875rem;
            display: flex;
            align-items: center;
            gap: 0.375rem;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: var(--text-secondary);
        }

        .empty-state .icon {
            font-size: 4rem;
            color: var(--text-muted);
            margin-bottom: 1.5rem;
            opacity: 0.6;
        }

        .empty-state h5 {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.75rem;
        }

        .empty-state p {
            font-size: 1rem;
            margin-bottom: 2rem;
            max-width: 400px;
            margin-left: auto;
            margin-right: auto;
        }

        /* Pagination */
        .pagination-container {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 0.5rem;
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid var(--border-light);
        }

        .page-link {
            padding: 0.75rem 1rem;
            border: 1px solid var(--border-color);
            border-radius: var(--border-radius);
            color: var(--text-secondary);
            text-decoration: none;
            font-weight: 500;
            transition: all 0.2s ease;
            min-width: 44px;
            text-align: center;
            background: var(--bg-primary);
        }

        .page-link:hover {
            background: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
            transform: translateY(-1px);
            box-shadow: var(--shadow-sm);
        }

        .page-link.active {
            background: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
            box-shadow: var(--shadow-sm);
        }

        .page-link.disabled {
            opacity: 0.5;
            cursor: not-allowed;
            pointer-events: none;
        }

        /* Responsive Design */
        @media (max-width: 1200px) {
            /* Xóa các quy tắc liên quan đến stats-grid */
        }

        @media (max-width: 768px) {
            .main-container {
                padding: 1rem;
            }

            .header-section {
                padding: 1.5rem 1rem;
            }

            .content-section {
                padding: 1rem;
            }

            .header-title {
                font-size: 1.75rem;
                flex-direction: column;
                align-items: flex-start;
                gap: 0.75rem;
            }

            .header-subtitle {
                margin-left: 0;
            }

            .action-bar {
                flex-direction: column;
                align-items: stretch;
            }

            .table-modern {
                font-size: 0.8rem;
            }

            .table-modern th,
            .table-modern td {
                padding: 0.75rem 0.5rem;
            }

            .btn-modern {
                padding: 0.5rem 1rem;
                font-size: 0.8rem;
            }

            .action-buttons {
                flex-direction: column;
            }
        }

        @media (max-width: 480px) {
            .pagination-container {
                flex-wrap: wrap;
                gap: 0.25rem;
            }

            .page-link {
                padding: 0.5rem 0.75rem;
                font-size: 0.8rem;
                min-width: 36px;
            }
        }

        /* Animation Classes */
        .fade-in {
            animation: fadeIn 0.5s ease-in;
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

        .slide-in {
            animation: slideIn 0.3s ease-out;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateX(-20px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
    </style>
</head>
<body>
    <div class="main-container">
        <div class="content-wrapper fade-in">
            <!-- Header Section -->
            <div class="header-section">
                <div class="header-content">
                    <div class="d-flex justify-content-between align-items-start flex-wrap">
                        <div>
                            <h1 class="header-title">
                                <div class="icon-wrapper">
                                    <i class="fas fa-cogs"></i>
                                </div>
                                <div>
                                    <div>Quản Lý Dịch Vụ</div>
                                    <div class="header-subtitle">Quản lý và theo dõi tất cả dịch vụ trong hệ thống</div>
                                </div>
                            </h1>
                        </div>
                        <div class="breadcrumb-nav">
                            <a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp">
                                <i class="fas fa-home"></i>
                                Trang chủ
                            </a>
                            <i class="fas fa-chevron-right text-muted"></i>
                            <span class="current">Dịch vụ</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Content Section -->
            <div class="content-section">
                <!-- Success Alert -->
                <c:if test="${not empty successMessage}">
                    <div class="alert-modern alert-success slide-in">
                        <i class="fas fa-check-circle"></i>
                        <span>${successMessage}</span>
                        <button type="button" class="btn-close ms-auto" onclick="this.parentElement.remove()">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                </c:if>

                <!-- Action Bar -->
                <div class="action-bar">
                    <h5 class="action-title">
                        <i class="fas fa-list"></i>
                        Danh Sách Dịch Vụ
                    </h5>
                    <a href="${pageContext.request.contextPath}/views/admin/AddService.jsp" 
                       class="btn-modern btn-success">
                        <i class="fas fa-plus"></i>
                        Thêm Dịch Vụ Mới
                    </a>
                </div>

                <!-- Search Section -->
                <div class="search-section">
                    <div class="search-header">
                        <i class="fas fa-search" style="color: var(--primary-color);"></i>
                        <h6 class="search-title">Tìm Kiếm & Lọc Dịch Vụ</h6>
                    </div>
                    <form action="${pageContext.request.contextPath}/ViewServiceServlet" method="get">
                        <div class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label">
                                    <i class="fas fa-search me-1"></i>
                                    Tìm kiếm theo ID hoặc Tên
                                </label>
                                <input type="text" class="form-control form-control-modern" 
                                       name="keyword" value="${param.keyword}" 
                                       placeholder="Nhập ID hoặc tên dịch vụ...">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">
                                    <i class="fas fa-money-bill-wave me-1"></i>
                                    Giá từ (VNĐ)
                                </label>
                                <input type="number" step="1000" min="0" 
                                       class="form-control form-control-modern" 
                                       name="minPrice" value="${param.minPrice}" 
                                       placeholder="0">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">
                                    <i class="fas fa-money-bill-wave me-1"></i>
                                    Giá đến (VNĐ)
                                </label>
                                <input type="number" step="1000" min="0" 
                                       class="form-control form-control-modern" 
                                       name="maxPrice" value="${param.maxPrice}" 
                                       placeholder="1,000,000">
                            </div>
                            <div class="col-md-2">
                                <label class="form-label"> </label>
                                <button type="submit" class="btn-modern btn-primary w-100">
                                    <i class="fas fa-search"></i>
                                    Tìm Kiếm
                                </button>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Services Table -->
                <div class="table-container">
                    <table class="table table-modern">
                        <thead>
                            <tr>
                                <th>
                                    <i class="fas fa-hashtag me-2"></i>
                                    ID
                                </th>
                                <th>
                                    <i class="fas fa-tag me-2"></i>
                                    Tên Dịch Vụ
                                </th>
                                <th>
                                    <i class="fas fa-dollar-sign me-2"></i>
                                    Giá Tiền
                                </th>
                                <th>
                                    <i class="fas fa-toggle-on me-2"></i>
                                    Trạng Thái
                                </th>
                                <th>
                                    <i class="fas fa-calendar-plus me-2"></i>
                                    Ngày Tạo
                                </th>
                                <th>
                                    <i class="fas fa-calendar-edit me-2"></i>
                                    Cập Nhật
                                </th>
                                <th>
                                    <i class="fas fa-cog me-2"></i>
                                    Thao Tác
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
                                        <tr class="slide-in">
                                            <td>
                                                <span class="id-display">#${service.serviceID}</span>
                                            </td>
                                            <td>
                                                <div class="service-name">${service.serviceName}</div>
                                            </td>
                                            <td>
                                                <span class="price-display">
                                                    <i class="fas fa-dong-sign me-1"></i>
                                                    <fmt:formatNumber value="${service.price}" type="number" pattern="#,##0" />
                                                </span>
                                            </td>
                                            <td>
                                                <span class="status-badge ${service.status == 'Active' ? 'status-active' : 'status-inactive'}">
                                                    <i class="fas fa-circle"></i>
                                                    ${service.status == 'Active' ? 'Hoạt động' : 'Tạm dừng'}
                                                </span>
                                            </td>
                                            <td>
                                                <div class="date-display">
                                                    <i class="fas fa-calendar"></i>
                                                    <fmt:formatDate value="${service.createdAt}" pattern="dd/MM/yyyy" />
                                                </div>
                                            </td>
                                            <td>
                                                <div class="date-display">
                                                    <i class="fas fa-calendar-check"></i>
                                                    <fmt:formatDate value="${service.updatedAt}" pattern="dd/MM/yyyy" />
                                                </div>
                                            </td>
                                            <td>
                                                <div class="action-buttons">
                                                    <a href="${pageContext.request.contextPath}/ViewDetailServiceAdminServlet?id=${service.serviceID}" 
                                                       class="btn-modern btn-info btn-sm" 
                                                       title="Xem chi tiết">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/UpdateServiceServlet?id=${service.serviceID}" 
                                                       class="btn-modern btn-warning btn-sm" 
                                                       title="Chỉnh sửa">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/DeleteServiceServlet?id=${service.serviceID}" 
                                                       class="btn-modern btn-danger btn-sm" 
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
                                                <h5>Không có dữ liệu</h5>
                                                <p>Hiện tại không có dịch vụ nào trong hệ thống. Hãy thêm dịch vụ đầu tiên để bắt đầu quản lý.</p>
                                                <a href="${pageContext.request.contextPath}/views/admin/AddService.jsp" 
                                                   class="btn-modern btn-primary">
                                                    <i class="fas fa-plus"></i>
                                                    Thêm Dịch Vụ Đầu Tiên
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
                        <div class="pagination-container">
                            <c:set var="prevPage" value="${page - 1}" />
                            <c:set var="nextPage" value="${page + 1}" />
                            
                            <a href="${pageContext.request.contextPath}/ViewServiceServlet?page=${prevPage}&keyword=${param.keyword}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}" 
                               class="page-link ${page == 1 ? 'disabled' : ''}">
                                <i class="fas fa-chevron-left"></i>
                            </a>
                            
                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <a href="${pageContext.request.contextPath}/ViewServiceServlet?page=${i}&keyword=${param.keyword}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}" 
                                   class="page-link ${page == i ? 'active' : ''}">
                                    ${i}
                                </a>
                            </c:forEach>
                            
                            <a href="${pageContext.request.contextPath}/ViewServiceServlet?page=${nextPage}&keyword=${param.keyword}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}" 
                               class="page-link ${page == totalPages ? 'disabled' : ''}">
                                <i class="fas fa-chevron-right"></i>
                            </a>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Enhanced UI Interactions
        document.addEventListener('DOMContentLoaded', function() {
            // Auto-hide alerts after 5 seconds with smooth animation
            const alerts = document.querySelectorAll('.alert-modern');
            alerts.forEach(alert => {
                setTimeout(() => {
                    alert.style.opacity = '0';
                    alert.style.transform = 'translateX(100%)';
                    setTimeout(() => {
                        alert.remove();
                    }, 300);
                }, 5000);
            });

            // Enhanced table row interactions
            const tableRows = document.querySelectorAll('.table-modern tbody tr');
            tableRows.forEach(row => {
                row.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-2px)';
                    this.style.boxShadow = 'var(--shadow-md)';
                    this.style.background = 'linear-gradient(135deg, #f8fafc, #f1f5f9)';
                });
                
                row.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                    this.style.boxShadow = 'none';
                    this.style.background = '';
                });
            });

            // Smooth scrolling for internal links
            document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                anchor.addEventListener('click', function (e) {
                    e.preventDefault();
                    const target = document.querySelector(this.getAttribute('href'));
                    if (target) {
                        target.scrollIntoView({
                            behavior: 'smooth',
                            block: 'start'
                        });
                    }
                });
            });

            // Add loading state to buttons
            const buttons = document.querySelectorAll('.btn-modern');
            buttons.forEach(button => {
                button.addEventListener('click', function(e) {
                    if (this.type === 'submit' || this.href) {
                        const originalText = this.innerHTML;
                        this.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang xử lý...';
                        this.disabled = true;
                        
                        // Re-enable button after 3 seconds in case of error
                        setTimeout(() => {
                            this.innerHTML = originalText;
                            this.disabled = false;
                        }, 3000);
                    }
                });
            });

            // Add search input debounce
            const searchInput = document.querySelector('input[name="keyword"]');
            if (searchInput) {
                let searchTimeout;
                searchInput.addEventListener('input', function() {
                    clearTimeout(searchTimeout);
                    searchTimeout = setTimeout(() => {
                        // Optional: Auto-submit search after user stops typing
                        // this.form.submit();
                    }, 500);
                });
            }

            // Enhance form validation
            const forms = document.querySelectorAll('form');
            forms.forEach(form => {
                form.addEventListener('submit', function(e) {
                    const inputs = this.querySelectorAll('input[required]');
                    let isValid = true;
                    
                    inputs.forEach(input => {
                        if (!input.value.trim()) {
                            input.classList.add('is-invalid');
                            isValid = false;
                        } else {
                            input.classList.remove('is-invalid');
                        }
                    });
                    
                    if (!isValid) {
                        e.preventDefault();
                        alert('Vui lòng điền đầy đủ thông tin bắt buộc!');
                        return false;
                    }
                });
            });

            // Add keyboard navigation support
            document.addEventListener('keydown', function(e) {
                // Ctrl/Cmd + K to focus search
                if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
                    e.preventDefault();
                    const searchInput = document.querySelector('input[name="keyword"]');
                    if (searchInput) {
                        searchInput.focus();
                        searchInput.select();
                    }
                }
                
                // Escape to clear search
                if (e.key === 'Escape') {
                    const searchInput = document.querySelector('input[name="keyword"]');
                    if (searchInput && document.activeElement === searchInput) {
                        searchInput.value = '';
                        searchInput.blur();
                    }
                }
            });

            // Add tooltips to action buttons
            const actionButtons = document.querySelectorAll('.action-buttons .btn-modern');
            actionButtons.forEach(button => {
                button.addEventListener('mouseenter', function() {
                    const title = this.getAttribute('title');
                    if (title) {
                        const tooltip = document.createElement('div');
                        tooltip.className = 'tooltip-custom';
                        tooltip.textContent = title;
                        tooltip.style.cssText = `
                            position: absolute;
                            background: var(--text-primary);
                            color: white;
                            padding: 0.5rem 0.75rem;
                            border-radius: var(--border-radius);
                            font-size: 0.75rem;
                            z-index: 1000;
                            white-space: nowrap;
                            box-shadow: var(--shadow-md);
                            opacity: 0;
                            transform: translateY(10px);
                            transition: all 0.2s ease;
                            pointer-events: none;
                        `;
                        
                        document.body.appendChild(tooltip);
                        
                        const rect = this.getBoundingClientRect();
                        tooltip.style.left = rect.left + (rect.width / 2) - (tooltip.offsetWidth / 2) + 'px';
                        tooltip.style.top = rect.bottom + 8 + 'px';
                        
                        setTimeout(() => {
                            tooltip.style.opacity = '1';
                            tooltip.style.transform = 'translateY(0)';
                        }, 10);
                        
                        this.tooltipElement = tooltip;
                    }
                });
                
                button.addEventListener('mouseleave', function() {
                    if (this.tooltipElement) {
                        this.tooltipElement.style.opacity = '0';
                        this.tooltipElement.style.transform = 'translateY(10px)';
                        setTimeout(() => {
                            if (this.tooltipElement) {
                                this.tooltipElement.remove();
                                this.tooltipElement = null;
                            }
                        }, 200);
                    }
                });
            });

            // Add progressive loading for large datasets
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.classList.add('fade-in');
                    }
                });
            });

            document.querySelectorAll('.table-modern tbody tr').forEach(el => {
                observer.observe(el);
            });

            // Add copy-to-clipboard functionality for service IDs
            document.querySelectorAll('.id-display').forEach(idElement => {
                idElement.style.cursor = 'pointer';
                idElement.title = 'Click để sao chép ID';
                
                idElement.addEventListener('click', function() {
                    const text = this.textContent.replace('#', '');
                    navigator.clipboard.writeText(text).then(() => {
                        const originalText = this.textContent;
                        this.textContent = '✓ Đã sao chép';
                        this.style.color = 'var(--success-color)';
                        
                        setTimeout(() => {
                            this.textContent = originalText;
                            this.style.color = '';
                        }, 1500);
                    });
                });
            });
        });

        // Add CSS for invalid inputs
        const style = document.createElement('style');
        style.textContent = `
            .form-control-modern.is-invalid {
                border-color: var(--danger-color);
                box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.1);
            }
            
            .tooltip-custom::before {
                content: '';
                position: absolute;
                top: -5px;
                left: 50%;
                transform: translateX(-50%);
                border-left: 5px solid transparent;
                border-right: 5px solid transparent;
                border-bottom: 5px solid var(--text-primary);
            }
        `;
        document.head.appendChild(style);
    </script>
</body>
</html>
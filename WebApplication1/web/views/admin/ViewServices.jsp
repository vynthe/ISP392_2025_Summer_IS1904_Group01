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
    <style>
        :root {
            --primary-color: #6366f1;
            --primary-hover: #4f46e5;
            --secondary-color: #8b5cf6;
            --success-color: #10b981;
            --success-hover: #059669;
            --warning-color: #f59e0b;
            --danger-color: #ef4444;
            --danger-hover: #dc2626;
            --text-primary: #1f2937;
            --text-secondary: #6b7280;
            --bg-light: #f9fafb;
            --border-color: #e5e7eb;
            --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
            --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
            --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
            --shadow-xl: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: var(--text-primary);
            line-height: 1.6;
        }

        .main-container {
            min-height: 100vh;
            padding: 2rem 1rem;
        }

        .content-wrapper {
            max-width: 1400px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            box-shadow: var(--shadow-xl);
            overflow: hidden;
            position: relative;
        }

        .header-section {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            padding: 2rem;
            position: relative;
            overflow: hidden;
        }

        .header-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 100" fill="white" opacity="0.1"><polygon points="0,0 1000,0 1000,100 0,80"/></svg>');
            background-size: cover;
        }

        .header-content {
            position: relative;
            z-index: 1;
        }

        .header-title {
            color: white;
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .header-subtitle {
            color: rgba(255, 255, 255, 0.9);
            font-size: 1rem;
            font-weight: 400;
        }

        .nav-breadcrumb {
            background: rgba(255, 255, 255, 0.1);
            padding: 0.5rem 1rem;
            border-radius: 50px;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            margin-top: 1rem;
        }

        .nav-breadcrumb a {
            color: white;
            text-decoration: none;
            font-weight: 500;
            transition: opacity 0.2s;
        }

        .nav-breadcrumb a:hover {
            opacity: 0.8;
        }

        .content-section {
            padding: 2rem;
        }

        .action-bar {
            background: var(--bg-light);
            padding: 1.5rem;
            border-radius: 12px;
            margin-bottom: 2rem;
            border: 1px solid var(--border-color);
        }

        .search-section {
            background: white;
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
            margin-bottom: 2rem;
        }

        .search-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-modern {
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.2s ease;
            border: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
            font-size: 0.875rem;
        }

        .btn-primary-modern {
            background: var(--primary-color);
            color: white;
        }

        .btn-primary-modern:hover {
            background: var(--primary-hover);
            transform: translateY(-1px);
            box-shadow: var(--shadow-md);
            color: white;
        }

        .btn-success-modern {
            background: var(--success-color);
            color: white;
        }

        .btn-success-modern:hover {
            background: var(--success-hover);
            transform: translateY(-1px);
            box-shadow: var(--shadow-md);
            color: white;
        }

        .btn-warning-modern {
            background: var(--warning-color);
            color: white;
        }

        .btn-warning-modern:hover {
            background: #d97706;
            transform: translateY(-1px);
            box-shadow: var(--shadow-md);
            color: white;
        }

        .btn-danger-modern {
            background: var(--danger-color);
            color: white;
        }

        .btn-danger-modern:hover {
            background: var(--danger-hover);
            transform: translateY(-1px);
            box-shadow: var(--shadow-md);
            color: white;
        }

        .btn-sm-modern {
            padding: 0.5rem 1rem;
            font-size: 0.75rem;
        }

        .form-control-modern {
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 0.75rem 1rem;
            font-size: 0.875rem;
            transition: all 0.2s ease;
        }

        .form-control-modern:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
            outline: none;
        }

        .table-modern {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
        }

        .table-modern thead {
            background: linear-gradient(135deg, var(--bg-light) 0%, #f3f4f6 100%);
        }

        .table-modern th {
            font-weight: 600;
            color: var(--text-primary);
            padding: 1rem;
            border: none;
            font-size: 0.875rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .table-modern td {
            padding: 1rem;
            border: none;
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
            font-size: 0.875rem;
        }

        .table-modern tbody tr:hover {
            background: rgba(99, 102, 241, 0.05);
        }

        .table-modern tbody tr:last-child td {
            border-bottom: none;
        }

        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .status-active {
            background: rgba(16, 185, 129, 0.1);
            color: var(--success-color);
        }

        .status-inactive {
            background: rgba(239, 68, 68, 0.1);
            color: var(--danger-color);
        }

        .price-display {
            font-weight: 600;
            color: var(--success-color);
            font-size: 0.875rem;
        }

        .pagination-modern {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 0.5rem;
            margin-top: 2rem;
        }

        .pagination-modern .page-link-modern {
            padding: 0.5rem 0.75rem;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            color: var(--text-secondary);
            text-decoration: none;
            font-weight: 500;
            transition: all 0.2s ease;
            min-width: 40px;
            text-align: center;
        }

        .pagination-modern .page-link-modern:hover {
            background: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
        }

        .pagination-modern .page-link-modern.active {
            background: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
        }

        .pagination-modern .page-link-modern.disabled {
            opacity: 0.5;
            pointer-events: none;
        }

        .empty-state {
            text-align: center;
            padding: 3rem;
            color: var(--text-secondary);
        }

        .empty-state i {
            font-size: 3rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        .alert-modern {
            border: none;
            border-radius: 12px;
            padding: 1rem 1.5rem;
            margin-bottom: 1.5rem;
            position: relative;
            overflow: hidden;
        }

        .alert-success-modern {
            background: rgba(16, 185, 129, 0.1);
            color: var(--success-color);
            border-left: 4px solid var(--success-color);
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
            text-align: center;
        }

        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }

        .stat-label {
            font-size: 0.875rem;
            color: var(--text-secondary);
            font-weight: 500;
        }

        @media (max-width: 768px) {
            .main-container {
                padding: 1rem;
            }
            
            .header-section {
                padding: 1.5rem;
            }
            
            .content-section {
                padding: 1rem;
            }
            
            .header-title {
                font-size: 1.5rem;
            }
            
            .btn-modern {
                padding: 0.5rem 1rem;
                font-size: 0.8rem;
            }
            
            .table-modern {
                font-size: 0.8rem;
            }
            
            .table-modern th,
            .table-modern td {
                padding: 0.75rem 0.5rem;
            }
        }
    </style>
</head>
<body>
    <div class="main-container">
        <div class="content-wrapper">
            <!-- Header Section -->
            <div class="header-section">
                <div class="header-content">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <h1 class="header-title">
                                <i class="fas fa-cogs me-2"></i>
                                Quản Lý Dịch Vụ
                            </h1>
                        </div>
                        <div class="nav-breadcrumb">
                            <a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp">
                                <i class="fas fa-home me-1"></i>
                                Trang chủ
                            </a>
                            <i class="fas fa-chevron-right mx-2 opacity-50"></i>
                            <span>Dịch vụ</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Content Section -->
            <div class="content-section">
                <!-- Success Alert -->
                <c:if test="${not empty successMessage}">
                    <div class="alert-modern alert-success-modern">
                        <i class="fas fa-check-circle me-2"></i>
                        ${successMessage}
                        <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Statistics Cards -->

                <!-- Action Bar -->
                <div class="action-bar">
                    <div class="d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">
                            <i class="fas fa-list me-2"></i>
                            Danh Sách Dịch Vụ
                        </h5>
                        <a href="${pageContext.request.contextPath}/views/admin/AddService.jsp" 
                           class="btn-modern btn-success-modern">
                            <i class="fas fa-plus"></i>
                            Thêm Dịch Vụ Mới
                        </a>
                    </div>
                </div>

                <!-- Search Section -->
                <div class="search-section">
                    <div class="search-title">
                        <i class="fas fa-search"></i>
                        Tìm Kiếm & Lọc Dịch Vụ
                    </div>
                    <form action="${pageContext.request.contextPath}/ViewServiceServlet" method="get">
                        <div class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label">Tìm kiếm theo ID hoặc Tên</label>
                                <input type="text" class="form-control form-control-modern" 
                                       name="keyword" value="${param.keyword}" 
                                       placeholder="Nhập ID hoặc tên dịch vụ...">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Giá từ (VNĐ)</label>
                                <input type="number" step="1000" min="0" 
                                       class="form-control form-control-modern" 
                                       name="minPrice" value="${param.minPrice}" 
                                       placeholder="0">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Giá đến (VNĐ)</label>
                                <input type="number" step="1000" min="0" 
                                       class="form-control form-control-modern" 
                                       name="maxPrice" value="${param.maxPrice}" 
                                       placeholder="1,000,000">
                            </div>
                            <div class="col-md-2">
                                <label class="form-label">&nbsp;</label>
                                <button type="submit" class="btn-modern btn-primary-modern w-100">
                                    <i class="fas fa-search"></i>
                                    Tìm Kiếm
                                </button>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Services Table -->
                <div class="table-modern">
                    <table class="table table-hover mb-0">
                        <thead>
                            <tr>
                                <th>
                                    <i class="fas fa-hashtag me-1"></i>
                                    ID
                                </th>
                                <th>
                                    <i class="fas fa-tag me-1"></i>
                                    Tên Dịch Vụ
                                </th>
                                <th>
                                    <i class="fas fa-dollar-sign me-1"></i>
                                    Giá Tiền
                                </th>
                                <th>
                                    <i class="fas fa-toggle-on me-1"></i>
                                    Trạng Thái
                                </th>
                                <th>
                                    <i class="fas fa-calendar-plus me-1"></i>
                                    Ngày Tạo
                                </th>
                                <th>
                                    <i class="fas fa-calendar-edit me-1"></i>
                                    Cập Nhật
                                </th>
                                <th>
                                    <i class="fas fa-cog me-1"></i>
                                   Hành Động
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
                                                <span class="fw-bold text-primary">#${service.serviceID}</span>
                                            </td>
                                            <td>
                                                <div class="fw-semibold">${service.serviceName}</div>
                                            </td>
                                            <td>
                                                <span class="price-display">
                                                    <fmt:formatNumber value="${service.price}" type="number" pattern="#,##0" /> VNĐ
                                                </span>
                                            </td>
                                            <td>
                                                <span class="status-badge ${service.status == 'Active' ? 'status-active' : 'status-inactive'}">
                                                    <i class="fas fa-circle me-1"></i>
                                                    ${service.status}
                                                </span>
                                            </td>
                                            <td>
                                                <i class="fas fa-calendar me-1 text-muted"></i>
                                                <fmt:formatDate value="${service.createdAt}" pattern="dd/MM/yyyy" />
                                            </td>
                                            <td>
                                                <i class="fas fa-calendar me-1 text-muted"></i>
                                                <fmt:formatDate value="${service.updatedAt}" pattern="dd/MM/yyyy" />
                                            </td>
                                            <td>
                                                <div class="d-flex gap-1">
                                                    <a href="${pageContext.request.contextPath}/ViewDetailServiceAdminServlet?id=${service.serviceID}" 
                                                       class="btn-modern btn-primary-modern btn-sm-modern" 
                                                       title="Xem chi tiết">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/UpdateServiceServlet?id=${service.serviceID}" 
                                                       class="btn-modern btn-warning-modern btn-sm-modern" 
                                                       title="Chỉnh sửa">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/DeleteServiceServlet?id=${service.serviceID}" 
                                                       class="btn-modern btn-danger-modern btn-sm-modern" 
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
                                                <i class="fas fa-inbox"></i>
                                                <h5>Không có dữ liệu</h5>
                                                <p>Hiện tại không có dịch vụ nào trong hệ thống.</p>
                                                <a href="${pageContext.request.contextPath}/views/admin/AddService.jsp" 
                                                   class="btn-modern btn-primary-modern">
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
                </div>

                <!-- Pagination -->
                <c:if test="${not empty services and totalItems > pageSize}">
                    <div class="pagination-modern">
                        <c:set var="prevPage" value="${page - 1}" />
                        <c:set var="nextPage" value="${page + 1}" />
                        
                        <a href="${pageContext.request.contextPath}/ViewServiceServlet?page=${prevPage}&keyword=${param.keyword}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}" 
                           class="page-link-modern ${page == 1 ? 'disabled' : ''}">
                            <i class="fas fa-chevron-left"></i>
                        </a>
                        
                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <a href="${pageContext.request.contextPath}/ViewServiceServlet?page=${i}&keyword=${param.keyword}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}" 
                               class="page-link-modern ${page == i ? 'active' : ''}">
                                ${i}
                            </a>
                        </c:forEach>
                        
                        <a href="${pageContext.request.contextPath}/ViewServiceServlet?page=${nextPage}&keyword=${param.keyword}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}" 
                           class="page-link-modern ${page == totalPages ? 'disabled' : ''}">
                            <i class="fas fa-chevron-right"></i>
                        </a>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Auto-hide alerts after 5 seconds
        document.addEventListener('DOMContentLoaded', function() {
            const alerts = document.querySelectorAll('.alert-modern');
            alerts.forEach(alert => {
                setTimeout(() => {
                    alert.style.opacity = '0';
                    alert.style.transform = 'translateY(-10px)';
                    setTimeout(() => {
                        alert.remove();
                    }, 300);
                }, 5000);
            });
        });

        // Enhanced table interactions
        document.querySelectorAll('.table-modern tbody tr').forEach(row => {
            row.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-1px)';
                this.style.boxShadow = '0 4px 12px rgba(0,0,0,0.1)';
            });
            
            row.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
                this.style.boxShadow = 'none';
            });
        });

        // Smooth scrolling for navigation
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
    </script>
</body>
</html>
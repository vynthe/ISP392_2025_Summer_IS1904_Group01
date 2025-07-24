<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Phòng Khám - Hospital Management System</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2563eb;
            --primary-dark: #1d4ed8;
            --secondary-color: #64748b;
            --success-color: #059669;
            --warning-color: #d97706;
            --danger-color: #dc2626;
            --info-color: #0891b2;
            --light-color: #f8fafc;
            --dark-color: #1e293b;
            --border-color: #e2e8f0;
            --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
            --shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
            --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
            --radius: 8px;
            --radius-lg: 12px;
        }
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            line-height: 1.6;
            color: var(--dark-color);
        }
        .main-container {
            min-height: 100vh;
            padding: 2rem 1rem;
        }
        .content-wrapper {
            max-width: 1400px;
            margin: 0 auto;
            background: white;
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-lg);
            overflow: hidden;
        }
        .header-section {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            color: white;
            padding: 2rem;
            position: relative;
            overflow: hidden;
        }
        .header-section::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 200px;
            height: 200px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            transform: translate(50%, -50%);
        }
        .header-content {
            position: relative;
            z-index: 1;
        }
        .header-title {
            font-size: 2.25rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        .header-subtitle {
            font-size: 1.2rem;
            opacity: 0.9;
            font-weight: 400;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 1.5rem;
            margin-top: 2rem;
        }
        .stat-card {
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
            border-radius: var(--radius);
            padding: 1.25rem;
            text-align: center;
            border: 1px solid rgba(255, 255, 255, 0.3);
            transition: transform 0.3s ease;
        }
        .stat-card:hover {
            transform: translateY(-4px);
        }
        .stat-number {
            font-size: 1.75rem;
            font-weight: 700;
            display: block;
        }
        .stat-label {
            font-size: 1rem;
            opacity: 0.9;
            margin-top: 0.5rem;
        }
        .nav-section {
            background: var(--light-color);
            padding: 1.5rem 2rem;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 1rem;
        }
        .nav-left {
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-size: 1rem;
            font-weight: 600;
            color: var(--dark-color);
            background: rgba(255, 255, 255, 0.95);
            padding: 0.75rem 1rem;
            border-radius: var(--radius);
            box-shadow: var(--shadow-sm);
        }
        .breadcrumb a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s ease;
        }
        .breadcrumb a:hover {
            color: var(--primary-dark);
            text-decoration: underline;
        }
        .breadcrumb i {
            color: var(--secondary-color);
            font-size: 1.1rem;
        }
        .controls-section {
            padding: 1.5rem 2rem;
            background: white;
            border-bottom: 1px solid var(--border-color);
        }
        .search-form {
            display: flex;
            gap: 1rem;
            align-items: center;
            flex-wrap: wrap;
        }
        .search-group {
            flex: 1;
            min-width: 300px;
            position: relative;
        }
        .search-input {
            width: 100%;
            padding: 0.75rem 1rem 0.75rem 2.5rem;
            border: 2px solid var(--border-color);
            border-radius: var(--radius);
            font-size: 0.9rem;
            transition: all 0.3s ease;
            background: white;
        }
        .search-input:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.15);
        }
        .search-icon {
            position: absolute;
            left: 0.75rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--secondary-color);
            font-size: 1rem;
        }
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: var(--radius);
            font-size: 0.9rem;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s ease;
            white-space: nowrap;
        }
        .btn-primary {
            background: var(--primary-color);
            color: white;
        }
        .btn-primary:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: var(--shadow);
        }
        .btn-success {
            background: var(--success-color);
            color: white;
        }
        .btn-success:hover {
            background: #047857;
            transform: translateY(-2px);
            box-shadow: var(--shadow);
        }
        .btn-secondary {
            background: var(--secondary-color);
            color: white;
        }
        .btn-secondary:hover {
            background: #475569;
            transform: translateY(-2px);
            box-shadow: var(--shadow);
        }
        .table-section {
            padding: 0;
            overflow: hidden;
        }
        .table-container {
            overflow-x: auto;
        }
        .data-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.9rem;
            background: white;
        }
        .data-table th {
            background: var(--light-color);
            color: var(--dark-color);
            padding: 1.25rem;
            text-align: left;
            font-weight: 600;
            border-bottom: 2px solid var(--border-color);
            white-space: nowrap;
        }
        .data-table td {
            padding: 1.25rem;
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
        }
        .data-table tbody tr {
            transition: all 0.3s ease;
        }
        .data-table tbody tr:hover {
            background: #f1f5f9;
            transform: scale(1.005);
            box-shadow: var(--shadow-sm);
        }
        .room-id {
            font-weight: 600;
            color: var(--primary-color);
            font-family: 'Courier New', monospace;
        }
        .room-name {
            font-weight: 500;
            color: var(--dark-color);
        }
        .no-assignment {
            color: var(--secondary-color);
            font-style: italic;
            font-size: 0.85rem;
        }
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            border-radius: 9999px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            box-shadow: var(--shadow-sm);
        }
        .status-available {
            background: #dcfce7;
            color: #166534;
        }
        .status-completed {
            background: #dbeafe;
            color: #1e40af;
        }
        .status-unavailable {
            background: #fef2f2;
            color: #991b1b;
        }
        .status-in-progress {
            background: #fef3c7;
            color: #92400e;
        }
        .status-unknown {
            background: #f1f5f9;
            color: #475569;
        }
        .action-group {
            display: flex;
            gap: 0.75rem;
            align-items: center;
        }
        .btn-action {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            border: 1px solid transparent;
            border-radius: var(--radius);
            font-size: 0.8rem;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        .btn-view {
            background: var(--info-color);
            color: white;
            border-color: var(--info-color);
        }
        .btn-view:hover {
            background: #0e7490;
            transform: translateY(-2px);
            box-shadow: var(--shadow);
        }
        .btn-edit {
            background: var(--warning-color);
            color: white;
            border-color: var(--warning-color);
        }
        .btn-edit:hover {
            background: #b45309;
            transform: translateY(-2px);
            box-shadow: var(--shadow);
        }
        .btn-delete {
            background: var(--danger-color);
            color: white;
            border-color: var(--danger-color);
        }
        .btn-delete:hover {
            background: #b91c1c;
            transform: translateY(-2px);
            box-shadow: var(--shadow);
        }
        .btn-service {
            background: var(--success-color);
            color: white;
            border-color: var(--success-color);
        }
        .btn-service:hover {
            background: #047857;
            transform: translateY(-2px);
            box-shadow: var(--shadow);
        }
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: var(--secondary-color);
        }
        .empty-icon {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.3;
        }
        .empty-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--dark-color);
        }
        .empty-description {
            margin-bottom: 1.5rem;
            font-size: 1rem;
        }
        .loading-spinner {
            display: inline-block;
            width: 1rem;
            height: 1rem;
            border: 2px solid transparent;
            border-top: 2px solid currentColor;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        @keyframes spin {
            to {
                transform: rotate(360deg);
            }
        }
        @media (max-width: 1024px) {
            .main-container {
                padding: 1rem 0.5rem;
            }
            .header-section {
                padding: 1.5rem;
            }
            .header-title {
                font-size: 1.75rem;
            }
            .stats-grid {
                grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            }
        }
        @media (max-width: 768px) {
            .nav-section {
                flex-direction: column;
                align-items: stretch;
            }
            .search-form {
                flex-direction: column;
            }
            .search-group {
                min-width: 100%;
            }
            .action-group {
                flex-direction: column;
                gap: 0.5rem;
            }
            .btn-action {
                justify-content: center;
                width: 100%;
            }
            .data-table {
                min-width: 800px;
            }
        }
        @media (max-width: 480px) {
            .header-section {
                padding: 1rem;
            }
            .controls-section,
            .nav-section {
                padding: 1rem;
            }
            .stats-grid {
                grid-template-columns: 1fr;
            }
            .breadcrumb {
                font-size: 0.9rem;
                padding: 0.5rem 0.75rem;
            }
        }
    </style>
</head>
<body>
    <div class="main-container">
        <div class="content-wrapper">
            <!-- Header Section -->
            <div class="header-section" role="banner">
                <div class="header-content">
                    <h1 class="header-title">
                        <i class="fas fa-hospital" aria-hidden="true"></i>
                        Quản lý Phòng Khám
                    </h1>
                    <p class="header-subtitle">Hệ thống quản lý phòng bệnh viện hiện đại và chuyên nghiệp</p>
                    <div class="stats-grid">
                        <div class="stat-card">
                            <span class="stat-number">${roomList.size()}</span>
                            <div class="stat-label">Tổng số phòng</div>
                        </div>
                        <div class="stat-card">
                            <span class="stat-number">
                                <c:out value="${roomList.stream().filter(room -> room.status == 'Available').count()}"/>
                            </span>
                            <div class="stat-label">Phòng trống</div>
                        </div>
                        <div class="stat-card">
                            <span class="stat-number">
                                <c:out value="${roomList.stream().filter(room -> room.status == 'In Progress').count()}"/>
                            </span>
                            <div class="stat-label">Đang sử dụng</div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Navigation Section -->
            <div class="nav-section" role="navigation">
                <div class="nav-left">
                    <nav class="breadcrumb" aria-label="Breadcrumb">
                        <i class="fas fa-home" aria-hidden="true"></i>
                        <a href="${pageContext.request.contextPath}/${isAdmin ? 'views/admin/dashboard.jsp' : 'views/user/DoctorNurse/dashboard.jsp'}"
                           aria-current="page">Dashboard</a>
                        <i class="fas fa-chevron-right" aria-hidden="true"></i>
                        <span aria-current="page">Quản lý Phòng</span>
                    </nav>
                </div>
                <a href="${pageContext.request.contextPath}/${isAdmin ? 'views/admin/dashboard.jsp' : 'views/user/DoctorNurse/dashboard.jsp'}"
                   class="btn btn-secondary">
                    <i class="fas fa-arrow-left" aria-hidden="true"></i> Quay lại Dashboard
                </a>
            </div>
            <!-- Controls Section -->
            <div class="controls-section">
                <form class="search-form" method="get" action="${pageContext.request.contextPath}/ViewRoomServlet" aria-label="Tìm kiếm phòng">
                    <div class="search-group">
                        <i class="fas fa-search search-icon" aria-hidden="true"></i>
                        <input type="text" name="keyword" class="search-input"
                               placeholder="Tìm kiếm theo tên phòng, mã phòng, bác sĩ, y tá..."
                               value="${keyword}"
                               aria-label="Tìm kiếm phòng">
                        <select name="statusFilter" class="search-input" aria-label="Lọc theo trạng thái">
                            <option value="">-- Tất cả trạng thái --</option>
                            <option value="Available" ${statusFilter == 'Available' ? 'selected' : ''}>Còn Phòng</option>
                            <option value="In Progress" ${statusFilter == 'In Progress' ? 'selected' : ''}>Đang Khám</option>
                            <option value="Completed" ${statusFilter == 'Completed' ? 'selected' : ''}>Hoàn Thành</option>
                            <option value="Not Available" ${statusFilter == 'Not Available' ? 'selected' : ''}>Hết Phòng</option>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-primary" aria-label="Tìm kiếm">
                        <i class="fas fa-search" aria-hidden="true"></i> Tìm kiếm
                    </button>
                    <c:if test="${isAdmin}">
                        <a href="${pageContext.request.contextPath}/views/admin/AddRoom.jsp"
                           class="btn btn-success"
                           aria-label="Thêm phòng mới">
                            <i class="fas fa-plus-circle" aria-hidden="true"></i> Thêm phòng mới
                        </a>
                    </c:if>
                </form>
            </div>
            <!-- Table Section -->
            <div class="table-section" role="region" aria-label="Danh sách phòng">
                <c:choose>
                    <c:when test="${not empty roomList}">
                        <div class="table-container">
                            <table class="data-table" aria-label="Bảng danh sách phòng">
                                <thead>
                                    <tr>
                                        <th scope="col"><i class="fas fa-hashtag" aria-hidden="true"></i> Mã Phòng</th>
                                        <th scope="col"><i class="fas fa-door-open" aria-hidden="true"></i> Tên Phòng</th>
                                        <th scope="col"><i class="fas fa-align-left" aria-hidden="true"></i> Mô Tả</th>
                                        <th scope="col"><i class="fas fa-info-circle" aria-hidden="true"></i> Trạng Thái</th>
                                        <th scope="col"><i class="fas fa-user-plus" aria-hidden="true"></i> Người Tạo</th>
                                        <c:if test="${isAdmin}">
                                            <th scope="col"><i class="fas fa-cogs" aria-hidden="true"></i> Thao Tác</th>
                                        </c:if>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="room" items="${roomList}">
                                        <tr>
                                            <td><span class="room-id">${room.roomID}</span></td>
                                            <td><span class="room-name">${room.roomName}</span></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty room.description}">
                                                        <c:out value="${room.description}"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="no-assignment">Không có mô tả</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${room.status == 'Available'}">
                                                        <span class="status-badge status-available">
                                                            <i class="fas fa-check-circle" aria-hidden="true"></i> Còn Phòng
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${room.status == 'Completed'}">
                                                        <span class="status-badge status-completed">
                                                            <i class="fas fa-check-double" aria-hidden="true"></i> Hoàn Thành
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${room.status == 'Not Available'}">
                                                        <span class="status-badge status-unavailable">
                                                            <i class="fas fa-times-circle" aria-hidden="true"></i> Hết Phòng
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${room.status == 'In Progress'}">
                                                        <span class="status-badge status-in-progress">
                                                            <i class="fas fa-clock" aria-hidden="true"></i> Đang khám
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge status-unknown">
                                                            <i class="fas fa-question-circle" aria-hidden="true"></i> Không xác định
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty room.createdBy}">
                                                        <strong><c:out value="${room.createdBy}"/></strong>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="no-assignment">Không rõ</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <c:if test="${isAdmin}">
                                                <td>
                                                    <div class="action-group">
                                                        <a href="${pageContext.request.contextPath}/ViewRoomDetailServlet?id=${room.roomID}"
                                                           class="btn-action btn-view"
                                                           title="Xem chi tiết phòng"
                                                           aria-label="Xem chi tiết phòng ${room.roomID}">
                                                            <i class="fas fa-eye" aria-hidden="true"></i> Xem
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/UpdateRoomServlet?id=${room.roomID}"
                                                           class="btn-action btn-edit"
                                                           title="Chỉnh sửa thông tin phòng"
                                                           aria-label="Chỉnh sửa phòng ${room.roomID}">
                                                            <i class="fas fa-edit" aria-hidden="true"></i> Sửa
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/DeleteRoomServlet?id=${room.roomID}"
                                                           class="btn-action btn-delete"
                                                           title="Xóa phòng"
                                                           aria-label="Xóa phòng ${room.roomID}">
                                                            <i class="fas fa-trash" aria-hidden="true"></i> Xóa
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/AssignServiceToRoomServlet?roomId=${room.roomID}"
                                                           class="btn-action btn-service"
                                                           title="Quản lý dịch vụ phòng"
                                                           aria-label="Quản lý dịch vụ phòng ${room.roomID}">
                                                            <i class="fas fa-plus-circle" aria-hidden="true"></i> Dịch vụ
                                                        </a>
                                                    </div>
                                                </td>
                                            </c:if>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state" role="alert">
                            <i class="fas fa-bed empty-icon" aria-hidden="true"></i>
                            <h3 class="empty-title">Không tìm thấy phòng nào</h3>
                            <p class="empty-description">
                                <c:choose>
                                    <c:when test="${not empty keyword}">
                                        Không có phòng nào khớp với từ khóa tìm kiếm "<strong><c:out value="${keyword}"/></strong>".
                                        <br>Thử tìm kiếm với từ khóa khác hoặc
                                    </c:when>
                                    <c:otherwise>
                                        Hiện tại chưa có phòng nào trong hệ thống.
                                    </c:otherwise>
                                </c:choose>
                            </p>
                            <c:if test="${isAdmin}">
                                <a href="${pageContext.request.contextPath}/views/admin/AddRoom.jsp"
                                   class="btn btn-success"
                                   aria-label="Thêm phòng đầu tiên">
                                    <i class="fas fa-plus-circle" aria-hidden="true"></i> Thêm phòng đầu tiên
                                </a>
                            </c:if>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    <div style="height: 200px;"></div>
    <jsp:include page="/assets/footer.jsp" />
    <script>
        // Form submission with loading state
        const form = document.querySelector('.search-form');
        form.addEventListener('submit', function(e) {
            const submitBtn = this.querySelector('button[type="submit"]');
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin" aria-hidden="true"></i> Đang tìm...';
            submitBtn.disabled = true;
        });
        // Row hover effects
        document.querySelectorAll('.data-table tbody tr').forEach(row => {
            row.addEventListener('mouseenter', function() {
                this.style.transform = 'scale(1.005)';
            });
            row.addEventListener('mouseleave', function() {
                this.style.transform = 'scale(1)';
            });
        });
        // Custom delete confirmation
        document.querySelectorAll('.btn-delete').forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                const roomId = this.getAttribute('aria-label').match(/\d+/)[0];
                if (confirm(`Bạn có chắc chắn muốn xóa phòng ${roomId} không?\nHành động này không thể hoàn tác!`)) {
                    window.location.href = this.href;
                }
            });
        });
        // Ensure accessibility for keyboard navigation
        document.querySelectorAll('.btn-action').forEach(btn => {
            btn.addEventListener('keypress', function(e) {
                if (e.key === 'Enter' || e.key === ' ') {
                    e.preventDefault();
                    this.click();
                }
            });
        });
    </script>
</body>
</html>

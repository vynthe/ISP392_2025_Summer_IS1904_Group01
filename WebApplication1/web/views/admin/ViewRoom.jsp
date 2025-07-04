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
            --shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1);
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

        /* Header Section */
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
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .header-subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
            font-weight: 400;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-top: 1.5rem;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(10px);
            border-radius: var(--radius);
            padding: 1rem;
            text-align: center;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .stat-number {
            font-size: 1.5rem;
            font-weight: 700;
            display: block;
        }

        .stat-label {
            font-size: 0.875rem;
            opacity: 0.9;
            margin-top: 0.25rem;
        }

        /* Navigation Section */
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
            gap: 0.5rem;
            font-size: 0.875rem;
            color: var(--secondary-color);
        }

        .breadcrumb a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
        }

        .breadcrumb a:hover {
            text-decoration: underline;
        }

        /* Controls Section */
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
            font-size: 0.875rem;
            transition: all 0.2s ease;
            background: white;
        }

        .search-input:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
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
            font-size: 0.875rem;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.2s ease;
            white-space: nowrap;
        }

        .btn-primary {
            background: var(--primary-color);
            color: white;
        }

        .btn-primary:hover {
            background: var(--primary-dark);
            transform: translateY(-1px);
            box-shadow: var(--shadow);
        }

        .btn-success {
            background: var(--success-color);
            color: white;
        }

        .btn-success:hover {
            background: #047857;
            transform: translateY(-1px);
        }

        .btn-secondary {
            background: var(--secondary-color);
            color: white;
        }

        .btn-secondary:hover {
            background: #475569;
        }

        /* Table Section */
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
            font-size: 0.875rem;
        }

        .data-table th {
            background: var(--light-color);
            color: var(--dark-color);
            padding: 1rem;
            text-align: left;
            font-weight: 600;
            border-bottom: 2px solid var(--border-color);
            white-space: nowrap;
        }

        .data-table td {
            padding: 1rem;
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
        }

        .data-table tbody tr {
            transition: background-color 0.2s ease;
        }

        .data-table tbody tr:hover {
            background: #f1f5f9;
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

        .staff-info {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
        }

        .staff-name {
            font-weight: 500;
        }

        .staff-id {
            font-size: 0.75rem;
            color: var(--secondary-color);
        }

        .no-assignment {
            color: var(--secondary-color);
            font-style: italic;
            font-size: 0.8rem;
        }

        /* Status Badges */
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
            padding: 0.375rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.025em;
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

        /* Action Buttons */
        .action-group {
            display: flex;
            gap: 0.5rem;
            align-items: center;
        }

        .btn-action {
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
            padding: 0.375rem 0.75rem;
            border: 1px solid transparent;
            border-radius: var(--radius);
            font-size: 0.75rem;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.2s ease;
        }

        .btn-view {
            background: var(--info-color);
            color: white;
            border-color: var(--info-color);
        }

        .btn-view:hover {
            background: #0e7490;
            transform: translateY(-1px);
        }

        .btn-edit {
            background: var(--warning-color);
            color: white;
            border-color: var(--warning-color);
        }

        .btn-edit:hover {
            background: #b45309;
            transform: translateY(-1px);
        }

        .btn-delete {
            background: var(--danger-color);
            color: white;
            border-color: var(--danger-color);
        }

        .btn-delete:hover {
            background: #b91c1c;
            transform: translateY(-1px);
        }

        .btn-service {
            background: var(--success-color);
            color: white;
            border-color: var(--success-color);
        }

        .btn-service:hover {
            background: #047857;
            transform: translateY(-1px);
        }

        /* Empty State */
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
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--dark-color);
        }

        .empty-description {
            margin-bottom: 1.5rem;
        }

        /* Loading States */
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

        /* Responsive Design */
        @media (max-width: 1024px) {
            .main-container {
                padding: 1rem 0.5rem;
            }
            
            .header-section {
                padding: 1.5rem;
            }
            
            .header-title {
                font-size: 1.5rem;
            }
            
            .stats-grid {
                grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
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
                gap: 0.25rem;
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
        }
    </style>
</head>
<body>
    <div class="main-container">
        <div class="content-wrapper">
            <!-- Header Section -->
            <div class="header-section">
                <div class="header-content">
                    <h1 class="header-title">
                        <i class="fas fa-hospital"></i>
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
                                <c:set var="availableCount" value="0" />
                                <c:forEach var="room" items="${roomList}">
                                    <c:if test="${room.status == 'Available'}">
                                        <c:set var="availableCount" value="${availableCount + 1}" />
                                    </c:if>
                                </c:forEach>
                                ${availableCount}
                            </span>
                            <div class="stat-label">Phòng trống</div>
                        </div>
                        <div class="stat-card">
                            <span class="stat-number">
                                <c:set var="inProgressCount" value="0" />
                                <c:forEach var="room" items="${roomList}">
                                    <c:if test="${room.status == 'In Progress'}">
                                        <c:set var="inProgressCount" value="${inProgressCount + 1}" />
                                    </c:if>
                                </c:forEach>
                                ${inProgressCount}
                            </span>
                            <div class="stat-label">Đang sử dụng</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Navigation Section -->
            <div class="nav-section">
                <div class="nav-left">
                    <nav class="breadcrumb">
                        <i class="fas fa-home"></i>
                        <c:choose>
                            <c:when test="${isAdmin}">
                                <a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp">Dashboard</a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/views/user/DoctorNurse/dashboard.jsp">Dashboard</a>
                            </c:otherwise>
                        </c:choose>
                        <i class="fas fa-chevron-right"></i>
                        <span>Quản lý Phòng</span>
                    </nav>
                </div>
                <c:choose>
                    <c:when test="${isAdmin}">
                        <a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Quay lại Dashboard
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/views/user/DoctorNurse/dashboard.jsp" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Quay lại Dashboard
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Controls Section -->
            <div class="controls-section">
                <form class="search-form" method="get" action="${pageContext.request.contextPath}/ViewRoomServlet">
                    <div class="search-group">
                        <i class="fas fa-search search-icon"></i>
                        <input type="text" 
                               name="keyword" 
                               class="search-input"
                               placeholder="Tìm kiếm theo tên phòng, mã phòng, bác sĩ, y tá..." 
                               value="${keyword}">
                    </div>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-search"></i> Tìm kiếm
                    </button>
                    <c:if test="${isAdmin}">
                        <a href="${pageContext.request.contextPath}/views/admin/AddRoom.jsp" class="btn btn-success">
                            <i class="fas fa-plus-circle"></i> Thêm phòng mới
                        </a>
                    </c:if>
                </form>
            </div>

            <!-- Table Section -->
            <div class="table-section">
                <c:choose>
                    <c:when test="${not empty roomList}">
                        <div class="table-container">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th><i class="fas fa-hashtag"></i> Mã Phòng</th>
                                        <th><i class="fas fa-door-open"></i> Tên Phòng</th>
                                        <th><i class="fas fa-align-left"></i> Mô Tả</th>
                                        <th><i class="fas fa-user-md"></i> Bác Sĩ</th>
                                        <th><i class="fas fa-user-nurse"></i> Y Tá</th>
                                        <th><i class="fas fa-info-circle"></i> Trạng Thái</th>
                                        <th><i class="fas fa-user-plus"></i> Người Tạo</th>
                                        <c:if test="${isAdmin}">
                                            <th><i class="fas fa-cogs"></i> Thao Tác</th>
                                        </c:if>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="room" items="${roomList}">
                                        <tr>
                                            <td>
                                                <span class="room-id">${room.roomID}</span>
                                            </td>
                                            <td>
                                                <span class="room-name">${room.roomName}</span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty room.description}">
                                                        ${room.description}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="no-assignment">Không có mô tả</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty room.doctorID}">
                                                        <div class="staff-info">
                                                            <span class="staff-name">${room.doctorName}</span>
                                                            <span class="staff-id">ID: ${room.doctorID}</span>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="no-assignment">
                                                            <i class="fas fa-user-times"></i> Chưa phân công
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty room.nurseID}">
                                                        <div class="staff-info">
                                                            <span class="staff-name">${room.nurseName}</span>
                                                            <span class="staff-id">ID: ${room.nurseID}</span>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="no-assignment">
                                                            <i class="fas fa-user-times"></i> Chưa phân công
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${room.status == 'Available'}">
                                                        <span class="status-badge status-available">
                                                            <i class="fas fa-check-circle"></i> Còn Phòng
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${room.status == 'Completed'}">
                                                        <span class="status-badge status-completed">
                                                            <i class="fas fa-check-double"></i> Hoàn Thành
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${room.status == 'Not Available'}">
                                                        <span class="status-badge status-unavailable">
                                                            <i class="fas fa-times-circle"></i> Hết Phòng
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${room.status == 'In Progress'}">
                                                        <span class="status-badge status-in-progress">
                                                            <i class="fas fa-clock"></i> Đang khám
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge status-unknown">
                                                            <i class="fas fa-question-circle"></i> Không xác định
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty room.createdBy}">
                                                        <strong>${room.createdBy}</strong>
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
                                                           title="Xem chi tiết phòng">
                                                            <i class="fas fa-eye"></i> Xem
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/UpdateRoomServlet?id=${room.roomID}" 
                                                           class="btn-action btn-edit"
                                                           title="Chỉnh sửa thông tin phòng">
                                                            <i class="fas fa-edit"></i> Sửa
                                                        </a>
                                                           <a href="${pageContext.request.contextPath}/DeleteRoomServlet?id=${room.roomID}" 
                                                           class="btn-action btn-edit"
                                                           title="Xóa thông tin phòng">
                                                            <i class="fas fa-edit"></i> Xóa
                                                        </a>
                                                        
                                                        <a href="${pageContext.request.contextPath}/AssignServiceToRoomServlet?roomId=${room.roomID}" 
                                                           class="btn-action btn-service"
                                                           title="Quản lý dịch vụ phòng">
                                                            <i class="fas fa-plus-circle"></i> Dịch vụ
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
                        <div class="empty-state">
                            <i class="fas fa-bed empty-icon"></i>
                            <h3 class="empty-title">Không tìm thấy phòng nào</h3>
                            <p class="empty-description">
                                <c:choose>
                                    <c:when test="${not empty keyword}">
                                        Không có phòng nào khớp với từ khóa tìm kiếm "<strong>${keyword}</strong>".
                                        <br>Thử tìm kiếm với từ khóa khác hoặc
                                    </c:when>
                                    <c:otherwise>
                                        Hiện tại chưa có phòng nào trong hệ thống.
                                    </c:otherwise>
                                </c:choose>
                            </p>
                            <c:if test="${isAdmin}">
                                <a href="${pageContext.request.contextPath}/views/admin/AddRoom.jsp" class="btn btn-success">
                                    <i class="fas fa-plus-circle"></i> Thêm phòng đầu tiên
                                </a>
                            </c:if>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <script>
        // Enhanced form submission with loading state
        document.querySelector('.search-form').addEventListener('submit', function(e) {
            const submitBtn = this.querySelector('button[type="submit"]');
            const originalText = submitBtn.innerHTML;
            
            submitBtn.innerHTML = '<span class="loading-spinner"></span> Đang tìm kiếm...';
            submitBtn.disabled = true;
            
            // Re-enable after 5 seconds as failsafe
            setTimeout(() => {
                submitBtn.innerHTML = originalText;
                submitBtn.disabled = false;
            }, 5000);
        });

        // Enhanced delete confirmation with room details
        document.querySelectorAll('.btn-delete').forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                
                const roomId = this.dataset.roomId;
                const roomName = this.dataset.roomName;
                
                const isConfirmed = confirm(
                    `⚠️ Xác nhận xóa phòng\n\n` +
                    `Mã phòng: ${roomId}\n` +
                    `Tên phòng: ${roomName}\n\n` +
                    `Bạn có chắc chắn muốn xóa phòng này không?\n` +
                    `Hành động này không thể hoàn tác!`
                );
                
                if (isConfirmed) {
                    // Show loading state
                    this.innerHTML = '<span class="loading-spinner"></span> Đang xóa...';
                    this.style.pointerEvents = 'none';
                    
                    // Navigate to delete URL
                    window.location.href = `${pageContext.request.contextPath}/DeleteRoomServlet?id=${roomId}`;
                }
            });
        });

        // Add hover effects and tooltips
        document.quer
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>

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
            /* max-width: 1400px; */
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
            table-layout: fixed;
        }

        .data-table th, .data-table td {
            vertical-align: middle;
            text-align: center;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            padding: 0.75rem 0.5rem;
        }
        .data-table th {
            background: #f1f5f9;
            color: #1e293b;
            font-size: 1rem;
            font-weight: 600;
            border-bottom: 2px solid #e2e8f0;
        }
        .data-table tbody tr:hover {
            background: #f0f7ff;
            transition: background 0.2s;
        }
        .assignment-card {
            background: #e0f2fe;
            border-radius: 8px;
            padding: 0.5rem 0.75rem;
            margin-bottom: 0.25rem;
            display: inline-block;
            min-width: 120px;
        }
        .assignment-card .icon {
            color: #2563eb;
            margin-right: 4px;
        }
        .btn-action {
            display: inline-block;
            margin: 2px 2px 0 0;
            padding: 0.3rem 0.7rem;
            font-size: 0.8rem;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            background: #f1f5f9;
            color: #2563eb;
            transition: background 0.2s;
            text-decoration: none;
        }
        .btn-action.detail { background: #e0e7ff; color: #3730a3; }
        .btn-action.edit { background: #fef9c3; color: #b45309; }
        .btn-action.assign { background: #d1fae5; color: #059669; font-weight: 600; }
        .btn-action:hover { opacity: 0.85; }

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
        .week-nav {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 2rem;
            margin-bottom: 1.5rem;
        }
        .week-nav form {
            display: inline;
        }
        .week-nav-btn {
            background: linear-gradient(90deg, #2563eb 0%, #1d4ed8 100%);
            color: #fff;
            border: none;
            border-radius: 999px;
            padding: 0.6rem 1.6rem;
            font-size: 1rem;
            font-weight: 600;
            box-shadow: 0 2px 8px rgba(37,99,235,0.08);
            transition: background 0.2s, transform 0.15s, box-shadow 0.2s;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .week-nav-btn:hover {
            background: linear-gradient(90deg, #1d4ed8 0%, #2563eb 100%);
            transform: translateY(-2px) scale(1.04);
            box-shadow: 0 4px 16px rgba(37,99,235,0.15);
        }
        @media (max-width: 600px) {
            .week-nav {
                flex-direction: column;
                gap: 0.75rem;
            }
            .week-nav-btn {
                width: 100%;
                justify-content: center;
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

            <h5 class="text-center mb-3">
                Bảng phân công theo ca và ngày trong tuần
                <c:if test="${not empty startDate && not empty endDate}">
                    (<span>${startDate}</span> - <span>${endDate}</span>)
                </c:if>
            </h5>
            <div class="week-nav mb-3">
                <form method="get" action="${pageContext.request.contextPath}/ViewRoomServlet">
                    <input type="hidden" name="action" value="prev"/>
                    <input type="hidden" name="startDate" value="${startDate}"/>
                    <input type="hidden" name="endDate" value="${endDate}"/>
                    <c:if test="${not empty keyword}">
                        <input type="hidden" name="keyword" value="${keyword}"/>
                    </c:if>
                    <button type="submit" class="week-nav-btn"><i class="fas fa-angle-double-left"></i> Tuần trước</button>
                </form>
                <form method="get" action="${pageContext.request.contextPath}/ViewRoomServlet">
                    <input type="hidden" name="action" value="next"/>
                    <input type="hidden" name="startDate" value="${startDate}"/>
                    <input type="hidden" name="endDate" value="${endDate}"/>
                    <c:if test="${not empty keyword}">
                        <input type="hidden" name="keyword" value="${keyword}"/>
                    </c:if>
                    <button type="submit" class="week-nav-btn">Tuần sau <i class="fas fa-angle-double-right"></i></button>
                </form>
            </div>
            <div class="table-section" style="margin-top: 2rem;">
              <div class="table-container">
                <table class="data-table text-center align-middle">
                  <thead>
                    <tr>
                      <th rowspan="2">Phòng</th>
                      <th rowspan="2">Ca</th>
                      <c:forEach var="d" items="${days}">
                        <th>${dayNameMap[d]}</th>
                      </c:forEach>
                    </tr>
                    <tr>
                      <c:forEach var="d" items="${days}">
                        <th>${d}</th>
                      </c:forEach>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach var="roomObj" items="${roomList}">
                      <c:set var="room" value="${roomObj.roomName}" />
                      <c:set var="shifts" value="${scheduleData[room]}" />
                      <tr>
                        <td rowspan="2" class="room-name">
                          <a href="${pageContext.request.contextPath}/ViewRoomDetailServlet?id=${roomObj.roomID}" style="color: var(--primary-color); text-decoration: underline; cursor: pointer;">
                            ${room}
                          </a>
                        </td>
                        <td>Ca sáng</td>
                        <c:set var="shift" value="Ca sáng" />
                        <c:forEach var="d" items="${days}">
                          <c:set var="roles" value="${shifts['Ca sáng'][d]}" />
                          <td>
                            <c:choose>
                              <c:when test="${not empty roles.doctor or not empty roles.nurse}">
                                <div class="assignment-card">
                                  <span class="icon"><i class="fas fa-user-md"></i></span>
                                  <span><b>Bác sĩ:</b> <c:out value="${roles.doctor}" /></span><br/>
                                  <span class="icon"><i class="fas fa-user-nurse"></i></span>
                                  <span><b>Y tá:</b> <c:out value="${roles.nurse}" /></span>
                                </div>
                                <br/>
                                <a href="${pageContext.request.contextPath}/ScheduleDetailServlet?room=${roomObj.roomID}&amp;date=${d}&amp;shift=Ca sáng" class="btn-action detail">Chi tiết</a>
                                <a href="${pageContext.request.contextPath}/ScheduleEditServlet?room=${roomObj.roomID}&amp;date=${d}&amp;shift=Ca sáng" class="btn-action edit">Sửa</a>
                              </c:when>
                              <c:otherwise>
                                <a href="${pageContext.request.contextPath}/AssignScheduleServlet?room=${roomObj.roomID}&amp;date=${d}&amp;shift=Ca sáng" class="btn-action assign">
                                  <i class="fas fa-plus"></i> Giao
                                </a>
                              </c:otherwise>
                            </c:choose>
                          </td>
                        </c:forEach>
                      </tr>
                      <tr>
                        <td>Ca chiều</td>
                        <c:set var="shift" value="Ca chiều" />
                        <c:forEach var="d" items="${days}">
                          <c:set var="roles" value="${shifts['Ca chiều'][d]}" />
                          <td>
                            <c:choose>
                              <c:when test="${not empty roles.doctor or not empty roles.nurse}">
                                <div class="assignment-card">
                                  <span class="icon"><i class="fas fa-user-md"></i></span>
                                  <span><b>Bác sĩ:</b> <c:out value="${roles.doctor}" /></span><br/>
                                  <span class="icon"><i class="fas fa-user-nurse"></i></span>
                                  <span><b>Y tá:</b> <c:out value="${roles.nurse}" /></span>
                                </div>
                                <br/>
                                <a href="${pageContext.request.contextPath}/ScheduleDetailServlet?room=${roomObj.roomID}&amp;date=${d}&amp;shift=Ca chiều" class="btn-action detail">Chi tiết</a>
                                <a href="${pageContext.request.contextPath}/ScheduleEditServlet?room=${roomObj.roomID}&amp;date=${d}&amp;shift=Ca chiều" class="btn-action edit">Sửa</a>
                              </c:when>
                              <c:otherwise>
                                <a href="${pageContext.request.contextPath}/AssignScheduleServlet?room=${roomObj.roomID}&amp;date=${d}&amp;shift=Ca chiều" class="btn-action assign">
                                  <i class="fas fa-plus"></i> Giao
                                </a>
                              </c:otherwise>
                            </c:choose>
                          </td>
                        </c:forEach>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
              </div>
            </div>
            <!-- PHÂN TRANG -->
            <div class="pagination" style="margin: 1rem 0; text-align: center;">
                <c:if test="${totalPages > 1}">
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <c:choose>
                            <c:when test="${i == currentPage}">
                                <span style="margin:0 4px; font-weight:bold; color: var(--primary-color); background: #e0e7ff; padding: 6px 12px; border-radius: 4px;">${i}</span>
                            </c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test="${not empty keyword}">
                                        <a href="?page=${i}&amp;keyword=${fn:escapeXml(keyword)}" style="margin:0 4px; text-decoration:none; padding: 6px 12px; border-radius: 4px; background: #f1f5f9; color: #2563eb;">${i}</a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="?page=${i}" style="margin:0 4px; text-decoration:none; padding: 6px 12px; border-radius: 4px; background: #f1f5f9; color: #2563eb;">${i}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </c:if>
            </div>
        </div>
    </div>

   <script>
        // Thêm hiệu ứng loading khi submit form
        document.querySelector('form').addEventListener('submit', function() {
            const submitBtn = this.querySelector('button[type="submit"]');
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang tìm...';
        });

        // Thêm hiệu ứng hover cho các hàng trong bảng
        document.querySelectorAll('.table tbody tr').forEach(row => {
            row.addEventListener('mouseenter', function() {
                this.style.transform = 'scale(1.01)';
            });
            
            row.addEventListener('mouseleave', function() {
                this.style.transform = 'scale(1)';
            });
        });

        // Confirm delete với style đẹp hơn
        document.querySelectorAll('.btn-delete').forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                if (confirm('⚠️ Bạn có chắc chắn muốn xóa phòng này không?\n\nHành động này không thể hoàn tác!')) {
                    window.location.href = this.href;
                }
            });
        });
    </script>
</body>

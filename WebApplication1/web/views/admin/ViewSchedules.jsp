<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch làm việc nhân viên</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            position: relative;
        }

        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="20" cy="20" r="1" fill="rgba(255,255,255,0.1)"/><circle cx="80" cy="40" r="1" fill="rgba(255,255,255,0.1)"/><circle cx="40" cy="80" r="1" fill="rgba(255,255,255,0.1)"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
            pointer-events: none;
            z-index: -1;
        }

        .main-container {
            width: 100%;
            margin: 0;
            padding: 20px;
            min-height: 100vh;
        }

        .header-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .content-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            position: relative;
            overflow: hidden;
            min-height: calc(100vh - 200px);
        }

        .content-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2, #f093fb, #f5576c);
            background-size: 200% 100%;
            animation: gradientShift 3s ease infinite;
        }

        @keyframes gradientShift {
            0%, 100% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
        }

        .page-title {
            color: #2d3748;
            font-size: 2.5rem;
            font-weight: 700;
            text-align: center;
            margin-bottom: 10px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .page-subtitle {
            text-align: center;
            color: #718096;
            font-size: 1.1rem;
            margin-bottom: 0;
        }

        .action-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .search-container {
            position: relative;
            max-width: 400px;
            flex-grow: 1;
        }

        .search-input {
            width: 100%;
            padding: 12px 20px 12px 50px;
            border: 2px solid #e2e8f0;
            border-radius: 25px;
            font-size: 14px;
            transition: all 0.3s ease;
            background: #fff;
        }

        .search-input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .search-icon {
            position: absolute;
            left: 18px;
            top: 50%;
            transform: translateY(-50%);
            color: #a0aec0;
            font-size: 16px;
        }

        .btn-modern {
            padding: 12px 24px;
            border: none;
            border-radius: 25px;
            font-weight: 500;
            font-size: 14px;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
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
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.4), transparent);
            transition: left 0.5s;
        }

        .btn-modern:hover::before {
            left: 100%;
        }

        .btn-primary-modern {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
        }

        .btn-primary-modern:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
            color: white;
        }

        .btn-success-modern {
            background: linear-gradient(135deg, #48bb78, #38a169);
            color: white;
        }

        .btn-success-modern:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(72, 187, 120, 0.4);
            color: white;
        }

        .btn-info-modern {
            background: linear-gradient(135deg, #4299e1, #3182ce);
            color: white;
            padding: 8px 16px;
            font-size: 12px;
        }

        .btn-info-modern:hover {
            transform: translateY(-1px);
            box-shadow: 0 8px 20px rgba(66, 153, 225, 0.4);
            color: white;
        }

        .btn-assign-room {
            background: linear-gradient(135deg, #ed8936, #dd6b20);
            color: white;
            padding: 8px 16px;
            border-radius: 25px;
            font-size: 12px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            margin-left: 8px;
            gap: 6px;
        }

        .btn-assign-room::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.4), transparent);
            transition: left 0.5s;
        }

        .btn-assign-room:hover::before {
            left: 100%;
        }

        .btn-assign-room:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(237, 137, 54, 0.4);
            color: white;
        }

        .action-buttons {
            display: flex;
            align-items: center;
            gap: 0;
        }

        .modern-table {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            border: none;
        }

        .modern-table thead {
            background: linear-gradient(135deg, #f7fafc, #edf2f7);
        }

        .modern-table th {
            border: none;
            padding: 20px 15px;
            font-weight: 600;
            color: #2d3748;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .modern-table td {
            border: none;
            padding: 20px 15px;
            color: #4a5568;
            font-size: 14px;
            border-bottom: 1px solid #f1f5f9;
        }

        .modern-table tbody tr {
            transition: all 0.3s ease;
        }

        .modern-table tbody tr:hover {
            background: linear-gradient(135deg, #f8faff, #f1f5f9);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        }

        .modern-table tbody tr:last-child td {
            border-bottom: none;
        }

        .role-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .role-doctor {
            background: linear-gradient(135deg, #fed7d7, #feb2b2);
            color: #c53030;
        }

        .role-nurse {
            background: linear-gradient(135deg, #c6f6d5, #9ae6b4);
            color: #2f855a;
        }

        .role-receptionist {
            background: linear-gradient(135deg, #bee3f8, #90cdf4);
            color: #2c5282;
        }

        .success-alert {
            background: linear-gradient(135deg, #c6f6d5, #9ae6b4);
            color: #2f855a;
            padding: 16px 24px;
            border-radius: 12px;
            margin-bottom: 25px;
            border: 1px solid #9ae6b4;
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 500;
        }

        .pagination-modern {
            display: flex;
            justify-content: center;
            gap: 8px;
            margin-top: 30px;
        }

        .pagination-modern .page-link {
            padding: 10px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            color: #4a5568;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            background: white;
        }

        .pagination-modern .page-link:hover {
            border-color: #667eea;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            transform: translateY(-1px);
        }

        .pagination-modern .page-item.active .page-link {
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-color: #667eea;
            color: white;
        }

        .pagination-modern .page-item.disabled .page-link {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .no-data {
            text-align: center;
            padding: 60px 20px;
            color: #718096;
        }

        .no-data i {
            font-size: 4rem;
            margin-bottom: 20px;
            color: #cbd5e0;
        }

        .employee-id {
            font-weight: 600;
            color: #667eea;
        }

        .employee-name {
            font-weight: 500;
            color: #2d3748;
        }

        .specialization {
            color: #718096;
            font-style: italic;
        }

        @media (max-width: 768px) {
            .main-container {
                padding: 10px;
            }
            
            .header-card {
                padding: 20px;
                margin-bottom: 20px;
            }
            
            .content-card {
                padding: 20px;
                min-height: calc(100vh - 140px);
            }
            
            .action-bar {
                flex-direction: column;
                align-items: stretch;
            }
            
            .search-container {
                max-width: none;
            }
            
            .page-title {
                font-size: 2rem;
            }
            
            .modern-table {
                font-size: 12px;
            }
            
            .modern-table th,
            .modern-table td {
                padding: 12px 8px;
            }

            .btn-assign-room {
                font-size: 11px;
                padding: 6px 12px;
            }
        }

        .floating-action {
            position: fixed;
            bottom: 30px;
            right: 30px;
            z-index: 1000;
        }

        .floating-btn {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(135deg, #48bb78, #38a169);
            color: white;
            border: none;
            font-size: 24px;
            box-shadow: 0 8px 25px rgba(72, 187, 120, 0.4);
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
        }

        .floating-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 30px rgba(72, 187, 120, 0.6);
            color: white;
        }

        .stats-card {
            background: rgba(255, 255, 255, 0.9);
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
            text-align: center;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
        }

        .stats-number {
            font-size: 2rem;
            font-weight: 700;
            color: #667eea;
            margin-bottom: 5px;
        }

        .stats-label {
            color: #718096;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
    </style>
</head>
<body>
    <div class="main-container">
        <!-- Header -->
        <div class="header-card">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp" class="btn btn-modern btn-success-modern">
                    <i class="fas fa-home"></i> Trang chủ
                </a>
                <div class="stats-card d-none d-md-block" style="margin-bottom: 0; min-width: 120px;">
                    <div class="stats-number">${not empty employees ? employees.size() : 0}</div>
                    <div class="stats-label">Nhân viên</div>
                </div>
            </div>
            <h1 class="page-title">
                <i class="fas fa-calendar-alt"></i> Lịch làm việc
            </h1>
            <p class="page-subtitle">Quản lý lịch làm việc của nhân viên</p>
        </div>

        <!-- Content -->
        <div class="content-card">
            <!-- Success Message -->
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="success-alert">
                    <i class="fas fa-check-circle"></i>
                    ${sessionScope.successMessage}
                </div>
                <% session.removeAttribute("successMessage"); %>
            </c:if>

            <!-- Action Bar -->
            <div class="action-bar">
                <div class="search-container">
                    <form action="${pageContext.request.contextPath}/admin/schedules" method="get">
                        <i class="fas fa-search search-icon"></i>
                        <input type="text" name="keyword" class="search-input" 
                               placeholder="Tìm theo tên, chuyên khoa..." 
                               value="${keyword != null ? keyword : ''}">
                    </form>
                </div>
                <a href="${pageContext.request.contextPath}/AddScheduleServlet" class="btn btn-modern btn-primary-modern">
                    <i class="fas fa-plus"></i> Thêm lịch làm việc
                </a>
            </div>

            <!-- Table -->
            <div class="table-responsive">
                <table class="table modern-table">
                    <thead>
                        <tr>
                            <th><i class="fas fa-id-card me-2"></i>ID</th>
                            <th><i class="fas fa-user me-2"></i>Tên nhân viên</th>
                            <th><i class="fas fa-stethoscope me-2"></i>Chuyên khoa</th>
                            <th><i class="fas fa-user-tag me-2"></i>Vai trò</th>
                            <th><i class="fas fa-cog me-2"></i>Hành động</th>
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

                                <c:forEach var="employee" items="${employees}" begin="${startIndex}" end="${endIndex}">
                                    <tr>
                                        <td class="employee-id">#${employee.userID}</td>
                                        <td class="employee-name">${employee.fullName}</td>
                                        <td class="specialization">${employee.specialization != null ? employee.specialization : 'Chưa xác định'}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${employee.role == 'doctor'}">
                                                    <span class="role-badge role-doctor">
                                                        <i class="fas fa-user-md me-1"></i>Bác sĩ
                                                    </span>
                                                </c:when>
                                                <c:when test="${employee.role == 'nurse'}">
                                                    <span class="role-badge role-nurse">
                                                        <i class="fas fa-user-nurse me-1"></i>Y tá
                                                    </span>
                                                </c:when>
                                                <c:when test="${employee.role == 'receptionist'}">
                                                    <span class="role-badge role-receptionist">
                                                        <i class="fas fa-user-tie me-1"></i>Lễ tân
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="role-badge role-receptionist">${employee.role}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="${pageContext.request.contextPath}/ViewScheduleDetailsServlet?userID=${employee.userID}" 
                                                   class="btn btn-modern btn-info-modern">
                                                    <i class="fas fa-eye"></i> Xem chi tiết
                                                </a>
                                                <c:if test="${employee.role != 'receptionist'}">
                                                    <a href="${pageContext.request.contextPath}/AssignDoctorNurseToRoom?userID=${employee.userID}" 
                                                       class="btn-assign-room">
                                                        <i class="fas fa-plus"></i> Gán phòng
                                                    </a>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="5" class="no-data">
                                        <i class="fas fa-users"></i>
                                        <div>Không có nhân viên nào</div>
                                        <small>Hãy thêm nhân viên để bắt đầu quản lý lịch làm việc</small>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <c:if test="${not empty employees and totalItems > pageSize}">
                <nav aria-label="Page navigation">
                    <ul class="pagination-modern">
                        <c:set var="prevPage" value="${page - 1}" />
                        <c:set var="nextPage" value="${page + 1}" />
                        
                        <li class="page-item ${page == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/schedules?page=${prevPage}${keyword != null ? '&keyword=' : ''}${keyword}">
                                <i class="fas fa-chevron-left"></i>
                            </a>
                        </li>
                        
                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <li class="page-item ${page == i ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/schedules?page=${i}${keyword != null ? '&keyword=' : ''}${keyword}">${i}</a>
                            </li>
                        </c:forEach>
                        
                        <li class="page-item ${page == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/schedules?page=${nextPage}${keyword != null ? '&keyword=' : ''}${keyword}">
                                <i class="fas fa-chevron-right"></i>
                            </a>
                        </li>
                    </ul>
                </nav>
            </c:if>
        </div>
    </div>

    <!-- Floating Action Button -->
    <div class="floating-action d-md-none">
        <a href="${pageContext.request.contextPath}/AddScheduleServlet" class="floating-btn">
            <i class="fas fa-plus"></i>
        </a>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Auto-submit search form
        document.querySelector('.search-input').addEventListener('input', function() {
            clearTimeout(this.searchTimeout);
            this.searchTimeout = setTimeout(() => {
                this.form.submit();
            }, 500);
        });

        // Smooth scroll for floating button
        document.addEventListener('DOMContentLoaded', function() {
            const floatingBtn = document.querySelector('.floating-btn');
            if (floatingBtn) {
                floatingBtn.addEventListener('click', function(e) {
                    e.preventDefault();
                    window.location.href = this.href;
                });
            }
        });
    </script>
</body>
</html>
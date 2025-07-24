<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh Sách Lịch Hẹn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #4f46e5;
            --secondary-color: #10b981;
            --accent-color: #f59e0b;
            --danger-color: #ef4444;
            --warning-color: #f59e0b;
            --success-color: #10b981;
            --dark-color: #1f2937;
            --light-bg: #f8fafc;
            --card-shadow: 0 10px 25px rgba(0,0,0,0.08);
            --border-radius: 12px;
        }
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .main-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: var(--border-radius);
            box-shadow: var(--card-shadow);
            margin: 20px 0;
            overflow: hidden;
        }
        .header-section {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 30px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        .header-section::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            animation: pulse 4s ease-in-out infinite;
        }
        .header-section h2 {
            font-size: 2.5rem;
            font-weight: 700;
            margin: 0;
            position: relative;
            z-index: 1;
        }
        .header-section .subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
            margin-top: 10px;
            position: relative;
            z-index: 1;
        }
        @keyframes pulse {
            0%, 100% { transform: scale(1); opacity: 0.1; }
            50% { transform: scale(1.1); opacity: 0.2; }
        }
        .search-section {
            padding: 30px;
            background: white;
            border-bottom: 1px solid #e5e7eb;
        }
        .search-card {
            background: linear-gradient(135deg, #f8fafc, #e2e8f0);
            border-radius: var(--border-radius);
            padding: 25px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
        }
        .search-input-group {
            position: relative;
        }
        .search-input {
            border: 2px solid #e5e7eb;
            border-radius: 50px;
            padding: 12px 20px 12px 50px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: white;
        }
        .search-input:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
            outline: none;
        }
        .search-icon {
            position: absolute;
            left: 18px;
            top: 50%;
            transform: translateY(-50%);
            color: #6b7280;
            z-index: 2;
        }
        .search-btn {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border: none;
            border-radius: 50px;
            padding: 12px 30px;
            color: white;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(79, 70, 229, 0.3);
        }
        .search-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(79, 70, 229, 0.4);
        }
        .table-section {
            padding: 0 30px 30px;
        }
        .table-wrapper {
            background: white;
            border-radius: var(--border-radius);
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
        }
        .custom-table {
            margin: 0;
            border: none;
        }
        .custom-table thead th {
            background: linear-gradient(135deg, var(--dark-color), #374151);
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
            padding: 18px 15px;
            border: none;
            position: sticky;
            top: 0;
            z-index: 10;
        }
        .custom-table tbody tr {
            transition: all 0.3s ease;
            border-bottom: 1px solid #f3f4f6;
        }
        .custom-table tbody tr:hover {
            background: linear-gradient(135deg, #f8fafc, #f1f5f9);
            transform: scale(1.002);
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        .custom-table td {
            padding: 15px;
            vertical-align: middle;
            border: none;
            font-size: 0.9rem;
        }
        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        .status-approved {
            background: linear-gradient(135deg, var(--success-color), #059669);
            color: white;
        }
        .status-pending {
            background: linear-gradient(135deg, var(--warning-color), #d97706);
            color: white;
        }
        .status-rejected {
            background: linear-gradient(135deg, var(--danger-color), #dc2626);
            color: white;
        }
        .pagination-wrapper {
            padding: 30px;
            background: white;
            border-top: 1px solid #e5e7eb;
        }
        .custom-pagination {
            justify-content: center;
            margin: 0;
        }
        .custom-pagination .page-link {
            border: 2px solid #e5e7eb;
            color: var(--primary-color);
            padding: 10px 15px;
            margin: 0.3px;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .custom-pagination .page-link:hover {
            background: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
        }
        .custom-pagination .page-item.active .page-link {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border-color: var(--primary-color);
            color: white;
            box-shadow: 0 4px 15px rgba(79, 70, 229, 0.3);
        }
        .custom-pagination .page-item.disabled .page-link {
            color: #9ca3af;
            background: #f9fafb;
            border-color: #e5e7eb;
        }
        .alert-custom {
            border: none;
            border-radius: var(--border-radius);
            padding: 15px 20px;
            margin-bottom: 20px;
            background: linear-gradient(135deg, #fef2f2, #fee2e2);
            border-left: 4px solid var(--danger-color);
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
        }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6b7280;
        }
        .empty-state i {
            font-size: 4rem;
            margin-bottom: 20px;
            opacity: 0.5;
        }
        .fade-in {
            animation: fadeInUp 0.6s ease-out;
        }
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        .data-cell {
            font-weight: 500;
        }
        .id-cell {
            color: var(--primary-color);
            font-weight: 600;
        }
        .patient-info {
            display: flex;
            flex-direction: column;
            gap: 2px;
        }
        .patient-name {
            font-weight: 600;
            color: var(--dark-color);
        }
        .patient-details {
            font-size: 0.8rem;
            color: #6b7280;
        }
        .time-info {
            background: #f8fafc;
            padding: 8px 12px;
            border-radius: 8px;
            font-family: 'Courier New', monospace;
            font-weight: 600;
            color: var(--dark-color);
        }
        .breadcrumb-container {
            margin-bottom: 20px;
            font-size: 1.2rem;
            font-weight: 600;
            color: #1f2937;
            background: rgba(255, 255, 255, 0.9);
            padding: 15px 20px;
            border-radius: var(--border-radius);
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
        }
        .breadcrumb-container a {
            text-decoration: none;
            color: var(--primary-color);
            transition: color 0.3s ease;
        }
        .breadcrumb-container a:hover {
            color: var(--secondary-color);
            text-decoration: underline;
        }
        .breadcrumb-container span {
            margin: 0 12px;
            color: #6b7280;
            font-weight: 500;
        }
        .action-btn {
            padding: 8px 16px;
            border-radius: 8px;
            font-size: 0.85rem;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: all 0.3s ease;
        }
        .update-btn {
            background: linear-gradient(135deg, #f59e0b, #d97706);
            color: white;
            border: none;
        }
        .update-btn:hover {
            background: linear-gradient(135deg, #d97706, #b45309);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(245, 158, 11, 0.3);
        }
        @media (max-width: 768px) {
            .header-section h2 {
                font-size: 2rem;
            }
            .search-section {
                padding: 20px;
            }
            .table-section {
                padding: 0 15px 20px;
            }
            .custom-table {
                font-size: 0.8rem;
            }
            .custom-table td {
                padding: 10px 8px;
            }
            .breadcrumb-container {
                font-size: 1rem;
                padding: 10px 15px;
            }
            .action-btn {
                padding: 6px 12px;
                font-size: 0.8rem;
            }
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="breadcrumb-container">
            <a href="${pageContext.request.contextPath}/views/user/Receptionist/ReceptionistDashBoard.jsp">
                <i class="fas fa-home me-2"></i>Dashboard
            </a>
            <span>></span>
            <span style="color: #111827;">Quản lý lịch hẹn</span>
        </div>
        <div class="main-container animate__animated animate__fadeIn">
            <!-- Header Section -->
            <div class="header-section">
                <h2><i class="fas fa-calendar-check me-3"></i>Quản Lý Lịch Hẹn</h2>
                <p class="subtitle">Hệ thống quản lý lịch hẹn khám bệnh</p>
            </div>
            <!-- Error Alert -->
            <c:if test="${not empty error}">
                <div class="search-section">
                    <div class="alert alert-custom alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </div>
            </c:if>
            <!-- Search Section -->
            <div class="search-section">
                <div class="search-card fade-in">
                    <form method="get" action="" accept-charset="UTF-8">
                        <div class="row align-items-center">
                            <div class="col-lg-8 col-md-7 mb-3 mb-md-0">
                                <div class="search-input-group">
                                    <i class="fas fa-search search-icon"></i>
                                    <input type="text"
                                           class="form-control search-input"
                                           name="keyword"
                                           placeholder="Tìm kiếm theo ID, bệnh nhân, số điện thoại, email, bác sĩ, dịch vụ, phòng..."
                                           value="${param.keyword}">
                                </div>
                            </div>
                            <div class="col-lg-4 col-md-5">
                                <button type="submit" class="btn search-btn w-100">
                                    <i class="fas fa-search me-2"></i>Tìm Kiếm
                                </button>
                            </div>
                        </div>
                        <input type="hidden" name="page" value="1">
                        <input type="hidden" name="pageSize" value="${param.pageSize != null ? param.pageSize : 10}">
                    </form>
                </div>
            </div>
            <!-- Table Section -->
            <div class="table-section">
                <div class="table-wrapper fade-in">
                    <table class="table custom-table">
                        <thead>
                            <tr>
                                <th><i class="fas fa-hashtag me-2"></i>ID</th>
                                <th><i class="fas fa-user me-2"></i>Bệnh Nhân</th>
                                <th><i class="fas fa-phone me-2"></i>Liên Hệ</th>
                                <th><i class="fas fa-user-md me-2"></i>Bác Sĩ</th>
                                <th><i class="fas fa-medical-kit me-2"></i>Dịch Vụ</th>
                                <th><i class="fas fa-door-open me-2"></i>Phòng</th>
                                <th><i class="fas fa-clock me-2"></i>Thời Gian</th>
                                <th><i class="fas fa-info-circle me-2"></i>Trạng Thái</th>
                                <th><i class="fas fa-calendar-plus me-2"></i>Ngày Tạo</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty appointments}">
                                    <tr>
                                        <td colspan="10">
                                            <div class="empty-state">
                                                <i class="fas fa-calendar-times"></i>
                                                <h4>Không có lịch hẹn nào</h4>
                                                <p>Hiện tại chưa có lịch hẹn nào trong hệ thống.</p>
                                            </div>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="appointment" items="${appointments}">
                                        <tr class="fade-in">
                                            <td class="id-cell">#${appointment.appointmentId}</td>
                                            <td>
                                                <div class="patient-info">
                                                    <span class="patient-name">
                                                        <c:out value="${appointment.patientName != null ? appointment.patientName : 'N/A'}" />
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="patient-details">
                                                    <div><i class="fas fa-phone me-1"></i>
                                                        <c:out value="${appointment.patientPhone != null ? appointment.patientPhone : 'N/A'}" />
                                                    </div>
                                                    <div><i class="fas fa-envelope me-1"></i>
                                                        <c:out value="${appointment.patientEmail != null ? appointment.patientEmail : 'N/A'}" />
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="data-cell">
                                                <i class="fas fa-user-md me-2 text-primary"></i>
                                                <c:out value="${appointment.doctorName}" />
                                            </td>
                                            <td class="data-cell">
                                                <i class="fas fa-medical-kit me-2 text-success"></i>
                                                <c:out value="${appointment.serviceName}" />
                                            </td>
                                            <td class="data-cell">
                                                <i class="fas fa-door-open me-2 text-info"></i>
                                                <c:out value="${appointment.roomName}" />
                                            </td>
                                            <td>
                                                <div class="time-info">
                                                    <div><fmt:formatDate value="${appointment.slotDate}" pattern="dd/MM/yyyy" /></div>
                                                    <div>
                                                        <fmt:formatDate value="${appointment.startTime}" pattern="HH:mm" /> -
                                                        <fmt:formatDate value="${appointment.endTime}" pattern="HH:mm" />
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="status-badge
                                                    ${appointment.status == 'Approved' ? 'status-approved' :
                                                    appointment.status == 'Pending' ? 'status-pending' :
                                                    appointment.status == 'Rejected' ? 'status-rejected' : 'bg-secondary'}">
                                                    <i class="fas fa-circle me-1" style="font-size: 0.6rem;"></i>
                                                    ${appointment.status}
                                                </span>
                                            </td>
                                            <td class="data-cell">
                                                <fmt:formatDate value="${appointment.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
            <!-- Pagination Section -->
            <c:if test="${not empty appointments && totalPages > 1}">
                <div class="pagination-wrapper">
                    <nav aria-label="Page navigation">
                        <ul class="pagination custom-pagination">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage - 1}&pageSize=${pageSize}&keyword=${param.keyword}" aria-label="Previous">
                                    <i class="fas fa-chevron-left me-1"></i>Trước
                                </a>
                            </li>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}&pageSize=${pageSize}&keyword=${param.keyword}">${i}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage + 1}&pageSize=${pageSize}&keyword=${param.keyword}" aria-label="Next">
                                    Tiếp<i class="fas fa-chevron-right ms-1"></i>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </c:if>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const tableRows = document.querySelectorAll('.custom-table tbody tr');
            tableRows.forEach(row => {
                row.addEventListener('mouseenter', function() {
                    this.style.transform = 'scale(1.002)';
                });
                row.addEventListener('mouseleave', function() {
                    this.style.transform = 'scale(1)';
                });
            });
            tableRows.forEach((row, index) => {
                row.style.animationDelay = `${index * 0.1}s`;
                row.classList.add('animate__animated', 'animate__fadeInUp');
            });
            const searchInput = document.querySelector('.search-input');
            if (searchInput && !searchInput.value) {
                searchInput.focus();
            }
            // Ensure accessibility for action buttons
            document.querySelectorAll('.action-btn').forEach(btn => {
                btn.addEventListener('keypress', function(e) {
                    if (e.key === 'Enter' || e.key === ' ') {
                        e.preventDefault();
                        this.click();
                    }
                });
            });
        });
    </script>
    <div style="height: 400px;"></div>
    <jsp:include page="/assets/footer.jsp" />
</body>
</html>

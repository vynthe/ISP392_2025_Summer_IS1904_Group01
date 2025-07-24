<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách Lịch hẹn</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #3b82f6;
            --primary-dark: #2563eb;
            --primary-light: #93c5fd;
            --secondary-color: #64748b;
            --success-color: #10b981;
            --danger-color: #ef4444;
            --warning-color: #f59e0b;
            --info-color: #06b6d4;
            --light-color: #f8fafc;
            --dark-color: #1e293b;
            --border-color: #e2e8f0;
            --shadow-sm: 0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1);
            --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
            --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
            --radius: 0.75rem;
            --radius-lg: 1rem;
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
            padding: 1rem;
            color: var(--dark-color);
            line-height: 1.6;
        }

        .main-container {
            max-width: 1440px;
            margin: 0 auto;
            background: white;
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-lg);
            overflow: hidden;
            animation: slideUp 0.6s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Header Section */
        .header-section {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            color: white;
            padding: 2.5rem 2rem;
            position: relative;
            overflow: hidden;
        }

        .header-section::before {
            content: '';
            position: absolute;
            top: -50px;
            right: -50px;
            width: 200px;
            height: 200px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            animation: float 6s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-20px); }
        }

        .header-content {
            position: relative;
            z-index: 2;
            text-align: center;
        }

        .header-title {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 1rem;
            font-size: 2.25rem;
            font-weight: 700;
            margin-bottom: 0.75rem;
        }

        .header-subtitle {
            font-size: 1.125rem;
            opacity: 0.9;
            font-weight: 400;
            margin-bottom: 1.5rem;
        }

        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 2rem;
            background: var(--primary-color);
            border: 2px solid var(--primary-color);
            border-radius: var(--radius);
            color: white;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            box-shadow: var(--shadow-sm);
        }

        .back-button:hover {
            background: var(--primary-dark);
            border-color: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        /* Controls Section */
        .controls-section {
            padding: 2rem;
            background: linear-gradient(to right, #f8fafc, #f1f5f9);
            border-bottom: 1px solid var(--border-color);
        }

        .search-container {
            display: flex;
            gap: 1rem;
            align-items: stretch;
            flex-wrap: wrap;
        }

        .search-field {
            flex: 1;
            min-width: 320px;
            position: relative;
        }

        .search-input {
            width: 100%;
            padding: 1rem 1rem 1rem 3rem;
            border: 2px solid #e2e8f0;
            border-radius: var(--radius);
            font-size: 0.9rem;
            transition: all 0.3s ease;
            background: white;
            box-shadow: var(--shadow-sm);
        }

        .search-input:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1);
            transform: translateY(-1px);
        }

        .search-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--secondary-color);
            font-size: 1.1rem;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 1rem 2rem;
            border: none;
            border-radius: var(--radius);
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s ease;
            white-space: nowrap;
            box-shadow: var(--shadow-sm);
        }

        .btn-primary {
            background: var(--primary-color);
            color: white;
        }

        .btn-primary:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        /* Content Section */
        .content-section {
            padding: 2rem;
            background: white;
        }

        .alert {
            padding: 1rem 1.5rem;
            border-radius: var(--radius);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-weight: 500;
            animation: slideDown 0.4s ease-out;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .alert.error {
            background: #fef2f2;
            color: var(--danger-color);
            border-left: 4px solid var(--danger-color);
        }

        /* Table Section */
        .table-wrapper {
            background: white;
            border-radius: var(--radius);
            overflow: hidden;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
        }

        .table-container {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: linear-gradient(to right, #f8fafc, #f1f5f9);
            color: var(--dark-color);
            font-weight: 600;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            padding: 1.25rem 1rem;
            text-align: left;
            border-bottom: 2px solid var(--border-color);
        }

        th i {
            margin-right: 0.5rem;
            color: var(--primary-color);
            font-size: 0.9rem;
        }

        td {
            padding: 1.25rem 1rem;
            border-bottom: 1px solid #f1f5f9;
            font-size: 0.9rem;
            vertical-align: middle;
        }

        tbody tr {
            transition: all 0.2s ease;
        }

        tbody tr:hover {
            background: linear-gradient(to right, #fafbff, #f0f4ff);
            transform: scale(1.005);
        }

        .null-value {
            color: var(--secondary-color);
            font-style: italic;
            font-size: 0.85rem;
            opacity: 0.7;
        }

        /* Status Badges */
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
            padding: 0.5rem 1rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.025em;
        }

        .status-pending {
            background: #fef3c7;
            color: #92400e;
        }

        .status-confirmed {
            background: #dcfce7;
            color: #166534;
        }

        .status-cancelled {
            background: #fef2f2;
            color: #991b1b;
        }

        .status-completed {
            background: #dbeafe;
            color: #1e40af;
        }

        /* Pagination */
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 0.5rem;
            margin-top: 2rem;
            padding: 1rem 0;
        }

        .pagination-btn {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.25rem;
            border: 2px solid #e2e8f0;
            border-radius: var(--radius);
            font-size: 0.875rem;
            color: var(--dark-color);
            text-decoration: none;
            transition: all 0.3s ease;
            font-weight: 500;
            min-width: 44px;
            justify-content: center;
        }

        .pagination-btn:hover:not(.disabled):not(.active) {
            background: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .pagination-btn.active {
            background: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
            cursor: default;
            box-shadow: var(--shadow-sm);
        }

        .pagination-btn.disabled {
            color: var(--secondary-color);
            cursor: not-allowed;
            opacity: 0.4;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: var(--secondary-color);
        }

        .empty-icon {
            font-size: 5rem;
            margin-bottom: 1.5rem;
            opacity: 0.2;
            color: var(--primary-color);
        }

        .empty-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 0.75rem;
            color: var(--dark-color);
        }

        .empty-description {
            font-size: 1rem;
            line-height: 1.6;
            max-width: 400px;
            margin: 0 auto;
        }

        /* Responsive Design */
        @media (max-width: 1024px) {
            .main-container {
                margin: 0.5rem;
            }
            
            .header-title {
                font-size: 2rem;
            }
        }

        @media (max-width: 768px) {
            body {
                padding: 0.5rem;
            }

            .main-container {
                margin: 0;
                border-radius: 0;
            }

            .header-section {
                padding: 2rem 1.5rem;
            }

            .header-title {
                font-size: 1.75rem;
                flex-direction: column;
                gap: 0.5rem;
            }

            .controls-section,
            .content-section {
                padding: 1.5rem;
            }

            .search-container {
                flex-direction: column;
            }

            .search-field {
                min-width: 100%;
            }

            table {
                min-width: 900px;
            }

            th, td {
                padding: 1rem 0.75rem;
                font-size: 0.85rem;
            }

            .pagination {
                flex-wrap: wrap;
                gap: 0.25rem;
            }

            .pagination-btn {
                padding: 0.5rem 0.75rem;
                font-size: 0.8rem;
            }
        }

        @media (max-width: 480px) {
            .header-section {
                padding: 1.5rem 1rem;
            }

            .controls-section,
            .content-section {
                padding: 1rem;
            }

            .empty-state {
                padding: 3rem 1rem;
            }

            .empty-icon {
                font-size: 4rem;
            }

            .empty-title {
                font-size: 1.25rem;
            }
        }

        /* Animation cho loading */
        .loading-spinner {
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        /* Hover effects */
        .hover-lift {
            transition: transform 0.2s ease;
        }

        .hover-lift:hover {
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <div class="main-container">
        <!-- Header Section -->
        <header class="header-section" role="banner">
            <div class="header-content">
                <h1 class="header-title">
                    <i class="fas fa-calendar-check" aria-hidden="true"></i>
                    Danh sách Lịch hẹn
                </h1>
                <p class="header-subtitle">Quản lý lịch hẹn phòng khám một cách hiệu quả và chuyên nghiệp</p>
            </div>
        </header>

        <!-- Controls Section -->
        <section class="controls-section">
            <form class="search-container" method="get" action="${pageContext.request.contextPath}/BookingServlet" 
                  aria-label="Tìm kiếm lịch hẹn">
                <div class="search-field">
                    <i class="fas fa-search search-icon" aria-hidden="true"></i>
                    <input type="text" 
                           name="keyword" 
                           class="search-input" 
                           placeholder="Tìm kiếm theo tên bệnh nhân, số điện thoại, email..." 
                           value="${param.keyword}" 
                           aria-label="Nhập từ khóa tìm kiếm">
                </div>
                <button type="submit" class="btn btn-primary hover-lift" aria-label="Thực hiện tìm kiếm">
                    <i class="fas fa-search" aria-hidden="true"></i>
                    Tìm kiếm
                </button>
            </form>
        </section>

        <!-- Content Section -->
        <main class="content-section" role="main">
            <!-- Error Alert -->
            <c:if test="${not empty error}">
                <div class="alert error" role="alert">
                    <i class="fas fa-exclamation-triangle" aria-hidden="true"></i>
                    <span><c:out value="${error}"/></span>
                </div>
            </c:if>

            <!-- Debug Information -->
            <div style="margin-bottom: 1rem; color: #64748b;">
                Kích thước danh sách: ${bookings.size()}, Trang: ${currentPage}, 
                Total Pages (JSP): ${(bookings.size() + 4) / 5}, Total Pages (Servlet): ${totalPages}, 
                Total Items: ${totalBookings}, Begin: ${startItem}, End: ${endItem}
            </div>

            <!-- Table or Empty State -->
            <c:choose>
                <c:when test="${not empty bookings && bookings.size() > 0}">
                    <div class="table-wrapper">
                        <div class="table-container">
                            <table aria-label="Bảng danh sách lịch hẹn">
                                <thead>
                                    <tr>
                                        <th scope="col"><i class="fas fa-hashtag"></i>ID</th>
                                        <th scope="col"><i class="fas fa-user"></i>Bệnh nhân</th>
                                        <th scope="col"><i class="fas fa-phone"></i>Điện thoại</th>
                                        <th scope="col"><i class="fas fa-envelope"></i>Email</th>
                                        <th scope="col"><i class="fas fa-user-md"></i>Bác sĩ</th>
                                        <th scope="col"><i class="fas fa-user-nurse"></i>Y tá</th>
                                        <th scope="col"><i class="fas fa-user-tie"></i>Lễ tân</th>
                                        <th scope="col"><i class="fas fa-door-open"></i>Phòng</th>
                                        <th scope="col"><i class="fas fa-clock"></i>Thời gian</th>
                                        <th scope="col"><i class="fas fa-stethoscope"></i>Dịch vụ</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="booking" items="${bookings}">
                                        <tr>
                                            <td><strong><c:out value="${booking.appointmentID}"/></strong></td>
                                            <td><c:out value="${booking.patientName}"/></td>
                                            <td><c:out value="${booking.patientPhone}"/></td>
                                            <td><c:out value="${booking.patientEmail}"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${empty booking.doctorName}">
                                                        <span class="null-value">Chưa phân công</span>
                                                    </c:when>
                                                    <c:otherwise><c:out value="${booking.doctorName}"/></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${empty booking.nurseName}">
                                                        <span class="null-value">Chưa phân công</span>
                                                    </c:when>
                                                    <c:otherwise><c:out value="${booking.nurseName}"/></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${empty booking.receptionistName}">
                                                        <span class="null-value">Chưa phân công</span>
                                                    </c:when>
                                                    <c:otherwise><c:out value="${booking.receptionistName}"/></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${empty booking.roomName}">
                                                        <span class="null-value">Chưa phân phòng</span>
                                                    </c:when>
                                                    <c:otherwise><c:out value="${booking.roomName}"/></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <i class="fas fa-calendar-alt" style="color: var(--primary-color); margin-right: 0.5rem;"></i>
                                                <fmt:formatDate value="${booking.appointmentTime}" pattern="dd/MM/yyyy" />
                                                <br>
                                                <i class="fas fa-clock" style="color: var(--secondary-color); margin-right: 0.5rem;"></i>
                                                <fmt:formatDate value="${booking.appointmentTime}" pattern="HH:mm" />
                                            </td>
                                            <td><c:out value="${booking.serviceInfo}"/></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Pagination -->
                    <nav class="pagination" role="navigation" aria-label="Điều hướng phân trang">
                        <c:if test="${hasPreviousPage}">
                            <a href="${pageContext.request.contextPath}/BookingServlet?page=${currentPage - 1}&keyword=${param.keyword}&statusFilter=${param.statusFilter}"
                               class="pagination-btn hover-lift" aria-label="Trang trước">
                                <i class="fas fa-chevron-left"></i>
                                Trước
                            </a>
                        </c:if>
                        
                        <c:forEach begin="1" end="${totalPages}" var="pageNum">
                            <a href="${pageContext.request.contextPath}/BookingServlet?page=${pageNum}&keyword=${param.keyword}&statusFilter=${param.statusFilter}"
                               class="pagination-btn ${pageNum == currentPage ? 'active' : ''}" 
                               aria-label="Trang ${pageNum}" 
                               aria-current="${pageNum == currentPage ? 'page' : ''}">
                                ${pageNum}
                            </a>
                        </c:forEach>
                        
                        <c:if test="${hasNextPage}">
                            <a href="${pageContext.request.contextPath}/BookingServlet?page=${currentPage + 1}&keyword=${param.keyword}&statusFilter=${param.statusFilter}"
                               class="pagination-btn hover-lift" aria-label="Trang sau">
                                Sau
                                <i class="fas fa-chevron-right"></i>
                            </a>
                        </c:if>
                    </nav>
                </c:when>
                <c:otherwise>
                    <div class="empty-state" role="status">
                        <i class="fas fa-calendar-times empty-icon" aria-hidden="true"></i>
                        <h2 class="empty-title">Không tìm thấy lịch hẹn nào</h2>
                        <div class="empty-description">
                            <c:choose>
                                <c:when test="${not empty param.keyword}">
                                    Không có lịch hẹn nào khớp với từ khóa "<strong><c:out value="${param.keyword}"/></strong>".
                                    <br>Vui lòng thử lại với từ khóa khác.
                                </c:when>
                                <c:otherwise>
                                    Hiện tại chưa có lịch hẹn nào trong hệ thống.
                                    <br>Các lịch hẹn mới sẽ hiển thị tại đây.
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
            
            <!-- Back to Dashboard Button -->
            <div style="text-align: center; margin-top: 2rem; padding-top: 2rem; border-top: 1px solid var(--border-color);">
                <a href="${pageContext.request.contextPath}/views/user/Receptionist/ReceptionistDashBoard.jsp"
                   class="back-button hover-lift" aria-label="Quay lại Dashboard">
                    <i class="fas fa-arrow-left" aria-hidden="true"></i>
                    Quay lại Dashboard
                </a>
            </div>
        </main>
    </div>

    <script>
        // Enhanced form submission with loading state
        const searchForm = document.querySelector('.search-container');
        const searchButton = searchForm.querySelector('button[type="submit"]');
        const originalButtonContent = searchButton.innerHTML;

        searchForm.addEventListener('submit', function(e) {
            searchButton.innerHTML = '<i class="fas fa-spinner loading-spinner" aria-hidden="true"></i> Đang tìm...';
            searchButton.disabled = true;
            
            // Re-enable button after 3 seconds as failsafe
            setTimeout(() => {
                searchButton.innerHTML = originalButtonContent;
                searchButton.disabled = false;
            }, 3000);
        });

        // Enhanced table row hover effects
        document.querySelectorAll('tbody tr').forEach(row => {
            row.addEventListener('mouseenter', function() {
                this.style.boxShadow = '0 4px 12px rgba(0, 0, 0, 0.1)';
            });
            
            row.addEventListener('mouseleave', function() {
                this.style.boxShadow = 'none';
            });
        });

        // Keyboard navigation for pagination
        document.querySelectorAll('.pagination-btn').forEach(btn => {
            btn.addEventListener('keydown', function(e) {
                if (e.key === 'Enter' || e.key === ' ') {
                    e.preventDefault();
                    if (!this.classList.contains('disabled') && !this.classList.contains('active')) {
                        this.click();
                    }
                }
            });
        });

        // Auto-focus search input if no results
        const emptyState = document.querySelector('.empty-state');
        const searchInput = document.querySelector('.search-input');
        if (emptyState && searchInput && searchInput.value.trim()) {
            searchInput.focus();
            searchInput.select();
        }

        // Add loading animation to page navigation
        document.querySelectorAll('.pagination-btn:not(.active):not(.disabled)').forEach(link => {
            link.addEventListener('click', function(e) {
                this.style.opacity = '0.7';
                this.innerHTML = '<i class="fas fa-spinner loading-spinner"></i>';
            });
        });
    </script>
</body>
</html>
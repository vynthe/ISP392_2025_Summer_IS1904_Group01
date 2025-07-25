<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Ca Làm & Lịch Hẹn</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #4f46e5;
            --secondary-color: #6366f1;
            --success-color: #10b981;
            --warning-color: #f59e0b;
            --danger-color: #ef4444;
            --light-bg: #f8fafc;
            --border-color: #e2e8f0;
            --card-bg: #ffffff;
            --table-stripe: #f9fafb;
        }

        body {
            background: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .main-container {
            background: var(--card-bg);
            border-radius: 20px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.08);
            margin: 20px auto;
            overflow: hidden;
            max-width: 1200px;
            border: 1px solid var(--border-color);
        }

        .header-section {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 30px;
            position: relative;
            overflow: hidden;
        }

        .header-section::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="50" cy="50" r="2" fill="white" opacity="0.1"/></svg>') repeat;
            animation: float 20s linear infinite;
        }

        @keyframes float {
            0% { transform: translateX(-100px) translateY(-100px); }
            100% { transform: translateX(100px) translateY(100px); }
        }

        .breadcrumb-custom {
            background: rgba(255,255,255,0.15);
            backdrop-filter: blur(10px);
            border-radius: 50px;
            padding: 12px 20px;
            margin-bottom: 20px;
            border: 1px solid rgba(255,255,255,0.2);
        }

        .breadcrumb-custom a {
            color: rgba(255,255,255,0.9);
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .breadcrumb-custom a:hover {
            color: white;
            text-shadow: 0 0 10px rgba(255,255,255,0.5);
        }

        .header-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin: 0;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
            position: relative;
            z-index: 1;
        }

        .header-subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
            margin-top: 10px;
            position: relative;
            z-index: 1;
        }

        .content-section {
            padding: 40px;
        }

        .info-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .info-card {
            background: var(--card-bg);
            border-radius: 12px;
            padding: 20px;
            border: 1px solid var(--border-color);
            transition: all 0.2s ease;
            position: relative;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0,0,0,0.02);
        }

        .info-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, transparent, rgba(79, 70, 229, 0.02), transparent);
            transform: translateX(-100%);
            transition: transform 0.6s ease;
        }

        .info-card:hover::before {
            transform: translateX(100%);
        }

        .info-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.06);
            border-color: #cbd5e1;
        }

        .info-card h5 {
            color: var(--primary-color);
            font-weight: 600;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .schedule-table {
            background: var(--card-bg);
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            border: 1px solid var(--border-color);
        }

        .schedule-table thead {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
        }

        .schedule-table thead th {
            border: none;
            padding: 18px 15px;
            font-weight: 600;
            text-align: center;
            position: relative;
            font-size: 0.9rem;
        }

        .schedule-table tbody tr {
            transition: all 0.2s ease;
            border-bottom: 1px solid var(--border-color);
            background: var(--card-bg);
        }

        .schedule-table tbody tr:nth-child(even) {
            background: var(--table-stripe);
        }

        .schedule-table tbody tr:hover {
            background: rgba(79, 70, 229, 0.04);
            transform: none;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }

        .schedule-table tbody td {
            padding: 18px 15px;
            vertical-align: middle;
            text-align: center;
            border: none;
            border-right: 1px solid #f1f5f9;
        }

        .schedule-table tbody td:last-child {
            border-right: none;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 6px 12px;
            border-radius: 16px;
            font-size: 0.8rem;
            font-weight: 500;
            text-transform: capitalize;
            letter-spacing: 0.3px;
        }

        .status-active {
            background: rgba(16, 185, 129, 0.08);
            color: var(--success-color);
            border: 1px solid rgba(16, 185, 129, 0.15);
        }

        .status-pending {
            background: rgba(245, 158, 11, 0.08);
            color: var(--warning-color);
            border: 1px solid rgba(245, 158, 11, 0.15);
        }

        .appointment-info {
            background: rgba(16, 185, 129, 0.04);
            border-radius: 8px;
            padding: 12px;
            text-align: left;
            border: 1px solid rgba(16, 185, 129, 0.1);
            margin: 0;
        }

        .appointment-info.no-appointment {
            background: rgba(107, 114, 128, 0.04);
            border-color: rgba(107, 114, 128, 0.1);
            color: #6b7280;
        }

        .appointment-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: var(--success-color);
            color: white;
            padding: 4px 10px;
            border-radius: 16px;
            font-size: 0.8rem;
            font-weight: 500;
            margin-bottom: 8px;
        }

        .no-appointment-badge {
            background: #6b7280;
            color: white;
            padding: 4px 10px;
            border-radius: 16px;
            font-size: 0.8rem;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .appointment-detail {
            margin: 6px 0;
            display: flex;
            align-items: flex-start;
            gap: 6px;
            font-size: 0.85rem;
            line-height: 1.4;
        }

        .appointment-detail strong {
            color: #374151;
            min-width: 70px;
            font-size: 0.8rem;
        }

        .appointment-detail i {
            font-size: 0.75rem;
            margin-top: 2px;
            color: var(--success-color);
        }

        .back-button {
            background: linear-gradient(135deg, #6b7280, #4b5563);
            border: none;
            padding: 15px 30px;
            border-radius: 50px;
            color: white;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .back-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            color: white;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: var(--light-bg);
            border-radius: 16px;
            margin: 20px 0;
        }

        .empty-state i {
            font-size: 4rem;
            color: #d1d5db;
            margin-bottom: 20px;
        }

        .empty-state h4 {
            color: #6b7280;
            margin-bottom: 10px;
        }

        .empty-state p {
            color: #9ca3af;
            margin: 0;
        }

        .time-display {
            font-family: 'Courier New', monospace;
            font-weight: 600;
            background: rgba(79, 70, 229, 0.06);
            padding: 4px 8px;
            border-radius: 4px;
            color: var(--primary-color);
            font-size: 0.9rem;
        }

        .date-display {
            font-weight: 600;
            color: #374151;
            font-size: 0.9rem;
        }

        .role-badge {
            background: linear-gradient(135deg, #6b7280, #9ca3af);
            color: white;
            padding: 4px 10px;
            border-radius: 14px;
            font-size: 0.8rem;
            font-weight: 500;
            text-transform: capitalize;
            letter-spacing: 0.3px;
        }

        @media (max-width: 768px) {
            .main-container {
                margin: 10px;
                border-radius: 15px;
            }
            
            .header-section {
                padding: 20px;
            }
            
            .header-title {
                font-size: 1.8rem;
            }
            
            .content-section {
                padding: 20px;
            }
            
            .info-cards {
                grid-template-columns: 1fr;
                gap: 15px;
            }
            
            .schedule-table {
                font-size: 0.9rem;
            }
            
            .schedule-table thead th,
            .schedule-table tbody td {
                padding: 12px 8px;
            }
        }
    </style>
</head>
<body>
    <div class="main-container">
        <!-- Header Section -->
        <div class="header-section">
            <div class="breadcrumb-custom">
                <i class="fas fa-home"></i>
                <a href="${pageContext.request.contextPath}/views/user/DoctorNurse/EmployeeDashBoard.jsp">Trang Chủ</a>
                <span class="mx-2">></span>
                <a href="${pageContext.request.contextPath}/ViewScheduleUserServlet">Lịch Làm Việc</a>
                <span class="mx-2">></span>
                <span>Chi Tiết Ca Làm</span>
            </div>
            
            <h1 class="header-title">
                <i class="fas fa-calendar-check"></i>
                Chi Tiết Ca Làm Việc
            </h1>
            <p class="header-subtitle">
                <i class="fas fa-door-open"></i> Phòng ID: ${roomId} | 
                <i class="fas fa-clock"></i> Ca làm ID: ${slotId}
            </p>
        </div>

        <!-- Content Section -->
        <div class="content-section">
            <c:if test="${empty scheduleDetails}">
                <div class="empty-state">
                    <i class="fas fa-calendar-times"></i>
                    <h4>Không tìm thấy thông tin</h4>
                    <p>Không tìm thấy ca làm việc hoặc lịch hẹn tương ứng với thông tin đã cung cấp.</p>
                </div>
            </c:if>

            <c:if test="${not empty scheduleDetails}">
                <!-- Info Cards -->
                <div class="info-cards">
                    <div class="info-card">
                        <h5><i class="fas fa-calendar-alt"></i> Thông Tin Ca Làm</h5>
                        <p><strong>Tổng số ca:</strong> ${scheduleDetails.size()} ca làm việc</p>
                        <p><strong>Phòng:</strong> ${roomId}</p>
                        <p><strong>Slot ID:</strong> ${slotId}</p>
                    </div>
                    
                    <div class="info-card">
                        <h5><i class="fas fa-user-md"></i> Trạng Thái</h5>
                        <c:set var="appointmentCount" value="0"/>
                        <c:forEach var="item" items="${scheduleDetails}">
                            <c:if test="${not empty item.appointmentId}">
                                <c:set var="appointmentCount" value="${appointmentCount + 1}"/>
                            </c:if>
                        </c:forEach>
                        <p><strong>Đã có lịch hẹn:</strong> ${appointmentCount} ca</p>
                        
                    </div>
                </div>

                <!-- Schedule Table -->
                <div class="table-responsive">
                    <table class="table schedule-table">
                        <thead>
                            <tr>
                                <th><i class="fas fa-hashtag"></i> STT</th>
                                <th><i class="fas fa-calendar"></i> Ngày Làm</th>
                                <th><i class="fas fa-play"></i> Giờ Bắt Đầu</th>
                                <th><i class="fas fa-stop"></i> Giờ Kết Thúc</th>
                                <th><i class="fas fa-user-tag"></i> Vai Trò</th>
                                <th><i class="fas fa-info-circle"></i> Trạng Thái</th>
                                <th><i class="fas fa-clipboard-list"></i> Thông Tin Lịch Hẹn</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${scheduleDetails}" varStatus="loop">
                                <tr>
                                    <td>
                                        <div class="fw-bold text-primary">${loop.index + 1}</div>
                                    </td>
                                    <td>
                                        <div class="date-display">
                                            <c:choose>
                                                <c:when test="${not empty item.slotDate}">
                                                    <fmt:formatDate value="${item.slotDate}" pattern="dd/MM/yyyy"/>
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="time-display">
                                            <c:choose>
                                                <c:when test="${not empty item.startTime}">
                                                    <fmt:formatDate value="${item.startTime}" pattern="HH:mm"/>
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="time-display">
                                            <c:choose>
                                                <c:when test="${not empty item.endTime}">
                                                    <fmt:formatDate value="${item.endTime}" pattern="HH:mm"/>
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="role-badge">${item.role}</span>
                                    </td>
                                    <td>
                                        <span class="status-badge status-active">
                                            <i class="fas fa-check-circle"></i>
                                            ${item.scheduleStatus}
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty item.appointmentId}">
                                                <div class="appointment-info">
                                                    <div class="appointment-badge">
                                                        <i class="fas fa-check-circle"></i>
                                                        Đã Đặt Lịch
                                                    </div>
                                                    <div class="appointment-detail">
                                                        <i class="fas fa-user"></i>
                                                        <strong>Bệnh nhân:</strong> ${item.patientName}
                                                    </div>
                                                    <div class="appointment-detail">
                                                        <i class="fas fa-stethoscope"></i>
                                                        <strong>Dịch vụ:</strong>
                                                        <c:choose>
                                                            <c:when test="${not empty item.serviceName}">
                                                                ${item.serviceName}
                                                            </c:when>
                                                            <c:otherwise><em>Chưa xác định</em></c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="appointment-info no-appointment">
                                                    <div class="no-appointment-badge">
                                                        <i class="fas fa-hourglass-half"></i>
                                                        Chưa Có Lịch Hẹn
                                                    </div>
                                                    <p class="mb-0 mt-2"><em>Thời gian này vẫn còn trống</em></p>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>

            <!-- Back Button -->
            <div class="mt-4 text-center">
                <a href="/ISP392_Group1/ViewScheduleUserServlet" class="back-button">
                    <i class="fas fa-arrow-left"></i>
                    Quay Lại Danh Sách Phòng
                </a>
            </div>
        </div>
    </div>

    <!-- Spacer -->
    <div style="height: 50px;"></div>
    
    <!-- Footer -->
    <jsp:include page="/assets/footer.jsp" />

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
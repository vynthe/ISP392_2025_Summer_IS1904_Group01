<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch làm việc - ID ${userId}</title>
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
            margin-bottom: 20px;
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

        p {
            text-align: center;
            margin: 10px 0;
        }

        p.error {
            color: #e74c3c;
        }

        p.message {
            color: #2ecc71;
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
        }
    </style>
</head>
<body>
    <div class="main-container">
        <!-- Header -->
        <div class="header-card">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <a href="${pageContext.request.contextPath}/ViewSchedulesServlet" class="btn btn-modern btn-success-modern">
                    <i class="fas fa-arrow-left"></i> Quay lại
                </a>
            </div>
            <h1 class="page-title">
                <i class="fas fa-calendar-alt"></i> Lịch làm việc - ID ${userId}
            </h1>
            <p class="page-subtitle">Lịch làm việc cho ngày ${viewDate}</p>
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

            <!-- Table -->
            <div class="table-responsive">
                <table class="table modern-table">
                    <thead>
                        <tr>
                            <th><i class="fas fa-clock me-2"></i>Slot</th>
                            <th><i class="fas fa-clock me-2"></i>Thời gian</th>
                            <th><i class="fas fa-hospital me-2"></i>Phòng</th>
                            <th><i class="fas fa-tools me-2"></i>Dịch vụ</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty schedules}">
                                <c:forEach var="schedule" items="${schedules}">
                                    <c:set var="roomKey" value="room_${schedule.slotId}" />
                                    <c:set var="serviceKey" value="services_${schedule.slotId}" />
                                    <c:set var="room" value="${requestScope[roomKey]}" />
                                    <c:set var="service" value="${requestScope[serviceKey]}" />
                                    <tr>
                                        <td>Slot ${schedule.slotId}</td>
                                        <td>
                                            ${not empty schedule.startTime ? schedule.startTime : 'Chưa có'} - 
                                            ${not empty schedule.endTime ? schedule.endTime : 'Chưa có'}
                                        </td>
                                        <td>
                                            ${not empty room ? room.roomName : 'Chưa gán phòng'} 
                                            (${not empty room ? room.status : ''})
                                        </td>
                                        <td>${not empty service ? service : 'Chưa gán dịch vụ'}</td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="4" class="no-data">
                                        <i class="fas fa-calendar-times"></i>
                                        <div>Không có lịch nào</div>
                                        <small>Hãy thêm lịch để bắt đầu quản lý</small>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
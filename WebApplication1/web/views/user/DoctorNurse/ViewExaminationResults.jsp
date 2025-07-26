<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Kết Quả Khám Nha Khoa</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            overflow: hidden;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .header {
            background: linear-gradient(135deg, #2C5282, #2A4365);
            color: white;
            padding: 30px 40px;
            position: relative;
            overflow: hidden;
        }

        .header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="dental" patternUnits="userSpaceOnUse" width="20" height="20"><circle cx="10" cy="10" r="2" fill="rgba(255,255,255,0.1)"/></pattern></defs><rect width="100" height="100" fill="url(%23dental)"/></svg>');
            opacity: 0.1;
        }

        .header-content {
            position: relative;
            z-index: 2;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header-title {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .header-title i {
            font-size: 32px;
            color: #63B3ED;
        }

        .header-title h2 {
            font-size: 28px;
            font-weight: 700;
            margin: 0;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .home-button {
            background: linear-gradient(135deg, #48BB78, #38A169);
            color: white;
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            border: 2px solid rgba(255,255,255,0.2);
        }

        .home-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(72, 187, 120, 0.3);
            background: linear-gradient(135deg, #38A169, #2F855A);
        }

        .content {
            padding: 40px;
        }

        .message-box {
            padding: 20px 25px;
            border-radius: 15px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 15px;
            border-left: 5px solid;
            backdrop-filter: blur(10px);
        }

        .error-box {
            background: linear-gradient(135deg, rgba(254, 178, 178, 0.2), rgba(252, 165, 165, 0.1));
            border-left-color: #F56565;
            color: #C53030;
        }

        .success-box {
            background: linear-gradient(135deg, rgba(154, 230, 180, 0.2), rgba(134, 239, 172, 0.1));
            border-left-color: #48BB78;
            color: #2F855A;
        }

        .message-box i {
            font-size: 24px;
        }

        .no-data {
            text-align: center;
            padding: 60px 40px;
            color: #4A5568;
        }

        .no-data i {
            font-size: 80px;
            color: #CBD5E0;
            margin-bottom: 20px;
        }

        .table-container {
            overflow-x: auto;
            border-radius: 15px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            border: 1px solid rgba(226, 232, 240, 0.8);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
        }

        th {
            background: linear-gradient(135deg, #EDF2F7, #E2E8F0);
            padding: 18px 15px;
            text-align: left;
            font-weight: 700;
            color: #2D3748;
            border-bottom: 2px solid #CBD5E0;
            position: sticky;
            top: 0;
            z-index: 10;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        td {
            padding: 16px 15px;
            border-bottom: 1px solid rgba(226, 232, 240, 0.6);
            vertical-align: middle;
            transition: all 0.2s ease;
        }

        tbody tr {
            transition: all 0.3s ease;
        }

        tbody tr:hover {
            background: linear-gradient(135deg, rgba(99, 179, 237, 0.05), rgba(129, 140, 248, 0.05));
            transform: scale(1.01);
        }

        .status {
            padding: 8px 16px;
            border-radius: 25px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .status-completed {
            background: linear-gradient(135deg, #C6F6D5, #9AE6B4);
            color: #2F855A;
            border: 1px solid #68D391;
        }

        .status-pending {
            background: linear-gradient(135deg, #FEFCBF, #F6E05E);
            color: #B7791F;
            border: 1px solid #F6E05E;
        }

        .status-cancelled {
            background: linear-gradient(135deg, #FED7D7, #FEB2B2);
            color: #C53030;
            border: 1px solid #FC8181;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .action-button {
            padding: 10px 16px;
            text-decoration: none;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 600;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .action-button.add {
            background: linear-gradient(135deg, #48BB78, #38A169);
            color: white;
            border: 1px solid rgba(255,255,255,0.2);
        }

        .action-button.add:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(72, 187, 120, 0.3);
            background: linear-gradient(135deg, #38A169, #2F855A);
        }

        .action-button.edit {
            background: linear-gradient(135deg, #4299E1, #3182CE);
            color: white;
            border: 1px solid rgba(255,255,255,0.2);
        }

        .action-button.edit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(66, 153, 225, 0.3);
            background: linear-gradient(135deg, #3182CE, #2C5282);
        }

        .action-button.view {
            background: linear-gradient(135deg, #805AD5, #6B46C1);
            color: white;
            border: 1px solid rgba(255,255,255,0.2);
        }

        .action-button.view:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(128, 90, 213, 0.3);
            background: linear-gradient(135deg, #6B46C1, #553C9A);
        }

        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: linear-gradient(135deg, rgba(255,255,255,0.9), rgba(247,250,252,0.9));
            padding: 25px;
            border-radius: 15px;
            border: 1px solid rgba(226, 232, 240, 0.8);
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(135deg, #63B3ED, #4299E1);
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.15);
        }

        .stat-number {
            font-size: 32px;
            font-weight: 800;
            color: #2C5282;
            margin-bottom: 8px;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .stat-label {
            color: #4A5568;
            font-size: 14px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .pagination {
            margin-top: 40px;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap;
        }

        .pagination a {
            padding: 12px 16px;
            text-decoration: none;
            border: 2px solid #E2E8F0;
            border-radius: 10px;
            color: #4A5568;
            font-weight: 600;
            transition: all 0.3s ease;
            background: white;
        }

        .pagination a:hover {
            background: linear-gradient(135deg, #63B3ED, #4299E1);
            color: white;
            border-color: #4299E1;
            transform: translateY(-2px);
        }

        .pagination a.active {
            background: linear-gradient(135deg, #2C5282, #2A4365);
            color: white;
            border-color: #2C5282;
        }

        .back-button {
            background: linear-gradient(135deg, #A0AEC0, #718096);
            color: white;
            padding: 12px 20px;
            text-decoration: none;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-top: 15px;
        }

        .back-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(160, 174, 192, 0.3);
            background: linear-gradient(135deg, #718096, #4A5568);
        }

        @media (max-width: 768px) {
            .container {
                margin: 10px;
                border-radius: 15px;
            }

            .header {
                padding: 20px;
            }

            .header-content {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }

            .content {
                padding: 20px;
            }

            .stats {
                grid-template-columns: 1fr;
            }

            .action-buttons {
                flex-direction: row;
            }

            th, td {
                padding: 10px 8px;
                font-size: 13px;
            }

            .header-title h2 {
                font-size: 24px;
            }
        }

        /* Dental themed animations */
        @keyframes pulse {
            0%, 100% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.05);
            }
        }

        .stat-card:hover .stat-number {
            animation: pulse 2s infinite;
        }

        /* Tooth icon styling */
        .tooth-icon {
            color: #63B3ED;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="header-content">
                <div class="header-title">
                    <i class="fas fa-tooth tooth-icon"></i>
                    <h2>Kết Quả Khám Nha Khoa</h2>
                </div>
                <a href="${pageContext.request.contextPath}/views/user/DoctorNurse/EmployeeDashBoard.jsp" class="home-button">
                    <i class="fas fa-home"></i>Trang chủ
                </a>
            </div>
        </div>

        <div class="content">
            <!-- Hiển thị thông báo thành công nếu có -->
            <c:if test="${not empty successMessage}">
                <div class="message-box success-box">
                    <i class="fas fa-check-circle"></i>
                    <div>
                        <strong>Thành công!</strong>
                        <p style="margin: 5px 0 0 0;">${successMessage}</p>
                    </div>
                </div>
            </c:if>

            <!-- Hiển thị thông báo lỗi nếu có -->
            <c:if test="${not empty errorMessage}">
                <div class="message-box error-box">
                    <i class="fas fa-exclamation-triangle"></i>
                    <div>
                        <strong>Lỗi!</strong>
                        <c:choose>
                            <c:when test="${errorMessage.contains('Lỗi khi lấy dữ liệu lịch hẹn')}">
                                <p style="margin: 5px 0 0 0;">Lỗi hệ thống: ${errorMessage}. Vui lòng thử lại hoặc liên hệ quản trị viên.</p>
                            </c:when>
                            <c:otherwise>
                                <p style="margin: 5px 0 0 0;">${errorMessage}</p>
                            </c:otherwise>
                        </c:choose>
                        <a href="javascript:history.back()" class="back-button">
                            <i class="fas fa-arrow-left"></i>Quay lại trang trước
                        </a>
                    </div>
                </div>
            </c:if>

            <c:if test="${empty errorMessage}">
                <!-- Thống kê -->
                <c:if test="${not empty appointments}">
                    <div class="stats">
                        <div class="stat-card">
                            <div class="stat-number">${appointments.size()}</div>
                            <div class="stat-label">Tổng lịch hẹn</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-number">
                                <c:set var="completedCount" value="0" />
                                <c:forEach var="appointment" items="${appointments}">
                                    <c:if test="${appointment.status == 'Completed' || appointment.status == 'Hoàn thành'}">
                                        <c:set var="completedCount" value="${completedCount + 1}" />
                                    </c:if>
                                </c:forEach>
                                ${completedCount}
                            </div>
                            <div class="stat-label">Đã hoàn thành</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-number">
                                <c:set var="diagnosisCount" value="0" />
                                <c:forEach var="appointment" items="${appointments}">
                                    <c:if test="${not empty appointment.diagnosis}">
                                        <c:set var="diagnosisCount" value="${diagnosisCount + 1}" />
                                    </c:if>
                                </c:forEach>
                                ${diagnosisCount}
                            </div>
                            <div class="stat-label">Có chuẩn đoán</div>
                        </div>
                    </div>
                </c:if>

                <c:if test="${empty appointments}">
                    <div class="no-data">
                        <i class="fas fa-calendar-times"></i>
                        <p><strong>Không tìm thấy lịch hẹn nào</strong></p>
                        <p>Vui lòng kiểm tra lại hoặc liên hệ quản trị viên để được hỗ trợ.</p>
                    </div>
                </c:if>

                <c:if test="${not empty appointments}">
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th style="width: 80px;"><i class="fas fa-hashtag"></i> ID</th>
                                    <th style="width: 150px;"><i class="fas fa-user"></i> Bệnh Nhân</th>
                                    <th style="width: 120px;"><i class="fas fa-tooth"></i> Dịch Vụ</th>
                                    <th style="width: 100px;"><i class="fas fa-door-open"></i> Phòng</th>
                                    <th style="width: 100px;"><i class="fas fa-calendar"></i> Ngày</th>
                                    <th style="width: 120px;"><i class="fas fa-clock"></i> Thời Gian</th>
                                    <th style="width: 100px;"><i class="fas fa-info-circle"></i> Trạng Thái</th>
                                    <th style="width: 220px;"><i class="fas fa-cogs"></i> Thao Tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="appointment" items="${appointments}">
                                    <tr>
                                        <td><strong style="color: #2C5282;">#${appointment.appointmentId}</strong></td>
                                        <td><strong>${appointment.patientName}</strong></td>
                                        <td>${appointment.serviceName}</td>
                                        <td><i class="fas fa-door-open" style="color: #63B3ED; margin-right: 5px;"></i>${appointment.roomName}</td>
                                        <td>
                                            <fmt:parseDate value="${appointment.slotDate}" pattern="yyyy-MM-dd" var="parsedDate" />
                                            <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy" />
                                        </td>
                                        <td>
                                            <div style="font-size: 12px;">
                                                <div><strong>${appointment.startTime}</strong></div>
                                                <div style="color: #718096;">đến ${appointment.endTime}</div>
                                            </div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${appointment.status == 'Completed' || appointment.status == 'Hoàn thành'}">
                                                    <span class="status status-completed">
                                                        <i class="fas fa-check-circle"></i>Hoàn thành
                                                    </span>
                                                </c:when>
                                                <c:when test="${appointment.status == 'Pending' || appointment.status == 'Chờ xử lý'}">
                                                    <span class="status status-pending">
                                                        <i class="fas fa-clock"></i>Chờ xử lý
                                                    </span>
                                                </c:when>
                                                <c:when test="${appointment.status == 'Cancelled' || appointment.status == 'Đã hủy'}">
                                                    <span class="status status-cancelled">
                                                        <i class="fas fa-times-circle"></i>Đã hủy
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status status-pending">
                                                        <i class="fas fa-question-circle"></i>${appointment.status}
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="action-buttons">
                                                <!-- Chỉ hiển thị nút "Thêm kết quả" khi appointment đã hoàn thành và chưa có kết quả khám -->
                                                <c:if test="${examinationResultDAO.getDiagnosisByAppointmentId(appointment.appointmentId) == null}">
                                                    <a href="${pageContext.request.contextPath}/AddExaminationResultServlet?appointmentId=${appointment.appointmentId}" 
                                                       class="action-button add" title="Thêm kết quả khám">
                                                        <i class="fas fa-plus"></i>Thêm kết quả
                                                    </a>
                                                </c:if>
                                                <a href="${pageContext.request.contextPath}/EditExaminationResultServlet?appointmentId=${appointment.appointmentId}" 
                                                   class="action-button edit" title="Chỉnh sửa kết quả khám">
                                                    <i class="fas fa-edit"></i>Chỉnh sửa
                                                </a>
                                                <a href="${pageContext.request.contextPath}/ViewExaminationResultDetailServlet?appointmentId=${appointment.appointmentId}" 
                                                   class="action-button view" title="Xem chi tiết">
                                                    <i class="fas fa-eye"></i>Chi tiết
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Phân trang -->
                    <c:if test="${totalPages > 1}">
                        <div class="pagination">
                            <c:if test="${currentPage > 1}">
                                <a href="ViewExaminationResults?page=${currentPage - 1}&pageSize=${pageSize}">
                                    <i class="fas fa-chevron-left"></i> Trước
                                </a>
                            </c:if>

                            <c:choose>
                                <c:when test="${totalPages <= 7}">
                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <a href="ViewExaminationResults?page=${i}&pageSize=${pageSize}" 
                                           class="${i == currentPage ? 'active' : ''}">${i}</a>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <c:if test="${currentPage > 3}">
                                        <a href="ViewExaminationResults?page=1&pageSize=${pageSize}">1</a>
                                        <span style="padding: 8px; color: #A0AEC0;">...</span>
                                    </c:if>

                                    <c:forEach begin="${currentPage - 2}" end="${currentPage + 2}" var="i">
                                        <c:if test="${i >= 1 && i <= totalPages}">
                                            <a href="ViewExaminationResults?page=${i}&pageSize=${pageSize}" 
                                               class="${i == currentPage ? 'active' : ''}">${i}</a>
                                        </c:if>
                                    </c:forEach>

                                    <c:if test="${currentPage < totalPages - 2}">
                                        <span style="padding: 8px; color: #A0AEC0;">...</span>
                                        <a href="ViewExaminationResults?page=${totalPages}&pageSize=${pageSize}">${totalPages}</a>
                                    </c:if>
                                </c:otherwise>
                            </c:choose>

                            <c:if test="${currentPage < totalPages}">
                                <a href="ViewExaminationResults?page=${currentPage + 1}&pageSize=${pageSize}">
                                    Sau <i class="fas fa-chevron-right"></i>
                                </a>
                            </c:if>
                        </div>
                    </c:if>
                </c:if>
            </c:if>
        </div>
    </div>
</body>
</html>
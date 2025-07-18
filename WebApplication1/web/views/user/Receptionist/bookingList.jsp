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
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .header {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
            padding: 30px;
            text-align: center;
            position: relative;
        }

        .header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grid" width="10" height="10" patternUnits="userSpaceOnUse"><path d="M 10 0 L 0 0 0 10" fill="none" stroke="rgba(255,255,255,0.1)" stroke-width="0.5"/></pattern></defs><rect width="100" height="100" fill="url(%23grid)"/></svg>');
            opacity: 0.3;
        }

        .header h2 {
            font-size: 2.2em;
            margin-bottom: 10px;
            position: relative;
            z-index: 1;
        }

        .header .subtitle {
            font-size: 1.1em;
            opacity: 0.9;
            position: relative;
            z-index: 1;
        }

        .table-content {
            padding: 40px;
        }

        .alert {
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert.error {
            background: linear-gradient(135deg, #ff6b6b, #ee5a52);
            color: white;
            border: 1px solid #ff5252;
        }

        .table-container {
            max-width: 100%;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            background: #f8f9fa;
            border-radius: 12px;
            overflow: hidden;
        }

        th, td {
            padding: 15px 20px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
        }

        th {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            color: #333;
            font-weight: 600;
            font-size: 1.05em;
            text-transform: uppercase;
        }

        th i {
            margin-right: 8px;
            color: #667eea;
        }

        tr {
            transition: all 0.3s ease;
        }

        tr:hover {
            background: #f1f5f9;
            transform: translateY(-2px);
        }

        .null {
            color: #6b7280;
            font-style: italic;
        }

        .floating-elements {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            overflow: hidden;
        }

        .floating-elements::before,
        .floating-elements::after {
            content: '';
            position: absolute;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.1);
            animation: float 6s ease-in-out infinite;
        }

        .floating-elements::before {
            width: 60px;
            height: 60px;
            top: 20%;
            left: 10%;
            animation-delay: 0s;
        }

        .floating-elements::after {
            width: 40px;
            height: 40px;
            top: 60%;
            right: 10%;
            animation-delay: 3s;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-20px); }
        }

        @media (max-width: 768px) {
            .container {
                margin: 10px;
                border-radius: 15px;
            }

            .header {
                padding: 20px;
            }

            .header h2 {
                font-size: 1.8em;
            }

            .table-content {
                padding: 20px;
            }

            th, td {
                padding: 10px;
                font-size: 0.9em;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
                        <a href="/ISP392_Group1/views/user/Receptionist/ReceptionistDashBoard.jsp"
               class="inline-block mt-4 bg-white text-blue-700 font-semibold px-5 py-2 rounded-lg shadow hover:bg-blue-100 transition duration-300 z-10 relative">
               <i class="fas fa-arrow-left mr-2"></i> Quay lại Dashboard
            </a>
            <div class="floating-elements"></div>
            <h2><i class="fas fa-calendar-alt"></i> Danh sách Lịch hẹn</h2>

            <!-- Nút quay lại Dashboard -->


            <p class="subtitle">Quản lý lịch hẹn phòng khám hiệu quả</p>
        </div>

        <div class="table-content">
            <c:if test="${not empty error}">
                <div class="alert error">
                    <i class="fas fa-exclamation-circle"></i>
                    ${error}
                </div>
            </c:if>

            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th><i class="fas fa-id-badge"></i> ID</th>
                            <th><i class="fas fa-user"></i> Họ tên bệnh nhân</th>
                            <th><i class="fas fa-phone"></i> Điện thoại</th>
                            <th><i class="fas fa-envelope"></i> Email</th>
                            <th><i class="fas fa-user-md"></i> Bác sĩ</th>
                            <th><i class="fas fa-user-nurse"></i> Y tá</th>
                            <th><i class="fas fa-concierge-bell"></i> Lễ tân</th>
                            <th><i class="fas fa-door-open"></i> Phòng</th>
                            <th><i class="fas fa-clock"></i> Thời gian</th>
                            <th><i class="fas fa-info-circle"></i> Trạng thái</th>
                            <th><i class="fas fa-stethoscope"></i> Dịch vụ</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="b" items="${bookings}">
                            <tr>
                                <td>${b.appointmentID}</td>
                                <td>${b.patientName}</td>
                                <td>${b.patientPhone}</td>
                                <td>${b.patientEmail}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${empty b.doctorName}">
                                            <span class="null">Không có</span>
                                        </c:when>
                                        <c:otherwise>${b.doctorName}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${empty b.nurseName}">
                                            <span class="null">Không có</span>
                                        </c:when>
                                        <c:otherwise>${b.nurseName}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${empty b.receptionistName}">
                                            <span class="null">Không có</span>
                                        </c:when>
                                        <c:otherwise>${b.receptionistName}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${empty b.roomName}">
                                            <span class="null">Không có</span>
                                        </c:when>
                                        <c:otherwise>${b.roomName}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <fmt:formatDate value="${b.appointmentTime}" pattern="dd/MM/yyyy HH:mm" />
                                </td>
                                <td>${b.status}</td>
                                <td>${b.serviceInfo}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>

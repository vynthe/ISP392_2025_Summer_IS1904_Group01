<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Phòng của Tôi</title>
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
            max-width: 1400px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .header-title {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .header h1 {
            color: #2c3e50;
            font-size: 2.2rem;
            font-weight: 700;
            background: linear-gradient(45deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .header-icon {
            font-size: 2.5rem;
            color: #667eea;
        }

        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 25px;
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
            text-decoration: none;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }

        .back-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
        }

        .error {
            background: linear-gradient(45deg, #ff6b6b, #ee5a6f);
            color: white;
            padding: 15px 20px;
            border-radius: 10px;
            margin: 20px 0;
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
            box-shadow: 0 4px 15px rgba(255, 107, 107, 0.3);
        }

        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
            border-left: 4px solid #667eea;
            transition: all 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.15);
        }

        .stat-card h3 {
            color: #2c3e50;
            font-size: 1.8rem;
            margin-bottom: 5px;
        }

        .stat-card p {
            color: #7f8c8d;
            font-size: 0.9rem;
        }

        .table-container {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
            border: 1px solid #e8f4fd;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
        }

        .table th {
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
            padding: 18px 15px;
            text-align: left;
            font-weight: 600;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .table td {
            padding: 15px;
            border-bottom: 1px solid #f1f3f4;
            vertical-align: middle;
        }

        .table tbody tr {
            transition: all 0.3s ease;
        }

        .table tbody tr:hover {
            background: linear-gradient(90deg, #f8f9ff, #ffffff);
            transform: scale(1.01);
        }

        .table tbody tr:nth-child(even) {
            background: #fafbff;
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .status-active {
            background: #d4edda;
            color: #155724;
        }

        .status-inactive {
            background: #f8d7da;
            color: #721c24;
        }

        .status-maintenance {
            background: #fff3cd;
            color: #856404;
        }

        .staff-info {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 5px;
        }

        .staff-info.doctor {
            color: #0066cc;
        }

        .staff-info.nurse {
            color: #28a745;
        }

        .staff-info.na {
            color: #6c757d;
        }

        .detail-btn {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 6px 12px;
            margin: 2px;
            border: none;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .btn-doctor {
            background: linear-gradient(45deg, #0066cc, #0052a3);
            color: white;
        }

        .btn-nurse {
            background: linear-gradient(45deg, #28a745, #1e7e34);
            color: white;
        }

        .btn-service {
            background: linear-gradient(45deg, #17a2b8, #138496);
            color: white;
        }

        .detail-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #7f8c8d;
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 20px;
            opacity: 0.5;
        }

        .empty-state h3 {
            font-size: 1.5rem;
            margin-bottom: 10px;
            color: #2c3e50;
        }

        .room-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
            border-left: 4px solid #667eea;
            transition: all 0.3s ease;
        }

        .room-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.15);
        }

        .room-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .room-id {
            font-size: 1.2rem;
            font-weight: 700;
            color: #2c3e50;
        }

        .room-name {
            font-size: 1.1rem;
            color: #667eea;
            font-weight: 600;
        }

        .room-description {
            color: #7f8c8d;
            margin-bottom: 15px;
            line-height: 1.5;
        }

        .staff-section {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 15px;
        }

        .staff-card {
            background: #f8f9ff;
            padding: 15px;
            border-radius: 10px;
            border: 1px solid #e8f4fd;
        }

        .timestamps {
            display: flex;
            gap: 20px;
            color: #6c757d;
            font-size: 0.9rem;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #e8f4fd;
        }

        @media (max-width: 768px) {
            .container {
                padding: 20px;
                margin: 10px;
            }

            .header {
                flex-direction: column;
                text-align: center;
            }

            .header h1 {
                font-size: 1.8rem;
            }

            .table-container {
                overflow-x: auto;
            }

            .table {
                min-width: 1000px;
            }

            .staff-section {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="header-title">
                <i class="fas fa-door-open header-icon"></i>
                <h1>Phòng của Tôi</h1>
            </div>
            <a href="${pageContext.request.contextPath}/views/user/DoctorNurse/EmployeeDashBoard.jsp" class="back-btn">
                <i class="fas fa-arrow-left"></i> Quay lại Trang chủ
            </a>
        </div>

        <c:if test="${not empty error}">
            <div class="error">
                <i class="fas fa-exclamation-triangle"></i>
                ${error}
            </div>
        </c:if>

        <c:choose>
            <c:when test="${not empty roomList}">
                <!-- Thống kê nhanh -->
                <div class="stats-container">
                    <div class="stat-card">
                        <h3><c:out value="${roomList.size()}" default="0"/></h3>
                        <p><i class="fas fa-door-open"></i> Tổng số phòng được phân công</p>
                    </div>
                    <div class="stat-card">
                        <h3>
                            <c:set var="activeCount" value="0"/>
                            <c:forEach var="room" items="${roomList}">
                                <c:if test="${room.status == 'Active' || room.status == 'Hoạt động'}">
                                    <c:set var="activeCount" value="${activeCount + 1}"/>
                                </c:if>
                            </c:forEach>
                            ${activeCount}
                        </h3>
                        <p><i class="fas fa-check-circle"></i> Phòng đang hoạt động</p>
                    </div>
                    <div class="stat-card">
                        <h3>${roomList.size() - activeCount}</h3>
                        <p><i class="fas fa-tools"></i> Phòng bảo trì/Khác</p>
                    </div>
                </div>

                <!-- Hiển thị dạng card cho mobile/tablet -->
                <div class="room-cards" style="display: none;">
                    <c:forEach var="room" items="${roomList}">
                        <div class="room-card">
                            <div class="room-header">
                                <div>
                                    <div class="room-id">#${room.roomID}</div>
                                    <div class="room-name">${room.roomName}</div>
                                </div>
                                <div>
                                    <c:choose>
                                        <c:when test="${room.status == 'Active' || room.status == 'Hoạt động'}">
                                            <span class="status-badge status-active">
                                                <i class="fas fa-check-circle"></i> Hoạt động
                                            </span>
                                        </c:when>
                                        <c:when test="${room.status == 'Maintenance' || room.status == 'Bảo trì'}">
                                            <span class="status-badge status-maintenance">
                                                <i class="fas fa-tools"></i> Bảo trì
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge status-inactive">
                                                <i class="fas fa-times-circle"></i> Không hoạt động
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="room-description">${room.description}</div>

                            <div class="staff-section">
                                <div class="staff-card">
                                    <h4><i class="fas fa-user-md"></i> Bác sĩ</h4>
                                    <c:choose>
                                        <c:when test="${not empty room.doctorID}">
                                            <div class="staff-info doctor">
                                                <i class="fas fa-user-md"></i>
                                                <span>ID: ${room.doctorID}</span>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="staff-info na">
                                                <i class="fas fa-user-slash"></i>
                                                <span>Chưa phân công</span>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="staff-card">
                                    <h4><i class="fas fa-user-nurse"></i> Y tá</h4>
                                    <c:choose>
                                        <c:when test="${not empty room.nurseID}">
                                            <div class="staff-info nurse">
                                                <i class="fas fa-user-nurse"></i>
                                                <span>ID: ${room.nurseID}</span>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="staff-info na">
                                                <i class="fas fa-user-slash"></i>
                                                <span>Chưa phân công</span>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="timestamps">
                                <div><i class="fas fa-user"></i> Tạo bởi: ${room.createdBy}</div>
                                <div><i class="fas fa-calendar-plus"></i> Tạo: ${room.createdAt}</div>
                                <div><i class="fas fa-calendar-edit"></i> Cập nhật: ${room.updatedAt}</div>
                                <a href="${pageContext.request.contextPath}/ViewRoomDetailServlet?id=${room.roomID}" class="detail-btn btn-service" style="margin-top: 10px;">
                                    <i class="fas fa-info-circle"></i> Xem chi tiết & Dịch vụ
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Bảng danh sách phòng cho desktop -->
                <div class="table-container">
                    <table class="table">
                        <thead>
                            <tr>
                                <th><i class="fas fa-hashtag"></i> Mã Phòng</th>
                                <th><i class="fas fa-door-open"></i> Tên Phòng</th>
                                <th><i class="fas fa-info-circle"></i> Mô Tả</th>
                                <th><i class="fas fa-user-md"></i> Bác Sĩ</th>
                                <th><i class="fas fa-user-nurse"></i> Y Tá</th>
                                <th><i class="fas fa-toggle-on"></i> Trạng Thái</th>
                                <th><i class="fas fa-user"></i> Người Tạo</th>
                                <th><i class="fas fa-calendar"></i> Ngày Tạo</th>
                                <th><i class="fas fa-calendar-edit"></i> Cập Nhật</th>
                                <th><i class="fas fa-cogs"></i> Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="room" items="${roomList}">
                                <tr>
                                    <td><strong>${room.roomID}</strong></td>
                                    <td>${room.roomName}</td>
                                    <td>${room.description}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty room.doctorID}">
                                                <div class="staff-info doctor">
                                                    <i class="fas fa-user-md"></i>
                                                    <span>ID: ${room.doctorID}</span>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="staff-info na">
                                                    <i class="fas fa-user-slash"></i>
                                                    <span>Chưa phân công</span>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty room.nurseID}">
                                                <div class="staff-info nurse">
                                                    <i class="fas fa-user-nurse"></i>
                                                    <span>ID: ${room.nurseID}</span>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="staff-info na">
                                                    <i class="fas fa-user-slash"></i>
                                                    <span>Chưa phân công</span>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${room.status == 'Active' || room.status == 'Hoạt động'}">
                                                <span class="status-badge status-active">
                                                    <i class="fas fa-check-circle"></i> Hoạt động
                                                </span>
                                            </c:when>
                                            <c:when test="${room.status == 'Maintenance' || room.status == 'Bảo trì'}">
                                                <span class="status-badge status-maintenance">
                                                    <i class="fas fa-tools"></i> Bảo trì
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-inactive">
                                                    <i class="fas fa-times-circle"></i> Không hoạt động
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <i class="fas fa-user"></i> ${room.createdBy}
                                    </td>
                                    <td>${room.createdAt}</td>
                                    <td>${room.updatedAt}</td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/ViewRoomDetailServlet?id=${room.roomID}" class="detail-btn btn-service">
                                            <i class="fas fa-info-circle"></i> Xem chi tiết & Dịch vụ
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-door-closed"></i>
                    <h3>Chưa có phòng nào được phân công</h3>
                    <p>Hiện tại bạn chưa được phân công vào phòng nào. Vui lòng liên hệ quản trị viên để được hỗ trợ.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script>
        // Responsive handling - switch between table and card view
        function handleResponsive() {
            const tableContainer = document.querySelector('.table-container');
            const cardContainer = document.querySelector('.room-cards');
            
            if (window.innerWidth <= 768) {
                tableContainer.style.display = 'none';
                cardContainer.style.display = 'block';
            } else {
                tableContainer.style.display = 'block';
                cardContainer.style.display = 'none';
            }
        }

        // Initial check and event listener
        handleResponsive();
        window.addEventListener('resize', handleResponsive);

        // Add hover effects for table rows
        document.querySelectorAll('.table tbody tr').forEach(row => {
            row.addEventListener('mouseenter', function() {
                this.style.transform = 'scale(1.01)';
            });
            
            row.addEventListener('mouseleave', function() {
                this.style.transform = 'scale(1)';
            });
        });

        // Add click tracking for detail buttons
        document.querySelectorAll('.detail-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                // You can add analytics or loading state here
                console.log('Viewing details for:', this.href);
            });
        });
    </script>
</body>
</html>
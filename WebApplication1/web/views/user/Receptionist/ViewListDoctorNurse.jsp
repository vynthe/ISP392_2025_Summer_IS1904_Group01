<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh Sách Nhân Viên Y Tế</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
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
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
            overflow: hidden;
        }

        .header {
            background: linear-gradient(135deg, #2c5282 0%, #3182ce 100%);
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
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 20"><defs><radialGradient id="a" cx="50%" cy="0%" r="100%"><stop offset="0%" style="stop-color:white;stop-opacity:0.1"/><stop offset="100%" style="stop-color:white;stop-opacity:0"/></radialGradient></defs><rect width="100" height="20" fill="url(%23a)"/></svg>');
        }

        .header h1 {
            font-size: 2.5rem;
            font-weight: 300;
            margin-bottom: 10px;
            position: relative;
            z-index: 1;
        }

        .header .subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
            position: relative;
            z-index: 1;
        }

        .content {
            padding: 30px;
        }

        .search-filter-bar {
            display: flex;
            gap: 15px;
            margin-bottom: 25px;
            flex-wrap: wrap;
            align-items: center;
        }

        .search-box {
            flex: 1;
            min-width: 250px;
            position: relative;
        }

        .search-box input {
            width: 100%;
            padding: 12px 40px 12px 15px;
            border: 2px solid #e2e8f0;
            border-radius: 25px;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .search-box input:focus {
            outline: none;
            border-color: #3182ce;
            box-shadow: 0 0 0 3px rgba(49, 130, 206, 0.1);
        }

        .search-box i {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #a0aec0;
        }

        .filter-select {
            padding: 12px 15px;
            border: 2px solid #e2e8f0;
            border-radius: 25px;
            font-size: 14px;
            background: white;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .filter-select:focus {
            outline: none;
            border-color: #3182ce;
            box-shadow: 0 0 0 3px rgba(49, 130, 206, 0.1);
        }

        .stats-bar {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: linear-gradient(135deg, #4299e1 0%, #3182ce 100%);
            color: white;
            padding: 20px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        }

        .stat-card i {
            font-size: 2rem;
            margin-bottom: 10px;
            opacity: 0.8;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            margin-bottom: 5px;
        }

        .stat-label {
            font-size: 0.9rem;
            opacity: 0.9;
        }

        .error {
            background: linear-gradient(135deg, #fc8181 0%, #e53e3e 100%);
            color: white;
            padding: 15px 20px;
            border-radius: 10px;
            text-align: center;
            margin-bottom: 20px;
            box-shadow: 0 5px 15px rgba(229, 62, 62, 0.3);
        }

        .table-container {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
            margin-bottom: 30px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: linear-gradient(135deg, #2d3748 0%, #4a5568 100%);
            color: white;
            padding: 18px 15px;
            text-align: left;
            font-weight: 600;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        td {
            padding: 15px;
            border-bottom: 1px solid #e2e8f0;
            vertical-align: middle;
        }

        tr:hover {
            background: linear-gradient(135deg, #f7fafc 0%, #edf2f7 100%);
            transform: translateY(-1px);
            transition: all 0.3s ease;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            margin-right: 10px;
            float: left;
        }

        .user-info {
            display: flex;
            align-items: center;
        }

        .user-name {
            font-weight: 600;
            color: #2d3748;
        }

        .role-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .role-doctor {
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
            color: white;
        }

        .role-nurse {
            background: linear-gradient(135deg, #ed8936 0%, #dd6b20 100%);
            color: white;
        }

        .specialization {
            color: #4a5568;
            font-style: italic;
        }

        .details-button {
            background: linear-gradient(135deg, #4299e1 0%, #3182ce 100%);
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 25px;
            font-size: 0.9rem;
            font-weight: 500;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 15px rgba(66, 153, 225, 0.3);
        }

        .details-button:hover {
            background: linear-gradient(135deg, #3182ce 0%, #2c5282 100%);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(66, 153, 225, 0.4);
        }

        .footer {
            padding: 20px 30px;
            background: #f7fafc;
            border-top: 1px solid #e2e8f0;
            text-align: center;
        }

        .back-link {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 30px;
            text-decoration: none;
            border-radius: 25px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }

        .back-link:hover {
            background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #4a5568;
        }

        .empty-state i {
            font-size: 4rem;
            color: #a0aec0;
            margin-bottom: 20px;
        }

        .empty-state h3 {
            font-size: 1.5rem;
            margin-bottom: 10px;
            color: #2d3748;
        }

        @media (max-width: 768px) {
            .container {
                margin: 10px;
                border-radius: 15px;
            }

            .header h1 {
                font-size: 2rem;
            }

            .content {
                padding: 20px;
            }

            .search-filter-bar {
                flex-direction: column;
            }

            .search-box {
                min-width: 100%;
            }

            .stats-bar {
                grid-template-columns: 1fr;
            }

            table {
                font-size: 0.9rem;
            }

            th, td {
                padding: 12px 8px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-user-md"></i> Danh Sách Nhân Viên Y Tế</h1>
            <p class="subtitle">Danh sách toàn bộ bác sĩ và y tá</p>
        </div>

        <div class="content">
            <!-- Search and Filter Bar -->
            <div class="search-filter-bar">
                <div class="search-box">
                    <input type="text" id="searchInput" placeholder="Tìm kiếm theo tên hoặc chuyên khoa...">
                    <i class="fas fa-search"></i>
                </div>
                <select class="filter-select" id="roleFilter">
                    <option value="">Tất cả vai trò</option>
                    <option value="Doctor">Bác sĩ</option>
                    <option value="Nurse">Y Tá</option>
                </select>
            </div>

            <!-- Statistics Bar -->
            <div class="stats-bar">
                <div class="stat-card">
                    <i class="fas fa-user-md"></i>
                    <div class="stat-number" id="doctorCount">0</div>
                    <div class="stat-label">Bác sĩ</div>
                </div>
                <div class="stat-card">
                    <i class="fas fa-user-nurse"></i>
                    <div class="stat-number" id="nurseCount">0</div>
                    <div class="stat-label">Y Tá</div>
                </div>
                <div class="stat-card">
                    <i class="fas fa-users"></i>
                    <div class="stat-number" id="totalCount">0</div>
                    <div class="stat-label">Tổng nhân viên</div>
                </div>
            </div>

            <!-- Display error message if present -->
            <c:if test="${not empty error}">
                <div class="error">
                    <i class="fas fa-exclamation-triangle"></i> ${error}
                </div>
            </c:if>

            <!-- Display the table of doctors and nurses -->
            <c:choose>
                <c:when test="${empty doctorNurseList}">
                    <div class="empty-state">
                        <i class="fas fa-user-times"></i>
                        <h3>Không tìm thấy nhân viên y tế</h3>
                        <p>Hiện tại không có bác sĩ hoặc điều dưỡng nào trong hệ thống.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-container">
                        <table id="staffTable">
                            <thead>
                                <tr>
                                    <th><i class="fas fa-id-card"></i> Mã số</th>
                                    <th><i class="fas fa-user"></i> Nhân viên</th>
                                    <th><i class="fas fa-user-tag"></i> Vai trò</th>
                                    <th><i class="fas fa-stethoscope"></i> Chuyên khoa</th>
                                    <th><i class="fas fa-cog"></i> Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="user" items="${doctorNurseList}">
                                    <tr data-role="${user.role}">
                                        <td><strong>#${user.userID}</strong></td>
                                        <td>
                                            <div class="user-info">
                                                <div class="user-avatar">
                                                    ${user.fullName.substring(0,1).toUpperCase()}
                                                </div>
                                                <div class="user-name">${user.fullName}</div>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="role-badge ${user.role.toLowerCase() == 'doctor' ? 'role-doctor' : 'role-nurse'}">
                                                <i class="fas ${user.role.toLowerCase() == 'doctor' ? 'fa-user-md' : 'fa-user-nurse'}"></i>
                                                ${user.role}
                                            </span>
                                        </td>
                                        <td>
                                            <span class="specialization">
                                                ${user.specialization != null ? user.specialization : 'Khám tổng quát'}
                                            </span>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/userDetails?userID=${user.userID}" class="details-button">
                                                <i class="fas fa-eye"></i> Xem chi tiết
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="footer">
            <a href="${pageContext.request.contextPath}/views/user/Receptionist/ReceptionistDashBoard.jsp" class="back-link">
                <i class="fas fa-arrow-left"></i> Quay lại Dashboard
            </a>
        </div>
    </div>

    <script>
        // Search and filter functionality
        document.addEventListener('DOMContentLoaded', function() {
            const searchInput = document.getElementById('searchInput');
            const roleFilter = document.getElementById('roleFilter');
            const table = document.getElementById('staffTable');
            const rows = table ? table.getElementsByTagName('tbody')[0].getElementsByTagName('tr') : [];

            // Update statistics
            updateStats();

            function updateStats() {
                let doctorCount = 0;
                let nurseCount = 0;
                
                Array.from(rows).forEach(row => {
                    if (row.style.display !== 'none') {
                        const role = row.getAttribute('data-role');
                        if (role && role.toLowerCase() === 'doctor') {
                            doctorCount++;
                        } else if (role && role.toLowerCase() === 'nurse') {
                            nurseCount++;
                        }
                    }
                });

                const totalCount = doctorCount + nurseCount;
                
                document.getElementById('doctorCount').textContent = doctorCount;
                document.getElementById('nurseCount').textContent = nurseCount;
                document.getElementById('totalCount').textContent = totalCount;
            }

            function filterTable() {
                const searchTerm = searchInput.value.toLowerCase();
                const roleFilter = document.getElementById('roleFilter').value;

                Array.from(rows).forEach(row => {
                    const name = row.cells[1].textContent.toLowerCase();
                    const specialization = row.cells[3].textContent.toLowerCase();
                    const role = row.getAttribute('data-role');

                    const matchesSearch = name.includes(searchTerm) || specialization.includes(searchTerm);
                    const matchesRole = !roleFilter || role === roleFilter;

                    row.style.display = (matchesSearch && matchesRole) ? '' : 'none';
                });

                updateStats();
            }

            if (searchInput) {
                searchInput.addEventListener('input', filterTable);
            }
            
            if (roleFilter) {
                roleFilter.addEventListener('change', filterTable);
            }
        });
    </script>
</body>
</html>
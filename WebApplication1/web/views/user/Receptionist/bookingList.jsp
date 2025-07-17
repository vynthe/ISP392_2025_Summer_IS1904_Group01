<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách lịch hẹn</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(to bottom, #f0f9f1, #e6f5e9);
            min-height: 100vh;
            font-family: 'Inter', sans-serif;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 1.5rem;
        }
        .table-container {
            background-color: #ffffff;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            margin-top: 1rem;
            border: 1px solid #e0e0e0;
        }
        h2 {
            font-size: 1.875rem;
            font-weight: 700;
            color: #1a3c34;
            text-align: center;
            margin-bottom: 2rem;
        }
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            border-radius: 8px;
            overflow: hidden;
        }
        th, td {
            padding: 1rem;
            text-align: center;
            border-bottom: 1px solid #e0e0e0;
        }
        th {
            background: linear-gradient(to bottom, #34c759, #2ca44e);
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.875rem;
            cursor: pointer;
            position: relative;
        }
        th:hover {
            background: linear-gradient(to bottom, #2ca44e, #248f3f);
        }
        th::after {
            content: '\f0dc'; /* Font Awesome sort icon */
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
            margin-left: 0.5rem;
            opacity: 0.5;
        }
        th.asc::after {
            content: '\f0de'; /* Font Awesome sort-up icon */
            opacity: 1;
        }
        th.desc::after {
            content: '\f0dd'; /* Font Awesome sort-down icon */
            opacity: 1;
        }
        tr:last-child td {
            border-bottom: none;
        }
        tr:hover {
            background-color: #f0f9f1;
        }
        .status {
            font-weight: 600;
            padding: 0.25rem 0.75rem;
            border-radius: 12px;
            display: inline-block;
        }
        .status-đã-xác-nhận {
            background-color: #34c759;
            color: white;
        }
        .status-đang-chờ {
            background-color: #facc15;
            color: #1a3c34;
        }
        .status-đã-hủy {
            background-color: #ef4444;
            color: white;
        }
        .no-data {
            text-align: center;
            color: #4b5563;
            font-size: 1.125rem;
            padding: 2rem;
        }
        .back-btn {
            display: inline-flex;
            align-items: center;
            padding: 0.75rem 1.5rem;
            background: linear-gradient(to right, #34c759, #2ca44e);
            color: white;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            transition: background 0.3s ease, transform 0.2s ease;
            margin-bottom: 1.5rem;
        }
        .back-btn:hover {
            background: linear-gradient(to right, #2ca44e, #248f3f);
            transform: translateY(-2px);
        }
        .back-btn i {
            margin-right: 0.5rem;
        }
        .filter-container {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 1rem;
        }
        .filter-container select {
            padding: 0.5rem;
            border-radius: 8px;
            border: 1px solid #d1d5db;
            background-color: #fff;
            font-size: 0.875rem;
            cursor: pointer;
        }
        .filter-container select:focus {
            outline: none;
            border-color: #34c759;
            box-shadow: 0 0 0 3px rgba(52, 199, 89, 0.1);
        }
        @media (max-width: 768px) {
            table {
                display: block;
                overflow-x: auto;
            }
            th, td {
                font-size: 0.875rem;
                padding: 0.75rem;
            }
            h2 {
                font-size: 1.5rem;
            }
            .filter-container {
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <a href="${pageContext.request.contextPath}/views/user/Receptionist/ReceptionistDashBoard.jsp" class="back-btn">
            <i class="fas fa-arrow-left"></i>Quay lại Dashboard
        </a>
        <h2>Danh sách lịch hẹn khám bệnh</h2>
        <div class="table-container">
            <div class="filter-container">
                <select id="statusFilter" onchange="filterTable()">
                <option value="all">Tất cả trạng thái</option>
                <option value="pending">Pending</option>
                <option value="approved">Approved</option>
                <option value="rejected">Rejected</option>
            </select>

            </div>
            <c:if test="${empty bookings}">
                <p class="no-data">Không có lịch hẹn nào.</p>
            </c:if>
            <c:if test="${not empty bookings}">
                <table id="appointmentTable">
                    <thead>
                        <tr>
                            <th data-sort="appointmentID">ID</th>
                            <th data-sort="patientName">Bệnh nhân</th>
                            <th data-sort="doctorName">Bác sĩ</th>
                            <th data-sort="nurseName">Y tá</th>
                            <th data-sort="roomName">Phòng</th>
                            <th data-sort="appointmentTime">Thời gian</th>
                            <th data-sort="status">Trạng thái</th>
                            <th data-sort="serviceInfo">Dịch vụ</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="b" items="${bookings}">
                            <tr data-status="${b.status.toLowerCase()}">
                                <td>${b.appointmentID}</td>
                                <td>${b.patientName}</td>
                                <td>${b.doctorName}</td>
                                <td>${b.nurseName}</td>
                                <td>${b.roomName}</td>
                                <td>${b.appointmentTime}</td>
                                <td>
                                    <span class="status status-${b.status.toLowerCase()}">${b.status}</span>
                                </td>
                                <td>${b.serviceInfo}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
        </div>
    </div>

    <script>
        // Ensure JavaScript is client-side only
        document.addEventListener('DOMContentLoaded', () => {
            const table = document.getElementById('appointmentTable');
            const headers = table?.querySelectorAll('th[data-sort]');
            let sortDirection = {};

            headers?.forEach(header => {
                header.addEventListener('click', () => {
                    const sortKey = header.getAttribute('data-sort');
                    sortDirection[sortKey] = !sortDirection[sortKey]; // Toggle direction
                    sortTable(sortKey, sortDirection[sortKey]);

                    // Update sort indicators
                    headers.forEach(h => h.classList.remove('asc', 'desc'));
                    header.classList.add(sortDirection[sortKey] ? 'asc' : 'desc');
                });
            });

            function sortTable(key, ascending) {
                if (!table) return;
                const tbody = table.querySelector('tbody');
                const rows = Array.from(tbody.querySelectorAll('tr'));

                rows.sort((a, b) => {
                    const colIndex = getColumnIndex(key);
                    const aValue = a.querySelector(`td:nth-child(${colIndex})`).textContent.trim();
                    const bValue = b.querySelector(`td:nth-child(${colIndex})`).textContent.trim();

                    let comparison;
                    if (key === 'appointmentID') {
                        comparison = parseInt(aValue) - parseInt(bValue);
                    } else if (key === 'appointmentTime') {
                        comparison = new Date(aValue) - new Date(bValue);
                    } else {
                        comparison = aValue.localeCompare(bValue);
                    }

                    return ascending ? comparison : -comparison;
                });

                tbody.innerHTML = '';
                rows.forEach(row => tbody.appendChild(row));
            }

            function getColumnIndex(key) {
                const headers = Array.from(table.querySelectorAll('th'));
                return headers.findIndex(h => h.getAttribute('data-sort') === key) + 1;
            }

            // Table filtering
            window.filterTable = function() {
                const filterValue = document.getElementById('statusFilter').value;
                const rows = document.querySelectorAll('#appointmentTable tbody tr');

                rows.forEach(row => {
                    const status = row.getAttribute('data-status');
                    row.style.display = (filterValue === 'all' || status === filterValue) ? '' : 'none';
                });
            };
        });
    </script>
</body>
</html>

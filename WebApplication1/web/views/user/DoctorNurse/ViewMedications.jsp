<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Danh Sách Thuốc</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/jquery.dataTables.min.css">
    <style>
        :root {
            --primary-purple: #6b48ff;
            --secondary-purple: #a856ff;
            --light-purple: #f0eaff;
            --dark-text: #1a1a1a;
            --light-text: #666;
            --border-color: #e0e0e0;
            --error-red: #ff4444;
            --white: #ffffff;
            --shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        body {
            background: linear-gradient(to right, var(--primary-purple), var(--secondary-purple));
            font-family: 'Roboto', sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            color: var(--dark-text);
        }

        .container {
            width: 90%;
            max-width: 1200px;
            background-color: var(--white);
            padding: 40px;
            border-radius: 20px;
            box-shadow: var(--shadow);
            animation: fadeIn 0.6s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            border-bottom: 2px solid var(--light-purple);
            padding-bottom: 20px;
        }

        h2 {
            color: var(--primary-purple);
            margin: 0;
            font-size: 32px;
            font-weight: 700;
        }

        .add-button {
            background-color: var(--primary-purple);
            color: var(--white);
            padding: 12px 25px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 500;
            text-decoration: none;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        .add-button:hover {
            background-color: #5a3de6;
            transform: translateY(-2px);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background-color: var(--white);
            border-radius: 12px;
            overflow: hidden;
        }

        th {
            background-color: var(--light-purple);
            color: var(--primary-purple);
            font-weight: 600;
            text-transform: uppercase;
            padding: 15px;
            text-align: left;
        }

        td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid var(--border-color);
            color: var(--light-text);
            font-size: 14px;
        }

        tr:nth-child(even) {
            background-color: #fafafa;
        }

        tr:hover {
            background-color: #f5f7ff;
        }

        .error {
            color: var(--error-red);
            font-weight: 500;
            margin-bottom: 20px;
            padding: 12px 15px;
            background-color: rgba(255, 68, 68, 0.1);
            border-left: 5px solid var(--error-red);
            border-radius: 5px;
        }

        .no-data {
            text-align: center;
            color: var(--light-text);
            padding: 20px;
            font-style: italic;
            font-size: 16px;
        }

        .action-button {
            color: var(--primary-purple);
            cursor: pointer;
            text-decoration: none;
        }

        .action-button:hover {
            text-decoration: underline;
        }

        @media (max-width: 768px) {
            .container {
                width: 95%;
                padding: 20px;
            }
            .header {
                flex-direction: column;
                gap: 15px;
            }
            h2 {
                font-size: 24px;
            }
            .add-button {
                width: 100%;
                text-align: center;
            }
            table, thead, tbody, th, td, tr {
                display: block;
            }
            thead tr {
                position: absolute;
                top: -9999px;
                left: -9999px;
            }
            tr {
                margin-bottom: 15px;
                border: 1px solid var(--border-color);
                border-radius: 8px;
            }
            td {
                border: none;
                position: relative;
                padding-left: 50%;
                text-align: right;
            }
            td:before {
                content: attr(data-label);
                position: absolute;
                left: 15px;
                width: 45%;
                padding-right: 10px;
                font-weight: 600;
                color: var(--dark-text);
                text-align: left;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h2>Danh Sách Thuốc</h2>
        <a href="${pageContext.request.contextPath}/AddMedicationsServlet" class="add-button">Thêm Thuốc</a>
    </div>

    <div id="error-message" class="error" style="display: none;"></div>

    <table id="medicationTable" class="display">
        <thead>
            <tr>
                <th>STT</th>
                <th>Tên Thuốc</th>
                <th>Hoạt Chất</th>
                <th>Hàm Lượng</th>
                <th>Dạng Bào Chế</th>
                <th>Nhà Sản Xuất</th>
                <th>Hành Động</th>
            </tr>
        </thead>
        <tbody>
        </tbody>
    </table>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
<script>
    $(document).ready(function() {
        const table = $('#medicationTable').DataTable({
            language: {
                search: "Tìm kiếm:",
                lengthMenu: "Hiển thị _MENU_ bản ghi",
                info: "Hiển thị _START_ đến _END_ của _TOTAL_ bản ghi",
                paginate: {
                    first: "Đầu",
                    last: "Cuối",
                    next: "Tiếp",
                    previous: "Trước"
                },
                emptyTable: "Không có dữ liệu thuốc."
            },
            columns: [
                { data: null, render: (data, type, row, meta) => meta.row + 1 },
                { data: 'brandName' },
                { data: 'genericName' },
                { data: 'strength' },
                { data: 'dosageForm' },
                { data: 'manufacturer' },
                {
                    data: null,
                    render: (data, type, row) => 
                        `<a href="${pageContext.request.contextPath}/MedicationDetailServlet?id=${row.id}" class="action-button">🔍 Xem chi tiết</a>`
                }
            ]
        });

        function fetchMedications() {
            $.ajax({
                url: '${pageContext.request.contextPath}/api/medications',
                method: 'GET',
                dataType: 'json',
                success: function(data) {
                    if (data && Array.isArray(data)) {
                        table.clear().rows.add(data).draw();
                    } else {
                        $('#error-message').text('Dữ liệu không hợp lệ từ server.').show();
                    }
                },
                error: function(xhr, status, error) {
                    $('#error-message').text('Lỗi khi tải dữ liệu: ' + (xhr.responseText || error)).show();
                }
            });
        }

        fetchMedications();
    });
</script>
</body>
</html>
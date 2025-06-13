<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.entity.Prescriptions" %>
<html>
<head>
    <title>Danh Sách Toa Thuốc</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
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
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }

        .container {
            width: 90%;
            max-width: 1200px;
            background-color: var(--white);
            padding: 40px;
            border-radius: 20px;
            box-shadow: var(--shadow);
            position: relative;
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
            letter-spacing: 0.5px;
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
            box-shadow: 0 3px 10px rgba(107, 72, 255, 0.3);
        }

        .add-button:hover {
            background-color: #5a3de6;
            transform: translateY(-2px);
        }

        .add-button:active {
            transform: translateY(0);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background-color: var(--white);
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        th {
            background-color: var(--light-purple);
            color: var(--primary-purple);
            font-weight: 600;
            text-transform: uppercase;
            padding: 15px;
            text-align: left;
            border-bottom: 2px solid var(--border-color);
        }

        td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid var(--border-color);
            color: var(--light-text);
            font-size: 14px;
        }

        tr:last-child td {
            border-bottom: none;
        }

        tr:nth-child(even) {
            background-color: #fafafa;
        }

        tr:hover {
            background-color: #f5f7ff;
            transition: background-color 0.2s ease;
        }

        .error {
            color: var(--error-red);
            font-weight: 500;
            margin-bottom: 20px;
            padding: 12px 15px;
            background-color: rgba(255, 68, 68, 0.1);
            border-left: 5px solid var(--error-red);
            border-radius: 5px;
            text-align: left;
        }

        .no-data {
            text-align: center;
            color: var(--light-text);
            padding: 20px;
            font-style: italic;
            font-size: 16px;
        }

        /* Responsive Design */
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
            td:last-child {
                border-bottom: 0;
            }
            .no-data {
                padding: 15px;
            }
        }
    </style>
</head>
<body>
    <form acction="ViewMedicationsServlet" method="get">
<div class="container">
    <div class="header">
        <h2>Danh Sách Toa Thuốc</h2>
        <a href="${pageContext.request.contextPath}/AddMedicationsServlet" class="add-button">Thêm Thuốc</a>
    </div>

    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
        <p class="error"><%= error %></p>
    <%
        }
    %>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Tên Thuốc</th>
                <th>Số Lượng</th>
                <th>Liều Dùng/Cách Dùng</th>
                <th>Ngày Kê Toa</th>
                <th>Hạn Sử Dụng</th>
            </tr>
        </thead>
        <tbody>
            <%
                List<Prescriptions> list = (List<Prescriptions>) request.getAttribute("medicines");
                if (list != null && !list.isEmpty()) {
                    for (Prescriptions p : list) {
            %>
            <tr>
                <td data-label="ID"><%= p.getPrescriptionID() %></td>
                <td data-label="Tên Thuốc"><%= p.getPrescriptionDetails() != null ? p.getPrescriptionDetails() : "N/A" %></td>
                <td data-label="Số Lượng"><%= p.getStatus() != null ? p.getStatus() : "N/A" %></td>
                <td data-label="Liều Dùng/Cách Dùng"><%= p.getCreatedAt() != null ? p.getCreatedAt() : "N/A" %></td>
                <td data-label="Ngày Kê Toa"><%= p.getCreatedAt() != null ? p.getCreatedAt() : "N/A" %></td>
                <td data-label="Hạn Sử Dụng"><%= p.getUpdatedAt() != null ? p.getUpdatedAt() : "N/A" %></td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
                <td colspan="6" class="no-data">Không có dữ liệu toa thuốc.</td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>
</div>
    </form>
</body>
</html>
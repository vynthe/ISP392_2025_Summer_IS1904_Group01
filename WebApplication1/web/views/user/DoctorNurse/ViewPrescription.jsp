<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.entity.Prescriptions" %>
<html>
<head>
    <title>Danh Sách Toa Thuốc</title>
    <style>
        body {
            background-color: #ffe4b5;
            font-family: Arial;
        }
        .container {
            width: 80%;
            margin: auto;
            margin-top: 40px;
            padding: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 0 10px #ccc;
            position: relative;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .add-button {
            background-color: orange;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            text-decoration: none;
        }
        .add-button:hover {
            background-color: #e68a00;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
            text-align: center;
        }
        th {
            background-color: orange;
            color: white;
        }
        .error {
            color: red;
            font-weight: bold;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h2>Danh Sách Toa Thuốc</h2>
        <a href="${pageContext.request.contextPath}/AddPrescriptionServlet" class="add-button">Thêm Thuốc</a>
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
        <tr>
            <th>Số Thứ Tự </th>
            <th>Số Thứ Tự Bác Sĩ </th>
            <th>Số Thứ Tự Bệnh Nhân </th>
            <th>Chi Tiết Toa Thuốc</th>
            <th>Trạng Thái</th>
            <th>Ngày Tạo</th>
        </tr>
        <%
            List<Prescriptions> list = (List<Prescriptions>) request.getAttribute("medicines");
            if (list != null && !list.isEmpty()) {
                for (Prescriptions p : list) {
        %>
        <tr>
            <td><%= p.getPrescriptionID() %></td>
            <td><%= p.getDoctorID() %></td>
            <td><%= p.getPatientID() %></td>
            <td><%= p.getPrescriptionDetails() %></td>
            <td><%= p.getStatus() %></td>
            <td><%= p.getCreatedAt() %></td>
        </tr>
        <%
                }
            } else {
        %>
        <tr>
            <td colspan="6">Không có dữ liệu toa thuốc.</td>
        </tr>
        <%
            }
        %>
    </table>
</div>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Thêm Toa Thuốc</title>
</head>
<body>
<h1>Thêm Toa Thuốc</h1>
<a href="${pageContext.request.contextPath}/AddPrescriptionServlet">
    <button>Thêm Thuốc</button>
</a>
<% String error = (String) request.getAttribute("error"); %>
<% if (error != null) { %>
    <p style="color: red;"><%= error %></p>
<% } %>

<form action="${pageContext.request.contextPath}/AddPrescriptionServlet" method="post">
    <label for="doctorID">ID Bác Sĩ:</label>
    <input type="text" id="doctorID" name="doctorID" required><br><br>

    <label for="patientID">ID Bệnh Nhân:</label>
    <input type="text" id="patientID" name="patientID" required><br><br>

    <label for="prescriptionDetails">Chi Tiết Toa Thuốc:</label><br>
    <textarea id="prescriptionDetails" name="prescriptionDetails" rows="4" cols="50" required></textarea><br><br>

    <label for="status">Trạng Thái:</label>
    <input type="text" id="status" name="status" value="Active" required><br><br>

    <button type="submit">Thêm Toa Thuốc</button>
</form>

<br>
<a href="${pageContext.request.contextPath}/ViewPrescriptionsServlet">Quay lại danh sách toa thuốc</a>
</body>
</html>
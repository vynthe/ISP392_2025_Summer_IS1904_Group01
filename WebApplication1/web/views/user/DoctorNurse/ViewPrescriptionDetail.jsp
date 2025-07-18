<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.entity.Prescriptions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Prescription Detail</title>
        <style>
            body {
                font-family: Arial, sans-serif;
            }

            .container {
                width: 70%;
                margin: auto;
                padding: 20px;
            }

            h2 {
                color: #2a8;
                margin-bottom: 20px;
            }

            .label {
                font-weight: bold;
            }

            .value {
                margin-bottom: 10px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Prescription Detail</h2>

          <div class="value"><span class="label">Mã Đơn Thuốc:</span> ${prescription.prescriptionId}</div>
    <div class="value"><span class="label">Mã Bác Sĩ:</span> ${prescription.doctorId}</div>
    <div class="value"><span class="label">Mã Bệnh Nhân:</span> ${prescription.patientId}</div>
    <div class="value"><span class="label">Nội Dung Kê Đơn:</span> ${prescription.prescriptionDetails}</div>

   <div class="value"><span class="label">Trạng Thái:</span>
    <c:choose>
        <c:when test="${prescription.status == 'Pending'}">Đang chờ</c:when>
        <c:when test="${prescription.status == 'In Progress'}">Đang xử lý</c:when> 
        <c:when test="${prescription.status == 'Completed'}">Hoàn thành</c:when>
        <c:when test="${prescription.status == 'Dispensed'}">Đã cấp phát</c:when>
        <c:when test="${prescription.status == 'Cancelled'}">Đã hủy</c:when>
        <c:otherwise>${prescription.status}</c:otherwise>
    </c:choose>
</div>


    <div class="value"><span class="label">Ngày Tạo:</span> ${createdAtFormatted}</div>
    <div class="value"><span class="label">Ngày Cập Nhật:</span> ${updatedAtFormatted}</div>

    <div style="margin-top: 20px;">
        <a class="back-link" href="${pageContext.request.contextPath}/ViewPrescriptionServlet">
            ← Quay lại danh sách đơn thuốc
        </a>
    </div>
    </body>
</html>

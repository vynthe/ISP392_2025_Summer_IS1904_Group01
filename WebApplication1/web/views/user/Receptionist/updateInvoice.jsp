<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Cập nhật hóa đơn</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f6f8fc; }
        .update-container {
            max-width: 500px;
            margin: 40px auto;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08);
            padding: 32px 28px;
        }
        h2 { color: #4f8cff; text-align: center; margin-bottom: 24px; }
        .form-row { margin-bottom: 16px; }
        .form-label { color: #888; font-weight: bold; display: block; margin-bottom: 4px; }
        .form-input { width: 100%; padding: 8px; border-radius: 6px; border: 1px solid #ccc; }
        .btn-update {
            background: linear-gradient(90deg, #4f8cff, #6ed0fa);
            color: #fff;
            border: none;
            border-radius: 8px;
            padding: 12px 32px;
            font-size: 1.1em;
            font-weight: bold;
            cursor: pointer;
            width: 100%;
            margin-top: 24px;
        }
        .btn-update:hover { background: linear-gradient(90deg, #6ed0fa, #4f8cff); }
        .error { color: red; margin-bottom: 16px; font-weight: bold; text-align: center; }
    </style>
</head>
<body>
<div class="update-container">
    <h2>Cập nhật hóa đơn</h2>
    <c:if test="${not empty error}">
        <div class="error">${error}</div>
    </c:if>
    <c:if test="${not empty invoice}">
    <form method="post" action="${pageContext.request.contextPath}/UpdateInvoiceServlet">
        <div class="form-row">
            <label class="form-label">Mã hóa đơn</label>
            <input class="form-input" type="text" name="invoiceId" value="${invoice.invoiceID}" readonly />
        </div>
        <div class="form-row">
            <label class="form-label">Mã bệnh nhân</label>
            <input class="form-input" type="text" name="patientId" value="${invoice.patientID}" required />
        </div>
        <div class="form-row">
            <label class="form-label">Mã bác sĩ</label>
            <input class="form-input" type="text" name="doctorId" value="${invoice.doctorID}" required />
        </div>
        <div class="form-row">
            <label class="form-label">Mã dịch vụ</label>
            <input class="form-input" type="text" name="serviceId" value="${invoice.serviceID}" required />
        </div>
        <div class="form-row">
            <label class="form-label">Số tiền</label>
            <input class="form-input" type="number" name="totalAmount" value="${invoice.totalAmount}" required />
        </div>
        <div class="form-row">
            <label class="form-label">Trạng thái</label>
            <input class="form-input" type="text" name="status" value="${invoice.status}" required />
        </div>
        <button type="submit" class="btn-update">Cập nhật hóa đơn</button>
    </form>
    </c:if>
</div>
</body>
</html> 
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Xác nhận hóa đơn</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background: #f6f8fc;
            }
            .confirm-container {
                max-width: 500px;
                margin: 40px auto;
                background: #fff;
                border-radius: 12px;
                box-shadow: 0 4px 16px rgba(0,0,0,0.08);
                padding: 32px 28px;
            }
            h2 {
                color: #4f8cff;
                text-align: center;
                margin-bottom: 24px;
            }
            .info-row {
                margin-bottom: 16px;
            }
            .info-label {
                color: #888;
                font-weight: bold;
            }
            .info-value {
                color: #222;
                margin-left: 8px;
            }
            .amount {
                color: #27ae60;
                font-size: 1.3em;
                font-weight: bold;
            }
            .btn-confirm {
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
            .btn-confirm:hover {
                background: linear-gradient(90deg, #6ed0fa, #4f8cff);
            }
        </style>
    </head>
    <body>
        <div class="confirm-container">
            <h2>Xác nhận hóa đơn</h2>
            <c:if test="${not empty error}">
                <div style="color: red; margin-bottom: 16px; font-weight: bold;">${error}</div>
            </c:if>
            <div class="info-row"><span class="info-label">Mã kết quả khám:</span><span class="info-value">${resultId}</span></div>
            <div class="info-row"><span class="info-label">Mã bệnh nhân:</span><span class="info-value">${patientId}</span></div>
            <div class="info-row"><span class="info-label">Mã bác sĩ:</span><span class="info-value">${doctorId}</span></div>
            <div class="info-row"><span class="info-label">Dịch vụ:</span><span class="info-value">${serviceId}</span></div>
            <div class="info-row"><span class="info-label">Số tiền:</span><span class="info-value amount">${totalAmount} VNĐ</span></div>
            <form method="post" action="${pageContext.request.contextPath}/AddInvoiceServlet">
                <input type="hidden" name="patientId" value="${patientId}" />
                <input type="hidden" name="doctorId" value="${doctorId}" />
                <input type="hidden" name="serviceId" value="${serviceId}" />
                <input type="hidden" name="totalAmount" value="${totalAmount}" />
                <input type="hidden" name="resultId" value="${resultId}" />
                <input type="hidden" name="status" value="Chưa thanh toán" />
                <button type="submit" class="btn-confirm">Xác nhận thêm hóa đơn </button>
            </form>
        </div>
    </body>
</html> 
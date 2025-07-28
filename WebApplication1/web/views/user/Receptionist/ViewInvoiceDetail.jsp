<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi Tiết Kết Quả Khám & Hóa Đơn</title>
    <style>
        body { font-family: 'Inter', Arial, sans-serif; background: #f4f6fb; margin: 0; padding: 0; }
        .container { max-width: 900px; margin: 40px auto; background: #fff; border-radius: 16px; box-shadow: 0 8px 32px rgba(0,0,0,0.08); padding: 40px; }
        h2 { color: #5a4fcf; margin-bottom: 20px; }
        .section { margin-bottom: 32px; }
        .label { font-weight: 600; color: #555; width: 180px; display: inline-block; }
        .value { color: #222; }
        .info-row { margin-bottom: 12px; }
        .invoice-section { background: #f8faff; border-radius: 12px; padding: 24px; }
        .no-invoice { color: #d32f2f; font-weight: 600; background: #fff3f3; border-radius: 8px; padding: 16px; }
        .back-btn { display: inline-block; margin-top: 24px; background: #5a4fcf; color: #fff; padding: 12px 28px; border-radius: 8px; text-decoration: none; font-weight: 600; }
        .back-btn:hover { background: #3d2fcf; }
    </style>
</head>
<body>
    <div class="container">
        <!-- ================== THÔNG TIN KẾT QUẢ KHÁM ================== -->
        <h2>Chi Tiết Kết Quả Khám</h2>
        <div class="section">
            <div class="info-row"><span class="label">Mã kết quả:</span> <span class="value">${detail.resultId}</span></div>
            <div class="info-row"><span class="label">Bệnh nhân:</span> <span class="value">${detail.patientName}</span></div>
            <div class="info-row"><span class="label">Bác sĩ:</span> <span class="value">${detail.doctorName}</span></div>
            <div class="info-row"><span class="label">Dịch vụ:</span> <span class="value">${detail.serviceName}</span></div>
            <div class="info-row"><span class="label">Phí dịch vụ:</span> <span class="value">${detail.servicePrice} VNĐ</span></div>
            <div class="info-row"><span class="label">Trạng thái:</span> <span class="value">${detail.resultStatus}</span></div>
            <div class="info-row"><span class="label">Chẩn đoán:</span> <span class="value">${detail.diagnosis}</span></div>
            <div class="info-row"><span class="label">Ghi chú:</span> <span class="value">${detail.notes}</span></div>
            <div class="info-row"><span class="label">Ngày tạo:</span> <span class="value">${detail.resultCreatedAt}</span></div>
            <div class="info-row"><span class="label">Ngày cập nhật:</span> <span class="value">${detail.resultUpdatedAt}</span></div>
        </div>

        <!-- ================== THÔNG TIN HÓA ĐƠN (NẾU CÓ) ================== -->
        <h2>Thông Tin Hóa Đơn</h2>
        <c:choose>
            <c:when test="${detail.invoiceId != null}">
                <div class="invoice-section">
                    <div class="info-row"><span class="label">Mã hóa đơn:</span> <span class="value">${detail.invoiceId}</span></div>
                    <div class="info-row"><span class="label">Tổng tiền:</span> <span class="value">${detail.totalAmount} VNĐ</span></div>
                    <div class="info-row"><span class="label">Trạng thái hóa đơn:</span> <span class="value">${detail.invoiceStatus}</span></div>
                    <div class="info-row"><span class="label">Ngày tạo hóa đơn:</span> <span class="value">${detail.invoiceCreatedAt}</span></div>
                    <div class="info-row"><span class="label">Ngày cập nhật hóa đơn:</span> <span class="value">${detail.invoiceUpdatedAt}</span></div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="no-invoice">
                    Chưa có hóa đơn cho kết quả khám này.
                </div>
            </c:otherwise>
        </c:choose>

        <!-- Nút quay lại -->
        <a href="${pageContext.request.contextPath}/ViewInvoiceServlet" class="back-btn">&larr; Quay lại danh sách</a>
    </div>
</body>
</html>

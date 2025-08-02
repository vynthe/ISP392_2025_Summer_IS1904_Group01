<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Kết Quả Khám & Hóa Đơn</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body { 
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container { 
            max-width: 1000px; 
            margin: 0 auto; 
            background: #fff; 
            border-radius: 20px; 
            box-shadow: 0 20px 60px rgba(0,0,0,0.15); 
            overflow: hidden;
            animation: slideUp 0.6s ease-out;
        }

        @keyframes slideUp {
            from { transform: translateY(30px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        .header {
            background: linear-gradient(135deg, #5a4fcf 0%, #764ba2 100%);
            color: white;
            padding: 30px 40px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .header::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: repeating-linear-gradient(
                45deg,
                transparent,
                transparent 10px,
                rgba(255,255,255,0.05) 10px,
                rgba(255,255,255,0.05) 20px
            );
            animation: shimmer 20s linear infinite;
        }

        @keyframes shimmer {
            0% { transform: translateX(-100%); }
            100% { transform: translateX(100%); }
        }

        .header h1 {
            font-size: 2.2em;
            margin-bottom: 8px;
            position: relative;
            z-index: 1;
        }

        .header .subtitle {
            opacity: 0.9;
            font-size: 1.1em;
            position: relative;
            z-index: 1;
        }

        .content {
            padding: 40px;
        }

        .card {
            background: #fff;
            border-radius: 16px;
            padding: 32px;
            margin-bottom: 32px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            border: 1px solid #f0f0f0;
            position: relative;
            overflow: hidden;
        }

        .card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #5a4fcf, #764ba2);
        }

        .card-title {
            font-size: 1.5em;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .card-title i {
            color: #5a4fcf;
            font-size: 1.2em;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }

        .info-item {
            padding: 16px;
            background: #f8faff;
            border-radius: 12px;
            border-left: 4px solid #5a4fcf;
            transition: all 0.3s ease;
        }

        .info-item:hover {
            transform: translateX(4px);
            box-shadow: 0 4px 12px rgba(90, 79, 207, 0.15);
        }

        .info-label {
            font-weight: 600;
            color: #4a5568;
            font-size: 0.9em;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .info-value {
            color: #2d3748;
            font-size: 1.1em;
            font-weight: 500;
            word-break: break-word;
        }

        /* Status badges */
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            border-radius: 25px;
            font-weight: 600;
            font-size: 0.9em;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }

        .status-completed {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
            box-shadow: 0 4px 15px rgba(16, 185, 129, 0.4);
        }

        .status-pending {
            background: linear-gradient(135deg, #f59e0b, #d97706);
            color: white;
            box-shadow: 0 4px 15px rgba(245, 158, 11, 0.4);
        }

        .status-cancelled {
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: white;
            box-shadow: 0 4px 15px rgba(239, 68, 68, 0.4);
        }

        .status-paid {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
            box-shadow: 0 4px 15px rgba(16, 185, 129, 0.4);
        }

        .status-unpaid {
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: white;
            box-shadow: 0 4px 15px rgba(239, 68, 68, 0.4);
        }

        .price-highlight {
            font-size: 1.3em;
            font-weight: 700;
            color: #5a4fcf;
            text-shadow: 0 2px 4px rgba(90, 79, 207, 0.3);
        }

        .no-invoice {
            background: linear-gradient(135deg, #fee2e2, #fecaca);
            border: 2px dashed #ef4444;
            border-radius: 16px;
            padding: 32px;
            text-align: center;
            color: #dc2626;
            font-weight: 600;
            font-size: 1.1em;
        }

        .no-invoice i {
            font-size: 3em;
            margin-bottom: 16px;
            opacity: 0.7;
        }

        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 12px;
            margin-top: 32px;
            background: linear-gradient(135deg, #5a4fcf, #764ba2);
            color: #fff;
            padding: 16px 32px;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 600;
            font-size: 1.1em;
            transition: all 0.3s ease;
            box-shadow: 0 6px 20px rgba(90, 79, 207, 0.4);
        }

        .back-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(90, 79, 207, 0.6);
        }

        .diagnosis-box {
            background: linear-gradient(135deg, #e0f2fe, #b3e5fc);
            border-left: 6px solid #0288d1;
            border-radius: 12px;
            padding: 20px;
            margin: 16px 0;
        }

        .notes-box {
            background: linear-gradient(135deg, #f3e5f5, #e1bee7);
            border-left: 6px solid #8e24aa;
            border-radius: 12px;
            padding: 20px;
            margin: 16px 0;
        }

        @media (max-width: 768px) {
            .content {
                padding: 20px;
            }
            
            .info-grid {
                grid-template-columns: 1fr;
            }
            
            .header h1 {
                font-size: 1.8em;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-file-medical"></i> Chi Tiết Kết Quả Khám</h1>
            <div class="subtitle">Thông tin chi tiết về kết quả khám bệnh và hóa đơn</div>
        </div>

        <div class="content">
            <!-- ================== THÔNG TIN KẾT QUẢ KHÁM ================== -->
            <div class="card">
                <h2 class="card-title">
                    <i class="fas fa-stethoscope"></i>
                    Thông Tin Kết Quả Khám
                </h2>
                
                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-label">
                            <i class="fas fa-hashtag"></i>
                            Mã kết quả
                        </div>
                        <div class="info-value">${detail.resultId}</div>
                    </div>

                    <div class="info-item">
                        <div class="info-label">
                            <i class="fas fa-user"></i>
                            Bệnh nhân
                        </div>
                        <div class="info-value">${detail.patientName}</div>
                    </div>

                    <div class="info-item">
                        <div class="info-label">
                            <i class="fas fa-user-md"></i>
                            Bác sĩ
                        </div>
                        <div class="info-value">${detail.doctorName}</div>
                    </div>

                    <div class="info-item">
                        <div class="info-label">
                            <i class="fas fa-medical-kit"></i>
                            Dịch vụ
                        </div>
                        <div class="info-value">${detail.serviceName}</div>
                    </div>

                    <div class="info-item">
                        <div class="info-label">
                            <i class="fas fa-dollar-sign"></i>
                            Phí dịch vụ
                        </div>
                        <div class="info-value price-highlight">${detail.servicePrice} VNĐ</div>
                    </div>

                    <div class="info-item">
                        <div class="info-label">
                            <i class="fas fa-flag"></i>
                            Trạng thái
                        </div>
                        <div class="info-value">
                            <c:choose>
                                <c:when test="${detail.resultStatus == 'Hoàn thành' || detail.resultStatus == 'COMPLETED'}">
                                    <span class="status-badge status-completed">
                                        <i class="fas fa-check-circle"></i>
                                        ${detail.resultStatus}
                                    </span>
                                </c:when>
                                <c:when test="${detail.resultStatus == 'Đang chờ' || detail.resultStatus == 'PENDING'}">
                                    <span class="status-badge status-pending">
                                        <i class="fas fa-clock"></i>
                                        ${detail.resultStatus}
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-badge status-cancelled">
                                        <i class="fas fa-times-circle"></i>
                                        ${detail.resultStatus}
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="info-item">
                        <div class="info-label">
                            <i class="fas fa-calendar-plus"></i>
                            Ngày tạo
                        </div>
                        <div class="info-value">${detail.resultCreatedAt}</div>
                    </div>

                    <div class="info-item">
                        <div class="info-label">
                            <i class="fas fa-calendar-edit"></i>
                            Ngày cập nhật
                        </div>
                        <div class="info-value">${detail.resultUpdatedAt}</div>
                    </div>
                </div>

                <c:if test="${detail.diagnosis != null && detail.diagnosis != ''}">
                    <div class="diagnosis-box">
                        <div class="info-label">
                            <i class="fas fa-diagnoses"></i>
                            Chẩn đoán
                        </div>
                        <div class="info-value">${detail.diagnosis}</div>
                    </div>
                </c:if>

                <c:if test="${detail.notes != null && detail.notes != ''}">
                    <div class="notes-box">
                        <div class="info-label">
                            <i class="fas fa-sticky-note"></i>
                            Ghi chú
                        </div>
                        <div class="info-value">${detail.notes}</div>
                    </div>
                </c:if>
            </div>

            <!-- ================== THÔNG TIN HÓA ĐƠN ================== -->
            <div class="card">
                <h2 class="card-title">
                    <i class="fas fa-receipt"></i>
                    Thông Tin Hóa Đơn
                </h2>
                
                <c:choose>
                    <c:when test="${detail.invoiceId != null}">
                        <div class="info-grid">
                            <div class="info-item">
                                <div class="info-label">
                                    <i class="fas fa-hashtag"></i>
                                    Mã hóa đơn
                                </div>
                                <div class="info-value">${detail.invoiceId}</div>
                            </div>

                            <div class="info-item">
                                <div class="info-label">
                                    <i class="fas fa-money-bill-wave"></i>
                                    Tổng tiền
                                </div>
                                <div class="info-value price-highlight">${detail.totalAmount} VNĐ</div>
                            </div>

                            <div class="info-item">
                                <div class="info-label">
                                    <i class="fas fa-flag"></i>
                                    Trạng thái thanh toán
                                </div>
                                <div class="info-value">
                                    <c:choose>
                                        <c:when test="${detail.invoiceStatus == 'Đã thanh toán' || detail.invoiceStatus == 'PAID'}">
                                            <span class="status-badge status-paid">
                                                <i class="fas fa-check-circle"></i>
                                                ${detail.invoiceStatus}
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge status-unpaid">
                                                <i class="fas fa-exclamation-circle"></i>
                                                ${detail.invoiceStatus}
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="info-item">
                                <div class="info-label">
                                    <i class="fas fa-calendar-plus"></i>
                                    Ngày tạo hóa đơn
                                </div>
                                <div class="info-value">${detail.invoiceCreatedAt}</div>
                            </div>

                            <div class="info-item">
                                <div class="info-label">
                                    <i class="fas fa-calendar-edit"></i>
                                    Ngày cập nhật hóa đơn
                                </div>
                                <div class="info-value">${detail.invoiceUpdatedAt}</div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="no-invoice">
                            <i class="fas fa-file-invoice"></i>
                            <div>Chưa có hóa đơn cho kết quả khám này</div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <a href="${pageContext.request.contextPath}/ViewInvoiceServlet" class="back-btn">
                <i class="fas fa-arrow-left"></i>
                Quay lại danh sách
            </a>
        </div>
    </div>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hóa đơn của tôi</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', 'Segoe UI', -apple-system, BlinkMacSystemFont, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
            min-height: 100vh;
            padding: 20px;
            color: #2d3748;
            line-height: 1.6;
        }
        
        .main-container {
            max-width: 1400px;
            margin: 0 auto;
        }
        
        .page-header {
            text-align: center;
            margin-bottom: 40px;
            padding: 40px 20px;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.3);
            position: relative;
            overflow: hidden;
        }
        
        .page-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(90deg, #667eea, #764ba2, #f093fb);
        }
        
        .page-title {
            font-size: 3rem;
            font-weight: 800;
            background: linear-gradient(135deg, #667eea, #764ba2, #f093fb);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 15px;
            letter-spacing: -1px;
        }
        
        .page-subtitle {
            color: #718096;
            font-size: 1.2rem;
            font-weight: 500;
        }
        
        .invoices-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(380px, 1fr));
            gap: 24px;
            margin-bottom: 40px;
        }
        
        .invoice-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.2);
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            height: fit-content;
        }
        
        .invoice-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2, #f093fb);
        }
        
        .invoice-card:hover {
            transform: translateY(-8px) scale(1.02);
            box-shadow: 0 25px 60px rgba(0, 0, 0, 0.15);
        }
        
        .invoice-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
            color: white;
            padding: 20px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: relative;
        }
        
        .invoice-number {
            font-size: 1.1rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .invoice-number::before {
            content: '📋';
            font-size: 1.2rem;
        }
        
        .invoice-status {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            backdrop-filter: blur(10px);
        }
        
        .status-pending {
            background: rgba(255, 255, 255, 0.2);
            color: #fff;
            border: 1px solid rgba(255, 255, 255, 0.3);
        }
        
        .status-paid {
            background: rgba(72, 187, 120, 0.9);
            color: white;
            border: 1px solid rgba(72, 187, 120, 0.5);
        }
        
        .invoice-body {
            padding: 24px;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-bottom: 20px;
        }
        
        .info-item {
            background: linear-gradient(135deg, #f8fafc 0%, #edf2f7 100%);
            padding: 16px;
            border-radius: 12px;
            border-left: 3px solid #667eea;
            transition: all 0.3s ease;
        }
        
        .info-item:hover {
            background: linear-gradient(135deg, #edf2f7 0%, #e2e8f0 100%);
            transform: translateX(3px);
        }
        
        .info-label {
            font-size: 0.8rem;
            color: #718096;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 6px;
        }
        
        .info-value {
            font-size: 0.95rem;
            font-weight: 600;
            color: #2d3748;
            word-break: break-word;
        }
        
        .amount-section {
            background: linear-gradient(135deg, #f0fff4 0%, #e6fffa 100%);
            padding: 20px;
            border-radius: 16px;
            text-align: center;
            margin: 20px 0;
            border: 2px solid #48bb78;
        }
        
        .amount-label {
            font-size: 0.9rem;
            color: #38a169;
            font-weight: 600;
            margin-bottom: 8px;
        }
        
        .amount-value {
            font-size: 1.8rem;
            font-weight: 800;
            color: #38a169;
            letter-spacing: -0.5px;
        }
        
        .invoice-footer {
            border-top: 1px solid #e2e8f0;
            padding: 20px 24px;
            background: rgba(248, 250, 252, 0.8);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
        }
        
        .last-update {
            color: #718096;
            font-size: 0.85rem;
            font-weight: 500;
        }
        
        .action-btn {
            background: linear-gradient(135deg, #ff6b6b, #ee5a24);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 6px;
            min-width: 140px;
            justify-content: center;
        }
        
        .action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(255, 107, 107, 0.4);
        }
        
        /* ✅ THÊM MỚI: Style cho nút In PDF */
        .print-btn {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 6px;
            min-width: 140px;
            justify-content: center;
            margin-left: 10px; /* Khoảng cách với nút Thanh toán */
        }
        
        .print-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
        }
        
        .payment-status {
            color: #48bb78;
            font-weight: 600;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        
        .payment-status.requested {
            color: #ed8936;
        }
        
        .payment-status::before {
            content: '✅';
            font-size: 1rem;
        }
        
        .payment-status.requested::before {
            content: '⏳';
        }
        
        .no-data {
            text-align: center;
            padding: 80px 20px;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .no-data-icon {
            font-size: 5rem;
            margin-bottom: 24px;
            opacity: 0.7;
        }
        
        .no-data-text {
            color: #718096;
            font-size: 1.3rem;
            font-weight: 600;
        }
        
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 12px;
            margin-top: 40px;
            padding: 16px 32px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            text-decoration: none;
            border-radius: 50px;
            font-weight: 700;
            font-size: 1.1rem;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 8px 32px rgba(102, 126, 234, 0.3);
        }
        
        .back-link:hover {
            transform: translateY(-4px);
            box-shadow: 0 16px 48px rgba(102, 126, 234, 0.4);
        }
        
        .back-link::before {
            content: '←';
            font-size: 1.3rem;
        }
        
        /* Responsive Design */
        @media (max-width: 1200px) {
            .invoices-grid {
                grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            }
        }
        
        @media (max-width: 768px) {
            .page-title {
                font-size: 2.2rem;
            }
            
            .invoices-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }
            
            .info-grid {
                grid-template-columns: 1fr;
                gap: 12px;
            }
            
            .invoice-footer {
                flex-direction: column;
                align-items: stretch;
                text-align: center;
            }
            
            .main-container {
                padding: 0 10px;
            }
        }
        
        @media (max-width: 480px) {
            body {
                padding: 10px;
            }
            
            .page-header {
                padding: 30px 15px;
            }
            
            .invoice-body {
                padding: 20px 16px;
            }
            
            .invoice-footer {
                padding: 16px;
            }
            
            /* ✅ THÊM MỚI: Responsive cho nút In PDF trên mobile */
            .print-btn {
                margin-left: 0;
                margin-top: 10px;
                width: 100%;
            }
        }
        
        /* Animations */
        @keyframes slideInUp {
            from {
                opacity: 0;
                transform: translateY(40px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .invoice-card {
            animation: slideInUp 0.6s cubic-bezier(0.4, 0, 0.2, 1) forwards;
        }
        
        .invoice-card:nth-child(1) { animation-delay: 0.1s; }
        .invoice-card:nth-child(2) { animation-delay: 0.2s; }
        .invoice-card:nth-child(3) { animation-delay: 0.3s; }
        .invoice-card:nth-child(4) { animation-delay: 0.4s; }
        .invoice-card:nth-child(5) { animation-delay: 0.5s; }
        .invoice-card:nth-child(6) { animation-delay: 0.6s; }
        
        /* Loading skeleton effect for better UX */
        .invoice-card.loading {
            background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
            background-size: 200% 100%;
            animation: loading 1.5s infinite;
        }
        
        @keyframes loading {
            0% { background-position: 200% 0; }
            100% { background-position: -200% 0; }
        }
        
        /* ✅ THÊM MỚI: CSS cho print mode - ẩn các phần không cần thiết khi in */
        @media print {
            /* Ẩn header, footer, nút quay lại */
            .page-header,
            .back-link,
            .action-btn,
            .print-btn {
                display: none !important;
            }
            
            /* Ẩn background gradient */
            body {
                background: white !important;
                padding: 0 !important;
            }
            
            /* Format lại card hóa đơn cho in */
            .invoice-card {
                break-inside: avoid;
                box-shadow: none !important;
                border: 2px solid #333 !important;
                margin-bottom: 20px !important;
                page-break-inside: avoid;
            }
            
            /* Ẩn hiệu ứng hover */
            .invoice-card:hover {
                transform: none !important;
                box-shadow: none !important;
            }
            
            /* Format header hóa đơn cho in */
            .invoice-header {
                background: #333 !important;
                color: white !important;
                padding: 15px !important;
            }
            
            /* Format body hóa đơn cho in */
            .invoice-body {
                padding: 20px !important;
            }
            
            /* Format footer hóa đơn cho in */
            .invoice-footer {
                border-top: 1px solid #333 !important;
                padding: 15px !important;
                background: #f9f9f9 !important;
            }
            
            /* Thêm tiêu đề cho mỗi trang in */
            .invoice-card::before {
                content: "HÓA ĐƠN KHÁM BỆNH";
                display: block;
                text-align: center;
                font-size: 18px;
                font-weight: bold;
                margin-bottom: 15px;
                color: #333;
            }
        }
    </style>
</head>
<body>
    <div class="main-container">
        <div class="page-header">
            <h1 class="page-title">Hóa đơn của tôi</h1>
            <p class="page-subtitle">Quản lý và theo dõi các hóa đơn khám bệnh một cách dễ dàng</p>
        </div>
        
        <c:choose>
            <c:when test="${empty invoices}">
                <div class="no-data">
                    <div class="no-data-icon">📋</div>
                    <p class="no-data-text">Chưa có hóa đơn nào được tạo</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="invoices-grid">
                    <c:forEach var="invoice" items="${invoices}">
                        <div class="invoice-card">
                            <div class="invoice-header">
                                <div class="invoice-number">Hóa đơn #${invoice.invoiceId}</div>
                                <div class="invoice-status ${invoice.status == 'PENDING' ? 'status-pending' : 'status-paid'}">
                                    ${invoice.status == 'PENDING' ? 'Chờ thanh toán' : 'Đã thanh toán'}
                                </div>
                            </div>
                            
                            <div class="invoice-body">
                                <div class="info-grid">
                                    <div class="info-item">
                                        <div class="info-label">👨‍⚕️ Bác sĩ</div>
                                        <div class="info-value">${invoice.doctorName}</div>
                                    </div>
                                    
                                    <div class="info-item">
                                        <div class="info-label">🏥 Dịch vụ</div>
                                        <div class="info-value">${invoice.serviceName}</div>
                                    </div>
                                    
                                    <div class="info-item">
                                        <div class="info-label">👤 Bệnh nhân</div>
                                        <div class="info-value">${invoice.patientName}</div>
                                    </div>
                                    
                                    <div class="info-item">
                                        <div class="info-label">📅 Ngày khám</div>
                                        <div class="info-value">
                                            <c:choose>
                                                <c:when test="${not empty invoice.appointmentTime}">
                                                    <fmt:formatDate value="${invoice.appointmentTime}" pattern="dd/MM/yyyy"/>
                                                </c:when>
                                                <c:otherwise>
                                                    Chưa xác định
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="amount-section">
                                    <div class="amount-label">Tổng chi phí</div>
                                    <div class="amount-value">
                                        <fmt:formatNumber value="${invoice.totalAmount}" type="currency" currencySymbol=""/>₫
                                    </div>
                                </div>
                            </div>
                            
                            <div class="invoice-footer">
                                <div class="last-update">
                                    <fmt:formatDate value="${invoice.createdAt}" pattern="dd/MM/yyyy"/>
                                </div>
                                
                                <div style="display: flex; align-items: center; gap: 10px; flex-wrap: wrap;">
                                    <!-- ✅ LOGIC CŨ: Nút Thanh toán và trạng thái -->
                                    <c:choose>
                                        <c:when test="${invoice.status == 'PENDING' && !invoice.paymentRequested}">
                                            <form method="post" action="${pageContext.request.contextPath}/PatientInvoiceServlet" style="margin:0;">
                                                <input type="hidden" name="action" value="requestPayment" />
                                                <input type="hidden" name="invoiceId" value="${invoice.invoiceId}" />
                                                <button type="submit" class="action-btn">
                                                    💳 Thanh toán
                                                </button>
                                            </form>
                                        </c:when>
                                        <c:when test="${invoice.status == 'PENDING' && invoice.paymentRequested}">
                                            <span class="payment-status requested">Đang xử lý</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="payment-status">Hoàn thành</span>
                                        </c:otherwise>
                                    </c:choose>
                                    
                                    <!-- ✅ THÊM MỚI: Nút In PDF cho tất cả hóa đơn -->
                                    <button type="button" class="print-btn" 
                                            onclick="printInvoice('${invoice.invoiceId}', '${invoice.doctorName}', '${invoice.serviceName}', '${invoice.patientName}', '${invoice.appointmentTime}', '${invoice.totalAmount}', '${invoice.status}')">
                                        🖨️ In PDF
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
        
        <div style="text-align: center;">
            <a href="${pageContext.request.contextPath}/views/user/Patient/PatientDashBoard.jsp" class="back-link">
                Quay lại Dashboard
            </a>
        </div>
    </div>

    <script>
        // ✅ LOGIC CŨ: Add smooth scrolling and enhanced interactions
        document.addEventListener('DOMContentLoaded', function() {
            // Smooth reveal animation on scroll
            const observerOptions = {
                threshold: 0.1,
                rootMargin: '0px 0px -50px 0px'
            };

            const observer = new IntersectionObserver(function(entries) {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.opacity = '1';
                        entry.target.style.transform = 'translateY(0)';
                    }
                });
            }, observerOptions);

            // Observe all invoice cards
            document.querySelectorAll('.invoice-card').forEach(card => {
                observer.observe(card);
            });

            // Add ripple effect to buttons
            document.querySelectorAll('.action-btn').forEach(button => {
                button.addEventListener('click', function(e) {
                    const ripple = document.createElement('span');
                    const rect = this.getBoundingClientRect();
                    const size = Math.max(rect.width, rect.height);
                    const x = e.clientX - rect.left - size / 2;
                    const y = e.clientY - rect.top - size / 2;
                    
                    ripple.style.width = ripple.style.height = size + 'px';
                    ripple.style.left = x + 'px';
                    ripple.style.top = y + 'px';
                    ripple.classList.add('ripple');
                    
                    this.appendChild(ripple);
                    
                    setTimeout(() => {
                        ripple.remove();
                    }, 600);
                });
            });
        });
        
        // ✅ THÊM MỚI: Function để in hóa đơn PDF
        function printInvoice(invoiceId, doctorName, serviceName, patientName, appointmentTime, totalAmount, status) {
            // Tạo popup window để in
            const printWindow = window.open('', '_blank', 'width=800,height=600');
            
            // Chuyển đổi totalAmount từ string sang number
            const amount = parseFloat(totalAmount);
            
            // Format ngày khám
            let formattedDate = 'Chưa xác định';
            if (appointmentTime && appointmentTime !== 'null') {
                try {
                    const date = new Date(appointmentTime);
                    if (!isNaN(date.getTime())) {
                        formattedDate = date.toLocaleDateString('vi-VN');
                    }
                } catch (e) {
                    console.log('Lỗi format ngày:', e);
                }
            }
            
            // Xác định style cho status
            const statusBgColor = status === 'PAID' ? '#e8f5e8' : '#fff3cd';
            const statusBorderColor = status === 'PAID' ? '#48bb78' : '#ffc107';
            const statusTextColor = status === 'PAID' ? '#38a169' : '#856404';
            const statusText = status === 'PAID' ? '✅ ĐÃ THANH TOÁN' : '⏳ CHỜ THANH TOÁN';
            
            // Format ngày hiện tại
            const currentDate = new Date().toLocaleDateString('vi-VN');
            const currentTime = new Date().toLocaleTimeString('vi-VN');
            
            // Tạo nội dung HTML cho hóa đơn
            const invoiceContent = `
                <!DOCTYPE html>
                <html lang="vi">
                <head>
                    <meta charset="UTF-8">
                    <title>Hóa đơn #${invoiceId}</title>
                    <style>
                        body {
                            font-family: 'Arial', sans-serif;
                            margin: 0;
                            padding: 20px;
                            background: white;
                        }
                        .invoice-container {
                            max-width: 800px;
                            margin: 0 auto;
                            border: 2px solid #333;
                            padding: 30px;
                        }
                        .invoice-header {
                            text-align: center;
                            border-bottom: 2px solid #333;
                            padding-bottom: 20px;
                            margin-bottom: 30px;
                        }
                        .invoice-title {
                            font-size: 24px;
                            font-weight: bold;
                            color: #333;
                            margin-bottom: 10px;
                        }
                        .invoice-number {
                            font-size: 18px;
                            color: #666;
                        }
                        .invoice-info {
                            display: grid;
                            grid-template-columns: 1fr 1fr;
                            gap: 30px;
                            margin-bottom: 30px;
                        }
                        .info-section {
                            border: 1px solid #ddd;
                            padding: 15px;
                            border-radius: 5px;
                        }
                        .info-label {
                            font-weight: bold;
                            color: #333;
                            margin-bottom: 5px;
                        }
                        .info-value {
                            color: #666;
                        }
                        .amount-section {
                            text-align: center;
                            border: 2px solid #48bb78;
                            padding: 20px;
                            border-radius: 10px;
                            background: #f0fff4;
                            margin: 30px 0;
                        }
                        .amount-label {
                            font-size: 16px;
                            color: #38a169;
                            font-weight: bold;
                            margin-bottom: 10px;
                        }
                        .amount-value {
                            font-size: 28px;
                            font-weight: bold;
                            color: #38a169;
                        }
                        .status-section {
                            text-align: center;
                            margin-top: 30px;
                            padding: 15px;
                            background: ${statusBgColor};
                            border: 1px solid ${statusBorderColor};
                            border-radius: 5px;
                        }
                        .status-text {
                            font-weight: bold;
                            color: ${statusTextColor};
                        }
                        .footer {
                            margin-top: 40px;
                            text-align: center;
                            color: #666;
                            font-size: 12px;
                        }
                        @media print {
                            body { margin: 0; }
                            .invoice-container { border: none; }
                        }
                    </style>
                </head>
                <body>
                    <div class="invoice-container">
                        <div class="invoice-header">
                            <div class="invoice-title">HÓA ĐƠN KHÁM BỆNH</div>
                            <div class="invoice-number">Số hóa đơn: #${invoiceId}</div>
                        </div>
                        
                        <div class="invoice-info">
                            <div class="info-section">
                                <div class="info-label">👨‍⚕️ Bác sĩ:</div>
                                <div class="info-value">${doctorName}</div>
                            </div>
                            <div class="info-section">
                                <div class="info-label">🏥 Dịch vụ:</div>
                                <div class="info-value">${serviceName}</div>
                            </div>
                            <div class="info-section">
                                <div class="info-label">👤 Bệnh nhân:</div>
                                <div class="info-value">${patientName}</div>
                            </div>
                            <div class="info-section">
                                <div class="info-label">📅 Ngày khám:</div>
                                <div class="info-value">${formattedDate}</div>
                            </div>
                        </div>
                        
                        <div class="amount-section">
                            <div class="amount-label">TỔNG CHI PHÍ</div>
                            <div class="amount-value">${amount.toLocaleString('vi-VN')} ₫</div>
                        </div>
                        
                        <div class="status-section">
                            <div class="status-text">
                                ${statusText}
                            </div>
                        </div>
                        
                        <div class="footer">
                            <p>Hóa đơn được tạo tự động từ hệ thống quản lý phòng khám</p>
                            <p>Ngày in: ${currentDate} - ${currentTime}</p>
                        </div>
                    </div>
                </body>
                </html>
            `;
            
            // Ghi nội dung vào popup window
            printWindow.document.write(invoiceContent);
            printWindow.document.close();
            
            // Đợi trang load xong rồi in
            printWindow.onload = function() {
                printWindow.print();
                // Đóng popup sau khi in xong (tùy chọn)
                // printWindow.close();
            };
        }
    </script>

    <style>
        .ripple {
            position: absolute;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.6);
            transform: scale(0);
            animation: ripple-animation 0.6s linear;
            pointer-events: none;
        }

        @keyframes ripple-animation {
            to {
                transform: scale(4);
                opacity: 0;
            }
        }
    </style>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Hóa đơn của tôi - Hệ thống Y tế</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                color: #333;
            }

            /* Header */
            .header {
                background: white;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                padding: 15px 0;
                position: sticky;
                top: 0;
                z-index: 1000;
            }

            .header-container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 20px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .logo {
                display: flex;
                align-items: center;
                gap: 12px;
                font-size: 22px;
                font-weight: 700;
                color: #2c3e50;
                text-decoration: none;
            }

            .logo i {
                color: #4CAF50;
                font-size: 28px;
            }

            .btn-homepage {
                display: flex;
                align-items: center;
                gap: 8px;
                padding: 10px 20px;
                background: #4CAF50;
                color: white;
                text-decoration: none;
                border-radius: 6px;
                font-weight: 500;
                transition: background 0.3s ease;
            }

            .btn-homepage:hover {
                background: #45a049;
            }

            /* Main Content */
            .main-content {
                max-width: 1200px;
                margin: 0 auto;
                padding: 30px 20px;
                min-height: calc(100vh - 140px);
            }

            .page-title {
                text-align: center;
                color: white;
                margin-bottom: 30px;
            }

            .page-title h1 {
                font-size: 2.5rem;
                margin-bottom: 10px;
                font-weight: 300;
            }

            .page-title p {
                font-size: 1.1rem;
                opacity: 0.9;
            }

            /* Statistics Dashboard */
            .stats-container {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 20px;
                margin-bottom: 40px;
            }

            .stat-card {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                border-radius: 15px;
                padding: 25px;
                text-align: center;
                box-shadow: 0 8px 32px rgba(0,0,0,0.1);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .stat-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 15px 40px rgba(0,0,0,0.15);
            }

            .stat-icon {
                font-size: 3rem;
                margin-bottom: 15px;
            }

            .stat-number {
                font-size: 2.5rem;
                font-weight: bold;
                margin-bottom: 10px;
            }

            .stat-label {
                font-size: 1rem;
                color: #666;
                text-transform: uppercase;
                letter-spacing: 1px;
            }

            .stat-total {
                color: #2196F3;
            }
            .stat-paid {
                color: #4CAF50;
            }
            .stat-pending {
                color: #FF9800;
            }
            .stat-amount {
                color: #9C27B0;
            }

            /* Filter Tabs */
            .filter-tabs {
                display: flex;
                justify-content: center;
                gap: 10px;
                margin-bottom: 30px;
                flex-wrap: wrap;
            }

            .filter-tab {
                padding: 12px 24px;
                background: rgba(255, 255, 255, 0.2);
                color: white;
                border: 2px solid rgba(255, 255, 255, 0.3);
                border-radius: 25px;
                cursor: pointer;
                transition: all 0.3s ease;
                font-weight: 500;
            }

            .filter-tab.active,
            .filter-tab:hover {
                background: rgba(255, 255, 255, 0.95);
                color: #333;
                border-color: rgba(255, 255, 255, 0.95);
                box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            }

            /* Invoice Cards */
            .invoice-container {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
                gap: 20px;
            }

            .invoice-card {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 8px 32px rgba(0,0,0,0.1);
                transition: all 0.3s ease;
                border-left: 5px solid;
            }

            .invoice-card.status-paid {
                border-left-color: #4CAF50;
            }
            .invoice-card.status-pending {
                border-left-color: #FF9800;
            }
            .invoice-card.status-cancelled {
                border-left-color: #f44336;
            }

            .invoice-card:hover {
                transform: translateY(-3px);
                box-shadow: 0 15px 40px rgba(0,0,0,0.15);
            }

            .invoice-header {
                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                padding: 20px 25px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .invoice-id {
                font-size: 1.3rem;
                font-weight: bold;
                color: #333;
            }

            .invoice-status {
                padding: 8px 16px;
                border-radius: 20px;
                font-weight: bold;
                text-transform: uppercase;
                font-size: 11px;
                letter-spacing: 1px;
            }

            .status-pending {
                background: #fff3e0;
                color: #e65100;
                border: 2px solid #ffcc02;
            }

            .status-paid {
                background: #e8f5e8;
                color: #2e7d32;
                border: 2px solid #4CAF50;
            }

            .status-cancelled {
                background: #ffebee;
                color: #c62828;
                border: 2px solid #f44336;
            }

            .invoice-body {
                padding: 25px;
            }

            .invoice-details {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 20px;
                margin-bottom: 25px;
            }

            .detail-item {
                display: flex;
                flex-direction: column;
                gap: 8px;
            }

            .detail-label {
                font-weight: 600;
                color: #666;
                font-size: 0.9rem;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .detail-value {
                color: #333;
                font-size: 1rem;
                font-weight: 500;
            }

            .total-amount {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 20px;
                border-radius: 10px;
                text-align: center;
                margin: 20px 0;
            }

            .total-label {
                font-size: 0.9rem;
                opacity: 0.9;
                margin-bottom: 8px;
            }

            .total-value {
                font-size: 2rem;
                font-weight: bold;
            }

            .invoice-actions {
                display: flex;
                justify-content: flex-end;
                gap: 15px;
                padding-top: 20px;
                border-top: 1px solid #eee;
            }

            .btn {
                padding: 12px 24px;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-size: 0.9rem;
                font-weight: 600;
                transition: all 0.3s ease;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .btn-payment {
                background: linear-gradient(45deg, #FF9800, #F57C00);
                color: white;
                box-shadow: 0 4px 15px rgba(255,152,0,0.3);
            }

            .btn-payment:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(255,152,0,0.4);
            }

            .btn-print {
                background: linear-gradient(45deg, #2196F3, #1976D2);
                color: white;
                box-shadow: 0 4px 15px rgba(33,150,243,0.3);
            }

            .btn-print:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(33,150,243,0.4);
            }

            .payment-requested {
                color: #4CAF50;
                font-weight: bold;
                padding: 12px 24px;
                background: rgba(76, 175, 80, 0.1);
                border-radius: 8px;
                border: 2px solid rgba(76, 175, 80, 0.3);
            }

            .no-data {
                text-align: center;
                padding: 60px 20px;
                background: rgba(255, 255, 255, 0.95);
                border-radius: 15px;
                box-shadow: 0 8px 32px rgba(0,0,0,0.1);
            }

            .no-data i {
                font-size: 4rem;
                color: #ccc;
                margin-bottom: 20px;
            }

            /* Footer */
            .footer {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                padding: 40px 0 20px;
                margin-top: 50px;
            }

            .footer-container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 20px;
            }

            .footer-content {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 30px;
                margin-bottom: 30px;
            }

            .footer-section h3 {
                color: #333;
                margin-bottom: 15px;
                font-size: 1.2rem;
            }

            .footer-section p,
            .footer-section a {
                color: #666;
                line-height: 1.6;
                text-decoration: none;
            }

            .footer-section a:hover {
                color: #4CAF50;
            }

            .footer-bottom {
                text-align: center;
                padding-top: 20px;
                border-top: 1px solid #eee;
                color: #666;
            }

            /* Responsive */
            @media (max-width: 1200px) {
                .invoice-container {
                    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                }
            }

            @media (max-width: 768px) {
                .header-container {
                    padding: 0 15px;
                }
                
                .logo {
                    font-size: 18px;
                }
                
                .logo i {
                    font-size: 22px;
                }
                
                .btn-homepage {
                    padding: 8px 16px;
                    font-size: 14px;
                }

                .page-title h1 {
                    font-size: 2rem;
                }

                .stats-container {
                    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                }

                .invoice-container {
                    grid-template-columns: 1fr;
                }

                .invoice-header {
                    flex-direction: column;
                    gap: 15px;
                    text-align: center;
                }

                .invoice-details {
                    grid-template-columns: 1fr;
                }

                .invoice-actions {
                    flex-direction: column;
                }
            }

            /* Animation Keyframes */
            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            @keyframes slideInFromTop {
                from {
                    opacity: 0;
                    transform: translateY(-20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .header {
                animation: slideInFromTop 0.6s ease-out;
            }

            .invoice-card {
                animation: fadeInUp 0.6s ease forwards;
            }

            .invoice-card:nth-child(even) {
                animation-delay: 0.1s;
            }

            /* Loading Animation */
            .loading {
                display: inline-block;
                width: 20px;
                height: 20px;
                border: 3px solid rgba(76, 175, 80, 0.3);
                border-radius: 50%;
                border-top-color: #4CAF50;
                animation: spin 1s ease-in-out infinite;
            }

            @keyframes spin {
                to { transform: rotate(360deg); }
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <header class="header">
            <div class="header-container">
                <div class="logo">
                    <i class="fas fa-hospital"></i>
                    <span>Phòng khám nha khoa</span>
                </div>
                <a href="${pageContext.request.contextPath}/views/user/Patient/PatientDashBoard.jsp" class="btn-homepage">
                    <i class="fas fa-home"></i> Trang chủ
                </a>
            </div>
        </header>

        <!-- Main Content -->
        <main class="main-content">
            <div class="page-title">
                <h1><i class="fas fa-file-invoice-dollar"></i> Hóa đơn của tôi</h1>
                <p>Quản lý và theo dõi tất cả hóa đơn khám chữa bệnh</p>
            </div>

            <c:choose>
                <c:when test="${empty invoices}">
                    <div class="no-data">
                        <i class="fas fa-inbox"></i>
                        <h3>Chưa có hóa đơn nào</h3>
                        <p>Bạn chưa có hóa đơn nào trong hệ thống. Hãy đặt lịch khám để tạo hóa đơn.</p>
                        <a href="${pageContext.request.contextPath}/views/user/Patient/PatientDashBoard.jsp" class="btn btn-view" style="margin-top: 20px; display: inline-block; text-decoration: none;">
                            <i class="fas fa-plus"></i> Đặt lịch khám
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Statistics Dashboard -->
                    <div class="stats-container">
                        <c:set var="totalInvoices" value="0" />
                        <c:set var="paidInvoices" value="0" />
                        <c:set var="pendingInvoices" value="0" />
                        <c:set var="totalAmount" value="0" />

                        <c:forEach var="invoice" items="${invoices}">
                            <c:set var="totalInvoices" value="${totalInvoices + 1}" />
                            <c:set var="totalAmount" value="${totalAmount + invoice.totalAmount}" />
                            <c:if test="${invoice.status == 'PAID'}">
                                <c:set var="paidInvoices" value="${paidInvoices + 1}" />
                            </c:if>
                            <c:if test="${invoice.status == 'PENDING'}">
                                <c:set var="pendingInvoices" value="${pendingInvoices + 1}" />
                            </c:if>
                        </c:forEach>

                        <div class="stat-card">
                            <div class="stat-icon stat-total">
                                <i class="fas fa-file-invoice"></i>
                            </div>
                            <div class="stat-number stat-total">${totalInvoices}</div>
                            <div class="stat-label">Tổng hóa đơn</div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-icon stat-paid">
                                <i class="fas fa-check-circle"></i>
                            </div>
                            <div class="stat-number stat-paid">${paidInvoices}</div>
                            <div class="stat-label">Đã thanh toán</div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-icon stat-pending">
                                <i class="fas fa-clock"></i>
                            </div>
                            <div class="stat-number stat-pending">${pendingInvoices}</div>
                            <div class="stat-label">Chờ thanh toán</div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-icon stat-amount">
                                <i class="fas fa-money-bill-wave"></i>
                            </div>
                            <div class="stat-number stat-amount">
                                <fmt:formatNumber value="${totalAmount}" pattern="#,###"/>₫
                            </div>
                            <div class="stat-label">Tổng chi phí</div>
                        </div>
                    </div>

                    <!-- Filter Tabs -->
                    <div class="filter-tabs">
                        <div class="filter-tab active" onclick="filterInvoices('all')">
                            <i class="fas fa-list"></i> Tất cả
                        </div>
                        <div class="filter-tab" onclick="filterInvoices('paid')">
                            <i class="fas fa-check"></i> Đã thanh toán
                        </div>
                        <div class="filter-tab" onclick="filterInvoices('pending')">
                            <i class="fas fa-clock"></i> Chờ thanh toán
                        </div>
                    </div>

                    <!-- Invoice Cards -->
                    <div class="invoice-container">
                        <c:forEach var="invoice" items="${invoices}">
                            <div class="invoice-card status-${invoice.status.toLowerCase()}" data-status="${invoice.status}">
                                <div class="invoice-header">
                                    <div class="invoice-id">
                                        <i class="fas fa-hashtag"></i> ${invoice.invoiceId}
                                    </div>
                                    <div class="invoice-status status-${invoice.status.toLowerCase()}">
                                        <c:choose>
                                            <c:when test="${invoice.status == 'PAID'}">
                                                <i class="fas fa-check-circle"></i> Đã thanh toán
                                            </c:when>
                                            <c:when test="${invoice.status == 'PENDING'}">
                                                <i class="fas fa-clock"></i> Chờ thanh toán
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fas fa-times-circle"></i> Đã hủy
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <div class="invoice-body">
                                    <div class="invoice-details">
                                        <div class="detail-item">
                                            <div class="detail-label">
                                                <i class="fas fa-user-md"></i> Bác sĩ
                                            </div>
                                            <div class="detail-value">${invoice.doctorName}</div>
                                        </div>

                                        <div class="detail-item">
                                            <div class="detail-label">
                                                <i class="fas fa-stethoscope"></i> Dịch vụ
                                            </div>
                                            <div class="detail-value">${invoice.serviceName}</div>
                                        </div>

                                        <div class="detail-item">
                                            <div class="detail-label">
                                                <i class="fas fa-user"></i> Bệnh nhân
                                            </div>
                                            <div class="detail-value">${invoice.patientName}</div>
                                        </div>

                                        <div class="detail-item">
                                            <div class="detail-label">
                                                <i class="fas fa-calendar-plus"></i> Ngày tạo
                                            </div>
                                            <div class="detail-value">
                                                <fmt:formatDate value="${invoice.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </div>
                                        </div>

                                        <div class="detail-item">
                                            <div class="detail-label">
                                                <i class="fas fa-calendar-check"></i> Ngày khám
                                            </div>
                                            <div class="detail-value">
                                                <c:choose>
                                                    <c:when test="${not empty invoice.appointmentTime}">
                                                        <fmt:formatDate value="${invoice.appointmentTime}" pattern="dd/MM/yyyy HH:mm"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: #999; font-style: italic;">Chưa xác định</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="total-amount">
                                        <div class="total-label">
                                            <i class="fas fa-money-bill-wave"></i> Tổng tiền
                                        </div>
                                        <div class="total-value">
                                            <fmt:formatNumber value="${invoice.totalAmount}" type="currency" currencySymbol="VNĐ"/>
                                        </div>
                                    </div>

                                    <div class="invoice-actions">
                                        <c:choose>
                                            <c:when test="${invoice.status == 'PENDING' && !invoice.paymentRequested}">
                                                <button class="btn btn-print" onclick="printInvoicePDF('${invoice.invoiceId}', '${invoice.doctorName}', '${invoice.serviceName}', '${invoice.patientName}', '${invoice.totalAmount}', '<fmt:formatDate value="${invoice.createdAt}" pattern="dd/MM/yyyy HH:mm"/>', '<c:choose><c:when test="${not empty invoice.appointmentTime}"><fmt:formatDate value="${invoice.appointmentTime}" pattern="dd/MM/yyyy HH:mm"/></c:when><c:otherwise>Chưa xác định</c:otherwise></c:choose>')">
                                                    <i class="fas fa-file-pdf"></i> In PDF
                                                </button>
                                                <form method="post" action="${pageContext.request.contextPath}/PatientInvoiceServlet" style="margin:0;">
                                                    <input type="hidden" name="action" value="requestPayment" />
                                                    <input type="hidden" name="invoiceId" value="${invoice.invoiceId}" />
                                                    <button type="submit" class="btn btn-payment">
                                                        <i class="fas fa-credit-card"></i> Yêu cầu thanh toán
                                                    </button>
                                                </form>
                                            </c:when>
                                            <c:when test="${invoice.status == 'PENDING' && invoice.paymentRequested}">
                                                <button class="btn btn-print" onclick="printInvoicePDF('${invoice.invoiceId}', '${invoice.doctorName}', '${invoice.serviceName}', '${invoice.patientName}', '${invoice.totalAmount}', '<fmt:formatDate value="${invoice.createdAt}" pattern="dd/MM/yyyy HH:mm"/>', '<c:choose><c:when test="${not empty invoice.appointmentTime}"><fmt:formatDate value="${invoice.appointmentTime}" pattern="dd/MM/yyyy HH:mm"/></c:when><c:otherwise>Chưa xác định</c:otherwise></c:choose>')">
                                                    <i class="fas fa-file-pdf"></i> In PDF
                                                </button>
                                                <div class="payment-requested">
                                                    <i class="fas fa-hourglass-half"></i> Đang chờ xử lý thanh toán
                                                </div>
                                            </c:when>
                                            <c:when test="${invoice.status == 'PAID'}">
                                                <button class="btn btn-print" onclick="printInvoicePDF('${invoice.invoiceId}', '${invoice.doctorName}', '${invoice.serviceName}', '${invoice.patientName}', '${invoice.totalAmount}', '<fmt:formatDate value="${invoice.createdAt}" pattern="dd/MM/yyyy HH:mm"/>', '<c:choose><c:when test="${not empty invoice.appointmentTime}"><fmt:formatDate value="${invoice.appointmentTime}" pattern="dd/MM/yyyy HH:mm"/></c:when><c:otherwise>Chưa xác định</c:otherwise></c:choose>')">
                                                    <i class="fas fa-file-pdf"></i> In PDF
                                                </button>
                                                <div style="color: #4CAF50; font-weight: bold; padding: 12px 0;">
                                                    <i class="fas fa-check-circle"></i> Đã hoàn thành thanh toán
                                                </div>
                                            </c:when>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </main>

        <!-- Footer -->
        <footer class="footer">
            <div class="footer-container">
                <div class="footer-content">
                    <div class="footer-section">
                        <h3><i class="fas fa-hospital"></i> Phòng khám nha khoa</h3>
                        <p>Cung cấp dịch vụ chăm sóc sức khỏe toàn diện và chuyên nghiệp. Chúng tôi cam kết mang đến sự chăm sóc tốt nhất cho sức khỏe của bạn.</p>
                    </div>
                    <div class="footer-section">
                        <h3><i class="fas fa-phone"></i> Liên hệ</h3>
                        <p><i class="fas fa-map-marker-alt"></i> 123 Đường ABC, Quận XYZ, TP.HCM</p>
                        <p><i class="fas fa-phone"></i> Hotline: 1900-123-456</p>
                        <p><i class="fas fa-envelope"></i> Email: support@hethongytecom</p>
                    </div>
                    <div class="footer-section">
                        <h3><i class="fas fa-clock"></i> Giờ làm việc</h3>
                        <p><i class="fas fa-calendar-day"></i> Thứ 2 - Thứ 6: 8:00 - 17:00</p>
                        <p><i class="fas fa-calendar-week"></i> Thứ 7: 8:00 - 12:00</p>
                        <p><i class="fas fa-calendar"></i> Chủ nhật: Nghỉ</p>
                    </div>
                    <div class="footer-section">
                        <h3><i class="fas fa-link"></i> Liên kết nhanh</h3>
                        <p><a href="${pageContext.request.contextPath}/views/user/Patient/PatientDashBoard.jsp"><i class="fas fa-home"></i> Trang chủ</a></p>
                        <p><a href="#"><i class="fas fa-calendar-alt"></i> Đặt lịch khám</a></p>
                        <p><a href="#"><i class="fas fa-user"></i> Thông tin cá nhân</a></p>
                        <p><a href="#"><i class="fas fa-history"></i> Lịch sử khám bệnh</a></p>
                    </div>
                </div>
                <div class="footer-bottom">
                    <p>&copy; 2024 Hệ thống Y tế. Tất cả quyền được bảo lưu. </p>
                </div>
            </div>
        </footer>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
        <script>
            // Filter functionality
            function filterInvoices(status) {
                const cards = document.querySelectorAll('.invoice-card');
                const tabs = document.querySelectorAll('.filter-tab');

                // Update active tab
                tabs.forEach(tab => tab.classList.remove('active'));
                event.target.closest('.filter-tab').classList.add('active');

                // Filter cards
                cards.forEach(card => {
                    if (status === 'all') {
                        card.style.display = 'block';
                    } else {
                        const cardStatus = card.getAttribute('data-status').toLowerCase();
                        card.style.display = cardStatus === status ? 'block' : 'none';
                    }
                });
            }

            // Print Invoice to PDF
            function printInvoicePDF(invoiceId, doctorName, serviceName, patientName, totalAmount, createdAt, appointmentTime) {
                const {jsPDF} = window.jspdf;

                // Create canvas for Vietnamese text rendering
                const canvas = document.createElement('canvas');
                canvas.width = 800;
                canvas.height = 1000;
                const ctx = canvas.getContext('2d');

                // White background
                ctx.fillStyle = '#ffffff';
                ctx.fillRect(0, 0, canvas.width, canvas.height);

                // Header
                ctx.fillStyle = '#4CAF50';
                ctx.font = 'bold 32px Arial, sans-serif';
                ctx.textAlign = 'center';
                ctx.fillText('PHÒNG KHÁM NHA KHOA', canvas.width / 2, 60);

                ctx.fillStyle = '#000000';
                ctx.font = '24px Arial, sans-serif';
                ctx.fillText('HÓA ĐƠN', canvas.width / 2, 100);

                // Line separator
                ctx.strokeStyle = '#000000';
                ctx.lineWidth = 2;
                ctx.beginPath();
                ctx.moveTo(50, 120);
                ctx.lineTo(750, 120);
                ctx.stroke();

                // Details
                ctx.textAlign = 'left';
                ctx.font = '18px Arial, sans-serif';
                ctx.fillStyle = '#000000';

                // Format amount
                const formattedAmount = new Intl.NumberFormat('vi-VN').format(totalAmount) + ' VND';

                const details = [
                    ['Số hóa đơn:', '#' + invoiceId],
                    ['Bệnh nhân:', patientName],
                    ['Bác sĩ:', doctorName],
                    ['Dịch vụ:', serviceName],
                    ['Ngày tạo:', createdAt],
                    ['Ngày khám:', appointmentTime],
                    ['Tổng tiền:', formattedAmount]
                ];

                let y = 180;
                details.forEach((detail) => {
                    ctx.font = 'bold 18px Arial, sans-serif';
                    ctx.fillText(detail[0], 60, y);
                    ctx.font = '18px Arial, sans-serif';
                    ctx.fillText(detail[1], 200, y);
                    y += 35;
                });

                // Contact info box
                ctx.strokeStyle = '#cccccc';
                ctx.lineWidth = 2;
                ctx.strokeRect(50, y + 200, 700, 120);

                ctx.fillStyle = '#000000';
                ctx.font = 'bold 18px Arial, sans-serif';
                ctx.textAlign = 'left';
                ctx.fillText('THÔNG TIN LIÊN HỆ', 70, y + 230);

                ctx.font = '16px Arial, sans-serif';
                ctx.fillText('Địa chỉ: 123 Đường ABC, Quận XYZ, TP.HCM', 70, y + 260);
                ctx.fillText('Điện thoại: 1900-123-456', 70, y + 285);
                ctx.fillText('Email: support@hethongytecom', 70, y + 310);

                // Convert canvas to image
                const imgData = canvas.toDataURL('image/png');

                // Create PDF and add image
                const doc = new jsPDF();

                // Calculate dimensions to fit A4
                const pdfWidth = doc.internal.pageSize.getWidth();
                const pdfHeight = doc.internal.pageSize.getHeight();
                const imgWidth = pdfWidth;
                const imgHeight = (canvas.height * pdfWidth) / canvas.width;

                // If image is too tall, scale it down
                if (imgHeight > pdfHeight) {
                    const ratio = pdfHeight / imgHeight;
                    doc.addImage(imgData, 'PNG', 0, 0, imgWidth * ratio, pdfHeight);
                } else {
                    doc.addImage(imgData, 'PNG', 0, 0, imgWidth, imgHeight);
                }

                // Save the PDF
                doc.save('Hoa_don_' + invoiceId + '.pdf');
            }

                // Add some interactive effects
                document.addEventListener('DOMContentLoaded', function () {
                    // Animate stats on scroll
                    const statCards = document.querySelectorAll('.stat-card');
                    const observer = new IntersectionObserver((entries) => {
                        entries.forEach(entry => {
                            if (entry.isIntersecting) {
                                entry.target.style.animation = 'fadeInUp 0.6s ease forwards';
                            }
                        });
                    });

                    statCards.forEach(card => {
                        observer.observe(card);
                    });
                });
        </script>
    </body>
</html>
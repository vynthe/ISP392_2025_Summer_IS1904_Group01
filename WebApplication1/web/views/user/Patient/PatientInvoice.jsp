<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hóa đơn của tôi</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #2563eb;
            --primary-light: #3b82f6;
            --primary-dark: #1d4ed8;
            --success: #059669;
            --warning: #d97706;
            --danger: #dc2626;
            --gray-50: #f9fafb;
            --gray-100: #f3f4f6;
            --gray-200: #e5e7eb;
            --gray-600: #4b5563;
            --gray-700: #374151;
            --gray-900: #111827;
            --white: #ffffff;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
            min-height: 100vh;
            color: var(--gray-900);
            line-height: 1.6;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 2rem 1rem;
        }

        /* Header */
        .page-header {
            text-align: center;
            margin-bottom: 3rem;
        }

        .page-title {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 1rem;
        }

        .page-title i {
            color: var(--primary);
        }

        .page-subtitle {
            font-size: 1.125rem;
            color: var(--gray-600);
            font-weight: 400;
        }

        /* Stats Section */
        .stats-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 3rem;
        }

        .stat-card {
            background: var(--white);
            border-radius: 1rem;
            padding: 1.5rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            border: 1px solid var(--gray-200);
            transition: all 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .stat-content {
            display: flex;
            items-center;
            gap: 1rem;
        }

        .stat-icon {
            width: 3rem;
            height: 3rem;
            border-radius: 0.75rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            color: var(--white);
        }

        .stat-icon.total { background: var(--primary); }
        .stat-icon.pending { background: var(--warning); }
        .stat-icon.paid { background: var(--success); }

        .stat-info h3 {
            font-size: 2rem;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: 0.25rem;
        }

        .stat-info p {
            color: var(--gray-600);
            font-weight: 500;
        }

        /* Invoice Grid */
        .invoices-section {
            margin-bottom: 3rem;
        }

        .invoices-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 2rem;
        }

        .invoice-card {
            background: var(--white);
            border-radius: 1rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            border: 1px solid var(--gray-200);
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .invoice-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }

        /* Card Header */
        .invoice-header {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-light) 100%);
            color: var(--white);
            padding: 1.5rem;
            position: relative;
        }

        .invoice-number {
            font-size: 1.25rem;
            font-weight: 700;
            margin-bottom: 0.75rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            border-radius: 9999px;
            font-size: 0.875rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.025em;
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
        }

        /* Card Body */
        .invoice-body {
            padding: 1.5rem;
        }

        .invoice-details {
            display: grid;
            gap: 1rem;
        }

        .detail-row {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem;
            background: var(--gray-50);
            border-radius: 0.75rem;
            transition: all 0.2s ease;
        }

        .detail-row:hover {
            background: var(--gray-100);
        }

        .detail-icon {
            width: 2.5rem;
            height: 2.5rem;
            border-radius: 0.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--white);
            font-size: 1rem;
            flex-shrink: 0;
        }

        .detail-icon.doctor { background: var(--primary); }
        .detail-icon.service { background: var(--success); }
        .detail-icon.patient { background: var(--warning); }
        .detail-icon.date { background: #8b5cf6; }
        .detail-icon.amount { background: var(--danger); }

        .detail-content {
            flex: 1;
        }

        .detail-label {
            font-size: 0.875rem;
            color: var(--gray-600);
            font-weight: 500;
            margin-bottom: 0.25rem;
        }

        .detail-value {
            font-size: 1rem;
            color: var(--gray-900);
            font-weight: 600;
            line-height: 1.4;
        }

        .amount-value {
            font-size: 1.25rem;
            color: var(--primary);
            font-weight: 700;
        }

        /* Card Footer */
        .invoice-footer {
            padding: 0 1.5rem 1.5rem;
        }

        .action-button {
            width: 100%;
            padding: 0.875rem 1.5rem;
            border: none;
            border-radius: 0.75rem;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .payment-button {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-light) 100%);
            color: var(--white);
            box-shadow: 0 4px 14px rgba(37, 99, 235, 0.3);
        }

        .payment-button:hover {
            background: linear-gradient(135deg, var(--primary-dark) 0%, var(--primary) 100%);
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(37, 99, 235, 0.4);
        }

        .payment-requested {
            background: rgba(5, 150, 105, 0.1);
            color: var(--success);
            border: 1px solid rgba(5, 150, 105, 0.2);
        }

        /* No Data State */
        .no-invoices {
            text-align: center;
            background: var(--white);
            padding: 4rem 2rem;
            border-radius: 1rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            border: 1px solid var(--gray-200);
        }

        .no-invoices-icon {
            font-size: 4rem;
            color: var(--gray-600);
            margin-bottom: 1.5rem;
        }

        .no-invoices h3 {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--gray-900);
            margin-bottom: 0.75rem;
        }

        .no-invoices p {
            color: var(--gray-600);
            font-size: 1rem;
            max-width: 500px;
            margin: 0 auto;
        }

        /* Back Link */
        .back-section {
            text-align: center;
            margin-top: 3rem;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.875rem 2rem;
            background: var(--white);
            color: var(--primary);
            text-decoration: none;
            border-radius: 9999px;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.3s ease;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            border: 1px solid var(--gray-200);
        }

        .back-link:hover {
            background: var(--primary);
            color: var(--white);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }
            
            .page-title {
                font-size: 2rem;
                flex-direction: column;
                gap: 0.5rem;
            }
            
            .stats-section {
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 1rem;
            }
            
            .invoices-grid {
                grid-template-columns: 1fr;
                gap: 1.5rem;
            }
            
            .stat-content {
                flex-direction: column;
                text-align: center;
                gap: 0.75rem;
            }
        }

        /* Animation */
        .invoice-card {
            animation: fadeInUp 0.6s ease forwards;
            opacity: 0;
            transform: translateY(20px);
        }

        .invoice-card:nth-child(1) { animation-delay: 0.1s; }
        .invoice-card:nth-child(2) { animation-delay: 0.2s; }
        .invoice-card:nth-child(3) { animation-delay: 0.3s; }
        .invoice-card:nth-child(4) { animation-delay: 0.4s; }

        @keyframes fadeInUp {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Page Header -->
        <div class="page-header">
            <h1 class="page-title">
                <i class="fas fa-file-invoice-dollar"></i>
                Hóa đơn của tôi
            </h1>
            <p class="page-subtitle">Quản lý và theo dõi các hóa đơn khám bệnh của bạn</p>
        </div>

        <!-- Statistics Section -->
        <div class="stats-section">
            <div class="stat-card">
                <div class="stat-content">
                    <div class="stat-icon total">
                        <i class="fas fa-file-invoice"></i>
                    </div>
                    <div class="stat-info">
                        <h3>${invoices.size()}</h3>
                        <p>Tổng hóa đơn</p>
                    </div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-content">
                    <div class="stat-icon pending">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="stat-info">
                        <h3>
                            <c:set var="pendingCount" value="0"/>
                            <c:forEach var="invoice" items="${invoices}">
                                <c:if test='${invoice.status == "PENDING"}'>
                                    <c:set var="pendingCount" value="${pendingCount + 1}"/>
                                </c:if>
                            </c:forEach>
                            ${pendingCount}
                        </h3>
                        <p>Chờ thanh toán</p>
                    </div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-content">
                    <div class="stat-icon paid">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="stat-info">
                        <h3>
                            <c:set var="paidCount" value="0"/>
                            <c:forEach var="invoice" items="${invoices}">
                                <c:if test='${invoice.status == "PAID"}'>
                                    <c:set var="paidCount" value="${paidCount + 1}"/>
                                </c:if>
                            </c:forEach>
                            ${paidCount}
                        </h3>
                        <p>Đã thanh toán</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Invoices Section -->
        <div class="invoices-section">
            <c:choose>
                <c:when test="${empty invoices}">
                    <div class="no-invoices">
                        <div class="no-invoices-icon">
                            <i class="fas fa-file-invoice"></i>
                        </div>
                        <h3>Chưa có hóa đơn nào</h3>
                        <p>Bạn chưa có hóa đơn khám bệnh nào. Hãy đặt lịch khám để tạo hóa đơn mới và theo dõi chi phí điều trị của bạn.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="invoices-grid">
                        <c:forEach var="invoice" items="${invoices}">
                            <div class="invoice-card">
                                <!-- Header -->
                                <div class="invoice-header">
                                    <div class="invoice-number">
                                        <i class="fas fa-receipt"></i>
                                        Hóa đơn #${invoice.invoiceId}
                                    </div>
                                    <div class="status-badge">
                                        <i class="fas fa-
                                            <c:choose>
                                                <c:when test='${invoice.status == "PENDING"}'>clock</c:when>
                                                <c:when test='${invoice.status == "PAID"}'>check</c:when>
                                                <c:otherwise>times</c:otherwise>
                                            </c:choose>
                                        "></i>
                                        <c:choose>
                                            <c:when test='${invoice.status == "PENDING"}'>Chờ thanh toán</c:when>
                                            <c:when test='${invoice.status == "PAID"}'>Đã thanh toán</c:when>
                                            <c:otherwise>Đã hủy</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <!-- Body -->
                                <div class="invoice-body">
                                    <div class="invoice-details">
                                        <div class="detail-row">
                                            <div class="detail-icon doctor">
                                                <i class="fas fa-user-md"></i>
                                            </div>
                                            <div class="detail-content">
                                                <div class="detail-label">Bác sĩ khám</div>
                                                <div class="detail-value">${invoice.doctorName}</div>
                                            </div>
                                        </div>

                                        <div class="detail-row">
                                            <div class="detail-icon service">
                                                <i class="fas fa-stethoscope"></i>
                                            </div>
                                            <div class="detail-content">
                                                <div class="detail-label">Dịch vụ khám</div>
                                                <div class="detail-value">${invoice.serviceName}</div>
                                            </div>
                                        </div>

                                        <div class="detail-row">
                                            <div class="detail-icon patient">
                                                <i class="fas fa-user"></i>
                                            </div>
                                            <div class="detail-content">
                                                <div class="detail-label">Bệnh nhân</div>
                                                <div class="detail-value">${invoice.patientName}</div>
                                            </div>
                                        </div>

                                        <div class="detail-row">
                                            <div class="detail-icon date">
                                                <i class="fas fa-calendar-alt"></i>
                                            </div>
                                            <div class="detail-content">
                                                <div class="detail-label">Ngày & Giờ khám</div>
                                                <div class="detail-value">
                                                    <c:choose>
                                                        <c:when test="${not empty invoice.appointmentTime}">
                                                            <fmt:formatDate value="${invoice.appointmentTime}" pattern="dd/MM/yyyy 'lúc' HH:mm"/>
                                                        </c:when>
                                                        <c:otherwise>Chưa xác định</c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="detail-row">
                                            <div class="detail-icon amount">
                                                <i class="fas fa-money-bill-wave"></i>
                                            </div>
                                            <div class="detail-content">
                                                <div class="detail-label">Tổng chi phí</div>
                                                <div class="detail-value amount-value">
                                                    <fmt:formatNumber value="${invoice.totalAmount}" pattern="#,###"/> VNĐ
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Footer -->
                                <c:if test='${invoice.status == "PENDING"}'>
                                    <div class="invoice-footer">
                                        <c:choose>
                                            <c:when test="${!invoice.paymentRequested}">
                                                <form method="post" action="${pageContext.request.contextPath}/PatientInvoiceServlet" style="margin:0;">
                                                    <input type="hidden" name="action" value="requestPayment" />
                                                    <input type="hidden" name="invoiceId" value="${invoice.invoiceId}" />
                                                    <button type="submit" class="action-button payment-button">
                                                        <i class="fas fa-credit-card"></i>
                                                        Thanh toán ngay
                                                    </button>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="action-button payment-requested">
                                                    <i class="fas fa-check-circle"></i>
                                                    Đã yêu cầu thanh toán
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Back Section -->
        <div class="back-section">
            <a href="${pageContext.request.contextPath}/views/user/Patient/PatientDashBoard.jsp" class="back-link">
                <i class="fas fa-arrow-left"></i>
                Quay lại Bảng điều khiển
            </a>
        </div>
    </div>
</body>
</html>
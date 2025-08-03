<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả khám nha khoa - Phòng khám Nha khoa DentalCare</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #1565C0;
            --secondary-color: #2196F3;
            --accent-color: #42A5F5;
            --light-blue: #E3F2FD;
            --text-dark: #1A237E;
            --text-muted: #546E7A;
            --success-color: #1976D2;
            --warning-color: #FF8F00;
            --danger-color: #E53E3E;
            --white: #FFFFFF;
            --light-gray: #F8F9FA;
        }

        body {
            background: linear-gradient(135deg, #E3F2FD 0%, #BBDEFB 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: var(--text-dark);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .main-content {
            flex: 1;
        }

        .navbar {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%) !important;
            box-shadow: 0 4px 20px rgba(21, 101, 192, 0.3);
            border-bottom: 3px solid var(--accent-color);
        }

        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
            color: white !important;
        }

        .dental-icon {
            color: #FFD54F;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }

        .page-header {
            background: linear-gradient(135deg, var(--white) 0%, var(--light-blue) 100%);
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 8px 30px rgba(21, 101, 192, 0.1);
            border: 2px solid rgba(21, 101, 192, 0.1);
        }

        .page-title {
            color: var(--primary-color);
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .result-card {
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            border: 2px solid transparent;
            border-radius: 16px;
            background: var(--white);
            overflow: hidden;
            position: relative;
        }

        .result-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
        }

        .result-card:hover {
            transform: translateY(-8px) scale(1.02);
            box-shadow: 0 20px 40px rgba(21, 101, 192, 0.2);
            border-color: var(--accent-color);
        }

        .status-badge {
            font-size: 0.75rem;
            padding: 0.5rem 1rem;
            border-radius: 25px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-completed {
            background: linear-gradient(135deg, #4CAF50, #45a049);
            color: white;
            box-shadow: 0 4px 15px rgba(76, 175, 80, 0.3);
        }

        .status-pending {
            background: linear-gradient(135deg, #FF9800, #f57c00);
            color: white;
            box-shadow: 0 4px 15px rgba(255, 152, 0, 0.3);
        }

        .status-draft {
            background: linear-gradient(135deg, #f44336, #d32f2f);
            color: white;
            box-shadow: 0 4px 15px rgba(244, 67, 54, 0.3);
        }

        .info-section {
            border-radius: 12px;
            padding: 1rem;
            margin-bottom: 1rem;
            position: relative;
            overflow: hidden;
        }

        .patient-info {
            background: linear-gradient(135deg, rgba(21, 101, 192, 0.1), rgba(33, 150, 243, 0.1));
            border-left: 4px solid var(--primary-color);
        }

        .doctor-info {
            background: linear-gradient(135deg, rgba(25, 118, 210, 0.1), rgba(33, 150, 243, 0.1));
            border-left: 4px solid var(--success-color);
        }

        .nurse-info {
            background: linear-gradient(135deg, rgba(66, 165, 245, 0.1), rgba(33, 150, 243, 0.1));
            border-left: 4px solid var(--accent-color);
        }

        .diagnosis-section {
            background: linear-gradient(135deg, rgba(255, 213, 79, 0.1), rgba(255, 183, 77, 0.1));
            border-radius: 12px;
            padding: 1rem;
            border-left: 4px solid #FFB74D;
        }

        .info-item {
            display: flex;
            align-items: center;
            margin-bottom: 0.5rem;
            padding: 0.25rem 0;
        }

        .info-item:last-child {
            margin-bottom: 0;
        }

        .info-icon {
            width: 24px;
            height: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 0.75rem;
            border-radius: 50%;
            background: rgba(21, 101, 192, 0.1);
            color: var(--primary-color);
            font-size: 0.9rem;
        }

        .dental-procedure-icon {
            color: var(--primary-color);
            font-size: 1.1rem;
        }

        /* Enhanced Pagination - Moved to bottom */
        .dental-pagination {
            background: var(--white);
            border: 2px solid rgba(21, 101, 192, 0.1);
            border-radius: 16px;
            padding: 1.5rem;
            margin: 2rem 0;
            box-shadow: 0 8px 25px rgba(21, 101, 192, 0.1);
        }

        .dental-pagination .pagination {
            margin: 0;
            gap: 8px;
            justify-content: center;
        }

        .dental-pagination .page-link {
            border: 2px solid rgba(21, 101, 192, 0.2);
            border-radius: 10px;
            padding: 12px 16px;
            color: var(--primary-color);
            background: var(--white);
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(21, 101, 192, 0.1);
            min-width: 50px;
            text-align: center;
        }

        .dental-pagination .page-link:hover {
            background: var(--light-blue);
            color: var(--primary-color);
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(21, 101, 192, 0.3);
            border-color: var(--accent-color);
        }

        .dental-pagination .page-item.active .page-link {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            border-color: var(--primary-color);
            box-shadow: 0 6px 20px rgba(21, 101, 192, 0.4);
            transform: scale(1.05);
            font-weight: 700;
        }

        .dental-pagination .page-item.disabled .page-link {
            background: rgba(21, 101, 192, 0.1);
            color: var(--text-muted);
            cursor: not-allowed;
            border-color: rgba(21, 101, 192, 0.1);
        }

        .pagination-info {
            background: rgba(21, 101, 192, 0.1);
            border-radius: 12px;
            padding: 1rem 1.5rem;
            margin-top: 1rem;
            border: 1px solid rgba(21, 101, 192, 0.2);
            text-align: center;
        }

        .pagination-info-text {
            color: var(--primary-color);
            font-weight: 600;
            margin: 0;
        }

        .nav-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            font-size: 16px;
            font-weight: bold;
        }

        .pagination-ellipsis {
            display: flex;
            align-items: center;
            justify-content: center;
            height: 50px;
            color: var(--text-muted);
            font-weight: bold;
            font-size: 18px;
        }

        .control-panel {
            background: var(--white);
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: 0 8px 25px rgba(21, 101, 192, 0.1);
            border: 2px solid rgba(21, 101, 192, 0.1);
        }

        .btn-dental {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border: none;
            border-radius: 25px;
            padding: 0.5rem 1.5rem;
            color: white;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(21, 101, 192, 0.3);
        }

        .btn-dental:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(21, 101, 192, 0.4);
            color: white;
        }

        .form-select {
            border-radius: 12px;
            border: 2px solid rgba(21, 101, 192, 0.2);
            padding: 0.5rem 1rem;
        }

        .form-select:focus {
            border-color: var(--accent-color);
            box-shadow: 0 0 0 0.2rem rgba(21, 101, 192, 0.25);
        }

        .empty-state {
            background: var(--white);
            border-radius: 20px;
            padding: 4rem 2rem;
            text-align: center;
            box-shadow: 0 8px 30px rgba(21, 101, 192, 0.1);
        }

        .alert-dental {
            border-radius: 16px;
            border: none;
            box-shadow: 0 8px 25px rgba(229, 62, 62, 0.2);
        }

        .tooth-decoration {
            position: absolute;
            top: 10px;
            right: 15px;
            color: rgba(21, 101, 192, 0.1);
            font-size: 2rem;
        }

        /* Animation for cards */
        .result-card {
            animation: slideInUp 0.6s ease-out;
        }

        @keyframes slideInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Footer Styles */
        footer {
            background: linear-gradient(135deg, #2c3e50, #34495e);
            color: white;
            padding: 40px 0;
            width: 100%;
            margin-top: auto;
            position: relative;
        }

        footer::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 2px;
            background: linear-gradient(90deg, #667eea, #764ba2, #667eea);
        }

        .footer-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .footer-content {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            flex-wrap: wrap;
            gap: 20px;
            margin-bottom: 30px;
        }

        .footer-section {
            flex: 1;
            min-width: 250px;
        }

        .footer-section h3 {
            font-size: 1.5rem;
            margin-bottom: 20px;
            color: #4ecdc4;
            position: relative;
        }

        .footer-section h3::after {
            content: '';
            position: absolute;
            left: 0;
            bottom: -5px;
            width: 50px;
            height: 3px;
            background: linear-gradient(90deg, #667eea, #764ba2);
            border-radius: 2px;
        }

        .footer-section p {
            line-height: 1.8;
            margin-bottom: 15px;
            opacity: 0.9;
        }

        .contact-info p {
            margin-bottom: 10px;
        }

        .footer-links {
            list-style: none;
            padding: 0;
        }

        .footer-links li {
            margin-bottom: 12px;
        }

        .footer-links a {
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            position: relative;
        }

        .footer-links a::before {
            content: '';
            position: absolute;
            left: 0;
            bottom: -2px;
            width: 0;
            height: 2px;
            background: #4ecdc4;
            transition: width 0.3s ease;
        }

        .footer-links a:hover {
            color: #4ecdc4;
            transform: translateX(5px);
        }

        .footer-links a:hover::before {
            width: 100%;
        }

        .footer-links i {
            margin-right: 8px;
            width: 16px;
        }

        .social-links {
            display: flex;
            gap: 15px;
            margin-top: 20px;
        }

        .social-links a {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            color: white;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .social-links a:hover {
            background: #4ecdc4;
            transform: translateY(-2px) scale(1.1);
        }

        .newsletter-form {
            display: flex;
            margin-top: 20px;
            gap: 10px;
        }

        .newsletter-input {
            flex: 1;
            padding: 10px 15px;
            border: none;
            border-radius: 25px;
            background: rgba(255, 255, 255, 0.1);
            color: white;
            border: 2px solid transparent;
            transition: all 0.3s ease;
        }

        .newsletter-input::placeholder {
            color: rgba(255, 255, 255, 0.7);
        }

        .newsletter-input:focus {
            outline: none;
            border-color: #4ecdc4;
            background: rgba(255, 255, 255, 0.15);
        }

        .newsletter-btn {
            padding: 10px 20px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border: none;
            border-radius: 25px;
            color: white;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 600;
        }

        .newsletter-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .footer-bottom {
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            padding-top: 20px;
            text-align: center;
        }

        .footer-bottom p {
            opacity: 0.8;
            margin: 10px 0;
        }

        .footer-bottom-links {
            display: flex;
            gap: 20px;
            list-style: none;
            justify-content: center;
            flex-wrap: wrap;
            padding: 0;
            margin: 0;
        }

        .footer-bottom-links a {
            color: rgba(255, 255, 255, 0.7);
            text-decoration: none;
            font-size: 0.9rem;
            transition: color 0.3s ease;
        }

        .footer-bottom-links a:hover {
            color: #4ecdc4;
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .page-header {
                padding: 1.5rem;
            }
            
            .dental-pagination {
                padding: 1.5rem;
            }
            
            .control-panel {
                padding: 1rem;
            }

            .footer-content {
                flex-direction: column;
                text-align: center;
            }

            .newsletter-form {
                flex-direction: column;
            }

            .social-links {
                justify-content: center;
            }

            .footer-section {
                min-width: unset;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="#">
                <i class="fas fa-tooth dental-icon me-2"></i>
                <strong>DentalCare</strong> - Phòng khám Nha khoa
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="${pageContext.request.contextPath}/views/user/Patient/PatientDashBoard.jsp">
                    <i class="fas fa-home me-1"></i>Trang chủ
                </a>
            </div>
        </div>
    </nav>

    <div class="main-content">
        <div class="container mt-4">
            <!-- Header -->
            <div class="page-header">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h1 class="page-title">
                            <i class="fas fa-clipboard-list me-3"></i>
                            Kết quả khám nha khoa
                        </h1>
                        <p class="text-muted mb-0 fs-5">Theo dõi lịch sử điều trị và chẩn đoán nha khoa của bạn</p>
                    </div>
                    <div class="text-end">
                        <span class="badge bg-gradient" style="background: linear-gradient(135deg, var(--accent-color), var(--secondary-color)); font-size: 1rem; padding: 0.75rem 1.5rem; border-radius: 25px;">
                            <i class="fas fa-file-medical me-2"></i>
                            Tổng cộng: ${totalResults} hồ sơ
                        </span>
                    </div>
                </div>
            </div>

            <!-- Error Message -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dental alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Controls -->
            <div class="control-panel mb-4">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <div class="d-flex align-items-center">
                            <label for="pageSize" class="form-label me-3 mb-0 fw-bold">
                                <i class="fas fa-list me-2 text-primary"></i>Hiển thị:
                            </label>
                            <select id="pageSize" class="form-select" style="width: auto; min-width: 80px;" onchange="changePageSize()">
                                <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                                <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                                <option value="30" ${pageSize == 30 ? 'selected' : ''}>30</option>
                                <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                            </select>
                            <span class="ms-3 text-muted fw-medium">hồ sơ mỗi trang</span>
                        </div>
                    </div>
                    <div class="col-md-6 text-md-end mt-3 mt-md-0">
                        <button class="btn btn-dental" onclick="location.reload()">
                            <i class="fas fa-sync-alt me-2"></i>Làm mới dữ liệu
                        </button>
                    </div>
                </div>
            </div>

            <!-- Results List -->
            <div class="row">
                <c:choose>
                    <c:when test="${empty examinationResults}">
                        <div class="col-12">
                            <div class="empty-state">
                                <i class="fas fa-tooth fa-4x text-muted mb-4"></i>
                                <h3 class="text-muted mb-3">Chưa có hồ sơ khám nha khoa</h3>
                                <p class="text-muted fs-5">Các kết quả khám và điều trị nha khoa của bạn sẽ được hiển thị tại đây sau khi hoàn thành.</p>
                                <div class="mt-4">
                                    <i class="fas fa-calendar-plus text-primary me-2"></i>
                                    <span class="text-muted">Hãy đặt lịch khám để bắt đầu theo dõi sức khỏe răng miệng</span>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="result" items="${examinationResults}" varStatus="status">
                            <div class="col-lg-6 col-xl-4 mb-4" style="animation-delay: ${status.index * 0.1}s">
                                <div class="card result-card h-100">
                                    <i class="fas fa-tooth tooth-decoration"></i>
                                    <div class="card-body">
                                        <!-- Date and Status -->
                                        <div class="d-flex justify-content-between align-items-start mb-3">
                                            <div>
                                                <h5 class="card-title mb-1 fw-bold text-primary">
                                                    <i class="fas fa-calendar-day me-2"></i>
                                                    <fmt:formatDate value="${result.slotDate}" pattern="dd/MM/yyyy"/>
                                                </h5>
                                                <small class="text-muted fw-medium">
                                                    <i class="fas fa-clock me-1"></i>
                                                    <fmt:formatDate value="${result.startTime}" pattern="HH:mm"/> - 
                                                    <fmt:formatDate value="${result.endTime}" pattern="HH:mm"/>
                                                </small>
                                            </div>
                                            <span class="status-badge 
                                                ${result.resultStatus == 'Completed' ? 'status-completed' : 
                                                  result.resultStatus == 'Pending' ? 'status-pending' : 'status-draft'}">
                                                <i class="fas fa-circle me-1"></i>
                                                <c:choose>
                                                    <c:when test="${result.resultStatus == 'Completed'}">Hoàn thành</c:when>
                                                    <c:when test="${result.resultStatus == 'Pending'}">Đang xử lý</c:when>
                                                    <c:when test="${result.resultStatus == 'Draft'}">Nháp</c:when>
                                                    <c:when test="${result.resultStatus == 'Reviewed'}">Đã xem xét</c:when>
                                                    <c:otherwise>${result.resultStatus}</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>

                                        <!-- Patient Info -->
                                        <div class="info-section patient-info">
                                            <div class="info-item">
                                                <div class="info-icon">
                                                    <i class="fas fa-user"></i>
                                                </div>
                                                <div>
                                                    <strong class="text-primary">Bệnh nhân</strong><br>
                                                    <span class="fw-bold">${result.patientName}</span>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Doctor and Service Info -->
                                        <div class="info-section doctor-info">
                                            <div class="info-item">
                                                <div class="info-icon">
                                                    <i class="fas fa-user-md"></i>
                                                </div>
                                                <div>
                                                    <strong class="text-success">Bác Sĩ </strong><br>
                                                    <span class="fw-bold">${result.doctorName}</span>
                                                    <c:if test="${not empty result.doctorSpecialization}">
                                                        <br><small class="text-muted">${result.doctorSpecialization}</small>
                                                    </c:if>
                                                </div>
                                            </div>
                                            <div class="info-item">
                                                <div class="info-icon">
                                                    <i class="fas fa-teeth dental-procedure-icon"></i>
                                                </div>
                                                <div>
                                                    <strong class="text-info">Dịch vụ</strong><br>
                                                    <span class="fw-medium">${result.serviceName}</span>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Nurse Info -->
                                        <div class="info-section nurse-info">
                                            <div class="info-item">
                                                <div class="info-icon">
                                                    <i class="fas fa-user-nurse"></i>
                                                </div>
                                                <div>
                                                    <strong class="text-success">Y tá hỗ trợ</strong><br>
                                                    <c:choose>
                                                        <c:when test="${not empty result.nurseName and result.nurseName != 'N/A' and result.nurseName != 'Chưa gán y tá'}">
                                                            <span class="fw-bold">${result.nurseName}</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted fw-medium">Chưa được gán</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Diagnosis Section -->
                                        <div class="diagnosis-section">
                                            <h6 class="mb-2 fw-bold">
                                                <i class="fas fa-stethoscope text-warning me-2"></i>
                                                Chẩn đoán & điều trị:
                                            </h6>
                                            <p class="mb-0 text-muted lh-base">
                                                ${result.diagnosis}
                                            </p>
                                        </div>

                                        <!-- Room Info -->
                                        <div class="mt-3 pt-3 border-top">
                                            <small class="text-muted fw-medium">
                                                <i class="fas fa-door-open me-2 text-primary"></i>
                                                Phòng điều trị: <strong>${result.roomName}</strong>
                                            </small>
                                        </div>
                                    </div>

                                    <!-- Card Footer -->
                                    <div class="card-footer bg-transparent border-top">
                                        <small class="text-muted fw-medium">
                                            <i class="fas fa-history me-2"></i>
                                            Ghi nhận: <fmt:formatDate value="${result.resultCreatedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </small>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Enhanced Dental Pagination -->
            <c:if test="${totalPages > 1}">
                <div class="dental-pagination text-center">
                    <nav aria-label="Điều hướng trang">
                        <ul class="pagination justify-content-center">
                            <!-- Previous Button -->
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link nav-btn" href="?page=${currentPage - 1}&pageSize=${pageSize}" title="Trang trước">
                                    <i class="fas fa-chevron-left"></i>
                                </a>
                            </li>

                            <!-- First Page -->
                            <c:if test="${startPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=1&pageSize=${pageSize}">1</a>
                                </li>
                                <c:if test="${startPage > 2}">
                                    <li class="page-item disabled">
                                        <span class="page-link pagination-ellipsis">⋯</span>
                                    </li>
                                </c:if>
                            </c:if>

                            <!-- Page Numbers -->
                            <c:forEach begin="${startPage}" end="${endPage}" var="pageNum">
                                <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="?page=${pageNum}&pageSize=${pageSize}">${pageNum}</a>
                                </li>
                            </c:forEach>

                            <!-- Last Page -->
                            <c:if test="${endPage < totalPages}">
                                <c:if test="${endPage < totalPages - 1}">
                                    <li class="page-item disabled">
                                        <span class="page-link pagination-ellipsis">⋯</span>
                                    </li>
                                </c:if>
                                <li class="page-item">
                                    <a class="page-link" href="?page=${totalPages}&pageSize=${pageSize}">${totalPages}</a>
                                </li>
                            </c:if>

                            <!-- Next Button -->
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link nav-btn" href="?page=${currentPage + 1}&pageSize=${pageSize}" title="Trang sau">
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                            </li>
                        </ul>
                    </nav>

                    <!-- Enhanced Pagination Info -->
                    <div class="pagination-info">
                        <p class="pagination-info-text">
                            <i class="fas fa-info-circle me-2"></i>
                            Hiển thị <strong>${(currentPage - 1) * pageSize + 1}</strong> - 
                            <strong>${currentPage * pageSize > totalResults ? totalResults : currentPage * pageSize}</strong> 
                            trong tổng số <strong>${totalResults}</strong> hồ sơ khám
                            <span class="ms-4">
                                <i class="fas fa-file-alt me-1"></i>
                                Trang <strong>${currentPage}</strong> / <strong>${totalPages}</strong>
                            </span>
                        </p>
                    </div>
                </div>
            </c:if>
        </div>
    </div>

    <!-- Footer -->
    <footer>
        <div class="footer-container">
            <div class="footer-content">
                <div class="footer-section">
                    <h3><i class="fas fa-rocket"></i> Về Nha Khoa PDC</h3>
                    <p>Chúng tôi là phòng khám nha khoa hàng đầu, cam kết mang lại nụ cười khỏe mạnh và tự tin với công nghệ tiên tiến và đội ngũ chuyên gia giàu kinh nghiệm.</p>
                    <div class="contact-info">
                        <p><i class="fas fa-map-marker-alt"></i> Địa Chỉ: ĐH FPT , Hòa Lạc </p>
                        <p><i class="fas fa-phone"></i> Hotline:</p>
                        <p><i class="fas fa-clock"></i> Thời gian: 7:30 - 17:00 (Thứ 2 - Thứ 7)</p>
                        <p><i class="fas fa-envelope"></i> Email:PhongKhamPDC@gmail.com</p>
                    </div>
                    <div class="social-links">
                        <a href="#" title="Facebook"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" title="Zalo"><i class="fab fa-whatsapp"></i></a>
                        <a href="#" title="Instagram"><i class="fab fa-instagram"></i></a>
                    </div>
                </div>

                <div class="footer-section">
                    <h3><i class="fas fa-link"></i> Liên Kết Nhanh</h3>
                    <ul class="footer-links">
                        <li><a href="${pageContext.request.contextPath}/views/common/HomePage.jsp"><i class="fas fa-home"></i> Trang Chủ</a></li>
                        <li><a href="${pageContext.request.contextPath}/BookAppointmentGuestServlet"><i class="fas fa-calendar-check"></i> Đăng Kí Tư Vấn</a></li>
                        <li><a href="#"><i class="fas fa-info-circle"></i> Giới Thiệu</a></li>               
                        <li><a href="#"><i class="fas fa-question-circle"></i> Hỏi Đáp</a></li>
                    </ul>
                </div>

                <div class="footer-section">
                    <h3><i class="fas fa-handshake"></i> Dịch Vụ Nổi Bật</h3>
                    <ul class="footer-links">
                        <li><i class="fas fa-tooth"></i> Cấy Ghép Implant</li>
                        <li><i class="fas fa-grip-lines"></i> Chỉnh Nha Mắc Cài</li>
                        <li><i class="fas fa-child"></i> Nha Khoa Trẻ Em</li>
                        <li><i class="fas fa-procedures"></i> Nhổ Răng Khôn</li>
                        <li><i class="fas fa-smile"></i> Nha Khoa Thẩm Mỹ</li>
                    </ul>
                </div>

                <div class="footer-section">
                    <h3><i class="fas fa-paper-plane"></i> Đăng Ký Tư Vấn</h3>
                    <p>Nhận tư vấn miễn phí và cập nhật thông tin sức khỏe răng miệng.</p>
                    <form class="newsletter-form" action="${pageContext.request.contextPath}/NewsletterServlet" method="post">
                        <input type="email" class="newsletter-input" name="email" placeholder="Nhập email của bạn...">
                        <button type="submit" class="newsletter-btn">
                            <i class="fas fa-paper-plane"></i>
                        </button>
                    </form>
                    <p style="margin-top: 15px;"><i class="fas fa-shield-alt"></i> Bảo hành trọn đời cho Implant</p>
                </div>
            </div>

            <div class="footer-bottom">
                <p>© 2025 Nha Khoa PDC. Đạt chuẩn Bộ Y tế. Tất cả quyền được bảo lưu.</p>
                <ul class="footer-bottom-links">
                    <li><a href="#">Chính Sách Bảo Mật</a></li>
                    <li><a href="#">Điều Khoản Sử Dụng</a></li>
                    <li><a href="#">Chính Sách Bảo Hành</a></li>
                </ul>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function changePageSize() {
            const pageSize = document.getElementById('pageSize').value;
            window.location.href = '?page=1&pageSize=' + pageSize;
        }

        // Enhanced interactions and animations
        document.addEventListener('DOMContentLoaded', function() {
            // Pagination hover effects
            const pageLinks = document.querySelectorAll('.dental-pagination .page-link');
            pageLinks.forEach(link => {
                link.addEventListener('mouseenter', function() {
                    if (!this.closest('.page-item').classList.contains('active') && 
                        !this.closest('.page-item').classList.contains('disabled')) {
                        this.style.transform = 'translateY(-3px) scale(1.05)';
                    }
                });
                
                link.addEventListener('mouseleave', function() {
                    if (!this.closest('.page-item').classList.contains('active')) {
                        this.style.transform = '';
                    }
                });
            });

            // Card hover sound effect simulation (visual feedback)
            const resultCards = document.querySelectorAll('.result-card');
            resultCards.forEach((card, index) => {
                // Staggered animation on load
                card.style.animationDelay = `${index * 0.1}s`;
                
                // Enhanced hover effects
                card.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-8px) scale(1.02)';
                    this.style.boxShadow = '0 20px 40px rgba(46, 125, 138, 0.2)';
                });
                
                card.addEventListener('mouseleave', function() {
                    this.style.transform = '';
                    this.style.boxShadow = '';
                });
            });

            // Smooth scroll to pagination
            const paginationLinks = document.querySelectorAll('.dental-pagination .page-link');
            paginationLinks.forEach(link => {
                link.addEventListener('click', function(e) {
                    if (!this.closest('.page-item').classList.contains('disabled') && 
                        !this.closest('.page-item').classList.contains('active')) {
                        // Add loading effect
                        const spinner = document.createElement('i');
                        spinner.className = 'fas fa-spinner fa-spin ms-2';
                        this.appendChild(spinner);
                    }
                });
            });

            // Add subtle animations to info sections
            const infoSections = document.querySelectorAll('.info-section');
            infoSections.forEach((section, index) => {
                section.style.opacity = '0';
                section.style.transform = 'translateY(20px)';
                
                setTimeout(() => {
                    section.style.transition = 'all 0.6s ease';
                    section.style.opacity = '1';
                    section.style.transform = 'translateY(0)';
                }, index * 100);
            });

            // Interactive page size selector
            const pageSizeSelect = document.getElementById('pageSize');
            if (pageSizeSelect) {
                pageSizeSelect.addEventListener('change', function() {
                    this.style.transform = 'scale(1.05)';
                    setTimeout(() => {
                        this.style.transform = '';
                    }, 200);
                });
            }

            // Add ripple effect to buttons
            const buttons = document.querySelectorAll('.btn-dental');
            buttons.forEach(button => {
                button.addEventListener('click', function(e) {
                    const ripple = document.createElement('span');
                    const rect = this.getBoundingClientRect();
                    const size = Math.max(rect.width, rect.height);
                    const x = e.clientX - rect.left - size / 2;
                    const y = e.clientY - rect.top - size / 2;
                    
                    ripple.style.cssText = `
                        position: absolute;
                        width: ${size}px;
                        height: ${size}px;
                        left: ${x}px;
                        top: ${y}px;
                        background: rgba(255, 255, 255, 0.5);
                        border-radius: 50%;
                        transform: scale(0);
                        animation: ripple 0.6s ease-out;
                        pointer-events: none;
                    `;
                    
                    this.style.position = 'relative';
                    this.style.overflow = 'hidden';
                    this.appendChild(ripple);
                    
                    setTimeout(() => {
                        ripple.remove();
                    }, 600);
                });
            });

            // Add CSS for ripple animation
            const style = document.createElement('style');
            style.textContent = `
                @keyframes ripple {
                    to {
                        transform: scale(2);
                        opacity: 0;
                    }
                }
                
                .result-card {
                    animation: slideInUp 0.6s ease-out both;
                }
                
                @keyframes slideInUp {
                    from {
                        opacity: 0;
                        transform: translateY(30px);
                    }
                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }
                
                .tooth-decoration {
                    transition: all 0.3s ease;
                }
                
                .result-card:hover .tooth-decoration {
                    color: rgba(21, 101, 192, 0.2);
                    transform: rotate(10deg) scale(1.1);
                }
                
                .status-badge {
                    animation: fadeInScale 0.8s ease-out;
                }
                
                @keyframes fadeInScale {
                    from {
                        opacity: 0;
                        transform: scale(0.8);
                    }
                    to {
                        opacity: 1;
                        transform: scale(1);
                    }
                }
                
                .info-icon {
                    transition: all 0.3s ease;
                }
                
                .info-section:hover .info-icon {
                    transform: scale(1.1);
                    background: rgba(21, 101, 192, 0.2);
                }
                
                .page-header {
                    animation: slideInDown 0.8s ease-out;
                }
                
                @keyframes slideInDown {
                    from {
                        opacity: 0;
                        transform: translateY(-30px);
                    }
                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }
                
                .control-panel {
                    animation: fadeIn 1s ease-out 0.3s both;
                }
                
                @keyframes fadeIn {
                    from {
                        opacity: 0;
                    }
                    to {
                        opacity: 1;
                    }
                }
            `;
            document.head.appendChild(style);

            // Footer Newsletter form handling
            document.querySelector('.newsletter-form').addEventListener('submit', function(e) {
                e.preventDefault();
                const email = this.querySelector('.newsletter-input').value;
                if (email) {
                    alert('Cảm ơn bạn đã đăng ký! Email: ' + email);
                    this.querySelector('.newsletter-input').value = '';
                }
            });

            // Add some interactive effects for footer links
            document.querySelectorAll('.footer-links a').forEach(link => {
                link.addEventListener('mouseenter', function() {
                    this.style.paddingLeft = '10px';
                });
                
                link.addEventListener('mouseleave', function() {
                    this.style.paddingLeft = '0';
                });
            });
        });

        // Add loading state for page changes
        function showLoadingState() {
            const cards = document.querySelectorAll('.result-card');
            cards.forEach(card => {
                card.style.opacity = '0.7';
                card.style.pointerEvents = 'none';
            });
        }

        // Enhanced page size change with loading
        function changePageSize() {
            showLoadingState();
            const pageSize = document.getElementById('pageSize').value;
            
            // Add loading indicator
            const pageSizeSelect = document.getElementById('pageSize');
            const originalHTML = pageSizeSelect.innerHTML;
            pageSizeSelect.innerHTML = '<option>Đang tải...</option>';
            pageSizeSelect.disabled = true;
            
            setTimeout(() => {
                window.location.href = '?page=1&pageSize=' + pageSize;
            }, 500);
        }
    </script>
</body>
</html>
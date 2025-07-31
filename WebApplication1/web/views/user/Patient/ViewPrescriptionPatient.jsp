<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đơn Thuốc Của Tôi - Hệ thống quản lý phòng khám</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #1a365d;
            --primary-light: #2c5282;
            --secondary-color: #e2e8f0;
            --success-color: #065f46;
            --warning-color: #92400e;
            --danger-color: #991b1b;
            --info-color: #0c4a6e;
            --text-primary: #1a202c;
            --text-secondary: #4a5568;
            --text-muted: #718096;
            --border-color: #e2e8f0;
            --bg-light: #f7fafc;
            --bg-white: #ffffff;
            --shadow-sm: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        }

        * {
            box-sizing: border-box;
        }

        body {
            font-family: 'IBM Plex Sans', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background-color: var(--bg-light);
            color: var(--text-primary);
            line-height: 1.6;
            margin: 0;
            padding: 0;
        }

        /* Navigation */
        .navbar {
            background-color: var(--primary-color) !important;
            box-shadow: var(--shadow-lg);
            padding: 1rem 0;
            border-bottom: 3px solid var(--primary-light);
        }

        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
            color: white !important;
            transition: all 0.3s ease;
        }

        .navbar-brand:hover {
            color: var(--secondary-color) !important;
            transform: translateX(5px);
        }

        .nav-link {
            font-weight: 500;
            color: rgba(255, 255, 255, 0.9) !important;
            padding: 0.75rem 1.5rem !important;
            margin: 0 0.25rem;
            transition: all 0.3s ease;
            border: 1px solid transparent;
        }

        .nav-link:hover {
            background-color: rgba(255, 255, 255, 0.1);
            color: white !important;
            border-color: rgba(255, 255, 255, 0.2);
        }

        /* Header Section */
        .page-header {
            background: linear-gradient(135deg, var(--bg-white) 0%, var(--bg-light) 100%);
            padding: 2.5rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow-md);
            border-left: 4px solid var(--primary-color);
            border-top: 1px solid var(--border-color);
            border-right: 1px solid var(--border-color);
            border-bottom: 1px solid var(--border-color);
        }

        .page-title {
            font-size: 2.25rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 0.75rem;
            letter-spacing: -0.025em;
        }

        .page-subtitle {
            font-size: 1.125rem;
            color: var(--text-secondary);
            font-weight: 400;
            margin-bottom: 0;
        }

        .total-badge {
            background-color: var(--info-color);
            color: white;
            padding: 0.875rem 1.75rem;
            font-weight: 600;
            font-size: 1rem;
            border: none;
            box-shadow: var(--shadow-sm);
            transition: all 0.3s ease;
        }

        .total-badge:hover {
            background-color: var(--primary-light);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        /* Statistics Cards */
        .stats-section {
            margin-bottom: 2.5rem;
        }

        .stat-card {
            background-color: var(--bg-white);
            border: 1px solid var(--border-color);
            padding: 2rem;
            text-align: center;
            transition: all 0.3s ease;
            box-shadow: var(--shadow-sm);
            height: 100%;
            position: relative;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            transition: all 0.3s ease;
        }

        .stat-card.stat-primary::before {
            background-color: var(--primary-color);
        }

        .stat-card.stat-success::before {
            background-color: var(--success-color);
        }

        .stat-card.stat-warning::before {
            background-color: var(--warning-color);
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-lg);
            border-color: var(--primary-color);
        }

        .stat-icon {
            width: 64px;
            height: 64px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            font-size: 1.75rem;
            color: white;
        }

        .stat-icon.icon-primary {
            background-color: var(--primary-color);
        }

        .stat-icon.icon-success {
            background-color: var(--success-color);
        }

        .stat-icon.icon-warning {
            background-color: var(--warning-color);
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 0.5rem;
            line-height: 1;
        }

        .stat-title {
            font-size: 1rem;
            font-weight: 500;
            color: var(--text-secondary);
            margin-bottom: 0;
        }

        /* Controls Section */
        .controls-section {
            background-color: var(--bg-white);
            border: 1px solid var(--border-color);
            padding: 1.5rem 2rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow-sm);
        }

        .form-select {
            border: 2px solid var(--border-color);
            padding: 0.75rem 1rem;
            font-weight: 500;
            transition: all 0.3s ease;
            background-color: var(--bg-white);
        }

        .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(26, 54, 93, 0.1);
        }

        .btn-refresh {
            background-color: var(--primary-color);
            border: 2px solid var(--primary-color);
            color: white;
            padding: 0.75rem 1.5rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-refresh:hover {
            background-color: var(--primary-light);
            border-color: var(--primary-light);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        /* Prescription Cards */
        .prescription-card {
            background-color: var(--bg-white);
            border: 1px solid var(--border-color);
            transition: all 0.3s ease;
            overflow: hidden;
            height: 100%;
            box-shadow: var(--shadow-sm);
        }

        .prescription-card:hover {
            transform: translateY(-8px);
            box-shadow: var(--shadow-lg);
            border-color: var(--primary-color);
        }

        .card-header {
            background-color: var(--bg-light);
            border-bottom: 2px solid var(--border-color);
            padding: 1.5rem 2rem;
        }

        .prescription-id {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 0;
        }

        .card-body {
            padding: 2rem;
        }

        .doctor-info {
            background-color: var(--bg-light);
            border: 1px solid var(--border-color);
            border-left: 4px solid var(--primary-color);
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .doctor-name {
            font-weight: 700;
            font-size: 1.125rem;
            color: var(--primary-color);
            margin-bottom: 1rem;
        }

        .info-item {
            display: flex;
            align-items: center;
            margin-bottom: 0.75rem;
            font-weight: 500;
            color: var(--text-secondary);
        }

        .info-item:last-child {
            margin-bottom: 0;
        }

        .info-icon {
            width: 20px;
            margin-right: 12px;
            color: var(--primary-color);
        }

        .diagnosis-section {
            background-color: #f0fdf4;
            border: 1px solid #bbf7d0;
            border-left: 4px solid var(--success-color);
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .diagnosis-title {
            font-weight: 700;
            color: var(--success-color);
            margin-bottom: 1rem;
            font-size: 1.1rem;
        }

        .diagnosis-preview {
            max-height: 4em;
            overflow: hidden;
            line-height: 1.4;
            color: var(--text-secondary);
            margin-bottom: 0;
        }

        .card-footer {
            background-color: var(--bg-light);
            border-top: 1px solid var(--border-color);
            padding: 1.5rem 2rem;
        }

        .timestamp {
            font-size: 0.875rem;
            color: var(--text-muted);
            font-weight: 500;
            margin-bottom: 0.5rem;
        }

        .btn-detail {
            background-color: var(--primary-color);
            border: 2px solid var(--primary-color);
            color: white;
            padding: 0.75rem 1.25rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-detail:hover {
            background-color: var(--primary-light);
            border-color: var(--primary-light);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        /* Detail View */
        .detail-card {
            background-color: var(--bg-white);
            box-shadow: var(--shadow-lg);
            border: 1px solid var(--border-color);
            overflow: hidden;
        }

        .detail-header {
            padding: 2.5rem;
            background-color: var(--bg-light);
            border-bottom: 2px solid var(--border-color);
            border-left: 4px solid var(--primary-color);
        }

        .detail-body {
            padding: 2.5rem;
        }

        .info-grid {
            display: grid;
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .info-card {
            background-color: var(--bg-light);
            border: 1px solid var(--border-color);
            padding: 1.5rem;
            transition: all 0.3s ease;
        }

        .info-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-md);
        }

        .prescription-details {
            background-color: #fef3c7;
            border: 1px solid #fbbf24;
            border-left: 4px solid var(--warning-color);
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .prescription-details h6 {
            color: var(--warning-color);
            font-weight: 700;
            margin-bottom: 1.5rem;
        }

        .detail-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .detail-list-item {
            background-color: var(--bg-white);
            border: 1px solid var(--border-color);
            padding: 1.25rem;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
        }

        .detail-list-item:hover {
            transform: translateX(5px);
            box-shadow: var(--shadow-sm);
            border-color: var(--primary-color);
        }

        .detail-list-item:last-child {
            margin-bottom: 0;
        }

        .detail-label {
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }

        .detail-value {
            color: var(--text-secondary);
            margin-bottom: 0;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            background-color: var(--bg-white);
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
        }

        .empty-icon {
            font-size: 4rem;
            color: var(--text-muted);
            margin-bottom: 2rem;
            opacity: 0.6;
        }

        .empty-title {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--text-secondary);
            margin-bottom: 1rem;
        }

        .empty-subtitle {
            font-size: 1.125rem;
            color: var(--text-muted);
            margin-bottom: 0;
        }

        /* Pagination */
        .pagination {
            --bs-pagination-border-color: var(--border-color);
            --bs-pagination-hover-bg: var(--primary-color);
            --bs-pagination-hover-border-color: var(--primary-color);
            --bs-pagination-hover-color: white;
            --bs-pagination-active-bg: var(--primary-color);
            --bs-pagination-active-border-color: var(--primary-color);
            --bs-pagination-focus-box-shadow: 0 0 0 3px rgba(26, 54, 93, 0.1);
            gap: 0.25rem;
        }

        .page-link {
            font-weight: 600;
            transition: all 0.3s ease;
            border-width: 2px;
            min-width: 44px;
            height: 44px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .page-link:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-sm);
        }

        .page-item.active .page-link {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .pagination-info {
            background-color: var(--bg-white);
            border: 1px solid var(--border-color);
            padding: 1rem 2rem;
            box-shadow: var(--shadow-sm);
            display: inline-block;
            margin-top: 2rem;
        }

        /* Error Alert */
        .alert-danger {
            background-color: #fee2e2;
            border: 1px solid #fca5a5;
            color: var(--danger-color);
            box-shadow: var(--shadow-sm);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .page-header {
                padding: 2rem 1.5rem;
                margin-bottom: 1.5rem;
            }
            
            .page-title {
                font-size: 1.875rem;
            }
            
            .controls-section {
                padding: 1.25rem 1.5rem;
            }
            
            .card-body {
                padding: 1.5rem;
            }
            
            .card-footer {
                padding: 1.25rem 1.5rem;
            }
            
            .prescription-card:hover {
                transform: translateY(-4px);
            }

            .stat-number {
                font-size: 2rem;
            }

            .stat-icon {
                width: 56px;
                height: 56px;
                font-size: 1.5rem;
            }
        }

        /* Loading Animation */
        .loading {
            display: inline-block;
            width: 18px;
            height: 18px;
            border: 3px solid rgba(255,255,255,.3);
            border-top-color: #fff;
            animation: spin 1s ease-in-out infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        /* Focus States */
        .btn:focus,
        .form-select:focus,
        .page-link:focus {
            outline: 2px solid var(--primary-color);
            outline-offset: 2px;
        }

        /* Utility Classes */
        .border-left-primary {
            border-left: 4px solid var(--primary-color);
        }

        .border-left-success {
            border-left: 4px solid var(--success-color);
        }

        .border-left-warning {
            border-left: 4px solid var(--warning-color);
        }

        .text-primary-custom {
            color: var(--primary-color);
        }

        .bg-light-custom {
            background-color: var(--bg-light);
        }

        /* Animation Classes */
        .fade-in {
            animation: fadeIn 0.6s ease-out;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .slide-in {
            animation: slideIn 0.8s ease-out;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateX(-30px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="#">
                <i class="fas fa-clinic-medical me-3"></i>
                Phòng khám ABC
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="${pageContext.request.contextPath}/patient/dashboard">
                    <i class="fas fa-home me-2"></i>Trang chủ
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/ViewPrescriptionPatient " class="nav-item active">
                    Xem đơn thuốc
                </a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <!-- Header -->
        <div class="page-header fade-in">
            <div class="d-flex justify-content-between align-items-center flex-wrap">
                <div>
                    <h1 class="page-title">
                        <i class="fas fa-prescription-bottle-alt me-3"></i>
                        <c:choose>
                            <c:when test="${isDetailView}">Chi Tiết Đơn Thuốc</c:when>
                            <c:otherwise>Đơn Thuốc Của Tôi</c:otherwise>
                        </c:choose>
                    </h1>
                    <p class="page-subtitle">
                        <c:choose>
                            <c:when test="${isDetailView}">Thông tin chi tiết về đơn thuốc được kê bởi bác sĩ</c:when>
                            <c:otherwise>Quản lý và theo dõi tất cả đơn thuốc của bạn</c:otherwise>
                        </c:choose>
                    </p>
                </div>
                <c:if test="${not isDetailView}">
                    <div class="mt-3 mt-md-0">
                        <span class="badge total-badge">
                            <i class="fas fa-pills me-2"></i>
                            ${totalPrescriptions} đơn thuốc
                        </span>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Error Message -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show fade-in" role="alert">
                <i class="fas fa-exclamation-triangle me-3"></i>
                <strong>Lỗi!</strong> ${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Detail View -->
        <c:if test="${isDetailView}">
            <div class="detail-card fade-in">
                <div class="detail-header">
                    <h2 class="prescription-id">
                        <i class="fas fa-prescription-bottle-alt me-3"></i>
                        Đơn Thuốc #${prescriptionDetail.prescriptionId}
                    </h2>
                </div>
                <div class="detail-body">
                    <div class="row info-grid">
                        <div class="col-md-6">
                            <div class="info-card border-left-primary">
                                <h5 class="mb-3 text-primary-custom fw-bold">
                                    <i class="fas fa-user-md me-2"></i>Thông tin bác sĩ
                                </h5>
                                <div class="info-item">
                                    <i class="fas fa-user-md info-icon"></i>
                                    <span class="doctor-name">${prescriptionDetail.doctorName}</span>
                                </div>
                                <div class="info-item">
                                    <i class="fas fa-calendar-plus info-icon"></i>
                                    <span>Ngày tạo: ${prescriptionDetail.createdAt != null ? prescriptionDetail.createdAt.toString().substring(0, 16).replace('T', ' ') : 'Không có'}</span>
                                </div>
                                <div class="info-item">
                                    <i class="fas fa-calendar-check info-icon"></i>
                                    <span>Cập nhật: ${prescriptionDetail.updatedAt != null ? prescriptionDetail.updatedAt.toString().substring(0, 16).replace('T', ' ') : 'Không có'}</span>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="info-card border-left-primary">
                                <h5 class="mb-3 text-primary-custom fw-bold">
                                    <i class="fas fa-info-circle me-2"></i>Thông tin khác
                                </h5>
                                <div class="info-item">
                                    <i class="fas fa-user-nurse info-icon"></i>
                                    <span>Y tá: ${prescriptionDetail.nurseName != null ? prescriptionDetail.nurseName : 'Chưa có'}</span>
                                </div>
                                <div class="info-item">
                                    <i class="fas fa-calendar-day info-icon"></i>
                                    <span>Mã lịch hẹn: ${prescriptionDetail.appointmentId != null ? prescriptionDetail.appointmentId : 'Không có'}</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="diagnosis-section border-left-success">
                        <h5 class="diagnosis-title">
                            <i class="fas fa-notes-medical me-2"></i>
                            Chẩn đoán
                        </h5>
                        <p class="diagnosis-preview">
                            ${prescriptionDetail.diagnosis != null ? prescriptionDetail.diagnosis : 'Không có thông tin chẩn đoán'}
                        </p>
                    </div>

                    <div class="prescription-details border-left-warning">
                        <h5>
                            <i class="fas fa-pills me-2"></i>
                            Thông Tin Đơn Thuốc
                        </h5>
                        <ul class="detail-list">
                            <li class="detail-list-item">
                                <div class="detail-label">
                                    <i class="fas fa-syringe me-2"></i>Liều lượng
                                </div>
                                <div class="detail-value">
                                    ${prescriptionDetail.prescriptionDosage != null ? prescriptionDetail.prescriptionDosage : 'Không có thông tin'}
                                </div>
                            </li>
                            <li class="detail-list-item">
                                <div class="detail-label">
                                    <i class="fas fa-clipboard-list me-2"></i>Hướng dẫn sử dụng
                                </div>
                                <div class="detail-value">
                                    ${prescriptionDetail.instruct != null ? prescriptionDetail.instruct : 'Không có hướng dẫn'}
                                </div>
                            </li>
                            <li class="detail-list-item">
                                <div class="detail-label">
                                    <i class="fas fa-sort-numeric-up me-2"></i>Số lượng
                                </div>
                                <div class="detail-value">
                                    ${prescriptionDetail.quantity != null ? prescriptionDetail.quantity : 'Không có thông tin'}
                                </div>
                            </li>
                        </ul>
                    </div>

                    <div class="text-center">
                        <a href="${pageContext.request.contextPath}/ViewPrescriptionPatient" 
                           class="btn btn-detail btn-lg">
                            <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
                        </a>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- List View -->
        <c:if test="${not isDetailView}">
            <!-- Statistics -->
            <div class="stats-section slide-in">
                <div class="row">
                    <div class="col-md-4 mb-4">
                        <div class="stat-card stat-primary">
                            <div class="stat-icon icon-primary">
                                <i class="fas fa-prescription-bottle-alt"></i>
                            </div>
                            <div class="stat-number">${totalPrescriptions}</div>
                            <div class="stat-title">Tổng số đơn thuốc</div>
                        </div>
                    </div>
                    <div class="col-md-4 mb-4">
                        <div class="stat-card stat-success">
                            <div class="stat-icon icon-success">
                                <i class="fas fa-user-nurse"></i>
                            </div>
                            <div class="stat-number">${prescriptionsWithNurse}</div>
                            <div class="stat-title">Đơn có y tá phụ trách</div>
                        </div>
                    </div>
                    <div class="col-md-4 mb-4">
                        <div class="stat-card stat-warning">
                            <div class="stat-icon icon-warning">
                                <i class="fas fa-exclamation-triangle"></i>
                            </div>
                            <div class="stat-number">${prescriptionsWithoutNurse}</div>
                            <div class="stat-title">Đơn chưa có y tá</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Controls -->
            <div class="controls-section fade-in">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <div class="d-flex align-items-center flex-wrap">
                            <label for="pageSize" class="form-label me-3 mb-0 fw-bold">
                                <i class="fas fa-list me-2 text-primary-custom"></i>Hiển thị:
                            </label>
                            <select id="pageSize" class="form-select form-select-sm w-auto me-3" onchange="changePageSize()">
                                <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                                <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                                <option value="30" ${pageSize == 30 ? 'selected' : ''}>30</option>
                                <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                            </select>
                            <span class="text-muted fw-semibold">đơn thuốc mỗi trang</span>
                        </div>
                    </div>
                    <div class="col-md-6 text-md-end mt-3 mt-md-0">
                        <button class="btn btn-refresh" onclick="location.reload()">
                            <i class="fas fa-sync-alt me-2"></i>Làm mới dữ liệu
                        </button>
                    </div>
                </div>
            </div>

            <!-- Prescriptions List -->
            <div class="row">
                <c:choose>
                    <c:when test="${empty prescriptions}">
                        <div class="col-12">
                            <div class="empty-state fade-in">
                                <div class="empty-icon">
                                    <i class="fas fa-prescription-bottle-alt"></i>
                                </div>
                                <h3 class="empty-title">Chưa có đơn thuốc nào</h3>
                                <p class="empty-subtitle">
                                    Các đơn thuốc được kê bởi bác sĩ sẽ xuất hiện tại đây.<br>
                                    Hãy đặt lịch khám để nhận tư vấn và điều trị.
                                </p>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="prescription" items="${prescriptions}" varStatus="status">
                            <div class="col-lg-6 col-xl-4 mb-4">
                                <div class="prescription-card fade-in" style="animation-delay: ${status.index * 0.1}s">
                                    <div class="card-header">
                                        <h5 class="prescription-id">
                                            <i class="fas fa-prescription-bottle-alt me-2"></i>
                                            Đơn thuốc #${prescription.prescriptionId}
                                        </h5>
                                    </div>
                                    <div class="card-body">
                                        <!-- Doctor Info -->
                                        <div class="doctor-info border-left-primary">
                                            <div class="doctor-name mb-3">
                                                <i class="fas fa-user-md me-2"></i>
                                                ${prescription.doctorName}
                                            </div>
                                            <div class="info-item">
                                                <i class="fas fa-user-nurse info-icon"></i>
                                                <span>Y tá: ${prescription.nurseName != null ? prescription.nurseName : 'Chưa có'}</span>
                                            </div>
                                            <div class="info-item">
                                                <i class="fas fa-calendar-day info-icon"></i>
                                                <span>Mã lịch hẹn: ${prescription.appointmentId != null ? prescription.appointmentId : 'Không có'}</span>
                                            </div>
                                        </div>

                                        <!-- Diagnosis Preview -->
                                        <div class="diagnosis-section border-left-success">
                                            <h6 class="diagnosis-title">
                                                <i class="fas fa-notes-medical me-2"></i>
                                                Chẩn đoán
                                            </h6>
                                            <p class="diagnosis-preview">
                                                ${prescription.diagnosis != null ? prescription.diagnosis : 'Không có thông tin chẩn đoán'}
                                            </p>
                                        </div>
                                    </div>

                                    <!-- Card Footer -->
                                    <div class="card-footer">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <div class="timestamp">
                                                    <i class="fas fa-calendar-plus me-2"></i>
                                                    <strong>Tạo:</strong> ${prescription.createdAt != null ? prescription.createdAt.toString().substring(0, 16).replace('T', ' ') : 'Không có'}
                                                </div>
                                                <div class="timestamp">
                                                    <i class="fas fa-clock me-2"></i>
                                                    <strong>Cập nhật:</strong> ${prescription.updatedAt != null ? prescription.updatedAt.toString().substring(0, 16).replace('T', ' ') : 'Không có'}
                                                </div>
                                            </div>
                                            <a href="${pageContext.request.contextPath}/ViewPrescriptionPatient?action=detail&prescriptionId=${prescription.prescriptionId}" 
                                               class="btn btn-detail">
                                                <i class="fas fa-eye me-2"></i>Chi tiết
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <div class="d-flex justify-content-center mb-4">
                    <nav aria-label="Page navigation">
                        <ul class="pagination">
                            <!-- Previous Button -->
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage - 1}&pageSize=${pageSize}">
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
                                        <span class="page-link">...</span>
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
                                        <span class="page-link">...</span>
                                    </li>
                                </c:if>
                                <li class="page-item">
                                    <a class="page-link" href="?page=${totalPages}&pageSize=${pageSize}">${totalPages}</a>
                                </li>
                            </c:if>

                            <!-- Next Button -->
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage + 1}&pageSize=${pageSize}">
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </div>

                <!-- Pagination Info -->
                <div class="text-center">
                    <div class="pagination-info">
                        <i class="fas fa-info-circle me-2 text-primary-custom"></i>
                        <strong>Hiển thị ${(currentPage - 1) * pageSize + 1} - 
                        ${currentPage * pageSize > totalPrescriptions ? totalPrescriptions : currentPage * pageSize} 
                        trong tổng số ${totalPrescriptions} đơn thuốc</strong>
                    </div>
                </div>
            </c:if>
        </c:if>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function changePageSize() {
            const pageSize = document.getElementById('pageSize').value;
            const url = new URL(window.location);
            url.searchParams.set('page', '1');
            url.searchParams.set('pageSize', pageSize);
            window.location.href = url.toString();
        }

        // Enhanced JavaScript functionality
        document.addEventListener('DOMContentLoaded', function() {
            // Add loading state to buttons
            const detailButtons = document.querySelectorAll('.btn-detail');
            detailButtons.forEach(button => {
                button.addEventListener('click', function(e) {
                    const icon = this.querySelector('i');
                    const originalClass = icon.className;
                    icon.className = 'loading me-2';
                    
                    // Restore icon after delay if navigation fails
                    setTimeout(() => {
                        icon.className = originalClass;
                    }, 3000);
                });
            });

            // Smooth scroll for pagination
            const pageLinks = document.querySelectorAll('.page-link');
            pageLinks.forEach(link => {
                link.addEventListener('click', function() {
                    window.scrollTo({ top: 0, behavior: 'smooth' });
                });
            });

            // Card animations on scroll
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

            // Apply scroll animations to cards
            const cards = document.querySelectorAll('.prescription-card, .stat-card');
            cards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(30px)';
                card.style.transition = `opacity 0.8s ease ${index * 0.1}s, transform 0.8s ease ${index * 0.1}s`;
                observer.observe(card);
            });

            // Enhanced hover effects for stat cards
            const statCards = document.querySelectorAll('.stat-card');
            statCards.forEach(card => {
                card.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-5px)';
                    this.style.boxShadow = 'var(--shadow-lg)';
                });
                
                card.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                    this.style.boxShadow = 'var(--shadow-sm)';
                });
            });

            // Page size change with loading indicator
            const pageSelect = document.getElementById('pageSize');
            if (pageSelect) {
                pageSelect.addEventListener('change', function() {
                    const selectedValue = this.value;
                    const loadingDiv = document.createElement('div');
                    loadingDiv.className = 'd-flex align-items-center ms-3';
                    loadingDiv.innerHTML = '<div class="loading me-2"></div><span class="text-muted">Đang tải...</span>';
                    this.parentElement.appendChild(loadingDiv);
                });
            }

            // Refresh button animation
            const refreshButton = document.querySelector('.btn-refresh');
            if (refreshButton) {
                refreshButton.addEventListener('click', function() {
                    const icon = this.querySelector('i');
                    icon.style.animation = 'spin 1s linear infinite';
                    
                    setTimeout(() => {
                        icon.style.animation = '';
                    }, 1000);
                });
            }

            // Keyboard shortcuts
            document.addEventListener('keydown', function(e) {
                if (e.ctrlKey && e.key === 'r') {
                    e.preventDefault();
                    location.reload();
                }
                
                // Navigate pages with arrow keys
                if (e.altKey) {
                    if (e.key === 'ArrowLeft') {
                        const prevLink = document.querySelector('.page-item:not(.disabled) .page-link[href*="page=' + (parseInt('${currentPage}') - 1) + '"]');
                        if (prevLink) prevLink.click();
                    } else if (e.key === 'ArrowRight') {
                        const nextLink = document.querySelector('.page-item:not(.disabled) .page-link[href*="page=' + (parseInt('${currentPage}') + 1) + '"]');
                        if (nextLink) nextLink.click();
                    }
                }
            });

            // Card interaction effects
            const prescriptionCards = document.querySelectorAll('.prescription-card');
            prescriptionCards.forEach(card => {
                card.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-8px)';
                    this.style.boxShadow = 'var(--shadow-lg)';
                    this.style.borderColor = 'var(--primary-color)';
                });
                
                card.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                    this.style.boxShadow = 'var(--shadow-sm)';
                    this.style.borderColor = 'var(--border-color)';
                });
            });

            // Info cards hover effects
            const infoCards = document.querySelectorAll('.info-card');
            infoCards.forEach(card => {
                card.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-3px)';
                    this.style.boxShadow = 'var(--shadow-md)';
                });
                
                card.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                    this.style.boxShadow = 'none';
                });
            });

            // Detail list items interaction
            const detailListItems = document.querySelectorAll('.detail-list-item');
            detailListItems.forEach(item => {
                item.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateX(5px)';
                    this.style.boxShadow = 'var(--shadow-sm)';
                    this.style.borderColor = 'var(--primary-color)';
                });
                
                item.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateX(0)';
                    this.style.boxShadow = 'none';
                    this.style.borderColor = 'var(--border-color)';
                });
            });

            // Add tooltips for truncated text
            const diagnosisPreviews = document.querySelectorAll('.diagnosis-preview');
            diagnosisPreviews.forEach(preview => {
                if (preview.scrollHeight > preview.clientHeight) {
                    preview.title = preview.textContent;
                }
            });

            // Auto-hide alerts
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                setTimeout(() => {
                    if (alert.classList.contains('show')) {
                        alert.classList.remove('show');
                        setTimeout(() => alert.remove(), 150);
                    }
                }, 5000);
            });
        });

        // Print functionality
        function printPage() {
            window.print();
        }

        // Export functionality placeholder
        function exportData(format) {
            console.log('Exporting data in format:', format);
            // Implementation would go here
        }
    </script>
</body>
</html>
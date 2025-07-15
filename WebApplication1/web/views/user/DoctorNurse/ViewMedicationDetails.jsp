<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chi Tiết Thuốc - Hệ Thống Y Tế</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            :root {
                --primary-blue: #2563eb;
                --primary-blue-dark: #1d4ed8;
                --secondary-blue: #3b82f6;
                --light-blue: #dbeafe;
                --green-success: #10b981;
                --orange-warning: #f59e0b;
                --red-danger: #ef4444;
                --gray-50: #f9fafb;
                --gray-100: #f3f4f6;
                --gray-200: #e5e7eb;
                --gray-300: #d1d5db;
                --gray-600: #4b5563;
                --gray-700: #374151;
                --gray-800: #1f2937;
                --gray-900: #111827;
                --white: #ffffff;
                --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
                --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', sans-serif;
                background-color: var(--gray-50);
                color: var(--gray-800);
                line-height: 1.6;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
            }

            /* Header */
            .header {
                background: var(--white);
                border-bottom: 1px solid var(--gray-200);
                box-shadow: var(--shadow-sm);
                position: sticky;
                top: 0;
                z-index: 100;
            }

            .header-container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 1rem 2rem;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .logo {
                display: flex;
                align-items: center;
                gap: 0.75rem;
                font-size: 1.5rem;
                font-weight: 700;
                color: var(--primary-blue);
            }

            .logo i {
                font-size: 1.8rem;
                color: var(--green-success);
            }

            .user-info {
                display: flex;
                align-items: center;
                gap: 1rem;
                color: var(--gray-600);
            }

            .user-role {
                background: var(--light-blue);
                color: var(--primary-blue);
                padding: 0.25rem 0.75rem;
                border-radius: 1rem;
                font-size: 0.875rem;
                font-weight: 500;
            }

            /* Main Content */
            .main-content {
                flex: 1;
                padding: 2rem 0;
            }

            .container {
                max-width: 1000px;
                margin: 0 auto;
                padding: 0 2rem;
            }

            /* Breadcrumb */
            .breadcrumb {
                background: var(--white);
                padding: 1rem 1.5rem;
                border-radius: 0.5rem;
                margin-bottom: 1.5rem;
                box-shadow: var(--shadow-sm);
                display: flex;
                align-items: center;
                gap: 0.5rem;
                font-size: 0.875rem;
            }

            .breadcrumb a {
                color: var(--primary-blue);
                text-decoration: none;
                font-weight: 500;
            }

            .breadcrumb a:hover {
                text-decoration: underline;
            }

            .breadcrumb span {
                color: var(--gray-600);
            }

            /* Error Message */
            .error-message {
                background: #fef2f2;
                border: 1px solid #fecaca;
                color: var(--red-danger);
                padding: 1rem;
                border-radius: 0.5rem;
                margin-bottom: 1.5rem;
                display: flex;
                align-items: center;
                gap: 0.75rem;
            }

            /* Medication Card */
            .medication-card {
                background: var(--white);
                border-radius: 0.75rem;
                box-shadow: var(--shadow-md);
                overflow: hidden;
            }

            .card-header {
                background: linear-gradient(135deg, var(--primary-blue) 0%, var(--secondary-blue) 100%);
                color: var(--white);
                padding: 2rem;
            }

            .medication-header {
                display: flex;
                align-items: center;
                gap: 1.5rem;
            }

            .medication-icon {
                width: 60px;
                height: 60px;
                background: rgba(255, 255, 255, 0.2);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.5rem;
            }

            .medication-info h1 {
                font-size: 1.75rem;
                font-weight: 700;
                margin-bottom: 0.25rem;
            }

            .medication-id {
                font-size: 0.9rem;
                opacity: 0.9;
            }

            .card-body {
                padding: 2rem;
            }

            /* Details Grid */
            .details-section {
                margin-bottom: 2rem;
            }

            .section-title {
                font-size: 1.125rem;
                font-weight: 600;
                color: var(--gray-800);
                margin-bottom: 1rem;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .details-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 1.5rem;
            }

            .detail-item {
                background: var(--gray-50);
                padding: 1.25rem;
                border-radius: 0.5rem;
                border-left: 4px solid var(--primary-blue);
            }

            .detail-label {
                font-size: 0.875rem;
                font-weight: 500;
                color: var(--gray-600);
                margin-bottom: 0.25rem;
            }

            .detail-value {
                font-size: 1rem;
                font-weight: 600;
                color: var(--gray-800);
            }

            .price-value {
                color: var(--green-success);
                font-size: 1.125rem;
            }

            .status-badge {
                display: inline-block;
                padding: 0.25rem 0.75rem;
                border-radius: 1rem;
                font-size: 0.75rem;
                font-weight: 600;
                text-transform: uppercase;
            }

            .status-active {
                background: #dcfce7;
                color: var(--green-success);
            }

            .status-inactive {
                background: #fee2e2;
                color: var(--red-danger);
            }

            /* Description */
            .description-section {
                background: var(--gray-50);
                padding: 1.5rem;
                border-radius: 0.5rem;
                margin-top: 1.5rem;
            }

            .description-text {
                color: var(--gray-700);
                line-height: 1.7;
            }

            /* Action Buttons */
            .action-section {
                background: var(--gray-50);
                padding: 1.5rem 2rem;
                border-top: 1px solid var(--gray-200);
            }

            .action-buttons {
                display: flex;
                gap: 1rem;
                justify-content: space-between;
                flex-wrap: wrap;
            }

            .btn-group-left {
                display: flex;
                gap: 1rem;
            }

            .btn {
                padding: 0.75rem 1.5rem;
                border: none;
                border-radius: 0.5rem;
                font-weight: 500;
                font-size: 0.875rem;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                transition: all 0.2s ease;
                cursor: pointer;
            }

            .btn-primary {
                background: var(--primary-blue);
                color: var(--white);
            }

            .btn-primary:hover {
                background: var(--primary-blue-dark);
            }

            .btn-secondary {
                background: var(--white);
                color: var(--gray-700);
                border: 1px solid var(--gray-300);
            }

            .btn-secondary:hover {
                background: var(--gray-50);
            }

            .btn-success {
                background: var(--green-success);
                color: var(--white);
            }

            .btn-success:hover {
                background: #059669;
            }

            .btn-warning {
                background: var(--orange-warning);
                color: var(--white);
            }

            .btn-warning:hover {
                background: #d97706;
            }

            /* Footer */
            .footer {
                background: var(--gray-800);
                color: var(--gray-300);
                padding: 2rem 0 1rem;
                margin-top: auto;
            }

            .footer-container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 2rem;
            }

            .footer-content {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 2rem;
                margin-bottom: 1.5rem;
            }

            .footer-section h3 {
                color: var(--white);
                font-size: 1rem;
                font-weight: 600;
                margin-bottom: 1rem;
            }

            .footer-section p,
            .footer-section a {
                color: var(--gray-300);
                text-decoration: none;
                font-size: 0.875rem;
                margin-bottom: 0.5rem;
                display: block;
            }

            .footer-section a:hover {
                color: var(--white);
            }

            .footer-bottom {
                border-top: 1px solid var(--gray-700);
                padding-top: 1rem;
                text-align: center;
                font-size: 0.875rem;
                color: var(--gray-400);
            }

            /* Responsive */
            @media (max-width: 768px) {
                .header-container {
                    padding: 1rem;
                    flex-direction: column;
                    gap: 1rem;
                }

                .container {
                    padding: 0 1rem;
                }

                .medication-header {
                    flex-direction: column;
                    text-align: center;
                }

                .details-grid {
                    grid-template-columns: 1fr;
                }

                .action-buttons {
                    flex-direction: column;
                }

                .btn-group-left {
                    flex-direction: column;
                }
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <header class="header">
            <div class="header-container">
                <div class="logo">
                    <i class="fas fa-hospital"></i>
                    <span>MediSystem</span>
                </div>
                <div class="user-info">
                    <span class="user-role">
                        <i class="fas fa-user-md"></i> Doctor/Nurse
                    </span>
                    <span><i class="fas fa-clock"></i> ${pageContext.session.getAttribute("currentTime")}</span>
                </div>
            </div>
        </header>

        <!-- Main Content -->
        <main class="main-content">
            <div class="container">
                <!-- Breadcrumb -->
                <nav class="breadcrumb">
                    <a href="${pageContext.request.contextPath}/ViewMedicationsServlet">
                        <i class="fas fa-pills"></i> Danh Sách Thuốc
                    </a>
                    <span><i class="fas fa-chevron-right"></i></span>
                    <span>Chi Tiết Thuốc</span>
                </nav>

                <!-- Error Message -->
                <c:if test="${not empty errorMessage}">
                    <div class="error-message">
                        <i class="fas fa-exclamation-triangle"></i>
                        <div>
                            <strong>Lỗi!</strong> ${errorMessage}
                        </div>
                    </div>
                </c:if>

                <!-- Medication Details -->
                <c:if test="${empty errorMessage and not empty medication}">
                    <div class="medication-card">
                        <!-- Card Header -->
                        <div class="card-header">
                            <div class="medication-header">
                                <div class="medication-icon">
                                    <i class="fas fa-prescription-bottle-alt"></i>
                                </div>
                                <div class="medication-info">
                                    <h1>${medication.name}</h1>
                                    <p class="medication-id">Mã thuốc: ${medication.medicationID}</p>
                                </div>
                            </div>
                        </div>

                        <!-- Card Body -->
                        <div class="card-body">
                            <!-- Basic Information -->
                            <div class="details-section">
                                <h2 class="section-title">
                                    <i class="fas fa-info-circle"></i>
                                    Thông Tin Cơ Bản
                                </h2>
                                <div class="details-grid">
                                    <div class="detail-item">
                                        <div class="detail-label">Hàm Lượng</div>
                                        <div class="detail-value">${medication.dosage}</div>
                                    </div>
                                    <div class="detail-item">
                                        <div class="detail-label">Dạng Bào Chế</div>
                                        <div class="detail-value">${medication.dosageForm != null ? medication.dosageForm : 'Chưa cập nhật'}</div>
                                    </div>
                                    <div class="detail-item">
                                        <div class="detail-label">Trạng Thái</div>
                                        <div class="detail-value">
                                            <span class="status-badge ${medication.status == 'Active' ? 'status-active' : 'status-inactive'}">
                                                ${medication.status != null ? medication.status : 'Không xác định'}
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        

                            <!-- Description -->
                            <div class="description-section">
                                <h2 class="section-title">
                                    <i class="fas fa-file-medical-alt"></i>
                                    Mô Tả & Hướng Dẫn Sử Dụng
                                </h2>
                                <p class="description-text">
                                    ${medication.description != null ? medication.description : 'Chưa có thông tin mô tả chi tiết. Vui lòng tham khảo hướng dẫn sử dụng trên bao bì hoặc liên hệ dược sĩ để biết thêm thông tin về cách sử dụng, liều lượng và các lưu ý đặc biệt.'}
                                </p>
                            </div>
                        </div>

                       
                   


                        <!-- Action Buttons -->
                        <div class="action-section">
                            <div class="action-buttons">
                                <div class="btn-group-left">
                                    <a href="${pageContext.request.contextPath}/ViewMedicationsServlet" class="btn btn-secondary">
                                        <i class="fas fa-arrow-left"></i>
                                        Quay Lại Danh Sách
                                    </a>
                                    <button class="btn btn-primary" onclick="window.print()">
                                        <i class="fas fa-print"></i>
                                        In Thông Tin
                                    </button>
                                </div>

                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
        </main>

        <!-- Footer -->
        <footer class="footer">
            <div class="footer-container">
                <div class="footer-content">
                    <div class="footer-section">
                        <h3><i class="fas fa-hospital"></i> MediSystem</h3>
                        <p>Hệ thống quản lý y tế tích hợp, hỗ trợ bác sĩ và điều dưỡng trong công tác chăm sóc bệnh nhân.</p>
                        <p><i class="fas fa-phone"></i> Hotline: 1900-2468</p>
                    </div>
                    <div class="footer-section">
                        <h3>Chức Năng Chính</h3>
                        <a href="#"><i class="fas fa-pills"></i> Quản Lý Thuốc</a>
                        <a href="#"><i class="fas fa-user-injured"></i> Hồ Sơ Bệnh Nhân</a>
                        <a href="#"><i class="fas fa-prescription"></i> Kê Đơn Thuốc</a>
                    </div>
                    <div class="footer-section">
                        <h3>Hỗ Trợ Kỹ Thuật</h3>
                        <a href="#"><i class="fas fa-question-circle"></i> Hướng Dẫn Sử Dụng</a>
                        <a href="#"><i class="fas fa-headset"></i> Hỗ Trợ Trực Tuyến</a>
                        <a href="#"><i class="fas fa-bug"></i> Báo Lỗi Hệ Thống</a>
                    </div>
                </div>

            </div>
        </footer>


    </body>
</html>
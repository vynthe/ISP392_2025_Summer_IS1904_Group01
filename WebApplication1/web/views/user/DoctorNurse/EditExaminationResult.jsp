<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh Sửa Kết Quả Khám - Nha Khoa PDC</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-blue: #0066cc;
            --primary-blue-dark: #004499;
            --primary-blue-light: #e6f3ff;
            --success-green: #10b981;
            --warning-orange: #f59e0b;
            --danger-red: #ef4444;
            --neutral-50: #f8fafc;
            --neutral-100: #f1f5f9;
            --neutral-200: #e2e8f0;
            --neutral-300: #cbd5e1;
            --neutral-400: #94a3b8;
            --neutral-500: #64748b;
            --neutral-600: #475569;
            --neutral-700: #334155;
            --neutral-800: #1e293b;
            --neutral-900: #0f172a;
            --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
            --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
            --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
            --shadow-xl: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);
            --border-radius: 12px;
            --border-radius-lg: 16px;
            --transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, var(--neutral-50) 0%, #ffffff 100%);
            color: var(--neutral-700);
            line-height: 1.6;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* Enhanced Header */
        .header {
            background: linear-gradient(135deg, var(--primary-blue) 0%, var(--primary-blue-dark) 100%);
            color: white;
            padding: 0;
            box-shadow: var(--shadow-lg);
            position: sticky;
            top: 0;
            z-index: 100;
            backdrop-filter: blur(20px);
        }

        .header-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 16px 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            display: flex;
            align-items: center;
            font-size: 1.75rem;
            font-weight: 700;
            color: white;
            text-decoration: none;
        }

        .logo i {
            margin-right: 12px;
            font-size: 2rem;
            background: linear-gradient(45deg, #4ecdc4, #44a08d);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .nav-links {
            display: flex;
            list-style: none;
            gap: 8px;
            align-items: center;
        }

        .nav-links a {
            color: rgba(255, 255, 255, 0.9);
            text-decoration: none;
            font-weight: 500;
            font-size: 0.95rem;
            padding: 10px 16px;
            border-radius: var(--border-radius);
            transition: var(--transition);
            position: relative;
            overflow: hidden;
        }

        .nav-links a::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.1);
            transform: translateX(-100%);
            transition: transform 0.3s ease;
        }

        .nav-links a:hover::before {
            transform: translateX(0);
        }

        .nav-links a:hover {
            color: white;
            background: rgba(255, 255, 255, 0.15);
            transform: translateY(-1px);
        }

        /* Main Content with improved layout */
        .main-content {
            flex: 1;
            padding: 48px 24px;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            min-height: calc(100vh - 200px);
        }

        .page-container {
            width: 100%;
            max-width: 900px;
        }

        .page-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .page-title {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--neutral-800);
            margin-bottom: 8px;
            background: linear-gradient(135deg, var(--primary-blue), var(--primary-blue-dark));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .page-subtitle {
            font-size: 1.125rem;
            color: var(--neutral-500);
            font-weight: 400;
        }

        .form-container {
            background: white;
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-xl);
            overflow: hidden;
            border: 1px solid var(--neutral-200);
            position: relative;
        }

        .form-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-blue), var(--success-green), var(--primary-blue));
        }

        .form-header {
            background: linear-gradient(135deg, var(--neutral-50), white);
            padding: 32px;
            border-bottom: 1px solid var(--neutral-200);
            text-align: center;
        }

        .form-header h2 {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--neutral-800);
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
        }

        .form-header h2 i {
            color: var(--primary-blue);
            font-size: 1.25rem;
        }

        .form-header p {
            color: var(--neutral-500);
            font-size: 0.95rem;
            font-weight: 400;
        }

        .form-body {
            padding: 40px;
        }

        .form-grid {
            display: grid;
            gap: 32px;
        }

        .form-section {
            background: var(--neutral-50);
            padding: 24px;
            border-radius: var(--border-radius);
            border: 1px solid var(--neutral-200);
        }

        .section-title {
            font-size: 1.125rem;
            font-weight: 600;
            color: var(--neutral-800);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .section-title i {
            color: var(--primary-blue);
        }

        .form-group {
            margin-bottom: 24px;
        }

        .form-group:last-child {
            margin-bottom: 0;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: var(--neutral-700);
            font-size: 0.95rem;
        }

        .label-required::after {
            content: ' *';
            color: var(--danger-red);
        }

        .form-control {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid var(--neutral-200);
            border-radius: var(--border-radius);
            font-size: 0.95rem;
            font-family: inherit;
            transition: var(--transition);
            background: white;
            color: var(--neutral-700);
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary-blue);
            box-shadow: 0 0 0 3px rgba(0, 102, 204, 0.1);
            background: white;
        }

        .form-control[readonly] {
            background: var(--neutral-100);
            color: var(--neutral-500);
            cursor: not-allowed;
            border-color: var(--neutral-300);
        }

        .form-control[readonly]:focus {
            border-color: var(--neutral-300);
            box-shadow: none;
        }

        textarea.form-control {
            height: 140px;
            resize: vertical;
            min-height: 100px;
            font-family: inherit;
        }

        .input-icon {
            position: relative;
        }

        .input-icon i {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--neutral-400);
            font-size: 0.9rem;
        }

        .input-icon .form-control {
            padding-left: 44px;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
            gap: 6px;
        }

        .status-completed {
            background: var(--primary-blue-light);
            color: var(--primary-blue-dark);
        }

        .error-message {
            background: #fef2f2;
            color: var(--danger-red);
            padding: 16px;
            border-radius: var(--border-radius);
            margin-bottom: 24px;
            border-left: 4px solid var(--danger-red);
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .success-message {
            background: #f0fdf4;
            color: var(--success-green);
            padding: 16px;
            border-radius: var(--border-radius);
            margin-bottom: 24px;
            border-left: 4px solid var(--success-green);
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 16px;
            margin-top: 40px;
            padding-top: 32px;
            border-top: 1px solid var(--neutral-200);
        }

        .btn {
            padding: 14px 28px;
            border: none;
            border-radius: var(--border-radius);
            cursor: pointer;
            font-weight: 500;
            font-size: 0.95rem;
            font-family: inherit;
            transition: var(--transition);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            position: relative;
            overflow: hidden;
            min-width: 140px;
            justify-content: center;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s ease;
        }

        .btn:hover::before {
            left: 100%;
        }

        .btn-secondary {
            background: var(--neutral-100);
            color: var(--neutral-600);
            border: 2px solid var(--neutral-300);
        }

        .btn-secondary:hover {
            background: var(--neutral-200);
            color: var(--neutral-700);
            border-color: var(--neutral-400);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-blue), var(--primary-blue-dark));
            color: white;
            border: 2px solid transparent;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
            background: linear-gradient(135deg, var(--primary-blue-dark), var(--primary-blue));
        }

        .btn-success {
            background: linear-gradient(135deg, var(--success-green), #059669);
            color: white;
            border: 2px solid transparent;
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
            background: linear-gradient(135deg, #059669, var(--success-green));
        }

        .btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            transform: none !important;
        }

        .btn-loading {
            position: relative;
            color: transparent;
        }

        .btn-loading::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 20px;
            height: 20px;
            border: 2px solid rgba(255,255,255,0.3);
            border-top-color: white;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            to { transform: translate(-50%, -50%) rotate(360deg); }
        }

        /* Enhanced Footer */
        footer {
            background: linear-gradient(135deg, var(--neutral-800), var(--neutral-900));
            color: white;
            padding: 60px 0 20px;
            margin-top: auto;
        }

        .footer-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 24px;
        }

        .footer-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 40px;
            margin-bottom: 40px;
        }

        .footer-section h3 {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 20px;
            color: white;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .footer-section h3 i {
            color: var(--primary-blue);
        }

        .footer-section p {
            line-height: 1.7;
            margin-bottom: 16px;
            color: var(--neutral-300);
        }

        .footer-links {
            list-style: none;
        }

        .footer-links li {
            margin-bottom: 12px;
        }

        .footer-links a {
            color: var(--neutral-300);
            text-decoration: none;
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 4px 0;
        }

        .footer-links a:hover {
            color: white;
            transform: translateX(4px);
        }

        .footer-links i {
            width: 16px;
            color: var(--primary-blue);
        }

        .social-links {
            display: flex;
            gap: 12px;
            margin-top: 20px;
        }

        .social-links a {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 44px;
            height: 44px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: var(--border-radius);
            color: white;
            text-decoration: none;
            transition: var(--transition);
        }

        .social-links a:hover {
            background: var(--primary-blue);
            transform: translateY(-2px);
        }

        .footer-bottom {
            border-top: 1px solid var(--neutral-700);
            padding-top: 24px;
            text-align: center;
            color: var(--neutral-400);
        }

        /* Responsive Design */
        @media (max-width: 1024px) {
            .header-container {
                padding: 16px 20px;
            }
            
            .main-content {
                padding: 32px 20px;
            }
            
            .form-body {
                padding: 32px 24px;
            }
        }

        @media (max-width: 768px) {
            .header-container {
                flex-direction: column;
                gap: 16px;
            }

            .nav-links {
                gap: 4px;
                flex-wrap: wrap;
                justify-content: center;
            }

            .main-content {
                padding: 24px 16px;
            }

            .page-title {
                font-size: 2rem;
            }

            .form-container {
                margin: 0;
            }

            .form-body {
                padding: 24px 20px;
            }

            .form-actions {
                flex-direction: column-reverse;
                gap: 12px;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }

            .footer-content {
                grid-template-columns: 1fr;
                gap: 32px;
                text-align: center;
            }
        }

        @media (max-width: 480px) {
            .page-title {
                font-size: 1.75rem;
            }

            .form-header {
                padding: 24px 20px;
            }

            .form-body {
                padding: 20px 16px;
            }
        }

        /* Animations */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .form-container {
            animation: fadeInUp 0.6s ease-out;
        }

        .form-group {
            animation: fadeInUp 0.6s ease-out;
            animation-fill-mode: both;
        }

        .form-group:nth-child(1) { animation-delay: 0.1s; }
        .form-group:nth-child(2) { animation-delay: 0.2s; }
        .form-group:nth-child(3) { animation-delay: 0.3s; }
        .form-group:nth-child(4) { animation-delay: 0.4s; }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="header-container">
            <a href="${pageContext.request.contextPath}/views/common/HomePage.jsp" class="logo">
                <i class="fas fa-tooth"></i>
                Nha Khoa PDC
            </a>

        </div>
    </header>

    <!-- Main Content -->
    <main class="main-content">
        <div class="page-container">
            <div class="page-header">
                <h1 class="page-title">Chỉnh Sửa Kết Quả Khám</h1>
                <p class="page-subtitle">Cập nhật thông tin chi tiết về kết quả khám bệnh</p>
            </div>

            <div class="form-container">
                <div class="form-header">
                    <h2>
                        <i class="fas fa-edit"></i>
                        Biểu Mẫu Chỉnh Sửa
                    </h2>
                    <p>Vui lòng kiểm tra và cập nhật thông tin một cách chính xác</p>
                </div>

                <div class="form-body">
                    <!-- Error Message -->
                    <c:if test="${not empty errorMessage}">
                        <div class="error-message">
                            <i class="fas fa-exclamation-triangle"></i>
                            ${errorMessage}
                        </div>
                    </c:if>

                    <!-- Success Message -->
                    <c:if test="${not empty successMessage}">
                        <div class="success-message">
                            <i class="fas fa-check-circle"></i>
                            ${successMessage}
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/EditExaminationResultServlet" method="post" id="editForm">
                        <input type="hidden" name="appointmentId" value="${resultDetails.appointmentId}" />
                        
                        <div class="form-grid">
                            <!-- Thông tin cơ bản -->
                            <div class="form-section">
                                <h3 class="section-title">
                                    <i class="fas fa-info-circle"></i>
                                    Thông Tin Cơ Bản
                                </h3>
                                
                                <div class="form-group">
                                    <label for="status" class="form-label">Trạng Thái Khám</label>
                                    <div class="input-icon">
                                        <i class="fas fa-check-circle"></i>
                                        <input type="text" 
                                               id="status" 
                                               name="status" 
                                               class="form-control" 
                                               value="${resultDetails.status}" 
                                               readonly />
                                    </div>
                                    <div class="status-badge status-completed" style="margin-top: 8px;">
                                        <i class="fas fa-check"></i>
                                        Đã hoàn thành
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="diagnosis" class="form-label">Chẩn Đoán</label>
                                    <div class="input-icon">
                                        <i class="fas fa-stethoscope"></i>
                                        <input type="text" 
                                               id="diagnosis" 
                                               name="diagnosis" 
                                               class="form-control" 
                                               value="${resultDetails.diagnosis}" 
                                               readonly />
                                    </div>
                                </div>
                            </div>

                            <!-- Ghi chú -->
                            <div class="form-section">
                                <h3 class="section-title">
                                    <i class="fas fa-sticky-note"></i>
                                    Ghi Chú Chi Tiết
                                </h3>
                                
                                <div class="form-group">
                                    <label for="notes" class="form-label">Ghi Chú Khám Bệnh</label>
                                    <textarea id="notes" 
                                              name="notes" 
                                              class="form-control" 
                                              placeholder="Nhập ghi chú chi tiết về tình trạng bệnh nhân, các khuyến nghị điều trị, lưu ý đặc biệt..."
                                              rows="6">${resultDetails.notes}</textarea>
                                    <small style="color: var(--neutral-500); font-size: 0.85rem; margin-top: 4px; display: block;">
                                        Ghi chú sẽ được lưu trong hồ sơ bệnh án của bệnh nhân
                                    </small>
                                </div>
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="button" 
                                    class="btn btn-secondary" 
                                    onclick="window.location.href='${pageContext.request.contextPath}/ViewExaminationResults?appointmentId=${resultDetails.appointmentId}'">
                                <i class="fas fa-arrow-left"></i>
                                Quay Lại
                            </button>
                            <button type="submit" class="btn btn-success" id="saveBtn">
                                <i class="fas fa-save"></i>
                                Lưu Thay Đổi
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </main>

    <!-- Enhanced Footer -->
    <footer>
        <div class="footer-container">
            <div class="footer-content">
                <div class="footer-section">
                    <h3><i class="fas fa-tooth"></i> Nha Khoa PDC</h3>
                    <p>Phòng khám nha khoa hàng đầu với đội ngũ chuyên gia giàu kinh nghiệm và công nghệ hiện đại, cam kết mang lại nụ cười khỏe mạnh và tự tin cho mọi bệnh nhân.</p>
                    <div class="social-links">
                        <a href="#" title="Facebook"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" title="Zalo"><i class="fab fa-whatsapp"></i></a>
                        <a href="#" title="Instagram"><i class="fab fa-instagram"></i></a>
                        <a href="#" title="YouTube"><i class="fab fa-youtube"></i></a>
                    </div>
                </div>

                <div class="footer-section">
                    <h3><i class="fas fa-map-marker-alt"></i> Liên Hệ</h3>
                    <p><i class="fas fa-map-marker-alt"></i> ĐH FPT, Hòa Lạc, Hà Nội</p>
                    <p><i class="fas fa-phone"></i> Hotline: 1900-XXX-XXX</p>
                    <p><i class="fas fa-envelope"></i> PhongKhamPDC@gmail.com</p>
                    <p><i class="fas fa-clock"></i> 7:30 - 17:00 (T2 - T7)</p>
                </div>

                <div class="footer-section">
                    <h3><i class="fas fa-link"></i> Liên Kết</h3>
                    <ul class="footer-links">
                        <li><a href="${pageContext.request.contextPath}/views/common/HomePage.jsp"><i class="fas fa-home"></i> Trang Chủ</a></li>
                        <li><a href="${pageContext.request.contextPath}/BookMedicalGuestServlet"><i class="fas fa-calendar-check"></i> Đặt Lịch Khám</a></li>
                        <li><a href="#"><i class="fas fa-tooth"></i> Dịch Vụ</a></li>
                        <li><a href="#"><i class="fas fa-phone"></i> Liên Hệ</a></li>
                    </ul>
                </div>

                <div class="footer-section">
                    <h3><i class="fas fa-star"></i> Dịch Vụ Nổi Bật</h3>
                    <ul class="footer-links">
                        <li><a href="#"><i class="fas fa-tooth"></i> Cấy Ghép Implant</a></li>
                        <li><a href="#"><i class="fas fa-grip-lines"></i> Chỉnh Nha Mắc Cài</a></li>
                        <li><a href="#"><i class="fas fa-child"></i> Nha Khoa Trẻ Em</a></li>
                        <li><a href="#"><i class="fas fa-smile"></i> Nha Khoa Thẩm Mỹ</a></li>
                    </ul>
                </div>
            </div>

            <div class="footer-bottom">
                <p>© 2025 Nha Khoa PDC. Đạt chuẩn Bộ Y tế. Tất cả quyền được bảo lưu.</p>
            </div>
        </div>
    </footer>

    <script>
        // Enhanced form handling
        document.getElementById('editForm').addEventListener('submit', function(e) {
            const saveBtn = document.getElementById('saveBtn');
            const notes = document.getElementById('notes').value.trim();
            
            // Basic validation
            if (notes.length === 0) {
                e.preventDefault();
                showNotification('Vui lòng nhập ghi chú trước khi lưu!', 'warning');
                document.getElementById('notes').focus();
                return;
            }

            // Show loading state
            saveBtn.classList.add('btn-loading');
            saveBtn.disabled = true;
            
            // Log form submission
            console.log('Form submission:', {
                appointmentId: document.querySelector('input[name="appointmentId"]').value,
                notes: notes,
                timestamp: new Date().toISOString()
            });
        });

        // Auto-save draft functionality
        let autoSaveTimer;
        const notesField = document.getElementById('notes');
        
        notesField.addEventListener('input', function() {
            clearTimeout(autoSaveTimer);
            autoSaveTimer = setTimeout(() => {
                saveDraft();
            }, 2000);
        });

        function saveDraft() {
            const notes = notesField.value;
            const appointmentId = document.querySelector('input[name="appointmentId"]').value;
            
            // Save to memory (since localStorage is not available)
            window.tempDraft = {
                appointmentId: appointmentId,
                notes: notes,
                timestamp: Date.now()
            };
            
            showNotification('Bản nháp đã được lưu tự động', 'info', 2000);
        }

        // Load draft on page load
        window.addEventListener('load', function() {
            if (window.tempDraft) {
                const currentAppointmentId = document.querySelector('input[name="appointmentId"]').value;
                if (window.tempDraft.appointmentId === currentAppointmentId) {
                    // Check if draft is recent (within 1 hour)
                    const hourAgo = Date.now() - (60 * 60 * 1000);
                    if (window.tempDraft.timestamp > hourAgo) {
                        notesField.value = window.tempDraft.notes;
                        showNotification('Đã khôi phục bản nháp trước đó', 'info');
                    }
                }
            }
        });

        // Enhanced notification system
        function showNotification(message, type = 'info', duration = 4000) {
            // Remove existing notifications
            const existingNotifications = document.querySelectorAll('.notification');
            existingNotifications.forEach(notif => notif.remove());

            const notification = document.createElement('div');
            notification.className = `notification notification-${type}`;
            
            const icons = {
                success: 'fas fa-check-circle',
                error: 'fas fa-exclamation-triangle',
                warning: 'fas fa-exclamation-circle',
                info: 'fas fa-info-circle'
            };

            // Determine border color based on type
            let borderColor;
            switch(type) {
                case 'success':
                    borderColor = 'var(--success-green)';
                    break;
                case 'error':
                    borderColor = 'var(--danger-red)';
                    break;
                case 'warning':
                    borderColor = 'var(--warning-orange)';
                    break;
                default:
                    borderColor = 'var(--primary-blue)';
            }

            notification.innerHTML = `
                <div class="notification-content">
                    <i class="${icons[type]}"></i>
                    <span>${message}</span>
                    <button class="notification-close" onclick="this.parentElement.parentElement.remove()">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
            `;

            // Add notification styles
            notification.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 1000;
                background: white;
                border-radius: var(--border-radius);
                box-shadow: var(--shadow-xl);
                border-left: 4px solid ${borderColor};
                min-width: 300px;
                max-width: 500px;
                animation: slideInRight 0.3s ease-out;
                transform: translateX(100%);
                animation-fill-mode: forwards;
            `;

            const notificationContent = notification.querySelector('.notification-content');
            notificationContent.style.cssText = `
                display: flex;
                align-items: center;
                padding: 16px;
                gap: 12px;
                color: var(--neutral-700);
            `;

            const icon = notification.querySelector('i:first-child');
            
            // Set icon color based on type
            let iconColor;
            switch(type) {
                case 'success':
                    iconColor = 'var(--success-green)';
                    break;
                case 'error':
                    iconColor = 'var(--danger-red)';
                    break;
                case 'warning':
                    iconColor = 'var(--warning-orange)';
                    break;
                default:
                    iconColor = 'var(--primary-blue)';
            }
            
            icon.style.color = iconColor;

            const closeBtn = notification.querySelector('.notification-close');
            closeBtn.style.cssText = `
                background: none;
                border: none;
                color: var(--neutral-400);
                cursor: pointer;
                padding: 4px;
                margin-left: auto;
                border-radius: 4px;
                transition: var(--transition);
            `;

            closeBtn.addEventListener('mouseenter', function() {
                this.style.background = 'var(--neutral-100)';
                this.style.color = 'var(--neutral-600)';
            });

            closeBtn.addEventListener('mouseleave', function() {
                this.style.background = 'none';
                this.style.color = 'var(--neutral-400)';
            });

            document.body.appendChild(notification);

            // Auto remove after duration
            setTimeout(() => {
                if (notification.parentElement) {
                    notification.style.animation = 'slideOutRight 0.3s ease-in forwards';
                    setTimeout(() => notification.remove(), 300);
                }
            }, duration);
        }

        // Add CSS animations for notifications
        const notificationStyles = document.createElement('style');
        notificationStyles.textContent = `
            @keyframes slideInRight {
                from {
                    transform: translateX(100%);
                    opacity: 0;
                }
                to {
                    transform: translateX(0);
                    opacity: 1;
                }
            }

            @keyframes slideOutRight {
                from {
                    transform: translateX(0);
                    opacity: 1;
                }
                to {
                    transform: translateX(100%);
                    opacity: 0;
                }
            }
        `;
        document.head.appendChild(notificationStyles);

        // Character counter for textarea
        const textarea = document.getElementById('notes');
        const maxLength = 2000;
        
        // Create character counter
        const counterDiv = document.createElement('div');
        counterDiv.style.cssText = `
            text-align: right;
            font-size: 0.8rem;
            color: var(--neutral-500);
            margin-top: 4px;
        `;
        textarea.parentNode.appendChild(counterDiv);

        function updateCharacterCount() {
            const currentLength = textarea.value.length;
            counterDiv.textContent = `${currentLength}/${maxLength} ký tự`;
            
            if (currentLength > maxLength * 0.9) {
                counterDiv.style.color = 'var(--warning-orange)';
            } else if (currentLength >= maxLength) {
                counterDiv.style.color = 'var(--danger-red)';
            } else {
                counterDiv.style.color = 'var(--neutral-500)';
            }
        }

        textarea.addEventListener('input', updateCharacterCount);
        updateCharacterCount(); // Initial count

        // Prevent form submission if textarea exceeds max length
        document.getElementById('editForm').addEventListener('submit', function(e) {
            if (textarea.value.length > maxLength) {
                e.preventDefault();
                showNotification(`Ghi chú không được vượt quá ${maxLength} ký tự!`, 'error');
                textarea.focus();
                return;
            }
        });

        // Enhanced button interactions
        document.querySelectorAll('.btn').forEach(btn => {
            btn.addEventListener('mousedown', function() {
                this.style.transform = 'translateY(-1px) scale(0.98)';
            });

            btn.addEventListener('mouseup', function() {
                this.style.transform = 'translateY(-2px) scale(1)';
            });

            btn.addEventListener('mouseleave', function() {
                this.style.transform = '';
            });
        });

        // Keyboard shortcuts
        document.addEventListener('keydown', function(e) {
            // Ctrl+S to save
            if ((e.ctrlKey || e.metaKey) && e.key === 's') {
                e.preventDefault();
                document.getElementById('editForm').dispatchEvent(new Event('submit'));
            }
            
            // Escape to cancel
            if (e.key === 'Escape') {
                const cancelBtn = document.querySelector('.btn-secondary');
                if (cancelBtn) {
                    cancelBtn.click();
                }
            }
        });

        // Form validation enhancement
        function validateForm() {
            const notes = document.getElementById('notes').value.trim();
            const saveBtn = document.getElementById('saveBtn');
            
            if (notes.length === 0) {
                saveBtn.disabled = true;
                saveBtn.style.opacity = '0.5';
            } else {
                saveBtn.disabled = false;
                saveBtn.style.opacity = '1';
            }
        }

        // Initial validation
        validateForm();
        
        // Validate on input
        document.getElementById('notes').addEventListener('input', validateForm);

        // Smooth scrolling for any anchor links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });

        // Show success message if form was submitted successfully
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('success') === 'true') {
            showNotification('Kết quả khám đã được cập nhật thành công!', 'success');
        }

        // Add loading state management
        let isSubmitting = false;
        
        document.getElementById('editForm').addEventListener('submit', function(e) {
            if (isSubmitting) {
                e.preventDefault();
                return;
            }
            isSubmitting = true;
        });

        // Reset loading state if user navigates back
        window.addEventListener('pageshow', function() {
            isSubmitting = false;
            const saveBtn = document.getElementById('saveBtn');
            saveBtn.classList.remove('btn-loading');
            saveBtn.disabled = false;
        });

        console.log('Enhanced professional dental form loaded successfully');
    </script>
</body>
</html>
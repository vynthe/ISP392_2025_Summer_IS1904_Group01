<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Chi Tiết Đơn Thuốc - Phòng Khám Nha Khoa</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #1e40af;
            --primary-light: #3b82f6;
            --primary-dark: #1e3a8a;
            --secondary: #64748b;
            --accent: #059669;
            --success: #065f46;
            --error: #dc2626;
            --warning: #d97706;
            --white: #ffffff;
            --gray-50: #f9fafb;
            --gray-100: #f3f4f6;
            --gray-200: #e5e7eb;
            --gray-300: #d1d5db;
            --gray-400: #9ca3af;
            --gray-500: #6b7280;
            --gray-600: #4b5563;
            --gray-700: #374151;
            --gray-800: #1f2937;
            --gray-900: #111827;
            --gradient-primary: linear-gradient(135deg, #1e40af 0%, #3b82f6 100%);
            --gradient-accent: linear-gradient(135deg, #059669 0%, #10b981 100%);
            --shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.06);
            --shadow-md: 0 4px 16px rgba(0, 0, 0, 0.08);
            --shadow-lg: 0 10px 30px rgba(0, 0, 0, 0.12);
            --shadow-xl: 0 20px 40px rgba(0, 0, 0, 0.15);
            --border-radius: 8px;
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
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
            display: flex;
            flex-direction: column;
            color: var(--gray-900);
            line-height: 1.7;
        }

        .main-header {
            background: var(--white);
            box-shadow: var(--shadow-sm);
            position: sticky;
            top: 0;
            z-index: 1000;
            border-bottom: 2px solid var(--gray-200);
        }

        .header-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            height: 80px;
        }

        .logo-section {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .logo {
            width: 48px;
            height: 48px;
            background: var(--gradient-primary);
            border-radius: var(--border-radius);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--white);
            font-size: 1.5rem;
            font-weight: bold;
        }

        .brand-name {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--gray-800);
        }

        .nav-menu {
            display: flex;
            gap: 0.5rem;
        }

        .nav-item {
            color: var(--gray-600);
            text-decoration: none;
            font-weight: 500;
            font-size: 0.875rem;
            padding: 0.75rem 1.25rem;
            border-radius: var(--border-radius);
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 0.5rem;
            border: 1px solid transparent;
        }

        .nav-item:hover {
            color: var(--primary);
            background-color: var(--gray-100);
            border-color: var(--gray-200);
        }

        .nav-item.active {
            color: var(--white);
            background: var(--primary);
            border-color: var(--primary);
        }

        .main-wrapper {
            flex: 1;
            padding: 3rem 2rem;
            background: transparent;
        }

        .dental-container {
            background: var(--white);
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-xl);
            max-width: 800px;
            margin: 0 auto;
            border: 1px solid var(--gray-200);
            overflow: hidden;
            animation: fadeIn 0.6s ease-out;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .dental-header {
            background: var(--gradient-primary);
            padding: 2rem;
            color: var(--white);
            text-align: center;
        }

        .dental-logo {
            width: 56px;
            height: 56px;
            background: rgba(255, 255, 255, 0.15);
            border-radius: var(--border-radius);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.75rem;
            margin: 0 auto 1rem;
        }

        .page-title {
            font-size: 1.75rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .page-subtitle {
            font-size: 1rem;
            opacity: 0.9;
        }

        .content-section {
            padding: 2.5rem;
        }

        .alert {
            padding: 1.5rem;
            border-radius: var(--border-radius);
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            font-weight: 600;
            border: 2px solid;
            font-size: 1rem;
        }

        .alert-error {
            background: linear-gradient(135deg, #fef2f2 0%, #fde8e8 100%);
            color: var(--error);
            border-color: #fca5a5;
        }

        .alert-success {
            background: linear-gradient(135deg, #f0fdf4 0%, #dcfce7 100%);
            color: var(--success);
            border-color: #86efac;
        }

        .prescription-id-header {
            text-align: center;
            margin-bottom: 2.5rem;
            padding: 2rem;
            background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
            border: 3px solid var(--primary);
            border-radius: var(--border-radius);
            position: relative;
        }

        .prescription-id {
            font-size: 1.75rem;
            font-weight: 800;
            color: var(--primary);
            margin: 0;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .info-item {
            margin-bottom: 2rem;
            padding: 1.5rem;
            background: linear-gradient(135deg, #fefefe 0%, #f9fafb 100%);
            border: 1px solid var(--gray-200);
            border-radius: var(--border-radius);
            transition: var(--transition);
        }

        .info-item:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
            border-color: var(--primary-light);
        }

        .info-label {
            font-size: 0.9rem;
            font-weight: 700;
            color: var(--primary);
            text-transform: uppercase;
            letter-spacing: 0.075em;
            margin-bottom: 0.75rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .info-label::before {
            content: '';
            width: 4px;
            height: 20px;
            background: var(--gradient-primary);
            border-radius: 2px;
        }

        .info-value {
            font-size: 1.1rem;
            font-weight: 500;
            color: var(--gray-800);
            line-height: 1.6;
            padding: 1rem;
            background: var(--white);
            border-radius: var(--border-radius);
            border: 1px solid var(--gray-100);
            word-wrap: break-word;
        }

        .medication-section {
            background: linear-gradient(135deg, #f0fdf4 0%, #ecfdf5 100%);
            border: 2px solid var(--accent);
            border-radius: var(--border-radius);
            padding: 1.5rem;
            margin-bottom: 2rem;
        }

        .medication-section .info-item {
            background: linear-gradient(135deg, #ffffff 0%, #f0fdf4 100%);
            border-color: rgba(5, 150, 105, 0.2);
        }

        .medication-section .info-item:hover {
            border-color: var(--accent);
            box-shadow: 0 4px 20px rgba(5, 150, 105, 0.15);
        }

        .signature-section {
            background: linear-gradient(135deg, #fefbff 0%, #f8fafc 100%);
            border: 2px solid var(--primary);
            border-radius: var(--border-radius);
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .section-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--gray-800);
            margin-bottom: 1.5rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .section-title i {
            color: var(--primary);
            font-size: 1.1rem;
        }

        .signature-content {
            background: var(--white);
            border: 2px solid var(--gray-200);
            padding: 2rem;
            border-radius: var(--border-radius);
            min-height: 120px;
            font-family: 'Courier New', monospace;
            font-size: 1.1rem;
            color: var(--gray-700);
            white-space: pre-wrap;
            word-wrap: break-word;
            line-height: 1.8;
            box-shadow: inset 0 2px 8px rgba(0, 0, 0, 0.05);
            position: relative;
        }

        .signature-content::before {
            content: '✍️';
            position: absolute;
            top: 1rem;
            right: 1rem;
            font-size: 1.5rem;
            opacity: 0.3;
        }

        .back-link {
            text-align: center;
            margin-top: 3rem;
            padding-top: 2rem;
            border-top: 2px solid var(--gray-200);
        }

        .back-link a {
            color: var(--white);
            background: var(--gradient-primary);
            text-decoration: none;
            font-size: 1rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 0.75rem;
            padding: 1rem 2rem;
            border: 2px solid var(--primary);
            border-radius: var(--border-radius);
            transition: var(--transition);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            box-shadow: var(--shadow-md);
        }

        .back-link a:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
            background: var(--primary-dark);
            border-color: var(--primary-dark);
        }

        .main-footer {
            background: var(--gray-800);
            color: var(--gray-200);
            margin-top: auto;
            padding: 2.5rem 0;
        }

        .footer-content {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 2rem;
        }

        .footer-sections {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
            margin-bottom: 2rem;
        }

        .footer-section h3 {
            font-size: 1.125rem;
            font-weight: 600;
            color: var(--white);
            margin-bottom: 1rem;
        }

        .footer-section p, .footer-links a, .contact-item {
            font-size: 0.875rem;
            color: var(--gray-300);
        }

        .footer-links {
            list-style: none;
        }

        .footer-links a {
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 0.75rem;
            transition: var(--transition);
            padding: 0.25rem 0;
        }

        .footer-links a:hover {
            color: var(--primary);
        }

        .contact-info {
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
        }

        .contact-item {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .contact-icon {
            width: 20px;
            color: var(--primary);
        }

        .footer-bottom {
            border-top: 1px solid var(--gray-700);
            padding-top: 2rem;
            text-align: center;
        }

        .copyright {
            font-size: 0.875rem;
            color: var(--gray-400);
        }

        @media (max-width: 768px) {
            .main-wrapper {
                padding: 1rem;
            }

            .dental-container {
                margin: 0;
            }

            .content-section {
                padding: 1.5rem;
            }

            .header-container {
                flex-direction: column;
                gap: 1rem;
                padding: 1rem;
                height: auto;
            }

            .nav-menu {
                flex-wrap: wrap;
                justify-content: center;
            }

            .footer-sections {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <header class="main-header">
        <div class="header-container">
            <div class="logo-section">
                <div class="logo">PDC</div>
                <div class="brand-name">Phòng Khám Nha Khoa</div>
            </div>
            <nav class="nav-menu">
                <a href="${pageContext.request.contextPath}/views/user/DoctorNurse/EmployeeDashBoard.jsp" class="nav-item">
                    <i class="fas fa-home"></i> Trang chủ
                </a>
                <a href="${pageContext.request.contextPath}/ViewPatientResultServlet" class="nav-item">
                    <i class="fas fa-stethoscope"></i> Danh Sách Đơn Thuốc
                </a>
                <a href="${pageContext.request.contextPath}/AddPrescriptionServlet" class="nav-item">
                    <i class="fas fa-prescription"></i> Kê Đơn Thuốc
                </a>
                <a href="#" class="nav-item active">
                    <i class="fas fa-file-alt"></i> Chi Tiết Đơn Thuốc
                </a>
            </nav>
        </div>
    </header>

    <main class="main-wrapper">
        <div class="dental-container">
            <div class="dental-header">
                <div class="dental-logo">📄</div>
                <h1 class="page-title">Chi Tiết Đơn Thuốc</h1>
                <p class="page-subtitle">Xem thông tin chi tiết của đơn thuốc</p>
            </div>

            <div class="content-section">
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i>
                        <span>${errorMessage}</span>
                    </div>
                </c:if>
                <c:if test="${not empty message}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        <span>${message}</span>
                    </div>
                </c:if>

                <c:choose>
                    <c:when test="${not empty prescriptionDetail}">
                        <div class="prescription-id-header">
                            <h2 class="prescription-id">Đơn Thuốc ${prescriptionDetail.prescriptionId}</h2>
                        </div>

                        <!-- 1. Tên Bệnh Nhân -->
                        <div class="info-item">
                            <div class="info-label">
                                <i class="fas fa-user"></i>
                                Tên Bệnh Nhân
                            </div>
                            <div class="info-value">
                                ${prescriptionDetail.patientName != null ? prescriptionDetail.patientName : 'Không xác định'}
                            </div>
                        </div>

                        <!-- 2. Tên Bác Sĩ Thăm Khám -->
                        <div class="info-item">
                            <div class="info-label">
                                <i class="fas fa-user-md"></i>
                                Bác Sĩ Thăm Khám
                            </div>
                            <div class="info-value">
                                ${prescriptionDetail.doctorName != null ? prescriptionDetail.doctorName : 'Không xác định'}
                            </div>
                        </div>

                        <!-- 3. Tên Y Tá -->
                        <div class="info-item">
                            <div class="info-label">
                                <i class="fas fa-user-nurse"></i>
                                Y Tá Hỗ Trợ
                            </div>
                            <div class="info-value">
                                ${prescriptionDetail.nurseName != null ? prescriptionDetail.nurseName : 'Không có thông tin'}
                            </div>
                        </div>

                        <!-- 4. Chẩn Đoán -->
                        <div class="info-item">
                            <div class="info-label">
                                <i class="fas fa-diagnoses"></i>
                                Chẩn Đoán
                            </div>
                            <div class="info-value">
                                ${prescriptionDetail.diagnosis != null ? prescriptionDetail.diagnosis : 'Không có thông tin'}
                            </div>
                        </div>

                        <!-- 5. Ghi Chú -->
                        <div class="info-item">
                            <div class="info-label">
                                <i class="fas fa-sticky-note"></i>
                                Ghi Chú
                            </div>
                            <div class="info-value">
                                ${prescriptionDetail.notes != null ? prescriptionDetail.notes : 'Không có thông tin'}
                            </div>
                        </div>

                        <!-- 6. Chi Tiết Thuốc -->
                        <div class="medication-section">
                            <h3 class="section-title">
                                <i class="fas fa-pills"></i>
                                Chi Tiết Thuốc
                            </h3>
                            
                            <div class="info-item">
                                <div class="info-label">
                                    <i class="fas fa-prescription-bottle"></i>
                                    Liều Lượng
                                </div>
                                <div class="info-value">
                                    ${prescriptionDetail.prescriptionDosage != null ? prescriptionDetail.prescriptionDosage : 'Không có thông tin'}
                                </div>
                            </div>

                            <div class="info-item">
                                <div class="info-label">
                                    <i class="fas fa-sort-numeric-up"></i>
                                    Số Lượng
                                </div>
                                <div class="info-value">
                                    ${prescriptionDetail.quantity != null ? prescriptionDetail.quantity : 'Không có thông tin'}
                                </div>
                            </div>

                            <div class="info-item">
                                <div class="info-label">
                                    <i class="fas fa-instructions"></i>
                                    Hướng Dẫn Sử Dụng
                                </div>
                                <div class="info-value">
                                    ${prescriptionDetail.instruct != null ? prescriptionDetail.instruct : 'Không có thông tin'}
                                </div>
                            </div>
                        </div>

                        <!-- 7. Ngày Kê Đơn Thuốc -->
                        <div class="info-item">
                            <div class="info-label">
                                <i class="fas fa-calendar-alt"></i>
                                Ngày Kê Đơn Thuốc
                            </div>
                            <div class="info-value">
                                ${prescriptionDetail.createdAt != null ? prescriptionDetail.createdAt : 'Không có thông tin'}
                            </div>
                        </div>

                        <!-- 8. Chữ Ký (Cuối cùng) -->
                        <div class="signature-section">
                            <h3 class="section-title">
                                <i class="fas fa-signature"></i>
                                Chữ Ký Bác Sĩ
                            </h3>
                            <div class="signature-content">
                                ${prescriptionDetail.signature != null ? prescriptionDetail.signature : 'Không có thông tin'}
                            </div>
                        </div>

                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-error">
                            <i class="fas fa-exclamation-circle"></i>
                            <span>Không tìm thấy thông tin đơn thuốc.</span>
                        </div>
                    </c:otherwise>
                </c:choose>

                <div class="back-link">
                    <a href="${pageContext.request.contextPath}/ViewPatientResultServlet">
                        <i class="fas fa-arrow-left"></i> Quay lại danh sách kết quả khám
                    </a>
                </div>
            </div>
        </div>
    </main>

    <footer class="main-footer">
        <div class="footer-content">
            <div class="footer-sections">
                <div class="footer-section">
                    <h3>Về Chúng Tôi</h3>
                    <p>Chúng tôi cam kết mang đến dịch vụ y tế chất lượng với đội ngũ bác sĩ tận tâm và hệ thống quản lý hiện đại.</p>
                </div>
                <div class="footer-section">
                    <h3>Liên Kết Nhanh</h3>
                    <ul class="footer-links">
                        <li><a href="/ViewExaminationResults"><i class="fas fa-stethoscope"></i> Kết Quả Khám</a></li>
                        <li><a href="/ViewMedicationsServlet"><i class="fas fa-pills"></i> Danh Sách Thuốc</a></li>
                        <li><a href="/ViewPatientResults"><i class="fas fa-prescription"></i> Kê Đơn Thuốc</a></li>
                        <li><a href="/ViewScheduleUserServlet"><i class="fas fa-calendar-check"></i> Lịch Làm Việc</a></li>
                        <li><a href="/ViewRoomServlet"><i class="fas fa-door-open"></i> Quản Lý Phòng</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h3>Liên Hệ</h3>
                    <div class="contact-info">
                        <div class="contact-item"><i class="fas fa-map-marker-alt contact-icon"></i> DH FPT, Hòa Lạc, Hà Nội</div>
                        <div class="contact-item"><i class="fas fa-phone contact-icon"></i> (098) 1234 5678</div>
                        <div class="contact-item"><i class="fas fa-envelope contact-icon"></i> PhongKhamPDC@gmail.com</div>
                        <div class="contact-item"><i class="fas fa-clock contact-icon"></i> Thứ 2 - Chủ nhật: 8:00 - 20:00</div>
                    </div>
                </div>
            </div>
            <div class="footer-bottom">
                <div class="copyright">© 2025 Phòng Khám Nha Khoa PDC. Tất cả quyền được bảo lưu.</div>
            </div>
        </div>
    </footer>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            console.log("DOM loaded for ViewPrescriptionDetail");

            // Animation cho info items
            const infoItems = document.querySelectorAll('.info-item');
            infoItems.forEach((item, index) => {
                item.style.opacity = '0';
                item.style.transform = 'translateY(10px)';
                setTimeout(() => {
                    item.style.transition = 'all 0.3s ease';
                    item.style.opacity = '1';
                    item.style.transform = 'translateY(0)';
                }, index * 100);
            });

            // Animation cho sections
            const sections = document.querySelectorAll('.medication-section, .signature-section');
            sections.forEach((section, index) => {
                section.style.opacity = '0';
                section.style.transform = 'translateY(15px)';
                setTimeout(() => {
                    section.style.transition = 'all 0.4s ease';
                    section.style.opacity = '1';
                    section.style.transform = 'translateY(0)';
                }, (index + 8) * 100);
            });
        });
    </script>
</body>
</html>
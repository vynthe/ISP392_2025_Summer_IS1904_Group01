<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="model.service.PrescriptionService" %>
<%@ page import="model.entity.Medication" %>
<%@ page import="java.util.List" %>
<html>
<head>
    <title>Thêm Đơn Thuốc - Phòng Khám Nha Khoa</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #3b82f6;
            --primary-dark: #2563eb;
            --secondary: #6b7280;
            --accent: #a855f7;
            --success: #10b981;
            --error: #ef4444;
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
            --gradient-primary: linear-gradient(135deg, #3b82f6 0%, #a855f7 100%);
            --shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.05);
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -2px rgba(0, 0, 0, 0.1);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.1);
            --border-radius: 12px;
            --border-radius-lg: 16px;
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--gray-50);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            color: var(--gray-900);
        }

        /* Header */
        .main-header {
            background: var(--white);
            box-shadow: var(--shadow-sm);
            position: sticky;
            top: 0;
            z-index: 1000;
            border-bottom: 1px solid var(--gray-200);
        }

        .header-container {
            max-width: 1280px;
            margin: 0 auto;
            padding: 0 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            height: 70px;
        }

        .logo-section {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .logo {
            width: 40px;
            height: 40px;
            background: var(--gradient-primary);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--white);
            font-size: 1.25rem;
            font-weight: bold;
        }

        .brand-name {
            font-size: 1.5rem;
            font-weight: 700;
        }

        .nav-menu {
            display: flex;
            gap: 1rem;
        }

        .nav-item {
            color: var(--gray-600);
            text-decoration: none;
            font-weight: 500;
            font-size: 0.875rem;
            padding: 0.5rem 1rem;
            border-radius: var(--border-radius);
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .nav-item:hover {
            color: var(--primary);
            background-color: rgba(59, 130, 246, 0.1);
        }

        .nav-item.active {
            color: var(--primary);
            background-color: rgba(59, 130, 246, 0.1);
        }

        .user-menu {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .user-avatar {
            width: 36px;
            height: 36px;
            background: var(--gradient-primary);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--white);
            font-weight: 600;
            font-size: 0.875rem;
        }

        .user-info {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
        }

        .user-name {
            font-size: 0.875rem;
            font-weight: 600;
        }

        .user-role {
            font-size: 0.75rem;
            color: var(--gray-500);
        }

        /* Main Content */
        .main-wrapper {
            flex: 1;
            padding: 2rem;
        }

        .dental-container {
            background: var(--white);
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-lg);
            max-width: 1280px;
            margin: 0 auto;
            animation: fadeIn 0.5s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .dental-header {
            background: var(--gradient-primary);
            padding: 1.5rem 2rem;
            color: var(--white);
        }

        .header-content {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .dental-logo {
            width: 48px;
            height: 48px;
            background: rgba(255, 255, 255, 0.15);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
        }

        .page-title {
            font-size: 1.5rem;
            font-weight: 700;
        }

        .page-subtitle {
            font-size: 0.875rem;
            opacity: 0.9;
        }

        .content-section {
            padding: 2rem;
        }

        .form-header {
            text-align: center;
            margin-bottom: 1.5rem;
        }

        .form-title {
            font-size: 1.25rem;
            font-weight: 600;
        }

        .alert {
            padding: 1rem;
            border-radius: var(--border-radius);
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-weight: 500;
        }

        .alert-success {
            background: rgba(16, 185, 129, 0.1);
            color: var(--success);
            border: 1px solid rgba(16, 185, 129, 0.2);
        }

        .alert-error {
            background: rgba(239, 68, 68, 0.1);
            color: var(--error);
            border: 1px solid rgba(239, 68, 68, 0.2);
        }

        .stats-section {
            margin-bottom: 1.5rem;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
        }

        .stat-card {
            background: var(--gray-50);
            padding: 1rem;
            border-radius: var(--border-radius);
            border: 1px solid var(--gray-200);
            transition: var(--transition);
        }

        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .stat-label {
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--gray-600);
            text-transform: uppercase;
            margin-bottom: 0.25rem;
        }

        .stat-value {
            font-size: 0.875rem;
            font-weight: 500;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            margin-bottom: 1rem;
        }

        .form-label {
            font-weight: 500;
            color: var(--gray-700);
            margin-bottom: 0.5rem;
            font-size: 0.875rem;
        }

        .required::after {
            content: " *";
            color: var(--error);
        }

        .form-select {
            width: 100%;
            padding: 0.75rem;
            border-radius: var(--border-radius);
            border: 1px solid var(--gray-200);
            font-size: 0.875rem;
            transition: var(--transition);
        }

        .form-select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        .medications-section {
            margin-bottom: 1.5rem;
        }

        .section-title {
            font-weight: 600;
            font-size: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1rem;
        }

        .medication-item {
            border: 1px solid var(--gray-200);
            border-radius: var(--border-radius);
            padding: 1rem;
            margin-bottom: 1rem;
            position: relative;
            background: var(--gray-50);
            transition: var(--transition);
        }

        .medication-item:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .remove-btn {
            position: absolute;
            top: 0.5rem;
            right: 0.5rem;
            background: var(--error);
            color: var(--white);
            border: none;
            border-radius: 50%;
            width: 24px;
            height: 24px;
            cursor: pointer;
            font-size: 0.75rem;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: var(--transition);
        }

        .remove-btn:hover {
            background: #dc2626;
            transform: scale(1.1);
        }

        .add-btn {
            background: var(--success);
            color: var(--white);
            border: none;
            padding: 0.75rem 1rem;
            border-radius: var(--border-radius);
            font-size: 0.875rem;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .add-btn:hover {
            background: #0d9b6f;
            transform: translateY(-2px);
        }

        .form-actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-top: 1.5rem;
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: var(--border-radius);
            font-size: 0.875rem;
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary {
            background: var(--primary);
            color: var(--white);
        }

        .btn-primary:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
        }

        .back-link {
            text-align: center;
            margin-top: 1.5rem;
        }

        .back-link a {
            color: var(--primary);
            text-decoration: none;
            font-size: 0.875rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            justify-content: center;
        }

        .back-link a:hover {
            text-decoration: underline;
        }

        /* Footer */
        .main-footer {
            background: var(--gray-800);
            color: var(--gray-200);
            margin-top: auto;
            padding: 2rem;
        }

        .footer-content {
            max-width: 1280px;
            margin: 0 auto;
        }

        .footer-sections {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .footer-section h3 {
            font-size: 1rem;
            font-weight: 600;
            color: var(--white);
            margin-bottom: 0.75rem;
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
            margin-bottom: 0.5rem;
            transition: var(--transition);
        }

        .footer-links a:hover {
            color: var(--primary);
        }

        .contact-info {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .contact-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .contact-icon {
            width: 20px;
            color: var(--primary);
        }

        .footer-bottom {
            border-top: 1px solid var(--gray-700);
            padding-top: 1.5rem;
            text-align: center;
        }

        .copyright {
            font-size: 0.875rem;
            color: var(--gray-400);
        }

        /* Mobile Styles */
        @media (max-width: 768px) {
            .main-wrapper { padding: 1rem; }
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
            .user-menu { justify-content: flex-end; width: 100%; }
            .dental-container { border-radius: var(--border-radius); }
            .header-content { flex-direction: column; text-align: center; }
            .form-actions { flex-direction: column; }
            .footer-sections { grid-template-columns: 1fr; }
            .stats-grid { grid-template-columns: 1fr; }
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
                <a href="#" class="nav-item active">
                    <i class="fas fa-prescription"></i> Kê Đơn Thuốc
                </a>
            </nav>
            <div class="user-menu">
                <div class="user-avatar"><i class="fas fa-user-md"></i></div>
                <div class="user-info">
                    <div class="user-name">Bác sĩ ${sessionScope.doctorName != null ? sessionScope.doctorName : 'Admin'}</div>
                    <div class="user-role">Nhân viên y tế</div>
                </div>
            </div>
        </div>
    </header>

    <main class="main-wrapper">
        <div class="dental-container">
            <div class="dental-header">
                <div class="header-content">
                    <div class="dental-logo">🩺</div>
                    <div>
                        <h1 class="page-title">Thêm Đơn Thuốc</h1>
                        <p class="page-subtitle">Tạo đơn thuốc mới cho bệnh nhân</p>
                    </div>
                </div>
            </div>

            <div class="content-section">
                <div class="form-header">
                    <h2 class="form-title">Thông Tin Đơn Thuốc</h2>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i>
                        <span>${errorMessage}</span>
                    </div>
                </c:if>
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        <span>${successMessage}</span>
                    </div>
                </c:if>
                <c:if test="${empty medications}">
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i>
                        <span>Không có thuốc nào trong hệ thống. Vui lòng thêm thuốc trước khi tạo đơn.</span>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/AddPrescriptionServlet" method="post" onsubmit="return validateForm()">
                    <input type="hidden" name="patientId" value="${param.patientId != null ? param.patientId : formPatientId}">
                    <input type="hidden" name="doctorId" value="${param.doctorId != null ? param.doctorId : formDoctorId}">
                    <input type="hidden" name="resultId" value="${param.resultId != null ? param.resultId : formResultId}">
                    <input type="hidden" name="appointmentId" value="${appointmentId != null && appointmentId != 'N/A' && appointmentId != 'null' ? appointmentId : ''}">

                    <div class="stats-section">
                        <h3 class="section-title"><i class="fas fa-info-circle"></i> Thông Tin Bệnh Nhân</h3>
                        <div class="stats-grid">
                            <div class="stat-card">
                                <div class="stat-label">Bệnh Nhân</div>
                                <div class="stat-value">${patientName != null ? patientName : 'Không xác định'}</div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-label">Bác Sĩ</div>
                                <div class="stat-value">${doctorName != null ? doctorName : 'Không xác định'}</div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-label">Kết Quả Khám</div>
                                <div class="stat-value">${resultName != null ? resultName : 'Không xác định'}</div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-label">Mã Lịch Hẹn</div>
                                <div class="stat-value">
                                    <c:choose>
                                        <c:when test="${appointmentId != null && appointmentId != 'N/A' && appointmentId != 'null' && appointmentId != ''}">
                                            ${appointmentId}
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: var(--gray-500); font-style: italic;">Không có thông tin</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="medications-section">
                        <h3 class="section-title"><i class="fas fa-capsules"></i> Danh Sách Thuốc</h3>
                        <div id="medicationList">
                            <div class="medication-item">
                                <div class="form-group">
                                    <label class="form-label required">Tên Thuốc</label>
                                    <select name="medicationIds" class="form-select" required>
                                        <option value="">Chọn thuốc</option>
                                        <c:if test="${not empty medications}">
                                            <c:forEach var="med" items="${medications}">
                                                <option value="${med.medicationID}" <c:if test="${formMedicationIds != null && formMedicationIds.contains(String.valueOf(med.medicationID))}">selected</c:if>>
                                                    ${med.name} - ${med.dosage}
                                                </option>
                                            </c:forEach>
                                        </c:if>
                                    </select>
                                </div>
                                <button type="button" class="remove-btn" onclick="removeMedication(this)">×</button>
                            </div>
                        </div>
                        <button type="button" class="add-btn" onclick="addMedication()">
                            <i class="fas fa-plus"></i> Thêm Thuốc
                        </button>
                    </div>

                    <input type="hidden" name="save" value="true">

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-check"></i> Tạo Đơn Thuốc
                        </button>
                    </div>

                    <div class="back-link">
                        <a href="${pageContext.request.contextPath}/ViewPatientResultServlet">
                            <i class="fas fa-arrow-left"></i> Quay lại danh sách kết quả khám
                        </a>
                    </div>
                </form>
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
                        <li><a href="#"><i class="fas fa-stethoscope"></i> Kết Quả Khám</a></li>
                        <li><a href="#"><i class="fas fa-pills"></i> Danh Sách Thuốc</a></li>
                        <li><a href="#"><i class="fas fa-prescription"></i> Kê Đơn Thuốc</a></li>
                        <li><a href="#"><i class="fas fa-calendar-check"></i> Lịch Làm Việc</a></li>
                        <li><a href="#"><i class="fas fa-door-open"></i> Quản Lý Phòng</a></li>
                        <li><a href="#"><i class="fas fa-headset"></i> Hỗ trợ kỹ thuật</a></li>
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
                <div class="copyright">© 2024 Phòng Khám Nha Khoa PDC. Tất cả quyền được bảo lưu.</div>
            </div>
        </div>
    </footer>

    <!-- Data từ server để sử dụng trong JavaScript -->
    <script>
        // Lấy dữ liệu thuốc từ server
        const medicationsData = [];
        <c:if test="${not empty medications}">
            <c:forEach var="med" items="${medications}">
                medicationsData.push({
                    id: ${med.medicationID},
                    name: "${med.name}".replace(/"/g, '&quot;'),
                    dosage: "${med.dosage}".replace(/"/g, '&quot;')
                });
            </c:forEach>
        </c:if>

        console.log("Medications loaded:", medicationsData);

        let medicationCount = 1;

        function addMedication() {
            console.log("Adding new medication, available medications:", medicationsData.length);
            
            const medicationList = document.getElementById('medicationList');
            const newMedication = document.createElement('div');
            newMedication.className = 'medication-item';
            newMedication.style.opacity = '0';
            newMedication.style.transform = 'translateY(20px)';

            const formGroup = document.createElement('div');
            formGroup.className = 'form-group';

            const label = document.createElement('label');
            label.className = 'form-label required';
            label.textContent = 'Tên Thuốc';
            formGroup.appendChild(label);

            const select = document.createElement('select');
            select.name = 'medicationIds';
            select.className = 'form-select';
            select.required = true;

            // Thêm option mặc định
            const defaultOption = document.createElement('option');
            defaultOption.value = '';
            defaultOption.textContent = 'Chọn thuốc';
            select.appendChild(defaultOption);

            // Thêm các thuốc từ dữ liệu
            medicationsData.forEach(med => {
                const option = document.createElement('option');
                option.value = med.id;
                option.textContent = med.name + ' - ' + med.dosage;
                select.appendChild(option);
                console.log("Added option:", med.name, med.dosage);
            });

            formGroup.appendChild(select);

            const removeBtn = document.createElement('button');
            removeBtn.type = 'button';
            removeBtn.className = 'remove-btn';
            removeBtn.innerHTML = '×';
            removeBtn.onclick = function() { removeMedication(this); };

            newMedication.appendChild(formGroup);
            newMedication.appendChild(removeBtn);
            medicationList.appendChild(newMedication);

            // Animation hiệu ứng
            setTimeout(() => {
                newMedication.style.transition = 'all 0.3s ease';
                newMedication.style.opacity = '1';
                newMedication.style.transform = 'translateY(0)';
            }, 10);

            medicationCount++;
            console.log("New medication item added, total count:", medicationCount);
        }

        function removeMedication(button) {
            const medicationItems = document.querySelectorAll('.medication-item');
            if (medicationItems.length > 1) {
                const item = button.parentElement;
                item.style.transition = 'all 0.3s ease';
                item.style.opacity = '0';
                item.style.transform = 'translateY(-20px)';
                
                setTimeout(() => {
                    item.remove();
                    medicationCount--;
                    console.log("Medication removed, remaining count:", medicationCount);
                }, 300);
            } else {
                alert('Phải có ít nhất một loại thuốc trong đơn.');
            }
        }

        function validateForm() {
            const medicationIds = document.getElementsByName('medicationIds');
            let hasEmptySelection = false;
            let selectedMeds = [];
            
            for (let i = 0; i < medicationIds.length; i++) {
                const value = medicationIds[i].value;
                if (!value || value.trim() === '') {
                    hasEmptySelection = true;
                    break;
                }
                selectedMeds.push(value);
            }
            
            if (hasEmptySelection) {
                alert('Vui lòng chọn thuốc cho tất cả các mục.');
                return false;
            }
            
            // Kiểm tra trùng lặp thuốc
            const uniqueMeds = [...new Set(selectedMeds)];
            if (selectedMeds.length !== uniqueMeds.length) {
                alert('Không được chọn trùng thuốc. Vui lòng chọn các loại thuốc khác nhau.');
                return false;
            }
            
            return true;
        }

        // Khởi tạo khi trang được tải
        document.addEventListener('DOMContentLoaded', function () {
            console.log("DOM loaded, medications available:", medicationsData.length);
            
            const submitBtn = document.querySelector('.btn-primary');
            const addBtn = document.querySelector('.add-btn');
            
            // Disable submit button nếu không có thuốc
            if (medicationsData.length === 0) {
                submitBtn.disabled = true;
                submitBtn.style.opacity = '0.5';
                submitBtn.style.cursor = 'not-allowed';
                addBtn.disabled = true;
                addBtn.style.opacity = '0.5';
                addBtn.style.cursor = 'not-allowed';
                console.log("Buttons disabled: no medications available");
            }

            // Xử lý submit form
            const form = document.querySelector('form');
            form.addEventListener('submit', function() {
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang tạo đơn thuốc...';
                submitBtn.disabled = true;
            });

            // Animation cho stat cards
            const statCards = document.querySelectorAll('.stat-card');
            statCards.forEach(card => {
                card.addEventListener('mouseenter', () => {
                    card.style.transform = 'translateY(-4px)';
                    card.style.boxShadow = 'var(--shadow-lg)';
                });
                card.addEventListener('mouseleave', () => {
                    card.style.transform = 'translateY(0)';
                    card.style.boxShadow = 'var(--shadow-sm)';
                });
            });

            // Animation cho medication items hiện có
            const medicationItems = document.querySelectorAll('.medication-item');
            medicationItems.forEach((item, index) => {
                item.style.opacity = '0';
                item.style.transform = 'translateY(20px)';
                setTimeout(() => {
                    item.style.transition = 'all 0.3s ease';
                    item.style.opacity = '1';
                    item.style.transform = 'translateY(0)';
                }, index * 100);
            });
        });
    </script>
</body>
</html>
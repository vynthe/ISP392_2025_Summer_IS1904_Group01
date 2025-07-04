<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="model.service.PrescriptionService" %>
<%@ page import="model.service.UserService" %>
<%@ page import="model.entity.Medication" %>
<%@ page import="model.entity.Users" %>
<%@ page import="java.util.List" %>
<html>
<head>
    <title>Thêm Đơn Thuốc - Pure Dental Care</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --primary: #2563eb;
            --primary-light: #3b82f6;
            --secondary: #64748b;
            --success: #059669;
            --danger: #dc2626;
            --warning: #d97706;
            --gray-50: #f8fafc;
            --gray-100: #f1f5f9;
            --gray-200: #e2e8f0;
            --gray-300: #cbd5e1;
            --gray-400: #94a3b8;
            --gray-500: #64748b;
            --gray-600: #475569;
            --gray-700: #334155;
            --gray-800: #1e293b;
            --gray-900: #0f172a;
            --white: #ffffff;
            --radius: 8px;
            --radius-lg: 12px;
            --shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1);
            --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%);
            color: var(--gray-800);
            line-height: 1.6;
            min-height: 100vh;
            padding: 1rem;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            background: var(--white);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-lg);
            overflow: hidden;
        }

        .header {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-light) 100%);
            color: white;
            padding: 2rem;
            text-align: center;
            position: relative;
        }

        .header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grid" width="10" height="10" patternUnits="userSpaceOnUse"><path d="M 10 0 L 0 0 0 10" fill="none" stroke="rgba(255,255,255,0.1)" stroke-width="1"/></pattern></defs><rect width="100" height="100" fill="url(%23grid)"/></svg>');
            opacity: 0.3;
        }

        .header-content {
            position: relative;
            z-index: 1;
        }

        .logo {
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }

        .title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 0.25rem;
        }

        .subtitle {
            font-size: 0.875rem;
            opacity: 0.9;
        }

        .form-container {
            padding: 2rem;
        }

        .form-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .form-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--gray-900);
            margin-bottom: 0.5rem;
        }

        .form-description {
            color: var(--gray-500);
            font-size: 0.875rem;
        }

        .alert {
            padding: 1rem;
            border-radius: var(--radius);
            margin-bottom: 1.5rem;
            border: 1px solid var(--danger);
            background: #fef2f2;
            color: var(--danger);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .form-grid {
            display: grid;
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-label {
            font-weight: 500;
            color: var(--gray-700);
            margin-bottom: 0.5rem;
            font-size: 0.875rem;
        }

        .required::after {
            content: " *";
            color: var(--danger);
        }

        .form-input,
        .form-select,
        .form-textarea {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid var(--gray-300);
            border-radius: var(--radius);
            font-size: 0.875rem;
            transition: all 0.2s ease;
            background: var(--white);
        }

        .form-input:focus,
        .form-select:focus,
        .form-textarea:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .form-textarea {
            resize: vertical;
            min-height: 80px;
        }

        .medications-section {
            margin-bottom: 2rem;
        }

        .section-title {
            font-weight: 600;
            color: var(--gray-900);
            margin-bottom: 1rem;
            font-size: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .medication-item {
            border: 1px solid var(--gray-200);
            border-radius: var(--radius);
            padding: 1rem;
            margin-bottom: 1rem;
            position: relative;
            background: var(--gray-50);
        }

        .medication-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        .remove-btn {
            position: absolute;
            top: 0.5rem;
            right: 0.5rem;
            background: var(--danger);
            color: white;
            border: none;
            border-radius: 50%;
            width: 24px;
            height: 24px;
            cursor: pointer;
            font-size: 0.75rem;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s ease;
        }

        .remove-btn:hover {
            background: #b91c1c;
            transform: scale(1.1);
        }

        .add-btn {
            background: var(--success);
            color: white;
            border: none;
            padding: 0.75rem 1rem;
            border-radius: var(--radius);
            font-size: 0.875rem;
            cursor: pointer;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1rem;
        }

        .add-btn:hover {
            background: #047857;
            transform: translateY(-1px);
        }

        .form-actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-top: 2rem;
        }

        .btn {
            padding: 0.75rem 2rem;
            border: none;
            border-radius: var(--radius);
            font-size: 0.875rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary {
            background: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background: var(--primary-light);
            transform: translateY(-1px);
        }

        .btn-secondary {
            background: var(--gray-100);
            color: var(--gray-700);
            border: 1px solid var(--gray-300);
        }

        .btn-secondary:hover {
            background: var(--gray-200);
        }

        .back-link {
            text-align: center;
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid var(--gray-200);
        }

        .back-link a {
            color: var(--primary);
            text-decoration: none;
            font-size: 0.875rem;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .back-link a:hover {
            text-decoration: underline;
        }

        @media (max-width: 640px) {
            body {
                padding: 0.5rem;
            }
            
            .header {
                padding: 1.5rem;
            }
            
            .form-container {
                padding: 1.5rem;
            }
            
            .medication-grid {
                grid-template-columns: 1fr;
            }
            
            .form-actions {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="header-content">
                <div class="logo">🦷</div>
                <h1 class="title">Pure Dental Care</h1>
                <p class="subtitle">Hệ Thống Quản Lý Nha Khoa</p>
            </div>
        </div>

        <div class="form-container">
            <div class="form-header">
                <h2 class="form-title">Thêm Đơn Thuốc</h2>
                <p class="form-description">Nhập thông tin để tạo đơn thuốc mới</p>
            </div>

            <c:if test="${not empty sessionScope.statusMessage}">
                <div class="alert">
                    <span>⚠️</span>
                    <span>${sessionScope.statusMessage}</span>
                </div>
                <c:remove var="statusMessage" scope="session"/>
            </c:if>

            <form action="${pageContext.request.contextPath}/AddPrescriptionServlet" method="post" onsubmit="return validateForm()">
                <div class="form-grid">
                    <div class="form-group">
                        <label for="patientId" class="form-label required">Bệnh Nhân</label>
                        <select id="patientId" name="patientId" class="form-select" required>
                            <option value="">Chọn bệnh nhân</option>
                            <% 
                                UserService userService = new UserService();
                                List<Users> patients = userService.getAllPatient();
                                for (Users patient : patients) {
                                    String displayName = patient.getFullName() != null && !patient.getFullName().isEmpty() ? 
                                        patient.getFullName() : "Bệnh nhân " + patient.getUserID();
                            %>
                            <option value="<%= patient.getUserID() %>" <%= String.valueOf(patient.getUserID()).equals(request.getAttribute("formPatientId")) ? "selected" : "" %>>
                                <%= displayName %>
                            </option>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="doctorId" class="form-label required">Bác Sĩ</label>
                        <select id="doctorId" name="doctorId" class="form-select" required>
                            <option value="">Chọn bác sĩ</option>
                            <% 
                                List<Users> doctors = userService.getUsersByRole("doctor");
                                for (Users doctor : doctors) {
                                    String displayName = doctor.getFullName() != null && !doctor.getFullName().isEmpty() ? 
                                        doctor.getFullName() : "Bác sĩ " + doctor.getUserID();
                            %>
                            <option value="<%= doctor.getUserID() %>" <%= String.valueOf(doctor.getUserID()).equals(request.getAttribute("formDoctorId")) ? "selected" : "" %>>
                                <%= displayName %>
                            </option>
                            <% } %>
                        </select>
                    </div>
                </div>

                <div class="medications-section">
                    <h3 class="section-title">
                        <span>💊</span>
                        <span>Danh Sách Thuốc</span>
                    </h3>
                    
                    <div id="medicationList">
                        <div class="medication-item">
                            <div class="medication-grid">
                                <div class="form-group">
                                    <label class="form-label required">Tên Thuốc</label>
                                    <select name="medicationIds" class="form-select" required>
                                        <option value="">Chọn thuốc</option>
                                        <% 
                                            PrescriptionService prescriptionService = new PrescriptionService();
                                            List<Medication> medications = prescriptionService.getAllMedications();
                                            for (Medication med : medications) {
                                        %>
                                        <option value="<%= med.getMedicationID() %>">
                                            <%= med.getName() %> - <%= med.getDosage() %>
                                        </option>
                                        <% } %>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label class="form-label required">Liều Uống</label>
                                    <input type="text" name="dosageInstructions" class="form-input" 
                                           placeholder="VD: 2 viên/ngày" required>
                                </div>
                            </div>
                            <button type="button" class="remove-btn" onclick="removeMedication(this)">×</button>
                        </div>
                    </div>

                    <button type="button" class="add-btn" onclick="addMedication()">
                        <span>+</span>
                        <span>Thêm Thuốc</span>
                    </button>
                </div>

                <div class="form-grid">
                    <div class="form-group">
                        <label for="prescriptionDetails" class="form-label">Ghi Chú</label>
                        <textarea id="prescriptionDetails" name="prescriptionDetails" class="form-textarea" 
                                  placeholder="Nhập ghi chú cho đơn thuốc...">${formPrescriptionDetails}</textarea>
                    </div>

                    <div class="form-group">
                        <label for="status" class="form-label required">Trạng Thái</label>
                        <select id="status" name="status" class="form-select" required>
                            <option value="">Chọn trạng thái</option>
                            <option value="Pending" ${formStatus == 'Pending' ? 'selected' : ''}>Đang chờ</option>
                            <option value="In Progress" ${formStatus == 'In Progress' ? 'selected' : ''}>Đang xử lý</option>
                            <option value="Completed" ${formStatus == 'Completed' ? 'selected' : ''}>Hoàn thành</option>
                            <option value="Dispensed" ${formStatus == 'Dispensed' ? 'selected' : ''}>Đã cấp phát</option>
                            <option value="Cancelled" ${formStatus == 'Cancelled' ? 'selected' : ''}>Đã hủy</option>
                        </select>
                    </div>
                </div>

                <input type="hidden" name="save" value="true">

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">
                        <span>✓</span>
                        <span>Tạo Đơn Thuốc</span>
                    </button>
                </div>
            </form>

            <div class="back-link">
                <a href="${pageContext.request.contextPath}/ViewPrescriptionServlet">
                    <span>←</span>
                    <span>Quay lại danh sách</span>
                </a>
            </div>
        </div>
    </div>

    <script>
        let medicationCount = 1;

        function addMedication() {
            const medicationList = document.getElementById('medicationList');
            const newMedication = document.createElement('div');
            newMedication.className = 'medication-item';
            newMedication.innerHTML = `
                <div class="medication-grid">
                    <div class="form-group">
                        <label class="form-label required">Tên Thuốc</label>
                        <select name="medicationIds" class="form-select" required>
                            <option value="">Chọn thuốc</option>
                            <% for (Medication med : medications) { %>
                            <option value="<%= med.getMedicationID() %>">
                                <%= med.getName() %> - <%= med.getDosage() %>
                            </option>
                            <% } %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label required">Liều Uống</label>
                        <input type="text" name="dosageInstructions" class="form-input" 
                               placeholder="VD: 2 viên/ngày" required>
                    </div>
                </div>
                <button type="button" class="remove-btn" onclick="removeMedication(this)">×</button>
            `;
            medicationList.appendChild(newMedication);
            medicationCount++;
        }

        function removeMedication(button) {
            const medicationItems = document.querySelectorAll('.medication-item');
            if (medicationItems.length > 1) {
                button.parentElement.remove();
            } else {
                alert('Phải có ít nhất một loại thuốc trong đơn.');
            }
        }

        function validateForm() {
            const patientId = document.getElementById('patientId').value;
            const doctorId = document.getElementById('doctorId').value;
            const status = document.getElementById('status').value;
            const medicationIds = document.getElementsByName('medicationIds');
            const dosageInstructions = document.getElementsByName('dosageInstructions');

            if (!patientId) {
                alert('Vui lòng chọn bệnh nhân.');
                return false;
            }
            if (!doctorId) {
                alert('Vui lòng chọn bác sĩ.');
                return false;
            }
            if (!status) {
                alert('Vui lòng chọn trạng thái.');
                return false;
            }
            
            for (let i = 0; i < medicationIds.length; i++) {
                if (!medicationIds[i].value) {
                    alert('Vui lòng chọn thuốc cho tất cả các mục.');
                    return false;
                }
                if (!dosageInstructions[i].value.trim()) {
                    alert('Vui lòng nhập liều uống cho tất cả các thuốc.');
                    return false;
                }
            }
            return true;
        }

        // Smooth form interactions
        document.addEventListener('DOMContentLoaded', function() {
            const inputs = document.querySelectorAll('.form-input, .form-select, .form-textarea');
            inputs.forEach(input => {
                input.addEventListener('focus', function() {
                    this.style.transform = 'translateY(-1px)';
                });
                input.addEventListener('blur', function() {
                    this.style.transform = 'translateY(0)';
                });
            });
        });
    </script>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="model.service.PrescriptionService" %>
<%@ page import="model.service.UserService" %>
<%@ page import="model.entity.Medication" %>
<%@ page import="model.entity.Users" %>
<%@ page import="java.util.List" %>
<html>
<head>
    <title>Thêm Đơn Thuốc</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Satoshi:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500&display=swap');
        
        :root {
            --primary: #667eea;
            --primary-dark: #5a67d8;
            --secondary: #764ba2;
            --accent: #f093fb;
            --success: #10b981;
            --warning: #f59e0b;
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
            --gradient-primary: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --gradient-surface: linear-gradient(145deg, #ffffff 0%, #f8fafc 100%);
            --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
            --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
            --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
            --shadow-xl: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);
            --shadow-2xl: 0 25px 50px -12px rgb(0 0 0 / 0.25);
            --border-radius: 20px;
            --border-radius-lg: 24px;
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Satoshi', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background-color: #f4f7fa;
            min-height: 100vh;
            padding: 2rem;
            position: relative;
            overflow-x: hidden;
        }

        .dental-container {
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-2xl);
            width: 100%;
            max-width: 1000px;
            margin: 0 auto;
            position: relative;
            overflow: hidden;
        }

        .dental-header {
            background: var(--gradient-primary);
            padding: 2rem 3rem 1.5rem;
            position: relative;
            overflow: hidden;
        }

        .dental-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -20%;
            width: 300px;
            height: 300px;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            border-radius: 50%;
        }

        .header-content {
            position: relative;
            z-index: 2;
            text-align: center;
        }

        .dental-logo {
            width: 50px;
            height: 50px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        .dental-logo::before {
            content: '🦷';
            font-size: 1.5rem;
            filter: drop-shadow(0 2px 4px rgba(0,0,0,0.1));
        }

        .dental-title {
            color: var(--white);
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.25rem;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
            letter-spacing: -0.025em;
        }

        .dental-subtitle {
            color: rgba(255, 255, 255, 0.9);
            font-size: 1rem;
            font-weight: 400;
            opacity: 0.9;
        }

        .dental-content {
            padding: 2.5rem 3rem 3rem;
        }

        .form-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .form-title {
            font-size: 1.75rem;
            font-weight: 600;
            color: var(--gray-900);
            margin-bottom: 0.5rem;
            letter-spacing: -0.025em;
        }

        .form-description {
            color: var(--gray-600);
            font-size: 1rem;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .form-group {
            position: relative;
        }

        .form-label {
            display: block;
            font-weight: 600;
            color: var(--gray-900);
            margin-bottom: 0.5rem;
            font-size: 0.875rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            position: relative;
        }

        .form-label.required::after {
            content: "*";
            color: var(--error);
            margin-left: 0.25rem;
            font-weight: 700;
        }

        .input-wrapper {
            position: relative;
        }

        .form-input,
        .form-select,
        .form-textarea {
            width: 100%;
            padding: 1rem 3rem 1rem 1.25rem;
            border: 2px solid var(--gray-200);
            border-radius: var(--border-radius);
            font-size: 1rem;
            font-family: inherit;
            background: var(--white);
            transition: var(--transition);
            color: var(--gray-900);
            position: relative;
            z-index: 1;
        }

        .form-textarea {
            min-height: 100px;
            resize: vertical;
        }

        .form-input:focus,
        .form-select:focus,
        .form-textarea:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
            transform: translateY(-1px);
        }

        .form-input::placeholder,
        .form-textarea::placeholder {
            color: var(--gray-400);
        }

        .medication-group {
            border: 1px solid var(--gray-200);
            border-radius: var(--border-radius);
            padding: 1rem;
            margin-bottom: 1rem;
            position: relative;
        }

        .remove-medication {
            position: absolute;
            top: 0.5rem;
            right: 0.5rem;
            background: var(--error);
            color: var(--white);
            border: none;
            border-radius: 50%;
            width: 24px;
            height: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            font-size: 1rem;
        }

        .add-medication {
            background: var(--success);
            color: var(--white);
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: var(--border-radius);
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            margin-bottom: 1rem;
        }

        .add-medication:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .form-actions {
            margin-top: 2rem;
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .dental-submit {
            background: var(--gradient-primary);
            color: var(--white);
            border: none;
            padding: 1.25rem 2rem;
            border-radius: var(--border-radius);
            font-size: 1.125rem;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            position: relative;
            overflow: hidden;
            box-shadow: var(--shadow-lg);
        }

        .dental-submit::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.6s;
        }

        .dental-submit:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-xl);
        }

        .dental-submit:hover::before {
            left: 100%;
        }

        .dental-submit:active {
            transform: translateY(0);
        }

        .dental-nav {
            text-align: center;
            padding-top: 1.5rem;
            border-top: 1px solid var(--gray-200);
        }

        .dental-link {
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
            padding: 0.75rem 1.25rem;
            border-radius: var(--border-radius);
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: rgba(102, 126, 234, 0.05);
            border: 1px solid rgba(102, 126, 234, 0.1);
        }

        .dental-link:hover {
            background: rgba(102, 126, 234, 0.1);
            transform: translateY(-1px);
        }

        .error-message {
            background: linear-gradient(135deg, rgba(239, 68, 68, 0.1) 0%, rgba(248, 113, 113, 0.1) 100%);
            color: var(--error);
            padding: 1rem 1.25rem;
            border-radius: var(--border-radius);
            margin-bottom: 1.5rem;
            border: 1px solid rgba(239, 68, 68, 0.2);
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .error-message::before {
            content: "⚠️";
            font-size: 1.125rem;
        }

        @media (max-width: 768px) {
            body { 
                padding: 1rem; 
            }
            
            .dental-container { 
                border-radius: 16px; 
            }
            
            .dental-header { 
                padding: 1.5rem 1.5rem 1rem; 
            }
            
            .dental-title { 
                font-size: 1.75rem; 
            }
            
            .dental-content { 
                padding: 2rem 1.5rem; 
            }
            
            .form-input, 
            .form-select,
            .form-textarea { 
                padding: 0.875rem 2.5rem 0.875rem 1rem; 
            }
            
            .dental-submit { 
                padding: 1rem 1.5rem; 
                font-size: 1rem; 
            }
            
            .form-grid { 
                grid-template-columns: 1fr;
                gap: 1.25rem;
            }

            .input-icon {
                right: 0.75rem;
                font-size: 1rem;
            }
        }
    </style>
</head>
<body>
    <div class="dental-container">
        <div class="dental-header">
            <div class="header-content">
                <div class="dental-logo"></div>
                <h1 class="dental-title">Pure Dental Care</h1>
                <p class="dental-subtitle">Hệ Thống Quản Lý Nha Khoa Thông Minh</p>
            </div>
        </div>

        <div class="dental-content">
            <div class="form-header">
                <h2 class="form-title">Thêm Đơn Thuốc</h2>
                <p class="form-description">Nhập thông tin chi tiết của đơn thuốc để thêm vào hệ thống</p>
            </div>

            <c:if test="${not empty sessionScope.statusMessage}">
                <div class="error-message">${sessionScope.statusMessage}</div>
                <c:remove var="statusMessage" scope="session"/>
            </c:if>

            <form action="${pageContext.request.contextPath}/AddPrescriptionServlet" method="post" onsubmit="return validateForm()">
                <div class="form-grid">
                    <div class="form-group">
                        <label for="patientId" class="form-label required">Bệnh Nhân</label>
                        <div class="input-wrapper">
                            <select id="patientId" name="patientId" class="form-select" required>
                                <option value="" ${empty formPatientId ? 'selected' : ''}>Chọn bệnh nhân...</option>
                                <% 
                                    UserService userService = new UserService();
                                    List<Users> patients = userService.getAllPatient();
                                    for (Users patient : patients) {
                                        String displayName = patient.getFullName() != null && !patient.getFullName().isEmpty() ? 
                                            patient.getFullName() : "Unknown Patient " + patient.getUserID();
                                %>
                                <option value="<%= patient.getUserID() %>" <%= String.valueOf(patient.getUserID()).equals(request.getAttribute("formPatientId")) ? "selected" : "" %>>
                                    <%= displayName %>
                                </option>
                                <% } %>
                            </select>
                            <span class="input-icon">🧑‍⚕️</span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="doctorId" class="form-label required">Bác Sĩ</label>
                        <div class="input-wrapper">
                            <select id="doctorId" name="doctorId" class="form-select" required>
                                <option value="" ${empty formDoctorId ? 'selected' : ''}>Chọn bác sĩ...</option>
                                <% 
                                    List<Users> doctors = userService.getUsersByRole("doctor");
                                    for (Users doctor : doctors) {
                                        String displayName = doctor.getFullName() != null && !doctor.getFullName().isEmpty() ? 
                                            doctor.getFullName() : "Unknown Doctor " + doctor.getUserID();
                                %>
                                <option value="<%= doctor.getUserID() %>" <%= String.valueOf(doctor.getUserID()).equals(request.getAttribute("formDoctorId")) ? "selected" : "" %>>
                                    <%= displayName %>
                                </option>
                                <% } %>
                            </select>
                            <span class="input-icon">👨‍⚕️</span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="prescriptionDetails" class="form-label">Chi Tiết Đơn Thuốc</label>
                        <div class="input-wrapper">
                            <textarea id="prescriptionDetails" name="prescriptionDetails" class="form-textarea" 
                                      placeholder="Nhập chi tiết đơn thuốc..." rows="4">${formPrescriptionDetails}</textarea>
                            <span class="input-icon">📝</span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="status" class="form-label required">Trạng Thái</label>
                        <div class="input-wrapper">
                            <select id="status" name="status" class="form-select" required>
                                <option value="" ${empty formStatus ? 'selected' : ''}>Chọn trạng thái...</option>
                                <option value="PENDING" ${formStatus == 'PENDING' ? 'selected' : ''}>Đang chờ</option>
                                <option value="APPROVED" ${formStatus == 'APPROVED' ? 'selected' : ''}>Đã duyệt</option>
                                <option value="CANCELLED" ${formStatus == 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
                            </select>
                            <span class="input-icon">🔄</span>
                        </div>
                    </div>
                </div>

                <div id="medicationList">
                    <div class="medication-group">
                        <div class="form-group">
                            <label for="medicationId_0" class="form-label required">Tên Thuốc</label>
                            <div class="input-wrapper">
                                <select id="medicationId_0" name="medicationIds" class="form-select" required>
                                    <option value="">Chọn thuốc...</option>
                                    <% 
                                        PrescriptionService prescriptionService = new PrescriptionService();
                                        List<Medication> medications = prescriptionService.getAllMedications();
                                        for (Medication med : medications) {
                                    %>
                                    <option value="<%= med.getMedicationID() %>">
                                        <%= med.getName() %> (<%= med.getDosage() %>)
                                    </option>
                                    <% } %>
                                </select>
                                <span class="input-icon">💊</span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="dosageInstructions_0" class="form-label required">Liều Uống</label>
                            <div class="input-wrapper">
                                <input type="text" id="dosageInstructions_0" name="dosageInstructions" class="form-input" 
                                       placeholder="Nhập liều uống (VD: 2 viên/ngày)..." required maxlength="100">
                                <span class="input-icon">📋</span>
                            </div>
                        </div>
                        <button type="button" class="remove-medication" onclick="removeMedication(this)">✕</button>
                    </div>
                </div>

                <button type="button" class="add-medication" onclick="addMedication()">Thêm Thuốc</button>

                <input type="hidden" name="save" value="true">

                <div class="form-actions">
                    <button type="submit" class="dental-submit">Thêm Đơn Thuốc</button>
                </div>
            </form>

            <div class="dental-nav">
                <a href="${pageContext.request.contextPath}/ViewPrescriptionServlet" class="dental-link">
                    <span>←</span>
                    <span>Quay lại danh sách đơn thuốc</span>
                </a>
            </div>
        </div>
    </div>

    <script>
        let medicationCount = 1;

        function addMedication() {
            const medicationList = document.getElementById('medicationList');
            const newMedication = document.createElement('div');
            newMedication.className = 'medication-group';
            newMedication.innerHTML = `
                <div class="form-group">
                    <label for="medicationId_${medicationCount}" class="form-label required">Tên Thuốc</label>
                    <div class="input-wrapper">
                        <select id="medicationId_${medicationCount}" name="medicationIds" class="form-select" required>
                            <option value="">Chọn thuốc...</option>
                            <% for (Medication med : medications) { %>
                            <option value="<%= med.getMedicationID() %>">
                                <%= med.getName() %> (<%= med.getDosage() %>)
                            </option>
                            <% } %>
                        </select>
                        <span class="input-icon">💊</span>
                    </div>
                </div>
                <div class="form-group">
                    <label for="dosageInstructions_${medicationCount}" class="form-label required">Liều Uống</label>
                    <div class="input-wrapper">
                        <input type="text" id="dosageInstructions_${medicationCount}" name="dosageInstructions" class="form-input" 
                               placeholder="Nhập liều uống (VD: 2 viên/ngày)..." required maxlength="100">
                        <span class="input-icon">📋</span>
                    </div>
                </div>
                <button type="button" class="remove-medication" onclick="removeMedication(this)">✕</button>
            `;
            medicationList.appendChild(newMedication);
            medicationCount++;
        }

        function removeMedication(button) {
            if (document.querySelectorAll('.medication-group').length > 1) {
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
                alert('Vui lòng chọn một bệnh nhân.');
                return false;
            }
            if (!doctorId) {
                alert('Vui lòng chọn một bác sĩ.');
                return false;
            }
            if (!status) {
                alert('Vui lòng chọn trạng thái.');
                return false;
            }
            for (let i = 0; i < medicationIds.length; i++) {
                if (!medicationIds[i].value) {
                    alert('Vui lòng chọn một loại thuốc.');
                    return false;
                }
                if (!dosageInstructions[i].value.trim()) {
                    alert('Vui lòng nhập liều uống cho thuốc.');
                    return false;
                }
            }
            return true;
        }
    </script>
</body>
</html>
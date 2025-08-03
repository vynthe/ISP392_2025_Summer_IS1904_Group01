<%-- 
    Document   : ReassignDoctorSchedule
    Created on : 03 Aug 2025
    Author     : Assistant
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi Bác Sĩ/Y Tá</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-green: #4CAF50;
            --secondary-green: #66BB6A;
            --light-green: #C8E6C9;
            --accent-blue: #2196F3;
            --text-dark: #333;
            --text-light: #fff;
            --background-light: #f4f7f6;
            --border-color: #e0e0e0;
            --shadow-light: rgba(0, 0, 0, 0.08);
            --warning-orange: #FF9800;
            --danger-red: #F44336;
        }

        body {
            font-family: 'Roboto', sans-serif;
            margin: 0;
            padding: 0;
            background-color: var(--background-light);
            color: var(--text-dark);
            line-height: 1.6;
        }

        .header {
            background-image: linear-gradient(to right, var(--primary-green), var(--secondary-green));
            color: var(--text-light);
            padding: 20px 0;
            text-align: center;
            box-shadow: 0 2px 10px var(--shadow-light);
            margin-bottom: 30px;
        }

        .header h1 {
            margin: 0;
            font-size: 2.2em;
            font-weight: 500;
        }

        .container {
            max-width: 900px;
            margin: 0 auto;
            background-color: var(--text-light);
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 20px var(--shadow-light);
        }

        .form-section {
            margin-bottom: 30px;
            padding: 25px;
            border: 1px solid var(--border-color);
            border-radius: 10px;
            background-color: #fafafa;
        }

        .section-title {
            color: var(--primary-green);
            font-size: 1.4em;
            font-weight: 500;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid var(--light-green);
        }

        .current-info {
            background-color: #e3f2fd;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 25px;
            border-left: 5px solid var(--accent-blue);
        }

        .current-info h3 {
            color: var(--accent-blue);
            margin-top: 0;
            font-size: 1.2em;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            padding: 8px 0;
            border-bottom: 1px dashed #ccc;
        }

        .info-label {
            font-weight: 500;
            color: #555;
            min-width: 120px;
        }

        .info-value {
            color: var(--text-dark);
            font-weight: 400;
        }

        .warning-box {
            background-color: #fff3e0;
            border: 1px solid var(--warning-orange);
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 25px;
            border-left: 5px solid var(--warning-orange);
        }

        .warning-box .warning-icon {
            color: var(--warning-orange);
            font-size: 1.2em;
            margin-right: 10px;
        }

        .available-doctors {
            background-color: #e8f5e9;
            padding: 20px;
            border-radius: 8px;
            border-left: 5px solid var(--primary-green);
        }

        .doctor-option {
            background-color: white;
            border: 2px solid var(--border-color);
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
        }

        .doctor-option:hover {
            border-color: var(--primary-green);
            box-shadow: 0 2px 10px rgba(76, 175, 80, 0.2);
            transform: translateY(-2px);
        }

        .doctor-option.selected {
            border-color: var(--primary-green);
            background-color: var(--light-green);
        }

        .doctor-option input[type="radio"] {
            position: absolute;
            opacity: 0;
            cursor: pointer;
        }

        .doctor-name {
            font-weight: 500;
            color: var(--primary-green);
            font-size: 1.1em;
            margin-bottom: 5px;
        }

        .doctor-details {
            color: #666;
            font-size: 0.9em;
        }

        .no-doctors {
            text-align: center;
            color: #666;
            font-style: italic;
            padding: 30px;
            background-color: #fafafa;
            border-radius: 8px;
            border: 2px dashed #ccc;
        }

        .button-group {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
        }

        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1em;
            font-weight: 500;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            text-align: center;
            min-width: 120px;
        }

        .btn-primary {
            background-color: var(--primary-green);
            color: var(--text-light);
        }

        .btn-primary:hover {
            background-color: #45a049;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(76, 175, 80, 0.3);
        }

        .btn-primary:disabled {
            background-color: #ccc;
            cursor: not-allowed;
            transform: none;
        }

        .btn-secondary {
            background-color: #f5f5f5;
            color: var(--text-dark);
            border: 1px solid var(--border-color);
        }

        .btn-secondary:hover {
            background-color: #e0e0e0;
            transform: translateY(-2px);
        }

        .error-message {
            background-color: #ffebee;
            color: var(--danger-red);
            padding: 15px;
            border-radius: 8px;
            border-left: 5px solid var(--danger-red);
            margin-bottom: 20px;
        }

        .success-message {
            background-color: #e8f5e9;
            color: var(--primary-green);
            padding: 15px;
            border-radius: 8px;
            border-left: 5px solid var(--primary-green);
            margin-bottom: 20px;
        }

        .patient-info {
            background-color: #fff8e1;
            padding: 15px;
            border-radius: 8px;
            border-left: 5px solid var(--warning-orange);
            margin-bottom: 20px;
        }

        .patient-info h4 {
            color: var(--warning-orange);
            margin-top: 0;
            margin-bottom: 10px;
        }

        @media (max-width: 768px) {
            .container {
                margin: 10px;
                padding: 20px;
            }

            .button-group {
                flex-direction: column;
            }

            .info-row {
                flex-direction: column;
                gap: 5px;
            }

            .info-label {
                min-width: auto;
                font-weight: 600;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>🔄 Đổi Bác Sĩ/Y Tá</h1>
    </div>

    <div class="container">
        <!-- Hiển thị thông báo lỗi hoặc thành công -->
        <c:if test="${not empty error}">
            <div class="error-message">
                <strong>❌ Lỗi:</strong> <c:out value="${error}"/>
            </div>
        </c:if>

        <c:if test="${not empty message}">
            <div class="success-message">
                <strong>✅ Thành công:</strong> <c:out value="${message}"/>
            </div>
        </c:if>

        <!-- Thông tin lịch hiện tại -->
        <div class="form-section">
            <h2 class="section-title">📋 Thông Tin Lịch Hiện Tại</h2>
            
            <div class="current-info">
                <h3>Thông tin ${role == 'Doctor' ? 'Bác sĩ' : 'Y tá'} hiện tại</h3>
                <div class="info-row">
                    <span class="info-label">👨‍⚕️ Họ tên:</span>
                    <span class="info-value"><c:out value="${fullName}"/></span>
                </div>
                <div class="info-row">
                    <span class="info-label">🏥 Vai trò:</span>
                    <span class="info-value">${role == 'Doctor' ? 'Bác sĩ' : 'Y tá'}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">📅 Ngày làm việc:</span>
                    <span class="info-value">
                        <c:choose>
                            <c:when test="${not empty slotDateStr}">
                                <c:out value="${slotDateStr}"/>
                            </c:when>
                            <c:otherwise>
                                Chưa có thông tin
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="info-row">
                    <span class="info-label">⏰ Giờ làm việc:</span>
                    <span class="info-value"><c:out value="${startTime}"/> - <c:out value="${endTime}"/></span>
                </div>
            </div>

            <!-- Thông tin bệnh nhân -->
            <c:if test="${not empty patientName and patientName != 'Chưa có bệnh nhân'}">
                <div class="patient-info">
                    <h4>👤 Thông tin bệnh nhân đã đặt lịch</h4>
                    <div class="info-row">
                        <span class="info-label">Tên bệnh nhân:</span>
                        <span class="info-value"><c:out value="${patientName}"/></span>
                    </div>
                </div>
            </c:if>

            <div class="warning-box">
                <span class="warning-icon">⚠️</span>
                <strong>Lưu ý quan trọng:</strong> 
                Việc đổi ${role == 'Doctor' ? 'bác sĩ' : 'y tá'} sẽ ảnh hưởng đến lịch hẹn của bệnh nhân. 
                Hệ thống sẽ tự động gửi thông báo cho bệnh nhân về sự thay đổi này.
            </div>
        </div>

        <!-- Danh sách bác sĩ/y tá khả dụng -->
        <div class="form-section">
            <h2 class="section-title">👥 Chọn ${role == 'Doctor' ? 'Bác Sĩ' : 'Y Tá'} Thay Thế</h2>
            
            <div class="available-doctors">
                <c:choose>
                    <c:when test="${not empty availableEmployees}">
                        <form action="${pageContext.request.contextPath}/ReassignScheduleDoctorNurseServlet" method="post" id="reassignForm">
                            <!-- Hidden fields để truyền thông tin -->
                            <input type="hidden" name="currentUserId" value="${userId}"/>
                            <input type="hidden" name="slotDate" value="${slotDate}"/>
                            <input type="hidden" name="startTime" value="${startTime}"/>
                            <input type="hidden" name="endTime" value="${endTime}"/>
                            <input type="hidden" name="role" value="${role}"/>
                            <input type="hidden" name="patientId" value="${patientId}"/>
                            <input type="hidden" name="currentFullName" value="${fullName}"/>
                            <input type="hidden" name="patientName" value="${patientName}"/>

                            <p style="margin-bottom: 20px; color: #666; font-style: italic;">
                                Tìm thấy <strong>${availableEmployees.size()}</strong> ${role == 'Doctor' ? 'bác sĩ' : 'y tá'} 
                                khả dụng trong cùng khung giờ và chưa có bệnh nhân đặt lịch:
                            </p>

                            <c:forEach var="employee" items="${availableEmployees}" varStatus="status">
                                <div class="doctor-option" onclick="selectDoctor(${employee.userID})">
                                    <input type="radio" name="newUserId" value="${employee.userID}" id="doctor_${employee.userID}"/>
                                    <div class="doctor-name">
                                        ${role == 'Doctor' ? '👨‍⚕️' : '👩‍⚕️'} <c:out value="${employee.fullName}"/>
                                    </div>
                                    <div class="doctor-details">
                                        <strong>Vai trò:</strong> ${employee.role == 'Doctor' ? 'Bác sĩ' : 'Y tá'} • 
                                        <strong>ID:</strong> ${employee.userID} • 
                                        <span style="color: var(--primary-green); font-weight: 500;">✅ Khả dụng</span>
                                    </div>
                                </div>
                            </c:forEach>

                            <div class="button-group">
                                <button type="submit" class="btn btn-primary" id="confirmBtn" disabled>
                                    🔄 Xác Nhận Đổi ${role == 'Doctor' ? 'Bác Sĩ' : 'Y Tá'}
                                </button>
                                <a href="${pageContext.request.contextPath}/ViewScheduleDoctorNurseServlet" class="btn btn-secondary">
                                    ❌ Hủy Bỏ
                                </a>
                            </div>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <div class="no-doctors">
                            <h3 style="color: #666; margin-top: 0;">😔 Không có ${role == 'Doctor' ? 'bác sĩ' : 'y tá'} khả dụng</h3>
                            <p>Hiện tại không có ${role == 'Doctor' ? 'bác sĩ' : 'y tá'} nào khả dụng trong khung giờ này 
                               (${startTime} - ${endTime}) vào ngày 
                               <c:choose>
                                   <c:when test="${not empty slotDateStr}">
                                       <c:out value="${slotDateStr}"/>
                                   </c:when>
                                   <c:otherwise>
                                       Chưa có thông tin
                                   </c:otherwise>
                               </c:choose>.</p>
                            <p style="color: #888; font-size: 0.9em;">
                                Điều này có thể do tất cả ${role == 'Doctor' ? 'bác sĩ' : 'y tá'} khác đều đã có bệnh nhân đặt lịch 
                                hoặc không có lịch làm việc trong khung giờ này.
                            </p>
                        </div>
                        
                        <div class="button-group">
                            <a href="${pageContext.request.contextPath}/ViewScheduleDoctorNurseServlet" class="btn btn-secondary">
                                ⬅️ Quay Lại Lịch
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <script>
        // Format date for display
        const slotDateFormatted = '${slotDateStr}';
        const startTime = '${startTime}';
        const endTime = '${endTime}';
        const role = '${role}';
        
        function selectDoctor(doctorId) {
            // Bỏ chọn tất cả các options khác
            document.querySelectorAll('.doctor-option').forEach(option => {
                option.classList.remove('selected');
            });
            
            // Chọn option hiện tại
            event.currentTarget.classList.add('selected');
            
            // Check radio button
            document.getElementById('doctor_' + doctorId).checked = true;
            
            // Enable confirm button
            document.getElementById('confirmBtn').disabled = false;
        }

        // Xác nhận trước khi submit
        document.getElementById('reassignForm')?.addEventListener('submit', function(e) {
            const selectedDoctor = document.querySelector('input[name="newUserId"]:checked');
            if (!selectedDoctor) {
                e.preventDefault();
                const roleText = role === 'Doctor' ? 'bác sĩ' : 'y tá';
                alert('Vui lòng chọn ' + roleText + ' thay thế!');
                return;
            }

            const selectedName = selectedDoctor.closest('.doctor-option').querySelector('.doctor-name').textContent.trim();
            const currentName = '${fullName}';
            const patientName = '${patientName}';
            
            let confirmMessage = `Bạn có chắc chắn muốn đổi từ:\n\n`;
            const roleText2 = role === 'Doctor' ? 'Bác sĩ' : 'Y tá';
            confirmMessage += `👨‍⚕️ ${roleText2} hiện tại: ${currentName}\n`;
            confirmMessage += `➡️ ${roleText2} mới: ${selectedName}\n\n`;
            
            if (patientName && patientName !== 'Chưa có bệnh nhân') {
                confirmMessage += `👤 Bệnh nhân: ${patientName}\n`;
                confirmMessage += `📅 Ngày: ${slotDateFormatted}\n`;
                confirmMessage += `⏰ Giờ: ${startTime} - ${endTime}\n\n`;
                confirmMessage += `⚠️ Bệnh nhân sẽ được thông báo về sự thay đổi này.`;
            }
            
            if (!confirm(confirmMessage)) {
                e.preventDefault();
            }
        });

        // Auto-focus vào option đầu tiên nếu có
        document.addEventListener('DOMContentLoaded', function() {
            const firstOption = document.querySelector('.doctor-option');
            if (firstOption) {
                firstOption.style.border = '2px dashed var(--primary-green)';
                firstOption.style.animation = 'pulse 2s infinite';
            }
        });

        // Add pulse animation
        const style = document.createElement('style');
        style.textContent = `
            @keyframes pulse {
                0% { box-shadow: 0 0 0 0 rgba(76, 175, 80, 0.4); }
                70% { box-shadow: 0 0 0 10px rgba(76, 175, 80, 0); }
                100% { box-shadow: 0 0 0 0 rgba(76, 175, 80, 0); }
            }
        `;
        document.head.appendChild(style);
    </script>
</body>
</html>
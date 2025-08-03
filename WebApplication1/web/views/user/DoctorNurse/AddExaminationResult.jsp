<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Kết Quả Khám Bệnh</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
            position: relative;
        }

        .header h1 {
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 8px;
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
        }

        .header .subtitle {
            font-size: 16px;
            opacity: 0.9;
            font-weight: 300;
            position: relative;
            z-index: 1;
        }

        .form-content {
            padding: 40px;
        }

        .message-box {
            padding: 16px 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            border: none;
            position: relative;
            animation: slideIn 0.5s ease-out;
        }

        .error-box {
            background: linear-gradient(135deg, #ff6b6b, #ee5a52);
            color: white;
            box-shadow: 0 4px 15px rgba(255, 107, 107, 0.3);
        }

        .success-box {
            background: linear-gradient(135deg, #51cf66, #40c057);
            color: white;
            box-shadow: 0 4px 15px rgba(81, 207, 102, 0.3);
        }

        .info-box {
            background: linear-gradient(135deg, #74b9ff, #0984e3);
            color: white;
            box-shadow: 0 4px 15px rgba(116, 185, 255, 0.3);
        }

        .warning-box {
            background: linear-gradient(135deg, #fdcb6e, #e17055);
            color: white;
            box-shadow: 0 4px 15px rgba(253, 203, 110, 0.3);
        }

        .form-section {
            margin-bottom: 35px;
            padding-bottom: 25px;
            border-bottom: 1px solid #e9ecef;
        }

        .form-section:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }

        .section-title {
            font-size: 18px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .appointment-details {
            background: linear-gradient(135deg, #a29bfe, #6c5ce7);
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 25px;
        }

        .appointment-details h3 {
            margin-bottom: 15px;
            font-size: 18px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .detail-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 10px;
            margin-top: 10px;
        }

        .detail-item {
            background: rgba(255, 255, 255, 0.1);
            padding: 8px 12px;
            border-radius: 6px;
            font-size: 14px;
        }

        .detail-label {
            font-weight: 600;
            opacity: 0.9;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .form-group {
            position: relative;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        label {
            display: block;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 8px;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .label-required::after {
            content: ' *';
            color: #e74c3c;
            font-weight: bold;
        }

        .input-wrapper {
            position: relative;
        }

        input[type="text"],
        input[type="number"],
        select,
        textarea {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            font-size: 15px;
            font-family: inherit;
            transition: all 0.3s ease;
            background: #fafbfc;
        }

        input[type="text"]:focus,
        input[type="number"]:focus,
        select:focus,
        textarea:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            transform: translateY(-1px);
        }

        select {
            cursor: pointer;
            appearance: none;
            background-image: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" width="12" height="8" viewBox="0 0 12 8"><path fill="%23667eea" d="M6 8L0 2h12z"/></svg>');
            background-repeat: no-repeat;
            background-position: right 16px center;
            padding-right: 45px;
        }

        textarea {
            resize: vertical;
            min-height: 100px;
            font-family: inherit;
        }

        .nurse-info {
            font-size: 12px;
            color: #6c757d;
            margin-top: 8px;
            padding: 12px 16px;
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            border-radius: 8px;
            border-left: 4px solid #2196f3;
        }

        .nurse-info.assigned {
            background: linear-gradient(135deg, #e8f5e8, #c8e6c9);
            border-left-color: #4caf50;
        }

        .nurse-info strong {
            color: #2c3e50;
            display: block;
            margin-bottom: 5px;
        }

        .status-container {
            display: flex;
            align-items: center;
            gap: 15px;
            background: linear-gradient(135deg, #51cf66, #40c057);
            padding: 15px 20px;
            border-radius: 10px;
            color: white;
            margin-top: 8px;
        }

        .status-option {
            display: none;
        }

        .status-label {
            display: flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .status-checkbox {
            width: 20px;
            height: 20px;
            border: 2px solid white;
            border-radius: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255, 255, 255, 0.2);
        }

        .status-option:checked + .status-label .status-checkbox {
            background: white;
            color: #51cf66;
        }

        .status-option:checked + .status-label .status-checkbox::after {
            content: '✓';
            font-weight: bold;
            font-size: 14px;
        }

        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 40px;
            justify-content: center;
        }

        .btn {
            padding: 14px 30px;
            border: none;
            border-radius: 50px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            min-width: 150px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #74b9ff 0%, #0984e3 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(116, 185, 255, 0.4);
        }

        .btn-secondary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(116, 185, 255, 0.4);
        }

        .form-hint {
            font-size: 12px;
            color: #6c757d;
            margin-top: 5px;
            font-style: italic;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @media (max-width: 768px) {
            .container {
                margin: 10px;
                border-radius: 10px;
            }

            .header {
                padding: 20px;
            }

            .header h1 {
                font-size: 24px;
            }

            .form-content {
                padding: 25px;
            }

            .form-row {
                grid-template-columns: 1fr;
                gap: 15px;
            }

            .detail-grid {
                grid-template-columns: 1fr;
            }

            .button-group {
                flex-direction: column;
                align-items: stretch;
            }
        }

        .loading {
            opacity: 0.7;
            pointer-events: none;
        }

        .no-nurse-message {
            background: linear-gradient(135deg, #fdcb6e, #e17055);
            color: white;
            padding: 15px 20px;
            border-radius: 10px;
            margin-top: 8px;
            text-align: center;
            font-weight: 500;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>
                🏥 Thêm Kết Quả Khám Bệnh
            </h1>
            <p class="subtitle">Hệ thống quản lý khám chữa bệnh</p>
        </div>

        <div class="form-content">
            <!-- Hiển thị thông báo lỗi hoặc thành công -->
            <c:if test="${not empty errorMessage}">
                <div class="message-box error-box">
                    <p>❌ ${errorMessage}</p>
                </div>
            </c:if>
            
            <c:if test="${not empty successMessage}">
                <div class="message-box success-box">
                    <p>✅ ${successMessage}</p>
                </div>
            </c:if>

            <c:if test="${not empty noNurseMessage}">
                <div class="message-box warning-box">
                    <p>⚠️ ${noNurseMessage}</p>
                </div>
            </c:if>

            <!-- Thông tin chi tiết lịch hẹn -->
            <c:if test="${not empty appointmentDetails}">
                <div class="appointment-details">
                    <h3>📅 Thông tin lịch hẹn #${appointmentDetails.appointmentId}</h3>
                    <div class="detail-grid">
                        <div class="detail-item">
                            <div class="detail-label">Bệnh nhân:</div>
                            ${appointmentDetails.patientName}
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Bác sĩ:</div>
                            ${appointmentDetails.doctorName}
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Dịch vụ:</div>
                            ${appointmentDetails.serviceName}
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Phòng:</div>
                            ${appointmentDetails.roomName}
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Ngày khám:</div>
                            ${appointmentDetails.slotDate}
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Giờ khám:</div>
                            ${appointmentDetails.startTime} - ${appointmentDetails.endTime}
                        </div>
                    </div>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/AddExaminationResultServlet" method="post" id="examForm">
                <div class="form-section">
                    <div class="section-title">
                        📋 Thông tin cơ bản
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="appointmentId" class="label-required">Mã Lịch Hẹn</label>
                            <div class="input-wrapper">
                                <input type="number" 
                                       id="appointmentId" 
                                       name="appointmentId" 
                                       value="${param.appointmentId != null ? param.appointmentId : appointmentDetails.appointmentId}" 
                                       required
                                       min="1"
                                       placeholder="Nhập mã lịch hẹn"
                                       ${not empty appointmentDetails ? 'readonly' : ''}>
                            </div>
                            <div class="form-hint">Mã định danh duy nhất của lịch hẹn</div>
                        </div>

                        <div class="form-group">
                            <label for="nurseId">Y Tá Hỗ Trợ</label>
                            <div class="input-wrapper">
                                <c:choose>
                                    <c:when test="${hasAssignedNurse}">
                                        <select id="nurseId" name="nurseId">
                                            <c:forEach var="nurse" items="${nurses}">
                                                <option value="${nurse.userID}" selected>
                                                    ${nurse.fullName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                        <div class="nurse-info assigned">
                                            <strong>✅ Y tá được gán cho lịch hẹn này:</strong>
                                            <c:forEach var="nurse" items="${nurses}">
                                                📞 ${nurse.phone != null ? nurse.phone : 'Chưa có SĐT'}<br>
                                                📧 ${nurse.email != null ? nurse.email : 'Chưa có email'}
                                            </c:forEach>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <select id="nurseId" name="nurseId" disabled>
                                            <option value="">-- Chưa có y tá được gán --</option>
                                        </select>
                                        <div class="no-nurse-message">
                                            ⚠️ Lịch hẹn này chưa được gán y tá hỗ trợ
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="form-hint">Y tá được gán tự động theo lịch hẹn</div>
                        </div>
                    </div>
                </div>

                <div class="form-section">
                    <div class="section-title">
                        🔄 Trạng thái khám
                    </div>
                    <div class="status-container">
                        <input type="radio" 
                               id="completed" 
                               name="status" 
                               value="Completed" 
                               class="status-option" 
                               checked>
                        <label for="completed" class="status-label">
                            <div class="status-checkbox"></div>
                            Hoàn thành khám bệnh
                        </label>
                    </div>
                </div>

                <div class="form-section">
                    <div class="section-title">
                        🩺 Thông tin y khoa
                    </div>

                    <div class="form-group">
                        <label for="diagnosis">Chuẩn đoán</label>
                        <div class="input-wrapper">
                            <textarea id="diagnosis" 
                                      name="diagnosis" 
                                      rows="4"
                                      placeholder="Nhập chuẩn đoán chi tiết của bác sĩ..." required="">${param.diagnosis}</textarea>
                        </div>
                        <div class="form-hint">Mô tả chi tiết tình trạng sức khỏe và chẩn đoán</div>
                    </div>

                    <div class="form-group">
                        <label for="notes">Ghi chú bổ sung</label>
                        <div class="input-wrapper">
                            <textarea id="notes" 
                                      name="notes" 
                                      rows="4"
                                      placeholder="Nhập ghi chú, lời khuyên, hoặc hướng dẫn điều trị..." required="">${param.notes}</textarea>
                        </div>
                        <div class="form-hint">Các ghi chú thêm, lời khuyên cho bệnh nhân hoặc hướng dẫn điều trị</div>
                    </div>
                </div>

                <div class="button-group">
                    <button type="submit" class="btn btn-primary" id="submitBtn">
                        💾 Lưu kết quả
                    </button>
                    <a href="${pageContext.request.contextPath}/ViewExaminationResults" class="btn btn-secondary">
                        ↩️ Quay lại
                    </a>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Form validation and enhancement
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('examForm');
            const submitBtn = document.getElementById('submitBtn');
            
            // Form submission handling
            form.addEventListener('submit', function(e) {
                submitBtn.innerHTML = '⏳ Đang lưu...';
                submitBtn.disabled = true;
                form.classList.add('loading');
                
                // Validate required fields
                const appointmentId = document.getElementById('appointmentId').value;
                if (!appointmentId) {
                    e.preventDefault();
                    alert('Vui lòng nhập mã lịch hẹn!');
                    resetSubmitButton();
                    return;
                }
            });
            
            function resetSubmitButton() {
                submitBtn.innerHTML = '💾 Lưu kết quả';
                submitBtn.disabled = false;
                form.classList.remove('loading');
            }
            
            // Auto-hide success/error messages after 5 seconds
            const messageBoxes = document.querySelectorAll('.message-box');
            messageBoxes.forEach(box => {
                setTimeout(() => {
                    box.style.opacity = '0';
                    box.style.transform = 'translateY(-20px)';
                    setTimeout(() => {
                        box.style.display = 'none';
                    }, 300);
                }, 5000);
            });
            
            // Enhanced textarea auto-resize
            const textareas = document.querySelectorAll('textarea');
            textareas.forEach(textarea => {
                textarea.addEventListener('input', function() {
                    this.style.height = 'auto';
                    this.style.height = this.scrollHeight + 'px';
                });
            });

            // Show appointment details if appointmentId is provided
            const appointmentIdInput = document.getElementById('appointmentId');
            if (appointmentIdInput.value && !appointmentIdInput.readOnly) {
                // If there's an appointmentId but no details loaded, show a button to load
                const loadBtn = document.createElement('button');
                loadBtn.type = 'button';
                loadBtn.className = 'btn btn-secondary';
                loadBtn.innerHTML = '🔄 Tải thông tin lịch hẹn';
                loadBtn.onclick = function() {
                    window.location.href = '${pageContext.request.contextPath}/AddExaminationResultServlet?appointmentId=' + appointmentIdInput.value;
                };
                
                const buttonGroup = document.querySelector('.button-group');
                if (buttonGroup && !${not empty appointmentDetails}) {
                    buttonGroup.insertBefore(loadBtn, buttonGroup.firstChild);
                }
            }
        });
    </script>
</body>
</html>
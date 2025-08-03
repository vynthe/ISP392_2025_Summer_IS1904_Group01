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
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #f8fafc;
            color: #334155;
            line-height: 1.6;
            min-height: 100vh;
        }

        .main-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 24px;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* Header Section */
        .page-header {
            background: white;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            padding: 32px;
            margin-bottom: 24px;
            border-left: 4px solid #3b82f6;
        }

        .page-title {
            font-size: 28px;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .page-subtitle {
            font-size: 16px;
            color: #64748b;
            font-weight: 400;
        }

        /* Content Grid */
        .content-grid {
            display: grid;
            grid-template-columns: 1fr 400px;
            gap: 24px;
            flex: 1;
        }

        /* Main Content */
        .main-content {
            background: white;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        /* Sidebar */
        .sidebar {
            display: flex;
            flex-direction: column;
            gap: 24px;
        }

        /* Message Alerts */
        .alert {
            padding: 16px 20px;
            border-radius: 8px;
            font-weight: 500;
            animation: slideDown 0.3s ease-out;
            border-left: 4px solid;
        }

        .alert-error {
            background: #fef2f2;
            color: #dc2626;
            border-color: #dc2626;
        }

        .alert-success {
            background: #f0fdf4;
            color: #16a34a;
            border-color: #16a34a;
        }

        .alert-warning {
            background: #fffbeb;
            color: #d97706;
            border-color: #d97706;
        }

        /* Appointment Info Card */
        .appointment-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .card-header {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
            padding: 20px 24px;
            font-weight: 600;
            font-size: 16px;
        }

        .card-content {
            padding: 24px;
        }

        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 24px;
        }

        .info-item {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .info-label {
            font-size: 12px;
            font-weight: 600;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .info-value {
            font-size: 14px;
            font-weight: 500;
            color: #1e293b;
        }

        /* Status Section */
        .status-section {
            background: #f8fafc;
            border-radius: 8px;
            padding: 20px;
            border: 1px solid #e2e8f0;
        }

        .status-title {
            font-size: 14px;
            font-weight: 600;
            color: #374151;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .status-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 12px;
        }

        .status-row:last-child {
            margin-bottom: 0;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .status-badge.success {
            background: #dcfce7;
            color: #16a34a;
        }

        .status-badge.warning {
            background: #fef3c7;
            color: #d97706;
        }

        /* Form Styles */
        .form-container {
            padding: 32px;
        }

        .form-section {
            margin-bottom: 32px;
        }

        .section-header {
            margin-bottom: 24px;
            padding-bottom: 12px;
            border-bottom: 2px solid #f1f5f9;
        }

        .section-title {
            font-size: 18px;
            font-weight: 600;
            color: #1e293b;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .form-group {
            margin-bottom: 24px;
        }

        .form-label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            color: #374151;
            margin-bottom: 8px;
        }

        .form-label.required::after {
            content: ' *';
            color: #dc2626;
        }

        .form-input {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            font-family: inherit;
            transition: all 0.2s ease;
            background: white;
        }

        .form-input:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        .form-textarea {
            min-height: 120px;
            resize: vertical;
            font-family: inherit;
        }

        .form-hint {
            font-size: 12px;
            color: #6b7280;
            margin-top: 4px;
        }

        /* Button Styles */
        .button-group {
            display: flex;
            gap: 16px;
            justify-content: flex-end;
            padding-top: 24px;
            border-top: 1px solid #f1f5f9;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s ease;
            min-width: 140px;
            justify-content: center;
        }

        .btn-primary {
            background: #3b82f6;
            color: white;
        }

        .btn-primary:hover:not(:disabled) {
            background: #2563eb;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
        }

        .btn-secondary {
            background: #f1f5f9;
            color: #475569;
            border: 1px solid #e2e8f0;
        }

        .btn-secondary:hover {
            background: #e2e8f0;
            transform: translateY(-1px);
        }

        .btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }

        /* Animations */
        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Responsive Design */
        @media (max-width: 1024px) {
            .content-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }
            
            .sidebar {
                order: -1;
            }
        }

        @media (max-width: 768px) {
            .main-container {
                padding: 16px;
            }

            .page-header {
                padding: 24px;
            }

            .page-title {
                font-size: 24px;
            }

            .form-container {
                padding: 24px;
            }

            .info-grid {
                grid-template-columns: 1fr;
                gap: 16px;
            }

            .button-group {
                flex-direction: column-reverse;
            }

            .btn {
                width: 100%;
            }
        }

        /* Loading State */
        .loading {
            opacity: 0.7;
            pointer-events: none;
        }

        .loading .btn-primary {
            background: #9ca3af;
        }
    </style>
</head>
<body>
    <div class="main-container">
        <!-- Page Header -->
        <div class="page-header">
            <h1 class="page-title">
                <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.29 1.51 4.04 3 5.5l7 7Z"/>
                    <path d="M12 5L8 21l4-7 4 7-4-16"/>
                </svg>
                Thêm Kết Quả Khám Bệnh
            </h1>
            <p class="page-subtitle">Ghi nhận kết quả khám và chẩn đoán của bác sĩ</p>
        </div>

        <!-- Content Grid -->
        <div class="content-grid">
            <!-- Main Content -->
            <div class="main-content">
                <div class="form-container">
                    <!-- Messages -->
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-error">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="display: inline; margin-right: 8px;">
                                <circle cx="12" cy="12" r="10"/>
                                <line x1="15" y1="9" x2="9" y2="15"/>
                                <line x1="9" y1="9" x2="15" y2="15"/>
                            </svg>
                            ${errorMessage}
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="display: inline; margin-right: 8px;">
                                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
                                <polyline points="22,4 12,14.01 9,11.01"/>
                            </svg>
                            ${successMessage}
                        </div>
                    </c:if>

                    <c:if test="${not empty noNurseMessage}">
                        <div class="alert alert-warning">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="display: inline; margin-right: 8px;">
                                <path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3"/>
                                <line x1="12" y1="9" x2="12" y2="13"/>
                                <line x1="12" y1="17" x2="12.01" y2="17"/>
                            </svg>
                            ${noNurseMessage}
                        </div>
                    </c:if>

                    <!-- Form -->
                    <form action="${pageContext.request.contextPath}/AddExaminationResultServlet" method="post" id="examForm">
                        <!-- Hidden Fields -->
                        <input type="hidden" name="appointmentId" value="${param.appointmentId != null ? param.appointmentId : appointmentDetails.appointmentId}">
                        
                        <c:if test="${hasAssignedNurse}">
                            <c:forEach var="nurse" items="${nurses}">
                                <input type="hidden" name="nurseId" value="${nurse.userID}">
                            </c:forEach>
                        </c:if>

                        <!-- Medical Information Section -->
                        <div class="form-section">
                            <div class="section-header">
                                <h2 class="section-title">
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.29 1.51 4.04 3 5.5l7 7Z"/>
                                    </svg>
                                    Thông tin y khoa
                                </h2>
                            </div>

                            <div class="form-group">
                                <label for="diagnosis" class="form-label required">Chuẩn đoán</label>
                                <textarea id="diagnosis" 
                                          name="diagnosis" 
                                          class="form-input form-textarea"
                                          placeholder="Nhập chuẩn đoán chi tiết của bác sĩ..."
                                          required>${param.diagnosis}</textarea>
                                <div class="form-hint">Mô tả chi tiết tình trạng sức khỏe và chẩn đoán chính xác</div>
                            </div>

                            <div class="form-group">
                                <label for="notes" class="form-label required">Ghi chú và hướng dẫn</label>
                                <textarea id="notes" 
                                          name="notes" 
                                          class="form-input form-textarea"
                                          placeholder="Nhập ghi chú, lời khuyên, và hướng dẫn điều trị..."
                                          required>${param.notes}</textarea>
                                <div class="form-hint">Các ghi chú bổ sung, lời khuyên cho bệnh nhân và hướng dẫn điều trị</div>
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="button-group">
                            <a href="${pageContext.request.contextPath}/ViewExaminationResults" class="btn btn-secondary">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="m12 19-7-7 7-7"/>
                                    <path d="M19 12H5"/>
                                </svg>
                                Quay lại
                            </a>
                            <button type="submit" class="btn btn-primary" id="submitBtn">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/>
                                    <polyline points="17,21 17,13 7,13 7,21"/>
                                    <polyline points="7,3 7,8 15,8"/>
                                </svg>
                                Lưu kết quả
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Sidebar -->
            <div class="sidebar">
                <!-- Appointment Details -->
                <c:if test="${not empty appointmentDetails}">
                    <div class="appointment-card">
                        <div class="card-header">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="display: inline; margin-right: 8px;">
                                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/>
                                <line x1="16" y1="2" x2="16" y2="6"/>
                                <line x1="8" y1="2" x2="8" y2="6"/>
                                <line x1="3" y1="10" x2="21" y2="10"/>
                            </svg>
                            Lịch hẹn #${appointmentDetails.appointmentId}
                        </div>
                        <div class="card-content">
                            <div class="info-grid">
                                <div class="info-item">
                                    <div class="info-label">Bệnh nhân</div>
                                    <div class="info-value">${appointmentDetails.patientName}</div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">Bác sĩ</div>
                                    <div class="info-value">${appointmentDetails.doctorName}</div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">Y tá hỗ trợ</div>
                                    <div class="info-value">
                                        <c:choose>
                                            <c:when test="${hasAssignedNurse}">
                                                <c:forEach var="nurse" items="${nurses}">
                                                    ${nurse.fullName}
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #d97706; font-weight: 500;">Chưa được gán</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">Dịch vụ</div>
                                    <div class="info-value">${appointmentDetails.serviceName}</div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">Phòng khám</div>
                                    <div class="info-value">${appointmentDetails.roomName}</div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">Ngày khám</div>
                                    <div class="info-value">${appointmentDetails.slotDate}</div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">Thời gian</div>
                                    <div class="info-value">${appointmentDetails.startTime} - ${appointmentDetails.endTime}</div>
                                </div>
                            </div>

                            <div class="status-section">
                                <div class="status-title">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
                                        <polyline points="22,4 12,14.01 9,11.01"/>
                                    </svg>
                                    Trạng thái khám bệnh
                                </div>
                                
                                <div class="status-row">
                                    <span style="font-size: 13px; color: #64748b;">Trạng thái:</span>
                                    <div class="status-badge success">
                                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
                                            <polyline points="22,4 12,14.01 9,11.01"/>
                                        </svg>
                                        Hoàn thành
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('examForm');
            const submitBtn = document.getElementById('submitBtn');
            
            // Form submission handling h
            form.addEventListener('submit', function(e) {
                const diagnosis = document.getElementById('diagnosis').value.trim();
                const notes = document.getElementById('notes').value.trim();
                
                if (!diagnosis || !notes) {
                    e.preventDefault();
                    alert('Vui lòng nhập đầy đủ thông tin chuẩn đoán và ghi chú!');
                    return;
                }
                
                // Show loading state
                submitBtn.innerHTML = `
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="animation: spin 1s linear infinite;">
                        <path d="M21 12a9 9 0 11-6.219-8.56"/>
                    </svg>
                    Đang lưu...
                `;
                submitBtn.disabled = true;
                form.classList.add('loading');
            });
            
            // Auto-hide alerts after 5 seconds
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                setTimeout(() => {
                    alert.style.opacity = '0';
                    alert.style.transform = 'translateY(-10px)';
                    setTimeout(() => {
                        alert.remove();
                    }, 300);
                }, 5000);
            });
            
            // Auto-resize textareas
            const textareas = document.querySelectorAll('textarea');
            textareas.forEach(textarea => {
                textarea.addEventListener('input', function() {
                    this.style.height = 'auto';
                    this.style.height = this.scrollHeight + 'px';
                });
                
                // Initial resize
                textarea.style.height = textarea.scrollHeight + 'px';
            });
        });
    </script>

    <style>
        @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }
    </style>
</body>
</html>

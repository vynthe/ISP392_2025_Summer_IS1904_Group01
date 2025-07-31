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

        .header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="white" opacity="0.1"/><circle cx="75" cy="75" r="1" fill="white" opacity="0.1"/><circle cx="50" cy="10" r="0.5" fill="white" opacity="0.15"/><circle cx="20" cy="80" r="0.5" fill="white" opacity="0.15"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
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

        .message-box::before {
            content: '';
            position: absolute;
            left: 20px;
            top: 50%;
            transform: translateY(-50%);
            width: 20px;
            height: 20px;
            background: white;
            border-radius: 50%;
            opacity: 0.2;
        }

        .message-box p {
            font-weight: 500;
            margin-left: 35px;
            font-size: 15px;
        }

        .form-grid {
            display: grid;
            gap: 25px;
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

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
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

        .appointment-info {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
        }

        .appointment-info h3 {
            margin-bottom: 10px;
            font-size: 18px;
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

            .button-group {
                flex-direction: column;
                align-items: stretch;
            }
        }

        .loading {
            opacity: 0.7;
            pointer-events: none;
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

            <!-- Thông tin lịch hẹn -->
            <c:if test="${not empty param.appointmentId}">
                <div class="appointment-info">
                    <h3>📅 Thông tin lịch hẹn</h3>
                    <p><strong>Mã lịch hẹn:</strong> #${param.appointmentId}</p>
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
                                       value="${param.appointmentId}" 
                                       required
                                       min="1"
                                       placeholder="Nhập mã lịch hẹn">
                            </div>
                            <div class="form-hint">Mã định danh duy nhất của lịch hẹn</div>
                        </div>

                        <div class="form-group">
                            <label for="nurseId">Mã Y Tá</label>
                            <div class="input-wrapper">
                                <input type="number" 
                                       id="nurseId" 
                                       name="nurseId" 
                                       value="${param.nurseId}"
                                       min="1"
                                       placeholder="Nhập mã y tá (tùy chọn)">
                            </div>
                            <div class="form-hint">Để trống nếu không có y tá hỗ trợ</div>
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
                                      placeholder="Nhập chuẩn đoán chi tiết của bác sĩ...">${param.diagnosis}</textarea>
                        </div>
                        <div class="form-hint">Mô tả chi tiết tình trạng sức khỏe và chẩn đoán</div>
                    </div>

                    <div class="form-group">
                        <label for="notes">Ghi chú bổ sung</label>
                        <div class="input-wrapper">
                            <textarea id="notes" 
                                      name="notes" 
                                      rows="4"
                                      placeholder="Nhập ghi chú, lời khuyên, hoặc hướng dẫn điều trị...">${param.notes}</textarea>
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
        });
    </script>
</body>
</html>
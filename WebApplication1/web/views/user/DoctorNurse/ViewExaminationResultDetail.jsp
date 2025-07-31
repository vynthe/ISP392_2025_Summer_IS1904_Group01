<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Kết Quả Khám - Nha Khoa PDC</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px 0;
            color: #333;
        }

        .main-container {
            max-width: 900px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .header-section {
            text-align: center;
            margin-bottom: 40px;
            color: white;
        }

        .header-section h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 10px;
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }

        .header-section p {
            font-size: 1.1rem;
            opacity: 0.9;
        }

        .detail-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            overflow: hidden;
            margin-bottom: 30px;
            animation: slideUp 0.6s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .card-header {
            background: linear-gradient(135deg, #4ecdc4, #44a08d);
            padding: 25px 30px;
            color: white;
            position: relative;
            overflow: hidden;
        }

        .card-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 100%;
            height: 200%;
            background: rgba(255,255,255,0.1);
            transform: rotate(45deg);
            transition: all 0.3s ease;
        }

        .card-header:hover::before {
            right: -30%;
        }

        .card-header h2 {
            font-size: 1.8rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 15px;
            position: relative;
            z-index: 1;
        }

        .card-header i {
            font-size: 1.5rem;
        }

        .card-body {
            padding: 35px 30px;
        }

        .error-message {
            background: linear-gradient(135deg, #ff6b6b, #ee5a6f);
            color: white;
            padding: 20px;
            border-radius: 12px;
            text-align: center;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            font-weight: 500;
            animation: shake 0.5s ease-in-out;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }

        .detail-grid {
            display: grid;
            gap: 25px;
        }

        .detail-item {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            border-radius: 15px;
            padding: 25px;
            border-left: 5px solid #4ecdc4;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .detail-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(78, 205, 196, 0.1), transparent);
            transition: left 0.5s ease;
        }

        .detail-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            border-left-color: #44a08d;
        }

        .detail-item:hover::before {
            left: 100%;
        }

        .detail-label {
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 700;
            color: #2c3e50;
            font-size: 1.1rem;
            margin-bottom: 10px;
        }

        .detail-label i {
            color: #4ecdc4;
            font-size: 1.2rem;
            width: 20px;
        }

        .detail-value {
            font-size: 1rem;
            color: #555;
            line-height: 1.6;
            padding-left: 32px;
        }

        .no-data {
            color: #95a5a6;
            font-style: italic;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 40px;
            flex-wrap: wrap;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 15px 30px;
            font-size: 1rem;
            font-weight: 600;
            text-decoration: none;
            border-radius: 50px;
            transition: all 0.3s ease;
            cursor: pointer;
            border: none;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            position: relative;
            overflow: hidden;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            background: rgba(255,255,255,0.2);
            border-radius: 50%;
            transform: translate(-50%, -50%);
            transition: all 0.3s ease;
        }

        .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
        }

        .btn:hover::before {
            width: 300px;
            height: 300px;
        }

        .btn:active {
            transform: translateY(-1px);
        }

        .debug-section {
            background: #2c3e50;
            color: white;
            border-radius: 15px;
            padding: 25px;
            margin-top: 30px;
            border: 2px dashed #4ecdc4;
        }

        .debug-section h3 {
            color: #4ecdc4;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .debug-item {
            background: rgba(78, 205, 196, 0.1);
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            border-left: 3px solid #4ecdc4;
        }

        .debug-item:last-child {
            margin-bottom: 0;
        }

        .status-indicator {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
        }

        .status-success {
            background: rgba(46, 204, 113, 0.1);
            color: #27ae60;
            border: 1px solid rgba(46, 204, 113, 0.3);
        }

        .status-error {
            background: rgba(231, 76, 60, 0.1);
            color: #e74c3c;
            border: 1px solid rgba(231, 76, 60, 0.3);
        }

        @media (max-width: 768px) {
            .header-section h1 {
                font-size: 2rem;
            }
            
            .card-body {
                padding: 25px 20px;
            }
            
            .detail-item {
                padding: 20px;
            }
            
            .action-buttons {
                flex-direction: column;
                align-items: center;
            }
            
            .btn {
                width: 100%;
                max-width: 300px;
                justify-content: center;
            }
        }

        @media (max-width: 480px) {
            .main-container {
                padding: 0 15px;
            }
            
            .detail-value {
                padding-left: 0;
                margin-top: 5px;
            }
        }

        /* Loading animation */
        .loading {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid rgba(78, 205, 196, 0.3);
            border-radius: 50%;
            border-top-color: #4ecdc4;
            animation: spin 1s ease-in-out infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <div class="main-container">
        <div class="header-section">
            <h1><i class="fas fa-file-medical"></i> Chi Tiết Kết Quả Khám</h1>
            <p>Thông tin chi tiết về kết quả khám bệnh của bạn</p>
        </div>

        <div class="detail-card">
            <div class="card-header">
                <h2>
                    <i class="fas fa-clipboard-check"></i>
                    Thông Tin Kết Quả Khám
                </h2>
            </div>
            
            <div class="card-body">
                <c:if test="${not empty error}">
                    <div class="error-message">
                        <i class="fas fa-exclamation-triangle"></i>
                        ${error}
                    </div>
                </c:if>
                
                <c:choose>
                    <c:when test="${not empty resultDetails}">
                        <div class="status-indicator status-success">
                            <i class="fas fa-check-circle"></i>
                            Dữ liệu đã được tải thành công
                        </div>
                        
                        <div class="detail-grid">
                            <div class="detail-item">
                                <div class="detail-label">
                                    <i class="fas fa-user-md"></i>
                                    Bác Sĩ Khám
                                </div>
                                <div class="detail-value">
                                    <c:choose>
                                        <c:when test="${not empty resultDetails.doctorName}">
                                            <strong><c:out value="${resultDetails.doctorName}" /></strong>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="no-data">Không có thông tin</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-label">
                                    <i class="fas fa-user"></i>
                                    Bệnh Nhân
                                </div>
                                <div class="detail-value">
                                    <c:choose>
                                        <c:when test="${not empty resultDetails.patientName}">
                                            <strong><c:out value="${resultDetails.patientName}" /></strong>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="no-data">Không có thông tin</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-label">
                                    <i class="fas fa-stethoscope"></i>
                                    Chẩn Đoán
                                </div>
                                <div class="detail-value">
                                    <c:choose>
                                        <c:when test="${not empty examinationResultDAO.getDiagnosisByAppointmentId(resultDetails.appointmentId)}">
                                            <c:out value="${examinationResultDAO.getDiagnosisByAppointmentId(resultDetails.appointmentId)}" />
                                        </c:when>
                                        <c:otherwise>
                                            <span class="no-data">Chưa có chẩn đoán</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-label">
                                    <i class="fas fa-sticky-note"></i>
                                    Ghi Chú Từ Bác Sĩ
                                </div>
                                <div class="detail-value">
                                    <c:choose>
                                        <c:when test="${not empty resultDetails.notes}">
                                            <c:out value="${resultDetails.notes}" />
                                        </c:when>
                                        <c:otherwise>
                                            <span class="no-data">Không có ghi chú</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="status-indicator status-error">
                            <i class="fas fa-times-circle"></i>
                            Không tìm thấy dữ liệu
                        </div>
                        <div class="error-message">
                            <i class="fas fa-search"></i>
                            Không tìm thấy thông tin chi tiết kết quả khám
                        </div>
                    </c:otherwise>
                </c:choose>
                
                <div class="action-buttons">
                    <button class="btn btn-primary" onclick="window.location.href='${pageContext.request.contextPath}/ViewExaminationResults'">
                        <i class="fas fa-arrow-left"></i>
                        Quay Lại Danh Sách
                    </button>
                </div>
            </div>
        </div>
        
        <%-- Debug section - chỉ hiển thị khi cần thiết --%>
        <%
        Map<String, Object> resultDetails = (Map<String, Object>) request.getAttribute("resultDetails");
        if (request.getParameter("debug") != null && "true".equals(request.getParameter("debug"))) {
        %>
            <div class="debug-section">
                <h3>
                    <i class="fas fa-bug"></i>
                    Thông Tin Debug
                </h3>
                <%
                if (resultDetails != null) {
                %>
                    <div class="debug-item"><strong>Bác Sĩ (Debug):</strong> <%= resultDetails.get("doctorName") %></div>
                    <div class="debug-item"><strong>Bệnh Nhân (Debug):</strong> <%= resultDetails.get("patientName") %></div>
                    <div class="debug-item"><strong>Chẩn Đoán (Debug):</strong> <%= resultDetails.get("diagnosis") %></div>
                    <div class="debug-item"><strong>Ghi Chú (Debug):</strong> <%= resultDetails.get("notes") %></div>
                    <div class="debug-item"><strong>Appointment ID:</strong> <%= resultDetails.get("appointmentId") %></div>
                <%
                } else {
                %>
                    <div class="debug-item" style="color: #e74c3c;">
                        <i class="fas fa-exclamation-triangle"></i>
                        Không tìm thấy resultDetails trong request scope
                    </div>
                <%
                }
                %>
            </div>
        <%
        }
        %>
    </div>

    <script>
        // Add loading effect for buttons
        document.querySelectorAll('.btn').forEach(button => {
            button.addEventListener('click', function(e) {
                if (this.textContent.includes('Quay Lại')) {
                    const icon = this.querySelector('i');
                    icon.className = 'fas fa-spinner fa-spin';
                    setTimeout(() => {
                        icon.className = 'fas fa-arrow-left';
                    }, 500);
                }
            });
        });

        // Add smooth scroll and fade effects
        window.addEventListener('load', function() {
            const detailItems = document.querySelectorAll('.detail-item');
            detailItems.forEach((item, index) => {
                item.style.opacity = '0';
                item.style.transform = 'translateY(20px)';
                
                setTimeout(() => {
                    item.style.transition = 'all 0.6s ease';
                    item.style.opacity = '1';
                    item.style.transform = 'translateY(0)';
                }, index * 100);
            });
        });

        // Enhanced hover effects
        document.querySelectorAll('.detail-item').forEach(item => {
            item.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-5px) scale(1.02)';
            });
            
            item.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0) scale(1)';
            });
        });
    </script>
</body>
</html>
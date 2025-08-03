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
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 50%, #3b82f6 100%);
            min-height: 100vh;
            color: #333;
            display: flex;
            flex-direction: column;
        }

        .main-container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 40px 20px;
            flex: 1;
        }

        .header-section {
            text-align: center;
            margin-bottom: 50px;
            color: white;
            position: relative;
        }

        .header-section::before {
            content: '';
            position: absolute;
            top: -20px;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 4px;
            background: linear-gradient(90deg, #10b981, #06b6d4, #3b82f6);
            border-radius: 2px;
        }

        .header-section h1 {
            font-size: 2.8rem;
            font-weight: 700;
            margin-bottom: 15px;
            text-shadow: 0 4px 8px rgba(0,0,0,0.3);
            letter-spacing: -0.5px;
        }

        .header-section p {
            font-size: 1.2rem;
            opacity: 0.95;
            max-width: 600px;
            margin: 0 auto;
            line-height: 1.6;
        }

        .clinic-logo {
            width: 80px;
            height: 80px;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
            margin: 0 auto 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            color: #10b981;
            border: 3px solid rgba(16, 185, 129, 0.3);
            backdrop-filter: blur(10px);
        }

        .detail-card {
            background: rgba(255, 255, 255, 0.98);
            border-radius: 25px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.15);
            overflow: hidden;
            margin-bottom: 40px;
            animation: slideUp 0.8s ease-out;
            border: 1px solid rgba(59, 130, 246, 0.1);
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(40px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .card-header {
            background: linear-gradient(135deg, #1e40af 0%, #3b82f6 50%, #06b6d4 100%);
            padding: 30px 35px;
            color: white;
            position: relative;
            overflow: hidden;
        }

        .card-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
            animation: shimmer 3s infinite;
        }

        @keyframes shimmer {
            0% { left: -100%; }
            50% { left: 100%; }
            100% { left: 100%; }
        }

        .card-header h2 {
            font-size: 2rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 15px;
            position: relative;
            z-index: 1;
            text-shadow: 0 2px 4px rgba(0,0,0,0.2);
        }

        .card-header i {
            font-size: 1.8rem;
            padding: 10px;
            background: rgba(255,255,255,0.2);
            border-radius: 12px;
            backdrop-filter: blur(5px);
        }

        .card-body {
            padding: 40px 35px;
            background: linear-gradient(145deg, #f8fafc 0%, #ffffff 100%);
        }

        .error-message {
            background: linear-gradient(135deg, #dc2626, #ef4444);
            color: white;
            padding: 20px 25px;
            border-radius: 15px;
            text-align: center;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            font-weight: 500;
            animation: shake 0.6s ease-in-out;
            box-shadow: 0 8px 25px rgba(220, 38, 38, 0.2);
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }

        .detail-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 25px;
        }

        .detail-item {
            background: linear-gradient(145deg, #ffffff, #f1f5f9);
            border-radius: 18px;
            padding: 28px;
            border-left: 5px solid #3b82f6;
            border-right: 1px solid rgba(59, 130, 246, 0.1);
            border-top: 1px solid rgba(59, 130, 246, 0.1);
            border-bottom: 1px solid rgba(59, 130, 246, 0.1);
            transition: all 0.4s ease;
            position: relative;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(59, 130, 246, 0.08);
        }

        .detail-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(59, 130, 246, 0.05), transparent);
            transition: left 0.6s ease;
        }

        .detail-item:hover {
            transform: translateY(-3px) scale(1.01);
            box-shadow: 0 12px 35px rgba(59, 130, 246, 0.15);
            border-left-color: #1d4ed8;
        }

        .detail-item:hover::before {
            left: 100%;
        }

        .detail-label {
            display: flex;
            align-items: center;
            gap: 15px;
            font-weight: 700;
            color: #1e40af;
            font-size: 1.15rem;
            margin-bottom: 12px;
        }

        .detail-label i {
            color: #3b82f6;
            font-size: 1.3rem;
            width: 24px;
            height: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #dbeafe, #bfdbfe);
            border-radius: 8px;
            padding: 8px;
        }

        .detail-value {
            font-size: 1.05rem;
            color: #475569;
            line-height: 1.7;
            padding-left: 39px;
            font-weight: 500;
        }

        .detail-value strong {
            color: #1e40af;
            font-weight: 600;
        }

        .no-data {
            color: #94a3b8;
            font-style: italic;
            opacity: 0.8;
        }

        .action-buttons {
            display: flex;
            gap: 20px;
            justify-content: center;
            margin-top: 45px;
            flex-wrap: wrap;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 12px;
            padding: 16px 35px;
            font-size: 1.05rem;
            font-weight: 600;
            text-decoration: none;
            border-radius: 50px;
            transition: all 0.4s ease;
            cursor: pointer;
            border: none;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            position: relative;
            overflow: hidden;
            box-shadow: 0 6px 20px rgba(0,0,0,0.1);
        }

        .btn-primary {
            background: linear-gradient(135deg, #1e40af 0%, #3b82f6 50%, #06b6d4 100%);
            color: white;
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
            transition: all 0.4s ease;
        }

        .btn:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 35px rgba(59, 130, 246, 0.3);
        }

        .btn:hover::before {
            width: 400px;
            height: 400px;
        }

        .btn:active {
            transform: translateY(-2px);
        }

        .status-indicator {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 12px 20px;
            border-radius: 25px;
            font-size: 0.95rem;
            font-weight: 600;
            margin-bottom: 25px;
        }

        .status-success {
            background: linear-gradient(135deg, #dcfce7, #bbf7d0);
            color: #166534;
            border: 2px solid rgba(34, 197, 94, 0.2);
        }

        .status-error {
            background: linear-gradient(135deg, #fef2f2, #fecaca);
            color: #991b1b;
            border: 2px solid rgba(239, 68, 68, 0.2);
        }

        .debug-section {
            background: linear-gradient(135deg, #1e293b, #334155);
            color: white;
            border-radius: 20px;
            padding: 30px;
            margin-top: 40px;
            border: 2px dashed #3b82f6;
            backdrop-filter: blur(10px);
        }

        .debug-section h3 {
            color: #06b6d4;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 1.3rem;
        }

        .debug-item {
            background: rgba(59, 130, 246, 0.1);
            border-radius: 12px;
            padding: 18px;
            margin-bottom: 15px;
            border-left: 4px solid #3b82f6;
            backdrop-filter: blur(5px);
        }

        .debug-item:last-child {
            margin-bottom: 0;
        }

        /* Medical theme enhancements */
        .medical-pattern {
            position: relative;
        }

        .medical-pattern::after {
            content: '';
            position: absolute;
            top: 10px;
            right: 15px;
            width: 20px;
            height: 20px;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="%233b82f6" stroke-width="2"><path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.29 1.51 4.04 3 5.5l11 11z"/></svg>') no-repeat center;
            opacity: 0.3;
        }

        @media (max-width: 768px) {
            .header-section h1 {
                font-size: 2.2rem;
            }
            
            .card-body {
                padding: 30px 25px;
            }
            
            .detail-item {
                padding: 25px 20px;
            }
            
            .detail-grid {
                grid-template-columns: 1fr;
            }
            
            .action-buttons {
                flex-direction: column;
                align-items: center;
            }
            
            .btn {
                width: 100%;
                max-width: 350px;
                justify-content: center;
            }

            .detail-value {
                padding-left: 0;
                margin-top: 8px;
            }
        }

        @media (max-width: 480px) {
            .main-container {
                padding: 30px 15px;
            }
            
            .header-section h1 {
                font-size: 1.9rem;
            }
            
            .detail-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }
        }

        /* Loading animation */
        .loading {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid rgba(59, 130, 246, 0.3);
            border-radius: 50%;
            border-top-color: #3b82f6;
            animation: spin 1s ease-in-out infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        /* Professional dental clinic styling */
        .professional-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* Footer styles from the second file */
        footer {
            background: linear-gradient(135deg, #1e40af, #1e3a8a);
            color: white;
            padding: 50px 0 20px;
            width: 100%;
            margin-top: auto;
            position: relative;
        }

        footer::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, #10b981, #06b6d4, #3b82f6);
        }

        .footer-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .footer-content {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            flex-wrap: wrap;
            gap: 30px;
            margin-bottom: 40px;
        }

        .footer-section {
            flex: 1;
            min-width: 250px;
        }

        .footer-section h3 {
            font-size: 1.4rem;
            margin-bottom: 20px;
            color: #06b6d4;
            position: relative;
            font-weight: 600;
        }

        .footer-section h3::after {
            content: '';
            position: absolute;
            left: 0;
            bottom: -8px;
            width: 50px;
            height: 3px;
            background: linear-gradient(90deg, #3b82f6, #06b6d4);
            border-radius: 2px;
        }

        .footer-section p {
            line-height: 1.8;
            margin-bottom: 15px;
            opacity: 0.9;
            color: #e2e8f0;
        }

        .contact-info p {
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .contact-info i {
            color: #06b6d4;
            width: 18px;
        }

        .footer-links {
            list-style: none;
        }

        .footer-links li {
            margin-bottom: 12px;
        }

        .footer-links a {
            color: rgba(226, 232, 240, 0.9);
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            position: relative;
            padding: 5px 0;
        }

        .footer-links a::before {
            content: '';
            position: absolute;
            left: 0;
            bottom: 0;
            width: 0;
            height: 2px;
            background: #06b6d4;
            transition: width 0.3s ease;
        }

        .footer-links a:hover {
            color: #06b6d4;
            transform: translateX(8px);
        }

        .footer-links a:hover::before {
            width: 100%;
        }

        .footer-links i {
            margin-right: 10px;
            width: 18px;
            color: #3b82f6;
        }

        .social-links {
            display: flex;
            gap: 15px;
            margin-top: 25px;
        }

        .social-links a {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 45px;
            height: 45px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            color: white;
            text-decoration: none;
            transition: all 0.4s ease;
            backdrop-filter: blur(5px);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .social-links a:hover {
            background: linear-gradient(135deg, #3b82f6, #06b6d4);
            transform: translateY(-3px) scale(1.1);
            box-shadow: 0 8px 25px rgba(59, 130, 246, 0.3);
        }

        .newsletter-form {
            display: flex;
            margin-top: 20px;
            gap: 10px;
        }

        .newsletter-input {
            flex: 1;
            padding: 12px 18px;
            border: none;
            border-radius: 25px;
            background: rgba(255, 255, 255, 0.1);
            color: white;
            border: 2px solid transparent;
            transition: all 0.3s ease;
            backdrop-filter: blur(5px);
        }

        .newsletter-input::placeholder {
            color: rgba(255, 255, 255, 0.7);
        }

        .newsletter-input:focus {
            outline: none;
            border-color: #06b6d4;
            background: rgba(255, 255, 255, 0.15);
            box-shadow: 0 0 0 3px rgba(6, 182, 212, 0.1);
        }

        .newsletter-btn {
            padding: 12px 25px;
            background: linear-gradient(135deg, #3b82f6, #06b6d4);
            border: none;
            border-radius: 25px;
            color: white;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 600;
        }

        .newsletter-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(59, 130, 246, 0.4);
        }

        .footer-bottom {
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            padding-top: 25px;
            text-align: center;
        }

        .footer-bottom p {
            opacity: 0.8;
            margin: 15px 0;
            color: #cbd5e1;
        }

        .footer-bottom-links {
            display: flex;
            gap: 25px;
            list-style: none;
            justify-content: center;
            flex-wrap: wrap;
        }

        .footer-bottom-links a {
            color: rgba(203, 213, 225, 0.8);
            text-decoration: none;
            font-size: 0.9rem;
            transition: color 0.3s ease;
        }

        .footer-bottom-links a:hover {
            color: #06b6d4;
        }

        @media (max-width: 768px) {
            .footer-content {
                flex-direction: column;
                text-align: center;
            }

            .newsletter-form {
                flex-direction: column;
            }

            .social-links {
                justify-content: center;
            }

            .footer-bottom-links {
                flex-direction: column;
                gap: 15px;
            }
        }
    </style>
</head>
<body>
    <div class="main-container">
        <div class="header-section">
            <div class="clinic-logo">
                <i class="fas fa-tooth"></i>
            </div>
            <h1><i class="fas fa-file-medical"></i> Chi Tiết Kết Quả Khám</h1>
            <p>Hệ thống quản lý kết quả khám bệnh chuyên nghiệp - Nha Khoa PDC</p>
        </div>

        <div class="detail-card medical-pattern">
            <div class="professional-badge">
                Đạt chuẩn Bộ Y tế
            </div>
            <div class="card-header">
                <h2>
                    <i class="fas fa-clipboard-check"></i>
                    Thông Tin Kết Quả Khám Bệnh
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
                            Dữ liệu đã được tải thành công từ hệ thống
                        </div>
                        
                        <div class="detail-grid">
                            <div class="detail-item">
                                <div class="detail-label">
                                    <i class="fas fa-user-md"></i>
                                    Bác Sĩ Điều Trị
                                </div>
                                <div class="detail-value">
                                    <c:choose>
                                        <c:when test="${not empty resultDetails.doctorName}">
                                            <strong>BS. <c:out value="${resultDetails.doctorName}" /></strong>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="no-data">Thông tin chưa được cập nhật</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-label">
                                    <i class="fas fa-user-nurse"></i>
                                    Y Tá Hỗ Trợ
                                </div>
                                <div class="detail-value">
                                    <c:choose>
                                        <c:when test="${not empty resultDetails.nurseName}">
                                            <strong>YT. <c:out value="${resultDetails.nurseName}" /></strong>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="no-data">Thông tin chưa được cập nhật</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-label">
                                    <i class="fas fa-user"></i>
                                    Thông Tin Bệnh Nhân
                                </div>
                                <div class="detail-value">
                                    <c:choose>
                                        <c:when test="${not empty resultDetails.patientName}">
                                            <strong><c:out value="${resultDetails.patientName}" /></strong>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="no-data">Thông tin chưa được cập nhật</span>
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
                                            <strong><c:out value="${examinationResultDAO.getDiagnosisByAppointmentId(resultDetails.appointmentId)}" /></strong>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="no-data">Chẩn đoán đang được xử lý</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-label">
                                    <i class="fas fa-notes-medical"></i>
                                    Nhận Xét & Lời Khuyên Từ Bác Sĩ
                                </div>
                                <div class="detail-value">
                                    <c:choose>
                                        <c:when test="${not empty resultDetails.notes}">
                                            <c:out value="${resultDetails.notes}" />
                                        </c:when>
                                        <c:otherwise>
                                            <span class="no-data">Bác sĩ chưa có ghi chú thêm</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="status-indicator status-error">
                            <i class="fas fa-times-circle"></i>
                            Không thể tải dữ liệu từ hệ thống
                        </div>
                        <div class="error-message">
                            <i class="fas fa-database"></i>
                            Không tìm thấy thông tin chi tiết kết quả khám trong hệ thống
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
                    Thông Tin Debug Hệ Thống
                </h3>
                <%
                if (resultDetails != null) {
                %>
                    <div class="debug-item"><strong>Bác Sĩ (Debug):</strong> <%= resultDetails.get("doctorName") %></div>
                    <div class="debug-item"><strong>Y Tá (Debug):</strong> <%= resultDetails.get("nurseName") %></div>
                    <div class="debug-item"><strong>Bệnh Nhân (Debug):</strong> <%= resultDetails.get("patientName") %></div>
                    <div class="debug-item"><strong>Chẩn Đoán (Debug):</strong> <%= resultDetails.get("diagnosis") %></div>
                    <div class="debug-item"><strong>Ghi Chú (Debug):</strong> <%= resultDetails.get("notes") %></div>
                    <div class="debug-item"><strong>Appointment ID:</strong> <%= resultDetails.get("appointmentId") %></div>
                <%
                } else {
                %>
                    <div class="debug-item" style="color: #ef4444;">
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

    <!-- Footer từ file thứ hai -->
    <footer>
        <div class="footer-container">
            <div class="footer-content">
                <div class="footer-section">
                    <h3><i class="fas fa-tooth"></i> Về Nha Khoa PDC</h3>
                    <p>Chúng tôi là phòng khám nha khoa hàng đầu, cam kết mang lại nụ cười khỏe mạnh và tự tin với công nghệ tiên tiến và đội ngũ chuyên gia giàu kinh nghiệm.</p>
                    <div class="contact-info">
                        <p><i class="fas fa-map-marker-alt"></i> Địa Chỉ: ĐH FPT, Hòa Lạc</p>
                        <p><i class="fas fa-phone"></i> Hotline: 1900 2024</p>
                        <p><i class="fas fa-clock"></i> Thời gian: 7:30 - 17:00 (Thứ 2 - Thứ 7)</p>
                        <p><i class="fas fa-envelope"></i> Email: PhongKhamPDC@gmail.com</p>
                    </div>
                    <div class="social-links">
                        <a href="#" title="Facebook"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" title="Zalo"><i class="fab fa-whatsapp"></i></a>
                        <a href="#" title="Instagram"><i class="fab fa-instagram"></i></a>
                    </div>
                </div>

                <div class="footer-section">
                    <h3><i class="fas fa-link"></i> Liên Kết Nhanh</h3>
                    <ul class="footer-links">
                        <li><a href="${pageContext.request.contextPath}/views/common/HomePage.jsp"><i class="fas fa-home"></i> Trang Chủ</a></li>
                        <li><a href="${pageContext.request.contextPath}/BookAppointmentGuestServlet"><i class="fas fa-calendar-check"></i> Đăng Kí Tư Vấn</a></li>
                        <li><a href="#"><i class="fas fa-info-circle"></i> Giới Thiệu</a></li>               
                        <li><a href="#"><i class="fas fa-question-circle"></i> Hỏi Đáp</a></li>
                    </ul>
                </div>

                <div class="footer-section">
                    <h3><i class="fas fa-handshake"></i> Dịch Vụ Nổi Bật</h3>
                    <ul class="footer-links">
                        <li><i class="fas fa-tooth"></i> Cấy Ghép Implant</li>
                        <li><i class="fas fa-grip-lines"></i> Chỉnh Nha Mắc Cài</li>
                        <li><i class="fas fa-child"></i> Nha Khoa Trẻ Em</li>
                        <li><i class="fas fa-procedures"></i> Nhổ Răng Khôn</li>
                        <li><i class="fas fa-smile"></i> Nha Khoa Thẩm Mỹ</li>
                    </ul>
                </div>

                <div class="footer-section">
                    <h3><i class="fas fa-paper-plane"></i> Đăng Ký Tư Vấn</h3>
                    <p>Nhận tư vấn miễn phí và cập nhật thông tin sức khỏe răng miệng.</p>
                    <form class="newsletter-form" action="${pageContext.request.contextPath}/NewsletterServlet" method="post">
                        <input type="email" class="newsletter-input" name="email" placeholder="Nhập email của bạn..." required>
                        <button type="submit" class="newsletter-btn">
                            <i class="fas fa-paper-plane"></i>
                        </button>
                    </form>
                    <p style="margin-top: 15px;"><i class="fas fa-shield-alt"></i> Bảo hành trọn đời cho Implant</p>
                </div>
            </div>

            <div class="footer-bottom">
                <p>© 2025 Nha Khoa PDC. Đạt chuẩn Bộ Y tế. Tất cả quyền được bảo lưu.</p>
                <ul class="footer-bottom-links">
                    <li><a href="#">Chính Sách Bảo Mật</a></li>
                    <li><a href="#">Điều Khoản Sử Dụng</a></li>
                    <li><a href="#">Chính Sách Bảo Hành</a></li>
                </ul>
            </div>
        </div>
    </footer>

    <script>
        // Enhanced button loading effects
        document.querySelectorAll('.btn').forEach(button => {
            button.addEventListener('click', function(e) {
                if (this.textContent.includes('Quay Lại')) {
                    const icon = this.querySelector('i');
                    const originalClass = icon.className;
                    icon.className = 'fas fa-spinner fa-spin';
                    
                    // Add loading text
                    const originalText = this.innerHTML;
                    this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang tải...';
                    
                    setTimeout(() => {
                        this.innerHTML = originalText;
                    }, 800);
                }
            });
        });

        // Enhanced page load animations
        window.addEventListener('load', function() {
            // Animate header elements
            const headerElements = document.querySelectorAll('.header-section > *');
            headerElements.forEach((element, index) => {
                element.style.opacity = '0';
                element.style.transform = 'translateY(-30px)';
                
                setTimeout(() => {
                    element.style.transition = 'all 0.8s cubic-bezier(0.4, 0.0, 0.2, 1)';
                    element.style.opacity = '1';
                    element.style.transform = 'translateY(0)';
                }, index * 200);
            });

            // Animate detail items with stagger effect
            const detailItems = document.querySelectorAll('.detail-item');
            detailItems.forEach((item, index) => {
                item.style.opacity = '0';
                item.style.transform = 'translateX(-50px) scale(0.9)';
                
                setTimeout(() => {
                    item.style.transition = 'all 0.8s cubic-bezier(0.4, 0.0, 0.2, 1)';
                    item.style.opacity = '1';
                    item.style.transform = 'translateX(0) scale(1)';
                }, 400 + (index * 150));
            });

            // Animate footer sections
            const footerSections = document.querySelectorAll('.footer-section');
            footerSections.forEach((section, index) => {
                section.style.opacity = '0';
                section.style.transform = 'translateY(30px)';
                
                setTimeout(() => {
                    section.style.transition = 'all 0.6s ease';
                    section.style.opacity = '1';
                    section.style.transform = 'translateY(0)';
                }, 1000 + (index * 100));
            });
        });

        // Enhanced hover effects for detail items
        document.querySelectorAll('.detail-item').forEach(item => {
            item.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-8px) scale(1.02)';
                this.style.boxShadow = '0 20px 50px rgba(59, 130, 246, 0.2)';
                
                // Animate the icon
                const icon = this.querySelector('.detail-label i');
                if (icon) {
                    icon.style.transform = 'scale(1.2) rotate(5deg)';
                }
            });
            
            item.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0) scale(1)';
                this.style.boxShadow = '0 4px 15px rgba(59, 130, 246, 0.08)';
                
                // Reset icon animation
                const icon = this.querySelector('.detail-label i');
                if (icon) {
                    icon.style.transform = 'scale(1) rotate(0deg)';
                }
            });
        });

        // Newsletter form enhanced handling
        document.querySelector('.newsletter-form').addEventListener('submit', function(e) {
            e.preventDefault();
            const email = this.querySelector('.newsletter-input').value;
            const submitBtn = this.querySelector('.newsletter-btn');
            
            if (email) {
                // Add loading state
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
                submitBtn.disabled = true;
                
                // Simulate API call
                setTimeout(() => {
                    // Show success message
                    const successMsg = document.createElement('div');
                    successMsg.style.cssText = `
                        position: fixed;
                        top: 20px;
                        right: 20px;
                        background: linear-gradient(135deg, #10b981, #059669);
                        color: white;
                        padding: 15px 25px;
                        border-radius: 10px;
                        box-shadow: 0 10px 30px rgba(16, 185, 129, 0.3);
                        z-index: 1000;
                        font-weight: 600;
                        animation: slideInRight 0.5s ease;
                    `;
                    successMsg.innerHTML = '<i class="fas fa-check-circle"></i> Đăng ký thành công! Cảm ơn bạn.';
                    document.body.appendChild(successMsg);
                    
                    // Reset form
                    this.querySelector('.newsletter-input').value = '';
                    submitBtn.innerHTML = '<i class="fas fa-paper-plane"></i>';
                    submitBtn.disabled = false;
                    
                    // Remove success message after 3 seconds
                    setTimeout(() => {
                        successMsg.remove();
                    }, 3000);
                }, 1500);
            }
        });

        // Enhanced footer link interactions
        document.querySelectorAll('.footer-links a').forEach(link => {
            link.addEventListener('mouseenter', function() {
                this.style.paddingLeft = '15px';
                const icon = this.querySelector('i');
                if (icon) {
                    icon.style.transform = 'scale(1.2)';
                    icon.style.color = '#06b6d4';
                }
            });
            
            link.addEventListener('mouseleave', function() {
                this.style.paddingLeft = '0';
                const icon = this.querySelector('i');
                if (icon) {
                    icon.style.transform = 'scale(1)';
                    icon.style.color = '#3b82f6';
                }
            });
        });

        // Parallax effect for professional badge
        window.addEventListener('scroll', function() {
            const badge = document.querySelector('.professional-badge');
            if (badge) {
                const scrolled = window.pageYOffset;
                badge.style.transform = `translateY(${scrolled * 0.1}px)`;
            }
        });

        // Add CSS animation keyframes dynamically
        const style = document.createElement('style');
        style.textContent = `
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
            
            .detail-label i {
                transition: all 0.3s cubic-bezier(0.4, 0.0, 0.2, 1);
            }
            
            .footer-links i {
                transition: all 0.3s ease;
            }
        `;
        document.head.appendChild(style);
    </script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Xác Nhận Đặt Lịch Khám</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* ===== GLOBAL STYLES ===== */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            line-height: 1.6;
        }

        /* ===== HEADER STYLES ===== */
        .main-header {
            background: linear-gradient(135deg, #2c3e50 0%, #3498db 100%);
            color: white;
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .header-top {
            background: rgba(0,0,0,0.1);
            padding: 10px 0;
            font-size: 14px;
        }

        .header-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header-contact {
            display: flex;
            gap: 25px;
        }

        .header-contact span {
            display: flex;
            align-items: center;
            gap: 6px;
            opacity: 0.9;
            transition: opacity 0.3s;
        }

        .header-contact span:hover {
            opacity: 1;
        }

        .header-user {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 8px;
            background: rgba(255,255,255,0.1);
            padding: 6px 12px;
            border-radius: 20px;
            transition: background 0.3s;
        }

        .user-info:hover {
            background: rgba(255,255,255,0.2);
        }

        .header-main {
            padding: 20px 0;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 24px;
            font-weight: bold;
            text-decoration: none;
            color: white;
        }

        .logo i {
            font-size: 32px;
            color: #ecf0f1;
        }

        .main-nav {
            display: flex;
            list-style: none;
            gap: 5px;
        }

        .main-nav a {
            color: white;
            text-decoration: none;
            padding: 12px 18px;
            border-radius: 8px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 500;
        }

        .main-nav a:hover {
            background: rgba(255,255,255,0.15);
            transform: translateY(-2px);
        }

        .main-nav a.active {
            background: #e74c3c;
            box-shadow: 0 4px 15px rgba(231, 76, 60, 0.3);
        }

        /* ===== MAIN CONTENT ===== */
        .main-content {
            flex: 1;
            padding: 30px 20px;
        }

        .page-container {
            max-width: 900px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px 30px;
            text-align: center;
            position: relative;
        }

        .page-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="white" opacity="0.1"/><circle cx="75" cy="75" r="1" fill="white" opacity="0.1"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
            opacity: 0.3;
        }

        .page-header h1 {
            font-size: 32px;
            font-weight: 300;
            margin-bottom: 10px;
            position: relative;
            z-index: 1;
        }

        .page-header .subtitle {
            font-size: 16px;
            opacity: 0.9;
            position: relative;
            z-index: 1;
        }

        .page-content {
            padding: 40px;
        }

        /* ===== ALERTS ===== */
        .alert {
            padding: 16px 20px;
            margin-bottom: 25px;
            border-radius: 12px;
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 12px;
            border-left: 4px solid;
        }

        .alert-success {
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            border-left-color: #28a745;
            color: #155724;
        }

        .alert-error {
            background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
            border-left-color: #dc3545;
            color: #721c24;
        }

        /* ===== FORM STYLES ===== */
        .form-section {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 16px;
            padding: 35px;
            border: 1px solid #dee2e6;
        }

        .form-section h3 {
            color: #2d3748;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 20px;
            font-weight: 600;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            margin-bottom: 25px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group label {
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 15px;
        }

        .form-group label i {
            color: #667eea;
            width: 18px;
        }

        .value-display {
            background: white;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            padding: 14px 16px;
            color: #4a5568;
            font-weight: 500;
            transition: all 0.3s ease;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .value-display:hover {
            border-color: #cbd5e0;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }

        .form-group select {
            padding: 14px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            font-size: 16px;
            background: white;
            color: #2d3748;
            transition: all 0.3s ease;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .form-group select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.15);
        }

        .required {
            color: #e53e3e;
            font-weight: bold;
        }

        /* ===== BUTTONS ===== */
        .btn-container {
            text-align: center;
            margin-top: 35px;
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn {
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            padding: 14px 28px;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-secondary {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white;
        }

        .loading {
            display: none;
            text-align: center;
            margin-top: 20px;
            color: #667eea;
            font-weight: 500;
        }

        .loading i {
            animation: spin 1s linear infinite;
            margin-right: 10px;
        }

        @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        /* ===== FOOTER STYLES ===== */
        .main-footer {
            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
            color: white;
            margin-top: auto;
        }

        .footer-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 50px 20px 20px;
        }

        .footer-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 40px;
            margin-bottom: 40px;
        }

        .footer-section h4 {
            color: #3498db;
            margin-bottom: 20px;
            font-size: 18px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
        }

        .footer-section ul {
            list-style: none;
        }

        .footer-section ul li {
            margin-bottom: 10px;
        }

        .footer-section ul li a {
            color: #bdc3c7;
            text-decoration: none;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 5px 0;
        }

        .footer-section ul li a:hover {
            color: #3498db;
            padding-left: 10px;
        }

        .footer-section p {
            color: #bdc3c7;
            line-height: 1.7;
            margin-bottom: 12px;
        }

        .social-links {
            display: flex;
            gap: 15px;
            margin-top: 20px;
        }

        .social-links a {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 45px;
            height: 45px;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
            color: white;
            font-size: 18px;
            transition: all 0.3s;
            text-decoration: none;
        }

        .social-links a:hover {
            background: #3498db;
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(52, 152, 219, 0.3);
        }

        .footer-bottom {
            border-top: 1px solid rgba(255,255,255,0.1);
            padding-top: 25px;
            text-align: center;
            color: #95a5a6;
        }

        .footer-bottom p {
            margin: 8px 0;
        }

        /* ===== RESPONSIVE DESIGN ===== */
        @media (max-width: 768px) {
            .header-top {
                display: none;
            }

            .header-container {
                flex-direction: column;
                gap: 20px;
                padding: 0 15px;
            }

            .main-nav {
                flex-wrap: wrap;
                justify-content: center;
                gap: 8px;
            }

            .main-nav a {
                padding: 10px 14px;
                font-size: 14px;
            }

            .main-content {
                padding: 20px 15px;
            }

            .page-container {
                border-radius: 15px;
                margin: 0 5px;
            }

            .page-header {
                padding: 30px 20px;
            }

            .page-header h1 {
                font-size: 26px;
            }

            .page-content {
                padding: 25px 20px;
            }

            .form-section {
                padding: 25px 20px;
            }

            .form-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .btn-container {
                flex-direction: column;
                align-items: center;
            }

            .btn {
                width: 100%;
                max-width: 280px;
                justify-content: center;
            }

            .footer-grid {
                grid-template-columns: 1fr;
                gap: 30px;
            }

            .social-links {
                justify-content: center;
            }
        }

        @media (max-width: 480px) {
            .logo {
                font-size: 20px;
            }

            .logo i {
                font-size: 28px;
            }

            .page-header h1 {
                font-size: 22px;
            }

            .form-section h3 {
                font-size: 18px;
            }
        }
    </style>
</head>

<body>
    <!-- ===== HEADER ===== -->
    <header class="main-header">
        <div class="header-top">
            <div class="header-container">
             
                <div class="header-user">
                    <c:if test="${not empty currentUser}">
                        <div class="user-info">
                            <i class="fas fa-user-circle"></i>
                            <span>Xin chào, ${fn:escapeXml(currentUser.fullName)}</span>
                        </div>
                    </c:if>
                 
                </div>
            </div>
        </div>
        
        <div class="header-main">
            <div class="header-container">
                <a href="${pageContext.request.contextPath}/" class="logo">
                    <i class="fas fa-hospital"></i>
                    <span>Phòng Khám PDC</span>
                </a>
                <nav>
                    <ul class="main-nav">
                        <li><a href="${pageContext.request.contextPath}/views/user/Patient/PatientDashBoard.jsp "><i class="fas fa-home"></i> Trang chủ</a></li>
                        <li><a href="${pageContext.request.contextPath}/views/user/Patient/ViewDetailBook.jsp"><i class="fas fa-calendar-alt"></i>Đặt Lịch Khám</a></li>
                        <li><a href="${pageContext.request.contextPath}/views/user/Patient/BookAppointment.jsp "><i class="fas fa-calendar-alt"></i>Xác Nhận Đặt Lịch</a></li>
                      
                    </ul>
                </nav>
            </div>
        </div>
    </header>

    <!-- ===== MAIN CONTENT ===== -->
    <main class="main-content">
        <div class="page-container">
            <div class="page-header">
                <h1><i class="fas fa-calendar-plus"></i>Xác Nhận Đặt Lịch</h1>
                <div class="subtitle">Hệ thống quản lý lịch khám bệnh chuyên nghiệp</div>
            </div>

            <div class="page-content">
                <!-- Success Alert -->
                <c:if test="${not empty success}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        <span>${fn:escapeXml(success)}</span>
                    </div>
                </c:if>

                <!-- Booking Form -->
                <div class="form-section">
                    <h3><i class="fas fa-clipboard-list"></i> Thông Tin Đặt Lịch</h3>

                    <form action="${pageContext.request.contextPath}/BookAppointmentServlet" 
                          method="post" id="appointmentForm" onsubmit="return validateAndSubmitForm(this)">

                        <div class="form-grid">
                            <!-- Doctor Name -->
                            <div class="form-group">
                                <label><i class="fas fa-user-md"></i> Tên Bác Sĩ:</label>
                                <div class="value-display">
                                    ${fn:escapeXml(requestScope.doctorName != null ? requestScope.doctorName : 'Không xác định')}
                                </div>
                                <input type="hidden" name="doctorId" 
                                       value="${fn:escapeXml(param.doctorId != null ? param.doctorId : requestScope.doctorId)}">
                            </div>

                            <!-- Time Slot -->
                            <div class="form-group">
                                <label><i class="fas fa-clock"></i> Khung Giờ:</label>
                                <div class="value-display">
                                    <c:choose>
                                        <c:when test="${not empty requestScope.slotTime and requestScope.slotTime != 'Chưa chọn'}">
                                            ${fn:escapeXml(requestScope.slotTime)}
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #dc3545; font-weight: bold;">
                                                <i class="fas fa-exclamation-triangle"></i> Chưa chọn khung giờ
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <input type="hidden" name="slotId" 
                                       value="${not empty requestScope.slotId ? requestScope.slotId : (not empty param.slotId ? param.slotId : '')}">
                            </div>

                            <!-- Room -->
                            <div class="form-group">
                                <label><i class="fas fa-door-open"></i> Tên Phòng:</label>
                                <div class="value-display">
                                    <c:choose>
                                        <c:when test="${not empty requestScope.roomName and requestScope.roomName != 'Chưa có phòng'}">
                                            ${fn:escapeXml(requestScope.roomName)}
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #dc3545;">Chưa có phòng</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <input type="hidden" name="roomId" 
                                       value="${fn:escapeXml(not empty requestScope.roomId ? requestScope.roomId : (not empty param.roomId ? param.roomId : doctorDetails.roomID))}">
                            </div>

                            <!-- Patient Name -->
                            <div class="form-group">
                                <label><i class="fas fa-user"></i> Tên Bệnh Nhân:</label>
                                <div class="value-display">
                                    <c:choose>
                                        <c:when test="${not empty requestScope.patientName}">
                                            ${fn:escapeXml(requestScope.patientName)}
                                        </c:when>
                                        <c:otherwise>
                                            ${fn:escapeXml(currentUser.fullName != null ? currentUser.fullName : 'Không xác định')}
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <input type="hidden" name="patientId" 
                                       value="${fn:escapeXml(not empty currentUser ? currentUser.userID : (param.patientId != null ? param.patientId : requestScope.patientId))}">
                            </div>
                        </div>

                        <!-- Service Selection -->
                        <div class="form-group">
                            <label for="serviceId">
                                <i class="fas fa-stethoscope"></i> 
                                Chọn Dịch Vụ <span class="required">*</span>
                            </label>
                            <select name="serviceIdTemp" id="serviceId" required>
                                <option value="">-- Vui lòng chọn dịch vụ --</option>
                                <c:forEach var="service" items="${doctorDetails.services}">
                                    <option value="${fn:escapeXml(service.serviceID)}" 
                                            ${(param.serviceIdTemp == service.serviceID || requestScope.serviceIdTemp == service.serviceID) ? 'selected' : ''}>
                                        ${fn:escapeXml(service.serviceName)} - 
                                        <fmt:formatNumber value="${service.price}" pattern="#,##0" type="number"/> VNĐ
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Buttons -->
                        <div class="btn-container">
                            <button type="button" class="btn btn-secondary" onclick="history.back()">
                                <i class="fas fa-arrow-left"></i> Quay Lại
                            </button>
                            <button type="submit" class="btn btn-primary" id="submitBtn">
                                <i class="fas fa-calendar-check"></i> Xác Nhận Đặt Lịch
                            </button>
                        </div>

                        <!-- Loading -->
                        <div class="loading" id="loadingDiv">
                            <i class="fas fa-spinner"></i> Đang xử lý yêu cầu...
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </main>

    <!-- ===== FOOTER ===== -->
    <footer class="main-footer">
        <div class="footer-content">
            <div class="footer-grid">
                <!-- Company Info -->
                <div class="footer-section">
                    <h4><i class="fas fa-hospital"></i> Healthcare System</h4>
                    <p>Hệ thống chăm sóc sức khỏe hàng đầu Việt Nam, mang đến dịch vụ y tế chất lượng cao với đội ngũ bác sĩ chuyên nghiệp.</p>
                    <div class="social-links">
                        <a href="#" title="Facebook"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" title="Twitter"><i class="fab fa-twitter"></i></a>
                        <a href="#" title="Instagram"><i class="fab fa-instagram"></i></a>
                        <a href="#" title="YouTube"><i class="fab fa-youtube"></i></a>
                    </div>
                </div>

                <!-- Services -->
                <div class="footer-section">
                    <h4><i class="fas fa-stethoscope"></i> Dịch Vụ Y Tế</h4>
                    <ul>
                        <li><a href="#"><i class="fas fa-chevron-right"></i> Khám tổng quát</a></li>
                        <li><a href="#"><i class="fas fa-chevron-right"></i> Tim mạch</a></li>
                        <li><a href="#"><i class="fas fa-chevron-right"></i> Thần kinh</a></li>
                        <li><a href="#"><i class="fas fa-chevron-right"></i> Nhi khoa</a></li>
                        <li><a href="#"><i class="fas fa-chevron-right"></i> Sản phụ khoa</a></li>
                    </ul>
                </div>

                <!-- Quick Links -->
                <div class="footer-section">
                    <h4><i class="fas fa-link"></i> Liên Kết Nhanh</h4>
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/"><i class="fas fa-home"></i> Trang chủ</a></li>
                        <li><a href="${pageContext.request.contextPath}/doctors"><i class="fas fa-user-md"></i> Bác sĩ</a></li>
                        <li><a href="${pageContext.request.contextPath}/appointments"><i class="fas fa-calendar-alt"></i> Đặt lịch</a></li>
                        <li><a href="${pageContext.request.contextPath}/services"><i class="fas fa-stethoscope"></i> Dịch vụ</a></li>
                        <li><a href="${pageContext.request.contextPath}/contact"><i class="fas fa-phone-alt"></i> Liên hệ</a></li>
                    </ul>
                </div>

                <!-- Contact Info -->
                <div class="footer-section">
                    <h4><i class="fas fa-map-marker-alt"></i> Liên Hệ</h4>
                    <p><i class="fas fa-map-marker-alt"></i>ĐH FPT , HOA LAC</p>
                    <p><i class="fas fa-phone"></i> (098) 123 4567</p>
                    <p><i class="fas fa-envelope"></i> PhongKhamPDC@gmail.com</p>
                </div>
            </div>

            <div class="footer-bottom">
                <p>&copy; 2024 Healthcare System. Tất cả quyền được bảo lưu.</p>
            </div>
        </div>
    </footer>

    <!-- ===== JAVASCRIPT ===== -->
    <script>
        function validateAndSubmitForm(form) {
            const formData = {
                doctorId: form.doctorId.value,
                slotId: form.slotId.value,
                roomId: form.roomId.value,
                patientId: form.patientId.value,
                serviceId: form.serviceIdTemp.value
            };

            console.log("=== FORM VALIDATION DEBUG ===");
            console.log("Form Data:", formData);
            console.log("============================");

            // Validate required fields
            const requiredFields = [
                {field: 'doctorId', name: 'Mã bác sĩ'},
                {field: 'slotId', name: 'Mã khung giờ'},
                {field: 'roomId', name: 'Mã phòng'},
                {field: 'patientId', name: 'Mã bệnh nhân'},
                {field: 'serviceId', name: 'Dịch vụ'}
            ];

            for (const item of requiredFields) {
                const value = formData[item.field];
                if (!value || value.trim() === '') {
                    showAlert('❌ Lỗi: ' + item.name + ' không được để trống!', 'error');
                    return false;
                }

                // Validate numeric fields
                if (item.field !== 'serviceId' && (isNaN(value) || parseInt(value) <= 0)) {
                    showAlert('❌ Lỗi: ' + item.name + ' phải là số dương hợp lệ!', 'error');
                    return false;
                }
            }

            // Special validation for service selection
            if (!formData.serviceId || formData.serviceId === '') {
                showAlert('❌ Lỗi: Vui lòng chọn dịch vụ!', 'error');
                document.getElementById('serviceId').focus();
                return false;
            }

            // Show confirmation dialog
            const selectedServiceText = document.getElementById('serviceId').selectedOptions[0].textContent;
            const confirmMessage = 
                "🏥 XÁC NHẬN THÔNG TIN ĐẶT LỊCH HẸN\n\n" +
                "📋 Chi tiết lịch hẹn:\n" +
                "• Bác sĩ: ${fn:escapeXml(requestScope.doctorName != null ? requestScope.doctorName : 'Không xác định')}\n" +
                "• Khung giờ: ${fn:escapeXml(requestScope.slotTime != null ? requestScope.slotTime : 'Chưa chọn')}\n" +
                "• Phòng: ${fn:escapeXml(requestScope.roomName != null ? requestScope.roomName : 'Chưa có phòng')}\n" +
                "• Bệnh nhân: ${fn:escapeXml(requestScope.patientName != null ? requestScope.patientName : 'Không xác định')}\n" +
                "• Dịch vụ: " + selectedServiceText + "\n\n" +
                "⚠️ LƯU Ý: Sau khi xác nhận, bạn sẽ không thể thay đổi thông tin!\n\n" +
                "❓ Bạn có chắc chắn muốn đặt lịch hẹn này không?";

            if (!confirm(confirmMessage)) {
                return false;
            }

            // Show loading state
            showLoading(true);
            return true;
        }

        function showAlert(message, type) {
            try {
                // Remove existing alerts safely
                const existingAlerts = document.querySelectorAll('.alert');
                existingAlerts.forEach(alert => {
                    if (alert && alert.parentNode) {
                        alert.parentNode.removeChild(alert);
                    }
                });

                // Create new alert
                const alertDiv = document.createElement('div');
                alertDiv.className = `alert alert-${type}`;
                alertDiv.style.opacity = '0';
                alertDiv.style.transform = 'translateY(-20px)';
                alertDiv.style.transition = 'all 0.3s ease';
                
                // Set icon based on type
                const iconClass = type === 'error' ? 'exclamation-triangle' : 'check-circle';
                alertDiv.innerHTML = `
                    <i class="fas fa-${iconClass}"></i>
                    <span>${message}</span>
                `;
                
                // Find container and insert alert
                const pageContent = document.querySelector('.page-content');
                if (pageContent) {
                    pageContent.insertBefore(alertDiv, pageContent.firstChild);
                    
                    // Animate in
                    setTimeout(() => {
                        alertDiv.style.opacity = '1';
                        alertDiv.style.transform = 'translateY(0)';
                    }, 10);
                    
                    // Scroll to alert
                    setTimeout(() => {
                        alertDiv.scrollIntoView({ 
                            behavior: 'smooth', 
                            block: 'nearest',
                            inline: 'nearest'
                        });
                    }, 100);
                    
                    // Auto remove after 5 seconds
                    setTimeout(() => {
                        if (alertDiv && alertDiv.parentNode) {
                            alertDiv.style.opacity = '0';
                            alertDiv.style.transform = 'translateY(-20px)';
                            setTimeout(() => {
                                if (alertDiv && alertDiv.parentNode) {
                                    alertDiv.parentNode.removeChild(alertDiv);
                                }
                            }, 300);
                        }
                    }, 5000);
                } else {
                    // Fallback to simple alert if container not found
                    alert(message);
                }
            } catch (error) {
                console.error('Error showing alert:', error);
                // Fallback to browser alert
                alert(message);
            }
        }


        function showLoading(show) {
            const loadingDiv = document.getElementById('loadingDiv');
            const submitBtn = document.getElementById('submitBtn');

            if (show) {
                loadingDiv.style.display = 'block';
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
                submitBtn.style.opacity = '0.7';
            } else {
                loadingDiv.style.display = 'none';
                submitBtn.disabled = false;
                submitBtn.innerHTML = '<i class="fas fa-calendar-check"></i> Xác Nhận Đặt Lịch';
                submitBtn.style.opacity = '1';
            }
        }

        // Handle page load events
        document.addEventListener('DOMContentLoaded', function() {
            showLoading(false);

            // Focus on service selection if empty
            const serviceSelect = document.getElementById('serviceId');
            if (serviceSelect && !serviceSelect.value) {
                setTimeout(() => {
                    serviceSelect.focus();
                }, 500);
            }

            // Add smooth transitions to alerts
            const style = document.createElement('style');
            style.textContent = `
                .alert {
                    transition: all 0.3s ease;
                }
                .btn:disabled {
                    cursor: not-allowed;
                    transform: none !important;
                }
            `;
            document.head.appendChild(style);
        });

        // Handle form submission timeout
        document.getElementById('appointmentForm').addEventListener('submit', function() {
            // Reset loading state after 30 seconds if no response
            setTimeout(function() {
                showLoading(false);
                showAlert('⏰ Yêu cầu đang xử lý lâu hơn bình thường. Vui lòng kiểm tra kết quả hoặc thử lại.', 'error');
            }, 30000);
        });

        // Add hover effects for better UX
        document.querySelectorAll('.value-display').forEach(display => {
            display.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-1px)';
            });
            
            display.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
            });
        });

        // Enhanced service selection with visual feedback
        document.getElementById('serviceId').addEventListener('change', function() {
            if (this.value) {
                this.style.borderColor = '#28a745';
                this.style.boxShadow = '0 0 0 3px rgba(40, 167, 69, 0.15)';
            } else {
                this.style.borderColor = '#e2e8f0';
                this.style.boxShadow = '0 2px 4px rgba(0,0,0,0.05)';
            }
        });
    </script>
</body>
</html>
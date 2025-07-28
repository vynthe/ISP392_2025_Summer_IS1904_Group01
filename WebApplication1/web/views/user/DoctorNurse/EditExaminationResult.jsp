<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh Sửa Kết Quả Khám - Nha Khoa PDC</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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
            display: flex;
            flex-direction: column;
        }

        /* Header Styles */
        .header {
            background: linear-gradient(135deg, #2c3e50, #34495e);
            color: white;
            padding: 15px 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            position: relative;
        }

        .header::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, #667eea, #764ba2, #667eea);
        }

        .header-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            display: flex;
            align-items: center;
            font-size: 1.8rem;
            font-weight: bold;
            color: #4ecdc4;
        }

        .logo i {
            margin-right: 10px;
            font-size: 2rem;
        }

        .nav-links {
            display: flex;
            list-style: none;
            gap: 30px;
        }

        .nav-links a {
            color: rgba(255, 255, 255, 0.9);
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            padding: 5px 10px;
            border-radius: 5px;
        }

        .nav-links a:hover {
            color: #4ecdc4;
            background: rgba(78, 205, 196, 0.1);
        }

        /* Main Content */
        .main-content {
            flex: 1;
            padding: 40px 20px;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .form-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            padding: 0;
            width: 100%;
            max-width: 700px;
            overflow: hidden;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .form-header {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            padding: 25px 30px;
            text-align: center;
            position: relative;
        }

        .form-header::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 60px;
            height: 3px;
            background: rgba(255, 255, 255, 0.3);
            border-radius: 2px;
        }

        .form-header h2 {
            font-size: 1.8rem;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .form-header p {
            opacity: 0.9;
            font-size: 0.95rem;
        }

        .form-body {
            padding: 35px 30px;
        }

        .form-group {
            margin-bottom: 25px;
            position: relative;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #2c3e50;
            font-size: 0.95rem;
        }

        .form-group label i {
            margin-right: 8px;
            color: #007bff;
            width: 16px;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e1e8ed;
            border-radius: 10px;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            background: white;
        }

        .form-control:focus {
            outline: none;
            border-color: #007bff;
            box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.1);
        }

        .form-control[readonly] {
            background-color: #f8f9fa;
            color: #6c757d;
            cursor: not-allowed;
            border-color: #dee2e6;
        }

        textarea.form-control {
            height: 120px;
            resize: vertical;
            font-family: inherit;
        }

        .error-message {
            background: #f8d7da;
            color: #721c24;
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #dc3545;
            font-size: 0.9rem;
        }

        .error-message i {
            margin-right: 8px;
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-top: 30px;
            padding-top: 25px;
            border-top: 1px solid #e9ecef;
        }

        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-cancel {
            background: #6c757d;
            color: white;
        }

        .btn-cancel:hover {
            background: #5a6268;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(108, 117, 125, 0.3);
        }

        .btn-save {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
        }

        .btn-save:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.4);
        }

        /* Footer from your existing code */
        footer {
            background: linear-gradient(135deg, #2c3e50, #34495e);
            color: white;
            padding: 40px 0;
            width: 100%;
            position: relative;
        }

        footer::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 2px;
            background: linear-gradient(90deg, #667eea, #764ba2, #667eea);
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
            gap: 20px;
            margin-bottom: 30px;
        }

        .footer-section {
            flex: 1;
            min-width: 250px;
        }

        .footer-section h3 {
            font-size: 1.5rem;
            margin-bottom: 20px;
            color: #4ecdc4;
            position: relative;
        }

        .footer-section h3::after {
            content: '';
            position: absolute;
            left: 0;
            bottom: -5px;
            width: 50px;
            height: 3px;
            background: linear-gradient(90deg, #667eea, #764ba2);
            border-radius: 2px;
        }

        .footer-section p {
            line-height: 1.8;
            margin-bottom: 15px;
            opacity: 0.9;
        }

        .contact-info p {
            margin-bottom: 10px;
        }

        .footer-links {
            list-style: none;
        }

        .footer-links li {
            margin-bottom: 12px;
        }

        .footer-links a {
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            position: relative;
        }

        .footer-links a::before {
            content: '';
            position: absolute;
            left: 0;
            bottom: -2px;
            width: 0;
            height: 2px;
            background: #4ecdc4;
            transition: width 0.3s ease;
        }

        .footer-links a:hover {
            color: #4ecdc4;
            transform: translateX(5px);
        }

        .footer-links a:hover::before {
            width: 100%;
        }

        .footer-links i {
            margin-right: 8px;
            width: 16px;
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
            width: 40px;
            height: 40px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            color: white;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .social-links a:hover {
            background: #4ecdc4;
            transform: translateY(-2px) scale(1.1);
        }

        .newsletter-form {
            display: flex;
            margin-top: 20px;
            gap: 10px;
        }

        .newsletter-input {
            flex: 1;
            padding: 10px 15px;
            border: none;
            border-radius: 25px;
            background: rgba(255, 255, 255, 0.1);
            color: white;
            border: 2px solid transparent;
            transition: all 0.3s ease;
        }

        .newsletter-input::placeholder {
            color: rgba(255, 255, 255, 0.7);
        }

        .newsletter-input:focus {
            outline: none;
            border-color: #4ecdc4;
            background: rgba(255, 255, 255, 0.15);
        }

        .newsletter-btn {
            padding: 10px 20px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border: none;
            border-radius: 25px;
            color: white;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 600;
        }

        .newsletter-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .footer-bottom {
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            padding-top: 20px;
            text-align: center;
        }

        .footer-bottom p {
            opacity: 0.8;
            margin: 10px 0;
        }

        .footer-bottom-links {
            display: flex;
            gap: 20px;
            list-style: none;
            justify-content: center;
            flex-wrap: wrap;
        }

        .footer-bottom-links a {
            color: rgba(255, 255, 255, 0.7);
            text-decoration: none;
            font-size: 0.9rem;
            transition: color 0.3s ease;
        }

        .footer-bottom-links a:hover {
            color: #4ecdc4;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .header-container {
                flex-direction: column;
                gap: 15px;
            }

            .nav-links {
                gap: 20px;
                flex-wrap: wrap;
                justify-content: center;
            }

            .main-content {
                padding: 20px 10px;
            }

            .form-container {
                margin: 0 10px;
            }

            .form-body {
                padding: 25px 20px;
            }

            .form-actions {
                flex-direction: column-reverse;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }

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
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="header-container">
            <div class="logo">
                <i class="fas fa-tooth"></i>
                Nha Khoa PDC
            </div>
            <nav>
                <ul class="nav-links">
                    <li><a href="${pageContext.request.contextPath}/views/common/HomePage.jsp">Trang Chủ</a></li>
                    <li><a href="${pageContext.request.contextPath}/BookMedicalGuestServlet">Đặt Lịch</a></li>
                    <li><a href="#">Dịch Vụ</a></li>
                    <li><a href="#">Liên Hệ</a></li>
                </ul>
            </nav>
        </div>
    </header>

    <!-- Main Content -->
    <main class="main-content">
        <div class="form-container">
            <div class="form-header">
                <h2><i class="fas fa-edit"></i> Chỉnh Sửa Kết Quả Khám</h2>
                <p>Cập nhật thông tin kết quả khám bệnh</p>
            </div>

            <div class="form-body">
                <c:if test="${not empty errorMessage}">
                    <div class="error-message">
                        <i class="fas fa-exclamation-triangle"></i>
                        ${errorMessage}
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/EditExaminationResultServlet" method="post">
                    <input type="hidden" name="appointmentId" value="${resultDetails.appointmentId}" />
                    
                    <div class="form-group">
                        <label for="status">
                            <i class="fas fa-info-circle"></i>
                            Trạng Thái:
                        </label>
                        <input type="text" 
                               id="status" 
                               name="status" 
                               class="form-control" 
                               value="${resultDetails.status}" 
                               readonly />
                    </div>

                    <div class="form-group">
                        <label for="diagnosis">
                            <i class="fas fa-stethoscope"></i>
                            Chuẩn Đoán:
                        </label>
                        <input type="text" 
                               id="diagnosis" 
                               name="diagnosis" 
                               class="form-control" 
                               value="${resultDetails.diagnosis}" 
                               readonly />
                    </div>

                    <div class="form-group">
                        <label for="notes">
                            <i class="fas fa-sticky-note"></i>
                            Ghi Chú:
                        </label>
                        <textarea id="notes" 
                                  name="notes" 
                                  class="form-control" 
                                  placeholder="Nhập ghi chú chi tiết về kết quả khám...">${resultDetails.notes}</textarea>
                    </div>

                    <div class="form-actions">
                        <button type="button" 
                                class="btn btn-cancel" 
                                onclick="window.location.href='${pageContext.request.contextPath}/ViewExaminationResults?appointmentId=${resultDetails.appointmentId}'">
                            <i class="fas fa-times"></i>
                            Hủy Bỏ
                        </button>
                        <button type="submit" class="btn btn-save">
                            <i class="fas fa-save"></i>
                            Lưu Thay Đổi
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer>
        <div class="footer-container">
            <div class="footer-content">
                <div class="footer-section">
                    <h3><i class="fas fa-rocket"></i> Về Nha Khoa PDC</h3>
                    <p>Chúng tôi là phòng khám nha khoa hàng đầu, cam kết mang lại nụ cười khỏe mạnh và tự tin với công nghệ tiên tiến và đội ngũ chuyên gia giàu kinh nghiệm.</p>
                    <div class="contact-info">
                        <p><i class="fas fa-map-marker-alt"></i> Địa Chỉ: ĐH FPT , Hòa Lạc </p>
                        <p><i class="fas fa-phone"></i> Hotline:</p>
                        <p><i class="fas fa-clock"></i> Thời gian: 7:30 - 17:00 (Thứ 2 - Thứ 7)</p>
                        <p><i class="fas fa-envelope"></i> Email:PhongKhamPDC@gmail.com</p>
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
                        <li><a href="${pageContext.request.contextPath}/BookMedicalGuestServlet"><i class="fas fa-calendar-check"></i> Đặt Lịch Khám</a></li>
                        <li><a href="#"><i class="fas fa-info-circle"></i> Giới Thiệu</a></li>
                        <li><a href="#"><i class="fas fa-diagnoses"></i> Dịch Vụ</a></li>
                        <li><a href="#"><i class="fas fa-question-circle"></i> Hỏi Đáp</a></li>
                        <li><a href="#"><i class="fas fa-envelope"></i> Liên Hệ</a></li>
                    </ul>
                </div>

                <div class="footer-section">
                    <h3><i class="fas fa-handshake"></i> Dịch Vụ Nổi Bật</h3>
                    <ul class="footer-links">
                        <li><a href="${pageContext.request.contextPath}/ViewServiceByCategoryServlet?category=implant"><i class="fas fa-tooth"></i> Cấy Ghép Implant</a></li>
                        <li><a href="${pageContext.request.contextPath}/ViewServiceByCategoryServlet?category=mắc cài"><i class="fas fa-grip-lines"></i> Chỉnh Nha Mắc Cài</a></li>
                        <li><a href="${pageContext.request.contextPath}/ViewServiceByCategoryServlet?category=trẻ em"><i class="fas fa-child"></i> Nha Khoa Trẻ Em</a></li>
                        <li><a href="${pageContext.request.contextPath}/ViewServiceByCategoryServlet?category=răng khôn"><i class="fas fa-procedures"></i> Nhổ Răng Khôn</a></li>
                        <li><a href="${pageContext.request.contextPath}/ViewServiceByCategoryServlet?category=thẩm mỹ"><i class="fas fa-smile"></i> Nha Khoa Thẩm Mỹ</a></li>
                    </ul>
                </div>

                <div class="footer-section">
                    <h3><i class="fas fa-paper-plane"></i> Đăng Ký Tư Vấn</h3>
                    <p>Nhận tư vấn miễn phí và cập nhật thông tin sức khỏe răng miệng.</p>
                    <form class="newsletter-form" action="${pageContext.request.contextPath}/NewsletterServlet" method="post">
                        <input type="email" class="newsletter-input" name="email" placeholder="Nhập email của bạn...">
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
        // Newsletter form handling
        document.querySelector('.newsletter-form').addEventListener('submit', function(e) {
            e.preventDefault();
            const email = this.querySelector('.newsletter-input').value;
            if (email) {
                alert('Cảm ơn bạn đã đăng ký! Email: ' + email);
                this.querySelector('.newsletter-input').value = '';
            }
        });

        // Add some interactive effects
        document.querySelectorAll('.footer-links a').forEach(link => {
            link.addEventListener('mouseenter', function() {
                this.style.paddingLeft = '10px';
            });
            
            link.addEventListener('mouseleave', function() {
                this.style.paddingLeft = '0';
            });
        });

        // DEBUG: Form submission logging
        document.querySelector('form').addEventListener('submit', function(e) {
            console.log('Form is being submitted...');
            console.log('appointmentId:', document.querySelector('input[name="appointmentId"]').value);
            console.log('notes:', document.querySelector('#notes').value);
            
            // Show loading on button but don't prevent submission
            const saveBtn = document.querySelector('.btn-save');
            const originalText = saveBtn.innerHTML;
            saveBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang lưu...';
            
            // Don't disable the button to allow form submission
            // saveBtn.disabled = true;
        });

        // Simple visual feedback for save button
        document.querySelector('.btn-save').addEventListener('mousedown', function() {
            this.style.transform = 'scale(0.95)';
        });

        document.querySelector('.btn-save').addEventListener('mouseup', function() {
            this.style.transform = 'scale(1)';
        });
    </script>
</body>
</html>
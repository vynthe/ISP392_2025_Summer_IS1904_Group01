<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
                    <a href="#" title="Zalo"><i class="fab fa-whatsapp"></i></a> <!-- Thay bằng icon Zalo nếu có -->
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

<style>
    footer {
        background: linear-gradient(135deg, #2c3e50, #34495e);
        color: white;
        padding: 40px 0;
        width: 100%;
        margin-top: auto;
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
    }
</style>

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
</script>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Dashboard Lễ Tân</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }
            
            body {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                font-family: 'Inter', sans-serif;
                position: relative;
                overflow-x: hidden;
            }
            
            body::before {
                content: '';
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: 
                    radial-gradient(circle at 20% 80%, rgba(120, 119, 198, 0.3) 0%, transparent 50%),
                    radial-gradient(circle at 80% 20%, rgba(255, 255, 255, 0.15) 0%, transparent 50%),
                    radial-gradient(circle at 40% 40%, rgba(120, 119, 198, 0.2) 0%, transparent 50%);
                z-index: -1;
            }
            
            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 2rem;
            }
            
            .header {
                background: rgba(255, 255, 255, 0.1);
                backdrop-filter: blur(20px);
                border-radius: 20px;
                padding: 1.5rem;
                margin-bottom: 2rem;
                border: 1px solid rgba(255, 255, 255, 0.2);
                box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
                position: relative;
                z-index: 10;
            }
            
            .welcome-text {
                color: white;
                font-size: 1.5rem;
                font-weight: 600;
                text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }
            

            .dashboard-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
                gap: 2rem;
                margin-bottom: 2rem;
            }
            
            .action-card {
                background: rgba(255, 255, 255, 0.1);
                backdrop-filter: blur(20px);
                border-radius: 25px;
                padding: 2.5rem;
                border: 1px solid rgba(255, 255, 255, 0.2);
                box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
            }
            
            .action-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: linear-gradient(135deg, rgba(255, 255, 255, 0.1) 0%, rgba(255, 255, 255, 0.05) 100%);
                opacity: 0;
                transition: opacity 0.3s ease;
            }
            
            .action-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 20px 50px rgba(0, 0, 0, 0.2);
                border-color: rgba(255, 255, 255, 0.3);
            }
            
            .action-card:hover::before {
                opacity: 1;
            }
            
            .card-icon {
                width: 80px;
                height: 80px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border-radius: 20px;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-bottom: 1.5rem;
                font-size: 2rem;
                color: white;
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
                transition: all 0.3s ease;
            }
            
            .action-card:hover .card-icon {
                transform: scale(1.1) rotate(5deg);
                box-shadow: 0 12px 30px rgba(0, 0, 0, 0.3);
            }
            
            .card-title {
                font-size: 1.5rem;
                font-weight: 700;
                color: white;
                margin-bottom: 0.5rem;
                text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }
            
            .card-subtitle {
                color: rgba(255, 255, 255, 0.8);
                font-size: 0.9rem;
                margin-bottom: 1.5rem;
                line-height: 1.6;
            }
            
            .action-btn {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                padding: 0.75rem 1.5rem;
                background: rgba(255, 255, 255, 0.2);
                backdrop-filter: blur(10px);
                color: white;
                text-decoration: none;
                border-radius: 12px;
                font-weight: 600;
                transition: all 0.3s ease;
                border: 1px solid rgba(255, 255, 255, 0.3);
                cursor: pointer;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                font-size: 0.85rem;
            }
            
            .action-btn:hover {
                background: rgba(255, 255, 255, 0.3);
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
            }
            
            .action-btn i {
                margin-right: 0.5rem;
                font-size: 1rem;
            }
            
            .user-menu-container {
                position: relative;
                display: inline-block;
            }
            
            .user-menu-btn {
                width: 60px;
                height: 60px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                border: 3px solid rgba(255, 255, 255, 0.3);
                color: white;
                font-size: 1.5rem;
                cursor: pointer;
                transition: all 0.3s ease;
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
                position: relative;
                z-index: 50;
            }
            
            .user-menu-btn:hover {
                transform: scale(1.1);
                box-shadow: 0 12px 30px rgba(0, 0, 0, 0.3);
                border-color: rgba(255, 255, 255, 0.5);
            }
            
            .user-menu {
                position: absolute;
                top: 100%;
                right: 0;
                margin-top: 1rem;
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(20px);
                border-radius: 15px;
                box-shadow: 0 20px 50px rgba(0, 0, 0, 0.2);
                border: 1px solid rgba(255, 255, 255, 0.3);
                min-width: 200px;
                opacity: 0;
                visibility: hidden;
                transform: translateY(-10px);
                transition: all 0.3s ease;
                z-index: 9999;
            }
            
            .user-menu.active {
                opacity: 1;
                visibility: visible;
                transform: translateY(0);
            }
            
            .user-menu a {
                display: block;
                padding: 1rem 1.5rem;
                color: #333;
                text-decoration: none;
                transition: all 0.3s ease;
                border-bottom: 1px solid rgba(0, 0, 0, 0.1);
                font-weight: 500;
            }
            
            .user-menu a:last-child {
                border-bottom: none;
            }
            
            .user-menu a:hover {
                background: rgba(102, 126, 234, 0.1);
                color: #667eea;
                transform: translateX(5px);
            }
            
            .user-menu a:first-child {
                border-radius: 15px 15px 0 0;
            }
            
            .user-menu a:last-child {
                border-radius: 0 0 15px 15px;
            }
            
            .page-title {
                text-align: center;
                color: white;
                font-size: 3rem;
                font-weight: 700;
                margin-bottom: 3rem;
                text-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
                position: relative;
            }
            
            .page-title::after {
                content: '';
                position: absolute;
                bottom: -10px;
                left: 50%;
                transform: translateX(-50%);
                width: 100px;
                height: 4px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border-radius: 2px;
            }
            
            @media (max-width: 768px) {
                .container {
                    padding: 1rem;
                }
                
                .dashboard-grid {
                    grid-template-columns: 1fr;
                }
                
                .page-title {
                    font-size: 2rem;
                }
                
                .action-card {
                    padding: 2rem;
                }
            }
            
            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            
            .fade-in-up {
                animation: fadeInUp 0.6s ease-out;
            }
            
            .stagger-1 { animation-delay: 0.1s; }
            .stagger-2 { animation-delay: 0.2s; }
            .stagger-3 { animation-delay: 0.3s; }
            .stagger-4 { animation-delay: 0.4s; }
        </style>
    </head>
    <body>
        <div class="container">
            <!-- Header -->
            <div class="header fade-in-up">
                <div class="flex justify-between items-center">
                    <div class="welcome-text">
                        <i class="fas fa-user-tie mr-2"></i>
                        Chào mừng, Lễ Tân
                    </div>
                    <div class="user-menu-container">
                        <button id="userMenuBtn" class="user-menu-btn">
                            <i class="fas fa-user"></i>
                        </button>
                        <div id="userMenu" class="user-menu">
                            <a href="${pageContext.request.contextPath}/UserProfileController">
                                <i class="fas fa-user-circle mr-2"></i>Xem Hồ Sơ
                            </a>
                            <a href="${pageContext.request.contextPath}/EditProfileUserController">
                                <i class="fas fa-edit mr-2"></i>Chỉnh Sửa Hồ Sơ
                            </a>
                            <a href="${pageContext.request.contextPath}/ChangePasswordController">
                                <i class="fas fa-lock mr-2"></i>Đổi Mật Khẩu
                            </a>
                            <a href="${pageContext.request.contextPath}/LogoutServlet" onclick="return confirm('Bạn có chắc chắn muốn đăng xuất?')">
                                <i class="fas fa-sign-out-alt mr-2"></i>Đăng Xuất
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Page Title -->
            <h1 class="page-title fade-in-up stagger-1">Bảng Điều Khiển</h1>

            <!-- Dashboard Grid -->
            <div class="dashboard-grid">
                <div class="action-card fade-in-up stagger-3">
                    <div class="card-icon">
                        <i class="fas fa-calendar-alt"></i>
                    </div>
                    <h3 class="card-title">Quản Lý Đặt Lịch</h3>
                    <p class="card-subtitle">Xem và quản lý tất cả các cuộc hẹn và lịch trình đặt lịch</p>
                    <a href="${pageContext.request.contextPath}/ViewBookingServlet" class="action-btn">
                        <i class="fas fa-calendar-check mr-2"></i>Xem Lịch Đặt
                    </a>
                </div>

               <div class="action-card fade-in-up stagger-4">
                    <div class="card-icon">
                        <i class="fas fa-file-invoice-dollar"></i>
                    </div>
                    <h3 class="card-title">Quản Lý Hóa Đơn</h3>
                    <p class="card-subtitle">Xử lý thanh toán, hóa đơn và tạo báo cáo tài chính</p>
                    <!-- Đã sửa lại: Đường dẫn nút Xem Hóa Đơn chuyển sang servlet danh sách hóa đơn mới để tránh lỗi 404 -->
                    <a href="${pageContext.request.contextPath}/ViewInvoiceServlet" class="action-btn">
                        <i class="fas fa-file-invoice mr-2"></i>Xem Hóa Đơn
                    </a>
                </div>

                <div class="action-card fade-in-up stagger-4">
                    <div class="card-icon">
                        <i class="fas fa-clock"></i>
                    </div>
                    <h3 class="card-title">Lịch Làm Việc</h3>
                    <p class="card-subtitle">Kiểm tra lịch làm việc và tình trạng sẵn sàng của nhân viên</p>
                    <a href="${pageContext.request.contextPath}/ViewScheduleUserServlet" class="action-btn">
                        <i class="fas fa-calendar-week mr-2"></i>Xem Lịch Làm Việc
                    </a>
                </div>
                         <div class="action-card fade-in-up stagger-4">
                    <div class="card-icon">
                        <i class="fas fa-clock"></i>
                    </div>
                    <h3 class="card-title">Lịch Làm Việc</h3>
                    <p class="card-subtitle">Kiểm tra lịch làm việc và tình trạng sẵn sàng của nhân viên</p>
                    <a href="${pageContext.request.contextPath}/ViewListDoctorNurse" class="action-btn">
                        <i class="fas fa-calendar-week mr-2"></i>Xem Lịch Làm Việc Bác sĩ / Y Tá
                    </a>
                </div>
            </div>
        </div>

        <script>
            // Toggle user menu
            const userMenuBtn = document.getElementById('userMenuBtn');
            const userMenu = document.getElementById('userMenu');
            
            userMenuBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                userMenu.classList.toggle('active');
            });

            // Close menu when clicking outside
            document.addEventListener('click', (event) => {
                if (!userMenuBtn.contains(event.target) && !userMenu.contains(event.target)) {
                    userMenu.classList.remove('active');
                }
            });

            // Invoice button functionality
            document.getElementById('invoiceBtn').addEventListener('click', () => {
                // Create a more elegant notification
                const notification = document.createElement('div');
                notification.style.cssText = `
                    position: fixed;
                    top: 20px;
                    right: 20px;
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    color: white;
                    padding: 1rem 2rem;
                    border-radius: 15px;
                    box-shadow: 0 20px 50px rgba(0, 0, 0, 0.2);
                    z-index: 9999;
                    font-weight: 600;
                    backdrop-filter: blur(20px);
                    border: 1px solid rgba(255, 255, 255, 0.3);
                    transform: translateX(400px);
                    transition: all 0.3s ease;
                `;
                notification.innerHTML = '<i class="fas fa-info-circle mr-2"></i>Tính năng hóa đơn đang phát triển!';
                document.body.appendChild(notification);
                
                setTimeout(() => {
                    notification.style.transform = 'translateX(0)';
                }, 100);
                
                setTimeout(() => {
                    notification.style.transform = 'translateX(400px)';
                    setTimeout(() => {
                        document.body.removeChild(notification);
                    }, 300);
                }, 3000);
            });

            // Add smooth scrolling for internal links
            document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                anchor.addEventListener('click', function (e) {
                    e.preventDefault();
                    document.querySelector(this.getAttribute('href')).scrollIntoView({
                        behavior: 'smooth'
                    });
                });
            });
        </script>
        <div style="height: 300px;"></div>
<jsp:include page="/assets/footer.jsp" />
    </body>
</html>

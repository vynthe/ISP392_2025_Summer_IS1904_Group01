<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Hệ Thống Quản Lý Phòng Khám</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');

            :root {
                --primary: #2563eb;
                --primary-light: #3b82f6;
                --secondary: #059669;
                --accent: #0891b2;
                --success: #10b981;
                --warning: #f59e0b;
                --error: #ef4444;
                --dark: #1f2937;
                --gray-50: #f9fafb;
                --gray-100: #f3f4f6;
                --gray-200: #e5e7eb;
                --gray-300: #d1d5db;
                --gray-600: #4b5563;
                --gray-700: #374151;
                --gray-800: #1f2937;
                --white: #ffffff;
                --border-radius: 12px;
                --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
                --shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1);
                --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
                background-color: var(--gray-50);
                color: var(--dark);
                line-height: 1.6;
            }

            /* Header */
            .header {
                background: var(--white);
                border-bottom: 1px solid var(--gray-200);
                padding: 1rem 0;
                position: sticky;
                top: 0;
                z-index: 100;
                box-shadow: var(--shadow-sm);
            }

            .header-container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 1.5rem;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .logo-section {
                display: flex;
                align-items: center;
                gap: 0.75rem;
            }

            .logo-icon {
                width: 40px;
                height: 40px;
                background: var(--primary);
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 1.25rem;
            }

            .logo-text h1 {
                font-size: 1.5rem;
                font-weight: 600;
                color: var(--dark);
                margin-bottom: 0.125rem;
            }

            .logo-text p {
                font-size: 0.75rem;
                color: var(--gray-600);
                font-weight: 400;
            }

            .user-section {
                position: relative;
            }

            .user-button {
                background: var(--white);
                border: 1px solid var(--gray-300);
                color: var(--gray-700);
                padding: 0.5rem 1rem;
                border-radius: var(--border-radius);
                display: flex;
                align-items: center;
                gap: 0.5rem;
                cursor: pointer;
                font-weight: 500;
                font-size: 0.875rem;
                transition: all 0.2s ease;
            }

            .user-button:hover {
                background: var(--gray-50);
                border-color: var(--gray-400);
            }

            .user-dropdown {
                position: absolute;
                top: calc(100% + 0.5rem);
                right: 0;
                background: var(--white);
                border: 1px solid var(--gray-200);
                border-radius: var(--border-radius);
                box-shadow: var(--shadow-lg);
                min-width: 200px;
                opacity: 0;
                visibility: hidden;
                transform: translateY(-10px);
                transition: all 0.2s ease;
                z-index: 1000;
            }

            .user-dropdown.active {
                opacity: 1;
                visibility: visible;
                transform: translateY(0);
            }

            .dropdown-item {
                display: flex;
                align-items: center;
                gap: 0.75rem;
                padding: 0.75rem 1rem;
                color: var(--gray-700);
                text-decoration: none;
                font-size: 0.875rem;
                transition: background-color 0.2s ease;
                border-bottom: 1px solid var(--gray-100);
            }

            .dropdown-item:last-child {
                border-bottom: none;
            }

            .dropdown-item:hover {
                background: var(--gray-50);
            }

            .dropdown-item.danger:hover {
                background: #fef2f2;
                color: var(--error);
            }

            /* Main Container */
            .main-container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 2rem 1.5rem;
            }

            /* Welcome Section */
            .welcome-section {
                background: var(--white);
                border-radius: var(--border-radius);
                padding: 1.5rem;
                margin-bottom: 2rem;
                box-shadow: var(--shadow);
                border: 1px solid var(--gray-200);
            }

            .welcome-header {
                display: flex;
                align-items: center;
                gap: 1rem;
                margin-bottom: 1rem;
            }

            .welcome-icon {
                width: 60px;
                height: 60px;
                background: linear-gradient(135deg, var(--primary), var(--primary-light));
                border-radius: var(--border-radius);
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 1.5rem;
            }

            .welcome-text h2 {
                font-size: 1.5rem;
                font-weight: 600;
                color: var(--dark);
                margin-bottom: 0.25rem;
            }

            .welcome-text p {
                color: var(--gray-600);
                font-size: 0.875rem;
            }

            .current-time {
                background: var(--gray-50);
                padding: 0.75rem 1rem;
                border-radius: var(--border-radius);
                border-left: 4px solid var(--primary);
                margin-top: 1rem;
            }

            .current-time span {
                font-weight: 600;
                color: var(--primary);
            }

            /* Stats Grid */
            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
                gap: 1.5rem;
                margin-bottom: 2rem;
            }

            .stat-card {
                background: var(--white);
                border-radius: var(--border-radius);
                padding: 1.5rem;
                box-shadow: var(--shadow);
                border: 1px solid var(--gray-200);
                transition: transform 0.2s ease, box-shadow 0.2s ease;
            }

            .stat-card:hover {
                transform: translateY(-2px);
                box-shadow: var(--shadow-lg);
            }

            .stat-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-bottom: 1rem;
            }

            .stat-icon {
                width: 40px;
                height: 40px;
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 1rem;
            }

            .stat-icon.patients {
                background: var(--primary);
            }
            .stat-icon.appointments {
                background: var(--warning);
            }
            .stat-icon.results {
                background: var(--success);
            }
            .stat-icon.rooms {
                background: var(--accent);
            }

            .stat-number {
                font-size: 2rem;
                font-weight: 700;
                color: var(--dark);
                line-height: 1;
            }

            .stat-label {
                color: var(--gray-600);
                font-size: 0.875rem;
                font-weight: 500;
                margin-top: 0.5rem;
            }

            /* Quick Actions */
            .quick-actions {
                background: var(--white);
                border-radius: var(--border-radius);
                padding: 1.5rem;
                box-shadow: var(--shadow);
                border: 1px solid var(--gray-200);
            }

            .section-title {
                font-size: 1.25rem;
                font-weight: 600;
                color: var(--dark);
                margin-bottom: 1.5rem;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .section-title i {
                color: var(--primary);
            }

            .actions-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                gap: 1rem;
            }

            .action-card {
                display: flex;
                align-items: center;
                gap: 1rem;
                padding: 1rem;
                background: var(--gray-50);
                border: 1px solid var(--gray-200);
                border-radius: var(--border-radius);
                text-decoration: none;
                color: var(--dark);
                transition: all 0.2s ease;
            }

            .action-card:hover {
                background: var(--white);
                border-color: var(--primary);
                transform: translateY(-1px);
                box-shadow: var(--shadow);
            }

            .action-icon {
                width: 48px;
                height: 48px;
                border-radius: var(--border-radius);
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 1.25rem;
                flex-shrink: 0;
            }

            .action-icon.exam {
                background: var(--primary);
            }
            .action-icon.prescription {
                background: var(--success);
            }
            .action-icon.schedule {
                background: var(--warning);
            }
            .action-icon.room {
                background: var(--accent);
            }

            .action-content h3 {
                font-size: 1rem;
                font-weight: 600;
                color: var(--dark);
                margin-bottom: 0.25rem;
            }

            .action-content p {
                font-size: 0.75rem;
                color: var(--gray-600);
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .header-container {
                    padding: 0 1rem;
                }

                .main-container {
                    padding: 1.5rem 1rem;
                }

                .welcome-header {
                    flex-direction: column;
                    text-align: center;
                }

                .stats-grid {
                    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                    gap: 1rem;
                }

                .actions-grid {
                    grid-template-columns: 1fr;
                }

                .logo-text h1 {
                    font-size: 1.25rem;
                }

                .welcome-text h2 {
                    font-size: 1.25rem;
                }
            }

            /* Loading Animation */
            .fade-in {
                opacity: 0;
                transform: translateY(20px);
                animation: fadeInUp 0.6s ease forwards;
            }

            .fade-in:nth-child(1) {
                animation-delay: 0.1s;
            }
            .fade-in:nth-child(2) {
                animation-delay: 0.2s;
            }
            .fade-in:nth-child(3) {
                animation-delay: 0.3s;
            }
            .fade-in:nth-child(4) {
                animation-delay: 0.4s;
            }

            @keyframes fadeInUp {
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Status Indicators */
            .status-online {
                display: inline-block;
                width: 8px;
                height: 8px;
                background: var(--success);
                border-radius: 50%;
                margin-left: 0.5rem;
                animation: pulse 2s infinite;
            }

            @keyframes pulse {
                0% {
                    transform: scale(1);
                    opacity: 1;
                }
                50% {
                    transform: scale(1.1);
                    opacity: 0.7;
                }
                100% {
                    transform: scale(1);
                    opacity: 1;
                }
            }
        </style>
    </head>
    <body>
        <!-- Header Section -->
        <header class="header">
            <div class="header-container">
                <div class="logo-section">
                    <div class="logo-icon">
                        <i class="fas fa-heartbeat"></i>
                    </div>
                    <div class="logo-text">
                        <h1>MediCare Pro</h1>
                        <p>Hệ thống quản lý phòng khám</p>
                    </div>
                </div>

                <div class="user-section">
                    <button id="userMenuBtn" class="user-button">
                        <i class="fas fa-user-md"></i>
                        <span>Bác sĩ</span>
                        <span class="status-online"></span>
                        <i class="fas fa-chevron-down" style="font-size: 0.75rem; margin-left: 0.25rem;"></i>
                    </button>
                    <div id="userMenu" class="user-dropdown">
                        <a href="${pageContext.request.contextPath}/UserProfileController" class="dropdown-item">
                            <i class="fas fa-user"></i>
                            <span>Thông tin cá nhân</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/EditProfileUserController" class="dropdown-item">
                            <i class="fas fa-edit"></i>
                            <span>Chỉnh sửa hồ sơ</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/ChangePasswordController" class="dropdown-item">
                            <i class="fas fa-edit"></i>
                            <span>Đổi mật khẩu</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/LogoutServlet" class="dropdown-item danger" onclick="return confirm('Bạn có chắc muốn đăng xuất?')">
                            <i class="fas fa-sign-out-alt"></i>
                            <span>Đăng xuất</span>
                        </a>
                    </div>
                </div>
            </div>
        </header>

        <!-- Main Content -->
        <main class="main-container">
            <!-- Welcome Section -->
            <div class="welcome-section fade-in">
                <div class="welcome-header">
                    <div class="welcome-icon">
                        <i class="fas fa-user-md"></i>
                    </div>
                    <div class="welcome-text">
                        <h2>Chào mừng, Bác sĩ!</h2>
                        <p>Bảng điều khiển quản lý phòng khám của bạn</p>
                    </div>
                </div>
                <div class="current-time">
                    <i class="fas fa-clock"></i>
                    Thời gian hiện tại: <span id="currentTime"></span>
                </div>
            </div>

            <!-- Statistics Cards -->
            <div class="stats-grid">
                <div class="stat-card fade-in">
                    <div class="stat-header">
                        <div class="stat-icon patients">
                            <i class="fas fa-user-injured"></i>
                        </div>
                    </div>
                    <div class="stat-number"></div>
                    <div class="stat-label">Bệnh nhân hôm nay</div>
                </div>

                <div class="stat-card fade-in">
                    <div class="stat-header">
                        <div class="stat-icon appointments">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                    </div>
                    <div class="stat-number"></div>
                    <div class="stat-label">Lịch hẹn đang chờ</div>
                </div>

                <div class="stat-card fade-in">
                    <div class="stat-header">
                        <div class="stat-icon results">
                            <i class="fas fa-clipboard-list"></i>
                        </div>
                    </div>
                    <div class="stat-number"></div>
                    <div class="stat-label">Kết quả khám</div>
                </div>

                <div class="stat-card fade-in">
                    <div class="stat-header">
                        <div class="stat-icon rooms">
                            <i class="fas fa-door-open"></i>
                        </div>
                    </div>
                    <div class="stat-number"></div>
                    <div class="stat-label">Phòng hoạt động</div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="quick-actions fade-in">
                <h3 class="section-title">
                    <i class="fas fa-tasks"></i>
                    Tác vụ nhanh
                </h3>

                <div class="actions-grid">
                    <a href="${pageContext.request.contextPath}/ViewExaminationResultsServlet" class="action-card">
                        <div class="action-icon exam">
                            <i class="fas fa-stethoscope"></i>
                        </div>
                        <div class="action-content">
                            <h3>Thêm Kết Quả Khám</h3>
                            <p>Ghi nhận và lưu trữ kết quả khám bệnh</p>
                        </div>
                    </a>

                    <a href="${pageContext.request.contextPath}/ViewMedicationsServlet" class="action-card">
                        <div class="action-icon prescription">
                            <i class="fas fa-prescription-bottle-alt"></i>
                        </div>
                        <div class="action-content">
                            <h3>Danh sách thuốc</h3>
                            <p>Kê đơn và quản lý thuốc cho bệnh nhân</p>
                        </div>
                    </a>

                    <a href="${pageContext.request.contextPath}/ViewSchedulesServlet" class="action-card">
                        <div class="action-icon schedule">
                            <i class="fas fa-calendar-alt"></i>
                        </div>
                        <div class="action-content">
                            <h3>Xem Lịch Làm Việc</h3>
                            <p>Quản lý lịch trình và ca làm việc</p>
                        </div>
                    </a>

                    <a href="${pageContext.request.contextPath}/ViewPrescriptionServlet" class="action-card">
                        <div class="action-icon prescription">
                            <i class="fas fa-prescription-bottle-alt"></i>
                        </div>
                        <div class="action-content">
                            <h3>Thêm Đơn Thuốc</h3>
                            <p>Quản lý đơn thuốc</p>
                        </div>
                    </a>

                    <a href="${pageContext.request.contextPath}/ViewRoomServlet" class="action-card">
                        <div class="action-icon room">
                            <i class="fas fa-hospital"></i>
                        </div>
                        <div class="action-content">
                            <h3>Quản Lý Phòng</h3>
                            <p>Xem và quản lý thông tin các phòng khám</p>
                        </div>
                    </a>
                </div>
            </div>
        </main>

        <script>
            // User menu toggle
            const userMenuBtn = document.getElementById('userMenuBtn');
            const userMenu = document.getElementById('userMenu');

            userMenuBtn.addEventListener('click', function (e) {
                e.stopPropagation();
                userMenu.classList.toggle('active');
            });

            // Close menu when clicking outside
            document.addEventListener('click', function (event) {
                if (!userMenuBtn.contains(event.target) && !userMenu.contains(event.target)) {
                    userMenu.classList.remove('active');
                }
            });

            // Update current time
            function updateCurrentTime() {
                const now = new Date();
                const options = {
                    weekday: 'long',
                    year: 'numeric',
                    month: 'long',
                    day: 'numeric',
                    hour: '2-digit',
                    minute: '2-digit',
                    second: '2-digit'
                };
                document.getElementById('currentTime').textContent = now.toLocaleDateString('vi-VN', options);
            }

            // Initialize
            document.addEventListener('DOMContentLoaded', function () {
                updateCurrentTime();
                setInterval(updateCurrentTime, 1000);
            });
        </script>
    </body>
</html>
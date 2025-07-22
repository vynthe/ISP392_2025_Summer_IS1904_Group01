<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách bác sĩ - Hệ thống đặt lịch hẹn</title>
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
            color: #333;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .header {
            text-align: center;
            margin-bottom: 40px;
            color: white;
        }

        .header h1 {
            font-size: 2.5em;
            margin-bottom: 10px;
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
            animation: fadeInDown 0.8s ease-out;
        }

        .header p {
            font-size: 1.1em;
            opacity: 0.9;
            animation: fadeInUp 0.8s ease-out 0.2s both;
        }

        @keyframes fadeInDown {
            from {
                opacity: 0;
                transform: translateY(-30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
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

        .message {
            padding: 15px 20px;
            margin: 20px 0;
            border-radius: 12px;
            text-align: center;
            font-weight: 500;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            animation: slideIn 0.5s ease-out;
        }

        .success {
            background: linear-gradient(135deg, #a8e6cf, #88d8a3);
            color: #2d5a3d;
            border: 1px solid #7bc96f;
        }

        .error {
            background: linear-gradient(135deg, #ffb3ba, #ff9999);
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        @keyframes slideIn {
            from {
                transform: translateX(-100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }

        .search-container {
            background: white;
            padding: 20px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.1);
            backdrop-filter: blur(10px);
        }

        .search-box {
            position: relative;
            max-width: 500px;
            margin: 0 auto;
        }

        .search-input {
            width: 100%;
            padding: 15px 50px 15px 20px;
            border: 2px solid #e1e8ed;
            border-radius: 25px;
            font-size: 16px;
            outline: none;
            transition: all 0.3s ease;
        }

        .search-input:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .search-icon {
            position: absolute;
            right: 20px;
            top: 50%;
            transform: translateY(-50%);
            color: #667eea;
        }

        .doctors-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 25px;
            margin-top: 30px;
        }

        .doctor-card {
            background: white;
            border-radius: 20px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.6s ease-out;
        }

        .doctor-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }

        .doctor-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, #667eea, #764ba2);
        }

        .doctor-info h3 {
            color: #2c3e50;
            font-size: 1.4em;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .doctor-detail {
            display: flex;
            align-items: center;
            margin-bottom: 12px;
            color: #666;
            font-size: 0.95em;
        }

        .doctor-detail i {
            width: 20px;
            color: #667eea;
            margin-right: 10px;
        }

        .specialization-tag {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 6px 15px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: 500;
            display: inline-block;
            margin: 10px 0;
        }

        .book-btn {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            text-decoration: none;
            padding: 12px 25px;
            border-radius: 25px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            margin-top: 15px;
            border: none;
            cursor: pointer;
            font-size: 0.95em;
        }

        .book-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
            background: linear-gradient(135deg, #5a67d8, #6b46c1);
        }

        .no-data {
            text-align: center;
            color: white;
            font-size: 1.2em;
            background: rgba(255,255,255,0.1);
            padding: 60px 40px;
            border-radius: 20px;
            backdrop-filter: blur(10px);
            animation: fadeIn 0.8s ease-out;
        }

        .no-data i {
            font-size: 3em;
            margin-bottom: 20px;
            opacity: 0.7;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .footer-info {
            text-align: center;
            color: rgba(255,255,255,0.8);
            margin-top: 40px;
            padding: 20px;
            background: rgba(255,255,255,0.1);
            border-radius: 15px;
            backdrop-filter: blur(10px);
        }

        .stats-container {
            background: rgba(255,255,255,0.1);
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 30px;
            backdrop-filter: blur(10px);
            color: white;
            text-align: center;
        }

        .stats-container h3 {
            margin-bottom: 10px;
            font-size: 1.1em;
        }

        .stats-number {
            font-size: 2em;
            font-weight: bold;
            color: #fff;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .container {
                padding: 15px;
            }
            
            .header h1 {
                font-size: 2em;
            }
            
            .doctors-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }
            
            .doctor-card {
                padding: 20px;
            }
            
            .search-input {
                padding: 12px 45px 12px 15px;
                font-size: 14px;
            }
        }

        /* Loading Animation */
        .loading {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid rgba(255,255,255,.3);
            border-radius: 50%;
            border-top-color: #fff;
            animation: spin 1s ease-in-out infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-user-md"></i> Danh sách bác sĩ</h1>
            <p>Tìm và đặt lịch hẹn với các bác sĩ chuyên khoa</p>
        </div>
        
        <!-- Hiển thị thông báo thành công hoặc lỗi -->
        <c:if test="${not empty success}">
            <div class="message success">
                <i class="fas fa-check-circle"></i> ${success}
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="message error">
                <i class="fas fa-exclamation-triangle"></i> ${error}
            </div>
        </c:if>

        <!-- Thống kê -->
        <c:if test="${not empty doctors}">
            <div class="stats-container">
                <h3><i class="fas fa-chart-bar"></i> Thống kê hệ thống</h3>
                <div class="stats-number">${doctors.size()}</div>
                <p>Bác sĩ có sẵn</p>
            </div>
        </c:if>

        <!-- Tìm kiếm -->
        <div class="search-container">
            <div class="search-box">
                <input type="text" class="search-input" id="searchInput" placeholder="Tìm kiếm theo tên bác sĩ hoặc chuyên môn...">
                <i class="fas fa-search search-icon"></i>
            </div>
        </div>
        
        <!-- Hiển thị danh sách bác sĩ -->
        <c:choose>
            <c:when test="${not empty doctors}">
                <div class="doctors-grid" id="doctorsGrid">
                    <c:forEach var="doctor" items="${doctors}">
                        <div class="doctor-card" data-name="${doctor.fullName}" data-specialization="${doctor.specialization}">
                            <div class="doctor-info">
                                <h3>
                                    <i class="fas fa-user-md"></i>
                                    ${doctor.fullName}
                                </h3>
                                <div class="specialization-tag">
                                    <i class="fas fa-stethoscope"></i>
                                    ${doctor.specialization}
                                </div>
                                
                                <div class="doctor-detail">
                                    <i class="fas fa-id-card"></i>
                                    <span>Mã BS: ${doctor.userID}</span>
                                </div>
                                
                                <div class="doctor-detail">
                                    <i class="fas fa-envelope"></i>
                                    <span>${doctor.email}</span>
                                </div>
                                
                                <div class="doctor-detail">
                                    <i class="fas fa-phone"></i>
                                    <span>${doctor.phone}</span>
                                </div>
                                
                                <a href="${pageContext.request.contextPath}/ViewDetailBookServlet?doctorId=${doctor.userID}" class="book-btn">
                                    <i class="fas fa-calendar-plus"></i>
                                    Đặt lịch hẹn
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="no-data">
                    <i class="fas fa-user-md-slash"></i>
                    <h3>Không có bác sĩ nào được tìm thấy</h3>
                    <p>Vui lòng thử lại sau hoặc liên hệ với quản trị viên</p>
                </div>
            </c:otherwise>
        </c:choose>
        
        <!-- Thông tin thời gian hiện tại -->
        <div class="footer-info">
            <i class="fas fa-clock"></i>
            Cập nhật lúc: <%= new java.text.SimpleDateFormat("HH:mm:ss dd/MM/yyyy").format(new java.util.Date()) %> (Giờ Việt Nam)
        </div>
    </div>

    <script>
        // Tìm kiếm real-time
        document.getElementById('searchInput').addEventListener('input', function(e) {
            const searchTerm = e.target.value.toLowerCase();
            const doctorCards = document.querySelectorAll('.doctor-card');
            
            doctorCards.forEach(card => {
                const name = card.getAttribute('data-name').toLowerCase();
                const specialization = card.getAttribute('data-specialization').toLowerCase();
                
                if (name.includes(searchTerm) || specialization.includes(searchTerm)) {
                    card.style.display = 'block';
                    card.style.animation = 'fadeInUp 0.5s ease-out';
                } else {
                    card.style.display = 'none';
                }
            });
        });

        // Animation khi load trang
        window.addEventListener('load', function() {
            const cards = document.querySelectorAll('.doctor-card');
            cards.forEach((card, index) => {
                card.style.animationDelay = `${index * 0.1}s`;
            });
        });

        // Hiệu ứng hover cho các button
        document.querySelectorAll('.book-btn').forEach(btn => {
            btn.addEventListener('mouseenter', function() {
                this.innerHTML = '<i class="fas fa-calendar-check"></i> Đặt ngay';
            });
            
            btn.addEventListener('mouseleave', function() {
                this.innerHTML = '<i class="fas fa-calendar-plus"></i> Đặt lịch hẹn';
            });
        });

        // Smooth scroll animation
        document.documentElement.style.scrollBehavior = 'smooth';
    </script>
</body>
</html>
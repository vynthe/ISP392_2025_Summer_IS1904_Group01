<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="model.entity.Users" %>
<%
    // Giả sử user profile đã được lưu trong request hoặc session attribute là "userProfile"
    Users user = (Users) request.getAttribute("userProfile");
    if (user == null) {
        out.println("<h3>Không tìm thấy thông tin người dùng!</h3>");
        return;
    }
    request.setAttribute("user", user); // gán biến 'user' để EL truy cập
%>
<html>
<head>
    <title>Hồ Sơ Bệnh Nhân</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
            position: relative;
            overflow-x: hidden;
        }

        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: 
                radial-gradient(circle at 20% 50%, rgba(120, 119, 198, 0.3) 0%, transparent 50%),
                radial-gradient(circle at 80% 20%, rgba(255, 255, 255, 0.1) 0%, transparent 50%),
                radial-gradient(circle at 40% 80%, rgba(120, 119, 198, 0.2) 0%, transparent 50%);
            pointer-events: none;
            z-index: -1;
        }
        
        .profile-container {
            max-width: 850px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 32px;
            box-shadow: 
                0 32px 80px rgba(0, 0, 0, 0.12),
                0 8px 32px rgba(0, 0, 0, 0.08),
                inset 0 1px 0 rgba(255, 255, 255, 0.6);
            position: relative;
            overflow: hidden;
            animation: slideUp 0.8s cubic-bezier(0.25, 0.46, 0.45, 0.94);
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(50px) scale(0.95);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }
        
        .profile-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 6px;
            background: linear-gradient(90deg, #667eea, #764ba2, #f093fb, #667eea);
            background-size: 300% 100%;
            animation: gradientShift 4s ease-in-out infinite;
        }

        @keyframes gradientShift {
            0%, 100% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
        }

        .profile-header {
            text-align: center;
            padding: 50px 40px 40px;
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.05) 0%, rgba(118, 75, 162, 0.05) 100%);
            position: relative;
        }

        .profile-header::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 2px;
            background: linear-gradient(90deg, #667eea, #764ba2);
            border-radius: 2px;
        }
        
        .profile-avatar {
            width: 140px;
            height: 140px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 24px;
            box-shadow: 
                0 20px 40px rgba(102, 126, 234, 0.3),
                0 8px 16px rgba(0, 0, 0, 0.1),
                inset 0 2px 0 rgba(255, 255, 255, 0.3);
            position: relative;
            animation: float 6s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-8px); }
        }

        .profile-avatar::before {
            content: '';
            position: absolute;
            top: -3px;
            left: -3px;
            right: -3px;
            bottom: -3px;
            background: linear-gradient(135deg, #667eea, #764ba2, #f093fb, #667eea);
            border-radius: 50%;
            z-index: -1;
            animation: rotate 8s linear infinite;
            opacity: 0.7;
        }

        @keyframes rotate {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }
        
        .profile-avatar i {
            font-size: 4rem;
            color: white;
            text-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            position: relative;
            z-index: 1;
        }
        
        .profile-title {
            background: linear-gradient(135deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-size: 2.5rem;
            font-weight: 800;
            margin-bottom: 8px;
            letter-spacing: -0.5px;
        }
        
        .profile-subtitle {
            color: #64748b;
            font-size: 1.1rem;
            font-weight: 500;
            opacity: 0.8;
        }

        .profile-content {
            padding: 40px;
        }

        .fields-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        
        .profile-field {
            display: flex;
            align-items: center;
            padding: 24px;
            background: rgba(255, 255, 255, 0.8);
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.3);
            transition: all 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
            position: relative;
            overflow: hidden;
            backdrop-filter: blur(10px);
        }

        .profile-field::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.4), transparent);
            transition: left 0.6s;
        }

        .profile-field:hover::before {
            left: 100%;
        }
        
        .profile-field:hover {
            background: rgba(255, 255, 255, 0.95);
            box-shadow: 
                0 16px 40px rgba(0, 0, 0, 0.12),
                0 4px 16px rgba(102, 126, 234, 0.08);
            transform: translateY(-4px) scale(1.02);
            border-color: rgba(102, 126, 234, 0.2);
        }
        
        .field-icon {
            width: 56px;
            height: 56px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 20px;
            font-size: 1.4rem;
            color: white;
            flex-shrink: 0;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
            position: relative;
        }

        .field-icon::before {
            content: '';
            position: absolute;
            top: 2px;
            left: 2px;
            right: 2px;
            bottom: 2px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 12px;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .profile-field:hover .field-icon::before {
            opacity: 1;
        }
        
        .icon-user { background: linear-gradient(135deg, #667eea, #764ba2); }
        .icon-email { background: linear-gradient(135deg, #f093fb, #f5576c); }
        .icon-calendar { background: linear-gradient(135deg, #4facfe, #00f2fe); }
        .icon-gender { background: linear-gradient(135deg, #43e97b, #38f9d7); }
        .icon-phone { background: linear-gradient(135deg, #fa709a, #fee140); }
        .icon-address { background: linear-gradient(135deg, #a8edea, #fed6e3); }
        .icon-id { background: linear-gradient(135deg, #d299c2, #fef9d7); }
        
        .field-content {
            flex: 1;
            min-width: 0;
        }
        
        .field-label {
            font-weight: 700;
            color: #475569;
            font-size: 0.85rem;
            margin-bottom: 6px;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            opacity: 0.8;
        }
        
        .field-value {
            color: #1e293b;
            font-size: 1.15rem;
            font-weight: 600;
            word-break: break-word;
            line-height: 1.4;
        }
        
        .back-button {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 16px 32px;
            border-radius: 50px;
            font-weight: 700;
            font-size: 1.1rem;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 12px;
            transition: all 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
            box-shadow: 
                0 8px 32px rgba(102, 126, 234, 0.4),
                0 4px 16px rgba(0, 0, 0, 0.1);
            position: relative;
            overflow: hidden;
            border: 2px solid transparent;
        }

        .back-button::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.6s;
        }

        .back-button:hover::before {
            left: 100%;
        }
        
        .back-button:hover {
            transform: translateY(-3px) scale(1.05);
            box-shadow: 
                0 16px 40px rgba(102, 126, 234, 0.6),
                0 8px 24px rgba(0, 0, 0, 0.15);
            border-color: rgba(255, 255, 255, 0.3);
        }
        
        .profile-footer {
            text-align: center;
            padding: 0 40px 40px;
            border-top: 1px solid rgba(0, 0, 0, 0.06);
            margin-top: 20px;
            padding-top: 40px;
        }

        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 16px;
            margin-bottom: 32px;
        }

        .stat-item {
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.1), rgba(118, 75, 162, 0.05));
            border-radius: 16px;
            padding: 20px;
            text-align: center;
            border: 1px solid rgba(102, 126, 234, 0.1);
            transition: all 0.3s ease;
        }

        .stat-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.15);
        }

        .stat-value {
            font-size: 1.5rem;
            font-weight: 800;
            background: linear-gradient(135deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .stat-label {
            font-size: 0.8rem;
            font-weight: 600;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            margin-top: 4px;
        }
        
        @media (max-width: 768px) {
            body {
                padding: 15px;
            }

            .profile-container {
                border-radius: 24px;
            }

            .profile-header {
                padding: 40px 25px 30px;
            }

            .profile-content {
                padding: 30px 25px;
            }

            .profile-footer {
                padding: 0 25px 30px;
                padding-top: 30px;
            }
            
            .fields-grid {
                grid-template-columns: 1fr;
                gap: 16px;
            }
            
            .profile-field {
                padding: 20px;
            }

            .field-icon {
                width: 48px;
                height: 48px;
                margin-right: 16px;
                font-size: 1.2rem;
            }
            
            .profile-title {
                font-size: 2rem;
            }

            .profile-avatar {
                width: 120px;
                height: 120px;
            }

            .profile-avatar i {
                font-size: 3rem;
            }

            .stats-container {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 480px) {
            .fields-grid {
                grid-template-columns: 1fr;
            }

            .profile-field {
                flex-direction: column;
                align-items: center;
                text-align: center;
                padding: 24px 16px;
            }

            .field-icon {
                margin-right: 0;
                margin-bottom: 12px;
            }

            .back-button {
                padding: 14px 28px;
                font-size: 1rem;
            }

            .stats-container {
                grid-template-columns: 1fr;
            }
        }
        
        .fade-in {
            animation: fadeIn 0.8s ease-out;
        }
        
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .profile-field:nth-child(odd) {
            animation-delay: 0.1s;
        }

        .profile-field:nth-child(even) {
            animation-delay: 0.2s;
        }

        .floating-shapes {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: -1;
        }

        .shape {
            position: absolute;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.1);
            animation: float-shapes 20s infinite linear;
        }

        .shape:nth-child(1) {
            width: 80px;
            height: 80px;
            top: 20%;
            left: 10%;
            animation-delay: 0s;
        }

        .shape:nth-child(2) {
            width: 120px;
            height: 120px;
            top: 60%;
            right: 10%;
            animation-delay: -5s;
        }

        .shape:nth-child(3) {
            width: 60px;
            height: 60px;
            bottom: 30%;
            left: 20%;
            animation-delay: -10s;
        }

        @keyframes float-shapes {
            0%, 100% {
                transform: translateY(0px) rotate(0deg);
            }
            33% {
                transform: translateY(-30px) rotate(120deg);
            }
            66% {
                transform: translateY(30px) rotate(240deg);
            }
        }
    </style>
</head>
<body>
    <div class="floating-shapes">
        <div class="shape"></div>
        <div class="shape"></div>
        <div class="shape"></div>
    </div>

    <div class="profile-container fade-in">
        <div class="profile-header">
            <div class="profile-avatar">
                <i class="fas fa-user-injured"></i>
            </div>
            <h1 class="profile-title">Hồ Sơ Bệnh Nhân</h1>
            <p class="profile-subtitle">Thông tin cá nhân chi tiết và bảo mật</p>
        </div>

        <div class="profile-content">
            <div class="stats-container">
                <div class="stat-item">
                    <div class="stat-value">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <div class="stat-label">Bảo mật</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="stat-label">Xác thực</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">
                        <i class="fas fa-heart"></i>
                    </div>
                    <div class="stat-label">Sức khỏe</div>
                </div>
            </div>
        
            <div class="fields-grid">
                <div class="profile-field fade-in">
                    <div class="field-icon icon-id">
                        <i class="fas fa-fingerprint"></i>
                    </div>
                    <div class="field-content">
                        <div class="field-label">User ID</div>
                        <div class="field-value"><c:out value="${user.userID}"/></div>
                    </div>
                </div>
                
                <div class="profile-field fade-in">
                    <div class="field-icon icon-user">
                        <i class="fas fa-user-circle"></i>
                    </div>
                    <div class="field-content">
                        <div class="field-label">Tên đăng nhập</div>
                        <div class="field-value"><c:out value="${user.username}"/></div>
                    </div>
                </div>
                
                <div class="profile-field fade-in">
                    <div class="field-icon icon-user">
                        <i class="fas fa-user-tie"></i>
                    </div>
                    <div class="field-content">
                        <div class="field-label">Họ và tên</div>
                        <div class="field-value"><c:out value="${user.fullName}"/></div>
                    </div>
                </div>
                
                <div class="profile-field fade-in">
                    <div class="field-icon icon-email">
                        <i class="fas fa-paper-plane"></i>
                    </div>
                    <div class="field-content">
                        <div class="field-label">Email</div>
                        <div class="field-value"><c:out value="${user.email}"/></div>
                    </div>
                </div>
                
                <div class="profile-field fade-in">
                    <div class="field-icon icon-calendar">
                        <i class="fas fa-gift"></i>
                    </div>
                    <div class="field-content">
                        <div class="field-label">Ngày sinh</div>
                        <div class="field-value"><c:out value="${user.dob}"/></div>
                    </div>
                </div>
                
                <div class="profile-field fade-in">
                    <div class="field-icon icon-gender">
                        <i class="fas fa-smile"></i>
                    </div>
                    <div class="field-content">
                        <div class="field-label">Giới tính</div>
                        <div class="field-value"><c:out value="${user.gender}"/></div>
                    </div>
                </div>
                
                <div class="profile-field fade-in">
                    <div class="field-icon icon-phone">
                        <i class="fas fa-mobile-alt"></i>
                    </div>
                    <div class="field-content">
                        <div class="field-label">Số điện thoại</div>
                        <div class="field-value"><c:out value="${user.phone}"/></div>
                    </div>
                </div>
                
                <div class="profile-field fade-in">
                    <div class="field-icon icon-address">
                        <i class="fas fa-home"></i>
                    </div>
                    <div class="field-content">
                        <div class="field-label">Địa chỉ</div>
                        <div class="field-value"><c:out value="${user.address}"/></div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="profile-footer">
            <a href="${pageContext.request.contextPath}/views/user/Patient/PatientDashBoard.jsp" class="back-button">
                <i class="fas fa-arrow-left"></i>
                Quay lại trang chủ
            </a>
            <a href="${pageContext.request.contextPath}/views/user/Patient/EditProfilePatient.jsp" class="back-button">
               
              Cập nhật
            </a>
        </div>
    </div>
</body>
</html>
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
    <title>Patient Profile</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');
        
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        
        .profile-container {
            max-width: 700px;
            margin: 2rem auto;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 24px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.15);
            padding: 2.5rem;
            position: relative;
            overflow: hidden;
        }
        
        .profile-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2, #f093fb);
            border-radius: 24px 24px 0 0;
        }
        
        .profile-header {
            text-align: center;
            margin-bottom: 2rem;
            position: relative;
        }
        
        .profile-avatar {
            width: 120px;
            height: 120px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
        }
        
        .profile-avatar i {
            font-size: 3rem;
            color: white;
        }
        
        .profile-title {
            background: linear-gradient(135deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        
        .profile-subtitle {
            color: #6b7280;
            font-size: 1rem;
            font-weight: 500;
        }
        
        .profile-field {
            display: flex;
            align-items: center;
            margin-bottom: 1.5rem;
            padding: 1rem;
            background: rgba(255, 255, 255, 0.7);
            border-radius: 16px;
            border: 1px solid rgba(255, 255, 255, 0.3);
            transition: all 0.3s ease;
            position: relative;
        }
        
        .profile-field:hover {
            background: rgba(255, 255, 255, 0.9);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            transform: translateY(-2px);
        }
        
        .field-icon {
            width: 45px;
            height: 45px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 1rem;
            font-size: 1.2rem;
            color: white;
            flex-shrink: 0;
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
        }
        
        .field-label {
            font-weight: 600;
            color: #374151;
            font-size: 0.9rem;
            margin-bottom: 0.25rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        
        .field-value {
            color: #1f2937;
            font-size: 1.1rem;
            font-weight: 500;
        }
        
        .back-button {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 0.75rem 2rem;
            border-radius: 50px;
            font-weight: 600;
            font-size: 1rem;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }
        
        .back-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.6);
        }
        
        .profile-footer {
            text-align: center;
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid rgba(0, 0, 0, 0.1);
        }
        
        @media (max-width: 640px) {
            .profile-container {
                margin: 1rem;
                padding: 1.5rem;
            }
            
            .profile-field {
                flex-direction: column;
                align-items: flex-start;
                text-align: left;
            }
            
            .field-icon {
                margin-bottom: 0.5rem;
            }
            
            .profile-title {
                font-size: 1.5rem;
            }
        }
        
        .fade-in {
            animation: fadeIn 0.6s ease-out;
        }
        
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>
    <div class="profile-container fade-in">
        <div class="profile-header">
            <div class="profile-avatar">
                <i class="fas fa-user-injured"></i>
            </div>
            <h1 class="profile-title">Hồ Sơ Bệnh Nhân</h1>
            <p class="profile-subtitle">Thông tin chi tiết và an toàn</p>
        </div>
        
        <div class="profile-field">
            <div class="field-icon icon-id">
                <i class="fas fa-fingerprint"></i>
            </div>
            <div class="field-content">
                <div class="field-label">User ID</div>
                <div class="field-value"><c:out value="${user.userID}"/></div>
            </div>
        </div>
        
        <div class="profile-field">
            <div class="field-icon icon-user">
                <i class="fas fa-user-circle"></i>
            </div>
            <div class="field-content">
                <div class="field-label">Tên đăng nhập</div>
                <div class="field-value"><c:out value="${user.username}"/></div>
            </div>
        </div>
        
        <div class="profile-field">
            <div class="field-icon icon-user">
                <i class="fas fa-user-tie"></i>
            </div>
            <div class="field-content">
                <div class="field-label">Họ và tên</div>
                <div class="field-value"><c:out value="${user.fullName}"/></div>
            </div>
        </div>
        
        <div class="profile-field">
            <div class="field-icon icon-email">
                <i class="fas fa-paper-plane"></i>
            </div>
            <div class="field-content">
                <div class="field-label">Email</div>
                <div class="field-value"><c:out value="${user.email}"/></div>
            </div>
        </div>
        
        <div class="profile-field">
            <div class="field-icon icon-calendar">
                <i class="fas fa-gift"></i>
            </div>
            <div class="field-content">
                <div class="field-label">Ngày sinh</div>
                <div class="field-value"><c:out value="${user.dob}"/></div>
            </div>
        </div>
        
        <div class="profile-field">
            <div class="field-icon icon-gender">
                <i class="fas fa-smile"></i>
            </div>
            <div class="field-content">
                <div class="field-label">Giới tính</div>
                <div class="field-value"><c:out value="${user.gender}"/></div>
            </div>
        </div>
        
        <div class="profile-field">
            <div class="field-icon icon-phone">
                <i class="fas fa-mobile-alt"></i>
            </div>
            <div class="field-content">
                <div class="field-label">Số điện thoại</div>
                <div class="field-value"><c:out value="${user.phone}"/></div>
            </div>
        </div>
        
        <div class="profile-field">
            <div class="field-icon icon-address">
                <i class="fas fa-home"></i>
            </div>
            <div class="field-content">
                <div class="field-label">Địa chỉ</div>
                <div class="field-value"><c:out value="${user.address}"/></div>
            </div>
        </div>
        

        
        <div class="profile-footer">
            <a href="${pageContext.request.contextPath}/views/user/Patient/PatientDashBoard.jsp" class="back-button">
                <i class="fas fa-arrow-left"></i>
                Quay lại trang chủ
            </a>
        </div>
    </div>
</body>
</html>
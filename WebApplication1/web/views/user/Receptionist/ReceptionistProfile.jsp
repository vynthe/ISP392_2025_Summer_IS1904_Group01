<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="model.entity.Users" %>
<%
    Users user = (Users) request.getAttribute("userProfile");
    if (user == null) {
        out.println("<h3>Không tìm thấy thông tin người dùng!</h3>");
        return;
    }
    request.setAttribute("user", user);
%>
<html>
<head>
    <title>Receptionist Profile</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap');
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .profile-wrapper {
            max-width: 1200px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 30px;
            height: fit-content;
        }
        
        .profile-sidebar {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(15px);
            border-radius: 25px;
            padding: 40px 30px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .profile-sidebar::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: conic-gradient(from 0deg, transparent, rgba(102, 126, 234, 0.1), transparent);
            animation: rotate 20s linear infinite;
        }
        
        @keyframes rotate {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        .avatar-section {
            position: relative;
            z-index: 2;
            margin-bottom: 30px;
        }
        
        .avatar-ring {
            width: 140px;
            height: 140px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea, #764ba2);
            margin: 0 auto 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            animation: pulse-ring 2s infinite;
        }
        
        @keyframes pulse-ring {
            0%, 100% { transform: scale(1); box-shadow: 0 0 0 0 rgba(102, 126, 234, 0.4); }
            50% { transform: scale(1.05); box-shadow: 0 0 0 20px rgba(102, 126, 234, 0); }
        }
        
        .avatar-content {
            width: 120px;
            height: 120px;
            background: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            color: #667eea;
        }
        
        .status-badge {
            position: absolute;
            bottom: 10px;
            right: 10px;
            background: #10b981;
            color: white;
            padding: 8px 12px;
            border-radius: 20px;
            font-size: 0.7rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 5px;
            border: 3px solid white;
        }
        
        .profile-name {
            font-size: 1.8rem;
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 10px;
        }
        
        .profile-role {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 8px 20px;
            border-radius: 25px;
            font-size: 0.9rem;
            font-weight: 600;
            display: inline-block;
            margin-bottom: 30px;
        }
        
        .quick-stats {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-top: 30px;
        }
        
        .stat-item {
            background: rgba(102, 126, 234, 0.1);
            padding: 20px;
            border-radius: 15px;
            text-align: center;
        }
        
        .stat-icon {
            font-size: 1.5rem;
            color: #667eea;
            margin-bottom: 10px;
        }
        
        .stat-value {
            font-size: 1.2rem;
            font-weight: 700;
            color: #1f2937;
        }
        
        .stat-label {
            font-size: 0.8rem;
            color: #6b7280;
            margin-top: 5px;
        }
        
        .profile-details {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(15px);
            border-radius: 25px;
            padding: 40px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .details-header {
            display: flex;
            align-items: center;
            justify-content: between;
            margin-bottom: 35px;
        }
        
        .details-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #1f2937;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .info-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
        }
        
        .info-card {
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.05), rgba(118, 75, 162, 0.05));
            border: 1px solid rgba(102, 126, 234, 0.1);
            border-radius: 18px;
            padding: 25px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .info-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: linear-gradient(135deg, #667eea, #764ba2);
        }
        
        .info-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(102, 126, 234, 0.2);
            border-color: rgba(102, 126, 234, 0.3);
        }
        
        .card-header {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .card-icon {
            width: 45px;
            height: 45px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.2rem;
            margin-right: 15px;
        }
        
        .card-title {
            font-size: 0.85rem;
            font-weight: 600;
            color: #6b7280;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .card-content {
            font-size: 1.1rem;
            font-weight: 600;
            color: #1f2937;
            line-height: 1.4;
        }
        
        .action-section {
            margin-top: 40px;
            text-align: center;
        }
        
        .action-button {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 15px 40px;
            border-radius: 50px;
            font-weight: 600;
            font-size: 1rem;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 12px;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }
        
        .action-button:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 30px rgba(102, 126, 234, 0.4);
        }
        
        .floating-elements {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: -1;
        }
        
        .floating-circle {
            position: absolute;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.1);
            animation: float 6s ease-in-out infinite;
        }
        
        .floating-circle:nth-child(1) {
            width: 80px;
            height: 80px;
            top: 20%;
            left: 10%;
            animation-delay: -2s;
        }
        
        .floating-circle:nth-child(2) {
            width: 120px;
            height: 120px;
            top: 70%;
            right: 10%;
            animation-delay: -4s;
        }
        
        .floating-circle:nth-child(3) {
            width: 60px;
            height: 60px;
            top: 40%;
            right: 20%;
            animation-delay: -1s;
        }
        
        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-20px); }
        }
        
        @media (max-width: 768px) {
            .profile-wrapper {
                grid-template-columns: 1fr;
                gap: 20px;
                padding: 10px;
            }
            
            .profile-sidebar, .profile-details {
                padding: 25px;
            }
            
            .info-cards {
                grid-template-columns: 1fr;
            }
            
            .quick-stats {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="floating-elements">
        <div class="floating-circle"></div>
        <div class="floating-circle"></div>
        <div class="floating-circle"></div>
    </div>
    
    <div class="profile-wrapper">
        <!-- Sidebar -->
        <div class="profile-sidebar">
            <div class="avatar-section">
                <div class="avatar-ring">
                    <div class="avatar-content">
                        <i class="fas fa-user-tie"></i>
                    </div>
                </div>
                <div class="status-badge">
                    <i class="fas fa-circle"></i>
                    Online
                </div>
            </div>
            
            <h1 class="profile-name"><c:out value="${user.fullName}"/></h1>
            <div class="profile-role">
                <i class="fas fa-headset"></i>
                Lễ Tân 
            </div>
            
            <div class="quick-stats">
                <div class="stat-item">
                    <div class="stat-icon">
                        <i class="fas fa-id-badge"></i>
                    </div>
                    <div class="stat-value"><c:out value="${user.userID}"/></div>
                    <div class="stat-label">Employee ID</div>
                </div>
                
                <div class="stat-item">
                    <div class="stat-icon">
                        <i class="fas fa-calendar-check"></i>
                    </div>
                    <div class="stat-value">Active</div>
                    <div class="stat-label">Status</div>
                </div>
            </div>
        </div>
        
        <!-- Main Content -->
        <div class="profile-details">
            <div class="details-header">
                <h2 class="details-title">
                    <i class="fas fa-user-circle"></i>
                    Thông Tin Chi Tiết
                </h2>
            </div>
            
            <div class="info-cards">
                <div class="info-card">
                    <div class="card-header">
                        <div class="card-icon">
                            <i class="fas fa-at"></i>
                        </div>
                        <div class="card-title">Username</div>
                    </div>
                    <div class="card-content"><c:out value="${user.username}"/></div>
                </div>
                
                <div class="info-card">
                    <div class="card-header">
                        <div class="card-icon">
                            <i class="fas fa-envelope"></i>
                        </div>
                        <div class="card-title">Email Address</div>
                    </div>
                    <div class="card-content"><c:out value="${user.email}"/></div>
                </div>
                
                <div class="info-card">
                    <div class="card-header">
                        <div class="card-icon">
                            <i class="fas fa-phone-alt"></i>
                        </div>
                        <div class="card-title">Phone Number</div>
                    </div>
                    <div class="card-content"><c:out value="${user.phone}"/></div>
                </div>
                
                <div class="info-card">
                    <div class="card-header">
                        <div class="card-icon">
                            <i class="fas fa-birthday-cake"></i>
                        </div>
                        <div class="card-title">Date of Birth</div>
                    </div>
                    <div class="card-content"><c:out value="${user.dob}"/></div>
                </div>
                
                <div class="info-card">
                    <div class="card-header">
                        <div class="card-icon">
                            <i class="fas fa-venus-mars"></i>
                        </div>
                        <div class="card-title">Gender</div>
                    </div>
                    <div class="card-content"><c:out value="${user.gender}"/></div>
                </div>
                
                <div class="info-card">
                    <div class="card-header">
                        <div class="card-icon">
                            <i class="fas fa-map-marker-alt"></i>
                        </div>
                        <div class="card-title">Address</div>
                    </div>
                    <div class="card-content"><c:out value="${user.address}"/></div>
                </div>
                
                <c:if test="${not empty user.specialization}">
                    <div class="info-card">
                        <div class="card-header">
                            <div class="card-icon">
                                <i class="fas fa-award"></i>
                            </div>
                            <div class="card-title">Specialization</div>
                        </div>
                        <div class="card-content"><c:out value="${user.specialization}"/></div>
                    </div>
                </c:if>
            </div>
            
            <div class="action-section">
                <a href="${pageContext.request.contextPath}/views/user/Receptionist/ReceptionistDashBoard.jsp" class="action-button">
                    <i class="fas fa-home"></i>
                    Quay Về Trang Chủ
                </a>
                <a href="${pageContext.request.contextPath}/views/user/Receptionist/EditProfileReceptionist.jsp" class="action-button">
                    <i class="fas fa-edit"></i>
                    Cập nhật
                </a>
            </div>
        </div>
    </div>
</body>
</html>
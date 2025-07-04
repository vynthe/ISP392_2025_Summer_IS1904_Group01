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
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ Sơ Bác Sĩ/Y Tá - ${user.fullName}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');
        
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        
        .profile-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.15);
        }
        
        .profile-header {
            background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
            position: relative;
            overflow: hidden;
        }
        
        .profile-header::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 100px;
            height: 100px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            transform: translate(30px, -30px);
        }
        
        .profile-avatar {
            width: 120px;
            height: 120px;
            background: linear-gradient(135deg, #60a5fa 0%, #3b82f6 100%);
            border: 4px solid rgba(255, 255, 255, 0.8);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }
        
        .info-card {
            background: white;
            border-left: 4px solid #3b82f6;
            transition: all 0.3s ease;
        }
        
        .info-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            border-left-color: #1d4ed8;
        }
        
        .icon-wrapper {
            background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%);
            color: #1d4ed8;
            transition: all 0.3s ease;
        }
        
        .info-card:hover .icon-wrapper {
            background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
            color: white;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .btn-primary::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }
        
        .btn-primary:hover::before {
            left: 100%;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 30px rgba(59, 130, 246, 0.4);
        }
        
        .specialization-badge {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            animation: pulse 2s infinite;
        }
        
        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }
        
        .fade-in {
            animation: fadeIn 0.8s ease-out forwards;
            opacity: 0;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .stagger-1 { animation-delay: 0.1s; }
        .stagger-2 { animation-delay: 0.2s; }
        .stagger-3 { animation-delay: 0.3s; }
        .stagger-4 { animation-delay: 0.4s; }
        .stagger-5 { animation-delay: 0.5s; }
        .stagger-6 { animation-delay: 0.6s; }
        .stagger-7 { animation-delay: 0.7s; }
        .stagger-8 { animation-delay: 0.8s; }
        .stagger-9 { animation-delay: 0.9s; }
    </style>
</head>
<body>
    <div class="min-h-screen py-8 px-4">
        <div class="max-w-4xl mx-auto">
            <!-- Header Section -->
            <div class="profile-card rounded-2xl overflow-hidden mb-8 fade-in">
                <div class="profile-header text-white p-8 text-center relative">
                    <div class="profile-avatar rounded-full mx-auto mb-4 flex items-center justify-center">
                        <i class="fas fa-user-md text-4xl text-white"></i>
                    </div>
                    <h1 class="text-3xl font-bold mb-2">
                        <c:out value="${user.fullName}"/>
                    </h1>
                    <p class="text-blue-100 text-lg">
                        <i class="fas fa-tooth mr-2"></i>
                        Chuyên viên Nha khoa
                    </p>
                    <c:if test="${not empty user.specialization && user.specialization != 'N/A'}">
                        <div class="specialization-badge inline-block mt-3 px-4 py-2 rounded-full text-white font-medium">
                            <i class="fas fa-certificate mr-2"></i>
                            <c:out value="${user.specialization}"/>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- Profile Information Grid -->
            <div class="grid md:grid-cols-2 gap-6">
                <!-- Personal Information -->
                <div class="space-y-4">
                    <h2 class="text-2xl font-bold text-white mb-6 flex items-center">
                        <i class="fas fa-user mr-3"></i>
                        Thông tin cá nhân
                    </h2>
                    
                    <div class="info-card rounded-xl p-6 fade-in stagger-1">
                        <div class="flex items-center space-x-4">
                            <div class="icon-wrapper w-12 h-12 rounded-lg flex items-center justify-center">
                                <i class="fas fa-id-card"></i>
                            </div>
                            <div class="flex-1">
                                <p class="text-sm text-gray-500 font-medium">Mã nhân viên</p>
                                <p class="text-lg font-semibold text-gray-900">
                                    <c:out value="${user.userID}"/>
                                </p>
                            </div>
                        </div>
                    </div>

                    <div class="info-card rounded-xl p-6 fade-in stagger-2">
                        <div class="flex items-center space-x-4">
                            <div class="icon-wrapper w-12 h-12 rounded-lg flex items-center justify-center">
                                <i class="fas fa-user"></i>
                            </div>
                            <div class="flex-1">
                                <p class="text-sm text-gray-500 font-medium">Tên đăng nhập</p>
                                <p class="text-lg font-semibold text-gray-900">
                                    <c:out value="${user.username}"/>
                                </p>
                            </div>
                        </div>
                    </div>

                    <div class="info-card rounded-xl p-6 fade-in stagger-3">
                        <div class="flex items-center space-x-4">
                            <div class="icon-wrapper w-12 h-12 rounded-lg flex items-center justify-center">
                                <i class="fas fa-birthday-cake"></i>
                            </div>
                            <div class="flex-1">
                                <p class="text-sm text-gray-500 font-medium">Ngày sinh</p>
                                <p class="text-lg font-semibold text-gray-900">
                                    <c:out value="${user.dob}"/>
                                </p>
                            </div>
                        </div>
                    </div>

                    <div class="info-card rounded-xl p-6 fade-in stagger-4">
                        <div class="flex items-center space-x-4">
                            <div class="icon-wrapper w-12 h-12 rounded-lg flex items-center justify-center">
                                <i class="fas fa-venus-mars"></i>
                            </div>
                            <div class="flex-1">
                                <p class="text-sm text-gray-500 font-medium">Giới tính</p>
                                <p class="text-lg font-semibold text-gray-900">
                                    <c:out value="${user.gender}"/>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Contact Information -->
                <div class="space-y-4">
                    <h2 class="text-2xl font-bold text-white mb-6 flex items-center">
                        <i class="fas fa-address-book mr-3"></i>
                        Thông tin liên hệ
                    </h2>

                    <div class="info-card rounded-xl p-6 fade-in stagger-5">
                        <div class="flex items-center space-x-4">
                            <div class="icon-wrapper w-12 h-12 rounded-lg flex items-center justify-center">
                                <i class="fas fa-envelope"></i>
                            </div>
                            <div class="flex-1">
                                <p class="text-sm text-gray-500 font-medium">Email</p>
                                <p class="text-lg font-semibold text-gray-900 break-all">
                                    <c:out value="${user.email}"/>
                                </p>
                            </div>
                        </div>
                    </div>

                    <div class="info-card rounded-xl p-6 fade-in stagger-6">
                        <div class="flex items-center space-x-4">
                            <div class="icon-wrapper w-12 h-12 rounded-lg flex items-center justify-center">
                                <i class="fas fa-phone"></i>
                            </div>
                            <div class="flex-1">
                                <p class="text-sm text-gray-500 font-medium">Số điện thoại</p>
                                <p class="text-lg font-semibold text-gray-900">
                                    <c:out value="${user.phone}"/>
                                </p>
                            </div>
                        </div>
                    </div>

                    <div class="info-card rounded-xl p-6 fade-in stagger-7">
                        <div class="flex items-center space-x-4">
                            <div class="icon-wrapper w-12 h-12 rounded-lg flex items-center justify-center">
                                <i class="fas fa-map-marker-alt"></i>
                            </div>
                            <div class="flex-1">
                                <p class="text-sm text-gray-500 font-medium">Địa chỉ</p>
                                <p class="text-lg font-semibold text-gray-900">
                                    <c:out value="${user.address}"/>
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- Professional Status -->
                    <div class="info-card rounded-xl p-6 fade-in stagger-8">
                        <div class="flex items-center space-x-4">
                            <div class="icon-wrapper w-12 h-12 rounded-lg flex items-center justify-center">
                                <i class="fas fa-briefcase-medical"></i>
                            </div>
                            <div class="flex-1">
                                <p class="text-sm text-gray-500 font-medium">Trạng thái</p>
                                <div class="flex items-center mt-1">
                                    <div class="w-3 h-3 bg-green-500 rounded-full mr-2 animate-pulse"></div>
                                    <p class="text-lg font-semibold text-green-600">Đang hoạt động</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="mt-8 text-center fade-in stagger-9">
                <a href="${pageContext.request.contextPath}/views/user/DoctorNurse/EmployeeDashBoard.jsp" 
                   class="btn-primary inline-flex items-center px-8 py-4 text-white font-semibold rounded-xl shadow-lg hover:shadow-xl transition-all duration-300">
                    <i class="fas fa-home mr-3"></i>
                    Quay lại trang chủ
                </a>
            </div>
        </div>
    </div>


</body>
</html>
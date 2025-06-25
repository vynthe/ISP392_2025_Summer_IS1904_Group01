<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.service.UserService" %>
<%@ page import="model.service.RoomService" %>
<%@ page import="java.sql.SQLException" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng Điều Khiển Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');
        
        * {
            font-family: 'Inter', sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            position: relative;
            overflow-x: hidden;
        }
        
        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="20" cy="20" r="1" fill="rgba(255,255,255,0.05)"/><circle cx="60" cy="40" r="1" fill="rgba(255,255,255,0.03)"/><circle cx="40" cy="80" r="1" fill="rgba(255,255,255,0.04)"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
            pointer-events: none;
        }
        
        .navbar {
            backdrop-filter: blur(20px);
            background: rgba(255, 255, 255, 0.1);
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }
        
        .dashboard-container {
            padding-top: 120px;
            position: relative;
            z-index: 1;
        }
        
        .welcome-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 24px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            padding: 32px;
            margin-bottom: 32px;
            position: relative;
            overflow: hidden;
        }
        
        .welcome-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2, #f093fb);
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 24px;
            margin-bottom: 32px;
        }
        
        .stat-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 20px;
            padding: 24px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, transparent, rgba(255, 255, 255, 0.1));
            pointer-events: none;
        }
        
        .stat-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
        }
        
        .action-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 24px;
        }
        
        .action-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 20px;
            padding: 32px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
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
            background: linear-gradient(135deg, transparent, rgba(255, 255, 255, 0.1));
            pointer-events: none;
        }
        
        .action-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
        }
        
        .action-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 100%;
            padding: 16px 24px;
            margin-bottom: 12px;
            border-radius: 12px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            border: none;
            cursor: pointer;
        }
        
        .action-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
            transition: left 0.5s ease;
        }
        
        .action-btn:hover::before {
            left: 100%;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.6);
        }
        
        .btn-secondary {
            background: linear-gradient(135deg, #4facfe, #00f2fe);
            color: white;
            box-shadow: 0 4px 15px rgba(79, 172, 254, 0.4);
        }
        
        .btn-secondary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(79, 172, 254, 0.6);
        }
        
        .btn-accent {
            background: linear-gradient(135deg, #fa709a, #fee140);
            color: white;
            box-shadow: 0 4px 15px rgba(250, 112, 154, 0.4);
        }
        
        .btn-accent:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(250, 112, 154, 0.6);
        }
        
        .btn-success {
            background: linear-gradient(135deg, #43e97b, #38f9d7);
            color: white;
            box-shadow: 0 4px 15px rgba(67, 233, 123, 0.4);
        }
        
        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(67, 233, 123, 0.6);
        }
        
        .user-menu {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 16px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            min-width: 200px;
            overflow: hidden;
        }
        
        .user-menu a {
            padding: 16px 20px;
            display: flex;
            align-items: center;
            gap: 12px;
            transition: all 0.3s ease;
            font-weight: 500;
        }
        
        .user-menu a:hover {
            background: rgba(102, 126, 234, 0.1);
            color: #667eea;
        }
        
        .user-avatar {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea, #764ba2);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 20px;
            font-weight: 600;
            border: 3px solid rgba(255, 255, 255, 0.3);
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .user-avatar:hover {
            transform: scale(1.1);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
        }
        
        .floating-shapes {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
            pointer-events: none;
            z-index: 0;
        }
        
        .floating-shapes::before,
        .floating-shapes::after {
            content: '';
            position: absolute;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.1);
            animation: float 6s ease-in-out infinite;
        }
        
        .floating-shapes::before {
            width: 100px;
            height: 100px;
            top: 20%;
            left: 10%;
            animation-delay: 0s;
        }
        
        .floating-shapes::after {
            width: 150px;
            height: 150px;
            top: 60%;
            right: 10%;
            animation-delay: 3s;
        }
        
        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(180deg); }
        }
        
        .icon-gradient {
            background: linear-gradient(135deg, #667eea, #764ba2);
            background-clip: text;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        @media (max-width: 768px) {
            .dashboard-container {
                padding-top: 100px;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .action-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="floating-shapes"></div>
    
    <!-- Navigation Bar -->
    <nav class="navbar fixed top-0 left-0 right-0 z-50 px-6 py-4">
        <div class="max-w-7xl mx-auto flex justify-between items-center">
            <div class="flex items-center space-x-4">
                <div class="text-white text-2xl font-bold">
                    <i class="fas fa-tooth mr-2"></i>
                    Dental Admin
                </div>
            </div>
            
            <div class="relative">
                <div class="user-avatar" id="userMenuBtn">
                    <i class="fas fa-user"></i>
                </div>
                <div id="userMenu" class="user-menu absolute right-0 top-14 hidden">
                    <a href="${pageContext.request.contextPath}/AdminProfileController">
                        <i class="fas fa-user-circle"></i>
                        View Profile
                    </a>
                    <a href="${pageContext.request.contextPath}/EditProfileAdminController">
                        <i class="fas fa-edit"></i>
                        Edit Profile
                    </a>
                    <a href="${pageContext.request.contextPath}/LogoutServlet" onclick="return confirm('Bạn có chắc muốn thoát?')">
                        <i class="fas fa-sign-out-alt"></i>
                        Sign Out
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Dashboard -->
    <div class="dashboard-container">
        <div class="max-w-7xl mx-auto px-6">
            <!-- Welcome Section -->
            <div class="welcome-card">
                <div class="flex items-center justify-between">
                    <div>
                        <h1 class="text-3xl font-bold text-gray-800 mb-2">
                            <i class="fas fa-crown mr-3 icon-gradient"></i>
                            Welcome Back, Admin!
                        </h1>
                        <p class="text-gray-600 text-lg">
                            Manage your dental clinic with ease and efficiency
                        </p>
                    </div>
                    <div class="hidden md:block">
                        <div class="text-6xl icon-gradient">
                            <i class="fas fa-hospital"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Stats Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="flex items-center justify-between">
                        <div>
                            <%
                                // Calculate total patients
                                UserService userService = new UserService();
                                int totalPatients;
                                try {
                                    totalPatients = userService.countPatients();
                                } catch (SQLException e) {
                                    totalPatients = 0;
                                    request.setAttribute("errorMessagePatients", "Không thể lấy số lượng bệnh nhân.");
                                    System.err.println("Error fetching patient count: " + e.getMessage());
                                }
                            %>
                            <h3 class="text-2xl font-bold text-gray-800"><%= totalPatients %></h3>
                            <p class="text-gray-600">Total Patients</p>
                            <c:if test="${errorMessagePatients != null}">
                                <p class="text-red-500 text-sm">${errorMessagePatients}</p>
                            </c:if>
                        </div>
                        <div class="text-3xl text-blue-500">
                            <i class="fas fa-users"></i>
                        </div>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="flex items-center justify-between">
                        <div>
                            <%
                                // Calculate total employees
                                int totalEmployees;
                                try {
                                    totalEmployees = userService.countEmployee();
                                } catch (SQLException e) {
                                    totalEmployees = 0;
                                    request.setAttribute("errorMessageEmployees", "Không thể lấy số lượng nhân viên.");
                                    System.err.println("Error fetching employee count: " + e.getMessage());
                                }
                            %>
                            <h3 class="text-2xl font-bold text-gray-800"><%= totalEmployees %></h3>
                            <p class="text-gray-600">Staff Members</p>
                            <c:if test="${errorMessageEmployees != null}">
                                <p class="text-red-500 text-sm">${errorMessageEmployees}</p>
                            </c:if>
                        </div>
                        <div class="text-3xl text-green-500">
                            <i class="fas fa-user-md"></i>
                        </div>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="flex items-center justify-between">
                        <div>
                            <%
                                // Calculate available rooms
                                RoomService roomsService = new RoomService();
                                int availableRooms;
                                try {
                                    availableRooms = roomsService.countAvailableRooms();
                                } catch (SQLException e) {
                                    availableRooms = 0;
                                    request.setAttribute("errorMessageRooms", "Không thể lấy số lượng phòng trống.");
                                    System.err.println("Error fetching available rooms count: " + e.getMessage());
                                }
                            %>
                            <h3 class="text-2xl font-bold text-gray-800"><%= availableRooms %></h3>
                            <p class="text-gray-600">Available Rooms</p>
                            <c:if test="${errorMessageRooms != null}">
                                <p class="text-red-500 text-sm">${errorMessageRooms}</p>
                            </c:if>
                        </div>
                        <div class="text-3xl text-purple-500">
                            <i class="fas fa-door-open"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Action Cards -->
            <div class="action-grid">
                <div class="action-card">
                    <h3 class="text-xl font-bold text-gray-800 mb-6 text-center">
                        <i class="fas fa-users mr-2 icon-gradient"></i>
                        Patient Management
                    </h3>
                    <a href="${pageContext.request.contextPath}/ViewPatientServlet" class="action-btn btn-primary">
                        <i class="fas fa-eye mr-2"></i>
                        View All Patients
                    </a>
                </div>

                <div class="action-card">
                    <h3 class="text-xl font-bold text-gray-800 mb-6 text-center">
                        <i class="fas fa-user-tie mr-2 icon-gradient"></i>
                        Staff Management
                    </h3>
                    <a href="${pageContext.request.contextPath}/ViewEmployeeServlet" class="action-btn btn-secondary">
                        <i class="fas fa-user-md mr-2"></i>
                        View All Employees
                    </a>
                </div>

                <div class="action-card">
                    <h3 class="text-xl font-bold text-gray-800 mb-6 text-center">
                        <i class="fas fa-cogs mr-2 icon-gradient"></i>
                        Service Management
                    </h3>
                    <a href="${pageContext.request.contextPath}/ViewServiceServlet" class="action-btn btn-accent">
                        <i class="fas fa-tooth mr-2"></i>
                        View All Services
                    </a>
                </div>

                <div class="action-card">
                    <h3 class="text-xl font-bold text-gray-800 mb-6 text-center">
                        <i class="fas fa-door-closed mr-2 icon-gradient"></i>
                        Room Management
                    </h3>
                    <a href="${pageContext.request.contextPath}/ViewRoomServlet" class="action-btn btn-success">
                        <i class="fas fa-bed mr-2"></i>
                        View All Rooms
                    </a>
                </div>

                <div class="action-card">
                    <h3 class="text-xl font-bold text-gray-800 mb-6 text-center">
                        <i class="fas fa-calendar-alt mr-2 icon-gradient"></i>
                        Schedule Management
                    </h3>
                    <a href="${pageContext.request.contextPath}/ViewSchedulesServlet" class="action-btn btn-primary">
                        <i class="fas fa-calendar-check mr-2"></i>
                        View All Schedules
                    </a>
                </div>
            </div>
        </div>
    </div>
                        
    <script>
        // User menu toggle
        const userMenuBtn = document.getElementById('userMenuBtn');
        const userMenu = document.getElementById('userMenu');
        
        userMenuBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            userMenu.classList.toggle('hidden');
        });
        
        // Close menu when clicking outside
        document.addEventListener('click', function(event) {
            if (!userMenuBtn.contains(event.target) && !userMenu.contains(event.target)) {
                userMenu.classList.add('hidden');
            }
        });
        
        // Add smooth scroll behavior
        document.documentElement.style.scrollBehavior = 'smooth';
        
        // Add loading animation
        window.addEventListener('load', function() {
            const cards = document.querySelectorAll('.stat-card, .action-card, .welcome-card');
            cards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                setTimeout(() => {
                    card.style.transition = 'all 0.6s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            });
        });
    </script>
</body>
</html>

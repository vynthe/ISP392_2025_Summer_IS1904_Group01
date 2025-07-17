<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Receptionist Dashboard</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <style>
            body {
                background: linear-gradient(to bottom, #f0f9f1, #e6f5e9);
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                font-family: 'Inter', sans-serif;
            }
            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 1.5rem;
            }
            .action-card {
                background-color: #ffffff;
                padding: 2rem;
                border-radius: 12px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
                max-width: 600px;
                margin: 1rem auto;
                border: 1px solid #e0e0e0;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }
            .action-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 6px 24px rgba(0, 0, 0, 0.1);
            }
            .action-card h1 {
                font-size: 1.875rem;
                font-weight: 700;
                margin-bottom: 1.5rem;
                text-align: center;
                color: #1a3c34;
            }
            .action-card h3 {
                font-size: 1.25rem;
                font-weight: 600;
                margin-bottom: 1rem;
                color: #1a3c34;
            }
            .action-btn {
                display: flex;
                align-items: center;
                justify-content: center;
                width: 100%;
                padding: 0.75rem;
                margin-bottom: 0.75rem;
                border-radius: 8px;
                text-align: center;
                color: white;
                text-decoration: none;
                background: linear-gradient(to right, #34c759, #2ca44e);
                border: none;
                transition: background 0.3s ease, transform 0.2s ease;
                font-weight: 500;
            }
            .action-btn:hover {
                background: linear-gradient(to right, #2ca44e, #248f3f);
                transform: translateY(-2px);
            }
            .action-btn i {
                margin-right: 0.5rem;
            }
            .search-form {
                max-width: 600px;
                margin: 0 auto 2rem;
                display: flex;
                gap: 0.5rem;
            }
            .search-form input {
                flex: 1;
                padding: 0.75rem;
                border: 1px solid #d1d5db;
                border-radius: 8px;
                font-size: 0.875rem;
                transition: border-color 0.3s ease;
            }
            .search-form input:focus {
                outline: none;
                border-color: #34c759;
                box-shadow: 0 0 0 3px rgba(52, 199, 89, 0.1);
            }
            .search-form button {
                padding: 0.75rem 1.5rem;
                background: linear-gradient(to right, #34c759, #2ca44e);
                color: white;
                border: none;
                border-radius: 8px;
                font-weight: 500;
                transition: background 0.3s ease;
            }
            .search-form button:hover {
                background: linear-gradient(to right, #2ca44e, #248f3f);
            }
            .user-menu-btn {
                background: linear-gradient(to right, #34c759, #2ca44e);
                color: white;
                width: 48px;
                height: 48px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: background 0.3s ease, transform 0.2s ease;
                border: none;
                cursor: pointer;
                font-size: 1.5rem;
            }
            .user-menu-btn:hover {
                background: linear-gradient(to right, #2ca44e, #248f3f);
                transform: scale(1.05);
            }
            .user-menu {
                background-color: #ffffff;
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                position: absolute;
                right: 0;
                top: 100%;
                margin-top: 0.5rem;
                min-width: 180px;
                z-index: 10;
                display: none;
                overflow: hidden;
            }
            .user-menu a {
                color: #1a3c34;
                padding: 0.75rem 1rem;
                display: block;
                transition: background-color 0.3s ease;
                font-size: 0.875rem;
            }
            .user-menu a:hover {
                background-color: #f0f9f1;
            }
            .user-menu.active {
                display: block;
            }
            @media (max-width: 640px) {
                .action-card {
                    padding: 1.5rem;
                }
                .action-card h1 {
                    font-size: 1.5rem;
                }
                .search-form {
                    flex-direction: column;
                }
                .search-form input, .search-form button {
                    width: 100%;
                }
            }
        </style>
    </head>
    <body>
        <div class="container">
            <!-- Header with User Menu -->
            <div class="flex justify-end mb-8 relative">
                <div class="relative">
                    <button id="userMenuBtn" class="user-menu-btn"><i class="fas fa-user"></i></button>
                    <div id="userMenu" class="user-menu">
                        <a href="${pageContext.request.contextPath}/UserProfileController">View Profile</a>
                        <a href="${pageContext.request.contextPath}/EditProfileUserController">Edit Profile</a>
                        <a href="${pageContext.request.contextPath}/ChangePasswordController">Change Password</a>
                        <a href="${pageContext.request.contextPath}/LogoutServlet" onclick="return confirm('Are you sure you want to sign out?')">Sign Out</a>
                    </div>
                </div>
            </div>
            <!-- Search Form -->
            <div class="mb-8">
                <form action="ViewEmployeeServlet" method="get" class="search-form">
                    <input type="text" name="keyword" class="form-control" placeholder="Search by name, email..." value="${keyword != null ? keyword : ''}">
                    <button type="submit">Search</button>
                </form>
            </div>
            <!-- Main Dashboard -->
            <div class="action-card">
                <h1>Receptionist Dashboard</h1>
                <div class="mb-6">
                    <h3><i class="fas fa-calendar-alt mr-2"></i>Booking Lists</h3>
                    <a href="${pageContext.request.contextPath}/BookingServlet" class="action-btn">
                        <i class="fas fa-calendar-check mr-2"></i>View Booking Lists
                    </a>
                </div>
                <div>
                    <h3><i class="fas fa-file-invoice mr-2"></i>Invoices</h3>
                    <button id="invoiceBtn" class="action-btn">
                        <i class="fas fa-file-invoice-dollar mr-2"></i>Manage Invoices
                    </button>
                </div>
            </div>
        </div>

        <!-- JavaScript for interactions -->
        <script>
            // Toggle user menu
            const userMenuBtn = document.getElementById('userMenuBtn');
            const userMenu = document.getElementById('userMenu');
            userMenuBtn.addEventListener('click', () => {
                userMenu.classList.toggle('active');
            });

            // Close menu when clicking outside
            document.addEventListener('click', (event) => {
                if (!userMenuBtn.contains(event.target) && !userMenu.contains(event.target)) {
                    userMenu.classList.remove('active');
                }
            });

            // Invoice button placeholder
            document.getElementById('invoiceBtn').addEventListener('click', () => {
                alert('The Invoice feature will be opened. (Not implemented yet)');
            });
        </script>
    </body>
</html>

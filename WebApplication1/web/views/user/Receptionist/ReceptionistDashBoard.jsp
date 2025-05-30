<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Receptionist Dashboard</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <style>
            body {
                background: #e6f5e9; /* Light green background */
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                align-items: center;
            }
            .action-card {
                background-color: #ffffff;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                max-width: 500px;
                width: 100%;
                margin: 0 auto;
                border: 2px solid #a8d5ba; /* Darker green border */
            }
            .action-card h1 {
                font-size: 1.5rem;
                font-weight: 600;
                margin-bottom: 16px;
                text-align: center;
                color: #2c3e50;
            }
            .action-card button {
                display: block;
                width: 100%;
                padding: 10px;
                margin-bottom: 8px;
                border-radius: 4px;
                text-align: center;
                color: white;
                text-decoration: none;
                background-color: #a8d5ba; /* Darker green buttons */
                border: none;
                transition: background-color 0.3s ease;
            }
            .action-card button:hover {
                background-color: #8ec2a1; /* Slightly darker green on hover */
            }
            .container {
                display: flex;
                flex-direction: column;
                align-items: center;
            }
            .user-menu-btn {
                background-color: #a8d5ba; /* Darker green for the user icon */
                color: white;
                width: 40px;
                height: 40px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: background-color 0.3s ease;
                border: none;
                cursor: pointer;
                font-size: 1.2rem;
            }
            .user-menu-btn:hover {
                background-color: #8ec2a1; /* Slightly darker green on hover */
            }
            .user-menu {
                background-color: #ffffff;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                position: absolute;
                right: 0;
                top: 100%;
                margin-top: 8px;
                min-width: 150px;
                z-index: 10;
                display: none;
            }
            .user-menu a {
                color: #2c3e50;
                padding: 10px 16px;
                display: block;
                transition: background-color 0.3s ease;
            }
            .user-menu a:hover {
                background-color: #e6f5e9; /* Light green hover background */
            }
            .user-menu.active {
                display: block;
            }
        </style>
    </head>
    <body>
        <div class="container mx-auto p-4">
            <!-- Header with User Menu -->
            <div class="flex justify-end mb-6 w-full relative">
                <div class="relative">
                    <button id="userMenuBtn" class="user-menu-btn">👤</button>
                    <div id="userMenu" class="user-menu">
                        <a href="${pageContext.request.contextPath}/UserProfileController" class="block">View Profile</a>
                        <a href="${pageContext.request.contextPath}/EditProfileUserController" class="block">Edit Profile</a>
                        <a href="${pageContext.request.contextPath}/LogoutServlet" class="block" onclick="return confirm('Are you sure you want to sign out?')">Sign Out</a>
                    </div>
                </div>
            </div>
            <!-- FORM TÌM KIẾM -->
            <div class="mb-3">
                <form action="ViewEmployeeServlet" method="get" class="d-flex search-form" style="max-width: 600px;">
                    <input type="text" name="keyword" class="form-control me-2" placeholder="Tìm theo tên, email..."
                           value="${keyword != null ? keyword : ''}">
                    <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                </form>
            </div>
            <!-- Main Dashboard -->
            <div class="action-card">
                <h1>Receptionist Dashboard</h1>
                <button id="viewBookingListsBtn">View Booking Lists</button>
                <button id="invoiceBtn">Invoice</button>
            </div>
        </div>

        <!-- JavaScript for interactions -->
        <script>
            // Toggle user menu
            const userMenuBtn = document.getElementById('userMenuBtn');
            const userMenu = document.getElementById('userMenu');
            userMenuBtn.addEventListener('click', function () {
                userMenu.classList.toggle('active');
            });

            // Close menu when clicking outside
            document.addEventListener('click', function (event) {
                if (!userMenuBtn.contains(event.target) && !userMenu.contains(event.target)) {
                    userMenu.classList.remove('active');
                }
            });

            // Button functions (placeholder)
            document.getElementById('viewBookingListsBtn').addEventListener('click', function () {
                alert('The View Booking Lists feature will be opened. (Not implemented yet)');
            });

            document.getElementById('invoiceBtn').addEventListener('click', function () {
                alert('The Invoice feature will be opened. (Not implemented yet)');
            });
        </script>
    </body>
</html>
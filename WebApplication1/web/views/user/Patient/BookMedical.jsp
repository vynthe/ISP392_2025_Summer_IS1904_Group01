<%-- 
    Document   : BookMedical
    Created on : Jun 17, 2025, 11:23:01 AM
    Author     : ASUS
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đặt Lịch Hẹn (Khách)</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <style>
            body {
                font-family: 'Inter', sans-serif;
            }
            .input-focus {
                transition: all 0.3s ease;
            }
            .input-focus:focus {
                border-color: #5C4033;
                box-shadow: 0 0 0 3px rgba(92, 64, 51, 0.1);
            }
            .btn-hover {
                transition: all 0.3s ease;
            }
            .btn-hover:hover {
                transform: translateY(-1px);
                box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
            }
            .animate-pulse-slow {
                animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
            }
            @keyframes pulse {
                0%, 100% {
                    opacity: 1;
                }
                50% {
                    opacity: 0.5;
                }
            }
        </style>
    </head>
    <body class="bg-gradient-to-br from-amber-50 to-brown-200 flex items-center justify-center min-h-screen">
        <div class="bg-white p-12 rounded-3xl shadow-2xl w-full max-w-md transform transition-all duration-500 hover:shadow-3xl">
            <div class="text-center mb-10">
                <h2 class="text-4xl font-extrabold text-gray-900 tracking-tight">Đặt Lịch Hẹn</h2>
                <p class="text-gray-400 mt-2" style="font-size:1rem;">Điền thông tin để đặt lịch hẹn nhanh chóng và dễ dàng</p>        </div>
                <% if (request.getAttribute("error") != null) { %>
            <div class="bg-red-50 border-l-4 border-red-600 text-red-800 p-5 rounded-xl mb-8 animate-fade-in" role="alert">
                <div class="flex items-center">
                    <svg class="w-6 h-6 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                    </svg>
                    <span><%= request.getAttribute("error") %></span>
                </div>
            </div>
            <% } %>
            <form action="book-appointment" method="post" class="space-y-8">
                <div>
                    <label for="fullName" class="block text-sm font-semibold text-gray-800 mb-2">Họ và tên</label>
                    <input type="text" id="fullName" name="fullName" required
                           class="input-focus block w-full px-5 py-4 border border-gray-300 rounded-xl shadow-sm placeholder-gray-400 focus:outline-none sm:text-base bg-amber-50"
                           placeholder="Nhập họ và tên">
                </div>
                <div>
                    <label for="phoneNumber" class="block text-sm font-semibold text-gray-800 mb-2">Số điện thoại</label>
                    <input type="tel" id="phoneNumber" name="phoneNumber" required
                           class="input-focus block w-full px-5 py-4 border border-gray-300 rounded-xl shadow-sm placeholder-gray-400 focus:outline-none sm:text-base bg-amber-50"
                           placeholder="Nhập số điện thoại" pattern="\d{10,11}">
                    <p class="text-xs text-gray-600 mt-2">Số điện thoại phải từ 10-11 chữ số</p>
                </div>
                <div>
                    <button type="submit"
                            class="btn-hover w-full flex justify-center py-4 px-6 border border-transparent rounded-xl shadow-md text-base font-semibold text-gray bg-brown-800 hover:bg-brown-900 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brown-700 animate-pulse-slow">
                        Đặt Lịch Hẹn
                    </button>   
                </div>
            </form>
            <div class="mt-8 text-center">
                <p class="text-sm text-gray-700">Bạn đã có tài khoản? <a href="login.jsp" class="text-brown-700 hover:text-brown-900 font-semibold transition-colors duration-300">Đăng nhập</a></p>
            </div>
        </div>
    </body>
</html>

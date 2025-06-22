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
    <title>Đăng Ký Tư Vấn Chuyên Gia</title>
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
        .error {
            border-color: #ef4444;
        }
    </style>
    <script>
        function validateForm() {
            let fullName = document.getElementById("fullName").value.trim();
            let phoneNumber = document.getElementById("phoneNumber").value.trim();
            let email = document.getElementById("email").value.trim();
            let serviceType = document.getElementById("serviceType").value;
            let errors = [];

            // Kiểm tra fullName (không chứa ký tự đặc biệt, tối đa 100 ký tự)
            if (!/^[a-zA-Z0-9\s]+$/.test(fullName) || fullName.length > 100) {
                errors.push("Họ và tên không được chứa ký tự đặc biệt và tối đa 100 ký tự.");
                document.getElementById("fullName").classList.add("error");
            } else {
                document.getElementById("fullName").classList.remove("error");
            }

            // Kiểm tra phoneNumber (chính xác 10 chữ số)
            if (!/^\d{10}$/.test(phoneNumber)) {
                errors.push("Số điện thoại phải là 10 chữ số.");
                document.getElementById("phoneNumber").classList.add("error");
            } else {
                document.getElementById("phoneNumber").classList.remove("error");
            }

            // Kiểm tra email (nếu có, phải là @gmail.com)
            if (email && !/^[a-zA-Z0-9._%+-]+@gmail\.com$/.test(email)) {
                errors.push("Email phải có đuôi @gmail.com (có thể để trống).");
                document.getElementById("email").classList.add("error");
            } else {
                document.getElementById("email").classList.remove("error");
            }

            // Kiểm tra serviceType
            if (!serviceType) {
                errors.push("Vui lòng chọn loại hình dịch vụ.");
                document.getElementById("serviceType").classList.add("error");
            } else {
                document.getElementById("serviceType").classList.remove("error");
            }

            // Hiển thị lỗi nếu có
            if (errors.length > 0) {
                alert(errors.join("\n"));
                return false;
            }
            return true;
        }
    </script>
</head>
<body class="bg-gradient-to-br from-amber-50 to-brown-200 flex items-center justify-center min-h-screen">
    <div class="bg-white p-12 rounded-3xl shadow-2xl w-full max-w-md transform transition-all duration-500 hover:shadow-3xl">
        <div class="text-center mb-10">
            <h2 class="text-4xl font-extrabold text-gray-900 tracking-tight">ĐĂNG KÝ TƯ VẤN CHUYÊN GIA</h2>
            <p class="text-gray-400 mt-2" style="font-size:1rem;">Điền thông tin để nhận tư vấn nhanh chóng và hiệu quả</p>        
        </div>
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
        <form action="BookAppointmentGuestServlet" method="post" onsubmit="return validateForm()" class="space-y-8">
            <div>
                <label for="fullName" class="block text-sm font-semibold text-gray-800 mb-2">(*) Họ và tên:</label>
                <input type="text" id="fullName" name="fullName" required
                       class="input-focus block w-full px-5 py-4 border border-gray-300 rounded-xl shadow-sm placeholder-gray-400 focus:outline-none sm:text-base bg-amber-50"
                       placeholder="Nhập họ và tên">
            </div>
            <div>
                <label for="phoneNumber" class="block text-sm font-semibold text-gray-800 mb-2">(*) Số điện thoại:</label>
                <input type="tel" id="phoneNumber" name="phoneNumber" required
                       class="input-focus block w-full px-5 py-4 border border-gray-300 rounded-xl shadow-sm placeholder-gray-400 focus:outline-none sm:text-base bg-amber-50"
                       placeholder="Nhập số điện thoại" pattern="\d{10}">
                <p class="text-xs text-gray-600 mt-2">Số điện thoại phải là 10 chữ số</p>
            </div>
            <div>
                <label for="email" class="block text-sm font-semibold text-gray-800 mb-2">Email:</label>
                <input type="email" id="email" name="email"
                       class="input-focus block w-full px-5 py-4 border border-gray-300 rounded-xl shadow-sm placeholder-gray-400 focus:outline-none sm:text-base bg-amber-50"
                       placeholder="Nhập email">
                <p class="text-xs text-gray-600 mt-2">Email phải có đuôi @gmail.com (có thể để trống)</p>
            </div>
            <div>
                <label for="serviceType" class="block text-sm font-semibold text-gray-800 mb-2">(*) Loại hình dịch vụ quan tâm:</label>
                <select id="serviceType" name="serviceType" required class="input-focus block w-full px-5 py-4 border border-gray-300 rounded-xl shadow-sm placeholder-gray-400 focus:outline-none sm:text-base bg-amber-50">
                    <option value="">Chọn loại hình dịch vụ</option>
                    <option value="implant">Cấy ghép Implant</option>
                    <option value="teeth_cleaning">Chỉnh nha mắc cài</option>
                    <option value="dental_treatment">Nha khoa trẻ em</option>
                    <option value="teeth_whitening">Phẫu thuật chỉnh hình hàm</option>
                    <option value="general_checkup">Nha khoa thẩm mỹ</option>
                    <option value="root_canal">Nhổ răng khôn</option>
                </select>
            </div>
            <div>
                <button type="submit"
                        class="btn-hover w-full flex justify-center py-4 px-6 border border-transparent rounded-xl shadow-md text-base font-semibold text-white bg-green-700 hover:bg-green-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-700 animate-pulse-slow">
                    ĐĂNG KÝ
                </button>   
            </div>
        </form>
        <div class="mt-8 text-center">
            <p class="text-sm text-gray-700">Bạn đã có tài khoản? <a href="login.jsp" class="text-brown-700 hover:text-brown-900 font-semibold transition-colors duration-300">Đăng nhập</a></p>
        </div>
    </div>
</body>
</html>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.entity.Admins"%> 
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa hồ sơ Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <style>
        @keyframes slideIn {
            from { transform: translateY(-20px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        .modal-slide-in {
            animation: slideIn 0.3s ease-out;
        }
        .input-focus:focus {
            box-shadow: 0 0 0 3px rgba(34, 197, 94, 0.2);
        }
        .btn-hover:hover {
            transform: translateY(-1px);
        }
    </style>
</head>
<body class="bg-gray-50 flex items-center justify-center min-h-screen p-4">
    <div class="bg-white rounded-xl w-full max-w-lg p-6 modal-slide-in relative shadow-lg">
        <div class="flex justify-between items-center mb-4">
            <h2 class="text-xl font-semibold text-gray-800">Cập nhật hồ sơ Admin</h2>
            <a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp" class="text-gray-500 hover:text-green-600 transition">
                <i class="fas fa-times"></i>
            </a>
        </div>

        <c:if test="${not empty success}">
            <div class="bg-green-50 text-green-700 p-2 rounded-md mb-4 text-xs flex items-center">
                <i class="fas fa-check-circle mr-2"></i> ${success}
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="bg-red-50 text-red-700 p-2 rounded-md mb-4 text-xs flex items-center">
                <i class="fas fa-exclamation-circle mr-2"></i> ${error}
            </div>
        </c:if>

        <%
            Admins admin = (Admins) session.getAttribute("admin");
            if (admin == null) {
                response.sendRedirect(request.getContextPath() + "/views/admin/login.jsp");
                return;
            }
            request.setAttribute("admin", admin);
        %>

        <form action="EditProfileAdminController" method="post" class="needs-validation space-y-4" novalidate>
            <div>
                <label for="username" class="block text-xs font-medium text-gray-600 mb-1">Tên đăng nhập</label>
                <div class="relative">
                    <input type="text" id="username" name="username" value="${admin.username}" 
                           placeholder="Tên đăng nhập" 
                           class="w-full px-3 py-2 rounded-md border border-gray-200 bg-white text-sm text-gray-800 input-focus focus:border-green-500 transition"
                           required>
                    <i class="fas fa-user absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 text-xs"></i>
                </div>
                <div class="invalid-feedback text-red-500 text-xs mt-1 hidden">Vui lòng nhập tên đăng nhập.</div>
            </div>

            <div>
                <label for="fullName" class="block text-xs font-medium text-gray-600 mb-1">Họ tên</label>
                <div class="relative">
                    <input type="text" id="fullName" name="fullName" value="${admin.fullName}" 
                           placeholder="Họ tên" 
                           class="w-full px-3 py-2 rounded-md border border-gray-200 bg-white text-sm text-gray-800 input-focus focus:border-green-500 transition"
                           required>
                    <i class="fas fa-user absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 text-xs"></i>
                </div>
                <div class="invalid-feedback text-red-500 text-xs mt-1 hidden">Vui lòng nhập họ tên.</div>
            </div>

            <div>
                <label for="email" class="block text-xs font-medium text-gray-600 mb-1">Email</label>
                <div class="relative">
                    <input type="email" id="email" name="email" value="${admin.email}" 
                           placeholder="Email" 
                           class="w-full px-3 py-2 rounded-md border border-gray-200 bg-white text-sm text-gray-800 input-focus focus:border-green-500 transition"
                           required>
                    <i class="fas fa-envelope absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 text-xs"></i>
                </div>
                <div class="invalid-feedback text-red-500 text-xs mt-1 hidden">Vui lòng nhập email hợp lệ.</div>
            </div>

            <div class="flex space-x-2 pt-2">
                <button type="submit" 
                        class="flex-1 py-2 bg-green-500 text-white rounded-md text-sm font-medium btn-hover hover:bg-green-600 transition duration-200">
                    <i class="fas fa-save mr-1"></i> Lưu
                </button>
                <a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp" 
                   class="flex-1 py-2 bg-gray-200 text-gray-700 text-center rounded-md text-sm font-medium btn-hover hover:bg-gray-300 transition duration-200">
                    <i class="fas fa-arrow-left mr-1"></i> Quay lại
                </a>
            </div>
        </form>
    </div>

    <script>
        (function () {
            'use strict';
            const forms = document.querySelectorAll('.needs-validation');
            Array.from(forms).forEach(form => {
                form.addEventListener('submit', event => {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                    form.querySelectorAll('input').forEach(input => {
                        const feedback = input.parentElement.nextElementSibling;
                        if (!input.checkValidity()) {
                            feedback.classList.remove('hidden');
                        } else {
                            feedback.classList.add('hidden');
                        }
                    });
                }, false);
            });
        })();
    </script>
</body>
</html>
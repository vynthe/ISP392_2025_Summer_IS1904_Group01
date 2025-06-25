<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hoàn Thiện Hồ Sơ - Patient</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
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
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 20"><defs><radialGradient id="a" cx="50%" cy="50%"><stop offset="0%" stop-color="rgba(255,255,255,.1)"/><stop offset="100%" stop-color="rgba(255,255,255,0)"/></radialGradient></defs><circle fill="url(%23a)" cx="10" cy="10" r="10"/><circle fill="url(%23a)" cx="30" cy="5" r="8"/><circle fill="url(%23a)" cx="60" cy="15" r="6"/><circle fill="url(%23a)" cx="80" cy="10" r="12"/></svg>');
            animation: float 20s ease-in-out infinite;
            pointer-events: none;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(180deg); }
        }

        .container {
            max-width: 500px;
            width: 100%;
            margin: 20px;
            position: relative;
            z-index: 10;
        }

        .form-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            padding: 40px;
            box-shadow: 
                0 20px 40px rgba(0, 0, 0, 0.1),
                0 0 0 1px rgba(255, 255, 255, 0.2);
            position: relative;
            overflow: hidden;
            transform: translateY(0);
            transition: all 0.3s ease;
        }

        .form-container:hover {
            transform: translateY(-2px);
            box-shadow: 
                0 25px 50px rgba(0, 0, 0, 0.15),
                0 0 0 1px rgba(255, 255, 255, 0.3);
        }

        .form-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2, #667eea);
            background-size: 200% 100%;
            animation: shimmer 3s ease-in-out infinite;
        }

        @keyframes shimmer {
            0% { background-position: -200% 0; }
            100% { background-position: 200% 0; }
        }

        .header {
            text-align: center;
            margin-bottom: 35px;
        }

        .header-icon {
            background: linear-gradient(135deg, #667eea, #764ba2);
            width: 80px;
            height: 80px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
            position: relative;
        }

        .header-icon::before {
            content: '';
            position: absolute;
            top: -2px;
            left: -2px;
            right: -2px;
            bottom: -2px;
            background: linear-gradient(45deg, #667eea, #764ba2, #667eea);
            border-radius: 50%;
            z-index: -1;
            animation: rotate 4s linear infinite;
        }

        @keyframes rotate {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .header-icon i {
            font-size: 32px;
            color: white;
        }

        h2 {
            color: #2c3e50;
            font-size: 28px;
            font-weight: 700;
            margin: 0;
            letter-spacing: -0.5px;
        }

        .subtitle {
            color: #6c757d;
            font-size: 14px;
            margin-top: 8px;
        }

        .form-group {
            margin-bottom: 25px;
            position: relative;
        }

        .form-label {
            display: block;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 8px;
            font-size: 14px;
            letter-spacing: 0.5px;
        }

        .input-group {
            position: relative;
        }

        .input-icon {
            position: absolute;
            left: 18px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
            z-index: 2;
            transition: color 0.3s ease;
        }

        .form-control,
        .form-select {
            width: 100%;
            padding: 16px 20px 16px 50px;
            border: 2px solid #e9ecef;
            border-radius: 16px;
            background: rgba(255, 255, 255, 0.8);
            font-size: 15px;
            color: #2c3e50;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
        }

        .form-control:focus,
        .form-select:focus {
            outline: none;
            border-color: #667eea;
            background: rgba(255, 255, 255, 0.95);
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
            transform: translateY(-2px);
        }

        .form-control:focus + .input-icon,
        .form-select:focus + .input-icon {
            color: #667eea;
        }

        .form-control::placeholder {
            color: #adb5bd;
            font-style: italic;
        }

        .btn-submit {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 16px;
            color: white;
            font-weight: 600;
            font-size: 16px;
            letter-spacing: 0.5px;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            margin-top: 10px;
        }

        .btn-submit::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 15px 35px rgba(102, 126, 234, 0.4);
        }

        .btn-submit:hover::before {
            left: 100%;
        }

        .btn-submit:active {
            transform: translateY(0);
        }

        .alert-danger {
            background: linear-gradient(135deg, #ff6b6b, #ee5a52);
            color: white;
            border: none;
            border-radius: 12px;
            padding: 15px 20px;
            margin-top: 20px;
            font-weight: 500;
            box-shadow: 0 8px 25px rgba(255, 107, 107, 0.3);
            animation: slideIn 0.3s ease;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .floating-shapes {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            pointer-events: none;
            overflow: hidden;
        }

        .floating-shapes::before,
        .floating-shapes::after {
            content: '';
            position: absolute;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.1);
            animation: float-shapes 15s ease-in-out infinite;
        }

        .floating-shapes::before {
            width: 100px;
            height: 100px;
            top: 20%;
            left: -50px;
            animation-delay: 0s;
        }

        .floating-shapes::after {
            width: 60px;
            height: 60px;
            bottom: 20%;
            right: -30px;
            animation-delay: 7s;
        }

        @keyframes float-shapes {
            0%, 100% {
                transform: translateY(0px) rotate(0deg);
                opacity: 0.1;
            }
            50% {
                transform: translateY(-50px) rotate(180deg);
                opacity: 0.3;
            }
        }

        @media (max-width: 576px) {
            .form-container {
                padding: 30px 25px;
                margin: 15px;
            }
            
            .header-icon {
                width: 60px;
                height: 60px;
            }
            
            .header-icon i {
                font-size: 24px;
            }
            
            h2 {
                font-size: 24px;
            }
        }
    </style>
    <script>
        function trimOnBlur(event) {
            let input = event.target;
            input.value = input.value.trim();
        }

        function trimAllInputsOnSubmit(event) {
            const form = event.target;
            const textInputs = form.querySelectorAll('input[type="text"], input[type="tel"]');
            textInputs.forEach(input => {
                input.value = input.value.trim();
            });
        }

        // Add smooth animations
        document.addEventListener('DOMContentLoaded', function() {
            const formGroups = document.querySelectorAll('.form-group');
            formGroups.forEach((group, index) => {
                group.style.opacity = '0';
                group.style.transform = 'translateY(20px)';
                setTimeout(() => {
                    group.style.transition = 'all 0.5s ease';
                    group.style.opacity = '1';
                    group.style.transform = 'translateY(0)';
                }, index * 100);
            });
        });
    </script>
</head>
<body>
    <div class="floating-shapes"></div>
    
    <div class="container">
        <div class="form-container">
            <div class="header">
                <div class="header-icon">
                    <i class="fas fa-user-injured"></i>
                </div>
                <h2>Hoàn Thiện Hồ Sơ</h2>
                <p class="subtitle">Bệnh nhân - Thông tin cá nhân</p>
            </div>

            <form action="${pageContext.request.contextPath}/CompleteProfileController" method="post" onsubmit="trimAllInputsOnSubmit(event)">
                <input type="hidden" name="userID" value="${sessionScope.user.userID}">

                <div class="form-group">
                    <label for="fullName" class="form-label">Họ và tên</label>
                    <div class="input-group">
                        <input type="text" class="form-control" id="fullName" name="fullName" value="${fullName}" 
                               placeholder="Nhập họ và tên đầy đủ" maxlength="100" onblur="trimOnBlur(event)" required>
                        <i class="input-icon fas fa-user"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label for="gender" class="form-label">Giới tính</label>
                    <div class="input-group">
                        <select class="form-select" id="gender" name="gender" required>
                            <option value="" disabled ${empty gender ? 'selected' : ''}>Chọn giới tính</option>
                            <option value="Nam" ${gender == 'Nam' ? 'selected' : ''}>Nam</option>
                            <option value="Nữ" ${gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                            <option value="Khác" ${gender == 'Khác' ? 'selected' : ''}>Khác</option>
                        </select>
                        <i class="input-icon fas fa-venus-mars"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label for="dob" class="form-label">Ngày sinh</label>
                    <div class="input-group">
                        <input type="date" class="form-control" id="dob" name="dob" value="${dob}" required>
                        <i class="input-icon fas fa-calendar-alt"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label for="phone" class="form-label">Số điện thoại</label>
                    <div class="input-group">
                        <input type="tel" class="form-control" id="phone" name="phone" value="${phone}" 
                               placeholder="Số điện thoại (10 chữ số)" maxlength="10" onblur="trimOnBlur(event)" required>
                        <i class="input-icon fas fa-phone"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label for="address" class="form-label">Địa chỉ</label>
                    <div class="input-group">
                        <input type="text" class="form-control" id="address" name="address" value="${address}" 
                               placeholder="Nhập địa chỉ chi tiết" maxlength="255" onblur="trimOnBlur(event)" required>
                        <i class="input-icon fas fa-map-marker-alt"></i>
                    </div>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>${error}
                    </div>
                </c:if>

                <button type="submit" class="btn-submit">
                    <i class="fas fa-check me-2"></i>Hoàn thiện hồ sơ
                </button>
            </form>
        </div>
    </div>
</body>
</html>
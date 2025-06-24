<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chỉnh sửa hồ sơ Bác Sĩ Y Tá</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .header {
            text-align: center;
            margin-bottom: 30px;
            color: white;
        }
        
        .header h1 {
            font-size: 2.5rem;
            margin-bottom: 10px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        
        .header .subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
        }
        
        .form-container {
            background: white;
            max-width: 700px;
            margin: 0 auto;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.15);
            overflow: hidden;
        }
        
        .form-header {
            background: linear-gradient(45deg, #2563eb, #1d4ed8);
            color: white;
            padding: 25px;
            text-align: center;
        }
        
        .form-header h2 {
            font-size: 1.8rem;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
        }
        
        .form-header .subtitle {
            opacity: 0.9;
            font-size: 0.95rem;
        }
        
        .form-body {
            padding: 35px;
        }
        
        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group.full-width {
            grid-column: 1 / -1;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #374151;
            font-size: 0.95rem;
        }
        
        label i {
            margin-right: 8px;
            color: #2563eb;
            width: 16px;
        }
        
        input, select {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: #fafafa;
        }
        
        input:focus, select:focus {
            outline: none;
            border-color: #2563eb;
            background: white;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }
        
        select {
            cursor: pointer;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='m6 8 4 4 4-4'/%3e%3c/svg%3e");
            background-position: right 12px center;
            background-repeat: no-repeat;
            background-size: 16px;
            padding-right: 40px;
        }
        
        .message {
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 25px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .message.success {
            background: #dcfce7;
            color: #166534;
            border-left: 4px solid #16a34a;
        }
        
        .message.error {
            background: #fef2f2;
            color: #dc2626;
            border-left: 4px solid #ef4444;
        }
        
        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }
        
        .btn {
            flex: 1;
            padding: 14px 24px;
            border: none;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            text-decoration: none;
        }
        
        .btn-primary {
            background: linear-gradient(45deg, #2563eb, #1d4ed8);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(37, 99, 235, 0.3);
        }
        
        .btn-secondary {
            background: #f3f4f6;
            color: #374151;
            border: 1px solid #d1d5db;
        }
        
        .btn-secondary:hover {
            background: #e5e7eb;
            transform: translateY(-1px);
        }
        
        .medical-icon {
            position: absolute;
            top: 20px;
            right: 20px;
            font-size: 3rem;
            color: rgba(255,255,255,0.2);
        }
        
        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
            
            .button-group {
                flex-direction: column;
            }
            
            .header h1 {
                font-size: 2rem;
            }
            
            .form-body {
                padding: 25px;
            }
        }
        
        /* Animation cho form */
        .form-container {
            animation: slideUp 0.6s ease-out;
        }
        
        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        </style>
    </head>
    <body>
        <div class="header">
            <h1><i class="fas fa-hospital-user"></i> Hệ Thống Quản Lý Y Tế</h1>
            <div class="subtitle">Nền tảng quản lý thông tin chuyên nghiệp</div>
        </div>
        
        <div class="form-container">
            <div class="form-header">
                <i class="fas fa-stethoscope medical-icon"></i>
                <h2>
                    <i class="fas fa-user-md"></i>
                    Cập Nhật Hồ Sơ Y Tế
                </h2>
                <div class="subtitle">Vui lòng điền đầy đủ thông tin để cập nhật hồ sơ</div>
            </div>
            
            <div class="form-body">
                <c:if test="${not empty success}">
                    <div class="message success">
                        <i class="fas fa-check-circle"></i>
                        ${success}
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="message error">
                        <i class="fas fa-exclamation-circle"></i>
                        ${error}
                    </div>
                </c:if>
                
                <form action="${pageContext.request.contextPath}/EditProfileUserController" method="post">
                    <input type="hidden" name="userID" value="${sessionScope.user.userID}">
                    
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="username">
                                <i class="fas fa-user"></i>Tên đăng nhập:
                            </label>
                            <input type="text" id="username" name="username" value="${sessionScope.user.username}" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="dob">
                                <i class="fas fa-calendar"></i>Ngày sinh:
                            </label>
                            <input type="date" id="dob" name="dob" value="${sessionScope.user.dob}" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="gender">
                                <i class="fas fa-venus-mars"></i>Giới tính:
                            </label>
                            <select id="gender" name="gender" required>
                                <option value="">-- Chọn giới tính --</option>
                                <option value="Male" ${sessionScope.user.gender == 'Male' ? 'selected' : ''}>Nam</option>
                                <option value="Female" ${sessionScope.user.gender == 'Female' ? 'selected' : ''}>Nữ</option>
                                <option value="Other" ${sessionScope.user.gender == 'Other' ? 'selected' : ''}>Khác</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="phone">
                                <i class="fas fa-phone"></i>Số điện thoại:
                            </label>
                            <input type="tel" id="phone" name="phone" value="${sessionScope.user.phone}" required>
                        </div>
                        
                        <div class="form-group full-width">
                            <label for="email">
                                <i class="fas fa-envelope"></i>Email:
                            </label>
                            <input type="email" id="email" name="email" value="${sessionScope.user.email}" required>
                        </div>
                        
                        <div class="form-group full-width">
                            <label for="address">
                                <i class="fas fa-map-marker-alt"></i>Địa chỉ:
                            </label>
                            <input type="text" id="address" name="address" value="${sessionScope.user.address}" required>
                        </div>
                        
                        <div class="form-group full-width">
                            <label for="specialization">
                                <i class="fas fa-graduation-cap"></i>Trình độ chuyên môn:
                            </label>
                            <select id="specialization" name="specialization" required>
                                <option value="">-- Chọn trình độ chuyên môn --</option>
                                <option value="Chuyên Khoa" ${sessionScope.user.specialization == 'Chuyên Khoa' ? 'selected' : ''}>Bác sĩ Chuyên khoa</option>
                                <option value="Thạc Sỹ" ${sessionScope.user.specialization == 'Thạc Sỹ' ? 'selected' : ''}>Thạc sĩ Y khoa</option>
                                <option value="Tiến Sỹ" ${sessionScope.user.specialization == 'Tiến Sỹ' ? 'selected' : ''}>Tiến sĩ Y khoa</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="button-group">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i>
                            Cập nhật hồ sơ
                        </button>
                        <a href="${pageContext.request.contextPath}/views/user/DoctorNurse/EmployeeDashBoard.jsp" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i>
                            Quay lại trang chủ
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </body>
</html>
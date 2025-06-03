<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sửa Thông Tin Nhân Viên</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <style>
            /* Reset default styles */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', Arial, sans-serif;
            }

            body {
                background: linear-gradient(135deg, #fff3e0, #ffe082);
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                padding: 20px;
            }

            .container {
                background: #ffffff;
                padding: 40px;
                border-radius: 15px;
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
                width: 100%;
                max-width: 550px;
                position: relative;
                overflow: hidden;
            }

            .container::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 5px;
                background: linear-gradient(to right, #f57f17, #ffca28);
            }

            h2 {
                text-align: center;
                color: #2c3e50;
                margin-bottom: 30px;
                font-size: 28px;
                font-weight: 600;
                letter-spacing: 1px;
            }

            .form-group, .mb-3, .input-box {
                margin-bottom: 20px;
                position: relative;
            }

            .form-group label, .mb-3 label {
                display: block;
                font-weight: 500;
                margin-bottom: 8px;
                color: #34495e;
                font-size: 15px;
            }

            .form-group input[type="text"],
            .form-group input[type="date"],
            .form-group select,
            .input-box input,
            .input-box select {
                width: 100%;
                padding: 12px 40px 12px 15px;
                border: 1px solid #dfe6e9;
                border-radius: 8px;
                font-size: 14px;
                background: #f9fafb;
                transition: all 0.3s ease;
            }

            .form-group input:focus,
            .form-group select:focus,
            .input-box input:focus,
            .input-box select:focus {
                border-color: #f57f17;
                background: #ffffff;
                box-shadow: 0 0 5px rgba(245, 127, 23, 0.2);
                outline: none;
            }

            .input-box i {
                position: absolute;
                right: 15px;
                top: 50%;
                transform: translateY(-50%);
                color: #7f8c8d;
                font-size: 16px;
            }

            .form-group input[type="submit"],
            .form-group .btn-back {
                width: 100%;
                padding: 14px;
                background: linear-gradient(to right, #f57f17, #ffca28);
                color: white;
                border: none;
                border-radius: 8px;
                font-size: 16px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s ease;
                text-transform: uppercase;
                letter-spacing: 1px;
                text-decoration: none;
                text-align: center;
                display: block;
            }

            .form-group input[type="submit"]:hover,
            .form-group .btn-back:hover {
                background: linear-gradient(to right, #e65100, #ffb300);
                box-shadow: 0 5px 15px rgba(245, 127, 23, 0.3);
            }

            .error {
                background-color: #ffebee;
                color: #c62828;
                padding: 12px;
                border-radius: 8px;
                margin-bottom: 20px;
                text-align: center;
                font-size: 14px;
                border-left: 4px solid #c62828;
            }

            select option[disabled] {
                color: #b0bec5;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Sửa Thông Tin Nhân Viên</h2>
            <c:if test="${not empty error}">
                <div class="error">${error}</div>
            </c:if>
            <c:if test="${empty employee}">
                <div class="error">Không tìm thấy nhân viên để chỉnh sửa.</div>
                <div class="form-group">
                    <a href="${pageContext.request.contextPath}/ViewEmployeeServlet" class="btn-back">Quay lại</a>
                </div>
            </c:if>
            <c:if test="${not empty employee}">
                <form action="${pageContext.request.contextPath}/EditEmployeeServlet" method="post" id="employeeForm" class="needs-validation" novalidate>
                    <input type="hidden" name="userID" value="${employee.userID}">
                    <div class="form-group">
                        <label for="fullName">Họ và tên:</label>
                        <div class="input-box">
                            <input type="text" id="fullName" name="fullName" 
                                   value="${not empty formFullName ? formFullName : (not empty employee.fullName ? employee.fullName : '')}" 
                                   placeholder="Nhập họ và tên" required>
                            <i class="fas fa-user"></i>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="gender">Giới tính:</label>
                        <div class="input-box">
                            <select id="gender" name="gender" required>
                                <option value="" disabled ${empty formGender && empty employee.gender ? 'selected' : ''}>Chọn giới tính</option>
                                <option value="Nam" ${formGender == 'Nam' || (empty formGender && employee.gender == 'Nam') ? 'selected' : ''}>Nam</option>
                                <option value="Nữ" ${formGender == 'Nữ' || (empty formGender && employee.gender == 'Nữ') ? 'selected' : ''}>Nữ</option>
                            </select>
                            <i class="fas fa-venus-mars"></i>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="specialization">Chuyên khoa:</label>
                        <div class="input-box">
                            <select id="specialization" name="specialization" required>
                                <option value="" disabled ${empty formSpecialization && empty employee.specialization ? 'selected' : ''}>Chọn chuyên khoa</option>
                                <option value="Chuyên môn" ${formSpecialization == 'Chuyên môn' || (empty formSpecialization && employee.specialization == 'Chuyên môn') ? 'selected' : ''}>Chuyên môn</option>
                                <option value="Thạc sĩ" ${formSpecialization == 'Thạc sĩ' || (empty formSpecialization && employee.specialization == 'Thạc sĩ') ? 'selected' : ''}>Thạc sĩ</option>
                                <option value="Tiến sĩ" ${formSpecialization == 'Tiến sĩ' || (empty formSpecialization && employee.specialization == 'Tiến sĩ') ? 'selected' : ''}>Tiến sĩ</option>
                            </select>
                            <i class="fas fa-stethoscope"></i>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="dob">Ngày sinh:</label>
                        <div class="input-box">
                            <input type="date" id="dob" name="dob" 
                                   value="${not empty formDob ? formDob : (not empty employee.dob ? employee.dob : '')}" 
                                   placeholder="Nhập ngày sinh" required>
                            <i class="fas fa-calendar-alt"></i>
                        </div>
                    </div>
                    <div class="form-group">
                        <input type="submit" value="Lưu">
                    </div>
                    <div class="form-group">
                        <a href="${pageContext.request.contextPath}/ViewEmployeeServlet" class="btn-back">Hủy</a>
                    </div>
                </form>
            </c:if>
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
                    }, false);
                });
            })();
        </script>
    </body>
</html>
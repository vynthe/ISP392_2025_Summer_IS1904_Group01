<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sửa thông tin bệnh nhân</title>
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
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
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
            background: linear-gradient(to right, #1976D2, #42A5F5);
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
        .form-group input[type="tel"],
        .form-group input[type="date"],
        .form-group select {
            width: 100%;
            padding: 12px 40px 12px 15px;
            border: 1px solid #dfe6e9;
            border-radius: 8px;
            font-size: 14px;
            background: #f9fafb;
            transition: all 0.3s ease;
        }

        .form-group input:focus,
        .form-group select:focus {
            border-color: #1976D2;
            background: #ffffff;
            box-shadow: 0 0 5px rgba(25, 118, 210, 0.2);
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
            background: linear-gradient(to right, #1976D2, #42A5F5);
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
            background: linear-gradient(to right, #1565C0, #2196F3);
            box-shadow: 0 5px 15px rgba(25, 118, 210, 0.3);
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

        .needs-validation.was-validated .form-control:invalid,
        .needs-validation.was-validated .form-select:invalid {
            border-color: #c62828;
            background-image: none;
        }

        .needs-validation.was-validated .form-control:valid,
        .needs-validation.was-validated .form-select:valid {
            border-color: #1976D2;
        }

        .invalid-feedback {
            display: none;
            color: #c62828;
            font-size: 12px;
            margin-top: 5px;
        }

        .was-validated .form-control:invalid ~ .invalid-feedback,
        .was-validated .form-select:invalid ~ .invalid-feedback {
            display: block;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Sửa thông tin bệnh nhân</h2>
    <c:if test="${not empty error}">
        <div class="error">${error}</div>
    </c:if>
    <c:if test="${empty patient}">
        <div class="error">Không tìm thấy bệnh nhân để chỉnh sửa.</div>
        <div class="form-group">
            <a href="${pageContext.request.contextPath}/ViewPatientServlet" class="btn-back">Quay lại</a>
        </div>
    </c:if>
    <c:if test="${not empty patient}">
        <form action="${pageContext.request.contextPath}/UpdatePatientServlet" method="post" class="needs-validation" novalidate>
            <input type="hidden" name="userID" value="${patient.userID}">
            <div class="form-group">
                <label for="fullName">Họ và tên</label>
                <div class="input-box">
                    <input type="text" id="fullName" name="fullName"
                           value="${not empty formFullName ? formFullName : (not empty patient.fullName ? patient.fullName : '')}"
                           placeholder="Nhập họ và tên" required pattern="[A-Za-z\s]+">
                    <i class="fas fa-user"></i>
                </div>
                <div class="invalid-feedback">Họ và tên chỉ được chứa chữ cái và dấu cách.</div>
            </div>
            <div class="form-group">
                <label for="gender">Giới tính</label>
                <div class="input-box">
                    <select id="gender" name="gender" required>
                        <option value="" disabled ${empty formGender && empty patient.gender ? 'selected' : ''}>Chọn giới tính</option>
                        <option value="Nam" ${formGender == 'Nam' || (empty formGender && patient.gender == 'Nam') ? 'selected' : ''}>Nam</option>
                        <option value="Nữ" ${formGender == 'Nữ' || (empty formGender && patient.gender == 'Nữ') ? 'selected' : ''}>Nữ</option>
                    </select>
                    <i class="fas fa-venus-mars"></i>
                </div>
                <div class="invalid-feedback">Vui lòng chọn giới tính.</div>
            </div>
            <div class="form-group">
                <label for="dob">Ngày sinh</label>
                <div class="input-box">
                    <input type="date" id="dob" name="dob"
                           value="${not empty formDob ? formDob : (not empty patient.dob ? patient.dob : '')}"
                           required>
                    <i class="fas fa-calendar-alt"></i>
                </div>
                <div class="invalid-feedback">Vui lòng nhập ngày sinh.</div>
            </div>
            <div class="form-group">
                <label for="phone">Số điện thoại</label>
                <div class="input-box">
                    <input type="tel" id="phone" name="phone"
                           value="${not empty formPhone ? formPhone : (not empty patient.phone ? patient.phone : '')}"
                           placeholder="Nhập số điện thoại" required pattern="\d{10}">
                    <i class="fas fa-phone"></i>
                </div>
                <div class="invalid-feedback">Số điện thoại phải là 10 chữ số.</div>
            </div>
            <div class="form-group">
                <label for="address">Địa chỉ</label>
                <div class="input-box">
                    <input type="text" id="address" name="address"
                           value="${not empty formAddress ? formAddress : (not empty patient.address ? patient.address : '')}"
                           placeholder="Nhập địa chỉ" required>
                    <i class="fas fa-map-marker-alt"></i>
                </div>
                <div class="invalid-feedback">Vui lòng nhập địa chỉ.</div>
            </div>
            <div class="form-group">
                <label for="status">Trạng thái</label>
                <div class="input-box">
                    <select id="status" name="status" required>
                        <option value="" disabled ${empty formStatus && empty patient.status ? 'selected' : ''}>Chọn trạng thái</option>
                        <option value="Active" ${formStatus == 'Active' || (empty formStatus && patient.status == 'Active') ? 'selected' : ''}>Active</option>
                        <option value="Inactive" ${formStatus == 'Inactive' || (empty formStatus && patient.status == 'Inactive') ? 'selected' : ''}>Inactive</option>
                    </select>
                    <i class="fas fa-toggle-on"></i>
                </div>
                <div class="invalid-feedback">Vui lòng chọn trạng thái.</div>
            </div>
            <div class="form-group">
                <input type="submit" value="Lưu">
            </div>
            <div class="form-group">
                <a href="${pageContext.request.contextPath}/ViewPatientServlet" class="btn-back">Quay lại</a>
            </div>
        </form>
    </c:if>
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
</div>
</body>
</html>
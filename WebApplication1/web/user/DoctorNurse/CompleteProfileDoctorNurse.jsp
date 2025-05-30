<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hoàn Thiện Hồ Sơ - Bác Sĩ/Y Tá</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #fff3e0, #ffe082);
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            padding: 0;
            position: relative;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .container-wrapper {
            position: relative;
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .form-container {
            background: #ffffff;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
            margin: 40px 0;
            position: relative;
            overflow: hidden;
            z-index: 1;
            width: 100%;
            max-width: 600px;
        }

        .form-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(to right, #F9A825, #FFCA28);
        }

        .full-width-bottom-border {
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(to right, #F9A825, #FFCA28);
            z-index: 0;
        }

        h2 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 30px;
            font-size: 28px;
            font-weight: 600;
            letter-spacing: 1px;
        }

        .form-label {
            font-weight: bold;
            color: #2c3e50;
        }

        .form-control,
        .form-select {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: none;
            border-radius: 25px;
            background: rgba(255, 255, 255, 0.9);
            box-shadow: inset 0 2px 5px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
        }

        .form-control:focus,
        .form-select:focus {
            outline: none;
            background: rgba(255, 255, 255, 1);
            box-shadow: 0 0 10px rgba(249, 168, 37, 0.2);
        }

        .btn-custom {
            width: 100%;
            padding: 10px;
            border: none;
            border-radius: 25px;
            background: linear-gradient(to right, #F9A825, #FFCA28);
            color: white;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-custom:hover {
            background: linear-gradient(to right, #F57F17, #FFB300);
            box-shadow: 0 5px 15px rgba(249, 168, 37, 0.3);
        }

        .alert-danger {
            color: #c62828;
            background: rgba(255, 255, 255, 0.9);
            padding: 10px;
            border-radius: 5px;
            margin-top: 10px;
            text-align: center;
            border: none;
        }
    </style>
</head>
<body>
    <div class="container-wrapper">
        <div class="form-container">
            <h2>Hoàn Thiện Hồ Sơ (Bác Sĩ/Y Tá)</h2>

            <form action="${pageContext.request.contextPath}/CompleteProfileController" method="post">
                <input type="hidden" name="userID" value="${sessionScope.user.userID}">

                <div class="mb-3">
                    <label for="fullName" class="form-label">Họ và tên</label>
                    <input type="text" class="form-control" id="fullName" name="fullName" value="${fullName}" placeholder="Nhập họ và tên" required>
                </div>

                <div class="mb-3">
                    <label for="gender" class="form-label">Giới tính</label>
                    <select class="form-select" id="gender" name="gender" required>
                        <option value="" disabled ${empty gender ? 'selected' : ''}>Chọn giới tính</option>
                        <option value="Nam" ${gender == 'Nam' ? 'selected' : ''}>Nam</option>
                        <option value="Nữ" ${gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                        <option value="Khác" ${gender == 'Khác' ? 'selected' : ''}>Khác</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="dob" class="form-label">Ngày sinh</label>
                    <input type="date" class="form-control" id="dob" name="dob" value="${dob}" required>
                </div>

                <div class="mb-3">
                    <label for="phone" class="form-label">Số điện thoại</label>
                    <input type="tel" class="form-control" id="phone" name="phone" value="${phone}" placeholder="Nhập số điện thoại (10 chữ số)" required>
                </div>

                <div class="mb-3">
                    <label for="specialization" class="form-label">Trình độ chuyên môn</label>
                    <select class="form-select" id="specialization" name="specialization" required>
                        <option value="" disabled ${empty specialization ? 'selected' : ''}>Chọn trình độ</option>
                        <option value="Chuyên môn" ${specialization == 'Chuyên môn' ? 'selected' : ''}>Chuyên môn</option>
                        <option value="Thạc Sỹ" ${specialization == 'Thạc Sỹ' ? 'selected' : ''}>Thạc Sỹ</option>
                        <option value="Tiến Sỹ" ${specialization == 'Tiến Sỹ' ? 'selected' : ''}>Tiến Sỹ</option>
                    </select>
                </div>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger" role="alert">${error}</div>
                </c:if>

                <div class="d-flex justify-content-end">
                    <button type="submit" class="btn btn-custom">Hoàn thiện</button>
                </div>
            </form>
        </div>
        <div class="full-width-bottom-border"></div>
    </div>
</body>
</html>
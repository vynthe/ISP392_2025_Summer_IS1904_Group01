<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hoàn thiện hồ sơ - Receptionist</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #E8F5E9, #C8E6C9);
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
            background: linear-gradient(to right, #66BB6A, #A5D6A7);
        }

        .full-width-bottom-border {
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(to right, #66BB6A, #A5D6A7);
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

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            font-weight: bold;
            color: #2c3e50;
            margin-bottom: 5px;
            display: block;
        }

        .form-control,
        .form-select {
            width: 100%;
            padding: 12px 15px;
            margin-top: 5px;
            border: none;
            border-radius: 25px;
            background: rgba(255, 255, 255, 0.95);
            box-shadow: inset 0 2px 5px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
            font-size: 1rem;
            color: #2c3e50;
        }

        .form-control::placeholder,
        .form-select:invalid {
            color: #aaa;
            font-style: normal; /* Upright text as requested earlier */
        }

        .form-control:hover,
        .form-select:hover {
            background: rgba(255, 255, 255, 1);
            box-shadow: 0 0 10px rgba(102, 187, 106, 0.1);
        }

        .form-control:focus,
        .form-select:focus {
            outline: none;
            background: rgba(255, 255, 255, 1);
            box-shadow: 0 0 10px rgba(102, 187, 106, 0.3);
        }

        button {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 25px;
            background: linear-gradient(to right, #66BB6A, #A5D6A7);
            color: white;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 1rem;
            font-weight: 500;
        }

        button:hover {
            background: linear-gradient(to right, #43A047, #81C784);
            box-shadow: 0 5px 15px rgba(102, 187, 106, 0.3);
        }

        .error {
            color: #c62828;
            background: rgba(255, 255, 255, 0.9);
            padding: 10px;
            border-radius: 5px;
            margin-top: 10px;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="container-wrapper">
        <div class="form-container">
            <h2>Hoàn thiện hồ sơ (Receptionist)</h2>
            <form action="${pageContext.request.contextPath}/CompleteProfileController" method="post">
                <input type="hidden" name="userID" value="${sessionScope.user.userID}">
                <div class="form-group">
                    <label for="fullName" class="form-label">Họ và tên:</label>
                    <input type="text" id="fullName" name="fullName" class="form-control" placeholder="Nhập họ và tên" required>
                </div>
                <div class="form-group">
                    <label for="dob" class="form-label">Ngày sinh:</label>
                    <input type="date" id="dob" name="dob" class="form-control" required>
                </div>
                <div class="form-group">
                    <label for="gender" class="form-label">Giới tính:</label>
                    <select id="gender" name="gender" class="form-select" required>
                        <option value="" disabled selected>Chọn giới tính</option>
                        <option value="Male">Nam</option>
                        <option value="Female">Nữ</option>
                        <option value="Other">Khác</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="phone" class="form-label">Số điện thoại:</label>
                    <input type="tel" id="phone" name="phone" class="form-control" placeholder="Nhập số điện thoại (10 chữ số)" required>
                </div>
                <div class="form-group">
                    <label for="address" class="form-label">Địa chỉ:</label>
                    <input type="text" id="address" name="address" class="form-control" placeholder="Nhập địa chỉ" required>
                </div>
                <button type="submit">Hoàn thiện</button>
                <c:if test="${not empty error}">
                    <p class="error">${error}</p>
                </c:if>
            </form>
        </div>
        <div class="full-width-bottom-border"></div>
    </div>
</body>
</html>
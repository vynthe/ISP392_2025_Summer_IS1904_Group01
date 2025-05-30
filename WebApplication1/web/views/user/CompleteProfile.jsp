<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complete Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #e0f7fa, #b2ebf2);
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

        .container {
            background: #ffffff;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
            margin: 40px 0;
            position: relative;
            overflow: hidden;
            z-index: 1;
            width: 100%;
            max-width: 400px;
        }

        .container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(to right, #00695C, #4DD0E1);
        }

        .full-width-bottom-border {
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(to right, #00695C, #4DD0E1);
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

        .form-box {
            width: 100%;
            text-align: center;
        }

        .form-box input,
        .form-box select {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: none;
            border-radius: 25px;
            background: rgba(255, 255, 255, 0.9);
            box-shadow: inset 0 2px 5px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
        }

        .form-box input:focus,
        .form-box select:focus {
            outline: none;
            background: rgba(255, 255, 255, 1);
            box-shadow: 0 0 10px rgba(0, 105, 92, 0.2);
        }

        .form-box button {
            width: 100%;
            padding: 10px;
            border: none;
            border-radius: 25px;
            background: linear-gradient(to right, #00695C, #4DD0E1);
            color: white;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .form-box button:hover {
            background: linear-gradient(to right, #004D40, #26C6DA);
            box-shadow: 0 5px 15px rgba(0, 105, 92, 0.3);
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
        <div class="container">
            <div class="form-box">
                <h2>Complete Your Profile</h2>
                <form action="${pageContext.request.contextPath}/CompleteProfileController" method="POST">
                    <input type="text" name="fullName" placeholder="Full Name" value="${requestScope.fullName}">
                    <input type="date" name="dob" value="${requestScope.dob}" required>
                    <select name="gender" required>
                        <option value="" disabled ${requestScope.gender == null ? 'selected' : ''}>Gender</option>
                        <option value="Nam" ${requestScope.gender == 'Nam' ? 'selected' : ''}>Nam</option>
                        <option value="Nữ" ${requestScope.gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                        <option value="Khác" ${requestScope.gender == 'Khác' ? 'selected' : ''}>Khác</option>
                    </select>
                    <input type="text" name="phone" placeholder="Phone" value="${requestScope.phone}" required>
                    <input type="text" name="address" placeholder="Address" value="${requestScope.address}">
                    <c:if test="${sessionScope.user.role == 'doctor' || sessionScope.user.role == 'nurse'}">
                        <input type="text" name="specialization" placeholder="Specialization" value="${requestScope.specialization}" required>
                    </c:if>
                    <c:if test="${sessionScope.user.role == 'patient'}">
                        <input type="text" name="medicalHistory" placeholder="Medical History" value="${requestScope.medicalHistory}">
                    </c:if>
                    <button type="submit">Submit</button>
                </form>

                <c:if test="${not empty requestScope.error}">
                    <div class="error">${requestScope.error}</div>
                </c:if>
            </div>
        </div>
        <div class="full-width-bottom-border"></div>
    </div>
</body>
</html>
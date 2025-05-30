<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chỉnh sửa hồ sơ bệnh nhân</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f3f4f6;
                padding: 20px;
            }
            .form-container {
                background-color: white;
                max-width: 500px;
                margin: 0 auto;
                padding: 24px;
                border-radius: 10px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }
            h2 {
                text-align: center;
                margin-bottom: 16px;
            }
            label {
                display: block;
                margin-top: 12px;
            }
            input {
                width: 100%;
                padding: 8px;
                margin-top: 4px;
                border: 1px solid #ccc;
                border-radius: 6px;
            }
            .btn {
                margin-top: 20px;
                padding: 10px;
                background-color: #10b981;
                color: white;
                border: none;
                width: 100%;
                border-radius: 6px;
                cursor: pointer;
            }
            .btn:hover {
                background-color: #059669;
            }
            .message {
                text-align: center;
                margin-top: 12px;
            }
            .message.success {
                color: green;
            }
            .message.error {
                color: red;
            }
        </style>
    </head>
    <body>
        <div class="form-container">

            <c:if test="${not empty success}">
                <div class="message success">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="message error">${error}</div>
            </c:if>
            <h2>Chỉnh sửa hồ sơ bệnh nhân</h2>
            <form action="${pageContext.request.contextPath}/EditProfileUserController" method="post">
                <input type="hidden" name="userID" value="${sessionScope.user.userID}">
                <div class="form-group">
                    <label for="fullName">Họ và tên:</label>
                    <input type="text" id="fullName" name="fullName" value="${sessionScope.user.fullName}" required>
                </div>
                <div class="form-group">
                    <label for="dob">Ngày sinh:</label>
                    <input type="date" id="dob" name="dob" value="${sessionScope.user.dob}" required="">
                </div>
                <div class="form-group">
                    <label for="gender">Giới tính:</label>
                    <select id="gender" name="gender" required>
                        <option value="">Chọn giới tính</option>
                        <option value="Male" ${sessionScope.user.gender == 'Male' ? 'selected' : ''}>Nam</option>
                        <option value="Female" ${sessionScope.user.gender == 'Female' ? 'selected' : ''}>Nữ</option>
                        <option value="Other" ${sessionScope.user.gender == 'Other' ? 'selected' : ''}>Khác</option>
                    </select>
                </div>
                <label for="phone">Số điện thoại:</label>
                <input type="tel" id="phone" name="phone" value="${sessionScope.user.phone}" required>
                <label for="address">Địa chỉ:</label>
                <input type="text" id="address" name="address" value="${sessionScope.user.address}" required>
                <button type="submit" class="btn">Cập nhật</button> 
                <a href="${pageContext.request.contextPath}/views/user/Patient/PatientDashBoard.jsp">
                    <button type="button" class="btn">Quay lại trang chủ</button>
                </a>
            </form>
        </div>
    </body>
</html>

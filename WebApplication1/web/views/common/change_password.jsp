<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/LoginCSS/LoginCSS.css">
    <title>Change Password</title>
</head>
<body>
    <div class="wrapper">
        <nav class="nav">
            <!-- Tương tự navbar trong login.jsp -->
        </nav>
        <div class="form-box">
            <div class="top">
                <header>Change Password</header>
            </div>
            <form action="${pageContext.request.contextPath}/changePassword" method="post">
                <div class="input-box">
                    <input type="password" class="input-field" name="oldPassword" placeholder="Old password" required>
                    <i class="bx bx-lock-alt"></i>
                </div>
                <div class="input-box">
                    <input type="password" class="input-field" name="newPassword" placeholder="New Password" required>
                    <i class="bx bx-lock-alt"></i>
                </div>
                <div class="input-box">
                    <input type="password" class="input-field" name="confirmPassword" placeholder="Confirm new password" required>
                    <i class="bx bx-lock-alt"></i>
                </div>
                <div class="input-box">
                    <input type="submit" class="submit" value="Change Password">
                </div>
                <c:if test="${not empty error}">
                    <div class="error" style="color: red;">${error}</div>
                </c:if>
                <c:if test="${not empty successMessage}">
                    <div class="success" style="color: green;">${successMessage}</div>
                </c:if>
            </form>
        </div>
    </div>
</body>
</html>
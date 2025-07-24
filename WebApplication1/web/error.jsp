<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lỗi - Hệ thống quản lý lịch</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 40px;
            background-color: #f9f9f9;
        }
        h2 {
            color: red;
        }
        .error-message {
            margin-top: 20px;
            padding: 15px;
            background-color: #ffe6e6;
            border: 1px solid #ffcccc;
            border-radius: 5px;
        }
        a {
            display: inline-block;
            margin-top: 25px;
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        a:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <h2>Đã xảy ra lỗi</h2>

    <div class="error-message">
        <c:choose>
            <c:when test="${not empty errorMessage}">
                <c:out value="${errorMessage}" escapeXml="true" />
            </c:when>
            <c:otherwise>
                Đã xảy ra lỗi không xác định. Vui lòng thử lại sau.
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Liên kết quay lại phù hợp với vai trò người dùng -->
    <c:choose>
        <c:when test="${not empty sessionScope.userRole && not empty sessionScope.userId && (sessionScope.userRole == 'doctor' || sessionScope.userRole == 'nurse' || sessionScope.userRole == 'receptionist')}">
            <a href="<c:out value='${pageContext.request.contextPath}'/>/ViewScheduleUserServlet?role=<c:out value='${sessionScope.userRole}'/>&userId=<c:out value='${sessionScope.userId}'/>">
                Quay lại lịch làm việc
            </a>
        </c:when>
        <c:otherwise>
            <a href="<c:out value='${pageContext.request.contextPath}'/>/login.jsp">
                Quay lại trang đăng nhập
            </a>
        </c:otherwise>
    </c:choose>
</body>
</html>

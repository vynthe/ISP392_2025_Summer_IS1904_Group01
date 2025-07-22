<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lỗi - Hệ thống quản lý lịch</title>
</head>
<body>
    <h2>Có lỗi xảy ra</h2>

    <p>
        <c:choose>
            <c:when test="${not empty error}">
                <c:out value="${error}"/>
            </c:when>
            <c:otherwise>
                Đã xảy ra lỗi không xác định. Vui lòng thử lại sau.
            </c:otherwise>
        </c:choose>
    </p>

    <!-- Liên kết quay lại dựa trên session hoặc tham số -->
    <c:choose>
        <c:when test="${not empty sessionScope.userRole and (sessionScope.userRole == 'doctor' or sessionScope.userRole == 'nurse')}">
            <a href="${pageContext.request.contextPath}/ViewScheduleUserServlet?role=${sessionScope.userRole}&userId=${sessionScope.userId}">
                Quay lại lịch làm việc
            </a>
        </c:when>
        <c:when test="${not empty sessionScope.userRole and sessionScope.userRole == 'receptionist'}">
            <a href="${pageContext.request.contextPath}/ViewScheduleUserServlet?role=${sessionScope.userRole}&userId=${sessionScope.userId}">
                Quay lại lịch làm việc
            </a>
        </c:when>
        <c:otherwise>
            <a href="${pageContext.request.contextPath}/login.jsp">
                Quay lại trang đăng nhập
            </a>
        </c:otherwise>
    </c:choose>
</body>
</html>
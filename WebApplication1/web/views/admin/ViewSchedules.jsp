<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch làm việc nhân viên</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #fff3e0, #ffe082);
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            padding: 0;
            position: relative;
        }

        .container-wrapper {
            position: relative;
            min-height: 100vh;
        }

        .container {
            background: #ffffff;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
            margin-top: 40px;
            margin-bottom: 40px;
            position: relative;
            overflow: hidden;
            z-index: 1;
        }

        .full-width-bottom-border {
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(to right, #f57f17, #ffca28);
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

        .btn-primary {
            background: linear-gradient(to right, #f57f17, #ffca28);
            border: none;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background: linear-gradient(to right, #e65100, #ffb300);
            box-shadow: 0 5px 15px rgba(245, 127, 23, 0.3);
        }

        .btn-success {
            background: linear-gradient(to right, #f57f17, #ffca28);
            border: none;
            transition: all 0.3s ease;
        }

        .btn-success:hover {
            background: linear-gradient(to right, #e65100, #ffb300);
            box-shadow: 0 5px 15px rgba(245, 127, 23, 0.3);
        }

        .btn-info {
            background: linear-gradient(to right, #2e7d32, #66bb6a);
            border: none;
            transition: all 0.3s ease;
        }

        .btn-info:hover {
            background: linear-gradient(to right, #1b5e20, #4caf50);
            box-shadow: 0 5px 15px rgba(46, 125, 50, 0.3);
        }

        .table-hover tbody tr:hover {
            background-color: #fff8e1;
        }

        .table {
            border-radius: 8px;
            overflow: hidden;
        }

        .table-light {
            background-color: #f9fafb;
        }

        .search-form {
            max-width: 600px;
            margin-bottom: 20px;
        }

        .pagination {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-top: 20px;
        }

        .pagination .page-link {
            color: #f57f17;
            background-color: #fff;
            border: 1px solid #dee2e6;
            padding: 8px 12px;
            border-radius: 4px;
            text-decoration: none;
        }

        .pagination .page-link:hover {
            background-color: #ffe082;
            color: #e65100;
        }

        .pagination .page-item.active .page-link {
            background-color: #f57f17;
            color: #fff;
            border-color: #f57f17;
        }

        .success-message {
            background-color: #e8f5e9;
            color: #2e7d32;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
            font-size: 14px;
            border-left: 4px solid #2e7d32;
        }
    </style>
</head>
<body>
<div class="container-wrapper">
    <div class="container">
        <!-- Nút Home -->
        <div class="d-flex justify-content-start mb-3">
            <a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp" class="btn btn-success">Home</a>
        </div>
        <h2 class="text-center mb-4">Lịch làm việc nhân viên</h2>

        <!-- Thông báo thành công -->
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="success-message">${sessionScope.successMessage}</div>
            <% session.removeAttribute("successMessage"); %>
        </c:if>

        <!-- Form tìm kiếm -->
        <div class="mb-3">
            <form action="${pageContext.request.contextPath}/admin/schedules" method="get" class="d-flex search-form" style="max-width: 600px;">
                <input type="text" name="keyword" class="form-control me-2" placeholder="Tìm theo tên, chuyên khoa..."
                       value="${keyword != null ? keyword : ''}">
                <button type="submit" class="btn btn-primary">Tìm kiếm</button>
            </form>
        </div>
        <!-- Nút Thêm lịch làm việc -->
        <div class="d-flex justify-content-end mb-3">
            <a href="${pageContext.request.contextPath}/AddScheduleServlet" class="btn btn-success">Thêm lịch làm việc</a>
        </div>

        <!-- Bảng danh sách nhân viên -->
        <table class="table table-bordered table-hover">
            <thead class="table-light text-center">
            <tr>
                <th>ID</th>
                <th>Tên</th>
                <th>Chuyên khoa</th>
                <th>Vai trò</th>
                <th>Hành động</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${not empty employees}">
                    <c:set var="page" value="${param.page != null ? param.page : 1}" />
                    <c:set var="pageSize" value="10" />
                    <c:set var="totalItems" value="${employees.size()}" />
                    <c:set var="totalPages" value="${(totalItems + pageSize - 1) / pageSize}" />
                    <c:set var="startIndex" value="${(page - 1) * pageSize}" />
                    <c:set var="endIndex" value="${startIndex + pageSize - 1}" />
                    <c:if test="${endIndex >= totalItems}">
                        <c:set var="endIndex" value="${totalItems - 1}" />
                    </c:if>

                    <c:forEach var="employee" items="${employees}" begin="${startIndex}" end="${endIndex}">
                        <tr class="text-center">
                            <td>${employee.userID}</td>
                            <td>${employee.fullName}</td>
                            <td>${employee.specialization != null ? employee.specialization : 'N/A'}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${employee.role == 'doctor'}">Bác sĩ</c:when>
                                    <c:when test="${employee.role == 'nurse'}">Y tá</c:when>
                                    <c:when test="${employee.role == 'receptionist'}">Lễ tân</c:when>
                                    <c:otherwise>${employee.role}</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/ViewScheduleDetailsServlet?userID=${employee.userID}" 
                                   class="btn btn-sm btn-info text-white">Xem chi tiết</a>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="5" class="text-center">Không có dữ liệu</td>
                    </tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>

        <!-- Phân trang -->
        <c:if test="${not empty employees and totalItems > pageSize}">
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    <c:set var="prevPage" value="${page - 1}" />
                    <c:set var="nextPage" value="${page + 1}" />
                    <li class="page-item ${page == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/admin/schedules?page=${prevPage}${keyword != null ? '&keyword=' : ''}${keyword}" ${page == 1 ? 'tabindex="-1" aria-disabled="true"' : ''}>Previous</a>
                    </li>
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <li class="page-item ${page == i ? 'active' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/schedules?page=${i}${keyword != null ? '&keyword=' : ''}${keyword}">${i}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${page == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/admin/schedules?page=${nextPage}${keyword != null ? '&keyword=' : ''}${keyword}" ${page == totalPages ? 'tabindex="-1" aria-disabled="true"' : ''}>Next</a>
                    </li>
                </ul>
            </nav>
        </c:if>
    </div>
    <div class="full-width-bottom-border"></div>
</div>
</body>
</html>
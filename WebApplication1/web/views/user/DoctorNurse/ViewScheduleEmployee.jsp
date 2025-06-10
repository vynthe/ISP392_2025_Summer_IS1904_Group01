<%-- 
    Document   : ViewScheduleEmployee
    Created on : 6 Jun 2025, 11:40:00
    Author     : exorc
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>My Schedules</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #f0f2f5, #e0e7ff);
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            padding: 0;
            position: relative;
        }

        .container-wrapper {
            padding-top: 30px;
            padding-bottom: 30px;
        }

        .container {
            background-color: #ffffff;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            padding: 30px;
        }

        h2 {
            color: #333;
            font-weight: 600;
            margin-bottom: 25px;
        }

        .table {
            background-color: #fff;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        }

        .table thead th {
            background-color: #4a69bd;
            color: #fff;
            font-weight: 600;
            padding: 15px 10px;
            vertical-align: middle;
        }

        .table tbody tr:hover {
            background-color: #f5f5f5;
        }

        .table tbody td {
            vertical-align: middle;
            padding: 12px 10px;
            color: #555;
        }

        .btn-primary {
            background-color: #0d6efd;
            border-color: #0d6efd;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background-color: #0b5ed7;
            border-color: #0a58ca;
            transform: translateY(-2px);
        }

        .btn-info {
            background-color: #17a2b8;
            border-color: #17a2b8;
            transition: all 0.3s ease;
        }

        .btn-info:hover {
            background-color: #138496;
            border-color: #117a8b;
            transform: translateY(-2px);
        }

        .pagination {
            display: flex;
            justify-content: center;
            gap: 5px;
            margin-top: 25px;
        }

        .pagination .page-link {
            color: #4a69bd;
            background-color: #fff;
            border: 1px solid #dee2e6;
            padding: 8px 15px;
            border-radius: 5px;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .pagination .page-link:hover {
            background-color: #e0e7ff;
            color: #333;
            border-color: #cdd7ee;
        }

        .pagination .page-item.active .page-link {
            background-color: #4a69bd;
            color: #fff;
            border-color: #4a69bd;
            box-shadow: 0 3px 10px rgba(74, 105, 189, 0.3);
        }

        .alert-danger {
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container-wrapper">
        <div class="container">
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <div class="d-flex justify-content-between align-items-center mb-4">
                <a href="${pageContext.request.contextPath}/views/user/DoctorNurse/EmployeeDashBoard.jsp" class="btn btn-primary">
                    <i class="fas fa-home me-2"></i>Home
                </a>
                <h2 class="text-center flex-grow-1 m-0">Lịch Trình Của Tôi</h2>
            </div>

            <c:choose>
                <c:when test="${empty schedules}">
                    <p class="text-center alert alert-warning">Không có lịch trình nào.</p>
                </c:when>
                <c:otherwise>
                    <c:set var="page" value="${param.page != null ? param.page : 1}" />
                    <c:set var="pageSize" value="10" />
                    <c:set var="totalItems" value="${schedules.size()}" />
                    <c:set var="totalPages" value="${(totalItems + pageSize - 1) / pageSize}" />
                    <c:set var="startIndex" value="${(page - 1) * pageSize}" />
                    <c:set var="endIndex" value="${startIndex + pageSize - 1}" />
                    <c:if test="${endIndex >= totalItems}">
                        <c:set var="endIndex" value="${totalItems - 1}" />
                    </c:if>

                    <table class="table table-bordered table-hover">
                        <thead class="table-light text-center">
                            <tr>
                                <th>Date</th>
                                <th>Start Time</th>
                                <th>End Time</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="schedule" items="${schedules}" begin="${startIndex}" end="${endIndex}">
                                <tr class="text-center">
                                    <td>
                                        <fmt:formatDate value="${schedule['startTime']}" pattern="yyyy-MM-dd" />
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${schedule['shiftStart']}" pattern="HH:mm:ss" />
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${schedule['shiftEnd']}" pattern="HH:mm:ss" />
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/ViewScheduleDetailsServlet?scheduleId=${schedule['scheduleID']}&page=${page}" class="btn btn-info btn-sm">
                                            <i class="fas fa-eye"></i> View Details
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <c:if test="${not empty schedules and totalItems > pageSize}">
                        <nav aria-label="Page navigation">
                            <ul class="pagination">
                                <c:set var="prevPage" value="${page - 1}" />
                                <c:set var="nextPage" value="${page + 1}" />
                                <li class="page-item ${page == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/ViewSchedulesServlet?page=${prevPage}" ${page == 1 ? 'tabindex="-1" aria-disabled="true"' : ''}>Previous</a>
                                </li>
                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <li class="page-item ${page == i ? 'active' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/ViewSchedulesServlet?page=${i}">${i}</a>
                                    </li>
                                </c:forEach>
                                <li class="page-item ${page == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/ViewSchedulesServlet?page=${nextPage}" ${page == totalPages ? 'tabindex="-1" aria-disabled="true"' : ''}>Next</a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
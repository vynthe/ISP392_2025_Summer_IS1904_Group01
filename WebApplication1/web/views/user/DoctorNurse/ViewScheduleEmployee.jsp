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
    <style>
        body {
            background: linear-gradient(135deg, #ede7f6, #d1c4e9);
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

        .container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(to right, #7B1FA2, #AB47BC);
        }

        .full-width-bottom-border {
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(to right, #7B1FA2, #AB47BC);
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
            background: linear-gradient(to right, #7B1FA2, #AB47BC);
            border: none;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background: linear-gradient(to right, #6A1B9A, #9C27B0);
            box-shadow: 0 5px 15px rgba(123, 31, 162, 0.3);
        }

        .btn-info {
            background: linear-gradient(to right, #0288D1, #4FC3F7);
            border: none;
            transition: all 0.3s ease;
        }

        .btn-info:hover {
            background: linear-gradient(to right, #0277BD, #29B6F6);
            box-shadow: 0 5px 15px rgba(2, 136, 209, 0.3);
        }

        .table-hover tbody tr:hover {
            background-color: #f3e5f5;
        }

        .table {
            border-radius: 8px;
            overflow: hidden;
        }

        .table-light {
            background-color: #f9fafb;
        }

        .pagination {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-top: 20px;
        }

        .pagination .page-link {
            color: #7B1FA2;
            background-color: #fff;
            border: 1px solid #dee2e6;
            padding: 8px 12px;
            border-radius: 4px;
            text-decoration: none;
        }

        .pagination .page-link:hover {
            background-color: #f3e5f5;
            color: #6A1B9A;
        }

        .pagination .page-item.active .page-link {
            background-color: #7B1FA2;
            color: #fff;
            border-color: #7B1FA2;
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

            <div class="d-flex justify-content-between mb-3">
                <a href="${pageContext.request.contextPath}/views/user/DoctorNurse/EmployeeDashBoard.jsp" class="btn btn-primary">Home</a>
            </div>
            <h2 class="text-center mb-4">Lịch Trình Của Tôi</h2>

            <c:choose>
                <c:when test="${empty schedules}">
                    <p class="text-center">Không có lịch trình nào.</p>
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
                                <th>Schedule ID</th>
                                <th>Day of Week</th>
                                <th>Start Time</th>
                                <th>End Time</th>
                                <th>Doctor Name</th>
                                <th>Nurse Name</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="schedule" items="${schedules}" begin="${startIndex}" end="${endIndex}">
                                <tr class="text-center">
                                    <td>${schedule.scheduleID}</td>
                                    <td>${schedule.dayOfWeek}</td>
                                    <td>
                                        <fmt:formatDate value="${schedule.startTime}" pattern="HH:mm" />
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${schedule.endTime}" pattern="HH:mm" />
                                    </td>
                                    <td>${schedule.doctorName}</td>
                                    <td>${schedule.nurseName}</td>
                                    <td>${schedule.status}</td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/ViewScheduleDetailsServlet?scheduleId=${schedule.scheduleID}" class="btn btn-info btn-sm">View Details</a>
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
        <div class="full-width-bottom-border"></div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
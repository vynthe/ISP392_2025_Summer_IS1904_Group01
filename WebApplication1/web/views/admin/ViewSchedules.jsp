<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>View All Schedules</title>
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
            .btn-success {
                background-color: #28a745;
                border-color: #28a745;
                transition: all 0.3s ease;
            }
            .btn-success:hover {
                background-color: #218838;
                border-color: #1e7e34;
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
            .debug-info {
                color: #dc3545;
                font-size: 0.8em;
                margin-top: 5px;
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
            .form-control:focus {
                border-color: #4a69bd;
                box-shadow: 0 0 0 0.25rem rgba(74, 105, 189, 0.25);
            }
            .pagination .ellipsis {
                padding: 8px 15px;
                color: #555;
            }
            .search-container {
                display: flex;
                gap: 10px;
                margin-bottom: 20px;
            }
            .search-container .form-control {
                width: 100%;
                max-width: 300px;
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
                    <a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp" class="btn btn-primary">
                        <i class="fas fa-home me-2"></i>Home
                    </a>
                    <h2 class="text-center flex-grow-1 m-0">Danh Sách Lịch Trình</h2>
                    <a href="${pageContext.request.contextPath}/views/admin/AddSchedule.jsp" class="btn btn-success">
                        <i class="fas fa-plus-circle me-2"></i>Thêm Lịch Trình
                    </a>
                </div>

                <form action="${pageContext.request.contextPath}/ViewSchedulesServlet" method="get" class="mb-4">
                    <div class="search-container">
                        <div class="input-group">
                            <input type="text" class="form-control" placeholder="Tìm kiếm theo tên Bác sĩ, Y tá, Receptionist..." name="employeeName" value="${param.employeeName}">
                            <button class="btn btn-primary" type="submit">
                                <i class="fas fa-search me-2"></i>Tìm tên
                            </button>
                        </div>
                        <div class="input-group">
                            <input type="date" class="form-control" name="searchDate" value="${param.searchDate}">
                            <button class="btn btn-primary" type="submit">
                                <i class="fas fa-search me-2"></i>Tìm ngày
                            </button>
                        </div>
                    </div>
                </form>

                <c:choose>
                    <c:when test="${empty schedules}">
                        <p class="text-center alert alert-warning">Không có lịch trình nào phù hợp với tìm kiếm của bạn.</p>
                    </c:when>
                    <c:otherwise>
                        <table class="table table-bordered table-hover">
                            <thead class="table-light text-center">
                                <tr>
                                    <th>Schedule ID</th>
                                    <th>Date</th>
                                    <th>Start Time</th>
                                    <th>End Time</th>
                                    <th>Role</th>
                                    <th>Employee Name</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:set var="page" value="${param.page != null ? param.page : 1}" />
                                <c:set var="pageSize" value="10" />
                                <c:set var="totalItems" value="${schedules.size()}" />
                                <c:set var="totalPages" value="${(totalItems + pageSize - 1) / pageSize}" />
                                <c:set var="startIndex" value="${(page - 1) * pageSize}" />
                                <c:set var="endIndex" value="${startIndex + pageSize - 1}" />
                                <c:if test="${endIndex >= totalItems}">
                                    <c:set var="endIndex" value="${totalItems - 1}" />
                                </c:if>

                                <c:forEach var="schedule" items="${schedules}" begin="${startIndex}" end="${endIndex}">
                                    <tr class="text-center">
                                        <td>${schedule["scheduleID"]}</td>
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
                                            <c:choose>
                                                <c:when test="${schedule['role'] == 'Doctor'}">
                                                    <span class="badge bg-primary">Doctor</span>
                                                </c:when>
                                                <c:when test="${schedule['role'] == 'Nurse'}">
                                                    <span class="badge bg-success">Nurse</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">${schedule['role']}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty schedule['fullName'] and not empty schedule['fullName'].trim()}">
                                                    ${schedule['fullName']}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">Chưa có tên</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${schedule["status"]}</td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/ViewScheduleDetailsServlet?scheduleId=${schedule['scheduleID']}&page=${page}&employeeName=${param.employeeName}&searchDate=${param.searchDate}" class="btn btn-info btn-sm">
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
                                    <c:set var="maxPagesToShow" value="5" />
                                    <c:set var="halfMaxPages" value="${maxPagesToShow div 2}" />

                                    <li class="page-item ${page == 1 ? 'disabled' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/ViewSchedulesServlet?page=${prevPage}&employeeName=${param.employeeName}&searchDate=${param.searchDate}" ${page == 1 ? 'tabindex="-1" aria-disabled="true"' : ''}>Previous</a>
                                    </li>

                                    <c:choose>
                                        <c:when test="${totalPages <= maxPagesToShow}">
                                            <c:forEach var="i" begin="1" end="${totalPages}">
                                                <li class="page-item ${page == i ? 'active' : ''}">
                                                    <a class="page-link" href="${pageContext.request.contextPath}/ViewSchedulesServlet?page=${i}&employeeName=${param.employeeName}&searchDate=${param.searchDate}">${i}</a>
                                                </li>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <li class="page-item ${page == 1 ? 'active' : ''}">
                                                <a class="page-link" href="${pageContext.request.contextPath}/ViewSchedulesServlet?page=1&employeeName=${param.employeeName}&searchDate=${param.searchDate}">1</a>
                                            </li>

                                            <c:if test="${page > halfMaxPages + 1}">
                                                <li class="page-item disabled"><span class="page-link ellipsis">...</span></li>
                                            </c:if>

                                            <c:set var="startPage" value="${page - halfMaxPages}" />
                                            <c:set var="endPage" value="${page + halfMaxPages}" />

                                            <c:if test="${startPage < 2}">
                                                <c:set var="startPage" value="2" />
                                            </c:if>
                                            <c:if test="${endPage > totalPages - 1}">
                                                <c:set var="endPage" value="${totalPages - 1}" />
                                            </c:if>

                                            <c:if test="${endPage - startPage + 1 < maxPagesToShow - 2}">
                                                <c:set var="endPage" value="${startPage + maxPagesToShow - 3}" />
                                                <c:if test="${endPage >= totalPages}">
                                                    <c:set var="endPage" value="${totalPages - 1}" />
                                                    <c:set var="startPage" value="${endPage - (maxPagesToShow - 3)}" />
                                                    <c:if test="${startPage < 2}">
                                                        <c:set var="startPage" value="2" />
                                                    </c:if>
                                                </c:if>
                                            </c:if>

                                            <c:forEach var="i" begin="${startPage}" end="${endPage}">
                                                <c:if test="${i > 0 && i <= totalPages}">
                                                    <li class="page-item ${page == i ? 'active' : ''}">
                                                        <a class="page-link" href="${pageContext.request.contextPath}/ViewSchedulesServlet?page=${i}&employeeName=${param.employeeName}&searchDate=${param.searchDate}">${i}</a>
                                                    </li>
                                                </c:if>
                                            </c:forEach>

                                            <c:if test="${page < totalPages - halfMaxPages}">
                                                <li class="page-item disabled"><span class="page-link ellipsis">...</span></li>
                                            </c:if>

                                            <c:if test="${totalPages > 1 && totalPages != page}">
                                                <li class="page-item ${page == totalPages ? 'active' : ''}">
                                                    <a class="page-link" href="${pageContext.request.contextPath}/ViewSchedulesServlet?page=${totalPages}&employeeName=${param.employeeName}&searchDate=${param.searchDate}">${totalPages}</a>
                                                </li>
                                            </c:if>
                                        </c:otherwise>
                                    </c:choose>

                                    <li class="page-item ${page == totalPages ? 'disabled' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/ViewSchedulesServlet?page=${nextPage}&employeeName=${param.employeeName}&searchDate=${param.searchDate}" ${page == totalPages ? 'tabindex="-1" aria-disabled="true"' : ''}>Next</a>
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
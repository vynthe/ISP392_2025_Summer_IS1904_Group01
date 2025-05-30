<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.entity.Users" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Danh sách Nhân Viên</title>
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
                min-height: 100vh; /* Ensure the wrapper takes at least the full viewport height */
            }

            .container {
                background: #ffffff;
                padding: 40px;
                border-radius: 15px;
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
                margin-top: 40px;
                margin-bottom: 40px; /* Add space for the bottom border to be visible */
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

            .btn-danger {
                background: #c62828;
                border: none;
                transition: all 0.3s ease;
            }

            .btn-danger:hover {
                background: #b71c1c;
                box-shadow: 0 5px 15px rgba(198, 40, 40, 0.3);
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
        </style>
    </head>
    <body>
        <div class="container-wrapper">
            <div class="container">
                <div class="d-flex justify-content-start mb-3">
                    <a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp" class="btn btn-success">Home</a>
                </div>
                <h2 class="text-center mb-4">Danh sách Nhân Viên</h2>
                
                <!-- FORM TÌM KIẾM -->
                <div class="mb-3">
                    <form action="ViewEmployeeServlet" method="get" class="d-flex search-form" style="max-width: 600px;">
                        <input type="text" name="keyword" class="form-control me-2" placeholder="Tìm theo tên, email..."
                               value="${keyword != null ? keyword : ''}">
                        <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                    </form>
                </div>
                <div class="d-flex justify-content-end mb-3">
                    <a href="${pageContext.request.contextPath}/views/admin/AddEmployees.jsp" class="btn btn-success">Thêm Nhân Viên</a>
                </div>
                      
                <!-- TABLE DANH SÁCH NHÂN VIÊN -->
                <table class="table table-bordered table-hover">
                    <thead class="table-light text-center">
                        <tr>
                            <th>ID</th>
                            <th>Tên</th>
                            <th>Giới tính</th>
                            <th>Chuyên khoa</th>
                            <th>Ngày sinh</th>
                              <th>SĐT</th>
                            <th>Trạng thái</th>
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

                                <c:forEach var="user" items="${employees}" begin="${startIndex}" end="${endIndex}">
                                    <tr class="text-center">
                                        <td>${user.userID}</td>
                                        <td>${user.fullName}</td>
                                        <td>${user.gender}</td>
                                        <td>${user.specialization}</td>
                                        <td>
                                            <fmt:formatDate value="${user.dob}" pattern="dd/MM/yyyy" />
                                        </td>
                                         <td>${user.phone}</td>
                                        <td>${user.status}</td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/ViewDetailEmployeesServlet?id=${user.userID}" class="btn btn-sm btn-info text-white">Xem chi tiết</a>
                                            <a href="${pageContext.request.contextPath}/UpdateEmployeeServlet?id=${user.userID}" class="btn btn-sm btn-primary">Sửa</a>
                                            <a href="${pageContext.request.contextPath}/DeleteDoctorServlet?id=${user.userID}" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc muốn xóa nhân viên này?');">Xóa</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7" class="text-center">Không có dữ liệu</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>

                <!-- PHÂN TRANG -->
                <c:if test="${not empty employees and totalItems > pageSize}">
                    <nav aria-label="Page navigation">
                        <ul class="pagination">
                            <c:set var="prevPage" value="${page - 1}" />
                            <c:set var="nextPage" value="${page + 1}" />
                            <li class="page-item ${page == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/ViewEmployeeServlet?page=${prevPage}${keyword != null ? '&keyword=' : ''}${keyword}" ${page == 1 ? 'tabindex="-1" aria-disabled="true"' : ''}>Previous</a>
                            </li>
                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <li class="page-item ${page == i ? 'active' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/ViewEmployeeServlet?page=${i}${keyword != null ? '&keyword=' : ''}${keyword}">${i}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${page == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/ViewEmployeeServlet?page=${nextPage}${keyword != null ? '&keyword=' : ''}${keyword}" ${page == totalPages ? 'tabindex="-1" aria-disabled="true"' : ''}>Next</a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </div>
            <div class="full-width-bottom-border"></div>
        </div>
    </body>
</html>
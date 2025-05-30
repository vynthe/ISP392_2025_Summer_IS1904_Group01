<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.entity.Users" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Danh sách Bệnh Nhân</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background: linear-gradient(135deg, #e3f2fd, #bbdefb);
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

            .container::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 5px;
                background: linear-gradient(to right, #1976d2, #64b5f6);
            }

            .full-width-bottom-border {
                position: absolute;
                bottom: 0;
                left: 0;
                width: 100%;
                height: 5px;
                background: linear-gradient(to right, #1976d2, #64b5f6);
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
                background: linear-gradient(to right, #1976d2, #64b5f6);
                border: none;
                transition: all 0.3s ease;
            }

            .btn-primary:hover {
                background: linear-gradient(to right, #1565c0, #42a5f5);
                box-shadow: 0 5px 15px rgba(25, 118, 210, 0.3);
            }

            .btn-success {
                background: linear-gradient(to right, #1976d2, #64b5f6);
                border: none;
                transition: all 0.3s ease;
            }

            .btn-success:hover {
                background: linear-gradient(to right, #1565c0, #42a5f5);
                box-shadow: 0 5px 15px rgba(25, 118, 210, 0.3);
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
                background-color: #e3f2fd;
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
                color: #1976d2;
                background-color: #fff;
                border: 1px solid #dee2e6;
                padding: 8px 12px;
                border-radius: 4px;
                text-decoration: none;
            }

            .pagination .page-link:hover {
                background-color: #e3f2fd;
                color: #1565c0;
            }

            .pagination .page-item.active .page-link {
                background-color: #1976d2;
                color: #fff;
                border-color: #1976d2;
            }
        </style>
    </head>
    <body>
        <div class="container-wrapper">
            <div class="container">
                <div class="d-flex justify-content-start mb-3">
                    <a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp" class="btn btn-primary">Home</a>
                </div>
                <!-- FORM TÌM KIẾM -->
                <div class="mb-3">
                    <form action="ViewPatientServlet" method="get" class="d-flex search-form" style="max-width: 600px;">
                        <input type="text" name="keyword" class="form-control me-2" placeholder="Tìm theo tên, email..."
                               value="${keyword != null ? keyword : ''}">
                        <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                    </form>
                </div>
                <h2 class="text-center mb-4">Danh sách Bệnh Nhân</h2>
                <div class="d-flex justify-content-end mb-3">
                    <a href="${pageContext.request.contextPath}/views/admin/AddPatient.jsp" class="btn btn-success">Thêm bệnh nhân</a>
                </div>
                <form action="ViewPatientServlet" method="get">
                    <table class="table table-bordered table-hover">
                        <thead class="table-light text-center">
                            <tr>
                                <th>ID</th>
                                <th>Họ tên</th>
                                <th>Giới tính</th>
                                <th>Ngày sinh</th>
                                <th>SĐT</th>
                                <th>Địa chỉ</th>
                                <th>Trạng thái</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty patients}">
                                    <c:set var="page" value="${param.page != null ? param.page : 1}" />
                                    <c:set var="pageSize" value="10" />
                                    <c:set var="totalItems" value="${patients.size()}" />
                                    <c:set var="totalPages" value="${(totalItems + pageSize - 1) / pageSize}" />
                                    <c:set var="startIndex" value="${(page - 1) * pageSize}" />
                                    <c:set var="endIndex" value="${startIndex + pageSize - 1}" />
                                    <c:if test="${endIndex >= totalItems}">
                                        <c:set var="endIndex" value="${totalItems - 1}" />
                                    </c:if>

                                    <c:forEach var="patient" items="${patients}" begin="${startIndex}" end="${endIndex}">
                                        <tr class="text-center">
                                            <td>${patient.userID}</td>
                                            <td>${patient.fullName}</td>
                                            <td>${patient.gender}</td>
                                            <td><fmt:formatDate value="${patient.dob}" pattern="dd/MM/yyyy" /></td>
                                            <td>${patient.phone}</td>
                                            <td>${patient.address}</td>
                                            <td>${patient.status}</td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/ViewPatientDetailServlet?id=${patient.userID}" class="btn btn-sm btn-info text-white">Xem chi tiết</a>
                                                <a href="${pageContext.request.contextPath}/UpdatePatientServlet?id=${patient.userID}" class="btn btn-sm btn-primary">Sửa</a>
                                                <a href="${pageContext.request.contextPath}/deletePatient?id=${patient.userID}" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc muốn xóa bệnh nhân này?');">Xóa</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="8" class="text-center">Không có dữ liệu</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>

                    <!-- PHÂN TRANG -->
                    <c:if test="${not empty patients and totalItems > pageSize}">
                        <nav aria-label="Page navigation">
                            <ul class="pagination">
                                <c:set var="prevPage" value="${page - 1}" />
                                <c:set var="nextPage" value="${page + 1}" />
                                <li class="page-item ${page == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/ViewPatientServlet?page=${prevPage}" ${page == 1 ? 'tabindex="-1" aria-disabled="true"' : ''}>Previous</a>
                                </li>
                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <li class="page-item ${page == i ? 'active' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/ViewPatientServlet?page=${i}">${i}</a>
                                    </li>
                                </c:forEach>
                                <li class="page-item ${page == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/ViewPatientServlet?page=${nextPage}" ${page == totalPages ? 'tabindex="-1" aria-disabled="true"' : ''}>Next</a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </form>
            </div>
            <div class="full-width-bottom-border"></div>
        </div>
    </body>
</html>
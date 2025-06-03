<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.entity.Services" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Danh Sách Dịch Vụ</title>
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

            .btn-success {
                background: linear-gradient(to right, #7B1FA2, #AB47BC);
                border: none;
                transition: all 0.3s ease;
            }

            .btn-success:hover {
                background: linear-gradient(to right, #6A1B9A, #9C27B0);
                box-shadow: 0 5px 15px rgba(123, 31, 162, 0.3);
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
            .alert-success {
                margin-bottom: 20px;
            }
        </style>
    </head>
    <body>
        <div class="container-wrapper">
            <div class="container">
                 <c:if test="${not empty successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>
                <div class="d-flex justify-content-start mb-3">
                    <a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp" class="btn btn-primary">Home</a>
                </div>
                <h2 class="text-center mb-4">Danh Sách Dịch Vụ</h2>
                <div class="d-flex justify-content-end mb-3">
                    <a href="${pageContext.request.contextPath}/views/admin/AddService.jsp" class="btn btn-success">Thêm Dịch Vụ</a>
                </div>
               
              <!-- Form tìm kiếm  -->
<div class="search-form">
    <form action="${pageContext.request.contextPath}/ViewServiceServlet" method="get">
        <div class="row g-2">
            <div class="col-md-6">
                <input type="text" class="form-control" name="keyword" value="${param.keyword}" placeholder="Tìm theo ID hoặc Tên Dịch Vụ">
            </div>
            <div class="col-md-2">
                <input type="number" step="1" min="0" class="form-control" name="minPrice" value="${param.minPrice}" placeholder="Giá từ (VNĐ)">
            </div>
            <div class="col-md-2">
                <input type="number" step="1" min="0" class="form-control" name="maxPrice" value="${param.maxPrice}" placeholder="Giá đến (VNĐ)">
            </div>
            <div class="col-md-2">
                <button type="submit" class="btn btn-primary w-100">Tìm Kiếm</button>
            </div>
        </div>
    </form>
</div>

                 <form action="ViewServiceServlet" method="get">
                    <table class="table table-bordered table-hover">
                        <thead class="table-light text-center">
                            <tr>
                                <th>ID</th>
                                <th>Tên Dịch Vụ</th>
                                <th>Giá (VNĐ)</th>
                                <th>Trạng Thái</th>
                                <th>Ngày Tạo</th>
                                <th>Ngày Cập Nhật</th>
                                <th>Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty services}">
                                    <c:set var="page" value="${param.page != null ? param.page : 1}" />
                                    <c:set var="pageSize" value="10" />
                                    <c:set var="totalItems" value="${services.size()}" />
                                    <c:set var="totalPages" value="${(totalItems + pageSize - 1) / pageSize}" />
                                    <c:set var="startIndex" value="${(page - 1) * pageSize}" />
                                    <c:set var="endIndex" value="${startIndex + pageSize - 1}" />
                                    <c:if test="${endIndex >= totalItems}">
                                        <c:set var="endIndex" value="${totalItems - 1}" />
                                    </c:if>

                                    <c:forEach var="service" items="${services}" begin="${startIndex}" end="${endIndex}">
                                        <tr class="text-center">
                                            <td>${service.serviceID}</td>
                                            <td>${service.serviceName}</td>
                                            <td>
                                                <fmt:formatNumber value="${service.price}" type="number" pattern="#,##0" />
                                            </td>
                                            <td>${service.status}</td>
                                            <td>
                                                <fmt:formatDate value="${service.createdAt}" pattern="dd/MM/yyyy" />
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${service.updatedAt}" pattern="dd/MM/yyyy" />
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/ViewDetailServiceAdminServlet?id=${service.serviceID}" class="btn btn-sm btn-info text-white">Xem chi tiết</a>
                                                <a href="${pageContext.request.contextPath}/UpdateServiceServlet?id=${service.serviceID}" class="btn btn-sm btn-primary">Sửa</a>
                                                <a href="${pageContext.request.contextPath}/DeleteServiceServlet?id=${service.serviceID}" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc muốn xóa dịch vụ này?');">Xóa</a>
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
                    <c:if test="${not empty services and totalItems > pageSize}">
                        <nav aria-label="Page navigation">
                            <ul class="pagination">
                                <c:set var="prevPage" value="${page - 1}" />
                                <c:set var="nextPage" value="${page + 1}" />
                                <li class="page-item ${page == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/ViewServiceServlet?page=${prevPage}" ${page == 1 ? 'tabindex="-1" aria-disabled="true"' : ''}>Previous</a>
                                </li>
                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <li class="page-item ${page == i ? 'active' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/ViewServiceServlet?page=${i}">${i}</a>
                                    </li>
                                </c:forEach>
                                <li class="page-item ${page == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/ViewServiceServlet?page=${nextPage}" ${page == totalPages ? 'tabindex="-1" aria-disabled="true"' : ''}>Next</a>
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
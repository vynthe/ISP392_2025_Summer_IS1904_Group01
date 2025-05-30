<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.entity.Users" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết Bệnh Nhân</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background: linear-gradient(135deg, #e3f2fd, #bbdefb);
                font-family: 'Segoe UI', Arial, sans-serif;
            }

            .container {
                background: #ffffff;
                padding: 40px;
                border-radius: 15px;
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
                margin-top: 40px;
                position: relative;
                overflow: hidden;
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

            .detail-card {
                background-color: #f9fafb;
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 20px;
            }

            .detail-label {
                font-weight: bold;
                color: #2c3e50;
            }

            .detail-value {
                color: #555;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="d-flex justify-content-start mb-3">
                <a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp" class="btn btn-primary">Home</a>
            </div>
            <h2 class="text-center mb-4">Chi tiết Bệnh Nhân</h2>
            <form action="ViewPatientServlet" method="post"></form>
            <c:choose>
                <c:when test="${not empty user}">
                    <div class="detail-card">
                        <div class="row mb-3">
                            <div class="col-md-3 detail-label">ID:</div>
                            <div class="col-md-9 detail-value">${user.userID}</div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-3 detail-label">Tên đăng nhập:</div>
                            <div class="col-md-9 detail-value">${user.username}</div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-3 detail-label">Email:</div>
                            <div class="col-md-9 detail-value">${user.email}</div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-3 detail-label">Họ tên:</div>
                            <div class="col-md-9 detail-value">${user.fullName != null ? user.fullName : 'Chưa cung cấp'}</div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-3 detail-label">Giới tính:</div>
                            <div class="col-md-9 detail-value">${user.gender != null ? user.gender : 'Chưa cung cấp'}</div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-3 detail-label">Ngày sinh:</div>
                            <div class="col-md-9 detail-value">
                                <c:choose>
                                    <c:when test="${user.dob != null}">
                                        <fmt:formatDate value="${user.dob}" pattern="dd/MM/yyyy" />
                                    </c:when>
                                    <c:otherwise>Chưa cung cấp</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-3 detail-label">Số điện thoại:</div>
                            <div class="col-md-9 detail-value">${user.phone != null ? user.phone : 'Chưa cung cấp'}</div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-3 detail-label">Địa chỉ:</div>
                            <div class="col-md-9 detail-value">${user.address != null ? user.address : 'Chưa cung cấp'}</div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-3 detail-label">Tiền sử bệnh:</div>
                            <div class="col-md-9 detail-value">${user.medicalHistory != null ? user.medicalHistory : 'Chưa cung cấp'}</div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-3 detail-label">Trạng thái:</div>
                            <div class="col-md-9 detail-value">${user.status}</div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-3 detail-label">Ngày tạo:</div>
                            <div class="col-md-9 detail-value">
                                <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy HH:mm:ss" />
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-3 detail-label">Ngày cập nhật:</div>
                            <div class="col-md-9 detail-value">
                                <fmt:formatDate value="${user.updatedAt}" pattern="dd/MM/yyyy HH:mm:ss" />
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-3 detail-label">Người tạo:</div>
                            <div class="col-md-9 detail-value">${user.createdBy != null ? user.createdBy : 'Chưa cung cấp'}</div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-danger text-center" role="alert">
                        Không tìm thấy thông tin bệnh nhân!
                    </div>
                </c:otherwise>
            </c:choose>

            <div class="text-center">
                <a href="${pageContext.request.contextPath}/ViewPatientServlet" class="btn btn-primary">Quay lại danh sách</a>
            </div>
        </div>
    </body>
</html>
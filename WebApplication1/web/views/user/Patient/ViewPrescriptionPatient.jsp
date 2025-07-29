<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đơn Thuốc Của Tôi - Hệ thống quản lý phòng khám</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .prescription-card {
            transition: transform 0.2s;
            border: 1px solid #e0e0e0;
        }
        .prescription-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .doctor-info {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 0.8rem;
        }
        .diagnosis-preview {
            max-height: 2.4em;
            overflow: hidden;
            line-height: 1.2em;
        }
    </style>
</head>
<body class="bg-light">
    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="#">
                <i class="fas fa-clinic-medical me-2"></i>
                Phòng khám ABC
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="${pageContext.request.contextPath}/patient/dashboard">
                    <i class="fas fa-home me-1"></i>Trang chủ
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                    <i class="fas fa-sign-out-alt me-1"></i>Đăng xuất
                </a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <!-- Header -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h2 class="mb-1">
                            <i class="fas fa-prescription-bottle-alt me-2 text-primary"></i>
                            <c:choose>
                                <c:when test="${isDetailView}">Chi Tiết Đơn Thuốc</c:when>
                                <c:otherwise>Đơn Thuốc Của Tôi</c:otherwise>
                            </c:choose>
                        </h2>
                        <p class="text-muted mb-0">Xem danh sách và chi tiết đơn thuốc của bạn</p>
                    </div>
                    <c:if test="${not isDetailView}">
                        <div class="text-end">
                            <span class="badge bg-info fs-6">
                                Tổng cộng: ${totalPrescriptions} đơn thuốc
                            </span>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Error Message -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>
                ${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Detail View -->
        <c:if test="${isDetailView}">
            <div class="card mb-4">
                <div class="card-body">
                    <h5 class="card-title">
                        <i class="fas fa-prescription-bottle-alt me-2"></i>
                        Chi Tiết Đơn Thuốc #${prescriptionDetail.prescriptionId}
                    </h5>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="doctor-info mb-3">
                                <div class="d-flex align-items-center mb-2">
                                    <i class="fas fa-user-md text-primary me-2"></i>
                                    <strong>${prescriptionDetail.doctorName}</strong>
                                </div>
                                <div class="small text-muted mb-2">
                                    <i class="fas fa-calendar-alt me-2"></i>
                                    Ngày tạo: ${prescriptionDetail.createdAt != null ? prescriptionDetail.createdAt.toString().substring(0, 16).replace('T', ' ') : 'Không có'}
                                </div>
                                <div class="small text-muted">
                                    <i class="fas fa-calendar-check me-2"></i>
                                    Cập nhật: ${prescriptionDetail.updatedAt != null ? prescriptionDetail.updatedAt.toString().substring(0, 16).replace('T', ' ') : 'Không có'}
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="doctor-info mb-3">
                                <div class="small mb-2">
                                    <i class="fas fa-user-nurse text-info me-2"></i>
                                    Y tá: ${prescriptionDetail.nurseName != null ? prescriptionDetail.nurseName : 'Chưa có'}
                                </div>
                                <div class="small">
                                    <i class="fas fa-calendar-day me-2"></i>
                                    Mã lịch hẹn: ${prescriptionDetail.appointmentId != null ? prescriptionDetail.appointmentId : 'Không có'}
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <h6 class="mb-2">
                            <i class="fas fa-notes-medical text-success me-2"></i>
                            Chẩn đoán:
                        </h6>
                        <p class="diagnosis-preview text-muted">
                            ${prescriptionDetail.diagnosis != null ? prescriptionDetail.diagnosis : 'Không có'}
                        </p>
                    </div>
                    <div class="mb-3">
                        <h6 class="mb-2">
                            <i class="fas fa-pills text-success me-2"></i>
                            Thông Tin Đơn Thuốc:
                        </h6>
                        <ul class="list-group">
                            <li class="list-group-item">
                                <strong>Liều lượng:</strong> ${prescriptionDetail.prescriptionDosage != null ? prescriptionDetail.prescriptionDosage : 'Không có'}
                            </li>
                            <li class="list-group-item">
                                <strong>Hướng dẫn:</strong> ${prescriptionDetail.instruct != null ? prescriptionDetail.instruct : 'Không có'}
                            </li>
                            <li class="list-group-item">
                                <strong>Số lượng:</strong> ${prescriptionDetail.quantity != null ? prescriptionDetail.quantity : 'Không có'}
                            </li>
                        </ul>
                    </div>
                    <div class="mt-3">
                        <a href="${pageContext.request.contextPath}/ViewPrescriptionPatient" 
                           class="btn btn-outline-primary btn-sm">
                            <i class="fas fa-arrow-left me-1"></i>Quay lại danh sách
                        </a>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- List View -->
        <c:if test="${not isDetailView}">
            <!-- Statistics -->
            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="card bg-info text-white">
                        <div class="card-body">
                            <h6 class="card-title">
                                <i class="fas fa-prescription-bottle-alt me-2"></i>
                                Tổng số đơn thuốc
                            </h6>
                            <p class="fs-4 mb-0">${totalPrescriptions}</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card bg-success text-white">
                        <div class="card-body">
                            <h6 class="card-title">
                                <i class="fas fa-user-nurse me-2"></i>
                                Đơn có y tá
                            </h6>
                            <p class="fs-4 mb-0">${prescriptionsWithNurse}</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card bg-warning text-dark">
                        <div class="card-body">
                            <h6 class="card-title">
                                <i class="fas fa-prescription-bottle me-2"></i>
                                Đơn không có y tá
                            </h6>
                            <p class="fs-4 mb-0">${prescriptionsWithoutNurse}</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Filters and Controls -->
            <div class="row mb-4">
                <div class="col-md-6">
                    <div class="d-flex align-items-center">
                        <label for="pageSize" class="form-label me-2 mb-0">Hiển thị:</label>
                        <select id="pageSize" class="form-select form-select-sm w-auto" onchange="changePageSize()">
                            <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                            <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                            <option value="30" ${pageSize == 30 ? 'selected' : ''}>30</option>
                            <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                        </select>
                        <span class="ms-2 text-muted">đơn thuốc mỗi trang</span>
                    </div>
                </div>
                <div class="col-md-6 text-md-end">
                    <button class="btn btn-outline-primary btn-sm" onclick="location.reload()">
                        <i class="fas fa-sync-alt me-1"></i>Làm mới
                    </button>
                </div>
            </div>

            <!-- Prescriptions List -->
            <div class="row">
                <c:choose>
                    <c:when test="${empty prescriptions}">
                        <div class="col-12">
                            <div class="text-center py-5">
                                <i class="fas fa-prescription-bottle-alt fa-3x text-muted mb-3"></i>
                                <h4 class="text-muted">Chưa có đơn thuốc</h4>
                                <p class="text-muted">Các đơn thuốc của bạn sẽ được hiển thị tại đây sau khi được kê.</p>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="prescription" items="${prescriptions}">
                            <div class="col-lg-6 col-xl-4 mb-4">
                                <div class="card prescription-card h-100">
                                    <div class="card-body">
                                        <!-- Date -->
                                        <div class="d-flex justify-content-between align-items-start mb-3">
                                            <div>
                                                <h6 class="card-title mb-1">
                                                    ${prescription.createdAt != null ? prescription.createdAt.toString().substring(0, 10) : 'Không có'}
                                                </h6>
                                                <small class="text-muted">
                                                    ${prescription.createdAt != null ? prescription.createdAt.toString().substring(11, 16) : 'Không có'}
                                                </small>
                                            </div>
                                        </div>

                                        <!-- Doctor and Nurse Info -->
                                        <div class="doctor-info mb-3">
                                            <div class="d-flex align-items-center mb-2">
                                                <i class="fas fa-user-md text-primary me-2"></i>
                                                <strong>${prescription.doctorName}</strong>
                                            </div>
                                            <div class="small mb-2">
                                                <i class="fas fa-user-nurse text-info me-2"></i>
                                                Y tá: ${prescription.nurseName != null ? prescription.nurseName : 'Chưa có'}
                                            </div>
                                            <div class="small">
                                                <i class="fas fa-calendar-day me-2"></i>
                                                Mã lịch hẹn: ${prescription.appointmentId != null ? prescription.appointmentId : 'Không có'}
                                            </div>
                                        </div>

                                        <!-- Diagnosis Preview -->
                                        <div class="mb-3">
                                            <h6 class="mb-2">
                                                <i class="fas fa-notes-medical text-success me-2"></i>
                                                Chẩn đoán:
                                            </h6>
                                            <p class="diagnosis-preview text-muted">
                                                ${prescription.diagnosis != null ? prescription.diagnosis : 'Không có'}
                                            </p>
                                        </div>

                                        <!-- Updated At -->
                                        <div class="small mb-2">
                                            <i class="fas fa-clock me-2"></i>
                                            Cập nhật: ${prescription.updatedAt != null ? prescription.updatedAt.toString().substring(0, 16).replace('T', ' ') : 'Không có'}
                                        </div>
                                    </div>

                                    <!-- Card Footer -->
                                    <div class="card-footer bg-transparent">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <small class="text-muted">
                                                <i class="fas fa-prescription-bottle-alt me-1"></i>
                                                Đơn thuốc #${prescription.prescriptionId}
                                            </small>
                                            <a href="${pageContext.request.contextPath}/ViewPrescriptionPatient?action=detail&prescriptionId=${prescription.prescriptionId}" 
                                               class="btn btn-outline-primary btn-sm">
                                                <i class="fas fa-eye me-1"></i>Xem chi tiết
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <nav aria-label="Page navigation" class="mt-4">
                    <ul class="pagination justify-content-center">
                        <!-- Previous Button -->
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="?page=${currentPage - 1}&pageSize=${pageSize}">
                                <i class="fas fa-chevron-left"></i>
                            </a>
                        </li>

                        <!-- First Page -->
                        <c:if test="${startPage > 1}">
                            <li class="page-item">
                                <a class="page-link" href="?page=1&pageSize=${pageSize}">1</a>
                            </li>
                            <c:if test="${startPage > 2}">
                                <li class="page-item disabled">
                                    <span class="page-link">...</span>
                                </li>
                            </c:if>
                        </c:if>

                        <!-- Page Numbers -->
                        <c:forEach begin="${startPage}" end="${endPage}" var="pageNum">
                            <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                <a class="page-link" href="?page=${pageNum}&pageSize=${pageSize}">${pageNum}</a>
                            </li>
                        </c:forEach>

                        <!-- Last Page -->
                        <c:if test="${endPage < totalPages}">
                            <c:if test="${endPage < totalPages - 1}">
                                <li class="page-item disabled">
                                    <span class="page-link">...</span>
                                </li>
                            </c:if>
                            <li class="page-item">
                                <a class="page-link" href="?page=${totalPages}&pageSize=${pageSize}">${totalPages}</a>
                            </li>
                        </c:if>

                        <!-- Next Button -->
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="?page=${currentPage + 1}&pageSize=${pageSize}">
                                <i class="fas fa-chevron-right"></i>
                            </a>
                        </li>
                    </ul>
                </nav>

                <!-- Pagination Info -->
                <div class="text-center mt-3">
                    <small class="text-muted">
                        Hiển thị ${(currentPage - 1) * pageSize + 1} - 
                        ${currentPage * pageSize > totalPrescriptions ? totalPrescriptions : currentPage * pageSize} 
                        trong tổng số ${totalPrescriptions} đơn thuốc
                    </small>
                </div>
            </c:if>
        </c:if>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function changePageSize() {
            const pageSize = document.getElementById('pageSize').value;
            window.location.href = '?page=1&pageSize=' + pageSize;
        }
    </script>
</body>
</html>
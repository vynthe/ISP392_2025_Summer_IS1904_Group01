<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả khám bệnh - Hệ thống quản lý phòng khám</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .result-card {
            transition: transform 0.2s;
            border: 1px solid #e0e0e0;
        }
        .result-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .status-badge {
            font-size: 0.8rem;
            padding: 0.4rem 0.8rem;
            border-radius: 20px;
        }
        .status-completed {
            background-color: #d4edda;
            color: #155724;
        }
        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }
        .status-draft {
            background-color: #f8d7da;
            color: #721c24;
        }
        .diagnosis-preview {
            max-height: 2.4em;
            overflow: hidden;
            line-height: 1.2em;
        }
        .doctor-info {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 0.8rem;
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
                            <i class="fas fa-file-medical me-2 text-primary"></i>
                            Kết quả khám bệnh của tôi
                        </h2>
                        <p class="text-muted mb-0">Xem lại các kết quả khám bệnh và chẩn đoán</p>
                    </div>
                    <div class="text-end">
                        <span class="badge bg-info fs-6">
                            Tổng cộng: ${totalResults} kết quả
                        </span>
                    </div>
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
                    <span class="ms-2 text-muted">kết quả mỗi trang</span>
                </div>
            </div>
            <div class="col-md-6 text-md-end">
                <button class="btn btn-outline-primary btn-sm" onclick="location.reload()">
                    <i class="fas fa-sync-alt me-1"></i>Làm mới
                </button>
            </div>
        </div>

        <!-- Results List -->
        <div class="row">
            <c:choose>
                <c:when test="${empty examinationResults}">
                    <div class="col-12">
                        <div class="text-center py-5">
                            <i class="fas fa-file-medical fa-3x text-muted mb-3"></i>
                            <h4 class="text-muted">Chưa có kết quả khám bệnh</h4>
                            <p class="text-muted">Các kết quả khám bệnh của bạn sẽ được hiển thị tại đây sau khi hoàn thành khám.</p>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="result" items="${examinationResults}">
                        <div class="col-lg-6 col-xl-4 mb-4">
                            <div class="card result-card h-100">
                                <div class="card-body">
                                    <!-- Date and Status -->
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <div>
                                            <h6 class="card-title mb-1">
                                                <fmt:formatDate value="${result.slotDate}" pattern="dd/MM/yyyy"/>
                                            </h6>
                                            <small class="text-muted">
                                                <fmt:formatDate value="${result.startTime}" pattern="HH:mm"/> - 
                                                <fmt:formatDate value="${result.endTime}" pattern="HH:mm"/>
                                            </small>
                                        </div>
                                        <span class="status-badge 
                                            ${result.resultStatus == 'Completed' ? 'status-completed' : 
                                              result.resultStatus == 'Pending' ? 'status-pending' : 'status-draft'}">
                                            <c:choose>
                                                <c:when test="${result.resultStatus == 'Completed'}">Hoàn thành</c:when>
                                                <c:when test="${result.resultStatus == 'Pending'}">Đang xử lý</c:when>
                                                <c:when test="${result.resultStatus == 'Draft'}">Nháp</c:when>
                                                <c:when test="${result.resultStatus == 'Reviewed'}">Đã xem xét</c:when>
                                                <c:otherwise>${result.resultStatus}</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>

                                    <!-- Doctor and Service Info -->
                                    <div class="doctor-info mb-3">
                                        <div class="d-flex align-items-center mb-2">
                                            <i class="fas fa-user-md text-primary me-2"></i>
                                            <strong>${result.doctorName}</strong>
                                        </div>
                                        <c:if test="${not empty result.doctorSpecialization}">
                                            <div class="small text-muted mb-2">
                                                <i class="fas fa-stethoscope me-2"></i>
                                                ${result.doctorSpecialization}
                                            </div>
                                        </c:if>
                                        <div class="small">
                                            <i class="fas fa-medical-bag text-info me-2"></i>
                                            ${result.serviceName}
                                        </div>
                                    </div>

                                    <!-- Diagnosis Preview -->
                                    <div class="mb-3">
                                        <h6 class="mb-2">
                                            <i class="fas fa-notes-medical text-success me-2"></i>
                                            Chẩn đoán:
                                        </h6>
                                        <p class="diagnosis-preview text-muted">
                                            ${result.diagnosis}
                                        </p>
                                    </div>

                                    <!-- Room Info -->
                                    <div class="mb-3">
                                        <small class="text-muted">
                                            <i class="fas fa-door-open me-1"></i>
                                            Phòng: ${result.roomName}
                                        </small>
                                    </div>
                                </div>

                                <!-- Card Footer -->
                                <div class="card-footer bg-transparent">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <small class="text-muted">
                                            <i class="fas fa-clock me-1"></i>
                                            <fmt:formatDate value="${result.resultCreatedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </small>
                                        <a href="?action=detail&resultId=${result.resultId}" 
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
                    ${currentPage * pageSize > totalResults ? totalResults : currentPage * pageSize} 
                    trong tổng số ${totalResults} kết quả
                </small>
            </div>
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
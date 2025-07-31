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
        
        /* New styles for patient and nurse info */
        .patient-info {
            background-color: #e8f4fd;
            border-radius: 8px;
            padding: 0.8rem;
            border-left: 4px solid #0d6efd;
        }
        
        .nurse-info {
            background-color: #f0f9f0;
            border-radius: 8px;
            padding: 0.8rem;
            border-left: 4px solid #198754;
        }
        
        .info-item {
            display: flex;
            align-items: center;
            margin-bottom: 0.5rem;
        }
        
        .info-item:last-child {
            margin-bottom: 0;
        }
        
        .info-icon {
            width: 20px;
            text-align: center;
            margin-right: 0.5rem;
        }
        
        /* Enhanced Pagination Styles */
        .custom-pagination {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px;
            padding: 20px;
            margin: 30px 0;
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.15);
        }
        
        .custom-pagination .pagination {
            margin: 0;
            gap: 8px;
        }
        
        .custom-pagination .page-link {
            border: none;
            border-radius: 10px;
            padding: 12px 16px;
            color: #4a5568;
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            font-weight: 500;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        
        .custom-pagination .page-link:hover {
            background: #fff;
            color: #667eea;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }
        
        .custom-pagination .page-item.active .page-link {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border: none;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
            transform: scale(1.1);
        }
        
        .custom-pagination .page-item.disabled .page-link {
            background: rgba(255, 255, 255, 0.4);
            color: #a0aec0;
            cursor: not-allowed;
        }
        
        .pagination-info {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 10px 20px;
            margin-top: 15px;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .pagination-info-text {
            color: white;
            font-weight: 500;
            margin: 0;
            text-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);
        }
        
        /* Navigation improvements */
        .pagination-nav-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 45px;
            height: 45px;
            border-radius: 50%;
            font-size: 16px;
        }
        
        .pagination-ellipsis {
            display: flex;
            align-items: center;
            justify-content: center;
            height: 45px;
            color: rgba(255, 255, 255, 0.7);
            font-weight: bold;
        }
    </style>
</head>
<body class="bg-light">
    <!-- Navigation Bar (removed logout button) -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="#">
                <i class="fas fa-clinic-medical me-2"></i>
                Phòng khám ABC
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="${pageContext.request.contextPath}/views/user/Patient/PatientDashBoard.jsp">
                    <i class="fas fa-home me-1"></i>Trang chủ
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

                                    <!-- Patient Info -->
                                    <div class="patient-info mb-3">
                                        <div class="info-item">
                                            <i class="fas fa-user info-icon text-primary"></i>
                                            <strong>Bệnh nhân: ${result.patientName}</strong>
                                        </div>
                                    </div>

                                    <!-- Doctor and Service Info -->
                                    <div class="doctor-info mb-3">
                                        <div class="info-item">
                                            <i class="fas fa-user-md info-icon text-primary"></i>
                                            <strong>BS: ${result.doctorName}</strong>
                                        </div>
                                        <c:if test="${not empty result.doctorSpecialization}">
                                            <div class="info-item">
                                                <i class="fas fa-stethoscope info-icon text-muted"></i>
                                                <small class="text-muted">${result.doctorSpecialization}</small>
                                            </div>
                                        </c:if>
                                        <div class="info-item">
                                            <i class="fas fa-medical-bag info-icon text-info"></i>
                                            <small>${result.serviceName}</small>
                                        </div>
                                    </div>

                                    <!-- Nurse Info -->
                                    <div class="nurse-info mb-3">
                                        <div class="info-item">
                                            <i class="fas fa-user-nurse info-icon text-success"></i>
                                            <strong>Y tá: 
                                                <c:choose>
                                                    <c:when test="${not empty result.nurseName and result.nurseName != 'N/A' and result.nurseName != 'Chưa gán y tá'}">
                                                        ${result.nurseName}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Chưa gán y tá</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </strong>
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

                                <!-- Card Footer - Chỉ hiển thị thời gian tạo -->
                                <div class="card-footer bg-transparent">
                                    <small class="text-muted">
                                        <i class="fas fa-clock me-1"></i>
                                        <fmt:formatDate value="${result.resultCreatedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </small>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Enhanced Pagination -->
        <c:if test="${totalPages > 1}">
            <div class="custom-pagination text-center">
                <nav aria-label="Page navigation">
                    <ul class="pagination justify-content-center">
                        <!-- Previous Button -->
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link pagination-nav-btn" href="?page=${currentPage - 1}&pageSize=${pageSize}" title="Trang trước">
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
                                    <span class="page-link pagination-ellipsis">⋯</span>
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
                                    <span class="page-link pagination-ellipsis">⋯</span>
                                </li>
                            </c:if>
                            <li class="page-item">
                                <a class="page-link" href="?page=${totalPages}&pageSize=${pageSize}">${totalPages}</a>
                            </li>
                        </c:if>

                        <!-- Next Button -->
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link pagination-nav-btn" href="?page=${currentPage + 1}&pageSize=${pageSize}" title="Trang sau">
                                <i class="fas fa-chevron-right"></i>
                            </a>
                        </li>
                    </ul>
                </nav>

                <!-- Enhanced Pagination Info -->
                <div class="pagination-info">
                    <p class="pagination-info-text">
                        <i class="fas fa-info-circle me-2"></i>
                        Hiển thị <strong>${(currentPage - 1) * pageSize + 1}</strong> - 
                        <strong>${currentPage * pageSize > totalResults ? totalResults : currentPage * pageSize}</strong> 
                        trong tổng số <strong>${totalResults}</strong> kết quả
                        <span class="ms-3">
                            <i class="fas fa-file-alt me-1"></i>
                            Trang <strong>${currentPage}</strong>/<strong>${totalPages}</strong>
                        </span>
                    </p>
                </div>
            </div>
        </c:if>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function changePageSize() {
            const pageSize = document.getElementById('pageSize').value;
            window.location.href = '?page=1&pageSize=' + pageSize;
        }

        // Enhanced pagination animation
        document.addEventListener('DOMContentLoaded', function() {
            const pageLinks = document.querySelectorAll('.custom-pagination .page-link');
            pageLinks.forEach(link => {
                link.addEventListener('mouseenter', function() {
                    if (!this.closest('.page-item').classList.contains('active') && 
                        !this.closest('.page-item').classList.contains('disabled')) {
                        this.style.transform = 'translateY(-2px) scale(1.05)';
                    }
                });
                
                link.addEventListener('mouseleave', function() {
                    if (!this.closest('.page-item').classList.contains('active')) {
                        this.style.transform = '';
                    }
                });
            });
        });
    </script>
</body>
</html>
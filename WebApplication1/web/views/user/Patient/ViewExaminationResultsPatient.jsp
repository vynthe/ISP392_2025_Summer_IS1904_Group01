<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết Quả Khám Bệnh - Hệ Thống Quản Lý Phòng Khám</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .header-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }
        .result-card {
            border: none;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: transform 0.2s, box-shadow 0.2s;
            border-left: 4px solid #007bff;
        }
        .result-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
        }
        .status-badge {
            font-size: 0.875rem;
            font-weight: 500;
        }
        .pagination-container {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-top: 2rem;
        }
        .no-results {
            text-align: center;
            padding: 3rem;
            color: #6c757d;
        }
        .search-info {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1.5rem;
        }
        .btn-view-detail {
            background: linear-gradient(45deg, #007bff, #0056b3);
            border: none;
            transition: all 0.3s;
        }
        .btn-view-detail:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(0,123,255,0.3);
        }
    </style>
</head>
<body class="bg-light">
    <!-- Header Section -->
    <div class="header-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <h2><i class="fas fa-file-medical-alt me-2"></i>Kết Quả Khám Bệnh</h2>
                    <p class="mb-0">Xem lại các kết quả khám bệnh của bạn</p>
                </div>
                <div class="col-md-6 text-md-end">
                    <a href="/views/user/Patient/PatientDashboard.jsp" class="btn btn-light">
                        <i class="fas fa-home me-1"></i>Về Trang Chủ
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <!-- Error Message -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>
                ${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Search Info -->
        <div class="search-info">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <h5 class="mb-1"><i class="fas fa-info-circle text-primary me-2"></i>Thông Tin</h5>
                    <p class="mb-0">Tổng cộng: <strong>${totalRecords}</strong> kết quả khám bệnh</p>
                </div>
                <div class="col-md-6 text-md-end">
                    <small class="text-muted">
                        Trang ${currentPage} / ${totalPages} 
                        (${pageSize} kết quả/trang)
                    </small>
                </div>
            </div>
        </div>

        <!-- Results List -->
        <c:choose>
            <c:when test="${empty examinationResults}">
                <div class="no-results">
                    <div class="card">
                        <div class="card-body">
                            <i class="fas fa-file-medical fa-3x text-muted mb-3"></i>
                            <h4>Chưa có kết quả khám bệnh</h4>
                            <p class="text-muted">Bạn chưa có kết quả khám bệnh nào được ghi nhận trong hệ thống.</p>
                            <a href="/views/user/Patient/AppointmentBooking.jsp" class="btn btn-primary">
                                <i class="fas fa-calendar-plus me-1"></i>Đặt Lịch Khám
                            </a>
                        </div>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row">
                    <c:forEach var="result" items="${examinationResults}" varStatus="status">
                        <div class="col-12 mb-3">
                            <div class="card result-card h-100">
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-8">
                                            <div class="d-flex justify-content-between align-items-start mb-2">
                                                <h5 class="card-title mb-1">
                                                    <i class="fas fa-user-md text-primary me-2"></i>
                                                    ${result.doctorName}
                                                </h5>
                                                <span class="badge ${result.resultStatus == 'Completed' ? 'bg-success' : result.resultStatus == 'Pending' ? 'bg-warning' : 'bg-secondary'} status-badge">
                                                    <c:choose>
                                                        <c:when test="${result.resultStatus == 'Completed'}">Hoàn thành</c:when>
                                                        <c:when test="${result.resultStatus == 'Pending'}">Đang chờ</c:when>
                                                        <c:otherwise>${result.resultStatus}</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            
                                            <p class="text-muted mb-2">
                                                <i class="fas fa-stethoscope me-1"></i>
                                                Chuyên khoa: ${result.doctorSpecialization}
                                            </p>
                                            
                                            <div class="row mb-2">
                                                <div class="col-sm-6">
                                                    <small class="text-muted">
                                                        <i class="fas fa-calendar me-1"></i>
                                                        Ngày khám: 
                                                        <fmt:formatDate value="${result.slotDate}" pattern="dd/MM/yyyy"/>
                                                    </small>
                                                </div>
                                                <div class="col-sm-6">
                                                    <small class="text-muted">
                                                        <i class="fas fa-clock me-1"></i>
                                                        Giờ: 
                                                        <fmt:formatDate value="${result.startTime}" pattern="HH:mm"/> - 
                                                        <fmt:formatDate value="${result.endTime}" pattern="HH:mm"/>
                                                    </small>
                                                </div>
                                            </div>
                                            
                                            <p class="mb-2">
                                                <strong>Dịch vụ:</strong> ${result.serviceName}
                                                <span class="text-success ms-2">
                                                    <fmt:formatNumber value="${result.servicePrice}" type="currency" currencySymbol="₫"/>
                                                </span>
                                            </p>
                                            
                                            <p class="mb-2">
                                                <strong>Phòng khám:</strong> ${result.roomName}
                                            </p>
                                            
                                            <c:if test="${not empty result.diagnosis and result.diagnosis != 'Chưa có chẩn đoán'}">
                                                <p class="mb-2">
                                                    <strong>Chẩn đoán:</strong> 
                                                    <span class="text-primary">${result.diagnosis}</span>
                                                </p>
                                            </c:if>
                                        </div>
                                        <div class="col-md-4 text-md-end">
                                            <div class="mb-3">
                                                <small class="text-muted d-block">Tạo lúc:</small>
                                                <strong>
                                                    <fmt:formatDate value="${result.resultCreatedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                </strong>
                                            </div>
                                            
                                            <a href="ViewExaminationResultsPatient?action=detail&resultId=${result.resultId}" 
                                               class="btn btn-primary btn-view-detail">
                                                <i class="fas fa-eye me-1"></i>Xem Chi Tiết
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <div class="pagination-container">
                        <nav aria-label="Phân trang kết quả khám bệnh">
                            <ul class="pagination pagination-lg">
                                <!-- Previous Page -->
                                <c:if test="${hasPreviousPage}">
                                    <li class="page-item">
                                        <a class="page-link" href="ViewExaminationResultsPatient?page=${previousPage}&pageSize=${pageSize}">
                                            <i class="fas fa-chevron-left"></i>
                                        </a>
                                    </li>
                                </c:if>
                                
                                <!-- Page Numbers -->
                                <c:forEach begin="${currentPage > 3 ? currentPage - 2 : 1}" 
                                          end="${currentPage + 2 > totalPages ? totalPages : currentPage + 2}" 
                                          var="pageNum">
                                    <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                        <a class="page-link" href="ViewExaminationResultsPatient?page=${pageNum}&pageSize=${pageSize}">
                                            ${pageNum}
                                        </a>
                                    </li>
                                </c:forEach>
                                
                                <!-- Next Page -->
                                <c:if test="${hasNextPage}">
                                    <li class="page-item">
                                        <a class="page-link" href="ViewExaminationResultsPatient?page=${nextPage}&pageSize=${pageSize}">
                                            <i class="fas fa-chevron-right"></i>
                                        </a>
                                    </li>
                                </c:if>
                            </ul>
                        </nav>
                    </div>
                </c:if>
            </c:otherwise>
        </c:choose>

        <!-- Page Size Selector -->
        <c:if test="${totalRecords > 0}">
            <div class="row mt-3">
                <div class="col-md-6 offset-md-6">
                    <div class="d-flex align-items-center justify-content-md-end">
                        <label class="form-label me-2 mb-0">Hiển thị:</label>
                        <select class="form-select form-select-sm" style="width: auto;" onchange="changePageSize(this.value)">
                            <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                            <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                            <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                            <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                        </select>
                        <span class="ms-2 small text-muted">kết quả/trang</span>
                    </div>
                </div>
            </div>
        </c:if>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        function changePageSize(pageSize) {
            window.location.href = 'ViewExaminationResultsPatient?page=1&pageSize=' + pageSize;
        }

        // Auto dismiss alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    </script>
</body>
</html>
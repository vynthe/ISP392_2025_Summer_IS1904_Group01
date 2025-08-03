<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý đánh giá - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --success-gradient: linear-gradient(135deg, #84fab0 0%, #8fd3f4 100%);
            --warning-gradient: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%);
            --danger-gradient: linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%);
            --card-shadow: 0 10px 30px rgba(0,0,0,0.1);
            --border-radius: 15px;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }

        .main-header {
            background: var(--primary-gradient);
            border-radius: var(--border-radius);
            box-shadow: var(--card-shadow);
            margin-bottom: 2rem;
            overflow: hidden;
        }

        .search-filters {
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--card-shadow);
            padding: 1.5rem;
            margin-bottom: 2rem;
        }

        .search-input {
            border: 2px solid #e9ecef;
            border-radius: 10px;
            padding: 12px 15px;
            transition: all 0.3s ease;
        }

        .search-input:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }

        .filter-btn {
            border-radius: 25px;
            padding: 8px 20px;
            border: 2px solid #e9ecef;
            background: white;
            color: #6c757d;
            transition: all 0.3s ease;
            margin: 0 5px 10px 0;
        }

        .filter-btn:hover, .filter-btn.active {
            background: var(--primary-gradient);
            border-color: transparent;
            color: white;
            transform: translateY(-2px);
        }

        .star-filter {
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .star-filter:hover .fa-star {
            color: #ffc107 !important;
        }

        .review-card {
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--card-shadow);
            margin-bottom: 1.5rem;
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .review-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
        }

        .review-header {
            background: var(--primary-gradient);
            color: white;
            padding: 1.5rem;
        }

        .review-body {
            padding: 1.5rem;
        }

        .star-rating {
            color: #ffc107;
            font-size: 1.1rem;
        }

        .rating-card {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
            border-left: 4px solid #667eea;
        }

        .info-badge {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
            display: inline-block;
            margin-bottom: 10px;
        }

        .doctor-badge {
            background: linear-gradient(135deg, #84fab0 0%, #8fd3f4 100%);
        }

        .service-badge {
            background: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%);
            color: #8b5a3c;
        }

        .comment-section {
            background: linear-gradient(135deg, #f1f3f4 0%, #ffffff 100%);
            border-radius: 10px;
            padding: 1.2rem;
            margin-top: 1rem;
            border-left: 4px solid #17a2b8;
        }

        .reply-section {
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            border-left: 4px solid #28a745;
            padding: 1.2rem;
            margin-top: 1rem;
            border-radius: 0 10px 10px 0;
        }

        .reply-form, .edit-reply-form {
            background: linear-gradient(135deg, #fff3cd 0%, #ffeaa7 100%);
            border: 2px dashed #ffc107;
            border-radius: 12px;
            padding: 1.5rem;
            margin-top: 1rem;
        }

        .stats-card {
            border-radius: var(--border-radius);
            box-shadow: var(--card-shadow);
            transition: transform 0.3s ease;
            overflow: hidden;
        }

        .stats-card:hover {
            transform: translateY(-3px);
        }

        .stats-card .card-body {
            padding: 1.5rem;
        }

        .btn-modern {
            border-radius: 25px;
            padding: 10px 25px;
            font-weight: 500;
            transition: all 0.3s ease;
            border: none;
        }

        .btn-modern:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }

        .no-reviews {
            text-align: center;
            color: #6c757d;
            padding: 3rem;
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--card-shadow);
        }

        .breadcrumb-custom {
            background: white;
            border-radius: 10px;
            padding: 1rem 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .breadcrumb-custom a {
            color: #667eea;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .breadcrumb-custom a:hover {
            color: #5a6fd8;
        }

        .alert-modern {
            border-radius: 12px;
            border: none;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .search-section {
            position: sticky;
            top: 20px;
            z-index: 100;
        }

        @media (max-width: 768px) {
            .review-card {
                margin-bottom: 1rem;
            }
            
            .search-filters {
                padding: 1rem;
            }
            
            .filter-btn {
                margin: 2px;
                padding: 6px 12px;
                font-size: 0.85rem;
            }
        }

        .fade-in {
            animation: fadeIn 0.5s ease-in;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
    <div class="container-fluid px-4 py-3">
        <!-- Breadcrumb -->
        <nav class="breadcrumb-custom">
            <i class="fas fa-home me-2"></i>
            <a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp">Trang Chủ</a>
            <span class="mx-2">></span>
            <span class="text-muted">Quản Lý Đánh Giá</span>
        </nav>

        <!-- Header -->
        <div class="main-header">
            <div class="row g-0">
                <div class="col-12">
                    <div class="card-body text-white p-4">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h1 class="mb-2">
                                    <i class="fas fa-comments me-3"></i>
                                    Quản lý đánh giá
                                </h1>
                                <p class="mb-0 opacity-75">Xem và phản hồi đánh giá từ bệnh nhân</p>
                            </div>
                            <div class="text-end">
                                <span class="badge bg-light text-dark fs-6 px-3 py-2">
                                    <i class="fas fa-crown me-1"></i>
                                    ADMIN PANEL
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Alerts -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-modern alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>
                <strong>Lỗi!</strong> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${not empty success}">
            <div class="alert alert-success alert-modern alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>
                <strong>Thành công!</strong> ${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Statistics -->
        <div class="row mb-4">
            <div class="col-lg-3 col-md-6 mb-3">
                <div class="card stats-card bg-primary text-white">
                    <div class="card-body text-center">
                        <i class="fas fa-comments fa-2x mb-3"></i>
                        <h3 class="fw-bold">${reviews.size()}</h3>
                        <p class="mb-0">Tổng đánh giá</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-3">
                <div class="card stats-card bg-success text-white">
                    <div class="card-body text-center">
                        <i class="fas fa-reply fa-2x mb-3"></i>
                        <h3 class="fw-bold">
                            <c:set var="repliedCount" value="0"/>
                            <c:forEach var="review" items="${reviews}">
                                <c:if test="${not empty review.replies}">
                                    <c:set var="repliedCount" value="${repliedCount + 1}"/>
                                </c:if>
                            </c:forEach>
                            ${repliedCount}
                        </h3>
                        <p class="mb-0">Đã phản hồi</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-3">
                <div class="card stats-card bg-warning text-white">
                    <div class="card-body text-center">
                        <i class="fas fa-clock fa-2x mb-3"></i>
                        <h3 class="fw-bold">${reviews.size() - repliedCount}</h3>
                        <p class="mb-0">Chưa phản hồi</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-3">
                <div class="card stats-card bg-info text-white">
                    <div class="card-body text-center">
                        <i class="fas fa-star fa-2x mb-3"></i>
                        <h3 class="fw-bold">
                            <c:set var="totalRating" value="0"/>
                            <c:set var="reviewCount" value="${reviews.size()}"/>
                            <c:forEach var="review" items="${reviews}">
                                <c:set var="totalRating" value="${totalRating + (review.serviceRating + review.doctorRating) / 2}"/>
                            </c:forEach>
                            <c:choose>
                                <c:when test="${reviewCount > 0}">
                                    <fmt:formatNumber value="${totalRating / reviewCount}" maxFractionDigits="1"/>
                                </c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </h3>
                        <p class="mb-0">Điểm trung bình</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Search and Filter Section -->
        <div class="search-section">
            <div class="search-filters">
                <div class="row g-3">
                    <div class="col-lg-6">
                        <div class="input-group">
                            <span class="input-group-text bg-white border-end-0">
                                <i class="fas fa-search text-muted"></i>
                            </span>
                            <input type="text" id="searchDoctor" class="form-control search-input border-start-0" 
                                   placeholder="Tìm kiếm theo tên bác sĩ...">
                        </div>
                    </div>
                    <div class="col-lg-6">
                        <div class="input-group">
                            <span class="input-group-text bg-white border-end-0">
                                <i class="fas fa-user-injured text-muted"></i>
                            </span>
                            <input type="text" id="searchPatient" class="form-control search-input border-start-0" 
                                   placeholder="Tìm kiếm theo tên bệnh nhân...">
                        </div>
                    </div>
                </div>
                
                <div class="row mt-3">
                    <div class="col-12">
                        <label class="form-label fw-semibold">
                            <i class="fas fa-star text-warning me-1"></i>
                            Lọc theo số sao:
                        </label>
                        <div class="d-flex flex-wrap">
                            <button class="filter-btn active" data-rating="all">
                                <i class="fas fa-list me-1"></i>Tất cả
                            </button>
                            <button class="filter-btn star-filter" data-rating="5">
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                                <span class="ms-1">5 sao</span>
                            </button>
                            <button class="filter-btn star-filter" data-rating="4">
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-muted"></i>
                                <span class="ms-1">4 sao</span>
                            </button>
                            <button class="filter-btn star-filter" data-rating="3">
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-muted"></i>
                                <i class="fas fa-star text-muted"></i>
                                <span class="ms-1">3 sao</span>
                            </button>
                            <button class="filter-btn star-filter" data-rating="2">
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-muted"></i>
                                <i class="fas fa-star text-muted"></i>
                                <i class="fas fa-star text-muted"></i>
                                <span class="ms-1">2 sao</span>
                            </button>
                            <button class="filter-btn star-filter" data-rating="1">
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-muted"></i>
                                <i class="fas fa-star text-muted"></i>
                                <i class="fas fa-star text-muted"></i>
                                <i class="fas fa-star text-muted"></i>
                                <span class="ms-1">1 sao</span>
                            </button>
                        </div>
                    </div>
                </div>

                <div class="row mt-3">
                    <div class="col-12">
                        <label class="form-label fw-semibold">
                            <i class="fas fa-filter me-1"></i>
                            Lọc theo trạng thái:
                        </label>
                        <div class="d-flex flex-wrap">
                            <button class="filter-btn active" data-status="all">
                                <i class="fas fa-list me-1"></i>Tất cả
                            </button>
                            <button class="filter-btn" data-status="replied">
                                <i class="fas fa-check-circle me-1"></i>Đã phản hồi
                            </button>
                            <button class="filter-btn" data-status="pending">
                                <i class="fas fa-clock me-1"></i>Chưa phản hồi
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Reviews List -->
        <div class="row">
            <div class="col-12">
                <div id="reviewsContainer">
                    <c:choose>
                        <c:when test="${empty reviews}">
                            <div class="no-reviews fade-in">
                                <i class="fas fa-comments fa-4x mb-4 text-muted"></i>
                                <h4 class="text-muted">Chưa có đánh giá nào</h4>
                                <p class="text-muted">Hiện tại chưa có đánh giá nào từ bệnh nhân.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="review" items="${reviews}">
                                <div class="review-card fade-in" 
                                     data-doctor="${review.doctorFullName}" 
                                     data-patient="${review.userFullName}"
                                     data-service-rating="${review.serviceRating}"
                                     data-doctor-rating="${review.doctorRating}"
                                     data-status="${empty review.replies ? 'pending' : 'replied'}">
                                    <div class="review-header">
                                        <div class="row align-items-center">
                                            <div class="col-lg-8">
                                                <h5 class="mb-2">
                                                    <i class="fas fa-user-injured me-2"></i>
                                                    ${review.userFullName}
                                                </h5>
                                                <p class="mb-0 opacity-75">
                                                    <i class="fas fa-calendar-alt me-1"></i>
                                                    <fmt:formatDate value="${review.createdAt}" pattern="dd/MM/yyyy"/>
                                                    <i class="fas fa-clock ms-3 me-1"></i>
                                                    <fmt:formatDate value="${review.createdAt}" pattern="HH:mm"/>
                                                </p>
                                            </div>
                                            <div class="col-lg-4 text-lg-end text-start mt-2 mt-lg-0">
                                                <span class="badge bg-light text-dark fs-6 px-3 py-2">
                                                    ID: ${review.reviewID}
                                                </span>
                                                <c:choose>
                                                    <c:when test="${empty review.replies}">
                                                        <span class="badge bg-warning ms-2 fs-6 px-3 py-2">
                                                            <i class="fas fa-clock me-1"></i>Chưa phản hồi
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-success ms-2 fs-6 px-3 py-2">
                                                            <i class="fas fa-check-circle me-1"></i>Đã phản hồi
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="review-body">
                                        <!-- Doctor and Service Info -->
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <div class="info-badge doctor-badge">
                                                    <i class="fas fa-user-md me-2"></i>
                                                    BS. ${review.doctorFullName}
                                                </div>
                                            </div>
                                            <c:if test="${not empty review.serviceName}">
                                                <div class="col-md-6">
                                                    <div class="info-badge service-badge">
                                                        <i class="fas fa-stethoscope me-2"></i>
                                                        ${review.serviceName}
                                                    </div>
                                                </div>
                                            </c:if>
                                        </div>

                                        <!-- Ratings -->
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <div class="rating-card">
                                                    <div class="d-flex justify-content-between align-items-center">
                                                        <strong>
                                                            <i class="fas fa-stethoscope text-primary me-2"></i>
                                                            Đánh giá dịch vụ
                                                        </strong>
                                                        <div class="star-rating">
                                                            <c:forEach begin="1" end="5" var="i">
                                                                <i class="fas fa-star ${i <= review.serviceRating ? 'text-warning' : 'text-muted'}"></i>
                                                            </c:forEach>
                                                            <span class="ms-2 fw-bold">${review.serviceRating}/5</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="rating-card">
                                                    <div class="d-flex justify-content-between align-items-center">
                                                        <strong>
                                                            <i class="fas fa-user-md text-success me-2"></i>
                                                            Đánh giá bác sĩ
                                                        </strong>
                                                        <div class="star-rating">
                                                            <c:forEach begin="1" end="5" var="i">
                                                                <i class="fas fa-star ${i <= review.doctorRating ? 'text-warning' : 'text-muted'}"></i>
                                                            </c:forEach>
                                                            <span class="ms-2 fw-bold">${review.doctorRating}/5</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Comment -->
                                        <c:if test="${not empty review.comment}">
                                            <div class="comment-section">
                                                <div class="d-flex justify-content-between align-items-start mb-3">
                                                    <h6 class="fw-semibold mb-0">
                                                        <i class="fas fa-comment text-info me-2"></i>
                                                        Nhận xét từ bệnh nhân
                                                    </h6>
                                                    <button class="btn btn-danger btn-sm btn-modern delete-comment-btn" 
                                                            data-review-id="${review.reviewID}"
                                                            data-bs-toggle="tooltip" 
                                                            title="Xóa nhận xét">
                                                        <i class="fas fa-trash me-2"></i>Xóa
                                                    </button>
                                                </div>
                                                <div class="position-relative">
                                                    <i class="fas fa-quote-left text-muted position-absolute" style="top: -5px; left: -5px;"></i>
                                                    <p class="mb-0 ps-3 pe-3 font-italic">${review.comment}</p>
                                                    <i class="fas fa-quote-right text-muted position-absolute" style="bottom: -5px; right: -5px;"></i>
                                                </div>
                                            </div>
                                        </c:if>

                                        <!-- Display existing replies -->
                                        <c:if test="${not empty review.replies}">
                                            <c:forEach var="reply" items="${review.replies}">
                                                <div class="reply-section" id="reply-${reply.replyID}">
                                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                                        <h6 class="fw-semibold mb-0">
                                                            <i class="fas fa-user-shield text-success me-2"></i>
                                                            Phản hồi từ ${reply.userFullName}
                                                            <span class="badge bg-success ms-2">Admin</span>
                                                        </h6>
                                                        <div>
                                                            <button class="btn btn-warning btn-sm btn-modern edit-reply-btn me-2"
                                                                    data-reply-id="${reply.replyID}"
                                                                    data-review-id="${review.reviewID}"
                                                                    data-comment="${reply.comment}"
                                                                    data-bs-toggle="tooltip"
                                                                    title="Sửa phản hồi">
                                                                <i class="fas fa-edit me-2"></i>Sửa
                                                            </button>
                                                            <button class="btn btn-danger btn-sm btn-modern delete-reply-btn"
                                                                    data-reply-id="${reply.replyID}"
                                                                    data-review-id="${review.reviewID}"
                                                                    data-bs-toggle="tooltip"
                                                                    title="Xóa phản hồi">
                                                                <i class="fas fa-trash me-2"></i>Xóa
                                                            </button>
                                                        </div>
                                                    </div>
                                                    <p class="mb-0">${reply.comment}</p>
                                                </div>
                                            </c:forEach>
                                        </c:if>

                                        <!-- Edit reply form (hidden by default) -->
                                        <c:if test="${not empty review.replies}">
                                            <div class="edit-reply-form d-none" id="edit-reply-form-${review.reviewID}">
                                                <h6 class="text-warning fw-semibold mb-3">
                                                    <i class="fas fa-edit me-2"></i>
                                                    Sửa phản hồi
                                                </h6>
                                                <form method="post" action="${pageContext.request.contextPath}/ReviewManagementServlet">
                                                    <input type="hidden" name="action" value="editReply">
                                                    <input type="hidden" name="reviewId" value="${review.reviewID}">
                                                    <input type="hidden" name="replyId" value="">
                                                    <div class="mb-3">
                                                        <label for="editReplyContent${review.reviewID}" class="form-label fw-semibold">
                                                            <i class="fas fa-pen me-1"></i>
                                                            Nội dung phản hồi:
                                                        </label>
                                                        <textarea class="form-control search-input" 
                                                                  id="editReplyContent${review.reviewID}" 
                                                                  name="replyContent" 
                                                                  rows="4" 
                                                                  required
                                                                  placeholder="Nhập nội dung phản hồi chuyên nghiệp và thân thiện..."></textarea>
                                                    </div>
                                                    <div class="text-end">
                                                        <button type="button" class="btn btn-secondary btn-modern cancel-edit-btn me-2">
                                                            <i class="fas fa-times me-2"></i>Hủy
                                                        </button>
                                                        <button type="submit" class="btn btn-success btn-modern">
                                                            <i class="fas fa-save me-2"></i>Lưu thay đổi
                                                        </button>
                                                    </div>
                                                </form>
                                            </div>
                                        </c:if>

                                        <!-- Reply form for admin -->
                                        <c:if test="${empty review.replies}">
                                            <div class="reply-form">
                                                <h6 class="text-warning fw-semibold mb-3">
                                                    <i class="fas fa-reply me-2"></i>
                                                    Phản hồi đánh giá này
                                                </h6>
                                                <form method="post" action="${pageContext.request.contextPath}/ReviewManagementServlet">
                                                    <input type="hidden" name="action" value="addReply">
                                                    <input type="hidden" name="reviewId" value="${review.reviewID}">
                                                    <div class="mb-3">
                                                        <label for="replyContent${review.reviewID}" class="form-label fw-semibold">
                                                            <i class="fas fa-pen me-1"></i>
                                                            Nội dung phản hồi:
                                                        </label>
                                                        <textarea class="form-control search-input" 
                                                                  id="replyContent${review.reviewID}" 
                                                                  name="replyContent" 
                                                                  rows="4" 
                                                                  required
                                                                  placeholder="Nhập nội dung phản hồi chuyên nghiệp và thân thiện..."></textarea>
                                                    </div>
                                                    <div class="text-end">
                                                        <button type="submit" class="btn btn-success btn-modern">
                                                            <i class="fas fa-paper-plane me-2"></i>Gửi phản hồi
                                                        </button>
                                                    </div>
                                                </form>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- No results message -->
                <div id="noResults" class="no-reviews" style="display: none;">
                    <i class="fas fa-search fa-4x mb-4 text-muted"></i>
                    <h4 class="text-muted">Không tìm thấy kết quả</h4>
                    <p class="text-muted">Không có đánh giá nào phù hợp với tiêu chí tìm kiếm.</p>
                </div>

                <!-- Navigation -->
                <div class="text-center mt-5 mb-4">
                    <div class="d-flex flex-wrap justify-content-center gap-3">
                        <a href="${pageContext.request.contextPath}/ViewReviewsServlet" 
                           class="btn btn-outline-primary btn-modern">
                            <i class="fas fa-eye me-2"></i>
                            Xem giao diện công khai
                        </a>
                        <a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp" 
                           class="btn btn-outline-secondary btn-modern">
                            <i class="fas fa-tachometer-alt me-2"></i>
                            Về dashboard
                        </a>
                        <button class="btn btn-outline-info btn-modern" onclick="exportReviews()">
                            <i class="fas fa-download me-2"></i>
                            Xuất báo cáo
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Loading Spinner -->
    <div id="loadingSpinner" class="d-none position-fixed top-50 start-50 translate-middle">
        <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Đang tải...</span>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Auto dismiss alerts after 5 seconds
            setTimeout(function() {
                const alerts = document.querySelectorAll('.alert');
                alerts.forEach(alert => {
                    if (alert.classList.contains('show')) {
                        const bsAlert = new bootstrap.Alert(alert);
                        bsAlert.close();
                    }
                });
            }, 5000);

            // Search and Filter functionality
            const searchDoctor = document.getElementById('searchDoctor');
            const searchPatient = document.getElementById('searchPatient');
            const filterBtns = document.querySelectorAll('.filter-btn');
            const reviewCards = document.querySelectorAll('.review-card');
            const noResults = document.getElementById('noResults');
            const reviewsContainer = document.getElementById('reviewsContainer');

            let currentFilters = {
                doctorName: '',
                patientName: '',
                rating: 'all',
                status: 'all'
            };

            // Search by doctor name
            searchDoctor.addEventListener('input', function(e) {
                currentFilters.doctorName = e.target.value.toLowerCase();
                filterReviews();
            });

            // Search by patient name
            searchPatient.addEventListener('input', function(e) {
                currentFilters.patientName = e.target.value.toLowerCase();
                filterReviews();
            });

            // Filter buttons
            filterBtns.forEach(btn => {
                btn.addEventListener('click', function() {
                    const filterType = this.hasAttribute('data-rating') ? 'rating' : 'status';
                    const filterValue = this.getAttribute('data-rating') || this.getAttribute('data-status');
                    
                    const siblingBtns = filterType === 'rating' 
                        ? document.querySelectorAll('[data-rating]')
                        : document.querySelectorAll('[data-status]');
                    
                    siblingBtns.forEach(sibling => sibling.classList.remove('active'));
                    this.classList.add('active');
                    
                    currentFilters[filterType] = filterValue;
                    filterReviews();
                });
            });

            function filterReviews() {
                let visibleCount = 0;
                
                reviewCards.forEach(card => {
                    const doctorName = card.getAttribute('data-doctor').toLowerCase();
                    const patientName = card.getAttribute('data-patient').toLowerCase();
                    const serviceRating = parseInt(card.getAttribute('data-service-rating'));
                    const doctorRating = parseInt(card.getAttribute('data-doctor-rating'));
                    const avgRating = Math.round((serviceRating + doctorRating) / 2);
                    const status = card.getAttribute('data-status');

                    let shouldShow = true;

                    if (currentFilters.doctorName && !doctorName.includes(currentFilters.doctorName)) {
                        shouldShow = false;
                    }

                    if (currentFilters.patientName && !patientName.includes(currentFilters.patientName)) {
                        shouldShow = false;
                    }

                    if (currentFilters.rating !== 'all' && avgRating != currentFilters.rating) {
                        shouldShow = false;
                    }

                    if (currentFilters.status !== 'all' && status !== currentFilters.status) {
                        shouldShow = false;
                    }

                    if (shouldShow) {
                        card.style.display = 'block';
                        card.classList.add('fade-in');
                        visibleCount++;
                    } else {
                        card.style.display = 'none';
                        card.classList.remove('fade-in');
                    }
                });

                if (visibleCount === 0 && reviewCards.length > 0) {
                    noResults.style.display = 'block';
                } else {
                    noResults.style.display = 'none';
                }

                updateVisibleStats(visibleCount);
            }

            function updateVisibleStats(visibleCount) {
                let repliedCount = 0;
                let totalRating = 0;
                let ratingCount = 0;

                reviewCards.forEach(card => {
                    if (card.style.display !== 'none') {
                        const status = card.getAttribute('data-status');
                        const serviceRating = parseInt(card.getAttribute('data-service-rating'));
                        const doctorRating = parseInt(card.getAttribute('data-doctor-rating'));
                        
                        if (status === 'replied') {
                            repliedCount++;
                        }
                        
                        totalRating += (serviceRating + doctorRating) / 2;
                        ratingCount++;
                    }
                });
            }

            // Export functionality
            window.exportReviews = function() {
                const loadingSpinner = document.getElementById('loadingSpinner');
                loadingSpinner.classList.remove('d-none');
                
                setTimeout(function() {
                    loadingSpinner.classList.add('d-none');
                    
                    let csvContent = "data:text/csv;charset=utf-8,";
                    csvContent += "ID,Bệnh nhân,Bác sĩ,Dịch vụ,Điểm dịch vụ,Điểm bác sĩ,Nhận xét,Ngày tạo,Trạng thái\n";
                    
                    reviewCards.forEach(card => {
                        if (card.style.display !== 'none') {
                            const reviewId = card.querySelector('.badge').textContent.replace('ID: ', '');
                            const patientName = card.getAttribute('data-patient');
                            const doctorName = card.getAttribute('data-doctor');
                            const serviceRating = card.getAttribute('data-service-rating');
                            const doctorRating = card.getAttribute('data-doctor-rating');
                            const status = card.getAttribute('data-status') === 'replied' ? 'Đã phản hồi' : 'Chưa phản hồi';
                            const comment = card.querySelector('.comment-section p') ? 
                                          card.querySelector('.comment-section p').textContent.replace(/"/g, '""') : '';
                            const date = card.querySelector('.opacity-75').textContent.trim();
                            
                            const serviceBadge = card.querySelector('.service-badge');
                            const serviceName = serviceBadge ? serviceBadge.textContent.replace('🩺', '').trim() : '';
                            
                            csvContent += `"${reviewId}","${patientName}","${doctorName}","${serviceName}","${serviceRating}","${doctorRating}","${comment}","${date}","${status}"\n`;
                        }
                    });
                    
                    const encodedUri = encodeURI(csvContent);
                    const link = document.createElement("a");
                    link.setAttribute("href", encodedUri);
                    const today = new Date();
                    const dateStr = today.getFullYear() + '-' + 
                                  String(today.getMonth() + 1).padStart(2, '0') + '-' + 
                                  String(today.getDate()).padStart(2, '0');
                    link.setAttribute("download", `danh_gia_${dateStr}.csv`);
                    document.body.appendChild(link);
                    link.click();
                    document.body.removeChild(link);
                    
                    const alertDiv = document.createElement('div');
                    alertDiv.className = 'alert alert-success alert-modern alert-dismissible fade show position-fixed';
                    alertDiv.style.cssText = 'top: 20px; right: 20px; z-index: 9999; max-width: 400px;';
                    alertDiv.innerHTML = `
                        <i class="fas fa-check-circle me-2"></i>
                        <strong>Thành công!</strong> Đã xuất báo cáo đánh giá.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    `;
                    document.body.appendChild(alertDiv);
                    
                    setTimeout(() => {
                        if (alertDiv.parentNode) {
                            alertDiv.parentNode.removeChild(alertDiv);
                        }
                    }, 5000);
                }, 1500);
            };

            // Smooth scrolling
            document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                anchor.addEventListener('click', function(e) {
                    e.preventDefault();
                    const target = document.querySelector(this.getAttribute('href'));
                    if (target) {
                        target.scrollIntoView({
                            behavior: 'smooth',
                            block: 'start'
                        });
                    }
                });
            });

            // Hover effects for review cards
            reviewCards.forEach(card => {
                card.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-5px)';
                });
                
                card.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                });
            });

            // Form validation for reply and edit forms
            const replyForms = document.querySelectorAll('form[action*="ReviewManagementServlet"]');
            replyForms.forEach(form => {
                form.addEventListener('submit', function(e) {
                    const textarea = this.querySelector('textarea');
                    const content = textarea.value.trim();
                    
                    if (content.length < 10) {
                        e.preventDefault();
                        textarea.classList.add('is-invalid');
                        
                        let errorMsg = this.querySelector('.invalid-feedback');
                        if (!errorMsg) {
                            errorMsg = document.createElement('div');
                            errorMsg.className = 'invalid-feedback';
                            textarea.parentNode.appendChild(errorMsg);
                        }
                        errorMsg.textContent = 'Phản hồi phải có ít nhất 10 ký tự.';
                        
                        textarea.focus();
                        return false;
                    }
                    
                    const submitBtn = this.querySelector('button[type="submit"]');
                    const originalText = submitBtn.innerHTML;
                    submitBtn.disabled = true;
                    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang xử lý...';
                });
                
                const textarea = form.querySelector('textarea');
                textarea.addEventListener('input', function() {
                    this.classList.remove('is-invalid');
                    const errorMsg = form.querySelector('.invalid-feedback');
                    if (errorMsg) {
                        errorMsg.remove();
                    }
                });
            });

            // Edit reply functionality
            const editReplyButtons = document.querySelectorAll('.edit-reply-btn');
            editReplyButtons.forEach(btn => {
                btn.addEventListener('click', function() {
                    const replyId = this.getAttribute('data-reply-id');
                    const reviewId = this.getAttribute('data-review-id');
                    const comment = this.getAttribute('data-comment');
                    const editForm = document.getElementById(`edit-reply-form-${reviewId}`);
                    const textarea = editForm.querySelector('textarea');
                    const replyIdInput = editForm.querySelector('input[name="replyId"]');
                    
                    // Fill form with current reply content
                    textarea.value = comment;
                    replyIdInput.value = replyId;
                    
                    // Show edit form and hide reply section
                    editForm.classList.remove('d-none');
                    document.getElementById(`reply-${replyId}`).classList.add('d-none');
                });
            });

            // Cancel edit functionality
            const cancelEditButtons = document.querySelectorAll('.cancel-edit-btn');
            cancelEditButtons.forEach(btn => {
                btn.addEventListener('click', function() {
                    const editForm = this.closest('.edit-reply-form');
                    const replySection = editForm.previousElementSibling;
                    
                    // Hide edit form and show reply section
                    editForm.classList.add('d-none');
                    replySection.classList.remove('d-none');
                });
            });

            // Delete reply and comment functionality (handled by servlet)
            const deleteButtons = document.querySelectorAll('.delete-reply-btn, .delete-comment-btn');
            deleteButtons.forEach(btn => {
                btn.addEventListener('click', function() {
                    const isComment = this.classList.contains('delete-comment-btn');
                    const confirmMessage = isComment ? 'Bạn có chắc muốn xóa nhận xét này?' : 'Bạn có chắc muốn xóa phản hồi này?';
                    if (!confirm(confirmMessage)) return;
                    
                    // Form submission handled by servlet
                    const form = document.createElement('form');
                    form.method = 'post';
                    form.action = '${pageContext.request.contextPath}/ReviewManagementServlet';
                    
                    const actionInput = document.createElement('input');
                    actionInput.type = 'hidden';
                    actionInput.name = 'action';
                    actionInput.value = isComment ? 'deleteComment' : 'deleteReply';
                    form.appendChild(actionInput);
                    
                    const idInput = document.createElement('input');
                    idInput.type = 'hidden';
                    idInput.name = isComment ? 'reviewId' : 'replyId';
                    idInput.value = isComment ? this.getAttribute('data-review-id') : this.getAttribute('data-reply-id');
                    form.appendChild(idInput);
                    
                    if (!isComment) {
                        const reviewIdInput = document.createElement('input');
                        reviewIdInput.type = 'hidden';
                        reviewIdInput.name = 'reviewId';
                        reviewIdInput.value = this.getAttribute('data-review-id');
                        form.appendChild(reviewIdInput);
                    }
                    
                    document.body.appendChild(form);
                    form.submit();
                });
            });

            // Keyboard shortcuts
            document.addEventListener('keydown', function(e) {
                if ((e.ctrlKey || e.metaKey) && e.key === 'f') {
                    e.preventDefault();
                    searchDoctor.focus();
                }
                
                if (e.key === 'Escape') {
                    searchDoctor.value = '';
                    searchPatient.value = '';
                    currentFilters = {
                        doctorName: '',
                        patientName: '',
                        rating: 'all',
                        status: 'all'
                    };
                    
                    filterBtns.forEach(btn => btn.classList.remove('active'));
                    document.querySelector('[data-rating="all"]').classList.add('active');
                    document.querySelector('[data-status="all"]').classList.add('active');
                    
                    filterReviews();
                }
            });

            // Initialize tooltips
            if (typeof bootstrap !== 'undefined' && bootstrap.Tooltip) {
                const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                tooltipTriggerList.map(function(tooltipTriggerEl) {
                    return new bootstrap.Tooltip(tooltipTriggerEl);
                });
            }

            // Initialize with all reviews visible
            filterReviews();
        });
    </script>
    
    <div style="height: 100px;"></div>
    <jsp:include page="/assets/footer.jsp" />
</body>
</html>

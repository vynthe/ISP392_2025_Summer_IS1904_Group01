<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đánh giá từ bệnh nhân</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <!-- Animated Background -->
    <div class="background-animation"></div>
    
    <div class="container-fluid px-0">
        <!-- Hero Header -->
        <div class="breadcrumb">
                    <i class="fas fa-home"></i>
                    <a href="${pageContext.request.contextPath}/views/user/Patient/PatientDashBoard.jsp">Trang Chủ</a>
                    <span class="separator">></span>
                    <span class="current">Đánh Giá Dịch Vụ</span>

                </div>
        <div class="hero-header">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-lg-10">
                        <div class="hero-content">
                            <div class="hero-icon">
                                <i class="fas fa-comments"></i>
                            </div>
                            <h1 class="hero-title">Đánh giá từ bệnh nhân</h1>
                            <p class="hero-subtitle">
                                Khám phá những chia sẻ chân thực từ bệnh nhân về chất lượng dịch vụ
                            </p>
                            <div class="stats-container">
                                <div class="stat-item">
                                    <div class="stat-number">${reviews.size()}</div>
                                    <div class="stat-label">Đánh giá</div>
                                </div>
                                <div class="stat-divider"></div>
                                <div class="stat-item">
                                    <div class="stat-number">
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
                                    </div>
                                    <div class="stat-label">Điểm trung bình</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-lg-10">
                        <!-- Error Alert -->
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger custom-alert fade-in" role="alert">
                                <div class="alert-icon">
                                    <i class="fas fa-exclamation-triangle"></i>
                                </div>
                                <div class="alert-content">
                                    <strong>Lỗi!</strong> ${error}
                                </div>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Reviews Container -->
                        <div class="reviews-container">
                            <c:choose>
                                <c:when test="${empty reviews}">
                                    <!-- Empty State -->
                                    <div class="empty-state">
                                        <div class="empty-illustration">
                                            <div class="empty-icon">
                                                <i class="fas fa-comment-slash"></i>
                                            </div>
                                            <div class="empty-particles">
                                                <div class="particle particle-1"></div>
                                                <div class="particle particle-2"></div>
                                                <div class="particle particle-3"></div>
                                            </div>
                                        </div>
                                        <h3 class="empty-title">Chưa có đánh giá nào</h3>
                                        <p class="empty-description">
                                            Hãy trở thành người đầu tiên chia sẻ trải nghiệm của bạn về dịch vụ khám bệnh
                                        </p>
                                        <a href="${pageContext.request.contextPath}/SubmitReviewServlet" class="btn btn-primary btn-lg">
                                            <i class="fas fa-plus-circle"></i>
                                            Viết đánh giá đầu tiên
                                        </a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <!-- Filter Bar -->
                                    <div class="filter-bar">
                                        <div class="filter-group">
                                            <button class="filter-btn active" data-rating="all">
                                                <i class="fas fa-list"></i>
                                                Tất cả
                                            </button>
                                            <button class="filter-btn" data-rating="5">
                                                <i class="fas fa-star"></i>
                                                5 sao
                                            </button>
                                            <button class="filter-btn" data-rating="4">
                                                <i class="fas fa-star"></i>
                                                4 sao
                                            </button>
                                            <button class="filter-btn" data-rating="3">
                                                <i class="fas fa-star"></i>
                                                3 sao
                                            </button>
                                            <button class="filter-btn" data-rating="2">
                                                <i class="fas fa-star"></i>
                                                2 sao
                                            </button>
                                            <button class="filter-btn" data-rating="1">
                                                <i class="fas fa-star"></i>
                                                1 sao
                                            </button>
                                        </div>
                                    </div>

                                    <!-- Reviews List -->
                                    <div class="reviews-list">
                                        <div class="no-reviews-message" style="display: none;">
                                            <div class="empty-state">
                                                <div class="empty-illustration">
                                                    <div class="empty-icon">
                                                        <i class="fas fa-comment-slash"></i>
                                                    </div>
                                                    <div class="empty-particles">
                                                        <div class="particle particle-1"></div>
                                                        <div class="particle particle-2"></div>
                                                        <div class="particle particle-3"></div>
                                                    </div>
                                                </div>
                                                <h3 class="empty-title">Chưa có đánh giá nào cho <span class="rating-value"></span> sao</h3>
                                                <p class="empty-description">
                                                    Hãy trở thành người đầu tiên chia sẻ trải nghiệm của bạn về dịch vụ khám bệnh
                                                </p>
                                                <a href="${pageContext.request.contextPath}/SubmitReviewServlet" class="btn btn-primary btn-lg">
                                                    <i class="fas fa-plus-circle"></i>
                                                    Viết đánh giá
                                                </a>
                                            </div>
                                        </div>
                                        <c:forEach var="review" items="${reviews}" varStatus="status">
                                            <div class="review-card fade-in" style="animation-delay: ${status.index * 0.1}s" 
                                                 data-service-rating="${review.serviceRating}" data-doctor-rating="${review.doctorRating}"
                                                 data-created="${review.createdAt.time}">
                                                
                                                <!-- Review Header -->
                                                <div class="review-header">
                                                    <div class="reviewer-info">
                                                        <div class="reviewer-avatar">
                                                            <i class="fas fa-user"></i>
                                                        </div>
                                                        <div class="reviewer-details">
                                                            <h5 class="reviewer-name">${review.userFullName}</h5>
                                                            <div class="review-meta">
                                                                <span class="review-date">
                                                                    <i class="fas fa-clock"></i>
                                                                    <fmt:formatDate value="${review.createdAt}" pattern="dd/MM/yyyy"/>
                                                                </span>
                                                                <span class="review-id">ID: ${review.reviewID}</span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="review-actions">
                                                        <div class="dropdown">
                                                            <button class="action-btn" data-bs-toggle="dropdown">
                                                                <i class="fas fa-ellipsis-v"></i>
                                                            </button>
                                                            <ul class="dropdown-menu">
                                                                <li><a class="dropdown-item" href="#"><i class="fas fa-share"></i> Chia sẻ</a></li>
                                                                <li><a class="dropdown-item" href="#"><i class="fas fa-flag"></i> Báo cáo</a></li>
                                                            </ul>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Review Content -->
                                                <div class="review-content">
                                                    <!-- Service & Doctor Info -->
                                                    <div class="info-tags">
                                                        <div class="info-tag doctor-tag">
                                                            <i class="fas fa-user-md"></i>
                                                            <span>BS. ${review.doctorFullName}</span>
                                                        </div>
                                                        <c:if test="${not empty review.serviceName}">
                                                            <div class="info-tag service-tag">
                                                                <i class="fas fa-stethoscope"></i>
                                                                <span>${review.serviceName}</span>
                                                            </div>
                                                        </c:if>
                                                    </div>

                                                    <!-- Ratings -->
                                                    <div class="rating-section">
                                                        <div class="rating-item">
                                                            <div class="rating-label">
                                                                <i class="fas fa-star-half-alt"></i>
                                                                Dịch vụ
                                                            </div>
                                                            <div class="star-display">
                                                                <c:forEach begin="1" end="5" var="i">
                                                                    <i class="fas fa-star ${i <= review.serviceRating ? 'filled' : 'empty'}"></i>
                                                                </c:forEach>
                                                                <span class="rating-score">${review.serviceRating}.0</span>
                                                            </div>
                                                        </div>
                                                        <div class="rating-item">
                                                            <div class="rating-label">
                                                                <i class="fas fa-user-md"></i>
                                                                Bác sĩ
                                                            </div>
                                                            <div class="star-display">
                                                                <c:forEach begin="1" end="5" var="i">
                                                                    <i class="fas fa-star ${i <= review.doctorRating ? 'filled' : 'empty'}"></i>
                                                                </c:forEach>
                                                                <span class="rating-score">${review.doctorRating}.0</span>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Comment -->
                                                    <c:if test="${not empty review.comment}">
                                                        <div class="comment-section">
                                                            <div class="comment-content">
                                                                <div class="quote-icon">
                                                                    <i class="fas fa-quote-left"></i>
                                                                </div>
                                                                <p class="comment-text">${review.comment}</p>
                                                            </div>
                                                        </div>
                                                    </c:if>

                                                    <!-- Replies -->
                                                    <c:if test="${not empty review.replies}">
                                                        <div class="replies-section">
                                                            <h6 class="replies-title">
                                                                <i class="fas fa-reply"></i>
                                                                Phản hồi từ phòng khám
                                                            </h6>
                                                            <c:forEach var="reply" items="${review.replies}">
                                                                <div class="reply-item">
                                                                    <div class="reply-header">
                                                                        <div class="reply-author">
                                                                            <div class="reply-avatar">
                                                                                <i class="fas fa-user-shield"></i>
                                                                            </div>
                                                                            <div class="reply-info">
                                                                                <span class="reply-name">${reply.userFullName}</span>
                                                                                <span class="reply-role">Quản trị viên</span>
                                                                            </div>
                                                                        </div>
                                                                        <span class="reply-date">
                                                                            <fmt:formatDate value="${reply.createdAt}" pattern="dd/MM/yyyy"/>
                                                                        </span>
                                                                    </div>
                                                                    <div class="reply-content">
                                                                        ${reply.comment}
                                                                    </div>
                                                                </div>
                                                            </c:forEach>
                                                        </div>
                                                    </c:if>
                                                </div>

                                                <!-- Review Footer -->
                                                <div class="review-footer">
                                                    <div class="helpful-section">
                                                        <span class="helpful-text">Đánh giá này có hữu ích không?</span>
                                                        <div class="helpful-buttons">
                                                            <button class="helpful-btn" data-action="like">
                                                                <i class="fas fa-thumbs-up"></i>
                                                                <span>Có</span>
                                                            </button>
                                                            <button class="helpful-btn" data-action="dislike">
                                                                <i class="fas fa-thumbs-down"></i>
                                                                <span>Không</span>
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>

                                    <!-- Load More Button -->
                                    <div class="load-more-section">
                                        <button class="btn btn-outline-primary btn-lg load-more-btn">
                                            <i class="fas fa-chevron-down"></i>
                                            Xem thêm đánh giá
                                        </button>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Action Buttons -->
                        <div class="action-buttons">
                            <a href="${pageContext.request.contextPath}/SubmitReviewServlet" class="btn btn-primary btn-lg">
                                <i class="fas fa-plus-circle"></i>
                                Thêm đánh giá mới
                            </a>
                            <a href="javascript:history.back()" class="btn btn-outline-secondary btn-lg">
                                <i class="fas fa-arrow-left"></i>
                                Quay lại
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div style="height: 200px;"></div>
    <jsp:include page="/assets/footer.jsp" />
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: #f8fafc;
            color: #334155;
            line-height: 1.6;
        }

        /* Background Animation */
        .background-animation {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(-45deg, #667eea, #764ba2, #f093fb, #f5576c);
            background-size: 400% 400%;
            animation: gradientShift 15s ease infinite;
            opacity: 0.02;
            z-index: -1;
        }

        @keyframes gradientShift {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        /* Hero Header */
        .hero-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 3rem 0;
            position: relative;
            overflow: hidden;
        }

        .hero-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="50" cy="50" r="1" fill="white" opacity="0.1"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
        }

        .hero-content {
            text-align: center;
            position: relative;
            z-index: 1;
        }

        .hero-icon {
            width: 80px;
            height: 80px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            backdrop-filter: blur(10px);
        }

        .hero-icon i {
            font-size: 2rem;
            color: white;
        }

        .hero-title {
            color: white;
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
            letter-spacing: -0.02em;
        }

        .hero-subtitle {
            color: rgba(255, 255, 255, 0.9);
            font-size: 1.1rem;
            max-width: 600px;
            margin: 0 auto 2rem;
        }

        .stats-container {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 2rem;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            padding: 1.5rem 2rem;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            max-width: 400px;
            margin: 0 auto;
        }

        .stat-item {
            text-align: center;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: white;
            line-height: 1;
        }

        .stat-label {
            font-size: 0.9rem;
            color: rgba(255, 255, 255, 0.8);
            margin-top: 0.25rem;
        }

        .stat-divider {
            width: 1px;
            height: 40px;
            background: rgba(255, 255, 255, 0.3);
        }

        /* Main Content */
        .main-content {
            margin-top: -1rem;
            position: relative;
            z-index: 2;
            padding-bottom: 4rem;
        }

        /* Custom Alert */
        .custom-alert {
            border-radius: 16px;
            border: none;
            padding: 1.5rem;
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .alert-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            background: rgba(239, 68, 68, 0.1);
            color: #dc2626;
        }

        /* Filter Bar */
        .filter-bar {
            background: white;
            border-radius: 20px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .filter-group {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
            justify-content: center;
        }

        .filter-btn {
            background: #f1f5f9;
            border: 2px solid transparent;
            border-radius: 50px;
            padding: 0.5rem 1rem;
            color: #64748b;
            font-size: 0.9rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .filter-btn:hover,
        .filter-btn.active {
            background: #667eea;
            color: white;
            border-color: #667eea;
            transform: translateY(-1px);
        }

        .sort-select {
            border-radius: 12px;
            border: 2px solid #e2e8f0;
            padding: 0.5rem 1rem;
            background: white;
            min-width: 150px;
        }

        .sort-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        /* Hidden class for filtering */
        .review-card.hidden {
            display: none;
        }

        /* No Reviews Message */
        .no-reviews-message {
            display: none;
            text-align: center;
            padding: 2rem;
        }

        /* Reviews List */
        .reviews-list {
            display: flex;
            flex-direction: column;
            gap: 2rem;
        }

        .review-card {
            background: white;
            border-radius: 24px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            overflow: hidden;
            transition: all 0.3s ease;
            border: 1px solid rgba(0, 0, 0, 0.05);
        }

        .review-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
        }

        /* Review Header */
        .review-header {
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            padding: 1.5rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .reviewer-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .reviewer-avatar {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.2rem;
        }

        .reviewer-name {
            font-size: 1.1rem;
            font-weight: 600;
            color: #1e293b;
            margin: 0;
        }

        .review-meta {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-top: 0.25rem;
        }

        .review-date {
            color: #64748b;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }

        .review-id {
            background: #e2e8f0;
            color: #475569;
            padding: 0.25rem 0.5rem;
            border-radius: 6px;
            font-size: 0.8rem;
            font-weight: 500;
        }

        .action-btn {
            background: none;
            border: none;
            color: #64748b;
            font-size: 1rem;
            cursor: pointer;
            padding: 0.5rem;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .action-btn:hover {
            background: #f1f5f9;
            color: #374151;
        }

        /* Review Content */
        .review-content {
            padding: 2rem;
        }

        .info-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 0.75rem;
            margin-bottom: 1.5rem;
        }

        .info-tag {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            border-radius: 50px;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .doctor-tag {
            background: #dbeafe;
            color: #1d4ed8;
            border: 1px solid #bfdbfe;
        }

        .service-tag {
            background: #dcfce7;
            color: #166534;
            border: 1px solid #bbf7d0;
        }

        /* Rating Section */
        .rating-section {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .rating-item {
            background: #f8fafc;
            border-radius: 16px;
            padding: 1.5rem;
            border: 1px solid #e2e8f0;
        }

        .rating-label {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 600;
            color: #374151;
            margin-bottom: 0.75rem;
        }

        .star-display {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .star-display i {
            font-size: 1.2rem;
        }

        .star-display i.filled {
            color: #fbbf24;
        }

        .star-display i.empty {
            color: #e5e7eb;
        }

        .rating-score {
            font-weight: 600;
            color: #374151;
            margin-left: 0.5rem;
        }

        /* Comment Section */
        .comment-section {
            background: #f8fafc;
            border-radius: 16px;
            padding: 1.5rem;
            position: relative;
            margin-bottom: 1.5rem;
        }

        .quote-icon {
            position: absolute;
            top: 1rem;
            left: 1rem;
            color: #cbd5e1;
            font-size: 1.5rem;
        }

        .comment-text {
            margin: 0;
            padding-left: 2rem;
            font-style: italic;
            color: #475569;
            line-height: 1.7;
        }

        /* Replies Section */
        .replies-section {
            background: #f0fdf4;
            border-radius: 16px;
            padding: 1.5rem;
            border-left: 4px solid #22c55e;
        }

        .replies-title {
            color: #166534;
            font-weight: 600;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .reply-item {
            background: white;
            border-radius: 12px;
            padding: 1rem;
            margin-bottom: 1rem;
            border: 1px solid #dcfce7;
        }

        .reply-item:last-child {
            margin-bottom: 0;
        }

        .reply-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.75rem;
        }

        .reply-author {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .reply-avatar {
            width: 32px;
            height: 32px;
            background: #22c55e;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 0.9rem;
        }

        .reply-name {
            font-weight: 600;
            color: #166534;
        }

        .reply-role {
            color: #65a30d;
            font-size: 0.8rem;
            background: #ecfccb;
            padding: 0.125rem 0.5rem;
            border-radius: 4px;
            margin-left: 0.5rem;
        }

        .reply-date {
            color: #6b7280;
            font-size: 0.8rem;
        }

        .reply-content {
            color: #374151;
            line-height: 1.6;
        }

        /* Review Footer */
        .review-footer {
            padding: 1.5rem 2rem;
            border-top: 1px solid #f1f5f9;
            background: #fafbfc;
        }

        .helpful-section {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .helpful-text {
            color: #64748b;
            font-size: 0.9rem;
        }

        .helpful-buttons {
            display: flex;
            gap: 0.5rem;
        }

        .helpful-btn {
            background: none;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            color: #64748b;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.3s ease;
        }

        .helpful-btn:hover {
            background: #f1f5f9;
            color: #374151;
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const filterButtons = document.querySelectorAll('.filter-btn');
            const reviewCards = document.querySelectorAll('.review-card');
            const reviewsList = document.querySelector('.reviews-list');
            const noReviewsMessage = document.querySelector('.no-reviews-message');
            const ratingValueSpan = noReviewsMessage.querySelector('.rating-value');
            const loadMoreSection = document.querySelector('.load-more-section');

            filterButtons.forEach(button => {
                button.addEventListener('click', function() {
                    // Remove active class from all buttons
                    filterButtons.forEach(btn => btn.classList.remove('active'));
                    // Add active class to clicked button
                    this.classList.add('active');

                    const selectedRating = this.getAttribute('data-rating');
                    let visibleReviews = 0;

                    // Hide all review cards and the no-reviews message initially
                    reviewCards.forEach(card => card.classList.add('hidden'));
                    noReviewsMessage.style.display = 'none';
                    loadMoreSection.style.display = 'block';

                    // Filter reviews
                    reviewCards.forEach(card => {
                        const serviceRating = parseInt(card.getAttribute('data-service-rating'));
                        const doctorRating = parseInt(card.getAttribute('data-doctor-rating'));
                        const averageRating = Math.round((serviceRating + doctorRating) / 2);

                        if (selectedRating === 'all' || averageRating === parseInt(selectedRating)) {
                            card.classList.remove('hidden');
                            visibleReviews++;
                        }
                    });

                    // Show no-reviews message if no reviews match the filter
                    if (visibleReviews === 0 && selectedRating !== 'all') {
                        ratingValueSpan.textContent = selectedRating;
                        noReviewsMessage.style.display = 'block';
                        loadMoreSection.style.display = 'none';
                    } else if (selectedRating === 'all' && visibleReviews > 0) {
                        loadMoreSection.style.display = 'block';
                    }
                });
            });
        });
    </script>
</body>
</html>

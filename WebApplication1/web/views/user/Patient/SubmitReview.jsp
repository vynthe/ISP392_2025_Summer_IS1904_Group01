<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đánh giá dịch vụ khám bệnh</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <!-- Animated Background -->
    <div class="background-animation"></div>
    
    <div class="container-fluid px-0">
        <!-- Hero Section -->
        <div class="hero-section">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-lg-8">
                        <!-- Breadcrumb -->
                        <nav aria-label="breadcrumb" class="mb-4">
                            <ol class="breadcrumb custom-breadcrumb">
                                <li class="breadcrumb-item">
                                    <a href="${pageContext.request.contextPath}/views/user/Patient/PatientDashBoard.jsp">
                                        <i class="fas fa-home"></i> Trang Chủ
                                    </a>
                                </li>
                                <li class="breadcrumb-item active">Đánh Giá Dịch Vụ</li>
                            </ol>
                        </nav>
                        
                        <!-- Hero Card -->
                        <div class="hero-card">
                            <div class="hero-content">
                                <div class="hero-icon">
                                    <i class="fas fa-star-half-alt"></i>
                                </div>
                                <h1 class="hero-title">Đánh giá dịch vụ khám bệnh</h1>
                                <p class="hero-subtitle">Chia sẻ trải nghiệm của bạn để giúp cải thiện chất lượng dịch vụ</p>
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
                    <div class="col-lg-8">
                        <!-- Alert Messages -->
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
                        
                        <c:if test="${not empty success}">
                            <div class="alert alert-success custom-alert fade-in" role="alert">
                                <div class="alert-icon">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                                <div class="alert-content">
                                    <strong>Thành công!</strong> ${success}
                                </div>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Main Form Card -->
                        <div class="form-card slide-up">
                            <form method="post" action="${pageContext.request.contextPath}/SubmitReviewServlet" class="needs-validation" novalidate>
                                
                                <!-- Step 1: Doctor Selection -->
                                <div class="form-step active" id="step1">
                                    <div class="step-header">
                                        <div class="step-number">1</div>
                                        <div class="step-info">
                                            <h3>Chọn bác sĩ</h3>
                                            <p>Chọn bác sĩ đã khám cho bạn</p>
                                        </div>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label class="form-label">
                                            <i class="fas fa-user-md"></i>
                                            Bác sĩ khám bệnh
                                        </label>
                                        <select class="form-select custom-select" name="doctorId" required 
                                                onchange="window.location.href='${pageContext.request.contextPath}/SubmitReviewServlet?doctorId=' + this.value">
                                            <option value="">Chọn bác sĩ của bạn</option>
                                            <c:forEach var="doctor" items="${doctors}">
                                                <option value="${doctor.userID}" ${selectedDoctorId == doctor.userID ? 'selected' : ''}>
                                                    BS. ${doctor.fullName}
                                                    <c:if test="${not empty doctor.specialization}"> - ${doctor.specialization}</c:if>
                                                </option>
                                            </c:forEach>
                                        </select>
                                        <div class="invalid-feedback">Vui lòng chọn bác sĩ</div>
                                    </div>
                                </div>

                                <!-- Step 2: Service & Rating -->
                                <c:if test="${not empty services}">
                                    <div class="form-step" id="step2">
                                        <div class="step-header">
                                            <div class="step-number">2</div>
                                            <div class="step-info">
                                                <h3>Chọn dịch vụ & Đánh giá</h3>
                                                <p>Chọn dịch vụ đã sử dụng và đưa ra đánh giá</p>
                                            </div>
                                        </div>

                                        <!-- Service Selection -->
                                        <div class="form-group">
                                            <label class="form-label">
                                                <i class="fas fa-stethoscope"></i>
                                                Dịch vụ đã sử dụng
                                            </label>
                                            <select class="form-select custom-select" name="serviceId" required>
                                                <option value="">Chọn dịch vụ</option>
                                                <c:forEach var="service" items="${services}">
                                                    <option value="${service.serviceID}">
                                                        ${service.serviceName} - <fmt:formatNumber value="${service.price}" type="currency" currencySymbol="" pattern="#,##0"/> VND
                                                    </option>
                                                </c:forEach>
                                            </select>
                                            <div class="invalid-feedback">Vui lòng chọn dịch vụ</div>
                                        </div>

                                        <!-- Rating Cards -->
                                        <div class="rating-container">
                                            <div class="row g-4">
                                                <!-- Service Rating -->
                                                <div class="col-md-6">
                                                    <div class="rating-card">
                                                        <div class="rating-header">
                                                            <i class="fas fa-star"></i>
                                                            <h4>Đánh giá dịch vụ</h4>
                                                        </div>
                                                        <div class="star-rating" data-rating="serviceRating">
                                                            <span class="star" data-value="1"><i class="fas fa-star"></i></span>
                                                            <span class="star" data-value="2"><i class="fas fa-star"></i></span>
                                                            <span class="star" data-value="3"><i class="fas fa-star"></i></span>
                                                            <span class="star" data-value="4"><i class="fas fa-star"></i></span>
                                                            <span class="star" data-value="5"><i class="fas fa-star"></i></span>
                                                        </div>
                                                        <div class="rating-text">Chọn số sao</div>
                                                        <input type="hidden" name="serviceRating" required>
                                                    </div>
                                                </div>

                                                <!-- Doctor Rating -->
                                                <div class="col-md-6">
                                                    <div class="rating-card">
                                                        <div class="rating-header">
                                                            <i class="fas fa-user-md"></i>
                                                            <h4>Đánh giá bác sĩ</h4>
                                                        </div>
                                                        <div class="star-rating" data-rating="doctorRating">
                                                            <span class="star" data-value="1"><i class="fas fa-star"></i></span>
                                                            <span class="star" data-value="2"><i class="fas fa-star"></i></span>
                                                            <span class="star" data-value="3"><i class="fas fa-star"></i></span>
                                                            <span class="star" data-value="4"><i class="fas fa-star"></i></span>
                                                            <span class="star" data-value="5"><i class="fas fa-star"></i></span>
                                                        </div>
                                                        <div class="rating-text">Chọn số sao</div>
                                                        <input type="hidden" name="doctorRating" required>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>

                                <!-- Step 3: Comment -->
                                <c:if test="${not empty services}">
                                    <div class="form-step" id="step3">
                                        <div class="step-header">
                                            <div class="step-number">3</div>
                                            <div class="step-info">
                                                <h3>Nhận xét chi tiết</h3>
                                                <p>Chia sẻ trải nghiệm cụ thể của bạn</p>
                                            </div>
                                        </div>

                                        <div class="comment-section">
                                            <div class="form-group">
                                                <label class="form-label">
                                                    <i class="fas fa-comment-dots"></i>
                                                    Nhận xét của bạn
                                                </label>
                                                <textarea class="form-control custom-textarea" name="comment" rows="6" required
                                                    placeholder="Hãy chia sẻ trải nghiệm cụ thể về chất lượng dịch vụ, thái độ phục vụ, cơ sở vật chất..."></textarea>
                                                <div class="form-text">
                                                    <i class="fas fa-info-circle"></i>
                                                    Nhận xét của bạn sẽ giúp cải thiện chất lượng dịch vụ
                                                </div>
                                                <div class="invalid-feedback">Vui lòng viết nhận xét</div>
                                            </div>
                                        </div>

                                        <!-- Submit Button -->
                                        <div class="submit-section">
                                            <button type="submit" class="btn-submit">
                                                <span class="btn-text">
                                                    <i class="fas fa-paper-plane"></i>
                                                    Gửi đánh giá
                                                </span>
                                                <div class="btn-loading">
                                                    <i class="fas fa-spinner fa-spin"></i>
                                                    Đang gửi...
                                                </div>
                                            </button>
                                        </div>
                                    </div>
                                </c:if>

                                <!-- Empty States -->
                                <c:if test="${empty services && not empty selectedDoctorId}">
                                    <div class="empty-state">
                                        <div class="empty-icon">
                                            <i class="fas fa-calendar-times"></i>
                                        </div>
                                        <h3>Chưa có dịch vụ nào</h3>
                                        <p>Bạn chưa sử dụng dịch vụ nào của bác sĩ này hoặc các cuộc hẹn chưa hoàn thành.</p>
                                    </div>
                                </c:if>

                                <c:if test="${empty selectedDoctorId}">
                                    <div class="empty-state">
                                        <div class="empty-icon">
                                            <i class="fas fa-arrow-up"></i>
                                        </div>
                                        <h3>Bắt đầu đánh giá</h3>
                                        <p>Vui lòng chọn bác sĩ để xem các dịch vụ bạn đã sử dụng.</p>
                                    </div>
                                </c:if>
                            </form>
                        </div>

                        <!-- Action Buttons -->
                        <div class="action-buttons">
                            <a href="${pageContext.request.contextPath}/ViewReviewsServlet" class="btn btn-outline">
                                <i class="fas fa-eye"></i>
                                Xem tất cả đánh giá
                            </a>
                            <a href="${pageContext.request.contextPath}/views/user/Patient/PatientDashBoard.jsp" class="btn btn-secondary">
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
            overflow-x: hidden;
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
            opacity: 0.03;
            z-index: -1;
        }

        @keyframes gradientShift {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        /* Hero Section */
        .hero-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 2rem 0 4rem;
            position: relative;
            overflow: hidden;
        }

        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="50" cy="50" r="1" fill="white" opacity="0.1"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
        }

        .custom-breadcrumb {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50px;
            padding: 0.75rem 1.5rem;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .custom-breadcrumb .breadcrumb-item a {
            color: rgba(255, 255, 255, 0.9);
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .custom-breadcrumb .breadcrumb-item a:hover {
            color: white;
        }

        .custom-breadcrumb .breadcrumb-item.active {
            color: rgba(255, 255, 255, 0.8);
        }

        .hero-card {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 24px;
            padding: 3rem 2rem;
            text-align: center;
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
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
            font-weight: 400;
            max-width: 500px;
            margin: 0 auto;
            line-height: 1.6;
        }

        /* Main Content */
        .main-content {
            margin-top: -2rem;
            position: relative;
            z-index: 2;
            padding-bottom: 4rem;
        }

        /* Form Card */
        .form-card {
            background: white;
            border-radius: 24px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.08);
            padding: 3rem;
            margin-bottom: 2rem;
            border: 1px solid rgba(0, 0, 0, 0.05);
        }

        /* Form Steps */
        .form-step {
            margin-bottom: 3rem;
        }

        .step-header {
            display: flex;
            align-items: center;
            margin-bottom: 2rem;
            padding-bottom: 1.5rem;
            border-bottom: 2px solid #f1f5f9;
        }

        .step-number {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 1.2rem;
            margin-right: 1rem;
            flex-shrink: 0;
        }

        .step-info h3 {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 0.25rem;
            color: #1e293b;
        }

        .step-info p {
            color: #64748b;
            margin: 0;
            font-size: 0.95rem;
        }

        /* Form Groups */
        .form-group {
            margin-bottom: 2rem;
        }

        .form-label {
            display: flex;
            align-items: center;
            font-weight: 600;
            margin-bottom: 0.75rem;
            color: #374151;
            font-size: 1rem;
        }

        .form-label i {
            margin-right: 0.5rem;
            color: #667eea;
            width: 20px;
        }

        .custom-select, .custom-textarea {
            background: #f8fafc;
            border: 2px solid #e2e8f0;
            border-radius: 16px;
            padding: 1rem 1.25rem;
            font-size: 1rem;
            transition: all 0.3s ease;
            width: 100%;
        }

        .custom-select:focus, .custom-textarea:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        }

        .custom-textarea {
            resize: vertical;
            min-height: 120px;
        }

        /* Rating Cards */
        .rating-container {
            margin: 2rem 0;
        }

        .rating-card {
            background: #f8fafc;
            border-radius: 20px;
            padding: 2rem;
            text-align: center;
            border: 2px solid #e2e8f0;
            transition: all 0.3s ease;
            height: 100%;
        }

        .rating-card:hover {
            border-color: #667eea;
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.1);
        }

        .rating-header {
            margin-bottom: 1.5rem;
        }

        .rating-header i {
            font-size: 1.5rem;
            color: #667eea;
            margin-bottom: 0.5rem;
            display: block;
        }

        .rating-header h4 {
            font-size: 1.1rem;
            font-weight: 600;
            color: #374151;
            margin: 0;
        }

        .star-rating {
            display: flex;
            justify-content: center;
            gap: 0.5rem;
            margin-bottom: 1rem;
        }

        .star {
            font-size: 1.5rem;
            color: #e2e8f0;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .star:hover,
        .star.active {
            color: #fbbf24;
            transform: scale(1.1);
        }

        .rating-text {
            font-size: 0.9rem;
            color: #64748b;
            font-weight: 500;
        }

        /* Comment Section */
        .comment-section {
            background: #f8fafc;
            border-radius: 20px;
            padding: 2rem;
            border: 2px solid #e2e8f0;
        }

        /* Submit Section */
        .submit-section {
            text-align: center;
            margin-top: 3rem;
        }

        .btn-submit {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border: none;
            border-radius: 50px;
            padding: 1rem 3rem;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            min-width: 200px;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
        }

        .btn-submit:active {
            transform: translateY(0);
        }

        .btn-loading {
            display: none;
        }

        .btn-submit.loading .btn-text {
            display: none;
        }

        .btn-submit.loading .btn-loading {
            display: block;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn {
            padding: 0.75rem 2rem;
            border-radius: 50px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }

        .btn-outline {
            background: white;
            color: #667eea;
            border-color: #667eea;
        }

        .btn-outline:hover {
            background: #667eea;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
        }

        .btn-secondary {
            background: #64748b;
            color: white;
        }

        .btn-secondary:hover {
            background: #475569;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(100, 116, 139, 0.3);
        }

        /* Empty States */
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
        }

        .empty-icon {
            width: 100px;
            height: 100px;
            background: linear-gradient(135deg, #f1f5f9, #e2e8f0);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 2rem;
        }

        .empty-icon i {
            font-size: 2.5rem;
            color: #64748b;
        }

        .empty-state h3 {
            font-size: 1.5rem;
            font-weight: 600;
            color: #374151;
            margin-bottom: 1rem;
        }

        .empty-state p {
            color: #64748b;
            font-size: 1rem;
            max-width: 400px;
            margin: 0 auto;
            line-height: 1.6;
        }

        /* Custom Alerts */
        .custom-alert {
            border-radius: 16px;
            border: none;
            padding: 1.5rem;
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .alert-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .alert-danger .alert-icon {
            background: rgba(239, 68, 68, 0.1);
            color: #dc2626;
        }

        .alert-success .alert-icon {
            background: rgba(34, 197, 94, 0.1);
            color: #16a34a;
        }

        .alert-content {
            flex: 1;
        }

        /* Animations */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(40px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .fade-in {
            animation: fadeIn 0.6s ease-out;
        }

        .slide-up {
            animation: slideUp 0.8s ease-out;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .hero-title {
                font-size: 2rem;
            }
            
            .hero-subtitle {
                font-size: 1rem;
            }
            
            .form-card {
                padding: 2rem 1.5rem;
            }
            
            .step-header {
                flex-direction: column;
                text-align: center;
            }
            
            .step-number {
                margin-right: 0;
                margin-bottom: 1rem;
            }
            
            .rating-card {
                padding: 1.5rem;
            }
            
            .action-buttons {
                flex-direction: column;
                align-items: center;
            }
        }

        @media (max-width: 576px) {
            .hero-card {
                padding: 2rem 1.5rem;
            }
            
            .custom-breadcrumb {
                padding: 0.5rem 1rem;
                font-size: 0.9rem;
            }
            
            .btn {
                padding: 0.625rem 1.5rem;
                font-size: 0.95rem;
            }
        }
    </style>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Star Rating System
        document.querySelectorAll('.star-rating').forEach(rating => {
            const stars = rating.querySelectorAll('.star');
            const input = rating.parentElement.querySelector('input[type="hidden"]');
            const ratingText = rating.parentElement.querySelector('.rating-text');
            const ratingName = rating.dataset.rating;
            
            stars.forEach((star, index) => {
                star.addEventListener('click', () => {
                    const value = index + 1;
                    input.value = value;
                    input.name = ratingName;
                    
                    // Update visual state
                    stars.forEach((s, i) => {
                        if (i <= index) {
                            s.classList.add('active');
                        } else {
                            s.classList.remove('active');
                        }
                    });
                    
                    // Update text
                    const ratingTexts = ['Kém', 'Chưa tốt', 'Khá', 'Tốt', 'Xuất sắc'];
                    ratingText.textContent = ratingTexts[index];
                });
                
                star.addEventListener('mouseover', () => {
                    stars.forEach((s, i) => {
                        if (i <= index) {
                            s.style.color = '#fbbf24';
                        } else {
                            s.style.color = '#e2e8f0';
                        }
                    });
                });
            });
            
            rating.addEventListener('mouseleave', () => {
                const currentValue = parseInt(input.value) || 0;
                stars.forEach((s, i) => {
                    if (i < currentValue) {
                        s.style.color = '#fbbf24';
                    } else {
                        s.style.color = '#e2e8f0';
                    }
                });
            });
        });

        // Form validation
        (function() {
            'use strict';
            window.addEventListener('load', function() {
                var forms = document.getElementsByClassName('needs-validation');
                var validation = Array.prototype.filter.call(forms, function(form) {
                    form.addEventListener('submit', function(event) {
                        let isValid = true;
                        
                        // Check star ratings
                        const ratingInputs = form.querySelectorAll('input[name="serviceRating"], input[name="doctorRating"]');
                        ratingInputs.forEach(input => {
                            if (!input.value) {
                                isValid = false;
                                const ratingCard = input.closest('.rating-card');
                                if (ratingCard) {
                                    ratingCard.style.borderColor = '#dc2626';
                                    const ratingText = ratingCard.querySelector('.rating-text');
                                    if (ratingText) {
                                        ratingText.textContent = 'Vui lòng chọn số sao';
                                        ratingText.style.color = '#dc2626';
                                    }
                                }
                            }
                        });
                        
                        if (form.checkValidity() === false || !isValid) {
                            event.preventDefault();
                            event.stopPropagation();
                        } else {
                            // Show loading state
                            const submitBtn = form.querySelector('.btn-submit');
                            if (submitBtn) {
                                submitBtn.classList.add('loading');
                                submitBtn.disabled = true;
                            }
                        }
                        form.classList.add('was-validated');
                    }, false);
                });
            }, false);
        })();

        // Reset rating card border on interaction
        document.querySelectorAll('.star').forEach(star => {
            star.addEventListener('click', () => {
                const ratingCard = star.closest('.rating-card');
                if (ratingCard) {
                    ratingCard.style.borderColor = '#667eea';
                    const ratingText = ratingCard.querySelector('.rating-text');
                    if (ratingText && ratingText.style.color === 'rgb(220, 38, 38)') {
                        ratingText.style.color = '#64748b';
                    }
                }
            });
        });
    </script>

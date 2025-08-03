<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.entity.Users" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Nhân Viên - Healthcare System</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f7fa;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        .header h1 {
            margin: 0;
            font-size: 28px;
            font-weight: 300;
        }
        .header .subtitle {
            margin-top: 10px;
            opacity: 0.9;
            font-size: 16px;
        }
        .content {
            padding: 30px;
        }
        .alert {
            padding: 15px 20px;
            margin-bottom: 20px;
            border-radius: 8px;
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .alert-error {
            background: #ffeaea;
            border: 1px solid #ffcccb;
            color: #d63384;
        }
        .detail-card {
            background: #f8f9ff;
            border: 2px solid #e3e8ff;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 25px;
        }
        .detail-card h3 {
            color: #4c63d2;
            margin-top: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 15px;
            margin-top: 15px;
        }
        .info-item {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 14px;
        }
        .info-item i {
            color: #667eea;
            width: 16px;
        }
        .detail-label {
            font-weight: 600;
            color: #2d3748;
        }
        .detail-value {
            color: #4a5568;
            font-weight: 500;
        }
        .form-section {
            background: #fafbfc;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 20px;
        }
        .form-section h3 {
            color: #2d3748;
            margin-top: 0;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .form-group {
            display: flex;
            flex-direction: column;
            margin-bottom: 20px;
        }
        .form-group label {
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .form-group textarea {
            padding: 12px;
            border: 2px solid #e2e8f0;
            border-radius: 6px;
            font-size: 16px;
            background: white;
            color: #2d3748;
            transition: border-color 0.3s;
        }
        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        .btn-container {
            text-align: center;
            margin-top: 30px;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 15px 40px;
            font-size: 18px;
            font-weight: 600;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        }
        .btn-back {
            background: #6c757d;
            color: white;
            border: none;
            padding: 12px 25px;
            font-size: 16px;
            border-radius: 6px;
            cursor: pointer;
            margin-right: 15px;
            transition: background-color 0.3s;
        }
        .btn-back:hover {
            background: #5a6268;
        }
        .review-card {
            background: #f8f9ff;
            border: 2px solid #e3e8ff;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .star-rating {
            display: flex;
            gap: 5px;
        }
        .star-rating input {
            display: none;
        }
        .star-rating label {
            cursor: pointer;
            font-size: 24px;
            color: #d1d5db;
            transition: color 0.2s;
        }
        .star-rating label:hover,
        .star-rating input:checked ~ label {
            color: #f59e0b;
        }
        .required {
            color: #e53e3e;
        }
        @media (max-width: 600px) {
            .container {
                margin: 10px;
                border-radius: 8px;
            }
            .header {
                padding: 20px;
            }
            .content {
                padding: 20px;
            }
            .info-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <!-- Header Section -->
    <div class="header">
        <h1><i class="fas fa-user-md"></i> Chi tiết Nhân Viên</h1>
        <div class="subtitle">Hệ thống quản lý nhân viên y tế</div>
    </div>

    <!-- Content Section -->
    <div class="content">
        <!-- Breadcrumb -->
        <nav class="flex items-center text-sm text-gray-600 mb-6">
            <a href="${pageContext.request.contextPath}/" class="text-indigo-600 hover:text-indigo-800">
                <i class="fas fa-home"></i> Trang Chủ
            </a>
            <span class="mx-2">›</span>
            <a href="${pageContext.request.contextPath}/employee-management" class="text-indigo-600 hover:text-indigo-800">
                Quản Lý Nhân Viên
            </a>
            <span class="mx-2">›</span>
            <span class="font-medium">Xem Chi Tiết Nhân Viên</span>
        </nav>

        <c:if test="${not empty requestScope.user}">
            <!-- Doctor Details -->
            <div class="detail-card">
                <h3><i class="fas fa-user-md"></i> Thông Tin Nhân Viên</h3>
                <div class="info-grid">
                    <div class="info-item">
                        <i class="fas fa-id-badge"></i>
                        <span class="detail-label">ID:</span>
                        <span class="detail-value">${fn:escapeXml(requestScope.user.userID)}</span>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-user"></i>
                        <span class="detail-label">Tên đầy đủ:</span>
                        <span class="detail-value">${fn:escapeXml(requestScope.user.fullName)}</span>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-user-circle"></i>
                        <span class="detail-label">Tên đăng nhập:</span>
                        <span class="detail-value">${fn:escapeXml(requestScope.user.username)}</span>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-envelope"></i>
                        <span class="detail-label">Email:</span>
                        <span class="detail-value">${fn:escapeXml(requestScope.user.email)}</span>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-venus-mars"></i>
                        <span class="detail-label">Giới tính:</span>
                        <span class="detail-value">${fn:escapeXml(requestScope.user.gender)}</span>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-stethoscope"></i>
                        <span class="detail-label">Chuyên khoa:</span>
                        <span class="detail-value">${fn:escapeXml(requestScope.user.specialization)}</span>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-birthday-cake"></i>
                        <span class="detail-label">Ngày sinh:</span>
                        <span class="detail-value">
                            <fmt:formatDate value="${requestScope.user.dob}" pattern="dd/MM/yyyy" />
                        </span>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-phone"></i>
                        <span class="detail-label">Số điện thoại:</span>
                        <span class="detail-value">${fn:escapeXml(requestScope.user.phone)}</span>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-map-marker-alt"></i>
                        <span class="detail-label">Địa chỉ:</span>
                        <span class="detail-value">${fn:escapeXml(requestScope.user.address)}</span>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-briefcase"></i>
                        <span class="detail-label">Vai trò:</span>
                        <span class="detail-value">${fn:escapeXml(requestScope.user.role)}</span>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-info-circle"></i>
                        <span class="detail-label">Trạng thái:</span>
                        <span class="detail-value">${fn:escapeXml(requestScope.user.status)}</span>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-calendar-plus"></i>
                        <span class="detail-label">Ngày tạo:</span>
                        <span class="detail-value">
                            <fmt:formatDate value="${requestScope.user.createdAt}" pattern="dd/MM/yyyy HH:mm:ss" />
                        </span>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-calendar-check"></i>
                        <span class="detail-label">Ngày cập nhật:</span>
                        <span class="detail-value">
                            <fmt:formatDate value="${requestScope.user.updatedAt}" pattern="dd/MM/yyyy HH:mm:ss" />
                        </span>
                    </div>
                </div>
            </div>
        </c:if>
        <c:if test="${empty requestScope.user}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-triangle"></i>
                Không tìm thấy thông tin bác sĩ/y tá!
            </div>
        </c:if>

        <!-- Review Section -->
        <div class="form-section">
            <h3><i class="fas fa-star"></i> Đánh giá Bác sĩ và Dịch vụ</h3>
            <c:if test="${not empty sessionScope.loggedInUser}">
                <form action="${pageContext.request.contextPath}/SubmitReviewServlet" method="post" id="reviewForm" onsubmit="return validateReviewForm(this)">
                    <input type="hidden" name="doctorID" value="${fn:escapeXml(requestScope.user.userID)}">
                    <input type="hidden" name="userID" value="${fn:escapeXml(sessionScope.loggedInUser.userID)}">
                    <div class="form-group">
                        <label for="serviceRating"><i class="fas fa-concierge-bell"></i> Đánh giá dịch vụ <span class="required">*</span></label>
                        <div class="star-rating">
                            <input type="radio" name="serviceRating" value="5" id="service5" required>
                            <label for="service5"><i class="fas fa-star"></i></label>
                            <input type="radio" name="serviceRating" value="4" id="service4">
                            <label for="service4"><i class="fas fa-star"></i></label>
                            <input type="radio" name="serviceRating" value="3" id="service3">
                            <label for="service3"><i class="fas fa-star"></i></label>
                            <input type="radio" name="serviceRating" value="2" id="service2">
                            <label for="service2"><i class="fas fa-star"></i></label>
                            <input type="radio" name="serviceRating" value="1" id="service1">
                            <label for="service1"><i class="fas fa-star"></i></label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="doctorRating"><i class="fas fa-user-md"></i> Đánh giá bác sĩ <span class="required">*</span></label>
                        <div class="star-rating">
                            <input type="radio" name="doctorRating" value="5" id="doctor5" required>
                            <label for="doctor5"><i class="fas fa-star"></i></label>
                            <input type="radio" name="doctorRating" value="4" id="doctor4">
                            <label for="doctor4"><i class="fas fa-star"></i></label>
                            <input type="radio" name="doctorRating" value="3" id="doctor3">
                            <label for="doctor3"><i class="fas fa-star"></i></label>
                            <input type="radio" name="doctorRating" value="2" id="doctor2">
                            <label for="doctor2"><i class="fas fa-star"></i></label>
                            <input type="radio" name="doctorRating" value="1" id="doctor1">
                            <label for="doctor1"><i class="fas fa-star"></i></label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="comment"><i class="fas fa-comment"></i> Bình luận</label>
                        <textarea name="comment" id="comment" rows="4" placeholder="Nhập bình luận của bạn..."></textarea>
                    </div>
                    <div class="btn-container">
                        <button type="submit" class="btn-primary">
                            <i class="fas fa-paper-plane"></i> Gửi đánh giá
                        </button>
                    </div>
                </form>
            </c:if>
            <c:if test="${empty sessionScope.loggedInUser}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    Vui lòng đăng nhập để gửi đánh giá.
                </div>
            </c:if>

            <!-- Review List -->
            <div class="mt-6">
                <h3><i class="fas fa-list"></i> Danh sách đánh giá</h3>
                <c:if test="${not empty requestScope.reviews}">
                    <c:forEach var="review" items="${requestScope.reviews}">
                        <div class="review-card">
                            <div class="flex justify-between items-center mb-2">
                                <div>
                                    <span class="font-semibold text-gray-800">${fn:escapeXml(review.userFullName)}</span>
                                    <span class="text-gray-500 text-sm ml-2">
                                        <fmt:formatDate value="${review.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                    </span>
                                </div>
                                <div class="text-yellow-500">
                                    <span>Dịch vụ: ${review.serviceRating} <i class="fas fa-star"></i></span>
                                    <span class="ml-2">Bác sĩ: ${review.doctorRating} <i class="fas fa-star"></i></span>
                                </div>
                            </div>
                            <p class="text-gray-600">${fn:escapeXml(review.comment)}</p>
                        </div>
                    </c:forEach>
                </c:if>
                <c:if test="${empty requestScope.reviews}">
                    <div class="alert alert-error">
                        <i class="fas fa-info-circle"></i> Chưa có đánh giá nào.
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Back Button -->
        <div class="btn-container">
            <a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp" class="btn-back">
                <i class="fas fa-arrow-left"></i> Quay về Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/ViewEmployeeServlet" class="btn-primary">
                <i class="fas fa-list"></i> Quay lại danh sách
            </a>
        </div>
    </div>
</div>

<script>
    function validateReviewForm(form) {
        const serviceRating = form.serviceRating.value;
        const doctorRating = form.doctorRating.value;
        const comment = form.comment.value.trim();

        if (!serviceRating || !doctorRating) {
            alert("❌ Vui lòng chọn đánh giá cho cả dịch vụ và bác sĩ!");
            return false;
        }

        if (comment.length > 500) {
            alert("❌ Bình luận không được vượt quá 500 ký tự!");
            return false;
        }

        const confirmMessage = "❓ Bạn có chắc chắn muốn gửi đánh giá này không?\n\n" +
                              "• Đánh giá dịch vụ: " + serviceRating + " sao\n" +
                              "• Đánh giá bác sĩ: " + doctorRating + " sao\n" +
                              "• Bình luận: " + (comment || "Không có bình luận");
        return confirm(confirmMessage);
    }
</script>
<div style="height: 200px;"></div>
    <jsp:include page="/assets/footer.jsp" />
</body>
</html>

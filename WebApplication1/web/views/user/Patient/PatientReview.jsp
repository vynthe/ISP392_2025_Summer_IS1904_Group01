<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đánh giá bác sĩ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5">
         <div class="breadcrumb">
                    <i class="fas fa-home"></i>
                    <a href="${pageContext.request.contextPath}/views/user/Patient/PatientDashBoard.jsp">Trang Chủ</a>
                    <span class="separator">></span>
                    <span class="current">Đánh Giá Dịch Vụ</span>

                </div>
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-body text-center">
                        <i class="fas fa-star fa-3x text-warning mb-3"></i>
                        <h3>Đánh giá dịch vụ khám bệnh</h3>
                        <p class="text-muted">Chia sẻ trải nghiệm của bạn về dịch vụ và bác sĩ</p>
                        
                        <div class="mt-4">
                            <a href="${pageContext.request.contextPath}/SubmitReviewServlet" class="btn btn-primary btn-lg">
                                <i class="fas fa-edit"></i>
                                Viết đánh giá mới
                            </a>
                            <a href="${pageContext.request.contextPath}/ViewReviewsServlet" class="btn btn-outline-secondary btn-lg ms-3">
                                <i class="fas fa-eye"></i>
                                Xem tất cả đánh giá
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <div style="height: 200px;"></div>
    <jsp:include page="/assets/footer.jsp" />
</body>
</html>


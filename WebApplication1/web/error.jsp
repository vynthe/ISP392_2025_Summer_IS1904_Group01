<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lỗi - Hệ thống quản lý lịch</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .error-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 40px;
            text-align: center;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            max-width: 500px;
            width: 100%;
        }

        .error-icon {
            font-size: 4rem;
            color: #dc3545;
            margin-bottom: 20px;
        }

        .error-title {
            color: #2d3748;
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .error-message {
            color: #718096;
            font-size: 1.1rem;
            margin-bottom: 30px;
        }

        .back-link {
            display: inline-block;
            padding: 12px 24px;
            border-radius: 25px;
            background: linear-gradient(135deg, #48bb78, #38a169);
            color: white;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .back-link:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(72, 187, 120, 0.4);
            color: white;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-icon"><i class="fas fa-exclamation-triangle"></i></div>
        <h2 class="error-title">Có lỗi xảy ra</h2>
        <p class="error-message">
            <c:choose>
                <c:when test="${not empty errorMessage}">
                    ${errorMessage}
                </c:when>
                <c:otherwise>
                    Đã xảy ra lỗi không xác định. Vui lòng thử lại sau.
                </c:otherwise>
            </c:choose>
        </p>
        <a href="${pageContext.request.contextPath}/admin/schedules" class="back-link">
            <i class="fas fa-arrow-left"></i> Quay lại danh sách lịch
        </a>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
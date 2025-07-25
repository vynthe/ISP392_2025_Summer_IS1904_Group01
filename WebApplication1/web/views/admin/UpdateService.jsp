<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cập Nhật Dịch Vụ | Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: #f8f9fa;
            color: #212529;
            line-height: 1.6;
        }

        /* Header Styles */
        .main-header {
            background: linear-gradient(135deg, #2c3e50 0%, #3498db 100%);
            color: white;
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .header-main {
            padding: 20px 0;
        }

        .header-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 24px;
            font-weight: bold;
            text-decoration: none;
            color: white;
        }

        .logo i {
            font-size: 32px;
            color: #ecf0f1;
        }

        .main-nav {
            display: flex;
            list-style: none;
            gap: 5px;
        }

        .main-nav a {
            color: white;
            text-decoration: none;
            padding: 12px 18px;
            border-radius: 8px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 500;
        }

        .main-nav a:hover {
            background: rgba(255,255,255,0.15);
            transform: translateY(-2px);
        }

        .main-nav a.active {
            background: #e74c3c;
            box-shadow: 0 4px 15px rgba(231, 76, 60, 0.3);
        }

        /* Main Content */
        .main-content {
            min-height: calc(100vh - 120px);
            padding: 2rem 0;
        }

        .content-section {
            background: white;
            border: 1px solid #dee2e6;
            margin-bottom: 2rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        .section-header {
            background: #f8f9fa;
            padding: 1rem 1.5rem;
            border-bottom: 1px solid #dee2e6;
            font-weight: 600;
            color: #495057;
            text-align: center;
        }

        .section-body {
            padding: 1.5rem;
        }

        /* Alert Styles */
        .alert {
            border: 0;
            margin-bottom: 1.5rem;
        }

        .alert-danger {
            background: #f8d7da;
            color: #721c24;
            border-left: 4px solid #dc3545;
        }

        /* Form Styles */
        .form-control {
            border: 1px solid #ced4da;
            padding: 0.75rem;
            font-size: 0.9rem;
        }

        .form-control:focus {
            border-color: #495057;
            box-shadow: 0 0 0 2px rgba(73, 80, 87, 0.25);
        }

        .form-label {
            font-weight: 500;
            color: #495057;
            margin-bottom: 0.5rem;
        }

        /* Button Styles */
        .btn {
            border: 0;
            padding: 0.75rem 1.5rem;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: #495057;
            color: white;
        }

        .btn-primary:hover {
            background: #343a40;
            color: white;
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #5a6268;
            color: white;
        }

        /* Footer */
        .main-footer {
            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
            color: white;
            margin-top: auto;
            width: 100vw;
            position: relative;
            left: 50%;
            right: 50%;
            margin-left: -50vw;
            margin-right: -50vw;
        }

        .footer-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 50px 20px 20px;
        }

        .footer-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 40px;
            margin-bottom: 40px;
        }

        .footer-section h4 {
            color: #3498db;
            margin-bottom: 20px;
            font-size: 18px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
        }

        .footer-section ul {
            list-style: none;
        }

        .footer-section ul li {
            margin-bottom: 10px;
        }

        .footer-section ul li a {
            color: #bdc3c7;
            text-decoration: none;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 5px 0;
        }

        .footer-section ul li a:hover {
            color: #3498db;
            padding-left: 10px;
        }

        .footer-section p {
            color: #bdc3c7;
            line-height: 1.7;
            margin-bottom: 12px;
        }

        .footer-bottom {
            border-top: 1px solid rgba(255,255,255,0.1);
            padding-top: 25px;
            text-align: center;
            color: #95a5a6;
        }

        .footer-bottom p {
            margin: 8px 0;
        }

        html, body {
            overflow-x: hidden;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .main-content {
                padding: 1rem 0;
            }

            .section-body {
                padding: 1rem;
            }

            .header-container {
                flex-direction: column;
                gap: 1rem;
            }

            .main-nav {
                flex-direction: column;
                gap: 1rem;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="main-header">
        <div class="header-main">
            <div class="header-container">
                <a href="${pageContext.request.contextPath}/" class="logo">
                    <i class="fas fa-hospital"></i>
                    <span>Phòng Khám Nha Khoa PDC</span>
                </a>
                <nav>
                    <ul class="main-nav">
                        <li><a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp">
                            <i class="fas fa-home"></i> Trang Chủ</a></li>
                        <li><a href="${pageContext.request.contextPath}/ViewServiceServlet">
                            <i class="fas fa-cogs"></i> Quản Lý Dịch Vụ</a></li>
                        <li><a href="${pageContext.request.contextPath}/AddServiceServlet" class="active">
                            <i></i> Cập Nhật Dịch Vụ</a></li>
                    </ul>
                </nav>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="main-content">
        <div class="container">
            <div class="content-section">
                <div class="section-header">
                    <i></i>
                    CẬP NHẬT DỊCH VỤ
                </div>
                <div class="section-body">
                    <c:if test="${not empty requestScope.error}">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle me-2"></i>
                            ${requestScope.error}
                            <button type="button" class="btn-close float-end" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <form action="${pageContext.request.contextPath}/UpdateServiceServlet" method="post" id="serviceForm">
                        <input type="hidden" name="serviceID" value="${service.serviceID}">
                        <div class="mb-3">
                            <label for="serviceName" class="form-label">
                                <i class="fas fa-briefcase-medical me-1"></i>
                                Tên Dịch Vụ
                            </label>
                            <input type="text" class="form-control" id="serviceName" name="serviceName" 
                                   value="${service.serviceName}" 
                                   placeholder="Nhập tên dịch vụ" required>
                        </div>
                        <div class="mb-3">
                            <label for="description" class="form-label">
                                <i class="fas fa-align-left me-1"></i>
                                Mô Tả
                            </label>
                            <textarea class="form-control" id="description" name="description" 
                                      placeholder="Nhập mô tả dịch vụ" rows="4">${service.description}</textarea>
                        </div>
                        <div class="mb-3">
                            <label for="price" class="form-label">
                                <i class="fas fa-money-bill me-1"></i>
                                Giá (VNĐ)
                            </label>
                            <input type="number" class="form-control" id="price" name="price" 
                                   value="${service.price}" 
                                   placeholder="Nhập giá dịch vụ" min="0" step="1000" required>
                        </div>
                        <div class="mb-3">
                            <label for="status" class="form-label">
                                <i class="fas fa-toggle-on me-1"></i>
                                Trạng Thái
                            </label>
                            <select class="form-control" id="status" name="status" required>
                                <option value="" disabled>Chọn trạng thái</option>
                                <option value="Active" ${service.status == 'Active' ? 'selected' : ''}>Hoạt động</option>
                                <option value="Inactive" ${service.status == 'Inactive' ? 'selected' : ''}>Tạm dừng</option>
                            </select>
                        </div>
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-2"></i>
                                CẬP NHẬT DỊCH VỤ
                            </button>
                            <a href="${pageContext.request.contextPath}/ViewServiceServlet" 
                               class="btn btn-secondary">
                                <i class="fas fa-arrow-left me-2"></i>
                                QUAY LẠI
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="main-footer">
        <div class="footer-content">
            <div class="footer-grid">
                <div class="footer-section">
                    <h4><i class="fas fa-hospital"></i>Về Chúng Tôi</h4>
                    <p>Chúng tôi là hệ thống quản lý dịch vụ y tế hàng đầu, cam kết mang lại sự chăm sóc tốt nhất với công nghệ tiên tiến và đội ngũ chuyên gia giàu kinh nghiệm.</p>
                </div>
                <div class="footer-section">
                    <h4><i class="fas fa-link"></i>Liên Kết Nhanh</h4>
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp">
                            <i class="fas fa-home"></i> Trang Chủ</a></li>
                        <li><a href="${pageContext.request.contextPath}/ViewServiceServlet">
                            <i class="fas fa-cogs"></i> Quản Lý Dịch Vụ</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h4><i class="fas fa-map-marker-alt"></i> Liên Hệ</h4>
                    <p><i class="fas fa-map-marker-alt"></i> ĐH FPT, HOA LAC</p>
                    <p><i class="fas fa-phone"></i> (098) 123 4567</p>
                    <p><i class="fas fa-envelope"></i> PhongKhamPDC@gmail.com</p>
                </div>
            </div>
            <div class="footer-bottom">
                <p>© 2025 Hệ Thống Quản Lý PDC. Đạt chuẩn Bộ Y tế. Tất cả quyền được bảo lưu.</p>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Auto-hide alerts
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                setTimeout(() => {
                    if (alert) {
                        alert.style.opacity = '0';
                        setTimeout(() => alert.remove(), 300);
                    }
                }, 5000);
            });

            // Form validation
            const form = document.getElementById('serviceForm');
            if (form) {
                form.addEventListener('submit', function() {
                    const submitBtn = this.querySelector('button[type="submit"]');
                    if (submitBtn) {
                        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i> Đang xử lý...';
                        submitBtn.disabled = true;
                    }
                });
            }
        });
    </script>
</body>
</html>
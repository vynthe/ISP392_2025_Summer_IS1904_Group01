
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
    <head>
        <title>Thêm Thuốc Mới</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            :root {
                --primary-blue: #2563eb;
                --primary-blue-dark: #1d4ed8;
                --primary-blue-light: #dbeafe;
                --secondary-indigo: #4f46e5;
                --accent-emerald: #10b981;
                --neutral-50: #f8fafc;
                --neutral-100: #f1f5f9;
                --neutral-200: #e2e8f0;
                --neutral-300: #cbd5e1;
                --neutral-600: #475569;
                --neutral-700: #334155;
                --neutral-800: #1e293b;
                --neutral-900: #0f172a;
                --error-red: #ef4444;
                --success-green: #22c55e;
                --white: #ffffff;
                --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
                --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
                --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
                --border-radius: 12px;
                --border-radius-lg: 16px;
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                background: linear-gradient(135deg, var(--primary-blue) 0%, var(--secondary-indigo) 100%);
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
                color: var(--neutral-800);
                min-height: 100vh;
                padding: 2rem 1rem;
                line-height: 1.6;
            }

            .main-container {
                max-width: 800px;
                margin: 0 auto;
                background: var(--white);
                border-radius: var(--border-radius-lg);
                box-shadow: var(--shadow-lg);
                padding: 2rem;
                animation: slideUp 0.6s cubic-bezier(0.16, 1, 0.3, 1);
            }

            @keyframes slideUp {
                from {
                    opacity: 0;
                    transform: translateY(40px) scale(0.98);
                }
                to {
                    opacity: 1;
                    transform: translateY(0) scale(1);
                }
            }

            .header-section {
                margin-bottom: 2rem;
                text-align: center;
            }

            .page-title {
                font-size: 1.75rem;
                font-weight: 700;
                color: var(--neutral-900);
            }

            .page-subtitle {
                font-size: 0.875rem;
                color: var(--neutral-600);
                margin-top: 0.25rem;
            }

            .form-container {
                display: flex;
                flex-direction: column;
                gap: 1.5rem;
            }

            .form-group {
                display: flex;
                flex-direction: column;
                gap: 0.5rem;
            }

            .form-label {
                font-weight: 600;
                color: var(--neutral-700);
                font-size: 0.875rem;
            }

            .form-input, .form-select, .form-textarea {
                padding: 0.75rem 1rem;
                border: 1px solid var(--neutral-200);
                border-radius: var(--border-radius);
                font-size: 0.875rem;
                color: var(--neutral-800);
                background: var(--neutral-50);
                transition: all 0.2s ease;
            }

            .form-textarea {
                resize: vertical;
                min-height: 100px;
            }

            .form-input:focus, .form-select:focus, .form-textarea:focus {
                outline: none;
                border-color: var(--primary-blue);
                box-shadow: 0 0 0 3px var(--primary-blue-light);
            }

            .form-input:invalid, .form-select:invalid, .form-textarea:invalid {
                border-color: var(--error-red);
            }

            .form-buttons {
                display: flex;
                gap: 1rem;
                justify-content: flex-end;
                margin-top: 1.5rem;
            }

            .btn-submit, .btn-cancel {
                padding: 0.75rem 1.5rem;
                border-radius: var(--border-radius);
                font-weight: 600;
                font-size: 0.875rem;
                text-decoration: none;
                transition: all 0.2s ease;
                border: none;
                cursor: pointer;
            }

            .btn-submit {
                background: linear-gradient(135deg, var(--accent-emerald), #059669);
                color: var(--white);
            }

            .btn-submit:hover {
                transform: translateY(-2px);
                box-shadow: var(--shadow-md);
                background: linear-gradient(135deg, #059669, #047857);
            }

            .btn-cancel {
                background: var(--neutral-200);
                color: var(--neutral-700);
            }

            .btn-cancel:hover {
                background: var(--neutral-300);
                transform: translateY(-2px);
                box-shadow: var(--shadow-md);
            }

            .alert {
                padding: 1rem 1.25rem;
                border-radius: var(--border-radius);
                margin-bottom: 1.5rem;
                display: flex;
                align-items: center;
                gap: 0.75rem;
                font-weight: 500;
                animation: fadeIn 0.3s ease;
            }

            .alert-success {
                background-color: #ecfdf5;
                color: #065f46;
                border: 1px solid #a7f3d0;
            }

            .alert-error {
                background-color: #fef2f2;
                color: #991b1b;
                border: 1px solid #fecaca;
            }

            .alert-icon {
                font-size: 1.125rem;
            }

            @media (max-width: 768px) {
                .main-container {
                    padding: 1.5rem;
                }

                .page-title {
                    font-size: 1.5rem;
                }

                .form-buttons {
                    flex-direction: column;
                    gap: 0.75rem;
                }

                .btn-submit, .btn-cancel {
                    width: 100%;
                    text-align: center;
                }
            }
        </style>
    </head>
    <body>
        <div class="main-container">
            <!-- Header Section -->
            <div class="header-section">
                <h1 class="page-title">Thêm Thuốc Mới</h1>
                <p class="page-subtitle">Nhập thông tin thuốc để thêm vào hệ thống</p>
            </div>

            <!-- Alert Messages -->
            <c:if test="${not empty sessionScope.statusMessage}">
                <c:choose>
                    <c:when test="${sessionScope.statusMessage == 'Tạo thành công'}">
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle alert-icon"></i>
                            ${sessionScope.statusMessage}
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-error">
                            <i class="fas fa-exclamation-circle alert-icon"></i>
                            ${sessionScope.statusMessage}
                        </div>
                    </c:otherwise>
                </c:choose>
                <c:remove var="statusMessage" scope="session"/>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-triangle alert-icon"></i>
                    ${errorMessage}
                </div>
            </c:if>

            <!-- Form Section -->
            <form action="${pageContext.request.contextPath}/AddMedicationServlet" method="post" class="form-container">
                <div class="form-group">
                    <label for="name" class="form-label">Tên Thuốc <span style="color: var(--error-red);">*</span></label>
                    <input type="text" id="name" name="name" class="form-input" required maxlength="255" placeholder="Nhập tên thuốc...">
                </div>

                <div class="form-group">
                    <label for="dosage" class="form-label">Hàm Lượng <span style="color: var(--error-red);">*</span></label>
                    <input type="text" id="dosage" name="dosage" class="form-input" required maxlength="100" placeholder="Nhập hàm lượng (ví dụ: 500mg)...">
                </div>

                <div class="form-group">
                    <label for="dosageForm" class="form-label">Dạng Bào Chế <span style="color: var(--error-red);">*</span></label>
                    <select id="dosageForm" name="dosageForm" class="form-select" required>
                        <option value="" disabled selected>Chọn dạng bào chế</option>
                        <option value="Tablet">Viên nén</option>
                        <option value="Liquid">Dung dịch</option>
                        <option value="Capsule">Viên nang</option>
                        <option value="Injection">Tiêm</option>
                        <option value="Syrup">Si rô</option>
                        <option value="Powder">Bột</option>
                        <option value="Cream">Kem</option>
                        <option value="Ointment">Thuốc mỡ</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="manufacturer" class="form-label">Nhà Sản Xuất <span style="color: var(--error-red);">*</span></label>
                    <input type="text" id="manufacturer" name="manufacturer" class="form-input" required maxlength="255" placeholder="Nhập nhà sản xuất...">
                </div>

                <div class="form-group">
                    <label for="description" class="form-label">Mô Tả</label>
                    <textarea id="description" name="description" class="form-textarea" placeholder="Nhập mô tả thuốc..."></textarea>
                </div>

                <div class="form-group">
                    <label for="status" class="form-label">Trạng Thái <span style="color: var(--error-red);">*</span></label>
                    <select id="status" name="status" class="form-select" required>
                        <option value="Active">Hoạt động</option>
                        <option value="Inactive">Ngừng hoạt động</option>
                        <option value="Out of Stock">Hết hàng</option>
                    </select>
                </div>

                <div class="form-buttons">
                    <a href="${pageContext.request.contextPath}/ViewMedicationsServlet" class="btn-cancel">Hủy</a>
                    <button type="submit" class="btn-submit">Thêm Thuốc</button>
                </div>
            </form>
        </div>
    </body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<html>
<head>
    <title>Nhập Thuốc - Hệ Thống Quản Lý Dược Phẩm</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        :root {
            --primary-blue: #2563eb;
            --primary-blue-dark: #1d4ed8;
            --secondary-blue: #3b82f6;
            --light-blue: #eff6ff;
            --accent-green: #10b981;
            --accent-orange: #f59e0b;
            --error-red: #ef4444;
            --success-green: #22c55e;
            --warning-yellow: #f59e0b;
            
            --neutral-50: #f8fafc;
            --neutral-100: #f1f5f9;
            --neutral-200: #e2e8f0;
            --neutral-300: #cbd5e1;
            --neutral-400: #94a3b8;
            --neutral-500: #64748b;
            --neutral-600: #475569;
            --neutral-700: #334155;
            --neutral-800: #1e293b;
            --neutral-900: #0f172a;
            
            --white: #ffffff;
            --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
            --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
            --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
            --shadow-xl: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);
            
            --border-radius-sm: 6px;
            --border-radius-md: 8px;
            --border-radius-lg: 12px;
            --border-radius-xl: 16px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, var(--light-blue) 0%, var(--neutral-50) 100%);
            color: var(--neutral-800);
            line-height: 1.6;
            min-height: 100vh;
            padding: 20px 0;
        }

        .container {
            max-width: 900px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .card {
            background: var(--white);
            border-radius: var(--border-radius-xl);
            box-shadow: var(--shadow-xl);
            overflow: hidden;
            border: 1px solid var(--neutral-200);
        }

        .header {
            background: linear-gradient(135deg, var(--primary-blue) 0%, var(--secondary-blue) 100%);
            color: var(--white);
            padding: 32px;
            text-align: center;
            position: relative;
        }

        .header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.05'%3E%3Ccircle cx='7' cy='7' r='7'/%3E%3Ccircle cx='53' cy='7' r='7'/%3E%3Ccircle cx='7' cy='53' r='7'/%3E%3Ccircle cx='53' cy='53' r='7'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
        }

        .header-content {
            position: relative;
            z-index: 1;
        }

        .header h1 {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
        }

        .header p {
            font-size: 16px;
            opacity: 0.9;
            font-weight: 400;
        }

        .content {
            padding: 40px;
        }

        /* Alert Styles */
        .alert {
            padding: 16px 20px;
            border-radius: var(--border-radius-md);
            margin-bottom: 32px;
            border-left: 4px solid;
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 500;
            animation: slideInDown 0.4s ease-out;
        }

        .alert-success {
            background-color: #f0fdf4;
            color: #166534;
            border-left-color: var(--success-green);
        }

        .alert-error {
            background-color: #fef2f2;
            color: #dc2626;
            border-left-color: var(--error-red);
        }

        /* Medication Info Card */
        .medication-info {
            background: linear-gradient(135deg, var(--light-blue) 0%, var(--neutral-50) 100%);
            border: 1px solid var(--neutral-200);
            border-radius: var(--border-radius-lg);
            padding: 24px;
            margin-bottom: 32px;
        }

        .medication-info h3 {
            color: var(--primary-blue);
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
        }

        .info-item {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .info-label {
            font-size: 13px;
            font-weight: 600;
            color: var(--neutral-500);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .info-value {
            font-size: 15px;
            font-weight: 500;
            color: var(--neutral-800);
        }

        /* Form Styles */
        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 24px;
            margin-bottom: 32px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .form-label {
            font-size: 14px;
            font-weight: 600;
            color: var(--neutral-700);
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .form-input {
            padding: 14px 16px;
            border: 2px solid var(--neutral-200);
            border-radius: var(--border-radius-md);
            font-size: 15px;
            font-weight: 500;
            background: var(--white);
            transition: all 0.2s ease;
            color: var(--neutral-800);
            width: 100%;
        }

        .form-input:focus {
            outline: none;
            border-color: var(--primary-blue);
            box-shadow: 0 0 0 3px rgb(37 99 235 / 0.1);
        }

        .form-input:invalid {
            border-color: var(--error-red);
        }

        /* Confirmation Styles */
        .confirmation-overlay {
            display: ${sessionScope.showConfirmation ? 'flex' : 'none'}; /* Sửa từ block sang flex cho căn giữa */
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 1000;
            justify-content: center;
            align-items: center;
        }

        .confirmation-card {
            background: var(--white);
            border-radius: var(--border-radius-md);
            box-shadow: var(--shadow-md);
            padding: 24px;
            text-align: center;
            max-width: 500px;
            width: 90%;
            margin: 0 auto;
        }

        .confirmation-card h2 {
            color: var(--primary-blue);
            margin-bottom: 16px;
        }

        .confirmation-details {
            background: var(--neutral-50);
            padding: 16px;
            border-radius: var(--border-radius-md);
            margin-bottom: 24px;
            text-align: left;
        }

        .detail-item {
            margin-bottom: 8px;
        }

        .detail-label {
            font-weight: 600;
            color: var(--neutral-800);
        }

        .detail-value {
            color: var(--neutral-600);
        }

        .confirmation-buttons {
            display: flex;
            gap: 16px;
            justify-content: center;
        }

        .btn-confirm {
            background: var(--accent-green);
            color: var(--white);
            padding: 12px 24px;
            border-radius: var(--border-radius-md);
            font-size: 14px;
            font-weight: 600;
            border: none;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .btn-confirm:hover {
            background: #0d8b5e; /* Thay vì darken, dùng màu cụ thể */
        }

        .btn-cancel {
            background: var(--neutral-200);
            color: var(--neutral-800);
            padding: 12px 24px;
            border-radius: var(--border-radius-md);
            font-size: 14px;
            font-weight: 600;
            border: none;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .btn-cancel:hover {
            background: var(--neutral-300);
        }

        /* Button Styles */
        .button-group {
            display: flex;
            gap: 16px;
            flex-wrap: wrap;
            justify-content: center;
        }

        .btn {
            padding: 14px 28px;
            border-radius: var(--border-radius-md);
            font-size: 15px;
            font-weight: 600;
            text-decoration: none;
            text-align: center;
            cursor: pointer;
            border: none;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            min-width: 140px;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-blue) 0%, var(--secondary-blue) 100%);
            color: var(--white);
            box-shadow: var(--shadow-md);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
            background: linear-gradient(135deg, var(--primary-blue-dark) 0%, var(--primary-blue) 100%);
        }

        .btn-secondary {
            background: var(--white);
            color: var(--neutral-600);
            border: 2px solid var(--neutral-200);
        }

        .btn-secondary:hover {
            background: var(--neutral-50);
            border-color: var(--neutral-300);
            color: var(--neutral-700);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .container {
                padding: 0 16px;
            }
            
            .content {
                padding: 24px;
            }
            
            .header {
                padding: 24px;
            }
            
            .header h1 {
                font-size: 24px;
            }
            
            .info-grid {
                grid-template-columns: 1fr;
            }
            
            .form-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }
            
            .button-group {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
            }

            .confirmation-buttons {
                flex-direction: column;
            }
            
            .btn-confirm, .btn-cancel {
                width: 100%;
            }
        }

        /* Animations */
        @keyframes slideInDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .card {
            animation: fadeIn 0.6s ease-out;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="card">
            <div class="header">
                <div class="header-content">
                    <h1>
                        <i class="fas fa-pills"></i>
                        Nhập Thuốc
                    </h1>
                    <p>Hệ thống quản lý dược phẩm chuyên nghiệp</p>
                </div>
            </div>

            <div class="content">
                <!-- Hiển thị thông báo trạng thái từ session -->
                <c:if test="${not empty sessionScope.statusMessage}">
                    <div class="alert ${fn:contains(sessionScope.statusMessage, 'thành công') ? 'alert-success' : 'alert-error'}">
                        <i class="fas ${fn:contains(sessionScope.statusMessage, 'thành công') ? 'fa-check-circle' : 'fa-exclamation-triangle'}"></i>
                        ${sessionScope.statusMessage}
                    </div>
                    <c:remove var="statusMessage" scope="session" /> <!-- Xóa thông báo sau khi hiển thị -->
                </c:if>

                <!-- Hiển thị thông tin thuốc nếu tồn tại -->
                <c:if test="${not empty medication}">
                    <div class="medication-info">
                        <h3>
                            <i class="fas fa-info-circle"></i>
                            Thông tin thuốc
                        </h3>
                        <div class="info-grid">
                            <div class="info-item">
                                <span class="info-label">Mã thuốc</span>
                                <span class="info-value">${medication.medicationID}</span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Tên thuốc</span>
                                <span class="info-value">${medication.name}</span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Hàm lượng</span>
                                <span class="info-value">${not empty medication.dosage ? medication.dosage : 'Chưa cập nhật'}</span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Dạng bào chế</span>
                                <span class="info-value">${not empty medication.dosageForm ? medication.dosageForm : 'Chưa cập nhật'}</span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Nhà sản xuất</span>
                                <span class="info-value">${not empty medication.manufacturer ? medication.manufacturer : 'Chưa cập nhật'}</span>
                            </div>
                        </div>
                    </div>

                    <!-- Form nhập thông tin nhập thuốc -->
                    <form action="${pageContext.request.contextPath}/MedicationImportServlet" method="post" id="importForm">
                        <input type="hidden" name="id" value="${medication.medicationID}" />

                        <div class="form-grid">
                            <div class="form-group">
                                <label for="productionDate" class="form-label">
                                    <i class="fas fa-calendar-alt input-icon"></i>
                                    Ngày sản xuất
                                </label>
                                <input type="date" 
                                       id="productionDate" 
                                       name="productionDate" 
                                       class="form-input input-with-icon"
                                       value="${not empty param.productionDate ? param.productionDate : (not empty medication.productionDate ? medication.productionDate : '')}" 
                                       required
                                       min="2025-01-01" />
                            </div>

                            <div class="form-group">
                                <label for="expirationDate" class="form-label">
                                    <i class="fas fa-calendar-times input-icon"></i>
                                    Hạn sử dụng
                                </label>
                                <input type="date" 
                                       id="expirationDate" 
                                       name="expirationDate" 
                                       class="form-input input-with-icon"
                                       value="${not empty param.expirationDate ? param.expirationDate : (not empty medication.expirationDate ? medication.expirationDate : '')}" 
                                       required
                                       min="2025-01-01" />
                            </div>

                            <div class="form-group">
                                <label for="price" class="form-label">
                                    <i class="fas fa-dollar-sign input-icon"></i>
                                    Giá bán (VNĐ)
                                </label>
                                <input type="number" 
                                       id="price" 
                                       name="price" 
                                       class="form-input input-with-icon"
                                       step="0.01" 
                                       min="0" 
                                       value="${not empty param.price ? param.price : (not empty medication.price ? medication.price : '')}" 
                                       required />
                            </div>

                            <div class="form-group">
                                <label for="quantity" class="form-label">
                                    <i class="fas fa-boxes input-icon"></i>
                                    Số lượng
                                </label>
                                <input type="number" 
                                       id="quantity" 
                                       name="quantity" 
                                       class="form-input input-with-icon"
                                       min="0" 
                                       value="${not empty param.quantity ? param.quantity : (not empty medication.quantity ? medication.quantity : '')}" 
                                       required />
                            </div>
                        </div>

                        <div class="button-group">
                            <button type="submit" class="btn btn-primary" id="submitBtn">
                                <i class="fas fa-plus-circle"></i>
                                Cập nhật
                            </button>
                            <a href="${pageContext.request.contextPath}/ViewMedicationsServlet" class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i>
                                Quay lại danh sách
                            </a>
                        </div>
                    </form>

                    <!-- Giao diện xác nhận -->
                    <div class="confirmation-overlay">
                        <div class="confirmation-card">
                            <h2>Xác Nhận Nhập Thuốc</h2>
                            <c:if test="${not empty sessionScope.tempMedication}">
                                <div class="confirmation-details">
                                    <div class="detail-item">
                                        <span class="detail-label">Mã thuốc:</span>
                                        <span class="detail-value">${sessionScope.tempMedication.medicationID}</span>
                                    </div>
                                    <div class="detail-item">
                                        <span class="detail-label">Ngày sản xuất:</span>
                                        <span class="detail-value">${sessionScope.tempMedication.productionDate}</span>
                                    </div>
                                    <div class="detail-item">
                                        <span class="detail-label">Hạn sử dụng:</span>
                                        <span class="detail-value">${sessionScope.tempMedication.expirationDate}</span>
                                    </div>
                                    <div class="detail-item">
                                        <span class="detail-label">Giá (VNĐ):</span>
                                        <span class="detail-value">${sessionScope.tempMedication.price}</span>
                                    </div>
                                    <div class="detail-item">
                                        <span class="detail-label">Số lượng:</span>
                                        <span class="detail-value">${sessionScope.tempMedication.quantity}</span>
                                    </div>
                                </div>
                                <div class="confirmation-buttons">
                                    <form action="${pageContext.request.contextPath}/MedicationImportServlet" method="post">
                                        <input type="hidden" name="id" value="${sessionScope.tempMedication.medicationID}" />
                                        <input type="hidden" name="productionDate" value="${sessionScope.tempMedication.productionDate}" />
                                        <input type="hidden" name="expirationDate" value="${sessionScope.tempMedication.expirationDate}" />
                                        <input type="hidden" name="price" value="${sessionScope.tempMedication.price}" />
                                        <input type="hidden" name="quantity" value="${sessionScope.tempMedication.quantity}" />
                                        <input type="hidden" name="confirmAction" value="true" />
                                        <button type="submit" class="btn-confirm">
                                            <i class="fas fa-check"></i> Xác nhận
                                        </button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/MedicationImportServlet" method="get">
                                        <input type="hidden" name="id" value="${sessionScope.tempMedication.medicationID}" />
                                        <input type="hidden" name="cancel" value="true" /> <!-- Thêm tham số cancel -->
                                        <button type="submit" class="btn-cancel">
                                            <i class="fas fa-times"></i> Hủy
                                        </button>
                                    </form>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </c:if>

                <!-- Hiển thị khi không tìm thấy thuốc -->
                <c:if test="${empty medication}">
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-triangle"></i>
                        Vui lòng chọn một loại thuốc để nhập.
                    </div>
                    <div class="button-group">
                        <a href="${pageContext.request.contextPath}/ViewMedicationsServlet" class="btn btn-primary">
                            <i class="fas fa-arrow-left"></i>
                            Quay lại danh sách thuốc
                        </a>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</body>
</html>
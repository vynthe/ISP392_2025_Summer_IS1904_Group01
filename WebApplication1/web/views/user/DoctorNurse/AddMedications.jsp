
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Thêm Thuốc</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Satoshi:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500&display=swap');
        
        :root {
            --primary: #667eea;
            --primary-dark: #5a67d8;
            --secondary: #764ba2;
            --accent: #f093fb;
            --success: #10b981;
            --warning: #f59e0b;
            --error: #ef4444;
            --white: #ffffff;
            --gray-50: #f9fafb;
            --gray-100: #f3f4f6;
            --gray-200: #e5e7eb;
            --gray-300: #d1d5db;
            --gray-400: #9ca3af;
            --gray-500: #6b7280;
            --gray-600: #4b5563;
            --gray-700: #374151;
            --gray-800: #1f2937;
            --gray-900: #111827;
            --gradient-primary: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --gradient-surface: linear-gradient(145deg, #ffffff 0%, #f8fafc 100%);
            --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
            --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
            --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
            --shadow-xl: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);
            --shadow-2xl: 0 25px 50px -12px rgb(0 0 0 / 0.25);
            --border-radius: 20px;
            --border-radius-lg: 24px;
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Satoshi', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background-color: #f4f7fa;
            min-height: 100vh;
            padding: 2rem;
            position: relative;
            overflow-x: hidden;
        }

        .dental-container {
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-2xl);
            width: 100%;
            max-width: 1000px;
            margin: 0 auto;
            position: relative;
            overflow: hidden;
        }

        .dental-header {
            background: var(--gradient-primary);
            padding: 2rem 3rem 1.5rem;
            position: relative;
            overflow: hidden;
        }

        .dental-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -20%;
            width: 300px;
            height: 300px;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            border-radius: 50%;
        }

        .header-content {
            position: relative;
            z-index: 2;
            text-align: center;
        }

        .dental-logo {
            width: 50px;
            height: 50px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        .dental-logo::before {
            content: '🦷';
            font-size: 1.5rem;
            filter: drop-shadow(0 2px 4px rgba(0,0,0,0.1));
        }

        .dental-title {
            color: var(--white);
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.25rem;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
            letter-spacing: -0.025em;
        }

        .dental-subtitle {
            color: rgba(255, 255, 255, 0.9);
            font-size: 1rem;
            font-weight: 400;
            opacity: 0.9;
        }

        .dental-content {
            padding: 2.5rem 3rem 3rem;
        }

        .form-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .form-title {
            font-size: 1.75rem;
            font-weight: 600;
            color: var(--gray-900);
            margin-bottom: 0.5rem;
            letter-spacing: -0.025em;
        }

        .form-description {
            color: var(--gray-600);
            font-size: 1rem;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .form-group {
            position: relative;
        }

        .form-label {
            display: block;
            font-weight: 600;
            color: var(--gray-900);
            margin-bottom: 0.5rem;
            font-size: 0.875rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            position: relative;
        }

        .form-label.required::after {
            content: "*";
            color: var(--error);
            margin-left: 0.25rem;
            font-weight: 700;
        }

        .input-wrapper {
            position: relative;
        }

        .form-input,
        .form-select {
            width: 100%;
            padding: 1rem 3rem 1rem 1.25rem;
            border: 2px solid var(--gray-200);
            border-radius: var(--border-radius);
            font-size: 1rem;
            font-family: inherit;
            background: var(--white);
            transition: var(--transition);
            color: var(--gray-900);
            position: relative;
            z-index: 1;
        }

        .form-input:focus,
        .form-select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
            transform: translateY(-1px);
        }

        .form-input::placeholder {
            color: var(--gray-400);
        }

        textarea.form-input {
            min-height: 100px;
            resize: vertical;
        }

        .input-icon {
            position: absolute;
            right: 1rem;
            top: 50%;
            transform: translateY(-50%);
            font-size: 1.25rem;
            transition: var(--transition);
            z-index: 2;
            opacity: 0.5;
            pointer-events: none;
        }

        .form-input:focus ~ .input-icon,
        .form-select:focus ~ .input-icon {
            opacity: 1;
            transform: translateY(-50%) scale(1.1);
        }

        .form-actions {
            margin-top: 2rem;
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .dental-submit {
            background: var(--gradient-primary);
            color: var(--white);
            border: none;
            padding: 1.25rem 2rem;
            border-radius: var(--border-radius);
            font-size: 1.125rem;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            position: relative;
            overflow: hidden;
            box-shadow: var(--shadow-lg);
        }

        .dental-submit::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.6s;
        }

        .dental-submit:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-xl);
        }

        .dental-submit:hover::before {
            left: 100%;
        }

        .dental-submit:active {
            transform: translateY(0);
        }

        .dental-nav {
            text-align: center;
            padding-top: 1.5rem;
            border-top: 1px solid var(--gray-200);
        }

        .dental-link {
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
            padding: 0.75rem 1.25rem;
            border-radius: var(--border-radius);
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: rgba(102, 126, 234, 0.05);
            border: 1px solid rgba(102, 126, 234, 0.1);
        }

        .dental-link:hover {
            background: rgba(102, 126, 234, 0.1);
            transform: translateY(-1px);
        }

        .error-message {
            background: linear-gradient(135deg, rgba(239, 68, 68, 0.1) 0%, rgba(248, 113, 113, 0.1) 100%);
            color: var(--error);
            padding: 1rem 1.25rem;
            border-radius: var(--border-radius);
            margin-bottom: 1.5rem;
            border: 1px solid rgba(239, 68, 68, 0.2);
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .error-message::before {
            content: "⚠️";
            font-size: 1.125rem;
        }

        @media (max-width: 768px) {
            body { 
                padding: 1rem; 
            }
            
            .dental-container { 
                border-radius: 16px; 
            }
            
            .dental-header { 
                padding: 1.5rem 1.5rem 1rem; 
            }
            
            .dental-title { 
                font-size: 1.75rem; 
            }
            
            .dental-content { 
                padding: 2rem 1.5rem; 
            }
            
            .form-input, 
            .form-select { 
                padding: 0.875rem 2.5rem 0.875rem 1rem; 
            }
            
            .dental-submit { 
                padding: 1rem 1.5rem; 
                font-size: 1rem; 
            }
            
            .form-grid { 
                grid-template-columns: 1fr;
                gap: 1.25rem;
            }

            .input-icon {
                right: 0.75rem;
                font-size: 1rem;
            }
        }
    </style>
</head>
<body>
    <div class="dental-container">
        <div class="dental-header">
            <div class="header-content">
                <div class="dental-logo"></div>
                <h1 class="dental-title">Pure Dental Care</h1>
                <p class="dental-subtitle">Hệ Thống Quản Lý Nha Khoa Thông Minh</p>
            </div>
        </div>

        <div class="dental-content">
            <div class="form-header">
                <h2 class="form-title">Thêm Thuốc</h2>
                <p class="form-description">Nhập thông tin chi tiết của thuốc để thêm vào hệ thống</p>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="error-message">${errorMessage}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/AddMedicationsServlet" method="post">
                <div class="form-grid">
                    <div class="form-group">
                        <label for="name" class="form-label required">Tên Thuốc</label>
                        <div class="input-wrapper">
                            <input type="text" id="name" name="drugName" class="form-input" 
                                   value="${formDrugName}" placeholder="Nhập tên thuốc..." required>
                            <span class="input-icon">💊</span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="dosage" class="form-label required">Hàm Lượng</label>
                        <div class="input-wrapper">
                            <input type="text" id="dosage" name="dosage" class="form-input" 
                                   value="${formDosage}" placeholder="Nhập hàm lượng..." required>
                            <span class="input-icon">⚖️</span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="manufacturer" class="form-label required">Nhà Sản Xuất</label>
                        <div class="input-wrapper">
                            <input type="text" id="manufacturer" name="manufacturer" class="form-input" 
                                   value="${formManufacturer}" placeholder="Nhập nhà sản xuất..." required>
                            <span class="input-icon">🏭</span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="description" class="form-label">Mô Tả</label>
                        <div class="input-wrapper">
                            <textarea id="description" name="description" class="form-input" 
                                      placeholder="Nhập mô tả thuốc...">${formDescription}</textarea>
                            <span class="input-icon">📝</span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="productionDate" class="form-label required">Ngày Sản Xuất</label>
                        <div class="input-wrapper">
                            <input type="date" id="productionDate" name="manufacturingDate" class="form-input" 
                                   value="${formManufacturingDate}" max="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>" required>
                            <span class="input-icon">📅</span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="expirationDate" class="form-label required">Ngày Hết Hạn</label>
                        <div class="input-wrapper">
                            <input type="date" id="expirationDate" name="expiryDate" class="form-input" 
                                   value="${formExpiryDate}" required>
                            <span class="input-icon">⏳</span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="price" class="form-label required">Giá</label>
                        <div class="input-wrapper">
                            <input type="number" id="price" name="price" class="form-input" 
                                   value="${formPrice}" placeholder="Nhập giá..." step="0.01" min="0" required>
                            <span class="input-icon">💰</span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="quantity" class="form-label required">Số Lượng</label>
                        <div class="input-wrapper">
                            <input type="number" id="quantity" name="quantity" class="form-input" 
                                   value="${formQuantity}" placeholder="Nhập số lượng..." min="0" required>
                            <span class="input-icon">📦</span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="dosageForm" class="form-label required">Dạng Bào Chế</label>
                        <div class="input-wrapper">
                            <select id="dosageForm" name="dosageForm" class="form-select" required>
                                <option value="" ${empty formData.dosageForm ? 'selected' : ''}>Chọn dạng bào chế...</option>
                                <option value="Tablet" ${formData.dosageForm == 'Tablet' ? 'selected' : ''}>Viên nén</option>
                                <option value="Capsule" ${formData.dosageForm == 'Capsule' ? 'selected' : ''}>Viên nang</option>
                                <option value="Injection" ${formData.dosageForm == 'Injection' ? 'selected' : ''}>Tiêm</option>
                                <option value="Syrup" ${formData.dosageForm == 'Syrup' ? 'selected' : ''}>Sirô</option>
                                <option value="Cream" ${formData.dosageForm == 'Cream' ? 'selected' : ''}>Kem</option>
                            </select>
                            <span class="input-icon">🔬</span>
                        </div>
                    </div>
                </div>

                <input type="hidden" name="save" value="true">

                <div class="form-actions">
                    <button type="submit" class="dental-submit">Thêm Thuốc</button>
                </div>
            </form>

            <div class="dental-nav">
                <a href="${pageContext.request.contextPath}/ViewMedicationsServlet" class="dental-link">
                    <span>←</span>
                    <span>Quay lại danh sách thuốc</span>
                </a>
            </div>
        </div>
    </div>
</body>
</html>
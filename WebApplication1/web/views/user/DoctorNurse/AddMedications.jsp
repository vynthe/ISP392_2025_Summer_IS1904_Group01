<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
            --gradient-accent: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            --gradient-bg: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
            --gradient-surface: linear-gradient(145deg, #ffffff 0%, #f8fafc 100%);
            --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
            --shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1);
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
            background: var(--gradient-bg);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
            position: relative;
            overflow-x: hidden;
        }

        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: 
                radial-gradient(circle at 20% 80%, rgba(120, 119, 198, 0.3) 0%, transparent 50%),
                radial-gradient(circle at 80% 20%, rgba(255, 119, 198, 0.3) 0%, transparent 50%),
                radial-gradient(circle at 40% 40%, rgba(120, 119, 198, 0.2) 0%, transparent 50%);
            pointer-events: none;
        }

        .dental-container {
            background: #ffffff;
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-2xl);
            width: 100%;
            max-width: 900px;
            position: relative;
            overflow: hidden;
        }

        .dental-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 1px;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.8), transparent);
        }

        .dental-header {
            background: var(--gradient-primary);
            padding: 3rem 3rem 2rem;
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

        .dental-header::after {
            content: '';
            position: absolute;
            bottom: -40%;
            left: -15%;
            width: 250px;
            height: 250px;
            background: radial-gradient(circle, rgba(255,255,255,0.05) 0%, transparent 70%);
            border-radius: 50%;
        }

        .header-content {
            position: relative;
            z-index: 2;
            text-align: center;
        }

        .dental-logo {
            width: 60px;
            height: 60px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        .dental-logo::before {
            content: '🦷';
            font-size: 2rem;
            filter: drop-shadow(0 2px 4px rgba(0,0,0,0.1));
        }

        .dental-title {
            color: var(--white);
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
            letter-spacing: -0.025em;
        }

        .dental-subtitle {
            color: rgba(255, 255, 255, 0.9);
            font-size: 1.125rem;
            font-weight: 400;
            opacity: 0.9;
        }

        .dental-content {
            padding: 3rem;
        }

        .form-header {
            text-align: center;
            margin-bottom: 2.5rem;
        }

        .form-title {
            font-size: 1.875rem;
            font-weight: 600;
            color: var(--gray-900);
            margin-bottom: 0.5rem;
            letter-spacing: -0.025em;
        }

        .form-description {
            color: var(--gray-600);
            font-size: 1rem;
        }

        .medical-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.1) 0%, rgba(6, 182, 212, 0.1) 100%);
            color: var(--success);
            padding: 0.75rem 1.25rem;
            border-radius: 50px;
            font-size: 0.875rem;
            font-weight: 600;
            margin-bottom: 2rem;
            border: 1px solid rgba(16,173,129,0.2);
            position: relative;
            overflow: hidden;
        }

        .medical-badge::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.6s;
        }

        .medical-badge:hover::before {
            left: 100%;
        }

        .form-grid {
            display: grid;
            gap: 2rem;
        }

        .form-group {
            position: relative;
        }

        .form-label {
            display: block;
            font-weight: 600;
            color: var(--gray-900);
            margin-bottom: 0.75rem;
            font-size: 0.9rem;
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
            group: true;
        }

        .form-input,
        .form-textarea,
        .form-select {
            width: 100%;
            padding: 1.25rem 1.5rem;
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
        .form-textarea:focus,
        .form-select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
            transform: translateY(-1px);
        }

        .form-textarea {
            min-height: 120px;
            resize: vertical;
            font-family: inherit;
            line-height: 1.6;
        }

        .form-select {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke-width='1.5' stroke='%236b7280' class='w-6 h-6'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' d='M19.5 8.25l-7.5 7.5-7.5-7.5' /%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 1.5rem center;
            background-size: 1.5em;
        }

        .input-icon {
            position: absolute;
            right: 1.25rem;
            top: 50%;
            transform: translateY(-50%);
            font-size: 1.25rem;
            transition: var(--transition);
            z-index: 2;
            opacity: 0.5;
        }

        .form-input:focus + .input-icon,
        .form-textarea:focus + .input-icon,
        .form-select:focus + .input-icon {
            opacity: 1;
            transform: translateY(-50%) scale(1.1);
        }

        .autocomplete-suggestions {
            position: absolute;
            background: #ffffff;
            border: 1px solid var(--gray-200);
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-md);
            max-height: 300px;
            overflow-y: auto;
            width: 100%;
            z-index: 10;
            display: none;
        }

        .autocomplete-suggestion {
            padding: 1rem;
            cursor: pointer;
            transition: var(--transition);
            border-bottom: 1px solid var(--gray-200);
        }

        .autocomplete-suggestion:last-child {
            border-bottom: none;
        }

        .autocomplete-suggestion:hover {
            background: var(--gray-100);
        }

        .form-actions {
            margin-top: 2.5rem;
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
            padding-top: 2rem;
            border-top: 1px solid var(--gray-200);
        }

        .dental-link {
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
            padding: 1rem 1.5rem;
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
            padding: 1.25rem 1.5rem;
            border-radius: var(--border-radius);
            margin-bottom: 2rem;
            border: 1px solid rgba(239, 68, 68, 0.2);
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .error-message::before {
            content: "⚠️";
            font-size: 1.25rem;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            body {
                padding: 1rem;
            }
            
            .dental-container {
                border-radius: 16px;
            }
            
            .dental-header {
                padding: 2rem 1.5rem;
            }
            
            .dental-title {
                font-size: 2rem;
            }
            
            .dental-content {
                padding: 2rem 1.5rem;
            }
            
            .form-input,
            .form-textarea,
            .form-select {
                padding: 1rem 1.25rem;
            }
            
            .dental-submit {
                padding: 1rem 1.5rem;
                font-size: 1rem;
            }
        }

        /* Animation Classes */
        .fade-in {
            animation: fadeIn 0.6s ease-out;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .pulse {
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.05);
            }
        }

        .form-input.valid,
        .form-select.valid {
            border-color: var(--success);
            background: rgba(16, 185, 129, 0.02);
        }

        .form-input.invalid,
        .form-select.invalid {
            border-color: var(--error);
            background: rgba(239, 68, 68, 0.02);
        }

        .form-input.valid + .input-icon,
        .form-select.valid + .input-icon {
            color: var(--success);
        }

        .form-input.invalid + .input-icon,
        .form-select.invalid + .input-icon {
            color: var(--error);
        }

        .loading .dental-submit {
            background: var(--gray-400);
            cursor: not-allowed;
            pointer-events: none;
        }

        .loading .dental-submit::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 20px;
            height: 20px;
            margin: -10px 0 0 -10px;
            border: 2px solid transparent;
            border-top: 2px solid var(--white);
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <div class="dental-container fade-in">
        <div class="progress-indicator"></div>
        
        <div class="dental-header">
            <div class="header-content">
                <div class="dental-logo pulse"></div>
                <h1 class="dental-title">Pure Dental Care</h1>
                <p class="dental-subtitle">Hệ Thống Quản Lý Nha Khoa Thông Minh</p>
            </div>
        </div>

        <div class="dental-content">
            <div class="form-header">
                <h2 class="form-title">Thêm Thuốc</h2>
                <p class="form-description">Nhập thông tin thuốc và kiểm tra thông tin từ cơ sở dữ liệu thuốc</p>
            </div>

            <div class="medical-badge">
                <span>⚕️</span>
                <span>Kê đơn thuốc an toàn</span>
            </div>

            <% String error = (String) request.getAttribute("error"); %>
            <% if (error != null) { %>
                <div class="error-message"><%= error %></div>
            <% } %>

            <form action="${pageContext.request.contextPath}/AddMedicationsServlet" method="post" id="medicationForm">
                <div class="form-grid">
                    <div class="form-group">
                        <label for="drugName" class="form-label required">Tên Thuốc</label>
                        <div class="input-wrapper">
                            <input type="text" id="drugName" name="drugName" class="form-input" 
                                   placeholder="Nhập tên thuốc (generic name)..." required 
                                   value="<%= request.getAttribute("formDrugName") != null ? request.getAttribute("formDrugName") : "" %>"
                                   autocomplete="off">
                            <span class="input-icon">💊</span>
                            <div class="autocomplete-suggestions" id="suggestions"></div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="manufacturingDate" class="form-label required">Ngày Sản Xuất</label>
                        <div class="input-wrapper">
                            <input type="date" id="manufacturingDate" name="manufacturingDate" class="form-input" 
                                   value="<%= request.getAttribute("formManufacturingDate") != null ? request.getAttribute("formManufacturingDate") : "" %>"
                                   max="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>"
                                   required>
                            <span class="input-icon">📅</span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="expiryDate" class="form-label required">Ngày Hết Hạn</label>
                        <div class="input-wrapper">
                            <input type="date" id="expiryDate" name="expiryDate" class="form-input" 
                                   value="<%= request.getAttribute("formExpiryDate") != null ? request.getAttribute("formExpiryDate") : "" %>"
                                   required>
                            <span class="input-icon">⏳</span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="quantity" class="form-label required">Số Lượng</label>
                        <div class="input-wrapper">
                            <input type="number" id="quantity" name="quantity" class="form-input" 
                                   placeholder="Nhập số lượng..." required 
                                   value="<%= request.getAttribute("formQuantity") != null ? request.getAttribute("formQuantity") : "" %>"
                                   min="0">
                            <span class="input-icon">📦</span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Lưu Vào Database</label>
                        <div class="checkbox-group">
                            <div class="checkbox-item">
                                <input type="checkbox" id="save" name="save" value="true" 
                                       <%= "true".equals(request.getParameter("save")) ? "checked" : "" %>>
                                <span class="checkmark"></span>
                                <span class="checkbox-label">Lưu thông tin vào database</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="dental-submit">
                        <span class="submit-text">Thêm Thuốc</span>
                    </button>
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

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('medicationForm');
            const drugNameInput = document.getElementById('drugName');
            const suggestionsDiv = document.getElementById('suggestions');
            const inputs = document.querySelectorAll('.form-input');
            const checkboxes = document.querySelectorAll('input[type="checkbox"]');
            const progressBar = document.querySelector('.progress-indicator');
            const submitBtn = document.querySelector('.dental-submit');

            drugNameInput.addEventListener('input', function() {
                const query = this.value.trim();
                if (query.length < 3) {
                    suggestionsDiv.style.display = 'none';
                    drugNameInput.classList.remove('valid', 'invalid');
                    return;
                }
                $.ajax({
                    url: 'https://api.fda.gov/drug/label.json',
                    data: {
                        search: 'generic_name:' + encodeURIComponent(query),
                        limit: 5
                    },
                    success: function(response) {
                        suggestionsDiv.innerHTML = '';
                        if (response.results && response.results.length > 0) {
                            response.results.forEach(function(drug) {
                                const genericName = drug.openfda && drug.openfda.generic_name 
                                    ? drug.openfda.generic_name[0] 
                                    : drug.active_ingredient 
                                    ? drug.active_ingredient[0] 
                                    : query;
                                const div = document.createElement('div');
                                div.className = 'autocomplete-suggestion';
                                div.textContent = genericName;
                                div.addEventListener('click', function() {
                                    drugNameInput.value = genericName;
                                    drugNameInput.classList.add('valid');
                                    drugNameInput.classList.remove('invalid');
                                    suggestionsDiv.style.display = 'none';
                                    updateProgress();
                                });
                                suggestionsDiv.appendChild(div);
                            });
                            suggestionsDiv.style.display = 'block';
                        } else {
                            suggestionsDiv.style.display = 'none';
                            drugNameInput.classList.add('invalid');
                            drugNameInput.classList.remove('valid');
                        }
                    },
                    error: function() {
                        suggestionsDiv.style.display = 'none';
                        drugNameInput.classList.add('invalid');
                        drugNameInput.classList.remove('valid');
                    }
                });
            });

            document.addEventListener('click', function(e) {
                if (!suggestionsDiv.contains(e.target) && e.target !== drugNameInput) {
                    suggestionsDiv.style.display = 'none';
                }
            });

            checkboxes.forEach(checkbox => {
                checkbox.addEventListener('change', function() {
                    const checkboxItem = this.closest('.checkbox-item');
                    if (this.checked) {
                        checkboxItem.classList.add('checked');
                    } else {
                        checkboxItem.classList.remove('checked');
                    }
                    updateProgress();
                });
            });

            function updateProgress() {
                const totalFields = inputs.length + 1;
                let filledFields = Array.from(inputs).filter(input => input.value.trim() !== '').length;
                const hasSelectedCheckbox = Array.from(checkboxes).some(cb => cb.checked);
                if (hasSelectedCheckbox) filledFields++;
                const progress = (filledFields / totalFields) * 100;
                progressBar.style.width = progress + '%';
            }

            inputs.forEach(input => {
                input.addEventListener('input', function() {
                    updateProgress();
                    if (input.value.trim() !== '') {
                        input.classList.add('valid');
                        input.classList.remove('invalid');
                    } else {
                        input.classList.remove('valid');
                        input.classList.add('invalid');
                    }
                });
                input.addEventListener('focus', function() {
                    this.parentElement.style.transform = 'scale(1.02)';
                });
                input.addEventListener('blur', function() {
                    this.parentElement.style.transform = 'scale(1)';
                });
            });

            form.addEventListener('submit', function(e) {
                e.preventDefault();
                const drugName = document.getElementById('drugName').value.trim();
                const manufacturingDate = document.getElementById('manufacturingDate').value;
                const expiryDate = document.getElementById('expiryDate').value;
                const quantity = document.getElementById('quantity').value;

                if (!drugName || !manufacturingDate || !expiryDate || !quantity) {
                    alert('Vui lòng điền đầy đủ thông tin bắt buộc.');
                    return;
                }

                if (parseInt(quantity) < 0) {
                    alert('Số lượng phải lớn hơn hoặc bằng 0.');
                    return;
                }

                if (manufacturingDate > expiryDate) {
                    alert('Ngày sản xuất không được sau ngày hết hạn.');
                    return;
                }

                document.body.classList.add('loading');
                submitBtn.querySelector('.submit-text').textContent = 'Đang xử lý...';
                form.submit();
            });
        });
    </script>
</body>
</html>
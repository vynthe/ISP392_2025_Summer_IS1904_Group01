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
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
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
            border: 1px solid rgba(16, 185, 129, 0.2);
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
        .form-textarea {
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
        .form-textarea:focus {
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
        .form-textarea:focus + .input-icon {
            opacity: 1;
            transform: translateY(-50%) scale(1.1);
        }

        /* Checkbox Group Styling */
        .checkbox-group {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-top: 0.75rem;
        }

        .checkbox-item {
            position: relative;
            display: flex;
            align-items: center;
            padding: 1rem 1.25rem;
            background: var(--white);
            border: 2px solid var(--gray-200);
            border-radius: var(--border-radius);
            cursor: pointer;
            transition: var(--transition);
            user-select: none;
        }

        .checkbox-item:hover {
            border-color: var(--primary);
            background: rgba(102, 126, 234, 0.02);
            transform: translateY(-1px);
        }

        .checkbox-item input[type="checkbox"] {
            position: absolute;
            opacity: 0;
            cursor: pointer;
            width: 100%;
            height: 100%;
            margin: 0;
        }

        .checkbox-item .checkmark {
            position: relative;
            width: 20px;
            height: 20px;
            border: 2px solid var(--gray-300);
            border-radius: 6px;
            margin-right: 0.75rem;
            transition: var(--transition);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .checkbox-item input:checked + .checkmark {
            background: var(--primary);
            border-color: var(--primary);
        }

        .checkbox-item input:checked + .checkmark::after {
            content: '✓';
            color: white;
            font-size: 12px;
            font-weight: bold;
        }

        .checkbox-item .checkbox-label {
            font-weight: 500;
            color: var(--gray-700);
            font-size: 0.95rem;
        }

        .checkbox-item input:checked ~ .checkbox-label {
            color: var(--primary);
            font-weight: 600;
        }

        .checkbox-item.checked {
            border-color: var(--primary);
            background: rgba(102, 126, 234, 0.05);
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
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

        /* Enhanced Form Grid Layout */
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
        }

        /* Progress Indicator */
        .progress-indicator {
            position: absolute;
            top: 0;
            left: 0;
            height: 4px;
            background: var(--gradient-accent);
            border-radius: 2px;
            width: 0%;
            transition: width 0.3s ease;
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
            
            .form-row {
                grid-template-columns: 1fr;
                gap: 1.5rem;
            }

            .checkbox-group {
                grid-template-columns: 1fr;
            }
            
            .form-input,
            .form-textarea {
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

        /* Success State */
        .form-input.valid {
            border-color: var(--success);
            background: rgba(16, 185, 129, 0.02);
        }

        .form-input.valid + .input-icon {
            color: var(--success);
        }

        /* Loading State */
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
                <p class="form-description">Tạo toa thuốc chính xác và an toàn cho bệnh nhân</p>
            </div>

            <div class="medical-badge">
                <span>⚕️</span>
                <span>Kê đơn thuốc an toàn</span>
            </div>

            <% String error = (String) request.getAttribute("error"); %>
            <% if (error != null) { %>
                <div class="error-message"><%= error %></div>
            <% } %>

            <form action="${pageContext.request.contextPath}/AddMedicationsServlet" method="post" id="prescriptionForm">
                    <input type="hidden" name="resultId" value="${resultId}" />
                   <div class="form-grid">
                    <div class="form-group">
                        <label for="tenThuoc" class="form-label required">Tên Thuốc</label>
                        <div class="input-wrapper">
                            <input type="text" id="tenThuoc" name="tenThuoc" class="form-input" 
                                   placeholder="Nhập tên thuốc cần kê..." required>
                            <span class="input-icon">💊</span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="soLuong" class="form-label required">Số Lượng</label>
                        <div class="input-wrapper">
                            <input type="number" id="soLuong" name="soLuong" class="form-input" 
                                   min="1" placeholder="Số lượng thuốc cần kê" required>
                            <span class="input-icon">📦</span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label required">Liều Dùng</label>
                        <div class="checkbox-group">
                            <div class="checkbox-item">
                                <input type="checkbox" id="lieu1" name="lieuDung" value="1 lần/1 ngày">
                                <span class="checkmark"></span>
                                <span class="checkbox-label">1 lần/1 ngày</span>
                            </div>
                            <div class="checkbox-item">
                                <input type="checkbox" id="lieu2" name="lieuDung" value="2 lần/1 ngày">
                                <span class="checkmark"></span>
                                <span class="checkbox-label">2 lần/1 ngày</span>
                            </div>
                            <div class="checkbox-item">
                                <input type="checkbox" id="lieu3" name="lieuDung" value="3 lần/1 ngày">
                                <span class="checkmark"></span>
                                <span class="checkbox-label">3 lần/1 ngày</span>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="moTaThuoc" class="form-label required">Mô Tả Thuốc</label>
                        <div class="input-wrapper">
                            <textarea id="moTaThuoc" name="moTaThuoc" class="form-textarea" 
                                      placeholder="Mô tả chi tiết về thuốc, cách sử dụng và lưu ý đặc biệt..." required></textarea>
                            <span class="input-icon">📝</span>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="ngayKeToa" class="form-label required">Ngày Kê Toa</label>
                            <div class="input-wrapper">
                                <input type="date" id="ngayKeToa" name="ngayKeToa" class="form-input" required>
                                <span class="input-icon">📅</span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="hanSuDung" class="form-label required">Hạn Sử Dụng</label>
                            <div class="input-wrapper">
                                <input type="date" id="hanSuDung" name="hanSuDung" class="form-input" required>
                                <span class="input-icon">⏰</span>
                            </div>
                        </div>
                    </div>

                </div>

                <div class="form-actions">
                    <button type="submit" class="dental-submit">
                        <span class="submit-text">Tạo Toa Thuốc</span>
                    </button>
                </div>
            </form>

            <div class="dental-nav">
                <a href="${pageContext.request.contextPath}/ViewMedicationsServlet" class="dental-link">
                    <span>←</span>
                    <span>Quay lại danh sách toa thuốc</span>
                </a>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('prescriptionForm');
            const inputs = document.querySelectorAll('.form-input, .form-textarea');
            const checkboxes = document.querySelectorAll('input[type="checkbox"]');
            const progressBar = document.querySelector('.progress-indicator');
            const submitBtn = document.querySelector('.dental-submit');
            
            // Auto-fill dates
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('ngayKeToa').value = today;
            
            const expiryDate = new Date();
            expiryDate.setDate(expiryDate.getDate() + 30);
            document.getElementById('hanSuDung').value = expiryDate.toISOString().split('T')[0];
            
            // Handle checkbox interactions
            checkboxes.forEach(checkbox => {
                checkbox.addEventListener('change', function() {
                    const checkboxItem = this.closest('.checkbox-item');
                    
                    if (this.checked) {
                        checkboxItem.classList.add('checked');
                        // Uncheck other checkboxes (single selection)
                        checkboxes.forEach(cb => {
                            if (cb !== this && cb.checked) {
                                cb.checked = false;
                                cb.closest('.checkbox-item').classList.remove('checked');
                            }
                        });
                    } else {
                        checkboxItem.classList.remove('checked');
                    }
                    
                    updateProgress();
                });
            });
            
            // Form validation and progress
            function updateProgress() {
                const totalFields = inputs.length + 1; // +1 for checkbox group
                let filledFields = Array.from(inputs).filter(input => input.value.trim() !== '').length;
                
                // Check if at least one checkbox is selected
                const hasSelectedCheckbox = Array.from(checkboxes).some(cb => cb.checked);
                if (hasSelectedCheckbox) filledFields++;
                
                const progress = (filledFields / totalFields) * 100;
                progressBar.style.width = progress + '%';
            }
            
            inputs.forEach(input => {
                input.addEventListener('input', updateProgress);
                
                input.addEventListener('blur', function() {
                    if (this.value.trim() !== '') {
                        this.classList.add('valid');
                    } else {
                        this.classList.remove('valid');
                    }
                });

                input.addEventListener('focus', function() {
                    this.parentElement.style.transform = 'scale(1.02)';
                });
                
                input.addEventListener('blur', function() {
                    this.parentElement.style.transform = 'scale(1)';
                });
            });
            
            // Form submission validation
            form.addEventListener('submit', function(e) {
                const hasSelectedCheckbox = Array.from(checkboxes).some(cb => cb.checked);
                if (!hasSelectedCheckbox) {
                    e.preventDefault();
                    alert('Vui lòng chọn ít nhất một liều dùng.');
                    return;
                }
                
                document.body.classList.add('loading');
                submitBtn.querySelector('.submit-text').textContent = 'Đang xử lý...';
            });
            
            // Initial progress update
            updateProgress();
            
            // Add smooth animations
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.opacity = '1';
                        entry.target.style.transform = 'translateY(0)';
                    }
                });
            });
            
            document.querySelectorAll('.form-group').forEach(group => {
                group.style.opacity = '0';
                group.style.transform = 'translateY(20px)';
                group.style.transition = 'all 0.6s ease';
                observer.observe(group);
            });
        });
    </script>
</body>
</html>
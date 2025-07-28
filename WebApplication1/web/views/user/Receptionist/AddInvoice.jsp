<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thêm Hóa Đơn</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            /* ✅ CSS STYLES CHÍNH: Layout và container */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                padding: 20px;
                color: #333;
            }

            .container {
                max-width: 1400px;
                margin: 0 auto;
                background: white;
                border-radius: 24px;
                overflow: hidden;
                box-shadow: 0 25px 50px rgba(0, 0, 0, 0.15);
                animation: slideUp 0.8s ease-out;
            }

            @keyframes slideUp {
                from {
                    opacity: 0;
                    transform: translateY(50px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* ✅ HEADER STYLES: Tiêu đề trang */
            .header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 40px;
                text-align: center;
                position: relative;
                overflow: hidden;
            }

            .header::before {
                content: '';
                position: absolute;
                top: -50%;
                left: -50%;
                width: 200%;
                height: 200%;
                background: radial-gradient(circle, rgba(255,255,255,0.1) 1px, transparent 1px);
                background-size: 30px 30px;
                animation: float 20s infinite linear;
            }

            @keyframes float {
                0% {
                    transform: translate(-50%, -50%) rotate(0deg);
                }
                100% {
                    transform: translate(-50%, -50%) rotate(360deg);
                }
            }

            .header-content {
                position: relative;
                z-index: 2;
            }

            .header h1 {
                font-size: 2.8rem;
                font-weight: 700;
                margin-bottom: 12px;
                letter-spacing: -1px;
            }

            .header .subtitle {
                font-size: 1.2rem;
                opacity: 0.9;
                font-weight: 400;
            }

            .header-icon {
                font-size: 3.5rem;
                margin-bottom: 20px;
                opacity: 0.8;
            }

            /* ✅ MAIN CONTENT: Nội dung chính */
            .main-content {
                padding: 40px;
            }

            /* ✅ FORM CONTAINER: Container cho form */
            .form-container {
                max-width: 800px;
                margin: 0 auto;
                background: white;
                border-radius: 20px;
                padding: 40px;
                box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
                border: 1px solid #f0f0f0;
            }
            
            /* ✅ FORM ROW: Layout 2 cột cho form */
            .form-row {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
                margin-bottom: 20px;
            }
            
            /* ✅ FORM GROUP: Nhóm các field */
            .form-group {
                display: flex;
                flex-direction: column;
            }
            
            .form-group label {
                font-weight: 600;
                margin-bottom: 8px;
                color: #333;
                font-size: 0.95rem;
            }
            
            .form-group input, .form-group textarea {
                padding: 12px;
                border: 2px solid #e1e8ed;
                border-radius: 8px;
                font-size: 14px;
                transition: all 0.3s ease;
            }
            
            .form-group input:focus, .form-group textarea:focus {
                outline: none;
                border-color: #667eea;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
                transform: translateY(-2px);
            }
            
            /* ✅ READONLY FIELD: Field chỉ đọc */
            .readonly-field {
                background-color: #f8f9fa;
                color: #666;
                cursor: not-allowed;
            }
            
            /* ✅ BUTTON STYLES: Nút submit full width */
            .button-group {
                margin-top: 30px;
            }
            
            .submit-btn {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border: none;
                padding: 15px 30px;
                border-radius: 10px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                width: 100%;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
            }
            
            .submit-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 12px 35px rgba(102, 126, 234, 0.4);
            }



            /* ✅ RESPONSIVE: Responsive design */
            @media (max-width: 768px) {
                body {
                    padding: 10px;
                }

                .container {
                    border-radius: 16px;
                }

                .header {
                    padding: 30px 20px;
                }

                .header h1 {
                    font-size: 2.2rem;
                }

                .main-content {
                    padding: 25px;
                }

                .form-container {
                    padding: 25px;
                }

                .form-row {
                    grid-template-columns: 1fr;
                    gap: 15px;
                }


            }
        </style>
    </head>
    <body>
        <div class="container">
            <!-- ✅ HEADER: Tiêu đề trang -->
            <div class="header">
                <div class="header-content">
                    <div class="header-icon">
                        <i class="fas fa-plus-circle"></i>
                    </div>
                    <h1>Thêm Hóa Đơn</h1>
                    <p class="subtitle">Tạo hóa đơn cho kết quả khám</p>
                </div>
            </div>

            <div class="main-content">
                <div class="form-container">
                    <!-- ✅ FORM: Form thêm hóa đơn -->
                    <form method="post" action="${pageContext.request.contextPath}/AddInvoiceServlet">
                        
                        <!-- ✅ THÔNG TIN KẾT QUẢ KHÁM: Các field readonly -->
                        <div class="form-row">
                            <div class="form-group">
                                <label><i class="fas fa-barcode"></i> Mã Kết Quả:</label>
                                <input type="text" value="${resultId}" readonly class="readonly-field">
                                <input type="hidden" name="resultId" value="${resultId}">
                            </div>
                            <div class="form-group">
                                <label><i class="fas fa-user"></i> Bệnh Nhân:</label>
                                <input type="text" value="${patientName}" readonly class="readonly-field">
                                <input type="hidden" name="patientId" value="${patientId}">
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label><i class="fas fa-user-md"></i> Bác Sĩ:</label>
                                <input type="text" value="${doctorName}" readonly class="readonly-field">
                                <input type="hidden" name="doctorId" value="${doctorId}">
                            </div>
                            <div class="form-group">
                                <label><i class="fas fa-stethoscope"></i> Dịch Vụ:</label>
                                <input type="text" value="${serviceName}" readonly class="readonly-field">
                                <input type="hidden" name="serviceId" value="${serviceId}">
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label><i class="fas fa-clipboard-check"></i> Chẩn Đoán:</label>
                            <textarea rows="3" readonly class="readonly-field">${diagnosis}</textarea>
                        </div>
                        
                        <!-- ✅ THÔNG TIN TIỀN: Phí dịch vụ và tổng tiền tự động từ database -->
                        <div class="form-row">
                            <div class="form-group">
                                <label><i class="fas fa-money-bill-wave"></i> Phí Dịch Vụ (VNĐ):</label>
                                <!-- ✅ HIỂN THỊ: Phí dịch vụ thực tế từ bảng Services -->
                                <input type="number" value="${servicePrice}" readonly class="readonly-field">
                            </div>
                            <div class="form-group">
                                <label><i class="fas fa-calculator"></i> Tổng Tiền (VNĐ):</label>
                                <!-- ✅ TỰ ĐỘNG: Tổng tiền = Phí dịch vụ (không cần nhập) -->
                                <input type="number" value="${servicePrice}" readonly class="readonly-field">
                                <!-- ✅ QUAN TRỌNG: Hidden input để gửi totalAmount -->
                                <input type="hidden" name="totalAmount" value="${servicePrice}">
                            </div>
                        </div>
                        

                        
                        <!-- ✅ BUTTON: Chỉ có nút submit -->
                        <div class="button-group">
                            <button type="submit" class="submit-btn">
                                <i class="fas fa-check"></i>
                                Xác Nhận Thêm Hóa Đơn
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>


    </body>
</html>
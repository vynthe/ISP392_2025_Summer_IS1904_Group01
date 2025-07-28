<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Danh Sách Hóa Đơn</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
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

            .main-content {
                padding: 40px;
            }

            .message {
                margin-bottom: 30px;
                padding: 20px 25px;
                border-radius: 16px;
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 15px;
                animation: fadeInScale 0.6s ease-out;
            }

            .message.success {
                background: linear-gradient(135deg, #d4f8d4 0%, #a8e6a8 100%);
                color: #2e7d32;
                border-left: 5px solid #4caf50;
            }

            .message.error {
                background: linear-gradient(135deg, #ffe0e0 0%, #ffcccc 100%);
                color: #d32f2f;
                border-left: 5px solid #f44336;
            }

            .message i {
                font-size: 1.4rem;
            }

            @keyframes fadeInScale {
                from {
                    opacity: 0;
                    transform: scale(0.9);
                }
                to {
                    opacity: 1;
                    transform: scale(1);
                }
            }

            .search-section {
                background: linear-gradient(135deg, #f8faff 0%, #e8f4f8 100%);
                border-radius: 20px;
                padding: 35px;
                margin-bottom: 35px;
                border: 1px solid rgba(102, 126, 234, 0.1);
                box-shadow: 0 8px 32px rgba(102, 126, 234, 0.1);
            }

            .search-title {
                font-size: 1.5rem;
                font-weight: 600;
                color: #333;
                margin-bottom: 25px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .search-form {
                display: grid;
                grid-template-columns: 1fr 1fr auto;
                gap: 25px;
                align-items: end;
            }

            .form-group {
                display: flex;
                flex-direction: column;
            }

            .form-group label {
                color: #555;
                font-weight: 600;
                margin-bottom: 10px;
                font-size: 0.95rem;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .form-group input {
                padding: 16px 20px;
                border: 2px solid #e1e8ed;
                border-radius: 12px;
                font-size: 1rem;
                transition: all 0.3s ease;
                background: white;
            }

            .form-group input:focus {
                outline: none;
                border-color: #667eea;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
                transform: translateY(-2px);
            }

            .search-btn {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border: none;
                padding: 16px 28px;
                border-radius: 12px;
                font-size: 1rem;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 10px;
                box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
            }

            .search-btn:hover {
                transform: translateY(-3px);
                box-shadow: 0 12px 35px rgba(102, 126, 234, 0.4);
            }

            .search-btn:active {
                transform: translateY(-1px);
            }

            .table-section {
                background: white;
                border-radius: 20px;
                overflow: hidden;
                box-shadow: 0 10px 40px rgba(0, 0, 0, 0.08);
                margin-bottom: 35px;
                border: 1px solid #f0f0f0;
            }

            .table {
                width: 100%;
                border-collapse: collapse;
            }

            .table thead {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
            }

            .table th {
                padding: 25px 20px;
                font-weight: 600;
                text-align: left;
                font-size: 0.9rem;
                letter-spacing: 0.5px;
                text-transform: uppercase;
                border: none;
            }

            .table th i {
                margin-right: 8px;
                opacity: 0.8;
            }

            .table td {
                padding: 20px;
                border-bottom: 1px solid #f5f5f5;
                vertical-align: middle;
                border: none;
            }

            .table tbody tr {
                transition: all 0.3s ease;
                background: white;
            }

            .table tbody tr:nth-child(even) {
                background: #fafbff;
            }

            .table tbody tr:hover {
                background: linear-gradient(135deg, #f0f4ff 0%, #e8f0fe 100%);
                transform: scale(1.005);
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            }

            .stt-cell {
                font-weight: 700;
                color: #667eea;
                text-align: center;
                width: 80px;
                font-size: 1.1rem;
            }

            .id-cell {
                font-family: 'JetBrains Mono', 'Courier New', monospace;
                color: #2196F3;
                font-weight: 600;
                font-size: 0.9rem;
            }

            .name-cell {
                font-weight: 600;
                color: #333;
            }

            .doctor-cell {
                color: #4caf50;
                font-weight: 500;
            }

            .service-cell {
                background: linear-gradient(135deg, #e8f5e8 0%, #f0f8f0 100%);
                color: #2e7d32;
                font-weight: 500;
                border-radius: 8px;
                padding: 8px 12px;
                display: inline-block;
            }

            .result-cell {
                max-width: 200px;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
                color: #555;
            }

            .action-buttons {
                display: flex;
                gap: 10px;
                flex-wrap: wrap;
            }

            .action-btn {
                border: none;
                padding: 10px 16px;
                border-radius: 10px;
                font-size: 0.85rem;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 6px;
                text-decoration: none;
                color: white;
            }

            .pay-btn {
                background: linear-gradient(135deg, #4caf50 0%, #45a049 100%);
                box-shadow: 0 4px 15px rgba(76, 175, 80, 0.3);
            }

            .pay-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(76, 175, 80, 0.4);
            }

            .update-btn {
                background: linear-gradient(135deg, #ff9800 0%, #f57c00 100%);
                box-shadow: 0 4px 15px rgba(255, 152, 0, 0.3);
            }

            .update-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(255, 152, 0, 0.4);
            }

            .pagination {
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 12px;
                margin: 35px 0;
            }

            .pagination a {
                display: flex;
                align-items: center;
                justify-content: center;
                width: 50px;
                height: 50px;
                border-radius: 12px;
                text-decoration: none;
                font-weight: 600;
                transition: all 0.3s ease;
                background: #f8faff;
                color: #667eea;
                border: 2px solid #e1e8ed;
            }

            .pagination a:hover {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                transform: translateY(-3px);
                box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
                border-color: transparent;
            }

            .pagination a.active {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border-color: transparent;
                box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
            }

            .no-data {
                text-align: center;
                padding: 80px 20px;
                color: #999;
            }

            .no-data-icon {
                font-size: 5rem;
                margin-bottom: 25px;
                color: #ddd;
            }

            .no-data h3 {
                font-size: 1.8rem;
                margin-bottom: 15px;
                color: #666;
                font-weight: 600;
            }

            .no-data p {
                font-size: 1.1rem;
                line-height: 1.6;
            }

            @media (max-width: 1024px) {
                .search-form {
                    grid-template-columns: 1fr;
                    gap: 20px;
                }
            }

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

                .search-section {
                    padding: 25px;
                }

                .table-section {
                    overflow-x: auto;
                }

                .table {
                    min-width: 900px;
                }

                .action-buttons {
                    flex-direction: column;
                }

                .pagination {
                    flex-wrap: wrap;
                    gap: 8px;
                }

                .pagination a {
                    width: 45px;
                    height: 45px;
                }
            }

            .stats-card {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 20px;
                margin-bottom: 35px;
            }

            .stat-item {
                background: linear-gradient(135deg, #f8faff 0%, #e8f4f8 100%);
                padding: 25px;
                border-radius: 16px;
                text-align: center;
                border: 1px solid rgba(102, 126, 234, 0.1);
                transition: all 0.3s ease;
            }

            .stat-item:hover {
                transform: translateY(-5px);
                box-shadow: 0 15px 35px rgba(102, 126, 234, 0.15);
            }

            .stat-item i {
                font-size: 2.5rem;
                color: #667eea;
                margin-bottom: 15px;
            }

            .stat-item h3 {
                font-size: 2rem;
                font-weight: 700;
                color: #333;
                margin-bottom: 5px;
            }

            .stat-item p {
                color: #666;
                font-weight: 500;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <div class="header-content">
                    <div class="header-icon">
                        <i class="fas fa-file-invoice-dollar"></i>
                    </div>
                    <h1>Danh Sách Hóa Đơn</h1>
                    <p class="subtitle">Quản lý và xử lý thanh toán hóa đơn khám bệnh</p>
                </div>
            </div>

            <div class="main-content">
                <!-- Thống kê nhanh -->
                <div class="stats-card">
                    <div class="stat-item">
                        <i class="fas fa-clipboard-check"></i>
                        <h3>${results.size()}</h3>
                        <p>Tổng kết quả khám</p>
                    </div>
                    <div class="stat-item">
                        <i class="fas fa-check-circle"></i>
                        <h3>
                            <c:set var="completedCount" value="0"/>
                            <c:forEach items="${results}" var="result">
                                <c:if test="${result.status == 'Completed'}">
                                    <c:set var="completedCount" value="${completedCount + 1}"/>
                                </c:if>
                            </c:forEach>
                            ${completedCount}
                        </h3>
                        <p>Đã hoàn thành</p>
                    </div>
                    <div class="stat-item">
                        <i class="fas fa-clock"></i>
                        <h3>
                            <c:set var="pendingCount" value="0"/>
                            <c:forEach items="${results}" var="result">
                                <c:if test="${result.status == 'Pending'}">
                                    <c:set var="pendingCount" value="${pendingCount + 1}"/>
                                </c:if>
                            </c:forEach>
                            ${pendingCount}
                        </h3>
                        <p>Đang xử lý</p>
                    </div>
                </div>

                <!-- Hiển thị thông báo -->
                <c:if test="${not empty message}">
                    <div class="message ${added == true ? 'success' : 'error'}">
                        <i class="fas ${added == true ? 'fa-check-circle' : 'fa-exclamation-circle'}"></i>
                        <span>${message}</span>
                    </div>
                </c:if>

                <!-- Form tìm kiếm -->
                <div class="search-section">
                    <div class="search-title">
                        <i class="fas fa-search"></i>
                        Tìm Kiếm Kết Quả Khám
                    </div>
                    <form method="get" action="${pageContext.request.contextPath}/ViewInvoiceServlet" class="search-form">
                        <div class="form-group">
                            <label for="patientNameKeyword">
                                <i class="fas fa-user"></i>
                                Tên Bệnh Nhân
                            </label>
                            <input type="text" id="patientNameKeyword" name="patientNameKeyword" 
                                   value="${patientNameKeyword}" placeholder="Nhập tên bệnh nhân...">
                        </div>
                        <div class="form-group">
                            <label for="serviceNameKeyword">
                                <i class="fas fa-stethoscope"></i>
                                Tên Dịch Vụ
                            </label>
                            <input type="text" id="serviceNameKeyword" name="serviceNameKeyword" 
                                   value="${serviceNameKeyword}" placeholder="Nhập tên dịch vụ...">
                        </div>
                        <div class="form-group">
                            <button type="submit" class="search-btn">
                                <i class="fas fa-search"></i>
                                Tìm Kiếm
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Bảng danh sách kết quả khám -->
                <c:choose>
                    <c:when test="${not empty results}">
                        <div class="table-section">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th><i class="fas fa-hashtag"></i>STT</th>
                                        <th><i class="fas fa-barcode"></i>Mã Kết Quả</th>
                                        <th><i class="fas fa-user"></i>Tên Bệnh Nhân</th>
                                        <th><i class="fas fa-user-md"></i>Tên Bác Sĩ</th>
                                        <th><i class="fas fa-stethoscope"></i>Dịch Vụ</th>
                                        <th><i class="fas fa-clipboard-check"></i>Chẩn Đoán</th>
                                        <th><i class="fas fa-info-circle"></i>Trạng Thái</th>
                                        <th><i class="fas fa-cogs"></i>Thao Tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${results}" var="result" varStatus="loop">
                                        <tr>
                                            <td class="stt-cell">${loop.index + 1}</td>
                                            <td class="id-cell">${result.resultId}</td>
                                            <td class="name-cell">${result.patientName}</td>
                                            <td class="doctor-cell">${result.doctorName}</td>
                                            <td><span class="service-cell">${result.serviceName}</span></td>
                                            <td class="result-cell" title="${result.diagnosis}">
                                                <c:choose>
                                                    <c:when test="${not empty result.diagnosis}">
                                                        ${result.diagnosis}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: #999;">Chưa có chẩn đoán</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${result.status == 'Completed'}">
                                                        <span style="color: #27ae60; font-weight: bold;">
                                                            <i class="fas fa-check-circle"></i> Hoàn thành
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${result.status == 'Pending'}">
                                                        <span style="color: #f39c12; font-weight: bold;">
                                                            <i class="fas fa-clock"></i> Đang xử lý
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: #e74c3c; font-weight: bold;">
                                                            <i class="fas fa-times-circle"></i> ${result.status}
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="action-buttons">
                                                    <!-- ✅ SỬA: Chỉ hiển thị nút "Thêm hóa đơn" khi status = 'Completed' VÀ chưa có hóa đơn -->
                                                    <c:if test="${result.status == 'Completed' && result.invoiceId == null}">
                                                        <form method="get" action="${pageContext.request.contextPath}/AddInvoiceServlet" style="display:inline;">
                                                            <input type="hidden" name="resultId" value="${result.resultId}" />
                                                            <input type="hidden" name="patientId" value="${result.patientId}" />
                                                            <input type="hidden" name="doctorId" value="${result.doctorId}" />
                                                            <input type="hidden" name="serviceId" value="${result.serviceId}" />
                                                            <!-- ✅ THÊM: Truyền servicePrice từ database để hiển thị phí dịch vụ thực tế -->
                                                            <input type="hidden" name="servicePrice" value="${result.servicePrice}" />
                                                            <input type="hidden" name="patientName" value="${result.patientName}" />
                                                            <input type="hidden" name="doctorName" value="${result.doctorName}" />
                                                            <input type="hidden" name="serviceName" value="${result.serviceName}" />
                                                            <input type="hidden" name="diagnosis" value="${result.diagnosis}" />
                                                            <button type="submit" class="action-btn pay-btn">
                                                                <i class="fas fa-plus-circle"></i>
                                                                Thêm hóa đơn
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                    
                                                    <!-- ✅ THÊM: Hiển thị thông báo "Đã có hóa đơn" khi đã có hóa đơn -->
                                                    <c:if test="${result.status == 'Completed' && result.invoiceId != null}">
                                                        <span style="color: #27ae60; font-weight: bold; padding: 8px 12px; background: #e8f5e8; border-radius: 8px; display: inline-flex; align-items: center; gap: 6px;">
                                                            <i class="fas fa-check-circle"></i>
                                                            Đã có hóa đơn
                                                        </span>
                                                    </c:if>
                                                    
                                                    <!-- ✅ THÊM: Nút xem chi tiết kết quả khám -->
                                                    <a href="${pageContext.request.contextPath}/ViewExaminationResultDetailServlet?resultId=${result.resultId}" 
                                                       class="action-btn update-btn">
                                                        <i class="fas fa-eye"></i>
                                                        Xem chi tiết
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="no-data">
                            <div class="no-data-icon">
                                <i class="fas fa-clipboard-list"></i>
                            </div>
                            <h3>Không tìm thấy kết quả khám</h3>
                            <p>Không có kết quả khám nào phù hợp với tiêu chí tìm kiếm của bạn.<br>
                                Vui lòng thử lại với từ khóa khác.</p>
                        </div>
                    </c:otherwise>
                </c:choose>

                <!-- Phân trang -->
                <c:if test="${totalPages > 1}">
                    <div class="pagination">
                        <c:if test="${currentPage > 1}">
                            <a href="${pageContext.request.contextPath}/ViewInvoiceServlet?page=${currentPage - 1}&patientNameKeyword=${patientNameKeyword}&serviceNameKeyword=${serviceNameKeyword}">
                                <i class="fas fa-chevron-left"></i>
                            </a>
                        </c:if>

                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="${pageContext.request.contextPath}/ViewInvoiceServlet?page=${i}&patientNameKeyword=${patientNameKeyword}&serviceNameKeyword=${serviceNameKeyword}"
                               class="${i == currentPage ? 'active' : ''}">
                                ${i}
                            </a>
                        </c:forEach>

                        <c:if test="${currentPage < totalPages}">
                            <a href="${pageContext.request.contextPath}/ViewInvoiceServlet?page=${currentPage + 1}&patientNameKeyword=${patientNameKeyword}&serviceNameKeyword=${serviceNameKeyword}">
                                <i class="fas fa-chevron-right"></i>
                            </a>
                        </c:if>
                    </div>
                </c:if>
            </div>
        </div>


    </body>
</html>
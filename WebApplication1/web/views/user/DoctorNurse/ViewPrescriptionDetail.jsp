<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.entity.Prescriptions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chi tiết đơn thuốc</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                padding: 20px;
                color: #333;
            }

            .container {
                max-width: 900px;
                margin: 0 auto;
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                border-radius: 20px;
                padding: 40px;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
                border: 1px solid rgba(255, 255, 255, 0.2);
                animation: slideUp 0.6s ease;
            }

            @keyframes slideUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .header {
                text-align: center;
                margin-bottom: 40px;
                position: relative;
            }

            .header::before {
                content: '';
                position: absolute;
                top: -10px;
                left: 50%;
                transform: translateX(-50%);
                width: 80px;
                height: 4px;
                background: linear-gradient(90deg, #667eea, #764ba2);
                border-radius: 2px;
            }

            .header h1 {
                color: #2c3e50;
                font-size: 32px;
                font-weight: 700;
                margin: 20px 0 10px;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 15px;
            }

            .header .subtitle {
                color: #7f8c8d;
                font-size: 16px;
                font-weight: 400;
            }

            .success-message {
                background: linear-gradient(45deg, #51cf66, #40c057);
                color: white;
                padding: 15px 20px;
                border-radius: 12px;
                margin-bottom: 30px;
                font-size: 16px;
                display: flex;
                align-items: center;
                gap: 12px;
                animation: slideIn 0.5s ease;
                box-shadow: 0 4px 15px rgba(81, 207, 102, 0.3);
            }

            @keyframes slideIn {
                from {
                    opacity: 0;
                    transform: translateX(-20px);
                }
                to {
                    opacity: 1;
                    transform: translateX(0);
                }
            }

            .prescription-card {
                background: #fff;
                border-radius: 16px;
                padding: 30px;
                margin-bottom: 30px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
                border: 1px solid #f1f3f4;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .prescription-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 15px 35px rgba(0, 0, 0, 0.12);
            }

            .card-header {
                display: flex;
                align-items: center;
                gap: 15px;
                margin-bottom: 25px;
                padding-bottom: 15px;
                border-bottom: 2px solid #f8f9fa;
            }

            .prescription-id {
                background: linear-gradient(45deg, #667eea, #764ba2);
                color: white;
                padding: 8px 16px;
                border-radius: 25px;
                font-weight: 600;
                font-size: 18px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .status-badge {
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .status-pending {
                background: #fff3cd;
                color: #856404;
            }
            .status-in-progress {
                background: #d1ecf1;
                color: #0c5460;
            }
            .status-completed {
                background: #d4edda;
                color: #155724;
            }
            .status-dispensed {
                background: #e2e3e5;
                color: #383d41;
            }
            .status-cancelled {
                background: #f8d7da;
                color: #721c24;
            }

            .info-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 20px;
                margin-bottom: 25px;
            }

            .info-item {
                background: #f8f9fa;
                padding: 20px;
                border-radius: 12px;
                border-left: 4px solid #667eea;
                transition: all 0.3s ease;
            }

            .info-item:hover {
                background: #e9ecef;
                transform: translateX(5px);
            }

            .info-label {
                display: flex;
                align-items: center;
                gap: 8px;
                font-weight: 600;
                color: #495057;
                margin-bottom: 8px;
                font-size: 14px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .info-value {
                color: #2c3e50;
                font-size: 16px;
                line-height: 1.5;
                font-weight: 500;
            }

            .prescription-details {
                background: linear-gradient(135deg, #f8f9fa, #e9ecef);
                padding: 25px;
                border-radius: 12px;
                margin: 25px 0;
                border: 1px solid #dee2e6;
            }

            .prescription-details .info-label {
                color: #667eea;
                font-size: 16px;
                margin-bottom: 12px;
            }

            .prescription-details .info-value {
                background: white;
                padding: 15px;
                border-radius: 8px;
                border: 1px solid #e9ecef;
                white-space: pre-wrap;
                font-family: 'Courier New', monospace;
                font-size: 14px;
                line-height: 1.6;
                color: #2c3e50;
            }

            .note-section {
                background: linear-gradient(135deg, #fff7ed, #fef3e2);
                padding: 25px;
                border-radius: 12px;
                margin: 25px 0;
                border-left: 4px solid #f59e0b;
            }

            .note-section .info-label {
                color: #d97706;
                font-size: 16px;
                margin-bottom: 12px;
            }

            .note-section .info-value {
                color: #92400e;
                font-style: italic;
                background: rgba(255, 255, 255, 0.7);
                padding: 15px;
                border-radius: 8px;
                line-height: 1.6;
            }

            .date-info {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
                margin: 25px 0;
            }

            .date-item {
                background: linear-gradient(135deg, #e0f2fe, #b3e5fc);
                padding: 20px;
                border-radius: 12px;
                text-align: center;
                border: 1px solid #81d4fa;
            }

            .date-item .info-label {
                color: #0277bd;
                justify-content: center;
            }

            .date-item .info-value {
                color: #01579b;
                font-size: 18px;
                font-weight: 600;
            }

            .action-buttons {
                display: flex;
                gap: 15px;
                justify-content: center;
                margin-top: 40px;
                flex-wrap: wrap;
            }

            .btn {
                padding: 14px 28px;
                border: none;
                border-radius: 50px;
                font-size: 16px;
                font-weight: 500;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 10px;
                cursor: pointer;
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
                min-width: 160px;
                justify-content: center;
            }

            .btn::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
                transition: left 0.5s;
            }

            .btn:hover::before {
                left: 100%;
            }

            .btn-primary {
                background: linear-gradient(45deg, #667eea, #764ba2);
                color: white;
                box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
            }

            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
            }

            .btn-secondary {
                background: #f8f9fa;
                color: #6c757d;
                border: 2px solid #e9ecef;
            }

            .btn-secondary:hover {
                background: #e9ecef;
                color: #495057;
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            }

            .btn-success {
                background: linear-gradient(45deg, #51cf66, #40c057);
                color: white;
                box-shadow: 0 4px 15px rgba(81, 207, 102, 0.3);
            }

            .btn-success:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(81, 207, 102, 0.4);
            }

            .back-link {
                background: linear-gradient(45deg, #6c757d, #495057);
                color: white;
                box-shadow: 0 4px 15px rgba(108, 117, 125, 0.3);
            }

            .back-link:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(108, 117, 125, 0.4);
            }

            @media (max-width: 768px) {
                .container {
                    padding: 25px;
                    margin: 10px;
                }

                .header h1 {
                    font-size: 26px;
                }

                .info-grid {
                    grid-template-columns: 1fr;
                }

                .date-info {
                    grid-template-columns: 1fr;
                }

                .action-buttons {
                    flex-direction: column;
                    align-items: center;
                }

                .btn {
                    width: 100%;
                    max-width: 300px;
                }

                .card-header {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 10px;
                }
            }

            .empty-note {
                color: #adb5bd;
                font-style: italic;
                text-align: center;
                padding: 20px;
                background: #f8f9fa;
                border-radius: 8px;
                border: 2px dashed #dee2e6;
            }

            .icon-bg {
                width: 50px;
                height: 50px;
                border-radius: 50%;
                background: linear-gradient(45deg, #667eea, #764ba2);
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 24px;
                margin-right: 15px;
                flex-shrink: 0;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>
                    <i class="fas fa-prescription-bottle-alt"></i>
                    Chi tiết đơn thuốc
                </h1>
                <p class="subtitle">Thông tin chi tiết về đơn thuốc và tình trạng xử lý</p>
            </div>

            <c:if test="${not empty message}">
                <div class="success-message">
                    <i class="fas fa-check-circle"></i>
                    ${message}
                </div>
            </c:if>

            <div class="prescription-card">
                <div class="card-header">
                    <div class="icon-bg">
                        <i class="fas fa-file-prescription"></i>
                    </div>
                    <div style="flex: 1;">
                        <div class="prescription-id">
                            <i class="fas fa-hashtag"></i>
                            <c:choose>
                                <c:when test="${not empty prescription}">
                                    ${prescription.prescriptionId}
                                </c:when>
                                <c:otherwise>
                                    Không có đơn thuốc
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="status-badge ">
                        <c:choose>
                            <c:when test="${not empty prescription && prescription.status == 'Pending'}">Đang chờ</c:when>
                            <c:when test="${not empty prescription && prescription.status == 'In Progress'}">Đang xử lý</c:when>
                            <c:when test="${not empty prescription && prescription.status == 'Completed'}">Hoàn thành</c:when>
                            <c:when test="${not empty prescription && prescription.status == 'Dispensed'}">Đã cấp phát</c:when>
                            <c:when test="${not empty prescription && prescription.status == 'Cancelled'}">Đã hủy</c:when>
                            <c:otherwise>
                                <c:out value="${prescription.status}" default="Chưa có trạng thái"/>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-label">
                            <i class="fas fa-user-md"></i>
                            Mã Bác Sĩ
                        </div>
                        <div class="info-value">
                            <c:choose>
                                <c:when test="${not empty prescription}">
                                    ${prescription.doctorId}
                                </c:when>
                                <c:otherwise>
                                    ${doctorId}
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">
                            <i class="fas fa-user-injured"></i>
                            Mã Bệnh Nhân
                        </div>
                        <div class="info-value">
                            <c:choose>
                                <c:when test="${not empty prescription}">
                                    ${prescription.patientId}
                                </c:when>
                                <c:otherwise>
                                    ${patientId}
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">
                            <i class="fas fa-calendar-check"></i>
                            Mã Lịch Hẹn
                        </div>
                        <div class="info-value">
                            <c:out value="${appointmentId}" default="N/A"/>
                        </div>
                    </div>
                </div>

                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-label">
                            <i class="fas fa-user"></i>
                            Tên Bệnh Nhân
                        </div>
                        <div class="info-value">
                            <c:out value="${patientName}" default="N/A"/>
                        </div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">
                            <i class="fas fa-user-md"></i>
                            Tên Bác Sĩ
                        </div>
                        <div class="info-value">
                            <c:out value="${doctorName}" default="N/A"/>
                        </div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">
                            <i class="fas fa-notes-medical"></i>
                            Kết Quả Khám
                        </div>
                        <div class="info-value">
                            <c:out value="${resultName}" default="N/A"/>
                        </div>
                    </div>
                </div>

                <div class="prescription-details">
                    <div class="info-label">
                        <i class="fas fa-pills"></i>
                        Nội Dung Kê Đơn
                    </div>
                    <div class="info-value">
                        <c:choose>
                            <c:when test="${not empty prescription && not empty prescription.prescriptionDetails}">
                                <c:out value="${prescription.prescriptionDetails}"/>
                            </c:when>
                            <c:otherwise>
                                <span style="color:#aaa;">Chưa có nội dung kê đơn</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="note-section">
                    <div class="info-label">
                        <i class="fas fa-sticky-note"></i>
                        Ghi Chú
                    </div>
                    <div class="info-value">
                        <c:choose>
                            <c:when test="${not empty prescription && not empty prescription.note}">
                                <c:out value="${prescription.note}"/>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-note">
                                    <i class="fas fa-info-circle"></i>
                                    Chưa có ghi chú nào cho đơn thuốc này
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="date-info">
                    <div class="date-item">
                        <div class="info-label">
                            <i class="fas fa-calendar-plus"></i>
                            Ngày Tạo
                        </div>
                        <div class="info-value">
                            <c:out value="${createdAtFormatted}" default="N/A"/>
                        </div>
                    </div>
                    <div class="date-item">
                        <div class="info-label">
                            <i class="fas fa-calendar-check"></i>
                            Ngày Cập Nhật
                        </div>
                        <div class="info-value">
                            <c:out value="${updatedAtFormatted}" default="N/A"/>
                        </div>
                    </div>
                </div>
            </div>


        </div>
        <div class="action-buttons">
            <a href="${pageContext.request.contextPath}/EditPrescriptionNoteServlet?id=${prescription != null ? prescription.prescriptionId : ''}" class="btn btn-primary">
                <i class="fas fa-edit"></i>
                Chỉnh sửa ghi chú
            </a>



            <a href="${pageContext.request.contextPath}/views/user/DoctorNurse/ViewPatientResult.jsp" class="btn back-link">
                <i class="fas fa-arrow-left"></i>
                Quay lại danh sách
            </a>
        </div>


    </body>
</html>
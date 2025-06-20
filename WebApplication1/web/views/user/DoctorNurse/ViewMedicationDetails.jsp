<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>Chi Tiết Thuốc</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-purple: #6b48ff;
            --secondary-purple: #a856ff;
            --light-purple: #f0eaff;
            --dark-text: #1a1a1a;
            --light-text: #666;
            --border-color: #e0e0e0;
            --error-red: #ff4444;
            --white: #ffffff;
            --shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        body {
            background: linear-gradient(to right, var(--primary-purple), var(--secondary-purple));
            font-family: 'Roboto', sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            color: var(--dark-text);
        }

        .container {
            width: 90%;
            max-width: 800px;
            background-color: var(--white);
            padding: 40px;
            border-radius: 20px;
            box-shadow: var(--shadow);
            animation: fadeIn 0.6s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .header {
            margin-bottom: 30px;
            border-bottom: 2px solid var(--light-purple);
            padding-bottom: 20px;
            text-align: center;
        }

        h2 {
            color: var(--primary-purple);
            margin: 0;
            font-size: 32px;
            font-weight: 700;
        }

        .error {
            color: var(--error-red);
            font-weight: 500;
            margin-bottom: 20px;
            padding: 12px 15px;
            background-color: rgba(255, 68, 68, 0.1);
            border-left: 5px solid var(--error-red);
            border-radius: 5px;
            text-align: center;
        }

        .medication-details {
            margin-top: 20px;
        }

        .medication-details div {
            margin-bottom: 15px;
            display: flex;
            align-items: flex-start;
        }

        .label {
            font-weight: 600;
            color: var(--primary-purple);
            width: 200px;
            text-align: left;
        }

        .value {
            color: var(--light-text);
            flex: 1;
            word-break: break-word;
        }

        .back-link {
            display: block;
            margin-top: 30px;
            text-align: center;
        }

        .back-link a {
            background-color: var(--primary-purple);
            color: var(--white);
            padding: 12px 25px;
            border-radius: 10px;
            text-decoration: none;
            font-size: 16px;
            font-weight: 500;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        .back-link a:hover {
            background-color: #5a3de6;
            transform: translateY(-2px);
        }

        @media (max-width: 768px) {
            .container {
                width: 95%;
                padding: 20px;
            }

            h2 {
                font-size: 24px;
            }

            .medication-details div {
                flex-direction: column;
            }

            .label {
                width: 100%;
                margin-bottom: 5px;
            }

            .value {
                text-align: left;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>Chi Tiết Thuốc</h2>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="error">${errorMessage}</div>
        </c:if>

        <c:if test="${empty errorMessage and not empty medication}">
            <div class="medication-details">
                <div>
                    <span class="label">Mã Thuốc:</span>
                    <span class="value">${medication.medicationID}</span>
                </div>
                <div>
                    <span class="label">Tên Thuốc:</span>
                    <span class="value">${medication.name}</span>
                </div>
                <div>
                    <span class="label">Hàm Lượng:</span>
                    <span class="value">${medication.dosage}</span>
                </div>
                <div>
                    <span class="label">Nhà Sản Xuất:</span>
                    <span class="value">${medication.manufacturer}</span>
                </div>
                <div>
                   <span class="label">Mô Tả:</span>
                    <span class="value">
                        ${medication.description != null ? medication.description : 'Không có'}
                        <%-- Fallback if encoding is still broken --%>
                        <c:if test="${medication.description != null and medication.description.contains('?') or medication.description.contains('�')}">
                            <c:set var="rawDescription" value="${medication.description}" />
                            <span style="color: red;">(Dữ liệu bị lỗi, vui lòng cập nhật: ${rawDescription})</span>
                        </c:if>
                    </span>
                </div>
                <div>
                    <span class="label">Ngày Sản Xuất:</span>
                    <span class="value">${medication.productionDate != null ? medication.productionDate : 'Không có'}</span>
                </div>
                <div>
                    <span class="label">Ngày Hết Hạn:</span>
                    <span class="value">${medication.expirationDate != null ? medication.expirationDate : 'Không có'}</span>
                </div>
                <div>
                    <span class="label">Giá:</span>
                    <span class="value">
                        <c:choose>
                            <c:when test="${medication.price != null and medication.price >= 0}">
                                <fmt:setLocale value="vi_VN"/>
                                <fmt:formatNumber value="${medication.price}" type="currency" currencySymbol="₫"/>
                            </c:when>
                            <c:otherwise>Không có</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div>
                    <span class="label">Số Lượng:</span>
                    <span class="value">${medication.quantity >= 0 ? medication.quantity : 'Không có'}</span>
                </div>
                <div>
                    <span class="label">Trạng Thái:</span>
                    <span class="value">${medication.status != null ? medication.status : 'Không có'}</span>
                </div>
                <div>
                    <span class="label">Dạng Bào Chế:</span>
                    <span class="value">${medication.dosageForm != null ? medication.dosageForm : 'Không có'}</span>
                </div>
            </div>
        </c:if>

        <div class="back-link">
            <a href="${pageContext.request.contextPath}/ViewMedicationsServlet">Quay lại Danh Sách Thuốc</a>
        </div>
    </div>
</body>
</html>
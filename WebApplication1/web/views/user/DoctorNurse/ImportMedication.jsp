<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Nhập Thuốc</title>
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
            --success-green: #28a745;
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
            max-width: 600px;
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
        }

        h2 {
            color: var(--primary-purple);
            margin: 0;
            font-size: 32px;
            font-weight: 700;
            text-align: center;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-weight: 500;
            color: var(--dark-text);
            margin-bottom: 8px;
        }

        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            font-size: 14px;
            color: var(--dark-text);
            background-color: #fafafa;
            transition: border-color 0.3s ease;
        }

        .form-group input:focus {
            border-color: var(--primary-purple);
            outline: none;
        }

        .submit-button {
            background-color: var(--primary-purple);
            color: var(--white);
            padding: 12px 25px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 500;
            width: 100%;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        .submit-button:hover {
            background-color: #5a3de6;
            transform: translateY(-2px);
        }

        .back-button {
            display: inline-block;
            margin-top: 20px;
            color: var(--primary-purple);
            text-decoration: none;
            font-weight: 500;
            text-align: center;
            width: 100%;
        }

        .back-button:hover {
            text-decoration: underline;
        }

        .error {
            color: var(--error-red);
            font-weight: 500;
            margin-bottom: 20px;
            padding: 12px 15px;
            background-color: rgba(255, 68, 68, 0.1);
            border-left: 5px solid var(--error-red);
            border-radius: 5px;
        }

        .success {
            color: var(--success-green);
            font-weight: 500;
            margin-bottom: 20px;
            padding: 12px 15px;
            background-color: rgba(40, 167, 69, 0.1);
            border-left: 5px solid var(--success-green);
            border-radius: 5px;
        }

        .info {
            background-color: var(--light-purple);
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .info p {
            margin: 5px 0;
            color: var(--dark-text);
        }

        .info p strong {
            color: var(--primary-purple);
        }

        @media (max-width: 768px) {
            .container {
                width: 95%;
                padding: 20px;
            }
            h2 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h2>Nhập Thuốc</h2>
    </div>

    <!-- Hiển thị thông báo thành công hoặc lỗi -->
    <c:if test="${not empty sessionScope.statusMessage}">
        <c:choose>
            <c:when test="${sessionScope.statusMessage == 'Nhập thuốc thành công!'}">
                <div class="success">${sessionScope.statusMessage}</div>
            </c:when>
            <c:otherwise>
                <div class="error">${sessionScope.statusMessage}</div>
            </c:otherwise>
        </c:choose>
        <%-- Xóa thông báo sau khi hiển thị để tránh hiển thị lại khi reload --%>
        <c:remove var="statusMessage" scope="session"/>
    </c:if>

    <c:if test="${not empty medication}">
        <div class="info">
            <p><strong>Tên Thuốc:</strong> ${medication.name}</p>
            <p><strong>Hàm Lượng:</strong> ${not empty medication.dosage ? medication.dosage : 'Chưa cập nhật'}</p>
            <p><strong>Dạng Bào Chế:</strong> ${not empty medication.dosageForm ? medication.dosageForm : 'Chưa cập nhật'}</p>
            <p><strong>Nhà Sản Xuất:</strong> ${not empty medication.manufacturer ? medication.manufacturer : 'Chưa cập nhật'}</p>
        </div>

        <form action="${pageContext.request.contextPath}/MedicationImportServlet" method="post">
            <input type="hidden" name="id" value="${medication.medicationID}"/>
            <div class="form-group">
                <label for="productionDate">Ngày Sản Xuất</label>
                <input type="date" id="productionDate" name="productionDate" value="${not empty medication.productionDate ? medication.productionDate : ''}" required/>
            </div>
            <div class="form-group">
                <label for="expirationDate">Hạn Sử Dụng</label>
                <input type="date" id="expirationDate" name="expirationDate" value="${not empty medication.expirationDate ? medication.expirationDate : ''}" required/>
            </div>
            <div class="form-group">
                <label for="price">Giá Bán (Sửa nếu cần)</label>
                <input type="number" id="price" name="price" step="0.01" min="0" value="${not empty medication.price ? medication.price : ''}" required/>
            </div>
            <div class="form-group">
                <label for="quantity">Số Lượng</label>
                <input type="number" id="quantity" name="quantity" min="0" value="${not empty medication.quantity ? medication.quantity : ''}" required/>
            </div>
            <button type="submit" class="submit-button">Nhập Thuốc</button>
        </form>
        <a href="${pageContext.request.contextPath}/ViewMedicationsServlet" class="back-button">Quay lại danh sách thuốc</a>
    </c:if>
    <c:if test="${empty medication}">
        <div class="error">Vui lòng chọn một loại thuốc để nhập.</div>
        <a href="${pageContext.request.contextPath}/ViewMedicationsServlet" class="back-button">Quay lại danh sách thuốc</a>
    </c:if>
</div>
</body>
</html>
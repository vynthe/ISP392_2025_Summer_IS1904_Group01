
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Danh Sách Thuốc</title>
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
            max-width: 1200px;
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
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            border-bottom: 2px solid var(--light-purple);
            padding-bottom: 20px;
        }

        h2 {
            color: var(--primary-purple);
            margin: 0;
            font-size: 32px;
            font-weight: 700;
        }

        .add-button {
            background-color: var(--primary-purple);
            color: var(--white);
            padding: 12px 25px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 500;
            text-decoration: none;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        .add-button:hover {
            background-color: #5a3de6;
            transform: translateY(-2px);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background-color: var(--white);
            border-radius: 12px;
            overflow: hidden;
        }

        th {
            background-color: var(--light-purple);
            color: var(--primary-purple);
            font-weight: 600;
            text-transform: uppercase;
            padding: 15px;
            text-align: left;
        }

        td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid var(--border-color);
            color: var(--light-text);
            font-size: 14px;
        }

        tr:nth-child(even) {
            background-color: #fafafa;
        }

        tr:hover {
            background-color: #f5f7ff;
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

        .no-data {
            text-align: center;
            color: var(--light-text);
            padding: 20px;
            font-style: italic;
            font-size: 16px;
        }

        .action-button {
            color: var(--primary-purple);
            cursor: pointer;
            text-decoration: none;
        }

        .action-button:hover {
            text-decoration: underline;
        }

        .pagination-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid var(--border-color);
        }

        .pagination-info {
            color: var(--light-text);
            font-size: 14px;
        }

        .pagination {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .pagination a, .pagination span {
            padding: 8px 12px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            border: 1px solid var(--border-color);
            min-width: 35px;
            text-align: center;
            display: inline-block;
        }

        .pagination a {
            color: var(--primary-purple);
            background-color: var(--white);
        }

        .pagination a:hover {
            background-color: var(--light-purple);
            border-color: var(--primary-purple);
            transform: translateY(-1px);
        }

        .pagination .current {
            background-color: var(--primary-purple);
            color: var(--white);
            border-color: var(--primary-purple);
        }

        .pagination .disabled {
            color: #ccc;
            background-color: #f8f8f8;
            border-color: #e8e8e8;
            cursor: not-allowed;
        }

        .pagination .dots {
            border: none;
            background: none;
            color: var(--light-text);
        }

        @media (max-width: 768px) {
            .container {
                width: 95%;
                padding: 20px;
            }
            .header {
                flex-direction: column;
                gap: 15px;
            }
            h2 {
                font-size: 24px;
            }
            .add-button {
                width: 100%;
                text-align: center;
            }
            
            .pagination-container {
                flex-direction: column;
                gap: 15px;
            }
            
            .pagination {
                flex-wrap: wrap;
                justify-content: center;
            }
            
            table, thead, tbody, th, td, tr {
                display: block;
            }
            thead tr {
                position: absolute;
                top: -9999px;
                left: -9999px;
            }
            tr {
                margin-bottom: 15px;
                border: 1px solid var(--border-color);
                border-radius: 8px;
            }
            td {
                border: none;
                position: relative;
                padding-left: 50%;
                text-align: right;
            }
            td:before {
                content: attr(data-label);
                position: absolute;
                left: 15px;
                width: 45%;
                padding-right: 10px;
                font-weight: 600;
                color: var(--dark-text);
                text-align: left;
            }
        }

        .success {
            color: #28a745;
            font-weight: 500;
            margin-bottom: 20px;
            padding: 12px 15px;
            background-color: rgba(40, 167, 69, 0.1);
            border-left: 5px solid #28a745;
            border-radius: 5px;
        }

        .failure {
            color: #dc3545;
            font-weight: 500;
            margin-bottom: 20px;
            padding: 12px 15px;
            background-color: rgba(220, 53, 69, 0.1);
            border-left: 5px solid #dc3545;
            border-radius: 5px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h2>Danh Sách Thuốc</h2>
        <a href="${pageContext.request.contextPath}/AddMedicationsServlet" class="add-button">Thêm Thuốc</a>
    </div>

    <c:if test="${not empty sessionScope.statusMessage}">
        <c:choose>
            <c:when test="${sessionScope.statusMessage == 'Tạo thành công'}">
                <div class="success">${sessionScope.statusMessage}</div>
            </c:when>
            <c:otherwise>
                <div class="failure">${sessionScope.statusMessage}</div>
            </c:otherwise>
        </c:choose>
        <c:remove var="statusMessage" scope="session"/>
    </c:if>

    <c:if test="${not empty errorMessage}">
        <div class="error">${errorMessage}</div>
    </c:if>

    <table>
        <thead>
            <tr>
                <th>STT</th>
                <th>Tên Thuốc</th>
                <th>Hàm Lượng</th>
                <th>Dạng Bào Chế</th>
                <th>Nhà Sản Xuất</th>
                <th>Hành Động</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${empty medications}">
                    <tr>
                        <td colspan="6" class="no-data">Không có dữ liệu thuốc.</td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="medication" items="${medications}" varStatus="status">
                        <tr>
                            <td data-label="STT">${(currentPage - 1) * 10 + status.count}</td>
                            <td data-label="Tên Thuốc">${medication.name}</td>
                            <td data-label="Hàm Lượng">
                                <c:choose>
                                    <c:when test="${not empty medication.dosage and medication.dosage.length() > 50}">
                                        <span title="${medication.dosage}">${medication.dosage.substring(0, 50)}...</span>
                                    </c:when>
                                    <c:otherwise>${medication.dosage}</c:otherwise>
                                </c:choose>
                            </td>
                            <td data-label="Dạng Bào Chế">${medication.dosageForm}</td>
                            <td data-label="Nhà Sản Xuất">${medication.manufacturer}</td>
                            <td data-label="Hành Động">
                                <a href="${pageContext.request.contextPath}/ViewMedicationDetailsServlet?id=${medication.medicationID}" class="action-button">🔍 Xem chi tiết</a>
                            </td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>

    <c:if test="${not empty medications and totalPages > 1}">
        <div class="pagination-container">
            <div class="pagination-info">
                Hiển thị ${(currentPage - 1) * 10 + 1} - ${currentPage * 10 > totalRecords ? totalRecords : currentPage * 10} 
                trong tổng số ${totalRecords} thuốc
            </div>
            
            <div class="pagination">
                <c:choose>
                    <c:when test="${currentPage > 1}">
                        <a href="${pageContext.request.contextPath}/ViewMedicationsServlet?page=1">❮❮</a>
                        <a href="${pageContext.request.contextPath}/ViewMedicationsServlet?page=${currentPage - 1}">❮</a>
                    </c:when>
                    <c:otherwise>
                        <span class="disabled">❮❮</span>
                        <span class="disabled">❮</span>
                    </c:otherwise>
                </c:choose>

                <c:set var="startPage" value="${currentPage - 2 > 0 ? currentPage - 2 : 1}"/>
                <c:set var="endPage" value="${currentPage + 2 < totalPages ? currentPage + 2 : totalPages}"/>

                <c:if test="${startPage > 1}">
                    <a href="${pageContext.request.contextPath}/ViewMedicationsServlet?page=1">1</a>
                    <c:if test="${startPage > 2}">
                        <span class="dots">...</span>
                    </c:if>
                </c:if>

                <c:forEach var="i" begin="${startPage}" end="${endPage}">
                    <c:choose>
                        <c:when test="${i == currentPage}">
                            <span class="current">${i}</span>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/ViewMedicationsServlet?page=${i}">${i}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>

                <c:if test="${endPage < totalPages}">
                    <c:if test="${endPage < totalPages - 1}">
                        <span class="dots">...</span>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/ViewMedicationsServlet?page=${totalPages}">${totalPages}</a>
                </c:if>

                <c:choose>
                    <c:when test="${currentPage < totalPages}">
                        <a href="${pageContext.request.contextPath}/ViewMedicationsServlet?page=${currentPage + 1}">❯</a>
                        <a href="${pageContext.request.contextPath}/ViewMedicationsServlet?page=${totalPages}">❯❯</a>
                    </c:when>
                    <c:otherwise>
                        <span class="disabled">❯</span>
                        <span class="disabled">❯❯</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </c:if>
</div>
</body>
</html>
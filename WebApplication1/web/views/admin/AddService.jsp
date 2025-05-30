<%-- 
    Document   : AddService
    Created on : May 23, 2025
    Author     : Grok
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Thêm Dịch Vụ</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <style>
            /* Reset default styles */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', Arial, sans-serif;
            }

            body {
                background: linear-gradient(135deg, #ede7f6, #d1c4e9);
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                padding: 20px;
            }

            .container {
                background: #ffffff;
                padding: 40px;
                border-radius: 15px;
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
                width: 100%;
                max-width: 550px;
                position: relative;
                overflow: hidden;
            }

            .container::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 5px;
                background: linear-gradient(to right, #7B1FA2, #AB47BC);
            }

            h2 {
                text-align: center;
                color: #2c3e50;
                margin-bottom: 30px;
                font-size: 28px;
                font-weight: 600;
                letter-spacing: 1px;
            }

            .form-group, .mb-3, .input-box {
                margin-bottom: 20px;
                position: relative;
            }

            .form-group label, .mb-3 label {
                display: block;
                font-weight: 500;
                margin-bottom: 8px;
                color: #34495e;
                font-size: 15px;
            }

            .form-group input[type="text"],
            .form-group input[type="number"],
            .form-group textarea,
            .form-group select,
            .input-box input,
            .input-box select,
            .input-box textarea {
                width: 100%;
                padding: 12px 40px 12px 15px;
                border: 1px solid #dfe6e9;
                border-radius: 8px;
                font-size: 14px;
                background: #f9fafb;
                transition: all 0.3s ease;
            }

            .form-group textarea {
                resize: vertical;
                min-height: 100px;
            }

            .form-group input:focus,
            .form-group textarea:focus,
            .form-group select:focus,
            .input-box input:focus,
            .input-box select:focus,
            .input-box textarea:focus {
                border-color: #7B1FA2;
                background: #ffffff;
                box-shadow: 0 0 5px rgba(123, 31, 162, 0.2);
                outline: none;
            }

            .input-box i {
                position: absolute;
                right: 15px;
                top: 50%;
                transform: translateY(-50%);
                color: #7f8c8d;
                font-size: 16px;
            }

            .form-group input[type="submit"],
            .form-group input[type="button"] {
                width: 100%;
                padding: 14px;
                background: linear-gradient(to right, #7B1FA2, #AB47BC);
                color: white;
                border: none;
                border-radius: 8px;
                font-size: 16px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s ease;
                text-transform: uppercase;
                letter-spacing: 1px;
                margin-bottom: 10px;
            }

            .form-group input[type="submit"]:hover,
            .form-group input[type="button"]:hover {
                background: linear-gradient(to right, #6A1B9A, #9C27B0);
                box-shadow: 0 5px 15px rgba(123, 31, 162, 0.3);
            }

            .error {
                background-color: #ffebee;
                color: #c62828;
                padding: 12px;
                border-radius: 8px;
                margin-bottom: 20px;
                text-align: center;
                font-size: 14px;
                border-left: 4px solid #c62828;
            }

            select option[disabled] {
                color: #b0bec5;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Thêm Dịch Vụ</h2>
            <c:if test="${not empty requestScope.error}">
                <div class="error">${requestScope.error}</div>
            </c:if>
            <form action="${pageContext.request.contextPath}/AddServiceServlet" method="post" id="serviceForm">
                <div class="form-group">
                    <label for="serviceName">Tên Dịch Vụ:</label>
                    <div class="input-box">
                        <input type="text" id="serviceName" name="serviceName" value="${sessionScope.formData.serviceName}" placeholder="Nhập tên dịch vụ" required>
                        <i class="fas fa-briefcase-medical"></i>
                    </div>
                </div>
                <div class="form-group">
                    <label for="description">Mô Tả:</label>
                    <div class="input-box">
                        <textarea id="description" name="description" placeholder="Nhập mô tả dịch vụ">${sessionScope.formData.description}</textarea>
                        <i class="fas fa-align-left"></i>
                    </div>
                </div>
                <div class="form-group">
                    <label for="price">Giá (VNĐ):</label>
                    <div class="input-box">
                        <input type="number" id="price" name="price" value="${sessionScope.formData.price}" placeholder="Nhập giá dịch vụ" min="0" step="1000" required>
                        <i class="fas fa-money-bill"></i>
                    </div>
                </div>
                <div class="form-group">
                    <label for="status">Trạng Thái:</label>
                    <div class="input-box">
                        <select id="status" name="status" required>
                            <option value="" disabled ${empty sessionScope.formData.status ? 'selected' : ''}>Chọn trạng thái</option>
                            <option value="Active" ${sessionScope.formData.status == 'Active' ? 'selected' : ''}>Active</option>
                            <option value="Inactive" ${sessionScope.formData.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                        </select>
                        <i class="fas fa-toggle-on"></i>
                    </div>
                </div>
                <div class="form-group">
                    <input type="submit" value="Thêm Dịch Vụ">
                </div>
                <div class="form-group">
                    <input type="button" value="Quay Lại Danh Sách" onclick="window.history.back()">
                </div> 
            </form>
        </div>
    </body>
</html>
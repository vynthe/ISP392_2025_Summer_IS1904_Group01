<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chỉnh Sửa Kết Quả Khám</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f8f9fa;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 20px;
        }
        .header {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            padding: 10px 20px;
            border-radius: 8px 8px 0 0;
            margin: -20px -20px 20px -20px;
        }
        .header h2 {
            margin: 0;
            font-size: 20px;
            font-weight: 600;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
        }
        input[readonly], select[readonly] {
            background-color: #e9ecef;
            cursor: not-allowed;
        }
        textarea {
            width: 100%;
            padding: 8px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            box-sizing: border-box;
            height: 100px;
            resize: vertical;
        }
        .error {
            color: #dc3545;
            font-size: 14px;
            margin-top: 5px;
        }
        .buttons {
            margin-top: 20px;
            text-align: right;
        }
        .btn {
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 500;
        }
        .btn-save {
            background-color: #28a745;
            color: white;
        }
        .btn-save:hover {
            background-color: #218838;
        }
        .btn-cancel {
            background-color: #6c757d;
            color: white;
            margin-right: 10px;
        }
        .btn-cancel:hover {
            background-color: #5a6268;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>✏️ Chỉnh Sửa Kết Quả Khám</h2>
        </div>
        <c:if test="${not empty errorMessage}">
            <div class="error">${errorMessage}</div>
        </c:if>
        <form action="${pageContext.request.contextPath}/EditExaminationResultServlet" method="post">
            <input type="hidden" name="appointmentId" value="${resultDetails.appointmentId}" />
            <div class="form-group">
                <label for="status">Trạng Thái:</label>
                <input type="text" id="status" name="status" value="${resultDetails.status}" readonly />
            </div>
            <div class="form-group">
                <label for="diagnosis">Chuẩn Đoán:</label>
                <input type="text" id="diagnosis" name="diagnosis" value="${resultDetails.diagnosis}" readonly />
            </div>
            <div class="form-group">
                <label for="notes">Ghi Chú:</label>
                <textarea id="notes" name="notes">${resultDetails.notes}</textarea>
            </div>
            <div class="buttons">
                <button type="button" class="btn btn-cancel" onclick="window.location.href='${pageContext.request.contextPath}/ViewExaminationResults?appointmentId=${resultDetails.appointmentId}'">Hủy</button>
                <button type="submit" class="btn btn-save">Lưu</button>
            </div>
        </form>
    </div>
</body>
</html>
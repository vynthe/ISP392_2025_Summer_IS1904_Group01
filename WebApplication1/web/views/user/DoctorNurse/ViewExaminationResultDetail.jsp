<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chi Tiết Kết Quả Khám</title>
    <style>
        .detail-container { 
            max-width: 600px; 
            margin: 20px auto; 
            padding: 20px; 
            border: 1px solid #ccc; 
            border-radius: 5px; 
            font-family: Arial, sans-serif;
        }
        .detail-item { 
            margin-bottom: 15px; 
            padding: 10px;
            background-color: #f9f9f9;
            border-radius: 3px;
        }
        .detail-item label {
            font-weight: bold;
            color: #333;
            margin-right: 10px;
        }
        .error { 
            color: red; 
            text-align: center; 
            padding: 10px;
            background-color: #ffe6e6;
            border-radius: 3px;
            margin-bottom: 15px;
        }
        .back-btn { 
            margin-top: 20px; 
            text-align: center;
        }
        .back-btn button {
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }
        .back-btn button:hover {
            background-color: #0056b3;
        }
        .debug-section {
            margin-top: 30px;
            padding: 15px;
            border: 1px dashed #999;
            background-color: #f0f0f0;
        }
        .debug-section h3 {
            color: #666;
            margin-top: 0;
        }
    </style>
</head>
<body>
    <div class="detail-container">
        <h2>Chi Tiết Kết Quả Khám</h2>
        
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>
        
        <c:choose>
            <c:when test="${not empty resultDetails}">
                <div class="detail-item">
                    <label>Bác Sĩ:</label> 
                    <span><c:out value="${resultDetails.doctorName}" default="Không có thông tin" /></span>
                </div>
                <div class="detail-item">
                    <label>Bệnh Nhân:</label> 
                    <span><c:out value="${resultDetails.patientName}" default="Không có thông tin" /></span>
                </div>
                <div class="detail-item">
                    <label>Chẩn Đoán:</label> 
                    <span><c:out value="${examinationResultDAO.getDiagnosisByAppointmentId(resultDetails.appointmentId)}" default="Không có thông tin" /></span>
                </div>
                <div class="detail-item">
                    <label>Ghi Chú:</label> 
                    <span><c:out value="${resultDetails.notes}" default="Không có ghi chú" /></span>
                </div>
            </c:when>
            <c:otherwise>
                <div class="error">Không tìm thấy thông tin chi tiết kết quả khám</div>
            </c:otherwise>
        </c:choose>
        
        <div class="back-btn">
            <button onclick="window.location.href='${pageContext.request.contextPath}/ViewExaminationResults'">
                Quay Lại
            </button>
        </div>
        
        <%-- Debug section - chỉ hiển thị khi cần thiết --%>
        <%
        // Thêm import statement để tránh lỗi Map cannot be resolved
        Map<String, Object> resultDetails = (Map<String, Object>) request.getAttribute("resultDetails");
        if (request.getParameter("debug") != null && "true".equals(request.getParameter("debug"))) {
        %>
            <div class="debug-section">
                <h3>Debug Information</h3>
                <%
                if (resultDetails != null) {
                    out.println("<div class='detail-item'><label>Bác Sĩ (Debug):</label> <span>" + resultDetails.get("doctorName") + "</span></div>");
                    out.println("<div class='detail-item'><label>Bệnh Nhân (Debug):</label> <span>" + resultDetails.get("patientName") + "</span></div>");
                    out.println("<div class='detail-item'><label>Chẩn Đoán (Debug):</label> <span>" + resultDetails.get("diagnosis") + "</span></div>");
                    out.println("<div class='detail-item'><label>Ghi Chú (Debug):</label> <span>" + resultDetails.get("notes") + "</span></div>");
                } else {
                    out.println("<div class='error'>No resultDetails found in request scope (Debug)</div>");
                }
                %>
            </div>
        <%
        }
        %>
    </div>
</body>
</html>
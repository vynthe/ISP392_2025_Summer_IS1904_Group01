<%-- 
    Document   : ViewScheduleDetails
    Created on : 6 Jun 2025, 11:40:00
    Author     : exorc
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Schedule Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #ede7f6, #d1c4e9);
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            padding: 0;
            position: relative;
        }

        .container-wrapper {
            position: relative;
            min-height: 100vh;
        }

        .container {
            background: #ffffff;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
            margin-top: 40px;
            margin-bottom: 40px;
            position: relative;
            overflow: hidden;
            z-index: 1;
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

        .full-width-bottom-border {
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(to right, #7B1FA2, #AB47BC);
            z-index: 0;
        }

        h2 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 30px;
            font-size: 28px;
            font-weight: 600;
            letter-spacing: 1px;
        }

        .btn-primary {
            background: linear-gradient(to right, #7B1FA2, #AB47BC);
            border: none;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background: linear-gradient(to right, #6A1B9A, #9C27B0);
            box-shadow: 0 5px 15px rgba(123, 31, 162, 0.3);
        }

        .detail-label {
            font-weight: bold;
            color: #2c3e50;
        }

        .detail-value {
            color: #34495e;
        }

        .alert-danger {
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container-wrapper">
        <div class="container">
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <div class="d-flex justify-content-between mb-3">
                <a href="${pageContext.request.contextPath}/ViewSchedulesServlet?page=${param.page}&employeeName=${param.employeeName}&searchDate=${param.searchDate}&role=${param.role}&employeeID=${param.employeeID}" class="btn btn-primary">Back to Schedules</a>
            </div>
            <h2 class="text-center mb-4">Chi Tiết Lịch Trình</h2>

            <c:if test="${not empty scheduleDetails}">
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <span class="detail-label">Schedule ID:</span>
                        <span class="detail-value">${scheduleDetails.scheduleID}</span>
                    </div>
                    <div class="col-md-6 mb-3">
                        <span class="detail-label">Employee ID:</span>
                        <span class="detail-value">${scheduleDetails.employeeID}</span>
                    </div>
                    <div class="col-md-6 mb-3">
                        <span class="detail-label">Role:</span>
                        <span class="detail-value">${scheduleDetails.role}</span>
                    </div>
                    <div class="col-md-6 mb-3">
                        <span class="detail-label">Start Time:</span>
                        <span class="detail-value"><fmt:formatDate value="${scheduleDetails.startTime}" pattern="dd/MM/yyyy HH:mm" /></span>
                    </div>
                    <div class="col-md-6 mb-3">
                        <span class="detail-label">End Time:</span>
                        <span class="detail-value"><fmt:formatDate value="${scheduleDetails.endTime}" pattern="dd/MM/yyyy HH:mm" /></span>
                    </div>
                    <div class="col-md-6 mb-3">
                        <span class="detail-label">Shift Start:</span>
                        <span class="detail-value"><fmt:formatDate value="${scheduleDetails.shiftStart}" pattern="HH:mm" /></span>
                    </div>
                    <div class="col-md-6 mb-3">
                        <span class="detail-label">Shift End:</span>
                        <span class="detail-value"><fmt:formatDate value="${scheduleDetails.shiftEnd}" pattern="HH:mm" /></span>
                    </div>
                    <div class="col-md-6 mb-3">
                        <span class="detail-label">Day of Week:</span>
                        <span class="detail-value">${scheduleDetails.dayOfWeek}</span>
                    </div>
                    <div class="col-md-6 mb-3">
                        <span class="detail-label">Room ID:</span>
                        <span class="detail-value">${scheduleDetails.roomID}</span>
                    </div>
                    <div class="col-md-6 mb-3">
                        <span class="detail-label">Room Name:</span>
                        <span class="detail-value">${scheduleDetails.roomName}</span>
                    </div>
                    <div class="col-md-6 mb-3">
                        <span class="detail-label">Doctor ID:</span>
                        <span class="detail-value">${scheduleDetails.doctorID}</span>
                    </div>
                    <div class="col-md-6 mb-3">
                        <span class="detail-label">Doctor Name:</span>
                        <span class="detail-value">${scheduleDetails.doctorName}</span>
                    </div>
                    <div class="col-md-6 mb-3">
                        <span class="detail-label">Nurse ID:</span>
                        <span class="detail-value">${scheduleDetails.nurseID}</span>
                    </div>
                    <div class="col-md-6 mb-3">
                        <span class="detail-label">Nurse Name:</span>
                        <span class="detail-value">${scheduleDetails.nurseName}</span>
                    </div>
                    <div class="col-md-6 mb-3">
                        <span class="detail-label">Status:</span>
                        <span class="detail-value">${scheduleDetails.status}</span>
                    </div>
                </div>

                <h3 class="mt-4">Danh sách dịch vụ</h3>
                <c:choose>
                    <c:when test="${not empty scheduleDetails.services and not empty scheduleDetails.services[0]}">
                        <c:forEach var="service" items="${scheduleDetails.services}">
                            <div class="row mb-2">
                                <div class="col-md-6">
                                    <span class="detail-label">Service Name:</span>
                                    <span class="detail-value">${service.serviceName}</span>
                                </div>
                                <div class="col-md-6">
                                    <span class="detail-label">Price:</span>
                                    <span class="detail-value">${service.price}</span>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p class="detail-value">Không có dịch vụ nào.</p>
                    </c:otherwise>
                </c:choose>

                <h3 class="mt-4">Danh sách bệnh nhân</h3>
                <c:choose>
                    <c:when test="${not empty scheduleDetails.patients and not empty scheduleDetails.patients[0]}">
                        <c:forEach var="patient" items="${scheduleDetails.patients}">
                            <div class="row mb-2">
                                <div class="col-md-6">
                                    <span class="detail-label">Patient ID:</span>
                                    <span class="detail-value">${patient.patientID}</span>
                                </div>
                                <div class="col-md-6">
                                    <span class="detail-label">Full Name:</span>
                                    <span class="detail-value">${patient.fullName}</span>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p class="detail-value">Không có bệnh nhân nào.</p>
                    </c:otherwise>
                </c:choose>
            </c:if>
            <c:if test="${empty scheduleDetails}">
                <p class="detail-value">Không tìm thấy chi tiết lịch.</p>
            </c:if>
        </div>
        <div class="full-width-bottom-border"></div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
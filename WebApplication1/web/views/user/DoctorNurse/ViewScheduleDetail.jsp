<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi Tiết Ca Làm & Lịch Hẹn</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="container mt-4">

    <h3 class="text-primary mb-4">
        🕒 Chi tiết ca làm - Phòng ID: ${roomId}, Ca làm ID: ${slotId}
    </h3>

    <c:if test="${empty scheduleDetails}">
        <div class="alert alert-warning">
            Không tìm thấy ca làm việc hoặc lịch hẹn tương ứng.
        </div>
    </c:if>

    <c:if test="${not empty scheduleDetails}">
        <table class="table table-bordered table-hover align-middle">
            <thead class="table-light">
                <tr>
                    <th>#</th>
                    <th>Ngày làm</th>
                    <th>Giờ bắt đầu</th>
                    <th>Giờ kết thúc</th>
                    <th>Vai trò</th>
                    <th>Trạng thái ca</th>
                    <th>Thông tin lịch hẹn</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${scheduleDetails}" varStatus="loop">
                    <tr>
                        <td>${loop.index + 1}</td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty item.slotDate}">
                                    <fmt:formatDate value="${item.slotDate}" pattern="dd/MM/yyyy"/>
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty item.startTime}">
                                    <fmt:formatDate value="${item.startTime}" pattern="HH:mm"/>
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty item.endTime}">
                                    <fmt:formatDate value="${item.endTime}" pattern="HH:mm"/>
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>
                        <td>${item.role}</td>
                        <td>${item.scheduleStatus}</td>

                        <td>
                            <c:choose>
                                <c:when test="${not empty item.appointmentId}">
                                    <div><strong>✅ Đã đặt lịch</strong></div>
                                    <div><strong>Bệnh nhân:</strong> ${item.patientName}</div>
                                    <div><strong>Dịch vụ:</strong> 
                                        <c:choose>
                                            <c:when test="${not empty item.serviceName}">
                                                ${item.serviceName}
                                            </c:when>
                                            <c:otherwise><em>N/A</em></c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <em>⏳ Chưa có lịch hẹn</em>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>

    <div class="mt-3">
        <a href="/ISP392_Group1/ViewScheduleUserServlet" class="btn btn-secondary">← Quay lại danh sách phòng</a>
    </div>

</body>
</html>


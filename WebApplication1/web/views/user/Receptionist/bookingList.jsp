<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointment List</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2 class="mb-4">Danh sách lịch hẹn</h2>

        <!-- Hiển thị thông báo lỗi nếu có -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <!-- Bảng danh sách lịch hẹn -->
        <table class="table table-bordered table-striped">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Bệnh nhân</th>
                    <th>Bác sĩ</th>
                    <th>Dịch vụ</th>
                    <th>Phòng</th>
                    <th>Ngày</th>
                    <th>Thời gian</th>
                    <th>Trạng thái</th>
                    <th>Ngày tạo</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="appointment" items="${appointments}">
                    <tr>
                        <td>${appointment.appointmentId}</td>
                        <td>${appointment.patientName}</td>
                        <td>${appointment.doctorName}</td>
                        <td>${appointment.serviceName}</td>
                        <td>${appointment.roomName}</td>
                        <td>
                            <fmt:formatDate value="${appointment.slotDate}" pattern="dd/MM/yyyy" />
                        </td>
                        <td>
                            ${appointment.startTime} - ${appointment.endTime}
                        </td>
                        <td>${appointment.status}</td>
                        <td>
                            <fmt:formatDate value="${appointment.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty appointments}">
                    <tr>
                        <td colspan="9" class="text-center">Không có lịch hẹn nào.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>

        <!-- Phân trang -->
        <nav aria-label="Page navigation">
            <ul class="pagination justify-content-center">
                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                    <a class="page-link" href="?page=${currentPage - 1}&pageSize=${pageSize}">Previous</a>
                </li>
                <li class="page-item">
                    <a class="page-link" href="?page=${currentPage + 1}&pageSize=${pageSize}">Next</a>
                </li>
            </ul>
        </nav>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
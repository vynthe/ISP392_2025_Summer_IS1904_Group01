<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Làm Việc (Lễ Tân)</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- FullCalendar CSS -->
    <link href='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/main.min.css' rel='stylesheet' />
</head>
<body class="bg-gray-100 font-sans">
    <div class="container max-w-6xl mx-auto bg-white p-6 rounded-lg shadow-md mt-5">
        <h1 class="text-2xl font-bold text-center text-gray-800 mb-6">Lịch Làm Việc (Lễ Tân)</h1>

        <c:if test="${not empty error}">
            <p class="text-red-600 text-center mb-4"><i class="fas fa-exclamation-circle"></i> <c:out value="${error}"/></p>
        </c:if>

        <c:if test="${not empty schedules}">
            <div class="overflow-x-auto">
                <table class="min-w-full bg-white border border-gray-200">
                    <thead>
                        <tr class="bg-blue-600 text-white">
                            <th class="py-3 px-4 text-left">Mã Lịch</th>
                            <th class="py-3 px-4 text-left">Họ Tên</th>
                            <th class="py-3 px-4 text-left">Vai Trò</th>
                            <th class="py-3 px-4 text-left">Mã Phòng</th>
                            <th class="py-3 px-4 text-left">Tên Phòng</th>
                            <th class="py-3 px-4 text-left">Ngày Làm</th>
                            <th class="py-3 px-4 text-left">Giờ Bắt Đầu</th>
                            <th class="py-3 px-4 text-left">Giờ Kết Thúc</th>
                            <th class="py-3 px-4 text-left">Trạng Thái</th>
                            <th class="py-3 px-4 text-left">Dịch Vụ</th>
                            <th class="py-3 px-4 text-left">Người Tạo</th>
                            <th class="py-3 px-4 text-left">Ngày Tạo</th>
                            <th class="py-3 px-4 text-left">Ngày Cập Nhật</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="schedule" items="${schedules}">
                            <tr class="hover:bg-gray-50">
                                <td class="py-2 px-4 border-b">${schedule.slotId}</td>
                                <td class="py-2 px-4 border-b">${schedule.fullName}</td>
                                <td class="py-2 px-4 border-b">${schedule.role}</td>
                                <td class="py-2 px-4 border-b">${schedule.roomId != null ? schedule.roomId : 'Chưa phân phòng'}</td>
                                <td class="py-2 px-4 border-b">${schedule.roomName != null ? schedule.roomName : 'Chưa phân phòng'}</td>
                                <td class="py-2 px-4 border-b">${schedule.slotDate != null ? schedule.slotDate.toString() : 'Chưa xác định'}</td>
                                <td class="py-2 px-4 border-b">${schedule.startTime != null ? schedule.startTime.toString() : 'Chưa xác định'}</td>
                                <td class="py-2 px-4 border-b">${schedule.endTime != null ? schedule.endTime.toString() : 'Chưa xác định'}</td>
                                <td class="py-2 px-4 border-b">${schedule.status}</td>
                                <td class="py-2 px-4 border-b">
                                    <c:choose>
                                        <c:when test="${not empty schedule.serviceNames}">
                                            <c:forEach var="service" items="${schedule.serviceNames}" varStatus="loop">
                                                ${service}<c:if test="${!loop.last}">, </c:if>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>Chưa chọn dịch vụ</c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="py-2 px-4 border-b">${schedule.createdBy}</td>
                                <td class="py-2 px-4 border-b">${schedule.createdAt != null ? schedule.createdAt.toString() : 'Chưa xác định'}</td>
                                <td class="py-2 px-4 border-b">${schedule.updatedAt != null ? schedule.updatedAt.toString() : 'Chưa xác định'}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Calendar View -->
            <div id='calendar' class="mt-10"></div>
        </c:if>

        <a href="${pageContext.request.contextPath}/views/receptionist/ReceptionistDashBoard.jsp" class="block mt-5 text-center text-blue-600 font-semibold hover:underline">Quay lại Dashboard</a>
    </div>

    <!-- FullCalendar JS -->
    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/main.min.js'></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            var calendarEl = document.getElementById('calendar');
            var events = [];

            <c:forEach var="schedule" items="${schedules}">
                <c:if test="${schedule.slotDate != null && schedule.startTime != null && schedule.endTime != null}">
                    events.push({
                        title: '<c:out value="${schedule.fullName}" escapeXml="true"/> - <c:out value="${schedule.role}" escapeXml="true"/>',
                        start: '${schedule.slotDate}T${schedule.startTime}',
                        end: '${schedule.slotDate}T${schedule.endTime}',
                        description: '<c:out value="${schedule.roomName != null ? schedule.roomName : 'Chưa phân phòng'}" escapeXml="true"/>'
                    });
                </c:if>
            </c:forEach>

            var calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'timeGridWeek',
                headerToolbar: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'dayGridMonth,timeGridWeek,timeGridDay'
                },
                events: events,
                eventDidMount: function(info) {
                    info.el.setAttribute('title', info.event.extendedProps.description);
                }
            });

            calendar.render();
        });
    </script>
</body>
</html>
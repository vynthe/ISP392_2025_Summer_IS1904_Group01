<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Làm Việc - ${employee.fullName}</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 10px;
            background-color: #f5f5f5;
        }

        .header {
            margin-bottom: 10px;
        }

        .header select {
            margin-right: 10px;
            padding: 5px 8px;
            border: 1px solid #999;
            background-color: white;
            font-size: 12px;
        }

        .header label {
            font-weight: bold;
            margin-right: 5px;
        }

        table {
            border-collapse: collapse;
            width: 100%;
            background-color: white;
            font-size: 11px;
            min-height: 600px;
        }

        th, td {
            border: 1px solid #999;
            padding: 4px;
            text-align: left;
            vertical-align: top;
        }

        th {
            background-color: #7ba5d4;
            color: white;
            font-weight: bold;
            text-align: center;
            padding: 8px;
        }

        .week-header {
            background-color: #7ba5d4;
            color: white;
            font-weight: bold;
            text-align: center;
            width: 80px;
            min-width: 80px;
        }

        .slot-header {
            background-color: #7ba5d4;
            color: white;
            font-weight: bold;
            text-align: center;
            width: 80px;
            min-width: 80px;
            writing-mode: horizontal-tb;
        }

        .service-name {
            background-color: #ffc107;
            color: #000;
            padding: 2px 4px;
            border-radius: 3px;
            font-size: 10px;
            font-weight: bold;
            margin-right: 5px;
            display: inline-block;
        }

        .room-info {
            font-size: 10px;
            color: #333;
            margin: 2px 0;
        }

        .slot-count {
            background-color: #17a2b8;
            color: white;
            padding: 1px 4px;
            border-radius: 3px;
            font-size: 9px;
            margin: 2px 2px 2px 0;
            display: inline-block;
        }

        .action-button {
            background-color: #007bff;
            color: white;
            padding: 2px 4px;
            border-radius: 3px;
            font-size: 8px;
            margin: 1px 2px;
            border: none;
            cursor: pointer;
            display: inline-block;
        }

        .action-button:hover {
            opacity: 0.8;
        }

        .view-details {
            background-color: #ffc107;
            color: #000;
        }

        .book-appointment {
            background-color: #28a745;
            color: white;
        }

        .cell-content {
            min-height: 80px;
            line-height: 1.3;
            padding: 5px;
            overflow: auto;
        }

        .empty-cell {
            text-align: center;
            color: #666;
            font-size: 14px;
            min-height: 80px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .day-column {
            min-width: 150px;
            width: 14.28%;
        }

        .service-block {
            margin-bottom: 8px;
            padding: 3px;
            border-left: 3px solid #007bff;
            background-color: #f8f9fa;
        }

        .error-message {
            color: red;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .message {
            color: green;
            font-weight: bold;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <c:if test="${not empty error}">
        <div class="error-message">${error}</div>
    </c:if>
    <c:if test="${not empty message}">
        <div class="message">${message}</div>
    </c:if>

    <div class="header">
        <label>NĂM</label>
        <select id="yearSelect" onchange="updateWeeks()">
            <option value="2025" ${year == 2025 ? 'selected' : ''}>2025</option>
            <option value="2026" ${year == 2026 ? 'selected' : ''}>2026</option>
        </select>
        <label>TUẦN</label>
        <select id="weekSelect" onchange="updateDateHeader()">
            <c:forEach var="i" begin="28" end="52" step="1">
                <c:set var="startDate" value="${weekStart}"/>
                <c:set var="weekStartDate" value="${startDate.plusDays((i - 28) * 7)}"/>
                <c:set var="weekEndDate" value="${weekStartDate.plusDays(6)}"/>
                <fmt:formatDate var="startFormatted" value="${weekStartDate}" pattern="dd/MM"/>
                <fmt:formatDate var="endFormatted" value="${weekEndDate}" pattern="dd/MM"/>
                <option value="${i} (${startFormatted} To ${endFormatted})" ${week == i ? 'selected' : ''}>
                    ${i} (${startFormatted} To ${endFormatted})
                </option>
            </c:forEach>
        </select>
    </div>

    <table>
        <thead>
            <tr>
                <th class="week-header">NĂM</th>
                <th class="day-column">THỨ HAI</th>
                <th class="day-column">THỨ BA</th>
                <th class="day-column">THỨ TƯ</th>
                <th class="day-column">THỨ NĂM</th>
                <th class="day-column">THỨ SÁU</th>
                <th class="day-column">THỨ BẢY</th>
                <th class="day-column">CHỦ NHẬT</th>
            </tr>
            <tr>
                <th class="week-header">TUẦN</th>
                <th id="mon-date"><fmt:formatDate value="${weekStart}" pattern="dd/MM"/></th>
                <th id="tue-date"><fmt:formatDate value="${weekStart.plusDays(1)}" pattern="dd/MM"/></th>
                <th id="wed-date"><fmt:formatDate value="${weekStart.plusDays(2)}" pattern="dd/MM"/></th>
                <th id="thu-date"><fmt:formatDate value="${weekStart.plusDays(3)}" pattern="dd/MM"/></th>
                <th id="fri-date"><fmt:formatDate value="${weekStart.plusDays(4)}" pattern="dd/MM"/></th>
                <th id="sat-date"><fmt:formatDate value="${weekStart.plusDays(5)}" pattern="dd/MM"/></th>
                <th id="sun-date"><fmt:formatDate value="${weekStart.plusDays(6)}" pattern="dd/MM"/></th>
            </tr>
        </thead>
        <tbody>
            <!-- Slot 1: 7:30-12:30 -->
            <tr>
                <td class="slot-header">Ca 1<br>7:30-12:30</td>
                <c:forEach var="dayOffset" begin="0" end="6">
                    <c:set var="currentDate" value="${weekStart.plusDays(dayOffset)}"/>
                    <td class="cell-content">
                        <c:set var="schedule" value="${schedules.stream()
                            .filter(s -> java.sql.Date.valueOf(s.scheduleDate).equals(currentDate) && 
                                         s.startTime.equals(java.sql.Time.valueOf('07:30:00')) && 
                                         s.endTime.equals(java.sql.Time.valueOf('12:30:00')))
                            .findFirst().orElse(null)}"/>
                        <c:choose>
                            <c:when test="${schedule != null}">
                                <div class="service-block">
                                    <span class="service-name">${schedule.serviceName}</span>
                                    <button class="action-button view-details" onclick="viewDetails(${schedule.id})">Xem chi tiết</button><br>
                                    <span class="room-info">Phòng ${schedule.roomId}</span><br>
                                    <span class="slot-count">Số slot: ${schedule.availableSlots}</span>
                                    <button class="action-button book-appointment" onclick="bookAppointment(${schedule.id})">Đặt lịch</button>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-cell">-</div>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </c:forEach>
            </tr>

            <!-- Slot 2: 13:00-17:30 -->
            <tr>
                <td class="slot-header">Ca 2<br>13:00-17:30</td>
                <c:forEach var="dayOffset" begin="0" end="6">
                    <c:set var="currentDate" value="${weekStart.plusDays(dayOffset)}"/>
                    <td class="cell-content">
                        <c:set var="schedule" value="${schedules.stream()
                            .filter(s -> java.sql.Date.valueOf(s.scheduleDate).equals(currentDate) && 
                                         s.startTime.equals(java.sql.Time.valueOf('13:00:00')) && 
                                         s.endTime.equals(java.sql.Time.valueOf('17:30:00')))
                            .findFirst().orElse(null)}"/>
                        <c:choose>
                            <c:when test="${schedule != null}">
                                <div class="service-block">
                                    <span class="service-name">${schedule.serviceName}</span>
                                    <button class="action-button view-details" onclick="viewDetails(${schedule.id})">Xem chi tiết</button><br>
                                    <span class="room-info">Phòng ${schedule.roomId}</span><br>
                                    <span class="slot-count">Số slot: ${schedule.availableSlots}</span>
                                    <button class="action-button book-appointment" onclick="bookAppointment(${schedule.id})">Đặt lịch</button>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-cell">-</div>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </c:forEach>
            </tr>

            <!-- Slot 3: 18:00-20:00 -->
            <tr>
                <td class="slot-header">Ca 3<br>18:00-20:00</td>
                <c:forEach var="dayOffset" begin="0" end="6">
                    <c:set var="currentDate" value="${weekStart.plusDays(dayOffset)}"/>
                    <td class="cell-content">
                        <c:set var="schedule" value="${schedules.stream()
                            .filter(s -> java.sql.Date.valueOf(s.scheduleDate).equals(currentDate) && 
                                         s.startTime.equals(java.sql.Time.valueOf('18:00:00')) && 
                                         s.endTime.equals(java.sql.Time.valueOf('20:00:00')))
                            .findFirst().orElse(null)}"/>
                        <c:choose>
                            <c:when test="${schedule != null}">
                                <div class="service-block">
                                    <span class="service-name">${schedule.serviceName}</span>
                                    <button class="action-button view-details" onclick="viewDetails(${schedule.id})">Xem chi tiết</button><br>
                                    <span class="room-info">Phòng ${schedule.roomId}</span><br>
                                    <span class="slot-count">Số slot: ${schedule.availableSlots}</span>
                                    <button class="action-button book-appointment" onclick="bookAppointment(${schedule.id})">Đặt lịch</button>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-cell">-</div>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </c:forEach>
            </tr>
        </tbody>
    </table>

    <script>
        const yearSelect = document.getElementById('yearSelect');
        const weekSelect = document.getElementById('weekSelect');

        function updateWeeks() {
            const year = yearSelect.value;
            const weeks = year === '2025' ? generateWeeks2025() : generateWeeks2026();
            weekSelect.innerHTML = '';
            weeks.forEach((week, index) => {
                const option = document.createElement('option');
                option.value = week;
                option.textContent = week;
                weekSelect.appendChild(option);
            });
            updateDateHeader();
        }

        function generateWeeks2025() {
            const weeks = [];
            for (let i = 28; i <= 52; i++) {
                const weekStart = new Date(2025, 6, 14);
                weekStart.setDate(weekStart.getDate() + (i - 28) * 7);
                const weekEnd = new Date(weekStart);
                weekEnd.setDate(weekEnd.getDate() + 6);
                const formatDate = (date) => {
                    const day = String(date.getDate()).padStart(2, '0');
                    const month = String(date.getMonth() + 1).padStart(2, '0');
                    return `${day}/${month}`;
                };
                weeks.push(`${i} (${formatDate(weekStart)} To ${formatDate(weekEnd)})`);
            }
            return weeks;
        }

        function generateWeeks2026() {
            const weeks = [];
            for (let i = 1; i <= 52; i++) {
                const jan1 = new Date(2026, 0, 1);
                const dayOfWeek = jan1.getDay();
                let weekStart = new Date(2026, 0, 1 - dayOfWeek + 1 + (i - 1) * 7);
                if (weekStart.getFullYear() < 2026) {
                    weekStart.setDate(weekStart.getDate() + 7);
                }
                const weekEnd = new Date(weekStart);
                weekEnd.setDate(weekEnd.getDate() + 6);
                const formatDate = (date) => {
                    const day = String(date.getDate()).padStart(2, '0');
                    const month = String(date.getMonth() + 1).padStart(2, '0');
                    return `${day}/${month}`;
                };
                weeks.push(`${i} (${formatDate(weekStart)} To ${formatDate(weekEnd)})`);
            }
            return weeks;
        }

        function updateDateHeader() {
            const selectedWeek = weekSelect.value;
            const weekMatch = selectedWeek.match(/\d+ \((\d{2}\/\d{2}) To (\d{2}\/\d{2})\)/);
            if (weekMatch) {
                const startDate = weekMatch[1];
                const [startDay, startMonth] = startDate.split('/');
                const year = yearSelect.value;
                const startDateObj = new Date(parseInt(year), parseInt(startMonth) - 1, parseInt(startDay));
                const days = ['mon-date', 'tue-date', 'wed-date', 'thu-date', 'fri-date', 'sat-date', 'sun-date'];
                days.forEach((dayId, index) => {
                    const currentDate = new Date(startDateObj);
                    currentDate.setDate(currentDate.getDate() + index);
                    const formattedDate = String(currentDate.getDate()).padStart(2, '0') + '/' +
                        String(currentDate.getMonth() + 1).padStart(2, '0');
                    document.getElementById(dayId).textContent = formattedDate;
                });
            }
        }

        function viewDetails(scheduleId) {
            console.log('View details for schedule ID:', scheduleId);
            window.location.href = '${pageContext.request.contextPath}/ViewScheduleDetailServlet?id=' + scheduleId;
        }

        function bookAppointment(scheduleId) {
            console.log('Book appointment for schedule ID:', scheduleId);
            window.location.href = '${pageContext.request.contextPath}/BookAppointmentServlet?id=' + scheduleId;
        }

        // Event listeners
        weekSelect.addEventListener('change', updateDateHeader);

        // Initialize on page load
        document.addEventListener('DOMContentLoaded', function () {
            updateWeeks();
            updateDateHeader();
        });
    </script>
</body>
</html>
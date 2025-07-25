<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi Tiết Lịch Khám</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-blue-purple: #673AB7; /* Deep Purple */
            --secondary-blue-purple: #9C27B0; /* Purple */
            --light-blue-purple: #D1C4E9; /* Light Purple */
            --accent-blue: #2196F3; /* Blue for links/buttons */
            --text-dark: #333;
            --text-light: #fff;
            --background-light: #f4f7f6;
            --border-color: #e0e0e0;
            --shadow-light: rgba(0, 0, 0, 0.08);
        }

        body {
            font-family: 'Roboto', sans-serif;
            margin: 0;
            padding: 0;
            background-color: var(--background-light);
            color: var(--text-dark);
            line-height: 1.6;
        }

        .header {
            background-image: linear-gradient(to right, var(--primary-blue-purple), var(--secondary-blue-purple));
            color: var(--text-light);
            padding: 20px 0;
            text-align: center;
            box-shadow: 0 2px 10px var(--shadow-light);
            margin-bottom: 30px;
        }

        .header h1 {
            margin: 0;
            font-size: 2.5em;
            font-weight: 500;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            background-color: var(--text-light);
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 20px var(--shadow-light);
        }

        h2 {
            color: var(--primary-blue-purple);
            text-align: center;
            margin-bottom: 30px;
            font-size: 2em;
            font-weight: 500;
        }

        /* Error Message */
        .error-message {
            color: #d32f2f; /* Red */
            text-align: center;
            padding: 10px;
            background-color: #ffebee; /* Light red background */
            border: 1px solid #ef9a9a;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        /* Week Navigation */
        .week-navigation {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-bottom: 30px;
            gap: 20px;
        }

        .week-navigation button {
            background-color: var(--accent-blue);
            color: var(--text-light);
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1em;
            transition: background-color 0.3s ease, transform 0.2s ease;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        }

        .week-navigation button:hover {
            background-color: #1976d2;
            transform: translateY(-2px);
        }

        #currentWeek {
            font-size: 1.2em;
            font-weight: 500;
            color: var(--primary-blue-purple);
        }

        /* Weekly Calendar Styles */
        .weekly-calendar {
            border-collapse: collapse;
            width: 100%;
            border: 1px solid var(--border-color);
            border-radius: 10px;
            overflow: hidden; /* Ensures rounded corners apply to content */
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        .calendar-main-header {
            background-image: linear-gradient(to right, var(--primary-blue-purple), var(--light-blue-purple));
            color: var(--text-light);
            text-align: center;
            padding: 15px;
            font-weight: bold;
            font-size: 1.3em;
        }

        .day-header {
            background-color: var(--secondary-blue-purple);
            color: var(--text-light);
            text-align: center;
            padding: 12px 8px;
            font-weight: 500;
            width: 14.28%;
            font-size: 0.95em;
        }

        .day-header span {
            display: block;
            font-size: 0.8em;
            opacity: 0.9;
        }

        .slot-cell {
            vertical-align: top;
            padding: 10px;
            border: 1px solid var(--border-color);
            min-height: 150px; /* Increased height for more space */
            position: relative;
            background-color: #fff;
            transition: background-color 0.2s ease;
        }

        .slot-cell:hover {
            background-color: #fcfcfc;
        }

        .slot-number {
            font-weight: bold;
            color: var(--primary-blue-purple);
            font-size: 13px;
            margin-bottom: 8px;
            text-align: center;
            padding-bottom: 5px;
            border-bottom: 1px dashed var(--light-blue-purple);
        }

        .appointment {
            background-color: #e8f5e9; /* Light green for appointments */
            border: 1px solid #81c784; /* Green border */
            border-left: 5px solid #4CAF50; /* Stronger green left border */
            border-radius: 6px;
            padding: 8px;
            margin: 6px 0;
            font-size: 12px;
            position: relative;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            cursor: pointer;
        }

        .appointment:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        .appointment-patient {
            font-weight: bold;
            color: #388e3c; /* Darker green */
            margin-bottom: 3px;
            font-size: 1.1em;
        }

        .appointment-room {
            color: #555;
            font-size: 0.9em;
            margin-bottom: 2px;
        }

        .appointment-time {
            color: #444;
            font-size: 0.9em;
            margin-bottom: 2px;
        }

        .appointment-service {
            color: #2e7d32; /* Even darker green */
            font-size: 0.9em;
            font-style: italic;
        }

        .status-badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 10px;
            font-weight: bold;
            margin-top: 5px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-attended {
            background-color: #4CAF50; /* Green */
            color: white;
        }

        .status-cancelled {
            background-color: #F44336; /* Red */
            color: white;
        }
        
        /* No schedules message */
        .no-schedules-message {
            text-align: center;
            margin-top: 40px;
            padding: 30px;
            background-color: #e3f2fd; /* Light blue */
            border-radius: 10px;
            color: #1976d2; /* Darker blue */
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
        }

        .no-schedules-message h3 {
            margin-top: 0;
            font-size: 1.5em;
            color: var(--primary-blue-purple);
        }

        .no-schedules-message p {
            font-size: 1.1em;
            color: #555;
        }

        .back-link {
            display: block;
            margin-top: 40px;
            text-align: center;
            text-decoration: none;
            color: var(--accent-blue);
            font-weight: 500;
            font-size: 1.1em;
            transition: color 0.3s ease;
        }

        .back-link:hover {
            color: #1976d2;
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Quản Lý Lịch Khám Bệnh</h1>
    </div>

    <div class="container">
        <h2>Chi Tiết Lịch Khám Theo Tuần</h2>
        
        <c:if test="${not empty errorMessage}">
            <p class="error-message">${errorMessage}</p>
        </c:if>

        <div class="week-navigation">
            <button onclick="previousWeek()">← Tuần trước</button>
            <span id="currentWeek">Tuần hiện tại</span>
            <button onclick="nextWeek()">Tuần sau →</button>
        </div>
        
        <table class="weekly-calendar">
            <thead>
                <tr>
                    <th class="calendar-main-header" colspan="8">LỊCH KHÁM CHI TIẾT</th>
                </tr>
                <tr>
                    <th class="day-header">SLOT</th>
                    <th class="day-header">THỨ 2<br><span id="mon-date"></span></th>
                    <th class="day-header">THỨ 3<br><span id="tue-date"></span></th>
                    <th class="day-header">THỨ 4<br><span id="wed-date"></span></th>
                    <th class="day-header">THỨ 5<br><span id="thu-date"></span></th>
                    <th class="day-header">THỨ 6<br><span id="fri-date"></span></th>
                    <th class="day-header">THỨ 7<br><span id="sat-date"></span></th>
                    <th class="day-header">CHỦ NHẬT<br><span id="sun-date"></span></th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td class="slot-cell">
                        <div class="slot-number">Slot 1 (05:00 - 07:00)</div>
                    </td>
                    <td class="slot-cell" id="slot0-mon"></td>
                    <td class="slot-cell" id="slot0-tue"></td>
                    <td class="slot-cell" id="slot0-wed"></td>
                    <td class="slot-cell" id="slot0-thu"></td>
                    <td class="slot-cell" id="slot0-fri"></td>
                    <td class="slot-cell" id="slot0-sat"></td>
                    <td class="slot-cell" id="slot0-sun"></td>
                </tr>
                
                <tr>
                    <td class="slot-cell">
                        <div class="slot-number">Slot 2 (07:00 - 13:00)</div>
                    </td>
                    <td class="slot-cell" id="slot1-mon"></td>
                    <td class="slot-cell" id="slot1-tue"></td>
                    <td class="slot-cell" id="slot1-wed"></td>
                    <td class="slot-cell" id="slot1-thu"></td>
                    <td class="slot-cell" id="slot1-fri"></td>
                    <td class="slot-cell" id="slot1-sat"></td>
                    <td class="slot-cell" id="slot1-sun"></td>
                </tr>
                
                <tr>
                    <td class="slot-cell">
                        <div class="slot-number">Slot 3 (13:00 - 15:00)</div>
                    </td>
                    <td class="slot-cell" id="slot2-mon"></td>
                    <td class="slot-cell" id="slot2-tue"></td>
                    <td class="slot-cell" id="slot2-wed"></td>
                    <td class="slot-cell" id="slot2-thu"></td>
                    <td class="slot-cell" id="slot2-fri"></td>
                    <td class="slot-cell" id="slot2-sat"></td>
                    <td class="slot-cell" id="slot2-sun"></td>
                </tr>
                
                <tr>
                    <td class="slot-cell">
                        <div class="slot-number">Slot 4 (15:00 - 17:00)</div>
                    </td>
                    <td class="slot-cell" id="slot3-mon"></td>
                    <td class="slot-cell" id="slot3-tue"></td>
                    <td class="slot-cell" id="slot3-wed"></td>
                    <td class="slot-cell" id="slot3-thu"></td>
                    <td class="slot-cell" id="slot3-fri"></td>
                    <td class="slot-cell" id="slot3-sat"></td>
                    <td class="slot-cell" id="slot3-sun"></td>
                </tr>
            </tbody>
        </table>
        
        <c:if test="${empty schedules}">
            <div class="no-schedules-message">
                <h3>Chưa có lịch khám nào trong tuần này 😟</h3>
                <p>Vui lòng chọn tuần khác hoặc thêm lịch khám mới.</p>
            </div>
        </c:if>

        <a href="${pageContext.request.contextPath}/ViewSchedulesServlet" class="back-link">← Quay lại danh sách lịch khám</a>
    </div>

    <script>
        // Dữ liệu lịch từ server
        var scheduleData = [];
        <c:if test="${not empty schedules}">
            <c:forEach var="schedule" items="${schedules}">
                <c:set var="roomName" value="${schedule.roomName != null ? schedule.roomName : 'Chưa phân phòng'}" />
                <c:set var="serviceList" value="" />
                <c:forEach var="service" items="${schedule.serviceNames}" varStatus="loop">
                    <c:set var="serviceList" value="${serviceList}'${service}'${!loop.last ? ',' : ''}" />
                </c:forEach>

                scheduleData.push({
                    slotId: '${schedule.slotId}',
                    userId: '${schedule.userId}',
                    fullName: '<c:out value="${schedule.fullName}" escapeXml="true"/>',
                    role: '<c:out value="${schedule.role}" escapeXml="true"/>',
                    roomId: '${schedule.roomId != null ? schedule.roomId : ""}',
                    roomName: '<c:out value="${roomName}" escapeXml="true"/>',
                    slotDate: '${schedule.slotDate}',
                    startTime: '${schedule.startTime}',
                    endTime: '${schedule.endTime}',
                    status: '<c:out value="${schedule.status}" escapeXml="true"/>',
                    serviceNames: [${serviceList}],
                    createdBy: '<c:out value="${schedule.createdBy}" escapeXml="true"/>',
                    createdAt: '${schedule.createdAt}',
                    updatedAt: '${schedule.updatedAt}'
                });
            </c:forEach>
        </c:if>

        var currentWeekStart = new Date();
        // Adjust to Monday of the current week (0 = Sunday, 1 = Monday, ..., 6 = Saturday)
        // If current day is Sunday, getDay() returns 0, so (0 + 6) % 7 = 6 (Saturday).
        // For other days, it correctly calculates the offset to Monday.
        currentWeekStart.setDate(currentWeekStart.getDate() - (currentWeekStart.getDay() + 6) % 7); 
        currentWeekStart.setHours(0, 0, 0, 0); // Normalize time to start of day

        function formatDate(date) {
            return date.getDate() + '/' + (date.getMonth() + 1);
        }

        function updateWeekDates() {
            var days = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
            for (var i = 0; i < 7; i++) {
                var date = new Date(currentWeekStart);
                date.setDate(currentWeekStart.getDate() + i);
                document.getElementById(days[i] + '-date').textContent = formatDate(date);
            }
            
            // Update current week display
            var endWeek = new Date(currentWeekStart);
            endWeek.setDate(currentWeekStart.getDate() + 6);
            document.getElementById('currentWeek').textContent = 
                'Tuần ' + formatDate(currentWeekStart) + ' - ' + formatDate(endWeek);
        }

        function clearCalendar() {
            for (var slot = 0; slot <= 3; slot++) {
                var days = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
                for (var i = 0; i < days.length; i++) {
                    var day = days[i];
                    var cell = document.getElementById('slot' + slot + '-' + day);
                    if (cell) {
                        // Clear existing appointments and add the default "No schedule" message
                        cell.innerHTML = '';
                        var defaultMessageDiv = document.createElement('div');
                        defaultMessageDiv.style.cssText = "color: #999; font-size: 11px; text-align: center; padding: 10px;";
                        defaultMessageDiv.textContent = "Chưa có lịch";
                        cell.appendChild(defaultMessageDiv);
                    }
                }
            }
        }

        function getSlotFromTime(startTime) {
            // Updated slot logic based on your provided ranges:
            // Slot 1: 05:00 - 07:00
            // Slot 2: 07:00 - 13:00
            // Slot 3: 13:00 - 15:00
            // Slot 4: 15:00 - 17:00
            if (!startTime) return -1; // Indicate no valid slot

            var hour = parseInt(startTime.split(':')[0]);
            if (hour >= 5 && hour < 7) return 0; // Slot 1
            if (hour >= 7 && hour < 13) return 1; // Slot 2
            if (hour >= 13 && hour < 15) return 2; // Slot 3
            if (hour >= 15 && hour < 17) return 3; // Slot 4
            return -1; // Default or outside defined slots
        }

        function getDayOfWeek(dateStr) {
            if (!dateStr) return -1;
            var date = new Date(dateStr);
            // Adjust getDay() to make Monday = 0, Tuesday = 1, ..., Sunday = 6
            return (date.getDay() + 6) % 7; 
        }

        function getDayName(dayOfWeek) {
            var days = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
            return days[dayOfWeek];
        }

        function getStatusClass(status) {
            if (status === 'attended') return 'status-attended';
            if (status === 'cancelled') return 'status-cancelled';
            return ''; // No class for "Chưa khám" or other statuses
        }

        function getStatusText(status) {
            if (status === 'attended') return 'Đã khám';
            if (status === 'cancelled') return 'Đã hủy';
            return ''; // No text for "Chưa khám" or other statuses
        }

        function renderSchedules() {
            clearCalendar();
            
            for (var i = 0; i < scheduleData.length; i++) {
                var schedule = scheduleData[i];
                if (!schedule.slotDate) continue;
                
                var scheduleDate = new Date(schedule.slotDate);
                scheduleDate.setHours(0, 0, 0, 0); // Normalize schedule date to start of day

                var weekStart = new Date(currentWeekStart);
                var weekEnd = new Date(currentWeekStart);
                weekEnd.setDate(currentWeekStart.getDate() + 6);
                weekEnd.setHours(23, 59, 59, 999); // Set to end of the day for proper comparison
                
                // Only display schedules within the current week
                if (scheduleDate >= weekStart && scheduleDate <= weekEnd) {
                    var dayOfWeek = getDayOfWeek(schedule.slotDate);
                    var dayName = getDayName(dayOfWeek);
                    var slot = getSlotFromTime(schedule.startTime);
                    
                    if (slot === -1) { // Skip if slot is not found
                        console.warn("Could not determine slot for start time:", schedule.startTime);
                        continue;
                    }

                    var cellId = 'slot' + slot + '-' + dayName;
                    var cell = document.getElementById(cellId);
                    
                    if (cell) {
                        // Remove the "Chưa có lịch" message if it exists
                        if (cell.querySelector('div[style*="Chưa có lịch"]')) {
                            cell.innerHTML = ''; 
                        }

                        var appointmentDiv = document.createElement('div');
                        appointmentDiv.className = 'appointment';
                        
                        var services = schedule.serviceNames.length > 0 ? 
                            schedule.serviceNames.join(', ') : 'Chưa chọn dịch vụ';
                        
                        var statusClass = getStatusClass(schedule.status);
                        var statusText = getStatusText(schedule.status);
                        var statusBadgeHtml = statusText ? '<div class="status-badge ' + statusClass + '">' + statusText + '</div>' : '';

                        appointmentDiv.innerHTML = 
                            '<div class="appointment-patient">' + schedule.fullName + '</div>' +
                            '<div class="appointment-room">' + schedule.roomName + '</div>' +
                            '<div class="appointment-time">' + 
                                (schedule.startTime || '') + ' - ' + (schedule.endTime || '') + 
                            '</div>' +
                            '<div class="appointment-service">' + services + '</div>' +
                            statusBadgeHtml; // Only add badge if statusText is not empty
                        
                        cell.appendChild(appointmentDiv);
                    }
                }
            }
        }

        function previousWeek() {
            currentWeekStart.setDate(currentWeekStart.getDate() - 7);
            updateWeekDates();
            renderSchedules();
        }

        function nextWeek() {
            currentWeekStart.setDate(currentWeekStart.getDate() + 7);
            updateWeekDates();
            renderSchedules();
        }

        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            updateWeekDates();
            renderSchedules();
        });
    </script>
</body>
</html>
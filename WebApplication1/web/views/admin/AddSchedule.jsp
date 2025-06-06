<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="model.entity.Admins, model.entity.Users" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Schedule</title>
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.17/index.global.min.js"></script>
    <style>
        #calendar {
            max-width: 900px;
            margin: 20px auto;
        }
        #addEventModal {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: white;
            padding: 20px;
            border: 1px solid #ccc;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            z-index: 1000;
            max-height: 80vh;
            overflow-y: auto;
        }
        #addEventModal label {
            display: block;
            margin: 10px 0;
        }
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 999;
        }
        .time-input {
            margin-left: 10px;
        }
    </style>
</head>
<body>
    <%
        HttpSession session = request.getSession(false);
        if (session == null) {
    %>
        <script>
            alert("Please login first.");
            window.location.href = "${pageContext.request.contextPath}/login";
        </script>
    <%
            return;
        }
        Admins admin = (Admins) session.getAttribute("admin");
        Users user = (Users) session.getAttribute("user");
        if (admin == null && (user == null || !"admin".equalsIgnoreCase(user.getRole()))) {
    %>
        <script>
            alert("Only admins can access this page.");
            window.location.href = "${pageContext.request.contextPath}/login";
        </script>
    <%
            return;
        }
        Integer userId = admin != null ? admin.getAdminID() : user.getUserID();
    %>

    <button onclick="openAddEventModal()">Add Schedule</button>
    <div id="calendar"></div>

    <!-- Modal overlay -->
    <div class="modal-overlay" id="modalOverlay"></div>

    <!-- Modal để nhập thông tin sự kiện -->
    <div id="addEventModal">
        <h2>Add New Schedule</h2>
        <form id="addEventForm">
            <label>Start Date: <input type="date" id="startDate" required></label>
            <label>Start Time: <input type="time" id="startTime" class="time-input" required></label>
            <label>End Date: <input type="date" id="endDate" required></label>
            <label>End Time: <input type="time" id="endTime" class="time-input" required></label>
            <label>Day of Week:
                <select id="dayOfWeek" required>
                    <option value="">Select Day</option>
                    <option value="Monday">Monday</option>
                    <option value="Tuesday">Tuesday</option>
                    <option value="Wednesday">Wednesday</option>
                    <option value="Thursday">Thursday</option>
                    <option value="Friday">Friday</option>
                    <option value="Saturday">Saturday</option>
                </select>
            </label>
            <label>Room ID: <input type="number" id="roomId" required></label>
            <label>Recurring Weekly:
                <input type="checkbox" id="recurringWeekly" onchange="toggleRecurringWeeks()">
                (Generate for all weeks in the next month)
            </label>
            <div id="recurringWeeks" style="display: none;">
                <label>Number of Weeks: <input type="number" id="numWeeks" min="1" max="4" value="4"></label>
            </div>
            <button type="button" onclick="addEvent()">Save</button>
            <button type="button" onclick="closeAddEventModal()">Cancel</button>
        </form>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var calendarEl = document.getElementById('calendar');
            var calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'dayGridMonth',
                events: function(fetchInfo, successCallback, failureCallback) {
                    fetch('${pageContext.request.contextPath}/AddSchedulesServlet', {
                        method: 'GET',
                        headers: {
                            'Accept': 'application/json'
                        }
                    })
                    .then(response => {
                        if (!response.ok) throw new Error('Network response was not ok');
                        return response.json();
                    })
                    .then(data => {
                        const events = data.map(schedule => ({
                            title: `Room ${schedule.roomId} - ${schedule.dayOfWeek}`,
                            start: new Date(schedule.startTime).toISOString().replace(/\.000Z$/, ''),
                            end: new Date(schedule.endTime).toISOString().replace(/\.000Z$/, ''),
                            extendedProps: {
                                roomId: schedule.roomId,
                                dayOfWeek: schedule.dayOfWeek
                            }
                        }));
                        successCallback(events);
                    })
                    .catch(error => {
                        console.error('Error fetching schedules:', error);
                        failureCallback(error);
                    });
                },
                editable: true,
                eventClick: function(info) {
                    alert('Event: ' + info.event.title + '\nStart: ' + info.event.start.toLocaleString() + '\nEnd: ' + info.event.end.toLocaleString());
                }
            });
            calendar.render();
            window.calendar = calendar;
        });

        function toggleRecurringWeeks() {
            document.getElementById('recurringWeeks').style.display = document.getElementById('recurringWeekly').checked ? 'block' : 'none';
        }

        function openAddEventModal() {
            document.getElementById('addEventModal').style.display = 'block';
            document.getElementById('modalOverlay').style.display = 'block';
        }

        function closeAddEventModal() {
            document.getElementById('addEventModal').style.display = 'none';
            document.getElementById('modalOverlay').style.display = 'none';
            document.getElementById('addEventForm').reset();
            document.getElementById('recurringWeeks').style.display = 'none';
        }

        function addEvent() {
            var startDate = document.getElementById('startDate').value;
            var startTime = document.getElementById('startTime').value;
            var endDate = document.getElementById('endDate').value;
            var endTime = document.getElementById('endTime').value;
            var dayOfWeek = document.getElementById('dayOfWeek').value;
            var roomId = document.getElementById('roomId').value;
            var recurringWeekly = document.getElementById('recurringWeekly').checked;
            var numWeeks = recurringWeekly ? document.getElementById('numWeeks').value : 1;

            if (startDate && startTime && endDate && endTime && dayOfWeek && roomId) {
                var start = new Date(startDate + 'T' + startTime + ':00');
                var end = new Date(endDate + 'T' + endTime + ':00');
                if (end < start) {
                    alert('End date and time cannot be before start date and time.');
                    return;
                }

                var eventsToAdd = [];
                for (let i = 0; i < numWeeks; i++) {
                    var eventStart = new Date(start);
                    var eventEnd = new Date(end);
                    eventStart.setDate(eventStart.getDate() + (i * 7)); // Add 7 days per week
                    eventEnd.setDate(eventEnd.getDate() + (i * 7));
                    eventsToAdd.push({
                        startTime: eventStart.toISOString().replace(/\.000Z$/, ''),
                        endTime: eventEnd.toISOString().replace(/\.000Z$/, ''),
                        dayOfWeek: dayOfWeek,
                        roomId: roomId
                    });
                }

                fetch('${pageContext.request.contextPath}/AddSchedulesServlet', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        events: eventsToAdd,
                        recurring: recurringWeekly
                    })
                })
                .then(response => {
                    if (!response.ok) return response.json().then(err => { throw new Error(err.message || 'Failed to add schedule'); });
                    return response.json();
                })
                .then(data => {
                    if (data.success) {
                        data.events.forEach(event => {
                            window.calendar.addEvent({
                                title: `Room ${event.roomId} - ${event.dayOfWeek}`,
                                start: event.startTime,
                                end: event.endTime,
                                extendedProps: {
                                    roomId: event.roomId,
                                    dayOfWeek: event.dayOfWeek
                                }
                            });
                        });
                        closeAddEventModal();
                        alert('Schedule(s) added successfully!');
                    } else {
                        alert('Error adding schedule: ' + (data.message || 'Unknown error'));
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Failed to add schedule: ' + error.message);
                });
            } else {
                alert('Please fill in all required fields.');
            }
        }
    </script>
</body>
</html>
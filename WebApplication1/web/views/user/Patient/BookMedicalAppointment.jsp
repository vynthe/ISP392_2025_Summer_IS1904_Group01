<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book a Medical Appointment</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            background-color: #e0f2fe;
            font-family: 'Inter', sans-serif;
        }
        .container {
            max-width: 32rem;
            margin: 2rem auto;
            padding: 2rem;
            background-color: #f5f3ff;
            border-radius: 1rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .form-group label {
            color: #6b7280;
            font-weight: 500;
        }
        select, input[type="text"], input[type="datetime-local"] {
            background-color: #fef2f2;
            border: 1px solid #d1d5db;
            border-radius: 0.5rem;
            padding: 0.5rem;
            width: 100%;
            transition: border-color 0.2s;
        }
        select:focus, input:focus {
            outline: none;
            border-color: #a5b4fc;
            box-shadow: 0 0 0 3px rgba(165, 180, 252, 0.3);
        }
        button {
            background-color: #a5b4fc;
            color: white;
            padding: 0.75rem;
            border-radius: 0.5rem;
            border: none;
            width: 100%;
            font-weight: 600;
            transition: background-color 0.2s;
        }
        button:hover {
            background-color: #818cf8;
        }
        .error {
            color: #f87171;
            font-size: 0.875rem;
            margin-top: 0.5rem;
        }
        .loading {
            color: #a5b4fc;
            font-size: 0.875rem;
            display: none;
        }
        h2 {
            color: #4b5563;
            text-align: center;
        }
        .tab-button {
            padding: 0.5rem 1rem;
            background-color: #e0f2fe;
            border: none;
            cursor: pointer;
        }
        .tab-button.active {
            background-color: #a5b4fc;
            color: white;
        }
        .tab-content {
            display: none;
        }
        .tab-content.active {
            display: block;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2 class="text-2xl font-bold mb-6">Book a Medical Appointment</h2>
        <div class="mb-4">
            <button class="tab-button active" onclick="showTab('detailed')">Detailed Booking</button>
            <button class="tab-button" onclick="showTab('simple')">Simple Booking</button>
        </div>
        <form id="appointmentForm" action="BookMedicalAppointmentServlet" method="post" class="space-y-4">
            <input type="hidden" name="action" value="bookAppointment">
            <input type="hidden" name="type" id="bookingType">

            <!-- Detailed Booking Tab -->
            <div id="detailedTab" class="tab-content active">
                <input type="hidden" name="patientID" value="${sessionScope.user.userID}">

                <div class="form-group">
                    <label for="serviceID" class="block mb-1">Select Service:</label>
                    <select id="serviceID" name="serviceID" required onchange="loadRoomsAndDoctors()">
                        <option value="">-- Select a Service --</option>
                        <c:forEach var="service" items="${services}">
                            <option value="${service.serviceID}">${service.serviceName}</option>
                        </c:forEach>
                    </select>
                    <span id="serviceLoading" class="loading">Loading...</span>
                </div>

                <div class="form-group">
                    <label for="roomID" class="block mb-1">Select a Room:</label>
                    <select id="roomID" name="roomID" required disabled>
                        <option value="">-- Select a Room --</option>
                    </select>
                    <span id="roomLoading" class="loading">Loading rooms...</span>
                </div>

                <div class="form-group">
                    <label for="doctorID" class="block mb-1">Select Doctor:</label>
                    <select id="doctorID" name="doctorID" required disabled onchange="loadDoctorSchedule()">
                        <option value="">-- Select a Doctor --</option>
                    </select>
                    <span id="doctorLoading" class="loading">Loading doctors...</span>
                </div>

                <div class="form-group">
                    <label for="scheduleID" class="block mb-1">Select Doctor Schedule:</label>
                    <select id="scheduleID" name="scheduleID" required disabled onchange="setAppointmentTime()">
                        <option value="">-- Select a Schedule --</option>
                    </select>
                    <span id="scheduleLoading" class="loading">Loading schedules...</span>
                </div>

                <div class="form-group">
                    <label for="appointmentTime" class="block mb-1">Appointment Time:</label>
                    <input type="datetime-local" id="appointmentTime" name="appointmentTime" required readonly>
                    <input type="hidden" id="shiftStart" name="shiftStart">
                </div>
            </div>

            <!-- Simple Booking Tab -->
            <div id="simpleTab" class="tab-content">
                <div class="form-group">
                    <label for="fullName" class="block mb-1">Full Name:</label>
                    <input type="text" id="fullName" name="fullName" required>
                </div>
                <div class="form-group">
                    <label for="phoneNumber" class="block mb-1">Phone Number:</label>
                    <input type="text" id="phoneNumber" name="phoneNumber" required>
                </div>
                <div class="form-group">
                    <label for="email" class="block mb-1">Email:</label>
                    <input type="text" id="email" name="email">
                </div>
                <div class="form-group">
                    <label for="service" class="block mb-1">Service:</label>
                    <select id="service" name="service" required>
                        <option value="">-- Select a Service --</option>
                        <c:forEach var="service" items="${services}">
                            <option value="${service.serviceName}">${service.serviceName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label for="appointmentTimeSimple" class="block mb-1">Appointment Time:</label>
                    <input type="datetime-local" id="appointmentTimeSimple" name="appointmentTime" required>
                </div>
            </div>

            <button type="submit">Book Appointment</button>
        </form>

        <div id="error" class="error">${sessionScope.error}</div>
        <div id="success" class="success">${sessionScope.successMessage}</div>
        <% session.removeAttribute("error"); session.removeAttribute("successMessage"); %>
    </div>

    <script>
        $(document).ready(function() {
            showTab('detailed'); // Default tab
        });

        function showTab(tabName) {
            $('.tab-button').removeClass('active');
            $('.tab-content').removeClass('active');
            $(`.tab-button[onclick="showTab('${tabName}')"]`).addClass('active');
            $(`#${tabName}Tab`).addClass('active');
            $('#bookingType').val(tabName);
        }

        function loadRoomsAndDoctors() {
            const serviceID = $('#serviceID').val();
            if (!serviceID) {
                disableSelect('roomID');
                disableSelect('doctorID');
                disableSelect('scheduleID');
                $('#appointmentTime').val('');
                return;
            }

            $('#roomLoading').show();
            $('#doctorLoading').show();
            $.ajax({
                url: 'BookMedicalAppointmentServlet',
                type: 'GET',
                data: { action: 'getRoomsAndDoctors', serviceID: serviceID },
                success: function(data) {
                    const roomSelect = $('#roomID');
                    const doctorSelect = $('#doctorID');
                    roomSelect.html('<option value="">-- Select a Room --</option>');
                    doctorSelect.html('<option value="">-- Select a Doctor --</option>');
                    data.rooms.forEach(room => {
                        roomSelect.append(`<option value="${room.roomID}">${room.roomName}</option>`);
                    });
                    data.doctors.forEach(doctor => {
                        doctorSelect.append(`<option value="${doctor.userID}">${doctor.fullName}</option>`);
                    });
                    roomSelect.prop('disabled', false);
                    doctorSelect.prop('disabled', false);
                    $('#roomLoading').hide();
                    $('#doctorLoading').hide();
                    loadDoctorSchedule(); // Load schedules for the first doctor if selected
                },
                error: function(xhr) {
                    $('#error').text('Error loading rooms and doctors: ' + xhr.responseText);
                    disableSelect('roomID');
                    disableSelect('doctorID');
                    $('#roomLoading').hide();
                    $('#doctorLoading').hide();
                }
            });
        }

        function loadDoctorSchedule() {
            const doctorID = $('#doctorID').val();
            if (!doctorID) {
                disableSelect('scheduleID');
                $('#appointmentTime').val('');
                return;
            }

            $('#scheduleLoading').show();
            $.ajax({
                url: 'BookMedicalAppointmentServlet',
                type: 'GET',
                data: { action: 'getSchedules', doctorID: doctorID },
                success: function(data) {
                    const scheduleSelect = $('#scheduleID');
                    scheduleSelect.html('<option value="">-- Select a Schedule --</option>');
                    data.schedules.forEach(schedule => {
                        const startDateTime = new Date(schedule.startTime).toISOString().slice(0, 16);
                        scheduleSelect.append(`<option value="${schedule.scheduleID}" data-time="${startDateTime}">${schedule.startTime} - ${schedule.endTime} (${schedule.dayOfWeek})</option>`);
                    });
                    scheduleSelect.prop('disabled', false);
                    $('#scheduleLoading').hide();
                },
                error: function(xhr) {
                    $('#error').text('Error loading schedules: ' + xhr.responseText);
                    disableSelect('scheduleID');
                    $('#scheduleLoading').hide();
                }
            });
        }

        function setAppointmentTime() {
            const scheduleSelect = $('#scheduleID');
            const selectedOption = scheduleSelect.find(':selected');
            const appointmentTime = selectedOption.data('time');
            $('#appointmentTime').val(appointmentTime);
        }

        function disableSelect(id) {
            const select = $(`#${id}`);
            select.html('<option value="">-- Select an Option --</option>');
            select.prop('disabled', true);
        }

        $('#appointmentForm').on('submit', function(e) {
            const type = $('#bookingType').val();
            if (type === 'detailed') {
                const serviceID = $('#serviceID').val();
                const roomID = $('#roomID').val();
                const doctorID = $('#doctorID').val();
                const scheduleID = $('#scheduleID').val();
                const appointmentTime = $('#appointmentTime').val();
                if (!serviceID || !roomID || !doctorID || !scheduleID || !appointmentTime) {
                    e.preventDefault();
                    $('#error').text('Please complete all fields.');
                }
            } else if (type === 'simple') {
                const fullName = $('#fullName').val();
                const phoneNumber = $('#phoneNumber').val();
                const service = $('#service').val();
                const appointmentTime = $('#appointmentTimeSimple').val();
                if (!fullName || !phoneNumber || !service || !appointmentTime) {
                    e.preventDefault();
                    $('#error').text('Please complete all fields.');
                }
            }
        });
    </script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.ZoneId" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Appointment Slot - Nha Khoa PDC</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }
        .container {
            max-width: 800px;
            margin-top: 30px;
            padding: 20px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }
        .current-slot {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            border-left: 4px solid #007bff;
        }
        .form-label {
            font-weight: bold;
        }
        .btn-submit, .btn-back {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 25px;
            transition: all 0.3s ease;
        }
        .btn-submit:hover, .btn-back:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }
        .alert {
            border-radius: 15px;
        }
        .slot-option {
            padding: 10px;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            margin: 5px 0;
        }
        .slot-option:hover {
            background-color: #f8f9fa;
        }
        .current-slot-highlight {
            background-color: #fff3cd;
            color: #856404;
            border-color: #ffeaa7;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2 class="text-center mb-4">
            <i class="fas fa-calendar-alt"></i> Cập Nhật Lịch Hẹn
        </h2>

        <!-- Display error or success messages -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger" role="alert">
                <i class="fas fa-exclamation-circle"></i> ${errorMessage}
            </div>
        </c:if>
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success" role="alert">
                <i class="fas fa-check-circle"></i> ${successMessage}
            </div>
        </c:if>

        <!-- Check if appointment exists -->
        <c:if test="${not empty appointment}">
            <!-- Current Appointment Details -->
            <div class="current-slot">
                <h4><i class="fas fa-info-circle"></i> Thông Tin Lịch Hẹn Hiện Tại</h4>
                <div class="row">
                    <div class="col-md-6">
                        <p><strong>Mã Lịch Hẹn:</strong> ${appointment.appointmentId}</p>
                        <p><strong>Bác Sĩ:</strong> ${appointment.doctorName}</p>
                        <p><strong>Dịch Vụ:</strong> ${appointment.serviceName}</p>
                        <p><strong>Phòng:</strong> ${appointment.roomName}</p>
                    </div>
                    <div class="col-md-6">
                        <p><strong>Slot ID hiện tại:</strong> ${appointment.slotId}</p>
                        <p><strong>Ngày:</strong> 
                            <% 
                                java.util.Map<String, Object> appointment = (java.util.Map<String, Object>) request.getAttribute("appointment");
                                if (appointment != null) {
                                    java.time.LocalDate slotDate = (java.time.LocalDate) appointment.get("slotDate");
                                    java.util.Date date = null;
                                    if (slotDate != null) {
                                        date = java.util.Date.from(slotDate.atStartOfDay(java.time.ZoneId.systemDefault()).toInstant());
                                    }
                                    pageContext.setAttribute("convertedSlotDate", date);
                                }
                            %>
                            <c:choose>
                                <c:when test="${not empty convertedSlotDate}">
                                    <fmt:formatDate value="${convertedSlotDate}" pattern="dd-MM-yyyy"/>
                                </c:when>
                                <c:otherwise>
                                    N/A
                                </c:otherwise>
                            </c:choose>
                        </p>
                        <p><strong>Giờ:</strong> ${appointment.startTime} - ${appointment.endTime}</p>
                        <p><strong>Trạng Thái:</strong> 
                            <span class="badge bg-success">${appointment.status}</span>
                        </p>
                    </div>
                </div>
            </div>

            <!-- Debug Information (Remove in production) -->
            <div class="alert alert-info">
                <strong>Debug Info:</strong>
                <br>Appointment ID: ${appointment.appointmentId}
                <br>Doctor ID: ${appointment.doctorId}
                <br>Room ID: ${appointment.roomId}
                <br>Current Slot ID: ${appointment.slotId}
                <br>Available Slots Count: ${availableSlots.size()}
            </div>

            <!-- Update Slot Form -->
            <form action="${pageContext.request.contextPath}/UpdateAppointmentSlot" method="POST" onsubmit="return validateForm()">
                <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">
                <input type="hidden" name="doctorId" value="${appointment.doctorId}">
                <input type="hidden" name="roomId" value="${appointment.roomId}">
                
                <div class="mb-3">
                    <label for="newSlotId" class="form-label">
                        <i class="fas fa-clock"></i> Chọn Slot Mới
                    </label>
                    <select name="newSlotId" id="newSlotId" class="form-select" required>
                        <option value="" disabled selected>-- Chọn một slot khác --</option>
                        <c:forEach var="slot" items="${availableSlots}">
                            <c:choose>
                                <c:when test="${slot.slotId eq appointment.slotId}">
                                    <option value="${slot.slotId}" class="current-slot-highlight" disabled>
                                        [HIỆN TẠI] ${slot.slotDate} | ${slot.startTime} - ${slot.endTime} | Phòng: ${slot.roomId}
                                    </option>
                                </c:when>
                                <c:otherwise>
                                    <option value="${slot.slotId}">
                                        ${slot.slotDate} | ${slot.startTime} - ${slot.endTime} | Phòng: ${slot.roomId} | Trạng thái: ${slot.status}
                                    </option>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </select>
                    <div class="form-text">
                        <i class="fas fa-info-circle"></i> 
                        Chỉ hiển thị các slot có sẵn của cùng bác sĩ. Slot hiện tại được đánh dấu và không thể chọn.
                    </div>
                </div>

                <div class="text-center">
                    <button type="submit" class="btn btn-submit">
                        <i class="fas fa-save"></i> Cập Nhật Slot
                    </button>
                    <a href="${pageContext.request.contextPath}/ViewAppointmentPatient" class="btn btn-back">
                        <i class="fas fa-arrow-left"></i> Quay Lại
                    </a>
                </div>
            </form>

            <!-- Available Slots Info -->
            <div class="mt-4">
                <h5><i class="fas fa-list"></i> Danh Sách Các Slot Có Sẵn:</h5>
                <c:choose>
                    <c:when test="${empty availableSlots}">
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle"></i> 
                            Không có slot nào khác có sẵn cho bác sĩ này.
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="row">
                            <c:forEach var="slot" items="${availableSlots}" varStatus="status">
                                <div class="col-md-6 mb-2">
                                    <div class="slot-option ${slot.slotId eq appointment.slotId ? 'current-slot-highlight' : ''}">
                                        <strong>Slot ${slot.slotId}</strong>
                                        <br>📅 ${slot.slotDate}
                                        <br>🕐 ${slot.startTime} - ${slot.endTime}
                                        <br>🏥 Phòng: ${slot.roomId}
                                        <br>📊 Trạng thái: ${slot.status}
                                        <c:if test="${slot.slotId eq appointment.slotId}">
                                            <br><span class="badge bg-warning">Slot hiện tại</span>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <!-- Show error if appointment is null -->
        <c:if test="${empty appointment}">
            <div class="alert alert-warning" role="alert">
                <i class="fas fa-exclamation-triangle"></i> Không tìm thấy thông tin lịch hẹn.
                <div class="mt-2">
                    <a href="${pageContext.request.contextPath}/ViewAppointmentPatient" class="btn btn-back">
                        <i class="fas fa-arrow-left"></i> Quay Lại
                    </a>
                </div>
            </div>
        </c:if>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function validateForm() {
            const newSlotId = document.getElementById('newSlotId').value;
            const currentSlotId = '${appointment.slotId}';
            
            if (!newSlotId) {
                alert('Vui lòng chọn một slot mới!');
                return false;
            }
            
            if (newSlotId === currentSlotId) {
                alert('Bạn đã chọn slot hiện tại. Vui lòng chọn slot khác!');
                return false;
            }
            
            return confirm('Bạn có chắc chắn muốn cập nhật slot này không?');
        }

        // Highlight selected option
        document.getElementById('newSlotId').addEventListener('change', function() {
            console.log('Selected slot ID:', this.value);
        });
    </script>
</body>
</html>
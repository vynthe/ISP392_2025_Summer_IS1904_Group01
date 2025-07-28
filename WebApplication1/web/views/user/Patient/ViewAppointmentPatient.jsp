<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.time.ZoneId" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Appointments - Nha Khoa PDC</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }
        .container {
            max-width: 1200px;
            margin-top: 30px;
            padding: 20px;
        }
        .table th, .table td {
            vertical-align: middle;
            text-align: center;
        }
        .alert {
            margin-bottom: 20px;
            border-radius: 15px;
            transition: opacity 0.5s ease-in-out;
        }
        .btn-back {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 25px;
            transition: all 0.3s ease;
        }
        .btn-back:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }
        .btn-cancel {
            background: linear-gradient(135deg, #ff6b6b, #ee5a24);
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 20px;
            transition: all 0.3s ease;
            margin: 2px;
        }
        .btn-cancel:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(238, 90, 36, 0.4);
        }
        .btn-cancel:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }
        .btn-edit {
            background: linear-gradient(135deg, #74b9ff, #0984e3);
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 20px;
            transition: all 0.3s ease;
            margin: 2px;
        }
        .btn-edit:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(9, 132, 227, 0.4);
        }
        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 5px;
            flex-wrap: wrap;
        }
        #appointmentTable tr {
            transition: opacity 0.5s ease-out;
        }
        .fade-out {
            opacity: 0 !important;
            transition: opacity 0.5s ease-out;
        }
        .fade-in {
            opacity: 1 !important;
            transition: opacity 0.5s ease-in;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2 class="text-center mb-4">Lịch Khám Của Tôi</h2>

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

        <!-- Appointment Table -->
        <c:choose>
            <c:when test="${not empty appointments}">
                <table class="table table-striped table-bordered" id="appointmentTable">
                    <thead class="table-dark">
                        <tr>
                            <th>Mã Lịch Hẹn</th>
                            <th>Bác Sĩ</th>
                            <th>Dịch Vụ</th>
                            <th>Phòng</th>
                            <th>Ngày</th>
                            <th>Giờ</th>
                            <th>Trạng Thái</th>
                            <th>Thời Gian Đặt</th>
                            <th>Hành Động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="appointment" items="${appointments}">
                            <tr id="appointment-${appointment.appointmentId}">
                                <td>${appointment.appointmentId}</td>
                                <td>${appointment.doctorName}</td>
                                <td>${appointment.serviceName}</td>
                                <td>${appointment.roomName}</td>
                                <td>
                                    <% 
                                        java.util.Map<String, Object> currentAppointment = (java.util.Map<String, Object>) pageContext.getAttribute("appointment");
                                        java.time.LocalDate slotDate = (java.time.LocalDate) currentAppointment.get("slotDate");
                                        java.util.Date date = slotDate != null ? java.util.Date.from(slotDate.atStartOfDay(java.time.ZoneId.systemDefault()).toInstant()) : null;
                                        pageContext.setAttribute("convertedSlotDate", date);
                                    %>
                                    <fmt:formatDate value="${convertedSlotDate}" pattern="dd-MM-yyyy"/>
                                </td>
                                <td>${appointment.startTime} - ${appointment.endTime}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${appointment.status == 'Approved'}">
                                            <span class="badge bg-success">${appointment.status}</span>
                                        </c:when>
                                        <c:when test="${appointment.status == 'Pending'}">
                                            <span class="badge bg-warning">${appointment.status}</span>
                                        </c:when>
                                        <c:when test="${appointment.status == 'Rejected'}">
                                            <span class="badge bg-danger">${appointment.status}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">${appointment.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <fmt:formatDate value="${appointment.appointmentTime}" pattern="dd-MM-yyyy HH:mm"/>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <!-- Nút Sửa lịch -->
                                        <c:if test="${appointment.status == 'Pending' || appointment.status == 'Approved'}">
                                            <form action="${pageContext.request.contextPath}/UpdateAppointmentSlot" method="GET" style="display:inline;">
                                                <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">
                                                <button type="submit" class="btn btn-edit" title="Sửa lịch hẹn">
                                                    <i class="fas fa-edit"></i> Sửa
                                                </button>
                                            </form>
                                        </c:if>
                                        
                                        <!-- Nút Hủy lịch -->
                                        <c:if test="${appointment.status != 'Cancelled' && appointment.status != 'Rejected' && appointment.status != 'Completed'}">
                                            <button class="btn btn-cancel" onclick="cancelAppointment(${appointment.appointmentId})" title="Hủy lịch hẹn">
                                                <i class="fas fa-times"></i> Hủy
                                            </button>
                                        </c:if>
                                        
                                        <!-- Hiển thị thông báo nếu không thể thực hiện hành động -->
                                        <c:if test="${appointment.status == 'Cancelled' || appointment.status == 'Rejected' || appointment.status == 'Completed'}">
                                            <span class="badge bg-secondary">Không thể thay đổi</span>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="alert alert-info text-center" role="alert">
                    <i class="fas fa-info-circle"></i> Không tìm thấy lịch hẹn nào.
                </div>
            </c:otherwise>
        </c:choose>

        <!-- Back Button -->
        <div class="text-center mt-4">
            <a href="${pageContext.request.contextPath}/views/user/Patient/PatientDashBoard.jsp" class="btn btn-back">
                <i class="fas fa-arrow-left"></i> Quay lại Dashboard
            </a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function cancelAppointment(appointmentId) {
            if (!confirm('Bạn có chắc muốn hủy lịch hẹn này?')) {
                return;
            }

            // Disable the cancel button to prevent multiple clicks
            const cancelBtn = document.querySelector(`button[onclick="cancelAppointment(${appointmentId})"]`);
            if (cancelBtn) {
                cancelBtn.disabled = true;
                cancelBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang hủy...';
            }

            console.log('🔍 Cancelling appointment:', appointmentId);

            fetch('${pageContext.request.contextPath}/CancelAppointmentServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'appointmentId=' + encodeURIComponent(appointmentId)
            })
            .then(response => {
                console.log('🔍 HTTP Status:', response.status);
                console.log('🔍 Response OK:', response.ok);
                
                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                
                return response.json();
            })
            .then(data => {
                console.log('🔍 Full Response:', data);
                console.log('🔍 Response Status:', data.status);
                console.log('🔍 Response Message:', data.message);
                
                if (data.status === "success") {
                    // Show success message
                    showSuccessMessage(data.message || 'Hủy lịch hẹn thành công!');
                    
                    // Remove the appointment row with animation
                    removeAppointmentRow(appointmentId);
                    
                } else {
                    // Show error message
                    showErrorMessage(data.message || 'Hủy lịch hẹn thất bại!');
                    
                    // Re-enable the button
                    if (cancelBtn) {
                        cancelBtn.disabled = false;
                        cancelBtn.innerHTML = '<i class="fas fa-times"></i> Hủy';
                    }
                }
            })
            .catch(error => {
                console.error('🔍 Fetch Error:', error);
                showErrorMessage('Đã xảy ra lỗi khi hủy lịch hẹn: ' + error.message);
                
                // Re-enable the button
                if (cancelBtn) {
                    cancelBtn.disabled = false;
                    cancelBtn.innerHTML = '<i class="fas fa-times"></i> Hủy';
                }
            });
        }

        function removeAppointmentRow(appointmentId) {
            const row = document.getElementById('appointment-' + appointmentId);
            if (row) {
                // Add fade out animation
                row.style.transition = 'opacity 0.5s ease-out';
                row.style.opacity = '0';
                
                setTimeout(() => {
                    row.remove();
                    checkIfTableEmpty();
                }, 500);
            }
        }

        function checkIfTableEmpty() {
            const tableBody = document.querySelector('#appointmentTable tbody');
            if (tableBody && tableBody.children.length === 0) {
                const container = document.querySelector('.container');
                
                // Remove the entire table
                const table = document.getElementById('appointmentTable');
                if (table) {
                    table.style.transition = 'opacity 0.5s ease-out';
                    table.style.opacity = '0';
                    
                    setTimeout(() => {
                        table.remove();
                        
                        // Add no appointments message
                        const noAppointmentsDiv = document.createElement('div');
                        noAppointmentsDiv.className = 'alert alert-info text-center';
                        noAppointmentsDiv.style.opacity = '0';
                        noAppointmentsDiv.innerHTML = '<i class="fas fa-info-circle"></i> Không tìm thấy lịch hẹn nào.';
                        
                        const backButtonDiv = container.querySelector('.text-center.mt-4');
                        container.insertBefore(noAppointmentsDiv, backButtonDiv);
                        
                        // Fade in the message
                        setTimeout(() => {
                            noAppointmentsDiv.style.transition = 'opacity 0.5s ease-in';
                            noAppointmentsDiv.style.opacity = '1';
                        }, 100);
                        
                    }, 500);
                }
            }
        }

        function showSuccessMessage(message) {
            // Remove existing dynamic messages
            removeExistingMessages();
            
            const container = document.querySelector('.container');
            const successDiv = document.createElement('div');
            successDiv.className = 'alert alert-success dynamic-message';
            successDiv.style.opacity = '0';
            successDiv.innerHTML = `<i class="fas fa-check-circle"></i> ${message}`;
            
            // Insert after the title
            const title = container.querySelector('h2');
            container.insertBefore(successDiv, title.nextSibling);
            
            // Fade in animation
            setTimeout(() => {
                successDiv.style.transition = 'opacity 0.5s ease-in';
                successDiv.style.opacity = '1';
            }, 100);
            
            // Auto remove after 5 seconds
            setTimeout(() => {
                if (successDiv.parentNode) {
                    successDiv.style.transition = 'opacity 0.5s ease-out';
                    successDiv.style.opacity = '0';
                    setTimeout(() => {
                        if (successDiv.parentNode) {
                            successDiv.remove();
                        }
                    }, 500);
                }
            }, 5000);
        }

        function showErrorMessage(message) {
            // Remove existing dynamic messages
            removeExistingMessages();
            
            const container = document.querySelector('.container');
            const errorDiv = document.createElement('div');
            errorDiv.className = 'alert alert-danger dynamic-message';
            errorDiv.style.opacity = '0';
            errorDiv.innerHTML = `<i class="fas fa-exclamation-circle"></i> ${message}`;
            
            // Insert after the title
            const title = container.querySelector('h2');
            container.insertBefore(errorDiv, title.nextSibling);
            
            // Fade in animation
            setTimeout(() => {
                errorDiv.style.transition = 'opacity 0.5s ease-in';
                errorDiv.style.opacity = '1';
            }, 100);
            
            // Auto remove after 8 seconds (longer for error messages)
            setTimeout(() => {
                if (errorDiv.parentNode) {
                    errorDiv.style.transition = 'opacity 0.5s ease-out';
                    errorDiv.style.opacity = '0';
                    setTimeout(() => {
                        if (errorDiv.parentNode) {
                            errorDiv.remove();
                        }
                    }, 500);
                }
            }, 8000);
        }

        function removeExistingMessages() {
            const existingMessages = document.querySelectorAll('.alert.dynamic-message');
            existingMessages.forEach(msg => {
                if (msg.parentNode) {
                    msg.remove();
                }
            });
        }
    </script>
</body>
</html>
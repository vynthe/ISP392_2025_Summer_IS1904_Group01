<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chỉnh sửa lịch bác sĩ/y tá</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f8f9fa;
            }
            .container {
                max-width: 700px;
                margin-top: 30px;
            }
            .card {
                border-radius: 10px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }
            .card-header {
                background-color: #007bff;
                color: white;
                border-radius: 10px 10px 0 0;
            }
            .form-label {
                font-weight: bold;
            }
            .error-message {
                color: red;
                font-size: 0.9em;
                margin-bottom: 15px;
            }
            .btn-cancel {
                margin-left: 10px;
            }
            .debug-info {
                background-color: #f0f0f0;
                padding: 10px;
                border-radius: 5px;
                margin-bottom: 20px;
                font-size: 0.9em;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="card">
                <div class="card-header">
                    <h3 class="mb-0">Chỉnh sửa lịch bác sĩ/y tá</h3>
                </div>
                <div class="card-body">
                    <!-- Hiển thị thông báo lỗi nếu có -->
                    <c:if test="${not empty error}">
                        <div class="error-message">
                            <c:out value="${error}"/>
                        </div>
                    </c:if>

                    <!-- Debug info -->
                    <div class="debug-info">
                        <strong>Debug Info:</strong><br/>
                        Current Schedule Role: <c:out value="${currentSchedule['Role']}"/><br/>
                        Employees available: <c:out value="${not empty employees ? 'Yes' : 'No'}"/><br/>
                        SlotId: <c:out value="${slotId}"/><br/>
                        UserId: <c:out value="${userId}"/>
                    </div>

                    <!-- Thông tin lịch hiện tại -->
                    <h5>Thông tin lịch hiện tại</h5>
                    <div class="mb-3">
                        <p><strong>Mã lịch:</strong> <c:out value="${currentSchedule['SlotID']}"/></p>
                        <p><strong>Mã nhân viên:</strong> <c:out value="${currentSchedule['UserID']}"/></p>
                        <p><strong>Họ và tên:</strong> <c:out value="${currentSchedule['FullName']}"/></p>
                        <p><strong>Vai trò:</strong> <c:out value="${currentSchedule['Role']}"/></p>
                        <p><strong>Ngày:</strong> <c:out value="${currentSchedule['SlotDate']}"/></p>
                        <p><strong>Thời gian:</strong> <c:out value="${currentSchedule['StartTime']}"/> - <c:out value="${currentSchedule['EndTime']}"/></p>
                        <p><strong>Phòng:</strong> <c:out value="${currentSchedule['RoomName']}"/></p>
                        <p><strong>Dịch vụ:</strong> <c:out value="${currentSchedule['ServiceNames']}"/></p>
                    </div>

                    <!-- Form chỉnh sửa lịch -->
                    <h5>Chuyển lịch cho nhân viên khác</h5>
                    <form action="${pageContext.request.contextPath}/ReassignDoctorNurseServlet" method="post">
                        <input type="hidden" name="slotId" value="${currentSchedule['SlotID']}">
                        <input type="hidden" name="userId" value="${userId}">
                        
                        <div class="mb-3">
                            <label for="newUserId" class="form-label">Chọn nhân viên mới:</label>
                            <select class="form-select" id="newUserId" name="newUserId" required>
                                <option value="" disabled selected>Chọn bác sĩ/y tá</option>
                                
                                <!-- Kiểm tra employees có tồn tại không -->
                                <c:if test="${not empty employees}">
                                    <c:forEach var="employee" items="${employees}">
                                        <!-- Kiểm tra employee không null và có đủ thông tin -->
                                        <c:if test="${employee != null && 
                                                    not empty employee.fullName && 
                                                    not empty employee.role}">
                                            
                                            <!-- So sánh role đúng cách với Map -->
                                            <c:if test="${employee.role == currentSchedule['Role']}">
                                                <option value="${employee.userID}">
                                                    <c:out value="${employee.fullName}"/> (<c:out value="${employee.role}"/>)
                                                </option>
                                            </c:if>
                                        </c:if>
                                    </c:forEach>
                                </c:if>
                                
                                <!-- Hiển thị message nếu không có employees -->
                                <c:if test="${empty employees}">
                                    <option value="" disabled>Không có nhân viên phù hợp</option>
                                </c:if>
                            </select>
                        </div>
                        
                        <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                        <a href="${pageContext.request.contextPath}/ViewScheduleDoctorNurse?userID=${userId}" 
                           class="btn btn-secondary btn-cancel">Hủy</a>
                    </form>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
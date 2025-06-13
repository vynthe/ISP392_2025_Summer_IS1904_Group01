<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Tạo Lịch Làm Việc Tự Động - Hospital Management</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.17/main.min.css' rel='stylesheet' />
        <style>
            body {
                background-color: #f8f9fa;
            }
            .schedule-card {
                border: none;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                border-radius: 15px;
                transition: transform 0.3s ease;
                background-color: #ffffff;
            }
            .schedule-card:hover {
                transform: translateY(-5px);
            }
            .auto-schedule-info {
                background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
                color: white;
                border-radius: 15px;
                padding: 1.5rem;
                margin-bottom: 2rem;
            }
            .form-control, .form-select {
                border-radius: 10px;
                border: 2px solid #e9ecef;
                padding: 0.75rem 1rem;
                transition: border-color 0.3s ease;
            }
            .form-control:focus, .form-select:focus {
                border-color: #667eea;
                box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            }
            .is-invalid {
                border-color: #dc3545;
            }
            .invalid-feedback {
                display: none;
                color: #dc3545;
            }
            .form-control.is-invalid + .invalid-feedback,
            .form-select.is-invalid + .invalid-feedback {
                display: block;
            }
            .btn-primary {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border: none;
                padding: 0.75rem 2rem;
                border-radius: 10px;
                font-weight: 600;
                transition: transform 0.3s ease;
            }
            .btn-primary:hover {
                transform: translateY(-2px);
            }
            .alert {
                border-radius: 10px;
                border: none;
            }
            #calendar {
                max-width: 900px;
                margin: 40px auto;
                background-color: #ffffff;
                border-radius: 15px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                padding: 20px;
            }
            .special-schedule-item {
                border: 1px solid #dee2e6;
                border-radius: 10px;
                padding: 15px;
                margin-bottom: 15px;
                background-color: #f0f8ff;
            }
            .special-schedule-item .form-check-inline {
                margin-right: 1rem;
            }
        </style>
    </head>
    <body class="bg-light">
        <div class="container mt-4">
            <div class="row justify-content-center">
                <div class="col-md-10">
                    <div class="text-center mb-4">
                        <h1 class="display-4 fw-bold text-primary">
                            <i class="fas fa-calendar-plus me-3"></i>Tạo Lịch Làm Việc Tự Động
                        </h1>
                        <p class="lead text-muted">Tự động tạo lịch làm việc cho tất cả nhân viên y tế</p>
                    </div>

                    <c:if test="${not empty message}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>${message}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                      
                            ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>


                    <div id="autoForm" class="schedule-card card p-4 mb-4">
                        <div class="card-body">
                            <h4 class="card-title text-primary mb-4">
                                <i class="fas fa-magic me-2"></i>Tạo Lịch Tự Động Chung
                            </h4>

                            <div class="auto-schedule-info">
                                <h6><i class="fas fa-info-circle me-2"></i>Thông Tin Tạo Lịch Tự Động Chung</h6>
                                <ul class="mb-0">
                                    <li>Tạo lịch cho tất cả nhân viên không có lịch trình đặc biệt</li>
                                    <li>Lịch làm việc mặc định: Thứ 2 đến Thứ 7 (Ca sáng và Ca chiều)</li>
                                    <li>Chủ nhật: Không tạo lịch mặc định (có thể được định nghĩa trong lịch trình đặc biệt)</li>
                                    <li>Tự động phân bổ phòng và ca làm việc</li>
                                    <li>Trạng thái mặc định: Có sẵn</li>
                                </ul>
                            </div>

                            <form id="autoScheduleForm" method="post" action="${pageContext.request.contextPath}/AddScheduleServlet">
                                <input type="hidden" name="mode" value="auto">

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group mb-3">
                                            <label for="autoStartDate" class="form-label fw-bold">
                                                <i class="fas fa-calendar me-2"></i>Ngày Bắt Đầu <span class="text-danger">*</span>
                                            </label>
                                            <input type="date" class="form-control" id="autoStartDate" 
                                                   name="startDate" required min="${java.time.LocalDate.now()}">
                                            <div class="invalid-feedback">Vui lòng chọn ngày bắt đầu.</div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group mb-3">
                                            <label for="autoWeeks" class="form-label fw-bold">
                                                <i class="fas fa-calendar-week me-2"></i>Số Tuần <span class="text-danger">*</span>
                                            </label>
                                            <select class="form-select" id="autoWeeks" name="weeks" required>
                                                <option value="1">1 tuần</option>
                                                <option value="2" selected>2 tuần</option>
                                                <option value="3">3 tuần</option>
                                                <option value="4">4 tuần</option>
                                                <option value="8">8 tuần</option>
                                                <option value="12">12 tuần</option>
                                            </select>
                                            <div class="invalid-feedback">Vui lòng chọn số tuần.</div>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group mb-3">
                                    <label for="autoRole" class="form-label fw-bold">
                                        <i class="fas fa-user-tag me-2"></i>Vai Trò Áp Dụng Lịch Chung <span class="text-danger">*</span>
                                    </label>
                                    <select class="form-select" id="autoRole" name="role" required>
                                        <option value="">Chọn vai trò</option>
                                        <option value="Doctor">Bác sĩ</option>
                                        <option value="Nurse">Y tá</option>
                                        <option value="Receptionist">Lễ tân</option>
                                    </select>
                                    <div class="invalid-feedback">Vui lòng chọn vai trò.</div>
                                </div>

                                <hr class="my-4">

                                <h4 class="card-title text-primary mb-4">
                                    <i class="fas fa-user-clock me-2"></i>Lịch Trình Đặc Biệt (Tùy Chọn)
                                </h4>
                                <p class="text-muted mb-3">Thêm lịch trình riêng cho các nhân viên cụ thể. Lịch trình này sẽ ghi đè lịch trình chung.</p>

                                <div id="specialSchedulesContainer">
                                </div>

                                <button type="button" class="btn btn-outline-info mb-4" id="addSpecialSchedule">
                                    <i class="fas fa-plus-circle me-2"></i>Thêm Lịch Trình Đặc Biệt
                                </button>

                                <div class="text-center">
                                    <button type="submit" class="btn btn-primary btn-lg">
                                        <i class="fas fa-magic me-2"></i>Tạo Lịch Toàn Bộ
                                    </button>
                                    <a href="${pageContext.request.contextPath}/ViewSchedulesServlet" class="btn btn-primary btn-lg mt-3">
                                        <i class="fas fa-arrow-left me-2"></i>Quay Lại Dashboard
                                    </a>
                                </div>
                            </form>
                        </div>
                    </div>

                    <div id='calendar'></div>

                </div>
            </div>
        </div>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
        <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.17/index.global.min.js'></script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                // Set default date to today
                const today = new Date().toISOString().split('T')[0];
                document.getElementById('autoStartDate').value = today;

                // Initialize FullCalendar
                var calendarEl = document.getElementById('calendar');
                var calendar = new FullCalendar.Calendar(calendarEl, {
                    initialView: 'dayGridMonth',
                    locale: 'vi',
                    headerToolbar: {
                        left: 'prev,next today',
                        center: 'title',
                        right: 'dayGridMonth,timeGridWeek,timeGridDay'
                    },
                    events: []
                });
                calendar.render();

                // Special Schedule Logic
                let specialScheduleItemCount = 0;
                const specialSchedulesContainer = document.getElementById('specialSchedulesContainer');
                const addSpecialScheduleBtn = document.getElementById('addSpecialSchedule');

                function addSpecialScheduleItem() {
                    const index = specialScheduleItemCount++;
                    const div = document.createElement('div');
                    div.classList.add('special-schedule-item');
                    div.setAttribute('data-index', index);
                    div.innerHTML = `
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h6 class="mb-0 text-info"><i class="fas fa-calendar-alt me-2"></i>Lịch trình riêng #${index + 1}</h6>
                            <button type="button" class="btn btn-sm btn-danger remove-special-schedule">
                                <i class="fas fa-times me-1"></i>Xóa
                            </button>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="specialEmployeeId_${index}" class="form-label fw-bold">ID Nhân Viên <span class="text-danger">*</span></label>
                                <input type="number" class="form-control" id="specialEmployeeId_${index}" name="specialSchedules[${index}].employeeId" required min="1" placeholder="Nhập ID nhân viên">
                                <div class="invalid-feedback">Vui lòng nhập ID nhân viên.</div>
                            </div>
                            <div class="col-md-6">
                                <label for="specialRole_${index}" class="form-label fw-bold">Vai Trò <span class="text-danger">*</span></label>
                                <select class="form-select" id="specialRole_${index}" name="specialSchedules[${index}].role" required>
                                    <option value="">Chọn vai trò</option>
                                    <option value="Doctor">Bác sĩ</option>
                                    <option value="Nurse">Y tá</option>
                                    <option value="Receptionist">Lễ tân</option>
                                </select>
                                <div class="invalid-feedback">Vui lòng chọn vai trò.</div>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="specialShiftStart_${index}" class="form-label fw-bold">Ca Bắt Đầu <span class="text-danger">*</span></label>
                                <input type="time" class="form-control" id="specialShiftStart_${index}" name="specialSchedules[${index}].shiftStart" value="08:00" required>
                                <div class="invalid-feedback">Vui lòng chọn giờ bắt đầu. Giờ kết thúc phải lớn hơn giờ bắt đầu.</div>
                            </div>
                            <div class="col-md-6">
                                <label for="specialShiftEnd_${index}" class="form-label fw-bold">Ca Kết Thúc <span class="text-danger">*</span></label>
                                <input type="time" class="form-control" id="specialShiftEnd_${index}" name="specialSchedules[${index}].shiftEnd" value="17:00" required>
                                <div class="invalid-feedback">Vui lòng chọn giờ kết thúc. Giờ kết thúc phải lớn hơn giờ bắt đầu.</div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Ngày Làm Việc: <span class="text-danger">*</span></label><br>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="checkbox" id="specialDay_${index}_mon" name="specialSchedules[${index}].days" value="Monday" checked>
                                <label class="form-check-label" for="specialDay_${index}_mon">T2</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="checkbox" id="specialDay_${index}_tue" name="specialSchedules[${index}].days" value="Tuesday" checked>
                                <label class="form-check-label" for="specialDay_${index}_tue">T3</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="checkbox" id="specialDay_${index}_wed" name="specialSchedules[${index}].days" value="Wednesday" checked>
                                <label class="form-check-label" for="specialDay_${index}_wed">T4</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="checkbox" id="specialDay_${index}_thu" name="specialSchedules[${index}].days" value="Thursday" checked>
                                <label class="form-check-label" for="specialDay_${index}_thu">T5</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="checkbox" id="specialDay_${index}_fri" name="specialSchedules[${index}].days" value="Friday" checked>
                                <label class="form-check-label" for="specialDay_${index}_fri">T6</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="checkbox" id="specialDay_${index}_sat" name="specialSchedules[${index}].days" value="Saturday" checked>
                                <label class="form-check-label" for="specialDay_${index}_sat">T7</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="checkbox" id="specialDay_${index}_sun" name="specialSchedules[${index}].days" value="Sunday">
                                <label class="form-check-label" for="specialDay_${index}_sun">CN</label>
                            </div>
                            <div class="invalid-feedback">Vui lòng chọn ít nhất một ngày làm việc.</div>
                        </div>
                    `;
                    specialSchedulesContainer.appendChild(div);

                    // Validation cho shiftStart và shiftEnd
                    const shiftStartInput = div.querySelector(`#specialShiftStart_${index}`);
                    const shiftEndInput = div.querySelector(`#specialShiftEnd_${index}`);
                    function validateTime() {
                        const startTime = shiftStartInput.value;
                        const endTime = shiftEndInput.value;
                        if (startTime && endTime && endTime <= startTime) {
                            shiftEndInput.classList.add('is-invalid');
                            shiftStartInput.classList.add('is-invalid');
                        } else {
                            shiftEndInput.classList.remove('is-invalid');
                            shiftStartInput.classList.remove('is-invalid');
                        }
                    }
                    shiftStartInput.addEventListener('change', validateTime);
                    shiftEndInput.addEventListener('change', validateTime);

                    div.querySelector('.remove-special-schedule').addEventListener('click', function () {
                        div.remove();
                    });
                }

                addSpecialScheduleBtn.addEventListener('click', addSpecialScheduleItem);

                // Form validation
                document.getElementById('autoScheduleForm').addEventListener('submit', function (e) {
                    const requiredFields = this.querySelectorAll('[required]');
                    let isValid = true;

                    requiredFields.forEach(field => {
                        if (!field.value) {
                            isValid = false;
                            field.classList.add('is-invalid');
                        } else {
                            field.classList.remove('is-invalid');
                        }
                    });

                    // Kiểm tra ít nhất một ngày được chọn trong special schedules
                    document.querySelectorAll('.special-schedule-item').forEach(item => {
                        const checkboxes = item.querySelectorAll('input[type="checkbox"][name$=".days"]');
                        let daySelected = false;
                        checkboxes.forEach(cb => {
                            if (cb.checked)
                                daySelected = true;
                        });
                        if (!daySelected) {
                            isValid = false;
                            item.querySelector('.invalid-feedback').style.display = 'block';
                        } else {
                            item.querySelector('.invalid-feedback').style.display = 'none';
                        }
                    });

                    // Kiểm tra shiftStart và shiftEnd trong special schedules
                    document.querySelectorAll('.special-schedule-item').forEach(item => {
                        const shiftStartInput = item.querySelector('input[name$=".shiftStart"]');
                        const shiftEndInput = item.querySelector('input[name$=".shiftEnd"]');
                        const startTime = shiftStartInput.value;
                        const endTime = shiftEndInput.value;
                        if (startTime && endTime && endTime <= startTime) {
                            isValid = false;
                            shiftEndInput.classList.add('is-invalid');
                            shiftStartInput.classList.add('is-invalid');
                        } else {
                            shiftEndInput.classList.remove('is-invalid');
                            shiftStartInput.classList.remove('is-invalid');
                        }
                    });

                    if (!isValid) {
                        e.preventDefault();
                    }
                });
            });
        </script>
    </body>
</html>
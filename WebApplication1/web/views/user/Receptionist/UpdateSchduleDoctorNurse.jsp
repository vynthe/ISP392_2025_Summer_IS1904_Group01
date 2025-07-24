<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cập Nhật Phân Công Nhân Viên</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Custom CSS -->
    <style>
        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .slot-info-card {
            border-left: 4px solid #007bff;
            background-color: #f8f9fa;
        }
        
        .appointment-warning {
            border-left: 4px solid #dc3545;
            background-color: #fff5f5;
        }
        
        .staff-list-item {
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .staff-list-item:hover {
            background-color: #e3f2fd;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        
        .staff-list-item.selected {
            background-color: #bbdefb;
            border: 2px solid #2196f3;
        }
        
        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 500;
        }
        
        .status-available {
            background-color: #d4edda;
            color: #155724;
        }
        
        .status-unavailable {
            background-color: #f8d7da;
            color: #721c24;
        }
        
        .loading {
            display: none;
        }
        
        .loading.show {
            display: block;
        }
        
        .fade-in {
            animation: fadeIn 0.5s ease-in;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .search-container {
            position: relative;
        }
        
        .search-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
        }
        
        .search-input {
            padding-left: 45px;
        }
    </style>
</head>
<body class="bg-light">
    <div class="container-fluid py-4">
        <div class="row">
            <div class="col-12">
                <div class="card shadow-sm">
                    <div class="card-header">
                        <h4 class="mb-0">
                            <i class="fas fa-user-edit me-2"></i>
                            Cập Nhật Phân Công Nhân Viên
                        </h4>
                    </div>
                    <div class="card-body">
                        <!-- Form tìm kiếm slot -->
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <div class="search-container">
                                    <i class="fas fa-search search-icon"></i>
                                    <input type="number" id="slotIdInput" class="form-control search-input" 
                                           placeholder="Nhập Slot ID để kiểm tra...">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <button type="button" id="checkSlotBtn" class="btn btn-primary">
                                    <i class="fas fa-search me-1"></i>
                                    Kiểm Tra Slot
                                </button>
                            </div>
                        </div>

                        <!-- Loading indicator -->
                        <div id="loadingIndicator" class="text-center loading">
                            <div class="spinner-border text-primary" role="status">
                                <span class="visually-hidden">Đang tải...</span>
                            </div>
                            <p class="mt-2">Đang xử lý...</p>
                        </div>

                        <!-- Thông tin slot -->
                        <div id="slotInfoSection" class="mb-4" style="display: none;">
                            <div class="card slot-info-card">
                                <div class="card-header bg-primary text-white">
                                    <h5 class="mb-0">
                                        <i class="fas fa-info-circle me-2"></i>
                                        Thông Tin Slot
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <p><strong>Slot ID:</strong> <span id="slotId"></span></p>
                                            <p><strong>Nhân viên hiện tại:</strong> <span id="currentStaff"></span></p>
                                            <p><strong>Vai trò:</strong> <span id="slotRole"></span></p>
                                        </div>
                                        <div class="col-md-6">
                                            <p><strong>Ngày:</strong> <span id="slotDate"></span></p>
                                            <p><strong>Thời gian:</strong> <span id="slotTime"></span></p>
                                            <p><strong>Phòng:</strong> <span id="slotRoom"></span></p>
                                        </div>
                                    </div>
                                    <div class="mt-3">
                                        <span id="slotStatus" class="status-badge"></span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Cảnh báo có appointment -->
                        <div id="appointmentWarning" class="alert alert-danger appointment-warning" style="display: none;">
                            <h5 class="alert-heading">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                Không thể thay đổi nhân viên
                            </h5>
                            <p id="warningMessage" class="mb-0"></p>
                            <hr>
                            <div id="appointmentDetails" class="mt-3">
                                <!-- Chi tiết appointment sẽ được hiển thị ở đây -->
                            </div>
                        </div>

                        <!-- Form cập nhật nhân viên -->
                        <div id="updateForm" style="display: none;">
                            <div class="card">
                                <div class="card-header bg-success text-white">
                                    <h5 class="mb-0">
                                        <i class="fas fa-users me-2"></i>
                                        Chọn Nhân Viên Thay Thế
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <!-- Danh sách nhân viên có thể thay thế -->
                                    <div id="availableStaffList" class="row">
                                        <!-- Danh sách nhân viên sẽ được load động -->
                                    </div>

                                    <!-- Form lý do thay đổi -->
                                    <div class="mt-4">
                                        <label for="changeReason" class="form-label">
                                            <strong>Lý do thay đổi: <span class="text-danger">*</span></strong>
                                        </label>
                                        <textarea id="changeReason" class="form-control" rows="3" 
                                                  placeholder="Nhập lý do thay đổi nhân viên..."></textarea>
                                        <div class="form-text">Vui lòng nhập lý do rõ ràng để thông báo cho nhân viên.</div>
                                    </div>

                                    <!-- Buttons -->
                                    <div class="mt-4 text-end">
                                        <button type="button" id="cancelBtn" class="btn btn-secondary me-2">
                                            <i class="fas fa-times me-1"></i>
                                            Hủy
                                        </button>
                                        <button type="button" id="updateBtn" class="btn btn-success" disabled>
                                            <i class="fas fa-save me-1"></i>
                                            Cập Nhật
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Success Modal -->
    <div class="modal fade" id="successModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title">
                        <i class="fas fa-check-circle me-2"></i>
                        Thành Công
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p id="successMessage"></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Error Modal -->
    <div class="modal fade" id="errorModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title">
                        <i class="fas fa-exclamation-circle me-2"></i>
                        Lỗi
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p id="errorMessage"></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-danger" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        let currentSlotId = null;
        let selectedStaffId = null;
        let availableStaff = [];

        // Event listeners
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('checkSlotBtn').addEventListener('click', checkSlotAvailability);
            document.getElementById('slotIdInput').addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    checkSlotAvailability();
                }
            });
            document.getElementById('updateBtn').addEventListener('click', updateStaffAssignment);
            document.getElementById('cancelBtn').addEventListener('click', resetForm);
            document.getElementById('changeReason').addEventListener('input', validateForm);
        });

        // Kiểm tra slot có thể thay đổi không
        async function checkSlotAvailability() {
            const slotId = document.getElementById('slotIdInput').value.trim();
            
            if (!slotId) {
                showError('Vui lòng nhập Slot ID');
                return;
            }

            showLoading(true);
            hideAllSections();

            try {
                const response = await fetch(`updateStaffAssignment?action=checkSlotAvailability&slotId=${slotId}`);
                const result = await response.json();

                if (result.success) {
                    currentSlotId = slotId;
                    displaySlotInfo(result.data);
                    
                    if (result.data.canChange) {
                        await loadAvailableStaff(slotId);
                        showUpdateForm();
                    } else {
                        showAppointmentWarning(result.data);
                    }
                } else {
                    showError(result.error || 'Lỗi khi kiểm tra slot');
                }
            } catch (error) {
                console.error('Error:', error);
                showError('Lỗi kết nối đến server');
            } finally {
                showLoading(false);
            }
        }

        // Hiển thị thông tin slot
        function displaySlotInfo(data) {
            const slotInfo = data.slotInfo;
            
            document.getElementById('slotId').textContent = slotInfo.slotId;
            document.getElementById('currentStaff').textContent = slotInfo.staffName || 'N/A';
            document.getElementById('slotRole').textContent = slotInfo.role;
            document.getElementById('slotDate').textContent = formatDate(slotInfo.slotDate);
            document.getElementById('slotTime').textContent = `${slotInfo.startTime} - ${slotInfo.endTime}`;
            document.getElementById('slotRoom').textContent = slotInfo.roomName || 'Chưa phân phòng';
            
            const statusElement = document.getElementById('slotStatus');
            if (data.canChange) {
                statusElement.textContent = 'Có thể thay đổi';
                statusElement.className = 'status-badge status-available';
            } else {
                statusElement.textContent = 'Không thể thay đổi';
                statusElement.className = 'status-badge status-unavailable';
            }
            
            document.getElementById('slotInfoSection').style.display = 'block';
            document.getElementById('slotInfoSection').classList.add('fade-in');
        }

        // Hiển thị cảnh báo có appointment
        function showAppointmentWarning(data) {
            document.getElementById('warningMessage').textContent = data.reason;
            
            if (data.appointmentInfo) {
                const appointmentInfo = data.appointmentInfo;
                const detailsHtml = `
                    <div class="row">
                        <div class="col-md-6">
                            <p><strong>Bệnh nhân:</strong> ${appointmentInfo.patientName}</p>
                            <p><strong>Số điện thoại:</strong> ${appointmentInfo.patientPhone}</p>
                        </div>
                        <div class="col-md-6">
                            <p><strong>Dịch vụ:</strong> ${appointmentInfo.serviceName}</p>
                            <p><strong>Giá:</strong> ${formatCurrency(appointmentInfo.servicePrice)}</p>
                        </div>
                    </div>
                `;
                document.getElementById('appointmentDetails').innerHTML = detailsHtml;
            }
            
            document.getElementById('appointmentWarning').style.display = 'block';
            document.getElementById('appointmentWarning').classList.add('fade-in');
        }

        // Load danh sách nhân viên có thể thay thế
        async function loadAvailableStaff(slotId) {
            try {
                const response = await fetch(`updateStaffAssignment?action=getAvailableStaff&slotId=${slotId}`);
                const result = await response.json();

                if (result.success) {
                    availableStaff = result.data;
                    displayAvailableStaff(result.data);
                } else {
                    showError(result.error || 'Lỗi khi tải danh sách nhân viên');
                }
            } catch (error) {
                console.error('Error:', error);
                showError('Lỗi kết nối đến server');
            }
        }

        // Hiển thị danh sách nhân viên có thể thay thế
        function displayAvailableStaff(staffList) {
            const container = document.getElementById('availableStaffList');
            
            if (staffList.length === 0) {
                container.innerHTML = `
                    <div class="col-12">
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle me-2"></i>
                            Không có nhân viên nào có thể thay thế trong thời gian này.
                        </div>
                    </div>
                `;
                return;
            }

            const staffHtml = staffList.map(staff => `
                <div class="col-md-6 col-lg-4 mb-3">
                    <div class="card staff-list-item" onclick="selectStaff(${staff.userId})">
                        <div class="card-body">
                            <h6 class="card-title">
                                <i class="fas fa-user-md me-2 text-primary"></i>
                                ${staff.fullName}
                            </h6>
                            <p class="card-text">
                                <small class="text-muted">
                                    <i class="fas fa-user-tag me-1"></i>
                                    ${staff.role}
                                </small>
                            </p>
                            ${staff.specialization ? `
                                <p class="card-text">
                                    <small class="text-info">
                                        <i class="fas fa-stethoscope me-1"></i>
                                        ${staff.specialization}
                                    </small>
                                </p>
                            ` : ''}
                        </div>
                    </div>
                </div>
            `).join('');

            container.innerHTML = staffHtml;
        }

        // Chọn nhân viên
        function selectStaff(staffId) {
            // Remove previous selection
            document.querySelectorAll('.staff-list-item').forEach(item => {
                item.classList.remove('selected');
            });

            // Add selection to clicked item
            event.currentTarget.classList.add('selected');
            selectedStaffId = staffId;
            
            validateForm();
        }

        // Validate form
        function validateForm() {
            const reason = document.getElementById('changeReason').value.trim();
            const updateBtn = document.getElementById('updateBtn');
            
            updateBtn.disabled = !(selectedStaffId && reason);
        }

        // Cập nhật phân công nhân viên
        async function updateStaffAssignment() {
            const reason = document.getElementById('changeReason').value.trim();
            
            if (!selectedStaffId || !reason) {
                showError('Vui lòng chọn nhân viên và nhập lý do thay đổi');
                return;
            }

            showLoading(true);

            try {
                const formData = new FormData();
                formData.append('slotId', currentSlotId);
                formData.append('newStaffId', selectedStaffId);
                formData.append('reason', reason);

                const response = await fetch('updateStaffAssignment', {
                    method: 'POST',
                    body: formData
                });

                const result = await response.json();

                if (result.success) {
                    showSuccess('Cập nhật phân công nhân viên thành công!');
                    resetForm();
                } else {
                    showError(result.error || 'Lỗi khi cập nhật phân công nhân viên');
                }
            } catch (error) {
                console.error('Error:', error);
                showError('Lỗi kết nối đến server');
            } finally {
                showLoading(false);
            }
        }

        // Reset form
        function resetForm() {
            currentSlotId = null;
            selectedStaffId = null;
            availableStaff = [];
            
            document.getElementById('slotIdInput').value = '';
            document.getElementById('changeReason').value = '';
            
            hideAllSections();
            validateForm();
        }

        // Utility functions
        function showLoading(show) {
            const loadingIndicator = document.getElementById('loadingIndicator');
            if (show) {
                loadingIndicator.classList.add('show');
            } else {
                loadingIndicator.classList.remove('show');
            }
        }

        function hideAllSections() {
            document.getElementById('slotInfoSection').style.display = 'none';
            document.getElementById('appointmentWarning').style.display = 'none';
            document.getElementById('updateForm').style.display = 'none';
        }

        function showUpdateForm() {
            document.getElementById('updateForm').style.display = 'block';
            document.getElementById('updateForm').classList.add('fade-in');
        }

        function showSuccess(message) {
            document.getElementById('successMessage').textContent = message;
            new bootstrap.Modal(document.getElementById('successModal')).show();
        }

        function showError(message) {
            document.getElementById('errorMessage').textContent = message;
            new bootstrap.Modal(document.getElementById('errorModal')).show();
        }

        function formatDate(dateString) {
            const date = new Date(dateString);
            return date.toLocaleDateString('vi-VN');
        }

        function formatCurrency(amount) {
            return new Intl.NumberFormat('vi-VN', {
                style: 'currency',
                currency: 'VND'
            }).format(amount);
        }
    </script>
</body>
</html>
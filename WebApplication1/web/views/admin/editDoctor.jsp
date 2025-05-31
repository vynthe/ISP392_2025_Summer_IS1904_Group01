<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sửa thông tin bác sĩ / y tá</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
    <h2 class="text-center mb-4">Sửa thông tin bác sĩ / y tá</h2>
    <c:if test="${not empty error}">
        <div class="alert alert-danger" role="alert">${error}</div>
    </c:if>
    <form action="${pageContext.request.contextPath}/updateEmployee" method="post">
        <input type="hidden" name="userID" value="${not empty formUserID ? formUserID : user.userID}">
        <div class="mb-3">
            <label for="fullName" class="form-label">Họ và tên</label>
            <input type="text" class="form-control" id="fullName" name="fullName" 
                   value="${not empty formFullName ? formFullName : user.fullName}" required>
            <div class="invalid-feedback">Vui lòng nhập họ và tên.</div>
        </div>
        <div class="mb-3">
            <label for="gender" class="form-label">Giới tính</label>
            <select class="form-select" id="gender" name="gender" required>
                <option value="Nam" ${formGender == 'Nam' || (empty formGender && user.gender == 'Nam') ? 'selected' : ''}>Nam</option>
                <option value="Nữ" ${formGender == 'Nữ' || (empty formGender && user.gender == 'Nữ') ? 'selected' : ''}>Nữ</option>
            </select>
            <div class="invalid-feedback">Vui lòng chọn giới tính.</div>
        </div>
        <div class="mb-3">
            <label for="specialization" class="form-label">Chuyên khoa</label>
            <select class="form-select" id="specialization" name="specialization" required>
                <option value="Chuyên môn" ${formSpecialization == 'Chuyên môn' || (empty formSpecialization && user.specialization == 'Chuyên môn') ? 'selected' : ''}>Chuyên môn</option>
                <option value="Thạc sĩ" ${formSpecialization == 'Thạc sĩ' || (empty formSpecialization && user.specialization == 'Thạc sĩ') ? 'selected' : ''}>Thạc sĩ</option>
                <option value="Tiến sĩ" ${formSpecialization == 'Tiến sĩ' || (empty formSpecialization && user.specialization == 'Tiến sĩ') ? 'selected' : ''}>Tiến sĩ</option>
            </select>
            <div class="invalid-feedback">Vui lòng chọn chuyên khoa.</div>
        </div>
        <div class="mb-3">
            <label for="dob" class="form-label">Ngày sinh</label>
            <input type="date" class="form-control" id="dob" name="dob" 
                   value="${not empty formDob ? formDob : (user.dob != null ? user.dob : '')}" required>
            <div class="invalid-feedback">Vui lòng nhập ngày sinh.</div>
        </div>
        <div class="mb-3">
            <label for="status" class="form-label">Trạng thái</label>
            <select class="form-select" id="status" name="status" required>
                <option value="Hoạt động" ${formStatus == 'Hoạt động' || (empty formStatus && user.status == 'Hoạt động') ? 'selected' : ''}>Hoạt động</option>
                <option value="Không hoạt động" ${formStatus == 'Không hoạt động' || (empty formStatus && user.status == 'Không hoạt động') ? 'selected' : ''}>Không hoạt động</option>
            </select>
            <div class="invalid-feedback">Vui lòng chọn trạng thái.</div>
        </div>
        <div class="d-flex justify-content-end">
            <a href="${pageContext.request.contextPath}/ViewEmployeeServlet" class="btn btn-secondary me-2">Hủy</a>
            <button type="submit" class="btn btn-primary">Lưu</button>
        </div>
    </form>
</div>
<script>
    (function () {
        'use strict';
        const forms = document.querySelectorAll('.needs-validation');
        Array.from(forms).forEach(form => {
            form.addEventListener('submit', event => {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                form.classList.add('was-validated');
            }, false);
        });
    })();
</script>
</body>
</html>
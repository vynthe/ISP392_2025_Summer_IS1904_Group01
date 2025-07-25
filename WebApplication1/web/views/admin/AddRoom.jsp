<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Phòng Mới - Hệ Thống Quản Lý Phòng Khám</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            padding: 20px;
            line-height: 1.6;
        }

        /* Breadcrumb Navigation */
        .breadcrumb {
            max-width: 800px;
            margin: 0 auto 20px;
            padding: 12px 20px;
            background: rgba(255, 255, 255, 0.9);
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
            backdrop-filter: blur(10px);
        }

        .breadcrumb a {
            color: #4f46e5;
            text-decoration: none;
            transition: color 0.2s;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .breadcrumb a:hover {
            color: #3730a3;
        }

        .breadcrumb span {
            color: #64748b;
        }

        .breadcrumb span:last-child {
            color: #1e293b;
            font-weight: 500;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        /* Enhanced Header */
        .header {
            background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
            padding: 40px 30px;
            text-align: center;
            color: white;
            position: relative;
            overflow: hidden;
        }

        .header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 20"><defs><radialGradient id="a" cx="50%" cy="0%" r="100%"><stop offset="0%" stop-color="white" stop-opacity="0.1"/><stop offset="100%" stop-color="white" stop-opacity="0"/></radialGradient></defs><rect width="100" height="20" fill="url(%23a)"/></svg>');
            opacity: 0.3;
        }

        .header-content {
            position: relative;
            z-index: 1;
        }

        .header h1 {
            font-size: 2.5em;
            margin-bottom: 12px;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .header h1 .icon-wrapper {
            background: rgba(255, 255, 255, 0.2);
            padding: 12px;
            border-radius: 50%;
            backdrop-filter: blur(10px);
        }

        .header h1 i {
            font-size: 0.8em;
        }

        .header .subtitle {
            font-size: 1.1em;
            opacity: 0.95;
            font-weight: 400;
            margin-bottom: 8px;
        }

        .header .description {
            font-size: 0.95em;
            opacity: 0.8;
            max-width: 500px;
            margin: 0 auto;
            line-height: 1.5;
        }

        /* Form Styling */
        .form-content {
            padding: 40px;
        }

        .form-header {
            text-align: center;
            margin-bottom: 35px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f1f5f9;
        }

        .form-title {
            font-size: 1.4em;
            color: #1e293b;
            font-weight: 600;
            margin-bottom: 8px;
        }

        .form-subtitle {
            color: #64748b;
            font-size: 1em;
        }

        .alert {
            padding: 16px 24px;
            border-radius: 12px;
            margin-bottom: 25px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 12px;
            border: 1px solid transparent;
        }

        .alert.error {
            background: linear-gradient(135deg, #fee2e2, #fecaca);
            color: #dc2626;
            border-color: #f87171;
        }

        .alert.success {
            background: linear-gradient(135deg, #dcfce7, #bbf7d0);
            color: #16a34a;
            border-color: #4ade80;
        }

        .alert i {
            font-size: 1.2em;
        }

        .form-group {
            margin-bottom: 28px;
            position: relative;
        }

        .form-group label {
            display: block;
            margin-bottom: 10px;
            font-weight: 600;
            color: #374151;
            font-size: 1.05em;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .form-group label i {
            color: #4f46e5;
            width: 18px;
            text-align: center;
        }

        .form-group label .required {
            color: #ef4444;
            margin-left: 4px;
        }

        .form-control {
            width: 100%;
            padding: 16px 20px;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            font-size: 16px;
            transition: all 0.3s ease;
            background: #fafafa;
            font-family: inherit;
        }

        .form-control:focus {
            outline: none;
            border-color: #4f46e5;
            background: #ffffff;
            box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1);
            transform: translateY(-1px);
        }

        .form-control:hover:not(:focus) {
            border-color: #d1d5db;
            background: #ffffff;
        }

        .form-control::placeholder {
            color: #9ca3af;
        }

        textarea.form-control {
            resize: vertical;
            min-height: 120px;
            font-family: inherit;
        }

        select.form-control {
            cursor: pointer;
            appearance: none;
            background-image: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="%23374151" stroke-width="2"><polyline points="6,9 12,15 18,9"/></svg>');
            background-repeat: no-repeat;
            background-position: right 16px center;
            background-size: 18px;
            padding-right: 50px;
        }

        .input-helper {
            font-size: 0.875em;
            color: #6b7280;
            margin-top: 6px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .input-helper i {
            font-size: 0.9em;
        }

        /* Status Options Styling */
        .status-option {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 8px 0;
        }

        .status-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            display: inline-block;
        }

        .status-available .status-dot { background-color: #22c55e; }
        .status-not-available .status-dot { background-color: #ef4444; }
        .status-in-progress .status-dot { background-color: #f59e0b; }
        .status-completed .status-dot { background-color: #3b82f6; }

        /* Button Styling */
        .button-group {
            display: flex;
            gap: 16px;
            justify-content: center;
            margin-top: 35px;
            padding-top: 25px;
            border-top: 2px solid #f1f5f9;
        }

        .btn {
            padding: 16px 32px;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            min-width: 160px;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s ease;
        }

        .btn:hover::before {
            left: 100%;
        }

        .btn-primary {
            background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
            color: white;
            box-shadow: 0 4px 16px rgba(79, 70, 229, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(79, 70, 229, 0.4);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #6b7280 0%, #4b5563 100%);
            color: white;
            box-shadow: 0 4px 16px rgba(107, 114, 128, 0.3);
        }

        .btn-secondary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(107, 114, 128, 0.4);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            body {
                padding: 10px;
            }

            .breadcrumb {
                margin: 0 auto 15px;
                padding: 10px 15px;
                font-size: 13px;
                flex-wrap: wrap;
            }

            .container {
                border-radius: 16px;
            }

            .header {
                padding: 30px 20px;
            }

            .header h1 {
                font-size: 2em;
                flex-direction: column;
                gap: 10px;
            }

            .header .subtitle {
                font-size: 1em;
            }

            .form-content {
                padding: 25px 20px;
            }

            .button-group {
                flex-direction: column;
                gap: 12px;
            }

            .btn {
                width: 100%;
                min-width: auto;
            }
        }

        @media (max-width: 480px) {
            .header h1 {
                font-size: 1.8em;
            }

            .form-content {
                padding: 20px 15px;
            }
        }
    </style>
</head>
<body>
    <!-- Breadcrumb Navigation -->
    <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp">
            <i class="fas fa-home"></i> Trang Chủ
        </a>
        <span>></span>
        <a href="${pageContext.request.contextPath}/ViewRoomServlet">Quản lý Phòng</a>
        <span>></span>
        <span>Thêm Phòng Mới</span>
    </div>

    <div class="container">
        <!-- Enhanced Header -->
        <div class="header">
            <div class="header-content">
                <h1>
                    <span class="icon-wrapper">
                        <i class="fas fa-plus-circle"></i>
                    </span>
                    Thêm Phòng Mới
                </h1>
                <p class="subtitle">Hệ Thống Quản Lý Phòng Khám</p>
                <p class="description">
                    Tạo mới phòng khám với thông tin chi tiết và trạng thái hoạt động
                </p>
            </div>
        </div>

        <div class="form-content">
            <!-- Form Header -->
            <div class="form-header">
                <h2 class="form-title">Thông Tin Phòng Khám</h2>
                <p class="form-subtitle">Vui lòng điền đầy đủ thông tin bên dưới</p>
            </div>

            <!-- Alert Messages -->
            <c:if test="${not empty error}">
                <div class="alert error">
                    <i class="fas fa-exclamation-triangle"></i>
                    <span>${error}</span>
                </div>
            </c:if>

            <c:if test="${not empty successMessage}">
                <div class="alert success">
                    <i class="fas fa-check-circle"></i>
                    <span>${successMessage}</span>
                </div>
            </c:if>

            <!-- Main Form -->
            <form action="${pageContext.request.contextPath}/AddRoomServlet" method="post">
                <input type="hidden" name="action" value="add">

                <div class="form-group">
                    <label for="roomName">
                        <i class="fas fa-door-open"></i>
                        Tên Phòng
                        <span class="required">*</span>
                    </label>
                    <input type="text" id="roomName" name="roomName" value="${roomName}" 
                           class="form-control" placeholder="Ví dụ: Phòng Khám Tổng Quát 01" required>
                    <div class="input-helper">
                        <i class="fas fa-info-circle"></i>
                        Nhập tên phòng rõ ràng và dễ nhận biết
                    </div>
                </div>

                <div class="form-group">
                    <label for="description">
                        <i class="fas fa-file-alt"></i>
                        Mô Tả Chi Tiết
                    </label>
                    <textarea id="description" name="description" class="form-control" 
                              placeholder="Mô tả về chức năng, thiết bị, và mục đích sử dụng của phòng...">${description}</textarea>
                    <div class="input-helper">
                        <i class="fas fa-lightbulb"></i>
                        Thông tin này giúp nhân viên hiểu rõ hơn về phòng
                    </div>
                </div>

                <div class="form-group">
                    <label for="status">
                        <i class="fas fa-info-circle"></i>
                        Trạng Thái Hoạt Động
                        <span class="required">*</span>
                    </label>
                    <select id="status" name="status" class="form-control" required>
                        <option value="Available" ${status == 'Available' ? 'selected' : ''}>
                            ✅ Có Sẵn - Sẵn sàng sử dụng
                        </option>
                        <option value="Not Available" ${status == 'Not Available' ? 'selected' : ''}>
                            ❌ Không Có Sẵn - Tạm thời không sử dụng được
                        </option>
                        <option value="In Progress" ${status == 'In Progress' ? 'selected' : ''}>
                            🔄 Đang Tiến Hành - Đang có bệnh nhân
                        </option>
                        <option value="Completed" ${status == 'Completed' ? 'selected' : ''}>
                            ✔️ Hoàn Thành - Đã hoàn thành công việc
                        </option>
                    </select>
                    <div class="input-helper">
                        <i class="fas fa-clock"></i>
                        Trạng thái có thể được thay đổi sau khi tạo phòng
                    </div>
                </div>

                <div class="button-group">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-plus"></i>
                        Tạo Phòng Mới
                    </button>
                    <a href="${pageContext.request.contextPath}/ViewRoomServlet" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i>
                        Quay Lại
                    </a>
                </div>
            </form>
        </div>
    </div>

    <div style="height: 50px;"></div>
    <jsp:include page="/assets/footer.jsp" />
</body>
</html>
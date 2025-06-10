<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Phòng</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
        }

        .header {
            text-align: center;
            margin-bottom: 40px;
        }

        .header h1 {
            color: #2c3e50;
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 10px;
            background: linear-gradient(45deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .header p {
            color: #7f8c8d;
            font-size: 1.1rem;
        }

        .search-section {
            background: white;
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
            border: 1px solid #e8f4fd;
        }

        .search-container {
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
            justify-content: center;
        }

        .search-input {
            flex: 1;
            min-width: 300px;
            padding: 12px 20px;
            border: 2px solid #e3f2fd;
            border-radius: 25px;
            font-size: 16px;
            transition: all 0.3s ease;
            background: #f8fffe;
        }

        .search-input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            transform: translateY(-2px);
        }

        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 25px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-search {
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
        }

        .btn-add {
            background: linear-gradient(45deg, #56ab2f, #a8e6cf);
            color: white;
        }

        .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
        }

        .table-container {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
            border: 1px solid #e8f4fd;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
        }

        .table th {
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
            padding: 18px 15px;
            text-align: left;
            font-weight: 600;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .table td {
            padding: 15px;
            border-bottom: 1px solid #f1f3f4;
            vertical-align: middle;
        }

        .table tbody tr {
            transition: all 0.3s ease;
        }

        .table tbody tr:hover {
            background: linear-gradient(90deg, #f8f9ff, #ffffff);
            transform: scale(1.01);
        }

        .table tbody tr:nth-child(even) {
            background: #fafbff;
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-active {
            background: #d4edda;
            color: #155724;
        }

        .status-inactive {
            background: #f8d7da;
            color: #721c24;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .btn-action {
            padding: 8px 12px;
            border: none;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .btn-view {
            background: linear-gradient(45deg, #17a2b8, #20c997);
            color: white;
        }

        .btn-edit {
            background: linear-gradient(45deg, #ffc107, #fd7e14);
            color: white;
        }

        .btn-delete {
            background: linear-gradient(45deg, #dc3545, #e83e8c);
            color: white;
        }

        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }

        .empty-state {
            text-align: center;
            padding: 50px 20px;
            color: #7f8c8d;
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 20px;
            opacity: 0.5;
        }

        @media (max-width: 768px) {
            .container {
                padding: 20px;
                margin: 10px;
            }

            .header h1 {
                font-size: 2rem;
            }

            .search-container {
                flex-direction: column;
            }

            .search-input {
                min-width: 100%;
            }

            .table-container {
                overflow-x: auto;
            }

            .table {
                min-width: 800px;
            }

            .action-buttons {
                flex-direction: column;
                gap: 5px;
            }
        }

        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
            border-left: 4px solid #667eea;
            transition: all 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.15);
        }

        .stat-card h3 {
            color: #2c3e50;
            font-size: 1.8rem;
            margin-bottom: 5px;
        }

        .stat-card p {
            color: #7f8c8d;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-door-open"></i> Quản lý Phòng</h1>
            <p>Hệ thống quản lý phòng bệnh viện</p>
        </div>

       
        <!-- Khu vực tìm kiếm -->
        <div class="search-section">
            <form class="search-container" method="get" action="${pageContext.request.contextPath}/SearchRoomServlet">
                <input type="text" 
                       name="keyword" 
                       class="search-input"
                       placeholder="🔍 Tìm kiếm theo tên phòng, mã phòng..." 
                       value="${param.keyword}">
                <button type="submit" class="btn btn-search">
                    <i class="fas fa-search"></i> Tìm kiếm
                </button>
                <a href="${pageContext.request.contextPath}/views/admin/AddRoom.jsp" class="btn btn-add">
                    <i class="fas fa-plus"></i> Thêm Phòng
                </a>
            </form>
        </div>

        <!-- Bảng danh sách phòng -->
        <div class="table-container">
            <c:choose>
                <c:when test="${not empty roomList}">
                    <table class="table">
                        <thead>
                            <tr>
                                <th><i class="fas fa-hashtag"></i> Mã Phòng</th>
                                <th><i class="fas fa-door-open"></i> Tên Phòng</th>
                                <th><i class="fas fa-info-circle"></i> Mô Tả</th>
                                <th><i class="fas fa-user-md"></i> Bác Sĩ</th>
                                <th><i class="fas fa-user-nurse"></i> Y Tá</th>
                                <th><i class="fas fa-toggle-on"></i> Trạng Thái</th>
                                <th><i class="fas fa-user"></i> Người Tạo</th>
                                <th><i class="fas fa-cogs"></i> Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="room" items="${roomList}">
                                <tr>
                                    <td><strong>${room.roomID}</strong></td>
                                    <td>${room.roomName}</td>
                                    <td>${room.description}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty room.doctorID}">
                                                <i class="fas fa-user-md"></i> ${room.doctorID}
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #6c757d;">Chưa phân công</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty room.nurseID}">
                                                <i class="fas fa-user-nurse"></i> ${room.nurseID}
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #6c757d;">Chưa phân công</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${room.status == 'Active' || room.status == 'Hoạt động'}">
                                                <span class="status-badge status-active">
                                                    <i class="fas fa-check-circle"></i> Hoạt động
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-inactive">
                                                    <i class="fas fa-times-circle"></i> Không hoạt động
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <i class="fas fa-user"></i> ${room.createdBy}
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <a href="${pageContext.request.contextPath}/ViewRoomDetailServlet?id=${room.roomID}" 
                                               class="btn-action btn-view" 
                                               title="Xem chi tiết">
                                                <i class="fas fa-eye"></i> Xem
                                            </a>
                                            <a href="${pageContext.request.contextPath}/UpdateRoomServlet?id=${room.roomID}" 
                                               class="btn-action btn-edit"
                                               title="Chỉnh sửa">
                                                <i class="fas fa-edit"></i> Sửa
                                            </a>
                                            <a href="${pageContext.request.contextPath}/DeleteRoomServlet?id=${room.roomID}" 
                                               class="btn-action btn-delete"
                                               title="Xóa phòng"
                                               onclick="return confirm('Bạn có chắc chắn muốn xóa phòng này không?');">
                                                <i class="fas fa-trash-alt"></i> Xóa
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-inbox"></i>
                        <h3>Không có dữ liệu</h3>
                        <p>Hiện tại không có phòng nào trong hệ thống.</p>
                        <a href="${pageContext.request.contextPath}/views/admin/AddRoom.jsp" class="btn btn-add" style="margin-top: 20px;">
                            <i class="fas fa-plus"></i> Thêm Phòng Đầu Tiên
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script>
        // Thêm hiệu ứng loading khi submit form
        document.querySelector('form').addEventListener('submit', function() {
            const submitBtn = this.querySelector('button[type="submit"]');
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang tìm...';
        });

        // Thêm hiệu ứng hover cho các hàng trong bảng
        document.querySelectorAll('.table tbody tr').forEach(row => {
            row.addEventListener('mouseenter', function() {
                this.style.transform = 'scale(1.01)';
            });
            
            row.addEventListener('mouseleave', function() {
                this.style.transform = 'scale(1)';
            });
        });

        // Confirm delete với style đẹp hơn
        document.querySelectorAll('.btn-delete').forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                if (confirm('⚠️ Bạn có chắc chắn muốn xóa phòng này không?\n\nHành động này không thể hoàn tác!')) {
                    window.location.href = this.href;
                }
            });
        });
    </script>
</body>
</html>
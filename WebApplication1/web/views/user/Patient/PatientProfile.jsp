<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="model.entity.Users" %>

<%
    // Giả sử user profile đã được lưu trong request hoặc session attribute là "userProfile"
    Users user = (Users) request.getAttribute("userProfile");
    if (user == null) {
        out.println("<h3>Không tìm thấy thông tin người dùng!</h3>");
        return;
    }
    request.setAttribute("user", user); // gán biến 'user' để EL truy cập
%>

<html>
<head>
    <title>Patient Profile</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            font-family: 'Inter', sans-serif;
        }
        .profile-container {
            max-width: 600px;
            margin: 2rem auto;
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            padding: 2rem;
        }
        .profile-field {
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
            padding: 0.5rem 0;
            border-bottom: 1px solid #e5e7eb;
        }
        .profile-field label {
            font-weight: 600;
            width: 150px;
            color: #374151;
        }
        .profile-field span {
            color: #1f2937;
            flex: 1;
        }
        h2 {
            color: #1f2937;
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            text-align: center;
        }
        @media (max-width: 640px) {
            .profile-field {
                flex-direction: column;
                align-items: flex-start;
            }
            .profile-field label {
                width: 100%;
                margin-bottom: 0.25rem;
            }
        }
    </style>
</head>
<body class="bg-gray-100">
    <div class="profile-container">
        <h2>Thông tin Bệnh Nhân</h2>
        <div class="profile-field">
            <label>User ID:</label> <span><c:out value="${user.userID}"/></span>
        </div>
        <div class="profile-field">
            <label>Username:</label> <span><c:out value="${user.username}"/></span>
        </div>
        <div class="profile-field">
            <label>Full Name:</label> <span><c:out value="${user.fullName}"/></span>
        </div>
        <div class="profile-field">
            <label>Email:</label> <span><c:out value="${user.email}"/></span>
        </div>
        <div class="profile-field">
            <label>Date of Birth:</label> <span><c:out value="${user.dob}"/></span>
        </div>
        <div class="profile-field">
            <label>Gender:</label> <span><c:out value="${user.gender}"/></span>
        </div>
        <div class="profile-field">
            <label>Phone:</label> <span><c:out value="${user.phone}"/></span>
        </div>
        <div class="profile-field">
            <label>Address:</label> <span><c:out value="${user.address}"/></span>
        </div>
       
        <!-- Phần chuyên môn, nếu bệnh nhân có thì để trống hoặc ẩn -->
        <c:if test="${not empty user.specialization}">
            <div class="profile-field">
                <label>Specialization:</label> <span><c:out value="${user.specialization}"/></span>
            </div>
        </c:if>
        <div class="mt-6 text-center">
        <a href="${pageContext.request.contextPath}/views/user/Patient/PatientDashBoard.jsp">
            <button class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition duration-200">
               Quay lại trang chủ
            </button>
        </a>
    </div>
    </div>
    
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thời khóa biểu</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        
        .header {
            background-color: #4a90e2;
            color: white;
            padding: 10px;
            text-align: center;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        
        .controls {
            margin-bottom: 20px;
            display: flex;
            gap: 10px;
            align-items: center;
        }
        
        .controls label {
            font-weight: bold;
            color: #333;
        }
        
        .controls select {
            padding: 5px;
            border: 1px solid #ccc;
            border-radius: 3px;
        }
        
        .schedule-table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .schedule-table th {
            background-color: #4a90e2;
            color: white;
            padding: 10px;
            text-align: center;
            font-weight: bold;
            border: 1px solid #ddd;
        }
        
        .schedule-table td {
            padding: 8px;
            border: 1px solid #ddd;
            vertical-align: top;
            min-height: 60px;
        }
        
        .slot-header {
            background-color: #e8f4f8;
            font-weight: bold;
            text-align: center;
            width: 80px;
        }
        
        .course-info {
            margin-bottom: 5px;
            font-size: 12px;
        }
        
        .course-code {
            font-weight: bold;
            color: #333;
        }
        
        .course-location {
            color: #666;
            font-size: 11px;
        }
        
        .course-status {
            display: inline-block;
            padding: 2px 6px;
            border-radius: 3px;
            font-size: 10px;
            margin: 2px;
            cursor: pointer;
        }
        
        .attended {
            background-color: #90EE90;
            color: #006400;
        }
        
        .not-yet {
            background-color: #FFE4B5;
            color: #FF8C00;
        }
        
        .change-room {
            background-color: #FFB6C1;
            color: #8B0000;
        }
        
        .view-materials {
            background-color: #FFA500;
            color: white;
        }
        
        .eduNext {
            background-color: #4169E1;
            color: white;
        }
        
        .time-slot {
            background-color: #87CEEB;
            color: #000080;
        }
        
        .meet-url {
            background-color: #32CD32;
            color: white;
        }
        
        .empty-cell {
            text-align: center;
            color: #999;
            font-style: italic;
        }
        
        .day-header {
            position: relative;
        }
        
        .date-number {
            font-size: 18px;
            font-weight: bold;
        }
        
        .course-cell:hover {
            background-color: #f0f8ff;
        }
    </style>
</head>
<body>
    <%-- Khởi tạo dữ liệu mẫu --%>
    <c:set var="currentYear" value="2025" />
    <c:set var="currentWeek" value="22/09 to 28/09" />
    
    <div class="header">
        <h2>Nhà vở số 3 (Ký hiệu VUV3 - cạnh hồ Delta) gồm 4 sàn tập: R01-VUV3 đến R04-VUV3</h2>
    </div>
    
    <form action="schedule.jsp" method="get">
        <div class="controls">
            <label for="year">YEAR:</label>
            <select id="year" name="year" onchange="this.form.submit()">
                <option value="2025" ${param.year == '2025' || empty param.year ? 'selected' : ''}>2025</option>
                <option value="2024" ${param.year == '2024' ? 'selected' : ''}>2024</option>
                <option value="2023" ${param.year == '2023' ? 'selected' : ''}>2023</option>
            </select>
            
            <label for="week">WEEK:</label>
            <select id="week" name="week" onchange="this.form.submit()">
                <option value="22/09 to 28/09" ${param.week == '22/09 to 28/09' || empty param.week ? 'selected' : ''}>22/09 to 28/09</option>
                <option value="15/09 to 21/09" ${param.week == '15/09 to 21/09' ? 'selected' : ''}>15/09 to 21/09</option>
                <option value="29/09 to 05/10" ${param.week == '29/09 to 05/10' ? 'selected' : ''}>29/09 to 05/10</option>
                <option value="06/10 to 12/10" ${param.week == '06/10 to 12/10' ? 'selected' : ''}>06/10 to 12/10</option>
            </select>
        </div>
    </form>
    
    <table class="schedule-table">
        <thead>
            <tr>
                <th></th>
                <th class="day-header">
                    <div>MON</div>
                    <div class="date-number">14/07</div>
                </th>
                <th class="day-header">
                    <div>TUE</div>
                    <div class="date-number">15/07</div>
                </th>
                <th class="day-header">
                    <div>WED</div>
                    <div class="date-number">16/07</div>
                </th>
                <th class="day-header">
                    <div>THU</div>
                    <div class="date-number">17/07</div>
                </th>
                <th class="day-header">
                    <div>FRI</div>
                    <div class="date-number">18/07</div>
                </th>
                <th class="day-header">
                    <div>SAT</div>
                    <div class="date-number">19/07</div>
                </th>
                <th class="day-header">
                    <div>SUN</div>
                    <div class="date-number">20/07</div>
                </th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td class="slot-header">Slot 0</td>
                <td class="empty-cell">-</td>
                <td class="empty-cell">-</td>
                <td class="empty-cell">-</td>
                <td class="empty-cell">-</td>
                <td class="empty-cell">-</td>
                <td class="empty-cell">-</td>
                <td class="empty-cell">-</td>
            </tr>
            <tr>
                <td class="slot-header">Slot 1</td>
                <td class="course-cell">
                    <div class="course-info">
                        <span class="course-code">FIN202</span>
                        <span class="course-status view-materials" onclick="viewMaterials('FIN202')">View Materials</span>
                        <br>
                        <span class="course-location">at BE-410</span>
                        <br>
                        <span class="course-status attended">(attended)</span>
                        <span class="course-status time-slot">(7:30-9:50)</span>
                    </div>
                </td>
                <td class="course-cell">
                    <div class="course-info">
                        <span class="course-code">ISP392</span>
                        <span class="course-status view-materials" onclick="viewMaterials('ISP392')">View Materials</span>
                        <br>
                        <span class="course-location">at DE-412</span>
                        <br>
                        <span class="course-status change-room">(_ChangeRoom_)</span>
                        <span class="course-status time-slot">(7:30-9:50)</span>
                        <span class="course-status eduNext" onclick="openEduNext('ISP392')">-EduNext</span>
                        <br>
                        <span class="course-status attended">(attended)</span>
                        <span class="course-status time-slot">(7:30-9:50)</span>
                    </div>
                </td>
                <td class="course-cell">
                    <div class="course-info">
                        <span class="course-code">ISM302</span>
                        <span class="course-status view-materials" onclick="viewMaterials('ISM302')">View Materials</span>
                        <br>
                        <span class="course-location">at BE-410</span>
                        <br>
                        <span class="course-status attended">(attended)</span>
                        <span class="course-status time-slot">(7:30-9:50)</span>
                    </div>
                </td>
                <td class="course-cell">
                    <div class="course-info">
                        <span class="course-code">ITA301</span>
                        <span class="course-status view-materials" onclick="viewMaterials('ITA301')">View Materials</span>
                        <br>
                        <span class="course-location">at EP-303</span>
                        <br>
                        <span class="course-status change-room">(_ChangeRoom_)</span>
                        <span class="course-status time-slot">(7:30-9:50)</span>
                        <span class="course-status eduNext" onclick="openEduNext('ITA301')">-EduNext</span>
                        <br>
                        <span class="course-status not-yet">(Not yet)</span>
                        <span class="course-status time-slot">(7:30-9:50)</span>
                    </div>
                </td>
                <td class="empty-cell">-</td>
                <td class="empty-cell">-</td>
                <td class="empty-cell">-</td>
            </tr>
            <tr>
                <td class="slot-header">Slot 2</td>
                <td class="course-cell">
                    <div class="course-info">
                        <span class="course-code">ISM302</span>
                        <span class="course-status view-materials" onclick="viewMaterials('ISM302')">View Materials</span>
                        <br>
                        <span class="course-location">at BE-410</span>
                        <br>
                        <span class="course-status attended">(attended)</span>
                        <span class="course-status time-slot">(10:00-12:20)</span>
                    </div>
                </td>
                <td class="course-cell">
                    <div class="course-info">
                        <span class="course-code">ITA301</span>
                        <span class="course-status view-materials" onclick="viewMaterials('ITA301')">View Materials</span>
                        <br>
                        <span class="course-location">at EP-303</span>
                        <br>
                        <span class="course-status change-room">(_ChangeRoom_)</span>
                        <span class="course-status time-slot">(10:00-12:20)</span>
                        <span class="course-status eduNext" onclick="openEduNext('ITA301')">-EduNext</span>
                        <br>
                        <span class="course-status attended">(attended)</span>
                        <span class="course-status time-slot">(10:00-12:20)</span>
                    </div>
                </td>
                <td class="course-cell">
                    <div class="course-info">
                        <span class="course-code">FIN202</span>
                        <span class="course-status view-materials" onclick="viewMaterials('FIN202')">View Materials</span>
                        <br>
                        <span class="course-location">at BE-410</span>
                        <br>
                        <span class="course-status attended">(attended)</span>
                        <span class="course-status time-slot">(10:00-12:20)</span>
                    </div>
                </td>
                <td class="course-cell">
                    <div class="course-info">
                        <span class="course-code">ISP392</span>
                        <span class="course-status view-materials" onclick="viewMaterials('ISP392')">View Materials</span>
                        <br>
                        <span class="course-location">at DE-423</span>
                        <br>
                        <span class="course-status change-room">(_ChangeRoom_)</span>
                        <span class="course-status time-slot">(10:00-12:20)</span>
                        <span class="course-status meet-url" onclick="openMeetUrl('ISP392')">Meet URL</span>
                        <span class="course-status eduNext" onclick="openEduNext('ISP392')">-EduNext</span>
                        <br>
                        <span class="course-status not-yet">(Not yet)</span>
                        <span class="course-status time-slot">(10:00-12:20)</span>
                    </div>
                </td>
                <td class="empty-cell">-</td>
                <td class="empty-cell">-</td>
                <td class="empty-cell">-</td>
            </tr>
            <tr>
                <td class="slot-header">Slot 3</td>
                <td class="empty-cell">-</td>
                <td class="empty-cell">-</td>
                <td class="empty-cell">-</td>
                <td class="empty-cell">-</td>
                <td class="empty-cell">-</td>
                <td class="empty-cell">-</td>
                <td class="empty-cell">-</td>
            </tr>
            <tr>
                <td class="slot-header">Slot 4</td>
                <td class="empty-cell">-</td>
                <td class="empty-cell">-</td>
                <td class="empty-cell">-</td>
                <td class="empty-cell">-</td>
                <td class="empty-cell">-</td>
                <td class="empty-cell">-</td>
                <td class="empty-cell">-</td>
            </tr>
        </tbody>
    </table>
    
    <script>
        // Các hàm JavaScript cho tương tác
        function viewMaterials(courseCode) {
            alert('Xem tài liệu cho môn: ' + courseCode);
            // Có thể redirect đến trang xem tài liệu
            // window.location.href = 'materials.jsp?courseCode=' + courseCode;
        }
        
        function openEduNext(courseCode) {
            alert('Mở EduNext cho môn: ' + courseCode);
            // Có thể mở tab mới với EduNext
            // window.open('https://edunext.fpt.edu.vn/course/' + courseCode, '_blank');
        }
        
        function openMeetUrl(courseCode) {
            alert('Mở Meet URL cho môn: ' + courseCode);
            // Có thể mở tab mới với link Meet
            // window.open('https://meet.google.com/xxx-xxx-xxx', '_blank');
        }
        
        // Hiển thị thông tin đã chọn
        <c:if test="${not empty param.year or not empty param.week}">
            console.log('Selected Year: ${param.year}');
            console.log('Selected Week: ${param.week}');
        </c:if>
    </script>
</body>
</html>
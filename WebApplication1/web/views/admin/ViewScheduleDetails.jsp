<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Tuần</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }
        
        .header {
            display: flex;
            gap: 10px;
            margin-bottom: 10px;
            align-items: center;
        }
        
        .header select {
            padding: 2px 5px;
            border: 1px solid #ccc;
            background-color: white;
        }
        
        .header label {
            font-weight: bold;
            color: #333;
        }
        
        .schedule-table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .schedule-table th, .schedule-table td {
            border: 1px solid #ccc;
            padding: 8px;
            text-align: left;
            vertical-align: top;
            min-height: 80px;
        }
        
        .schedule-table th {
            background-color: #e6f3ff;
            font-weight: bold;
            text-align: center;
        }
        
        .day-header {
            background-color: #b3d9ff;
            color: #333;
            font-weight: bold;
        }
        
        .slot-cell {
            background-color: #f0f8ff;
            font-weight: bold;
            text-align: center;
            width: 60px;
        }
        
        .class-item {
            margin-bottom: 8px;
            padding: 4px;
            border-radius: 4px;
            font-size: 12px;
        }
        
        .class-code {
            background-color: #ffa500;
            color: white;
            padding: 2px 4px;
            border-radius: 2px;
            font-weight: bold;
            display: inline-block;
            margin-bottom: 2px;
        }
        
        .class-details {
            margin-top: 2px;
            font-size: 11px;
        }
        
        .room-info {
            color: #666;
            font-size: 11px;
        }
        
        .status-attended {
            background-color: #90EE90;
            color: #006400;
            padding: 1px 3px;
            border-radius: 2px;
            font-size: 10px;
        }
        
        .status-time {
            background-color: #87CEEB;
            color: #004080;
            padding: 1px 3px;
            border-radius: 2px;
            font-size: 10px;
            margin-left: 5px;
        }
        
        .eduNext {
            background-color: #4CAF50;
            color: white;
            padding: 1px 3px;
            border-radius: 2px;
            font-size: 10px;
            margin-left: 5px;
        }
        
        .week-select {
            background-color: #b3d9ff;
        }
        
        .year-select {
            background-color: #b3d9ff;
        }
    </style>
</head>
<body>
    <div class="header">
        <label>YEAR</label>
        <select class="year-select" name="year">
            <option value="2025" selected>2025</option>
            <option value="2024">2024</option>
            <option value="2026">2026</option>
        </select>
        <label>WEEK</label>
        <select class="week-select" name="week">
            <option value="23/06 To 29/06" selected>23/06 To 29/06</option>
            <option value="16/06 To 22/06">16/06 To 22/06</option>
            <option value="30/06 To 06/07">30/06 To 06/07</option>
        </select>
    </div>
    
    <table class="schedule-table">
        <thead>
            <tr>
                <th></th>
                <th class="day-header">MON<br>23/06</th>
                <th class="day-header">TUE<br>24/06</th>
                <th class="day-header">WED<br>25/06</th>
                <th class="day-header">THU<br>26/06</th>
                <th class="day-header">FRI<br>27/06</th>
                <th class="day-header">SAT<br>28/06</th>
                <th class="day-header">SUN<br>29/06</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td class="slot-cell">Slot 0</td>
                <td>-</td>
                <td>-</td>
                <td>-</td>
                <td>-</td>
                <td>-</td>
                <td>-</td>
                <td>-</td>
            </tr>
            <tr>
                <td class="slot-cell">Slot 1</td>
                <td>
                    <div class="class-item">
                        <span class="class-code">FIN202</span>
                        <span class="class-code">New Materials</span>
                        <div class="class-details">
                            at BE-410 <span class="eduNext">EduNext</span>
                        </div>
                        <div class="status-attended">(attended)</div>
                        <div class="status-time">(7:30-9:50)</div>
                    </div>
                </td>
                <td>
                    <div class="class-item">
                        <span class="class-code">ISP392</span>
                        <span class="class-code">New Materials</span>
                        <div class="class-details">
                            at DE-412
                        </div>
                        <div class="room-info">(_ChangeRoom_)</div>
                        <div class="status-time">(7:30-9:50)</div>
                        <div class="eduNext">EduNext</div>
                        <div class="status-attended">(attended)</div>
                        <div class="status-time">(7:30-9:50)</div>
                    </div>
                </td>
                <td>-</td>
                <td>
                    <div class="class-item">
                        <span class="class-code">ISM302</span>
                        <span class="class-code">New Materials</span>
                        <div class="class-details">
                            at BE-410
                        </div>
                        <div class="status-attended">(attended)</div>
                        <div class="status-time">(7:30-9:50)</div>
                    </div>
                </td>
                <td>
                    <div class="class-item">
                        <span class="class-code">ITA301</span>
                        <span class="class-code">New Materials</span>
                        <div class="class-details">
                            at EP-303
                        </div>
                        <div class="room-info">(_ChangeRoom)</div>
                        <div class="status-time">(7:30-9:50)</div>
                        <div class="eduNext">EduNext</div>
                        <div class="status-attended">(attended)</div>
                        <div class="status-time">(7:30-9:50)</div>
                    </div>
                </td>
                <td>-</td>
                <td>-</td>
            </tr>
            <tr>
                <td class="slot-cell">Slot 2</td>
                <td>
                    <div class="class-item">
                        <span class="class-code">ISM302</span>
                        <span class="class-code">New Materials</span>
                        <div class="class-details">
                            at BE-410
                        </div>
                        <div class="status-attended">(attended)</div>
                        <div class="status-time">(10:00-12:20)</div>
                    </div>
                </td>
                <td>
                    <div class="class-item">
                        <span class="class-code">ITA301</span>
                        <span class="class-code">New Materials</span>
                        <div class="class-details">
                            at EP-303
                        </div>
                        <div class="room-info">(_ChangeRoom)</div>
                        <div class="status-time">(10:00-12:20)</div>
                        <div class="eduNext">EduNext</div>
                        <div class="status-attended">(attended)</div>
                        <div class="status-time">(10:00-12:20)</div>
                    </div>
                </td>
                <td>-</td>
                <td>
                    <div class="class-item">
                        <span class="class-code">FIN202</span>
                        <span class="class-code">New Materials</span>
                        <div class="class-details">
                            at BE-410 <span class="eduNext">EduNext</span>
                        </div>
                        <div class="status-attended">(attended)</div>
                        <div class="status-time">(10:00-12:20)</div>
                    </div>
                </td>
                <td>
                    <div class="class-item">
                        <span class="class-code">ISP392</span>
                        <span class="class-code">New Materials</span>
                        <div class="class-details">
                            at DE-423
                        </div>
                        <div class="room-info">(_ChangeRoom_)</div>
                        <div class="status-time">(10:00-12:20)</div>
                        <div class="eduNext">EduNext</div>
                        <div class="status-attended">(attended)</div>
                        <div class="status-time">(10:00-12:20)</div>
                    </div>
                </td>
                <td>-</td>
                <td>-</td>
            </tr>
            <tr>
                <td class="slot-cell">Slot 3</td>
                <td>-</td>
                <td>-</td>
                <td>-</td>
                <td>-</td>
                <td>-</td>
                <td>-</td>
                <td>-</td>
            </tr>
        </tbody>
    </table>

    <script>
        // Xử lý sự kiện thay đổi năm
        document.querySelector('.year-select').addEventListener('change', function() {
            // Có thể gửi Ajax request hoặc reload page
            console.log('Year changed to: ' + this.value);
        });
        
        // Xử lý sự kiện thay đổi tuần
        document.querySelector('.week-select').addEventListener('change', function() {
            // Có thể gửi Ajax request hoặc reload page
            console.log('Week changed to: ' + this.value);
        });
    </script>
</body>
</html>
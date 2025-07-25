<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chỉnh sửa ghi chú đơn thuốc</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                padding: 30px;
            }
            .form-container {
                max-width: 600px;
                margin: auto;
                padding: 24px;
                border: 1px solid #ccc;
                border-radius: 12px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
            textarea {
                width: 100%;
                min-height: 120px;
                padding: 10px;
                font-size: 14px;
                border-radius: 6px;
            }
            .btn {
                padding: 10px 20px;
                font-size: 15px;
                border: none;
                border-radius: 6px;
                background-color: #4CAF50;
                color: white;
                cursor: pointer;
            }
            .btn:hover {
                background-color: #388E3C;
            }
            .error {
                color: red;
                font-style: italic;
                margin-top: 10px;
            }
        </style>
    </head>
    <body>

        <div class="form-container">
            <h2>Chỉnh sửa ghi chú đơn thuốc</h2>

            <form action="EditPrescriptionNoteServlet" method="post">
                <input type="hidden" name="prescriptionId" value="${prescription.prescriptionId}" />

                <label for="note">Ghi chú:</label><br>
                <textarea id="note" name="note">${prescription.note}</textarea>

                <br><br>
                <input type="submit" class="btn" value="Lưu thay đổi" />

                <c:if test="${not empty errorMessage}">
                    <div class="error">${errorMessage}</div>
                </c:if>
            </form>
        </div>

    </body>
</html>

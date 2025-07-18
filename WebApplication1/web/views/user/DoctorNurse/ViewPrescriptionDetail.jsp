<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.entity.Prescriptions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Prescription Detail</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }

        .container {
            width: 70%;
            margin: auto;
            padding: 20px;
        }

        h2 {
            color: #2a8;
            margin-bottom: 20px;
        }

        .label {
            font-weight: bold;
        }

        .value {
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Prescription Detail</h2>

        <div class="value"><span class="label">Prescription ID:</span> ${prescription.prescriptionId}</div>
        <div class="value"><span class="label">Doctor ID:</span> ${prescription.doctorId}</div>
        <div class="value"><span class="label">Patient ID:</span> ${prescription.patientId}</div>
        <div class="value"><span class="label">Details:</span> ${prescription.prescriptionDetails}</div>
        <div class="value"><span class="label">Status:</span> ${prescription.status}</div>
        <div class="value"><span class="label">Created At:</span> ${createdAtFormatted}</div>
        <div class="value"><span class="label">Updated At:</span> ${updatedAtFormatted}</div>
    </div>
</body>
</html>

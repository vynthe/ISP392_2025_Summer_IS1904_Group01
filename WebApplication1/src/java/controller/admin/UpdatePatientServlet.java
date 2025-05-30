package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.Users;
import model.service.UserService;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.time.LocalDate;

@WebServlet(name = "UpdatePatientServlet", urlPatterns = {"/UpdatePatientServlet"})
public class UpdatePatientServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userIDParam = request.getParameter("id");
        if (userIDParam != null && !userIDParam.isEmpty()) {
            try {
                int userID = Integer.parseInt(userIDParam);
                Users patient = userService.getPatientByID(userID);
                if (patient != null) {
                    request.setAttribute("patient", patient);
                    request.getRequestDispatcher("/views/admin/UpdatePatient.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Không tìm thấy bệnh nhân để chỉnh sửa.");
                    request.getRequestDispatcher("/views/admin/UpdatePatient.jsp").forward(request, response);
                }
            } catch (NumberFormatException | SQLException e) {
                request.setAttribute("error", "Lỗi khi tải thông tin bệnh nhân: " + e.getMessage());
                request.getRequestDispatcher("/views/admin/UpdatePatient.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "ID không hợp lệ.");
            request.getRequestDispatcher("/views/admin/UpdatePatient.jsp").forward(request, response);
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userIDParam = request.getParameter("userID");
        String fullName = request.getParameter("fullName");
        String gender = request.getParameter("gender");
        String dobStr = request.getParameter("dob");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String status = request.getParameter("status");

        if (userIDParam == null || userIDParam.trim().isEmpty()) {
            handleError(request, response, "ID bệnh nhân không hợp lệ.", null, fullName, gender, dobStr, phone, address, status);
            return;
        }

        int userID;
        Users existingPatient;
        try {
            userID = Integer.parseInt(userIDParam);
            existingPatient = userService.getPatientByID(userID);
            if (existingPatient == null) {
                handleError(request, response, "Không tìm thấy bệnh nhân với ID: " + userID, null, fullName, gender, dobStr, phone, address, status);
                return;
            }
        } catch (NumberFormatException | SQLException e) {
            handleError(request, response, "Lỗi khi tải thông tin bệnh nhân: " + e.getMessage(), null, fullName, gender, dobStr, phone, address, status);
            return;
        }

        try {
            userService.validateFullName(fullName);

            if (gender == null || gender.trim().isEmpty()) {
                throw new IllegalArgumentException("Giới tính không được để trống.");
            }

            if (dobStr == null || dobStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Ngày sinh không được để trống.");
            }
            Date dob = Date.valueOf(dobStr);
            if (dob.toLocalDate().isAfter(LocalDate.now())) {
                throw new IllegalArgumentException("Ngày sinh không được quá thời gian hiện tại.");
            }

            if (phone == null || phone.trim().isEmpty() || !phone.matches("\\d{10}")) {
                throw new IllegalArgumentException("Số điện thoại phải là 10 chữ số.");
            }

            if (address == null || address.trim().isEmpty()) {
                throw new IllegalArgumentException("Địa chỉ không được để trống.");
            }

            if (status == null || status.trim().isEmpty()) {
                status = "Active";
            } else if (!status.equals("Active") && !status.equals("Inactive")) {
                throw new IllegalArgumentException("Trạng thái không hợp lệ.");
            }

            Users patient = new Users();
            patient.setUserID(userID);
            patient.setFullName(fullName.trim());
            patient.setGender(gender.trim());
            patient.setDob(dob);
            patient.setPhone(phone.trim());
            patient.setAddress(address.trim());
            patient.setStatus(status.trim());

         boolean updated = userService.UpdatePatient(patient);
            if (updated) {
                response.sendRedirect(request.getContextPath() + "/ViewPatientServlet");
            } else {
                handleError(request, response, "Không thể cập nhật thông tin bệnh nhân. Kiểm tra log để biết chi tiết.", existingPatient, fullName, gender, dobStr, phone, address, status);
            }
        } catch (IllegalArgumentException | SQLException e) {
            e.printStackTrace(); // In lỗi ra console
            handleError(request, response, "Lỗi: " + e.getMessage(), existingPatient, fullName, gender, dobStr, phone, address, status);
        }
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage, Users patient,
                             String fullName, String gender, String dob, String phone, String address, String status)
            throws ServletException, IOException {
        request.setAttribute("patient", patient);
        request.setAttribute("error", errorMessage);
        request.setAttribute("formFullName", fullName);
        request.setAttribute("formGender", gender);
        request.setAttribute("formDob", dob);
        request.setAttribute("formPhone", phone);
        request.setAttribute("formAddress", address);
        request.setAttribute("formStatus", status != null ? status : "Active");
        request.getRequestDispatcher("/views/admin/UpdatePatient.jsp").forward(request, response);
    }
}
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

@WebServlet(name = "UpdateEmployeeServlet", urlPatterns = {"/UpdateEmployeeServlet"})
public class UpdateEmployeeServlet extends HttpServlet {

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
                Users employee = userService.getEmployeeByID(userID);
                if (employee != null) {
                    request.setAttribute("employee", employee);
                    request.getRequestDispatcher("/views/admin/UpdateEmployees.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Không tìm thấy nhân viên để chỉnh sửa.");
                    request.getRequestDispatcher("/views/admin/UpdateEmployees.jsp").forward(request, response);
                }
            } catch (NumberFormatException | SQLException e) {
                request.setAttribute("error", "Lỗi khi tải thông tin nhân viên: " + e.getMessage());
                request.getRequestDispatcher("/views/admin/UpdateEmployees.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "ID không hợp lệ.");
            request.getRequestDispatcher("/views/admin/UpdateEmployees.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Retrieve form parameters
        String userIDParam = request.getParameter("userID");
        String fullName = request.getParameter("fullName");
        String gender = request.getParameter("gender");
        String specialization = request.getParameter("specialization");
        String dobStr = request.getParameter("dob");
        String status = request.getParameter("status");

        // Validate userID and fetch employee
        if (userIDParam == null || userIDParam.trim().isEmpty()) {
            handleError(request, response, "ID nhân viên không hợp lệ.", null, fullName, gender, specialization, dobStr, status);
            return;
        }
        int userID;
        Users existingEmployee;
        try {
            userID = Integer.parseInt(userIDParam);
            existingEmployee = userService.getEmployeeByID(userID);
            if (existingEmployee == null) {
                handleError(request, response, "Không tìm thấy nhân viên với ID: " + userID, null, fullName, gender, specialization, dobStr, status);
                return;
            }
        } catch (NumberFormatException e) {
            handleError(request, response, "ID nhân viên phải là một số hợp lệ.", null, fullName, gender, specialization, dobStr, status);
            return;
        } catch (SQLException e) {
            handleError(request, response, "Lỗi khi tải thông tin nhân viên: " + e.getMessage(), null, fullName, gender, specialization, dobStr, status);
            return;
        }

        try {
            // Validate fullName using service method
            userService.validateFullName(fullName);

            // Validate gender (only check for null/empty)
            if (gender == null || gender.trim().isEmpty()) {
                throw new IllegalArgumentException("Giới tính không được để trống.");
            }

            // Validate specialization (required for Doctor/Nurse, optional for Receptionist)
            if ((existingEmployee.getRole().equals("Doctor") || existingEmployee.getRole().equals("Nurse"))
                    && (specialization == null || specialization.trim().isEmpty())) {
                throw new IllegalArgumentException("Chuyên khoa không được để trống cho Bác sĩ hoặc Y tá.");
            }

            // Validate dob
            if (dobStr == null || dobStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Ngày sinh không được để trống.");
            }
            Date dob;
            try {
                dob = Date.valueOf(dobStr);
            } catch (IllegalArgumentException e) {
                throw new IllegalArgumentException("Định dạng ngày sinh không hợp lệ: " + dobStr);
            }
            LocalDate currentDate = LocalDate.now();
            if (dob.toLocalDate().isAfter(currentDate)) {
                throw new IllegalArgumentException("Ngày sinh không được quá thời gian thực.");
            }

            // Validate status (if provided, otherwise default to 'Active')
            if (status == null || status.trim().isEmpty()) {
                status = "Active";
            } else if (!status.matches("^(Active|Inactive|Suspended|Locked)$")) {
                throw new IllegalArgumentException("Trạng thái không hợp lệ: " + status);
            }

            // Create Users object
            Users employee = new Users();
            employee.setUserID(userID);
            employee.setFullName(fullName.trim());
            employee.setGender(gender.trim()); // Directly set gender without mapping
            employee.setSpecialization(specialization != null ? specialization.trim() : null);
            employee.setDob(dob);
            employee.setStatus(status.trim());

            // Update employee
            boolean updated = userService.UpdateEmployee(employee);
            if (updated) {
                response.sendRedirect(request.getContextPath() + "/ViewEmployeeServlet");
            } else {
                handleError(request, response, "Không thể cập nhật thông tin nhân viên.", existingEmployee, fullName, gender, specialization, dobStr, status);
            }
        } catch (IllegalArgumentException e) {
            handleError(request, response, e.getMessage(), existingEmployee, fullName, gender, specialization, dobStr, status);
        } catch (SQLException e) {
            handleError(request, response, "Lỗi khi cập nhật thông tin nhân viên: " + e.getMessage(), existingEmployee, fullName, gender, specialization, dobStr, status);
        }
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage, Users employee,
                             String fullName, String gender, String specialization, String dob, String status)
            throws ServletException, IOException {
        request.setAttribute("employee", employee);
        request.setAttribute("error", errorMessage);
        request.setAttribute("formFullName", fullName);
        request.setAttribute("formGender", gender);
        request.setAttribute("formSpecialization", specialization);
        request.setAttribute("formDob", dob);
        request.setAttribute("formStatus", status != null ? status : "Active");
        request.getRequestDispatcher("/views/admin/UpdateEmployees.jsp").forward(request, response);
    }
}
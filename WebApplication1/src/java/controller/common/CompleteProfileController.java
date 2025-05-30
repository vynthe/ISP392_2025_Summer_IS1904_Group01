package controller.common;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Date;
import java.time.LocalDate;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.service.UserService;
import model.entity.Users;

/**
 * Xử lý hoàn thiện hồ sơ của user
 */
@WebServlet(name = "CompleteProfileController", urlPatterns = {"/CompleteProfileController"})
public class CompleteProfileController extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Users user = (Users) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/UserLoginController");
            return;
        }

        try {
            String fullName = request.getParameter("fullName");
            String dobStr = request.getParameter("dob");
            String gender = request.getParameter("gender");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String medicalHistory = request.getParameter("medicalHistory");
            String specialization = request.getParameter("specialization");

            // Retain form values in case of error
            request.setAttribute("fullName", fullName);
            request.setAttribute("dob", dobStr);
            request.setAttribute("gender", gender);
            request.setAttribute("phone", phone);
            request.setAttribute("address", address);
            request.setAttribute("medicalHistory", medicalHistory);
            request.setAttribute("specialization", specialization);

            // Validate fullName bằng validateFullName từ UserService
            try {
                userService.validateFullName(fullName); // Sẽ ném SQLException nếu fullName không hợp lệ
            } catch (SQLException e) {
                request.setAttribute("error", e.getMessage());
                redirectToCompleteProfile(user.getRole(), request, response);
                return;
            }

            if (dobStr != null && !dobStr.trim().isEmpty()) {
                Date dob = Date.valueOf(dobStr);
                LocalDate currentDate = LocalDate.now(); // 09:10 AM +07, 26/5/2025
                LocalDate dobDate = dob.toLocalDate();
                if (dobDate.isAfter(currentDate)) {
                    request.setAttribute("error", "Ngày sinh không được vượt quá thời gian thực.");
                    redirectToCompleteProfile(user.getRole(), request, response);
                    return;
                }
            } else {
                request.setAttribute("error", "Ngày sinh không được để trống.");
                redirectToCompleteProfile(user.getRole(), request, response);
                return;
            }

            if (gender == null || gender.trim().isEmpty()) {
                request.setAttribute("error", "Giới tính không được để trống.");
                redirectToCompleteProfile(user.getRole(), request, response);
                return;
            }

            if (phone == null || phone.trim().isEmpty()) {
                request.setAttribute("error", "Số điện thoại không được để trống.");
                redirectToCompleteProfile(user.getRole(), request, response);
                return;
            }

            if (!phone.matches("\\d{10}")) {
                request.setAttribute("error", "Số điện thoại phải có đúng 10 chữ số.");
                redirectToCompleteProfile(user.getRole(), request, response);
                return;
            }

            // ... (giữ nguyên các validation khác)
            String mappedGender = mapGender(gender);
            user.setFullName(fullName != null && !fullName.trim().isEmpty() ? fullName : user.getFullName());
            user.setDob(dobStr != null && !dobStr.trim().isEmpty() ? Date.valueOf(dobStr) : user.getDob());
            user.setGender(mappedGender);
            user.setPhone(phone);
            user.setAddress(address != null && !address.trim().isEmpty() ? address : null);
            user.setMedicalHistory("patient".equalsIgnoreCase(user.getRole()) ? (medicalHistory != null ? medicalHistory : "") : null);
            user.setSpecialization(("doctor".equalsIgnoreCase(user.getRole()) || "nurse".equalsIgnoreCase(user.getRole())) ? specialization : null);

            userService.updateUserProfile(user);
            String redirectUrl = getDashboardUrl(user.getRole());
            response.sendRedirect(request.getContextPath() + redirectUrl);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi cập nhật hồ sơ: " + e.getMessage());
            redirectToCompleteProfile(user.getRole(), request, response);
        }
    }

    private String mapGender(String gender) {
        if (gender == null) return null;
        switch (gender.trim().toLowerCase()) {
            case "nam":
                return "Male";
            case "nữ":
                return "Female";
            case "khác":
                return "Other";
            default:
                return gender; // Return as-is if no match (though this should be validated)
        }
    }

    private void redirectToCompleteProfile(String role, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        switch (role.toLowerCase()) {
            case "patient":
                request.getRequestDispatcher("/views/user/Patient/CompleteProfilePatient.jsp").forward(request, response);
                break;
            case "doctor":
            case "nurse":
                request.getRequestDispatcher("/views/user/DoctorNurse/CompleteProfileDoctorNurse.jsp").forward(request, response);
                break;
            case "receptionist":
                request.getRequestDispatcher("/views/user/Receptionist/CompleteProfileReceptionist.jsp").forward(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/default/completeProfile");
        }
    }

    private String getDashboardUrl(String role) {
        if (role == null) {
            return "/default/dashboard";
        }
        switch (role.toLowerCase()) {
            case "patient":
                return "/views/user/Patient/PatientDashBoard.jsp";
            case "doctor":
            case "nurse":
                return "/views/user/DoctorNurse/EmployeeDashBoard.jsp";
            case "receptionist":
                return "/views/user/Receptionist/ReceptionistDashBoard.jsp";
            default:
                return "/default/dashboard";
        }
    }
}
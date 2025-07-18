package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import model.entity.Users;
import model.service.UserService;

@WebServlet(name = "EditProfileUserController", urlPatterns = {"/EditProfileUserController"})
public class EditProfileUserController extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        String role = user.getRole();
        String jspPath = getJspPathByRole(role);
        request.getRequestDispatcher(jspPath).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("/views/common/login.jsp");
            return;
        }

        // Lấy dữ liệu từ form
        String username = request.getParameter("username");
        String dobStr = request.getParameter("dob");
        String gender = request.getParameter("gender");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String specialization = request.getParameter("specialization");
        String medicalHistory = request.getParameter("medicalHistory");

        try {
            // Validate username
            if (username == null || username.trim().isEmpty()) {
                throw new ServletException("Tên đăng nhập không được để trống.");
            }
            userService.validateUsername(username);
            if (!username.equals(user.getUsername()) && userService.isEmailOrUsernameExists(null, username)) {
                throw new ServletException("Tên đăng nhập đã tồn tại.");
            }

            // Validate email
            if (email == null || email.trim().isEmpty()) {
                throw new ServletException("Email không được để trống.");
            }
            if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                throw new ServletException("Định dạng email không hợp lệ.");
            }
            if (!email.equals(user.getEmail()) && userService.isEmailOrUsernameExists(email, null)) {
                throw new ServletException("Email đã tồn tại.");
            }

            // Validate dob
            if (dobStr == null || dobStr.trim().isEmpty()) {
                throw new ServletException("Ngày sinh không được để trống.");
            }
            Date dob;
            try {
                dob = Date.valueOf(dobStr);
                LocalDate currentDate = LocalDate.now();
                LocalDate dobDate = dob.toLocalDate();
                if (dobDate.isAfter(currentDate)) {
                    throw new ServletException("Ngày sinh không được vượt quá ngày hiện tại.");
                }
            } catch (IllegalArgumentException e) {
                throw new ServletException("Định dạng ngày sinh không hợp lệ: " + dobStr);
            }

            // Validate gender
            if (gender == null || gender.trim().isEmpty()) {
                throw new ServletException("Giới tính không được để trống.");
            }
            String mappedGender = gender.trim();
            if (mappedGender.equals("Nam") || mappedGender.equals("Male")) {
                mappedGender = "Male";
            } else if (mappedGender.equals("Nữ") || mappedGender.equals("Female")) {
                mappedGender = "Female";
            } else if (mappedGender.equals("Khác") || mappedGender.equals("Other")) {
                mappedGender = "Other";
            } else {
                throw new ServletException("Giới tính không hợp lệ: " + gender);
            }

            // Validate phone
            if (phone != null && !phone.trim().isEmpty()) {
                if (!phone.matches("\\d{10}")) {
                    throw new ServletException("Số điện thoại phải có đúng 10 chữ số.");
                }
                if (userService.isPhoneExists(phone) && !phone.equals(user.getPhone())) {
                    throw new ServletException("Số điện thoại đã tồn tại.");
                }
            } else {
                phone = null;
            }

            // Validate address
            if (address == null || address.trim().isEmpty()) {
                throw new ServletException("Địa chỉ không được để trống.");
            }

            // Cập nhật thông tin
            user.setUsername(username.trim());
            user.setEmail(email.trim());
            user.setDob(dob);
            user.setGender(mappedGender);
            user.setPhone(phone);
            user.setAddress(address.trim());

            // Cập nhật theo role
            String role = user.getRole().toLowerCase();
            switch (role) {
                case "doctor":
                case "nurse":
                    if (specialization == null || specialization.trim().isEmpty()) {
                        throw new ServletException("Chuyên khoa không được để trống cho Bác sĩ hoặc Y tá.");
                    }
                    user.setSpecialization(specialization.trim());
                    user.setMedicalHistory(null);
                    break;

                case "patient":
                    user.setSpecialization(null);
                    break;

                case "receptionist":
                    user.setSpecialization(null);
                    user.setMedicalHistory(null);
                    break;

                default:
                    throw new ServletException("Vai trò không được hỗ trợ: " + role);
            }

            // Cập nhật vào database
            userService.updateUserProfile(user);
            session.setAttribute("user", user);
            request.setAttribute("success", "Cập nhật hồ sơ thành công.");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi cập nhật hồ sơ: " + e.getMessage());
            request.setAttribute("formUsername", username);
            request.setAttribute("formDob", dobStr);
            request.setAttribute("formGender", gender);
            request.setAttribute("formEmail", email);
            request.setAttribute("formPhone", phone);
            request.setAttribute("formAddress", address);
            request.setAttribute("formSpecialization", specialization);
            request.setAttribute("formMedicalHistory", medicalHistory);
        }

        String jspPath = getJspPathByRole(user.getRole());
        request.getRequestDispatcher(jspPath).forward(request, response);
    }

    private String getJspPathByRole(String role) {
        if (role == null) return "/views/common/error.jsp";

        switch (role.toLowerCase()) {
            case "doctor":
            case "nurse":
                return "/views/user/DoctorNurse/EditProfileDoctorNurse.jsp";
            case "patient":
                return "/views/user/Patient/EditProfilePatient.jsp";
            case "receptionist":
                return "/views/user/Receptionist/EditProfileReceptionist.jsp";
            default:
                return "/views/common/error.jsp";
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet dùng chung cập nhật hồ sơ cho Doctor/Nurse, Patient, Receptionist";
    }
}
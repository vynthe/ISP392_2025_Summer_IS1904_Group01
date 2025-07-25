package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
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
        
        // Xóa các message cũ khi load trang
        request.removeAttribute("success");
        request.removeAttribute("error");
        
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

        // Lưu lại dữ liệu form để hiển thị khi có lỗi
        request.setAttribute("formUsername", username);
        request.setAttribute("formDob", dobStr);
        request.setAttribute("formGender", gender);
        request.setAttribute("formEmail", email);
        request.setAttribute("formPhone", phone);
        request.setAttribute("formAddress", address);
        request.setAttribute("formSpecialization", specialization);
        request.setAttribute("formMedicalHistory", medicalHistory);

        try {
            // Validate username
            if (username == null || username.trim().isEmpty()) {
                throw new SQLException("Tên đăng nhập không được để trống.");
            }
            userService.validateUsername(username);
            if (!username.equals(user.getUsername()) && userService.isEmailOrUsernameExists(null, username)) {
                throw new SQLException("Tên đăng nhập đã tồn tại.");
            }

            // Validate email
            if (email == null || email.trim().isEmpty()) {
                throw new SQLException("Email không được để trống.");
            }
            if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                throw new SQLException("Định dạng email không hợp lệ.");
            }
            if (!email.equals(user.getEmail()) && userService.isEmailOrUsernameExists(email, null)) {
                throw new SQLException("Email đã tồn tại.");
            }

            // Validate dob
            if (dobStr == null || dobStr.trim().isEmpty()) {
                throw new SQLException("Ngày sinh không được để trống.");
            }
            Date dob;
            try {
                dob = Date.valueOf(dobStr);
                LocalDate currentDate = LocalDate.now();
                LocalDate dobDate = dob.toLocalDate();
                if (dobDate.isAfter(currentDate)) {
                    throw new SQLException("Ngày sinh không được vượt quá ngày hiện tại.");
                }
                if (dobDate.getYear() < 1915) {
                    throw new SQLException("Năm sinh phải từ năm 1915 trở lên.");
                }
            } catch (IllegalArgumentException e) {
                throw new SQLException("Định dạng ngày sinh không hợp lệ: " + dobStr);
            }

            // Validate gender
            if (gender == null || gender.trim().isEmpty()) {
                throw new SQLException("Giới tính không được để trống.");
            }
            String mappedGender = gender.trim();
            if (mappedGender.equals("Nam") || mappedGender.equals("Male")) {
                mappedGender = "Male";
            } else if (mappedGender.equals("Nữ") || mappedGender.equals("Female")) {
                mappedGender = "Female";
            } else if (mappedGender.equals("Khác") || mappedGender.equals("Other")) {
                mappedGender = "Other";
            } else {
                throw new SQLException("Giới tính không hợp lệ: " + gender);
            }

            // Validate phone
            if (phone != null && !phone.trim().isEmpty()) {
                if (!phone.matches("\\d{10}")) {
                    throw new SQLException("Số điện thoại phải có đúng 10 chữ số.");
                }
                if (userService.isPhoneExists(phone) && !phone.equals(user.getPhone())) {
                    throw new SQLException("Số điện thoại đã tồn tại.");
                }
            } else {
                phone = null;
            }

            // Validate address - NEW VALIDATION
            if (address == null || address.trim().isEmpty()) {
                throw new SQLException("Địa chỉ không được để trống.");
            }
            address = address.trim();
            if (address.length() > 250) {
                throw new SQLException("Địa chỉ không được vượt quá 250 ký tự.");
            }
            // Chỉ cho phép chữ cái, số, dấu phẩy, dấu gạch chéo, khoảng trắng và một số ký tự đặc biệt phổ biến
            if (!address.matches("^[a-zA-ZÀ-ỹ0-9\\s,/.-]+$")) {
                throw new SQLException("Địa chỉ chỉ được chứa chữ cái, số, dấu phẩy (,), dấu gạch chéo (/), dấu chấm (.) và dấu gạch ngang (-).");
            }

            // Cập nhật thông tin người dùng
            user.setUsername(username.trim());
            user.setEmail(email.trim());
            user.setDob(dob);
            user.setGender(mappedGender);
            user.setPhone(phone);
            user.setAddress(address);

            // Cập nhật theo role
            String role = user.getRole().toLowerCase();
            switch (role) {
                case "doctor":
                    if (specialization == null || specialization.trim().isEmpty()) {
                        throw new SQLException("Chuyên khoa không được để trống cho Bác sĩ.");
                    }
                    
                    // NEW VALIDATION FOR DOCTOR BASED ON SPECIALIZATION
                    validateDoctorBySpecialization(specialization.trim(), dob);
                    
                    user.setSpecialization(specialization.trim());
                    user.setMedicalHistory(null);
                    break;

                case "nurse":
                    if (specialization == null || specialization.trim().isEmpty()) {
                        throw new SQLException("Chuyên khoa không được để trống cho Y tá.");
                    }
                    user.setSpecialization(specialization.trim());
                    user.setMedicalHistory(null);
                    break;

                case "patient":
                    user.setSpecialization(null);
                    // Medical history có thể null cho patient
                    if (medicalHistory != null && !medicalHistory.trim().isEmpty()) {
                        user.setMedicalHistory(medicalHistory.trim());
                    }
                    break;

                case "receptionist":
                    user.setSpecialization(null);
                    user.setMedicalHistory(null);
                    break;

                default:
                    throw new SQLException("Vai trò không được hỗ trợ: " + role);
            }

            // Gọi method updateUserProfile (void return type)
            userService.updateUserProfile(user);
            
            // Nếu đến đây thì cập nhật thành công
            // Cập nhật session với thông tin mới
            session.setAttribute("user", user);
            
            // Set success message
            request.setAttribute("success", "Cập nhật hồ sơ thành công!");
            
            // Xóa dữ liệu form cũ khi thành công
            request.removeAttribute("formUsername");
            request.removeAttribute("formDob");
            request.removeAttribute("formGender");
            request.removeAttribute("formEmail");
            request.removeAttribute("formPhone");
            request.removeAttribute("formAddress");
            request.removeAttribute("formSpecialization");
            request.removeAttribute("formMedicalHistory");
            
            System.out.println("✅ Cập nhật thành công cho user: " + user.getUsername());

        } catch (SQLException e) {
            System.err.println("❌ Lỗi SQL khi cập nhật hồ sơ: " + e.getMessage());
            e.printStackTrace();
            
            // Set error message
            request.setAttribute("error", "Lỗi cập nhật hồ sơ: " + e.getMessage());
            
            // Xóa success message nếu có
            request.removeAttribute("success");
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi không xác định khi cập nhật hồ sơ: " + e.getMessage());
            e.printStackTrace();
            
            // Set error message
            request.setAttribute("error", "Cập nhật hồ sơ thất bại");
            
            // Xóa success message nếu có
            request.removeAttribute("success");
        }

        // Forward về trang JSP tương ứng
        String jspPath = getJspPathByRole(user.getRole());
        request.getRequestDispatcher(jspPath).forward(request, response);
    }

    /**
     * Validate Doctor based on specialization level
     * @param specialization - specialization string
     * @param dob - date of birth
     * @throws SQLException if validation fails
     */
    private void validateDoctorBySpecialization(String specialization, Date dob) throws SQLException {
        int birthYear = dob.toLocalDate().getYear();
        String specializationLower = specialization.toLowerCase();
        
        // Check for Master's degree keywords
        if (specializationLower.contains("thạc sĩ") || 
            specializationLower.contains("master") ||
            specializationLower.contains("ths") ||
            specializationLower.contains("m.d") ||
            specializationLower.contains("ms")) {
            
            if (birthYear >= 2000) {
                throw new SQLException("Thạc Sĩ phải 24 tuổi trở lên");
            }
        }
        
        // Check for PhD/Doctorate keywords
        else if (specializationLower.contains("tiến sĩ") || 
                 specializationLower.contains("tiến sỹ") ||
                 specializationLower.contains("doctor") ||
                 specializationLower.contains("phd") ||
                 specializationLower.contains("ph.d") ||
                 specializationLower.contains("ts") ||
                 specializationLower.contains("gs") ||
                 specializationLower.contains("giáo sư")) {
            
            if (birthYear > 1999) {
                throw new SQLException("Tiến Sỹ Phải 26 tuổi trở lên");
            }
        }
        
        // Check for Specialist keywords
        else if (specializationLower.contains("chuyên khoa") ||
                 specializationLower.contains("specialist") ||
                 specializationLower.contains("chuyên gia") ||
                 specializationLower.contains("ck")) {
            
            if (birthYear > 1997) {
                throw new SQLException("Bác Sĩ Chuyên Khoa Phải 27 tuổi trở lên ");
            }
        }
        
        // For general doctors (no specific degree mentioned), no additional age restriction
        // They still need to meet the basic requirement of birth year >= 1915
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
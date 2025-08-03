package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Users;
import model.entity.Services;
import model.service.ReviewService;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet({"/SimpleSubmitReviewServlet", "/SubmitReviewServlet"})
public class SimpleSubmitReviewServlet extends HttpServlet {
    private ReviewService reviewService;

    @Override
    public void init() {
        this.reviewService = new ReviewService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/views/common/login.jsp");
            return;
        }

        Users user = (Users) session.getAttribute("user");
        if (!"patient".equalsIgnoreCase(user.getRole())) {
            request.setAttribute("error", "Chỉ bệnh nhân mới có thể đánh giá.");
            request.getRequestDispatcher("views/user/Patient/SubmitReview.jsp").forward(request, response);
            return;
        }

        try {
            // Lấy danh sách bác sĩ mà bệnh nhân có thể đánh giá
            List<Users> doctors = reviewService.getDoctorsForReview(user.getUserID());
            request.setAttribute("doctors", doctors);

            // Nếu có doctorId được chọn, lấy danh sách dịch vụ
            String doctorIdParam = request.getParameter("doctorId");
            if (doctorIdParam != null && !doctorIdParam.isEmpty()) {
                try {
                    int doctorId = Integer.parseInt(doctorIdParam);
                    List<Services> services = reviewService.getServicesForReview(user.getUserID(), doctorId);
                    request.setAttribute("services", services);
                    request.setAttribute("selectedDoctorId", doctorId);
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "ID bác sĩ không hợp lệ.");
                }
            }

            // Forward to JSP
            request.getRequestDispatcher("views/user/Patient/SubmitReview.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("views/user/Patient/SubmitReview.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // Check session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/views/common/login.jsp");
            return;
        }

        Users user = (Users) session.getAttribute("user");
        if (!"patient".equalsIgnoreCase(user.getRole())) {
            request.setAttribute("error", "Chỉ bệnh nhân mới có thể đánh giá.");
            doGet(request, response);
            return;
        }

        try {
            // Get form data
            String doctorId = request.getParameter("doctorId");
            String serviceId = request.getParameter("serviceId");
            String serviceRating = request.getParameter("serviceRating");
            String doctorRating = request.getParameter("doctorRating");
            String comment = request.getParameter("comment");

            // Simple validation
            if (doctorId == null || doctorId.isEmpty() ||
                serviceId == null || serviceId.isEmpty() ||
                serviceRating == null || serviceRating.isEmpty() ||
                doctorRating == null || doctorRating.isEmpty() ||
                comment == null || comment.trim().isEmpty()) {
                
                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin.");
                doGet(request, response);
                return;
            }

            // Lưu đánh giá vào database
            boolean success = reviewService.submitReview(
                user.getUserID(), 
                Integer.parseInt(doctorId), 
                Integer.parseInt(serviceId), 
                Integer.parseInt(serviceRating), 
                Integer.parseInt(doctorRating), 
                comment
            );

            if (success) {
                request.setAttribute("success", "Đánh giá của bạn đã được gửi thành công!");
                // Có thể redirect đến trang xem đánh giá
                // response.sendRedirect(request.getContextPath() + "/ViewReviewsServlet");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi lưu đánh giá.");
            }
            
            doGet(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ.");
            doGet(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", e.getMessage());
            doGet(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            doGet(request, response);
        }
    }
}

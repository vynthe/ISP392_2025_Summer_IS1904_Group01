package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Admins;
import model.entity.Reviews;
import model.service.ReviewService;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/ReviewManagementServlet")
public class ReviewManagementServlet extends HttpServlet {
    private ReviewService reviewService;

    @Override
    public void init() {
        this.reviewService = new ReviewService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/views/common/login.jsp");
            return;
        }

        try {
            // Lấy tham số tìm kiếm từ request
            String searchDoctor = request.getParameter("searchDoctor");
            String searchPatient = request.getParameter("searchPatient");

            // Lấy danh sách đánh giá với phản hồi, áp dụng tìm kiếm nếu có
            List<Reviews> reviews;
            if ((searchDoctor != null && !searchDoctor.trim().isEmpty()) || 
                (searchPatient != null && !searchPatient.trim().isEmpty())) {
                // Gọi phương thức tìm kiếm với các tham số
                reviews = reviewService.searchReviewsByDoctorOrPatient(searchDoctor, searchPatient);
            } else {
                // Nếu không có tham số tìm kiếm, lấy tất cả đánh giá
                reviews = reviewService.getAllReviewsWithReplies();
            }

            // Đặt danh sách đánh giá vào request
            request.setAttribute("reviews", reviews);

            // Chuyển tiếp đến JSP
            request.getRequestDispatcher("/views/admin/ReviewManagement.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi lấy danh sách đánh giá: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/views/common/login.jsp");
            return;
        }

        Admins admin = (Admins) session.getAttribute("admin");

        try {
            // Lấy thông tin phản hồi từ form
            int reviewId = Integer.parseInt(request.getParameter("reviewId"));
            String replyContent = request.getParameter("replyContent");

            if (replyContent == null || replyContent.trim().isEmpty()) {
                request.setAttribute("error", "Nội dung phản hồi không được để trống.");
                doGet(request, response);
                return;
            }

            // Lưu phản hồi
            boolean success = reviewService.saveReply(reviewId, admin.getAdminID(), replyContent.trim());

            if (success) {
                request.setAttribute("success", "Phản hồi đã được gửi thành công!");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi lưu phản hồi.");
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

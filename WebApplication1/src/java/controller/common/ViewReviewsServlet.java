package controller.common;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.Reviews;
import model.service.ReviewService;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/ViewReviewsServlet")
public class ViewReviewsServlet extends HttpServlet {
    private ReviewService reviewService;

    @Override
    public void init() {
        this.reviewService = new ReviewService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Lấy tất cả đánh giá với phản hồi
            List<Reviews> reviews = reviewService.getAllReviewsWithReplies();
            request.setAttribute("reviews", reviews);

            // Kiểm tra doctorId parameter để lọc theo bác sĩ
            String doctorIdParam = request.getParameter("doctorId");
            if (doctorIdParam != null && !doctorIdParam.isEmpty()) {
                try {
                    int doctorId = Integer.parseInt(doctorIdParam);
                    List<Reviews> doctorReviews = reviewService.getReviewsByDoctorId(doctorId);
                    request.setAttribute("reviews", doctorReviews);
                    request.setAttribute("doctorId", doctorId);
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "ID bác sĩ không hợp lệ.");
                }
            }

            request.getRequestDispatcher("/views/common/ViewReviews.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi lấy danh sách đánh giá: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}

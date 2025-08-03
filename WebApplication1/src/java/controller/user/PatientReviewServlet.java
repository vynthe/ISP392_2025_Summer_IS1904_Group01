package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Users;
import model.service.UserService;

import java.io.IOException;
import java.util.List;

@WebServlet("/PatientReviewServlet")
public class PatientReviewServlet extends HttpServlet {
    private UserService userService;

    @Override
    public void init() {
        this.userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect to the new review form
        response.sendRedirect(request.getContextPath() + "/views/user/Patient/PatientReview.jsp");
    }
}

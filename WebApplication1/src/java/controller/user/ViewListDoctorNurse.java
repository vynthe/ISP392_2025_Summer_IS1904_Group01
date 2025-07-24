package controller.user;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.service.UserService;
import model.entity.Users;

/**
 * Servlet to display list of doctors and nurses for receptionist
 */
@WebServlet(name = "ViewListDoctorNurse", urlPatterns = {"/ViewListDoctorNurse"})
public class ViewListDoctorNurse extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in and is a receptionist
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;
        if (user == null || !"receptionist".equalsIgnoreCase(user.getRole())) {
            request.setAttribute("error", "You must be logged in as a receptionist to access this page.");
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            return;
        }

        try {
            // Get list of doctors and nurses
            List<Users> doctorNurseList = userService.getDoctorNurse();
            request.setAttribute("doctorNurseList", doctorNurseList);
            
            // Forward to JSP page to display the list
            request.getRequestDispatcher("/views/user/Receptionist/ViewListDoctorNurse.jsp").forward(request, response);
        } catch (SQLException e) {
            System.err.println("DoctorNurseListController: SQL Error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error retrieving doctor and nurse list: " + e.getMessage());
            request.getRequestDispatcher("/views/user/Receptionist/ViewListDoctorNurse.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect POST requests to GET to prevent duplicate form submissions
        response.sendRedirect(request.getContextPath() + "/ViewListDoctorNurse");
    }

    @Override
    public String getServletInfo() {
        return "Lists all doctors and nurses for receptionist view";
    }
}
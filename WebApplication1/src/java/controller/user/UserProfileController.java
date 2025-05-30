/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.user;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import model.dao.UserDAO;
import model.entity.Users;

/**
 *
 * @author HP
 */
@WebServlet(name="UserProfileController", urlPatterns={"/UserProfileController"})
public class UserProfileController extends HttpServlet {
   
     private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
           HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        Users userSession = (Users) session.getAttribute("user");
        if (userSession == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        Integer userID = userSession.getUserID();
        
        try {
            Users user = userDAO.getUserByID(userID);
            if (user == null) {
                request.setAttribute("error", "User không tồn tại!");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            request.setAttribute("userProfile", user);

            String role = user.getRole();
            if (role == null) {
                request.setAttribute("error", "Role không hợp lệ.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            role = role.toLowerCase();
            switch (role) {
                case "doctor":
                case "nurse":
                    
                    request.getRequestDispatcher("/views/user/DoctorNurse/DoctorNurseProfile.jsp").forward(request, response);
                    break;
                case "receptionist":
                    request.getRequestDispatcher("/views/user/Receptionist/ReceptionistProfile.jsp").forward(request, response);
                    break;
                case "patient":
                    request.getRequestDispatcher("/views/user/Patient/PatientProfile.jsp").forward(request, response);
                    break;
                default:
                    request.setAttribute("error", "Role không hợp lệ.");
                    request.getRequestDispatcher("/error.jsp").forward(request, response);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error: " + e.getMessage(), e);
        
    }

    }
}

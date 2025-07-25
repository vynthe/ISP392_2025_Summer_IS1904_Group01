package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.Services;
import model.service.Services_Service;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import model.service.UserService;

@WebServlet(name = "ViewServiceServlet", urlPatterns = {"/ViewServiceServlet"})
public class ViewServiceServlet extends HttpServlet {

    private Services_Service servicesService;

    @Override
    public void init() throws ServletException {
        servicesService = new Services_Service();
    }
@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");

    String keyword = request.getParameter("keyword");
    String minPriceStr = request.getParameter("minPrice");
    String maxPriceStr = request.getParameter("maxPrice");

    double minPrice = 0;
    double maxPrice = Double.MAX_VALUE;

    try {
        if (minPriceStr != null && !minPriceStr.trim().isEmpty()) {
            minPrice = Double.parseDouble(minPriceStr);
        }
        if (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) {
            maxPrice = Double.parseDouble(maxPriceStr);
        }
    } catch (NumberFormatException e) {
        minPrice = 0;
        maxPrice = Double.MAX_VALUE;
    }

    try {
        List<Services> services;
        boolean isSearching = (keyword != null && !keyword.trim().isEmpty())
                || minPrice > 0 || maxPrice < Double.MAX_VALUE;

        if (isSearching) {
            services = servicesService.searchServices(keyword == null ? "" : keyword.trim(), minPrice, maxPrice);
        } else {
            services = servicesService.getAllServices();
        }

        request.setAttribute("services", services);
        request.setAttribute("keyword", keyword);
        request.setAttribute("minPrice", minPriceStr);
        request.setAttribute("maxPrice", maxPriceStr);

    } catch (SQLException e) {
        System.err.println("Lỗi SQL khi lấy danh sách dịch vụ: " + e.getMessage());
        request.setAttribute("error", "Lỗi khi tải danh sách dịch vụ.");
    }

    request.getRequestDispatcher("/views/admin/ViewServices.jsp").forward(request, response);
}
}

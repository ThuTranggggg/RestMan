package servlet;

import dao.StaffDAO;
import model.Staff;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String role = request.getParameter("role");
        
        if ("staff".equals(role)) {
            request.getRequestDispatcher("/WEB-INF/Staff/LoginPage.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        
        if (username == null || password == null || role == null) {
            response.sendRedirect(request.getContextPath() + "/login?role=" + role + "&error=empty");
            return;
        }
        
        if ("staff".equals(role)) {
            handleStaffLogin(request, response, username, password);
        } else {
            response.sendRedirect(request.getContextPath() + "/");
        }
    }

    private void handleStaffLogin(HttpServletRequest request, HttpServletResponse response,
                                   String username, String password) throws ServletException, IOException {
        StaffDAO staffDAO = new StaffDAO();
        try {
            Staff staff = staffDAO.authenticate(username, password);
            if (staff != null) {
                HttpSession session = request.getSession(true);
                session.setAttribute("staff", staff);
                response.sendRedirect(request.getContextPath() + "/staffPage");
            } else {
                response.sendRedirect(request.getContextPath() + "/login?role=staff&error=invalid");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/login?role=staff&error=db");
        }
    }
}

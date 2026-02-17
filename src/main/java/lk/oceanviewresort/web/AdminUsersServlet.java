package lk.oceanviewresort.web;

import lk.oceanviewresort.dao.AdminUserDAO;
import lk.oceanviewresort.dao.RoleDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/app/admin/users")
public class AdminUsersServlet extends HttpServlet {

    private final AdminUserDAO adminUserDAO = new AdminUserDAO();
    private final RoleDAO roleDAO = new RoleDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("msg", req.getParameter("msg"));
        req.setAttribute("error", req.getParameter("error"));
        req.setAttribute("users", adminUserDAO.listUsers());
        req.setAttribute("roles", roleDAO.listRoles());

        req.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String fullName = req.getParameter("fullName");
        int roleId = Integer.parseInt(req.getParameter("roleId"));

        if (username == null || username.trim().length() < 3 || password == null || password.length() < 4) {
            resp.sendRedirect(req.getContextPath() + "/app/admin/users?error=Invalid input");
            return;
        }

        try {
            adminUserDAO.addUser(username.trim(), password, fullName, roleId);

            int adminId = (int) req.getSession(false).getAttribute("userId");
            new lk.oceanviewresort.dao.AuditDAO().log(adminId, "ADD_USER", "Username=" + username.trim());

            resp.sendRedirect(req.getContextPath() + "/app/admin/users?msg=User added");

        } catch (SQLException e) {
            resp.sendRedirect(req.getContextPath() + "/app/admin/users?error=Username already exists");
        }
    }
}

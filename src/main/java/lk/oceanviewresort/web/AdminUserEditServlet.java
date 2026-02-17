package lk.oceanviewresort.web;

import lk.oceanviewresort.dao.AdminUserDAO;
import lk.oceanviewresort.dao.RoleDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/app/admin/user/edit")
public class AdminUserEditServlet extends HttpServlet {

    private final AdminUserDAO adminUserDAO = new AdminUserDAO();
    private final RoleDAO roleDAO = new RoleDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int id = Integer.parseInt(req.getParameter("id"));

        req.setAttribute("userRow", adminUserDAO.findUserById(id));
        req.setAttribute("roles", roleDAO.listRoles());

        req.getRequestDispatcher("/WEB-INF/views/admin/user_edit.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        try {
            int userId = Integer.parseInt(req.getParameter("userId"));
            String username = req.getParameter("username");
            String fullName = req.getParameter("fullName");
            int roleId = Integer.parseInt(req.getParameter("roleId"));
            int isActive = Integer.parseInt(req.getParameter("isActive"));

            adminUserDAO.updateUser(userId, username.trim(), fullName.trim(), roleId, isActive);

            int adminId = (int) req.getSession(false).getAttribute("userId");
            new lk.oceanviewresort.dao.AuditDAO().log(adminId, "UPDATE_USER", "UserId=" + userId);

            resp.sendRedirect(req.getContextPath() + "/app/admin/users?msg=User updated");
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/app/admin/users?error=Update failed");
        }
    }
}

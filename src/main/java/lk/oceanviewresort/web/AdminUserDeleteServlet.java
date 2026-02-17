package lk.oceanviewresort.web;

import lk.oceanviewresort.dao.AdminUserDAO;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/app/admin/user/delete")
public class AdminUserDeleteServlet extends HttpServlet {

    private final AdminUserDAO adminUserDAO = new AdminUserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        try {
            int id = Integer.parseInt(req.getParameter("id"));

            boolean ok = adminUserDAO.deleteUserHard(id);

            int adminId = (int) req.getSession(false).getAttribute("userId");
            new lk.oceanviewresort.dao.AuditDAO().log(adminId, "DELETE_USER", "UserId=" + id);

            if (ok) resp.sendRedirect(req.getContextPath() + "/app/admin/users?msg=User deleted");
            else resp.sendRedirect(req.getContextPath() + "/app/admin/users?error=User not found");

        } catch (SQLException ex) {
            resp.sendRedirect(req.getContextPath() + "/app/admin/users?error=Cannot delete user (has records). Disable user instead.");
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/app/admin/users?error=Delete failed");
        }
    }
}

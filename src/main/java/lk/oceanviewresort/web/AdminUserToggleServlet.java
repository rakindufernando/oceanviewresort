package lk.oceanviewresort.web;

import lk.oceanviewresort.dao.AdminUserDAO;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/app/admin/user/toggle")
public class AdminUserToggleServlet extends HttpServlet {

    private final AdminUserDAO adminUserDAO = new AdminUserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            int active = Integer.parseInt(req.getParameter("active"));

            adminUserDAO.toggleActive(id, active);

            int adminId = (int) req.getSession(false).getAttribute("userId");
            new lk.oceanviewresort.dao.AuditDAO().log(adminId, "TOGGLE_USER", "UserId=" + id + ", Active=" + active);

            resp.sendRedirect(req.getContextPath() + "/app/admin/users?msg=User updated");
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/app/admin/users?error=Action failed");
        }
    }
}

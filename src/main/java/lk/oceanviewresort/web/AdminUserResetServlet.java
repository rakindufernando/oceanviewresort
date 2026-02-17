package lk.oceanviewresort.web;

import lk.oceanviewresort.dao.AdminUserDAO;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/app/admin/user/reset")
public class AdminUserResetServlet extends HttpServlet {

    private final AdminUserDAO adminUserDAO = new AdminUserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));

            adminUserDAO.resetPassword(id, "ocean123");

            int adminId = (int) req.getSession(false).getAttribute("userId");
            new lk.oceanviewresort.dao.AuditDAO().log(adminId, "RESET_PASSWORD", "UserId=" + id);

            resp.sendRedirect(req.getContextPath() + "/app/admin/users?msg=Password reset to ocean123");
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/app/admin/users?error=Reset failed");
        }
    }
}

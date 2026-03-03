package lk.oceanviewresort.web;

import lk.oceanviewresort.dao.AdminUserDAO;
import lk.oceanviewresort.dao.AuditDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.Calendar;
import java.util.List;

@WebServlet({"/app/admin/staff-activity", "/app/manager/staff-activity"})
public class StaffActivityServlet extends HttpServlet {

    private final AuditDAO auditDAO = new AuditDAO();
    private final AdminUserDAO adminUserDAO = new AdminUserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String userIdStr = trim(req.getParameter("userId"));
        String fromStr = trim(req.getParameter("from"));
        String toStr = trim(req.getParameter("to"));
        String keyword = trim(req.getParameter("q"));

        Integer userId = null;
        if (!userIdStr.isEmpty() && userIdStr.matches("\\d+")) userId = Integer.parseInt(userIdStr);

        Date fromDate = parseSqlDate(fromStr);
        Date toDate = parseSqlDate(toStr);

        int limit = 200;
        String limitStr = trim(req.getParameter("limit"));
        if (!limitStr.isEmpty() && limitStr.matches("\\d+")) limit = Integer.parseInt(limitStr);

        boolean noFilters = userId == null && fromDate == null && toDate == null && keyword.isEmpty();
        String todayParam = trim(req.getParameter("today"));

        if (noFilters || "1".equals(todayParam)) {
            Date today = getToday();
            fromDate = today;
            toDate = today;
            req.setAttribute("defaultToday", true);
        }

        List<String[]> logs = auditDAO.listLogs(userId, fromDate, toDate, keyword, limit);
        List<String[]> users = adminUserDAO.listUsers();

        req.setAttribute("logs", logs);
        req.setAttribute("users", users);

        String actionUrl = req.getContextPath() + req.getServletPath();
        req.setAttribute("actionUrl", actionUrl);

        req.getRequestDispatcher("/WEB-INF/views/staff_activity.jsp").forward(req, resp);
    }

    private Date getToday() {
        Calendar c = Calendar.getInstance();
        int y = c.get(Calendar.YEAR);
        int m = c.get(Calendar.MONTH) + 1;
        int d = c.get(Calendar.DAY_OF_MONTH);

        String mm = (m < 10 ? "0" : "") + m;
        String dd = (d < 10 ? "0" : "") + d;

        return Date.valueOf(y + "-" + mm + "-" + dd);
    }

    private Date parseSqlDate(String s) {
        if (s == null || s.trim().isEmpty()) return null;
        try {
            return Date.valueOf(s.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private String trim(String s) {
        if (s == null) return "";
        return s.trim();
    }
}
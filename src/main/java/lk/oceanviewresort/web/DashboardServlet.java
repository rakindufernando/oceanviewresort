package lk.oceanviewresort.web;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/app/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        HttpSession session = req.getSession(false);
        String fullName = (String) session.getAttribute("fullName");
        String role = (String) session.getAttribute("role");

        resp.setContentType("text/html; charset=UTF-8");
        PrintWriter out = resp.getWriter();

        String ctx = req.getContextPath();

        out.println("<!DOCTYPE html><html><head>");
        out.println("<meta charset='UTF-8'>");
        out.println("<meta name='viewport' content='width=device-width, initial-scale=1.0'>");
        out.println("<title>Dashboard</title>");
        out.println("<link rel='stylesheet' href='" + req.getContextPath() + "/assets/app.css'>");
        out.println("<script src='" + req.getContextPath() + "/assets/app.js' defer></script>");
        out.println("</head><body class='dashboard-servlet'>");
        out.println("<div class='container'>");
        out.println("<h1>Ocean View Resort - Dashboard</h1>");
        out.println("<p>Welcome: " + fullName + " (" + role + ")</p>");

        String err = req.getParameter("error");
        if (err != null) out.println("<p style='color:red;'>" + err + "</p>");

        out.println("<p><a href='" + req.getContextPath() + "/logout'>Logout</a></p>");
        out.println("<hr>");

        out.println("<h3>Common</h3><ul>");
        out.println("<li><a href='" + req.getContextPath() + "/app/help'>Help</a></li>");
        out.println("</ul>");

        if ("RECEPTIONIST".equals(role)) {
            out.println("<h3>Receptionist Functions</h3><ul>");
            out.println("<li><a href='" + req.getContextPath() + "/app/reception/guests'>Guest Management</a></li>");
            out.println("<li><a href='" + req.getContextPath() + "/app/reception/reservations'>Reservation Management</a></li>");
            out.println("<li><a href='" + req.getContextPath() + "/app/reception/billing'>Billing + Payments</a></li>");
            out.println("</ul>");
        }

        if ("MANAGER".equals(role)) {
            out.println("<h3>Manager Functions</h3><ul>");
            out.println("<li><a href='" + req.getContextPath() + "/app/manager/reservations'>View Reservations</a></li>");
            out.println("<li><a href='" + req.getContextPath() + "/app/manager/reports'>Reports</a></li>");
            out.println("</ul>");
        }

        if ("ADMIN".equals(role)) {
            out.println("<h3>Admin Functions</h3><ul>");
            out.println("<li><a href='" + req.getContextPath() + "/app/admin/users'>User Management</a></li>");
            out.println("<li><a href='" + req.getContextPath() + "/app/admin/reservations'>Delete Reservations</a></li>");
            out.println("<li><a href='" + req.getContextPath() + "/app/admin/transactions'>Transactions</a></li>");
            out.println("<li><a href='" + req.getContextPath() + "/app/admin/reports'>Reports</a></li>");
            out.println("</ul>");
        }

        out.println("<script src='" + ctx + "/assets/app.js'></script>");
        out.println("</body></html>");

    }
}

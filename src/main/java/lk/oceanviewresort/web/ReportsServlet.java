package lk.oceanviewresort.web;

import lk.oceanviewresort.dao.ReportDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

@WebServlet({"/app/manager/reports", "/app/admin/reports"})
public class ReportsServlet extends HttpServlet {

    private final ReportDAO reportDAO = new ReportDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String fromS = req.getParameter("from");
        String toS = req.getParameter("to");

        req.setAttribute("msg", req.getParameter("msg"));
        req.setAttribute("error", req.getParameter("error"));

        if (fromS != null && toS != null && !fromS.isEmpty() && !toS.isEmpty()) {
            try {
                LocalDate from = LocalDate.parse(fromS);
                LocalDate to = LocalDate.parse(toS);

                if (!to.isAfter(from)) {
                    req.setAttribute("error", "To date must be after From date.");
                } else {
                    long days = ChronoUnit.DAYS.between(from, to);
                    req.setAttribute("days", days);

                    req.setAttribute("occ", reportDAO.occupancyReport(from, to));
                    req.setAttribute("rev", reportDAO.revenueReport(from, to));
                    req.setAttribute("statusSummary", reportDAO.reservationStatusSummary());
                    req.setAttribute("resList", reportDAO.reservationList(from, to));
                }

            } catch (Exception e) {
                req.setAttribute("error", "Invalid dates.");
            }
        }

        req.getRequestDispatcher("/WEB-INF/views/reports.jsp").forward(req, resp);
    }
}

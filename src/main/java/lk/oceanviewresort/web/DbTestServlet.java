package lk.oceanviewresort.web;

import lk.oceanviewresort.util.DBUtil;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/dbtest")
public class DbTestServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("text/plain; charset=UTF-8");
        try {
            DBUtil.getConnection().close();
            resp.getWriter().println("DB Connection OK!");
        } catch (Exception e) {
            resp.getWriter().println("DB Connection FAILED: " + e.getMessage());
        }
    }
}

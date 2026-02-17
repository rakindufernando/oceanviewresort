package lk.oceanviewresort.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String uri = req.getRequestURI();
        String ctx = req.getContextPath();


        if (uri.equals(ctx + "/") ||
                uri.equals(ctx + "/index.html") ||
                uri.equals(ctx + "/login") ||
                uri.equals(ctx + "/logout") ||
                uri.startsWith(ctx + "/assets/") ||
                uri.startsWith(ctx + "/hello") ||
                uri.startsWith(ctx + "/dbtest")) {
            chain.doFilter(request, response);
            return;
        }


        if (uri.startsWith(ctx + "/app")) {
            HttpSession session = req.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                resp.sendRedirect(ctx + "/login");
                return;
            }

            String role = (String) session.getAttribute("role");
            if (role == null) role = "";

            if (uri.startsWith(ctx + "/app/admin") && !role.equals("ADMIN")) {
                resp.sendRedirect(ctx + "/app/dashboard?error=Access denied");
                return;
            }
            if (uri.startsWith(ctx + "/app/reception") && !role.equals("RECEPTIONIST")) {
                resp.sendRedirect(ctx + "/app/dashboard?error=Access denied");
                return;
            }
            if (uri.startsWith(ctx + "/app/manager") && !role.equals("MANAGER")) {
                resp.sendRedirect(ctx + "/app/dashboard?error=Access denied");
                return;
            }
        }

        chain.doFilter(request, response);
    }
}

package com.forensafe.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    private static final String[] PUBLIC = {"/login", "/LoginServlet", "/css/", "/js/", "/images/"};

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest  request  = (HttpServletRequest)  req;
        HttpServletResponse response = (HttpServletResponse) res;

        String uri = request.getRequestURI();
        String ctx = request.getContextPath();
        String path = uri.substring(ctx.length());

        // Allow public resources
        for (String pub : PUBLIC) {
            if (path.startsWith(pub)) { chain.doFilter(req, res); return; }
        }

        // Check session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("officer") == null) {
            response.sendRedirect(ctx + "/login");
            return;
        }

        // Prevent caching of protected pages
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        chain.doFilter(req, res);
    }

    @Override public void init(FilterConfig fc) {}
    @Override public void destroy() {}
}

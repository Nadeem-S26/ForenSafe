package com.forensafe.servlet;

import com.forensafe.dao.OfficerDAO;
import com.forensafe.model.Officer;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/officers")
public class OfficerServlet extends HttpServlet {

    private final OfficerDAO dao = new OfficerDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "add":
                    req.getRequestDispatcher("/jsp/officer_form.jsp").forward(req, resp);
                    return;
                case "edit": {
                    req.setAttribute("officerObj", dao.getById(req.getParameter("id")));
                    req.getRequestDispatcher("/jsp/officer_form.jsp").forward(req, resp);
                    return;
                }
                case "delete": {
                    dao.delete(req.getParameter("id"));
                    resp.sendRedirect(req.getContextPath() + "/officers?msg=deleted");
                    return;
                }
            }
            req.setAttribute("officers", dao.getAllOfficers());
            req.getRequestDispatcher("/jsp/officers.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/jsp/officers.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        boolean isNew = (req.getParameter("isNew") != null);

        Officer o = new Officer();
        o.setOfficerId(req.getParameter("officerId"));
        o.setFirstName(req.getParameter("firstName"));
        o.setLastName(req.getParameter("lastName"));
        o.setDesignation(req.getParameter("designation"));
        o.setDepartment(req.getParameter("department"));
        o.setPhone(req.getParameter("phone"));
        o.setEmail(req.getParameter("email"));
        o.setRole(req.getParameter("role"));
        o.setUsername(req.getParameter("username"));
        o.setPassword(req.getParameter("password"));

        try {
            if (isNew) dao.insert(o); else dao.update(o);
            resp.sendRedirect(req.getContextPath() + "/officers?msg=" + (isNew ? "added" : "updated"));
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.setAttribute("officerObj", o);
            req.getRequestDispatcher("/jsp/officer_form.jsp").forward(req, resp);
        }
    }
}

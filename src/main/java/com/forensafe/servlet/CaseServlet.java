package com.forensafe.servlet;

import com.forensafe.dao.CaseDAO;
import com.forensafe.model.Case;
import com.forensafe.model.Officer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/cases")
public class CaseServlet extends HttpServlet {

    private final CaseDAO dao = new CaseDAO();

    // ── List / Search ──────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "add":
                    req.getRequestDispatcher("/jsp/case_form.jsp").forward(req, resp);
                    return;
                case "edit": {
                    Case c = dao.getById(req.getParameter("id"));
                    req.setAttribute("caseObj", c);
                    req.getRequestDispatcher("/jsp/case_form.jsp").forward(req, resp);
                    return;
                }
                case "delete": {
                    requireAdmin(req, resp);
                    dao.delete(req.getParameter("id"));
                    resp.sendRedirect(req.getContextPath() + "/cases?msg=deleted");
                    return;
                }
                case "view": {
                    Case c = dao.getById(req.getParameter("id"));
                    req.setAttribute("caseObj", c);
                    req.getRequestDispatcher("/jsp/case_detail.jsp").forward(req, resp);
                    return;
                }
            }

            // Default: list with optional filter
            String status    = req.getParameter("status");
            String dateFrom  = req.getParameter("dateFrom");
            String dateTo    = req.getParameter("dateTo");

            if (status != null && !status.isEmpty()) {
                req.setAttribute("cases", dao.getByStatus(status));
                req.setAttribute("filterStatus", status);
            } else if (dateFrom != null && !dateFrom.isEmpty() && dateTo != null && !dateTo.isEmpty()) {
                req.setAttribute("cases", dao.getByDateRange(Date.valueOf(dateFrom), Date.valueOf(dateTo)));
                req.setAttribute("filterFrom", dateFrom);
                req.setAttribute("filterTo", dateTo);
            } else {
                req.setAttribute("cases", dao.getAllCases());
            }
            req.getRequestDispatcher("/jsp/cases.jsp").forward(req, resp);

        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/jsp/cases.jsp").forward(req, resp);
        }
    }

    // ── Save (Insert or Update) ────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String caseId = req.getParameter("caseId");
        boolean isNew = "1".equals(req.getParameter("isNew"));

        Case c = new Case();
        c.setCaseId(caseId);
        c.setCaseTitle(req.getParameter("caseTitle"));
        c.setCrimeType(req.getParameter("crimeType"));
        c.setDescription(req.getParameter("description"));
        c.setDateRegistered(Date.valueOf(req.getParameter("dateRegistered")));
        c.setStatus(req.getParameter("status"));
        c.setStreet(req.getParameter("street"));
        c.setArea(req.getParameter("area"));
        c.setPincode(req.getParameter("pincode"));

        try {
            if (isNew) dao.insert(c); else dao.update(c);
            resp.sendRedirect(req.getContextPath() + "/cases?msg=" + (isNew ? "added" : "updated"));
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.setAttribute("caseObj", c);
            req.getRequestDispatcher("/jsp/case_form.jsp").forward(req, resp);
        }
    }

    private void requireAdmin(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        Officer o = (Officer) req.getSession().getAttribute("officer");
        if (o == null || !"admin".equals(o.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Admin only.");
        }
    }
}

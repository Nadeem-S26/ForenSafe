package com.forensafe.servlet;

import com.forensafe.dao.AuditDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/audit")
public class AuditServlet extends HttpServlet {
    private final AuditDAO dao = new AuditDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String fromDate = req.getParameter("from");
        String toDate   = req.getParameter("to");
        try {
            req.setAttribute("activeCases",      dao.getActiveCases());
            req.setAttribute("auditResults",     dao.getCaseEvidenceAudit());
            req.setAttribute("noEvidenceCases",  dao.getCasesWithNoEvidence());
            if (fromDate != null && !fromDate.isEmpty() && toDate != null && !toDate.isEmpty()) {
                req.setAttribute("rangeResults", dao.getCasesByDateRange(fromDate, toDate));
                req.setAttribute("filterFrom",   fromDate);
                req.setAttribute("filterTo",     toDate);
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
        }
        req.getRequestDispatcher("/jsp/audit.jsp").forward(req, resp);
    }
}

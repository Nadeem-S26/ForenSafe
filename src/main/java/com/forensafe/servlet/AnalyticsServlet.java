// ── AnalyticsServlet.java ─────────────────────────────────────
package com.forensafe.servlet;

import com.forensafe.dao.AnalyticsDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/analytics")
public class AnalyticsServlet extends HttpServlet {
    private final AnalyticsDAO dao = new AnalyticsDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("statusPercentage",       dao.getCaseStatusPercentage());
            req.setAttribute("activeOfficers",         dao.getActiveOfficers());
            req.setAttribute("casesAboveAvg",          dao.getCasesAboveAvgEvidence());
            req.setAttribute("topOfficers",            dao.getTopOfficerByTransfers());
            req.setAttribute("transferParticipants",   dao.getTransferParticipants());
            req.setAttribute("evidenceIntersect",      dao.getEvidenceWithReportAndTransfer());
            req.setAttribute("summaryCounts",          dao.getSummaryCounts());
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
        }
        req.getRequestDispatcher("/jsp/analytics.jsp").forward(req, resp);
    }
}

package com.forensafe.servlet;

import com.forensafe.dao.IntelligenceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/intelligence")
public class IntelligenceServlet extends HttpServlet {
    private final IntelligenceDAO dao = new IntelligenceDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("untouchedEvidence",  dao.getUntouchedEvidence());
            req.setAttribute("evidenceSummary",    dao.getEvidenceSummary());
            req.setAttribute("evidenceAlerts",     dao.getEvidenceWithAlertLevel());
            req.setAttribute("fullyDocumented",    dao.getFullyDocumented());
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
        }
        req.getRequestDispatcher("/jsp/intelligence.jsp").forward(req, resp);
    }
}

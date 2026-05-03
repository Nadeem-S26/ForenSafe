package com.forensafe.servlet;

import com.forensafe.dao.OverdueEvidenceDAO;
import com.forensafe.dao.OverdueEvidenceDAO.OverdueItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * ============================================================
 *  OverdueEvidenceServlet
 *  URL: /forensafe/overdue
 *
 *  Calls sp_cursor_overdue_evidence() via OverdueEvidenceDAO
 *  and forwards results to overdue_alerts.jsp.
 *
 *  Also supports JSON output for the frontend web app via
 *  ?format=json — returns alert data as JSON array.
 * ============================================================
 */
@WebServlet("/overdue")
public class OverdueEvidenceServlet extends HttpServlet {

    private final OverdueEvidenceDAO dao = new OverdueEvidenceDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String format = req.getParameter("format");

        try {
            List<OverdueItem> items = dao.getOverdueEvidence();

            // ── JSON response (for frontend fetch API) ─────────────
            if ("json".equals(format)) {
                resp.setContentType("application/json;charset=UTF-8");
                resp.setHeader("Cache-Control", "no-cache");

                StringBuilder json = new StringBuilder("[");
                for (int i = 0; i < items.size(); i++) {
                    OverdueItem it = items.get(i);
                    if (i > 0) json.append(",");
                    json.append("{")
                        .append("\"evidenceId\":\"").append(escape(it.getEvidenceId())).append("\",")
                        .append("\"evidenceType\":\"").append(escape(it.getEvidenceType())).append("\",")
                        .append("\"caseId\":\"").append(escape(it.getCaseId())).append("\",")
                        .append("\"daysStuck\":").append(it.getDaysStuck()).append(",")
                        .append("\"lastMovement\":\"").append(escape(it.getLastMovement())).append("\",")
                        .append("\"alertLevel\":\"").append(escape(it.getAlertLevel())).append("\"")
                        .append("}");
                }
                json.append("]");
                resp.getWriter().write(json.toString());
                return;
            }

            // ── JSP response ───────────────────────────────────────
            int critical = (int) items.stream().filter(i -> "CRITICAL".equals(i.getAlertLevel())).count();
            int warning  = (int) items.stream().filter(i -> "WARNING".equals(i.getAlertLevel())).count();
            int notice   = (int) items.stream().filter(i -> "NOTICE".equals(i.getAlertLevel())).count();

            req.setAttribute("overdueItems",   items);
            req.setAttribute("totalOverdue",   items.size());
            req.setAttribute("criticalCount",  critical);
            req.setAttribute("warningCount",   warning);
            req.setAttribute("noticeCount",    notice);

            req.getRequestDispatcher("/jsp/overdue_alerts.jsp").forward(req, resp);

        } catch (Exception e) {
            if ("json".equals(format)) {
                resp.setContentType("application/json;charset=UTF-8");
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                resp.getWriter().write("{\"error\":\"" + escape(e.getMessage()) + "\"}");
            } else {
                req.setAttribute("error", "Failed to load overdue alerts: " + e.getMessage());
                req.getRequestDispatcher("/jsp/overdue_alerts.jsp").forward(req, resp);
            }
        }
    }

    /** Escape special chars for JSON string values */
    private String escape(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}

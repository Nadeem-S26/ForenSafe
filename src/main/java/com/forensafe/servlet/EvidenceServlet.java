package com.forensafe.servlet;

import com.forensafe.dao.CaseDAO;
import com.forensafe.dao.EvidenceDAO;
import com.forensafe.dao.OfficerDAO;
import com.forensafe.model.CustodyTransfer;
import com.forensafe.model.Evidence;
import com.forensafe.util.HashUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Timestamp;

@WebServlet("/evidence")
public class EvidenceServlet extends HttpServlet {

    private final EvidenceDAO dao = new EvidenceDAO();
    private final CaseDAO caseDAO = new CaseDAO();
    private final OfficerDAO offDAO = new OfficerDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null)
            action = "list";

        try {
            switch (action) {
                case "add":
                    req.setAttribute("cases", caseDAO.getAllCases());
                    req.getRequestDispatcher("/jsp/evidence_form.jsp").forward(req, resp);
                    return;
                case "edit": {
                    String evId = req.getParameter("id");
                    req.setAttribute("evidenceObj", dao.getById(evId));
                    req.setAttribute("cases", caseDAO.getAllCases());
                    req.getRequestDispatcher("/jsp/evidence_form.jsp").forward(req, resp);
                    return;
                }
                case "chain": {
                    String evId = req.getParameter("id");
                    req.setAttribute("evidence", dao.getById(evId));
                    req.setAttribute("chain", dao.getCustodyChain(evId));
                    req.setAttribute("officers", offDAO.getAllOfficers());
                    req.getRequestDispatcher("/jsp/custody_chain.jsp").forward(req, resp);
                    return;
                }
                case "delete": {
                    dao.delete(req.getParameter("id"));
                    resp.sendRedirect(req.getContextPath() + "/evidence?msg=deleted");
                    return;
                }
                case "byCase": {
                    String caseId = req.getParameter("caseId");
                    req.setAttribute("evidence", dao.getByCase(caseId));
                    req.setAttribute("caseObj", caseDAO.getById(caseId));
                    req.getRequestDispatcher("/jsp/evidence_list.jsp").forward(req, resp);
                    return;
                }
            }
            req.setAttribute("evidence", dao.getAll());
            req.getRequestDispatcher("/jsp/evidence_list.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/jsp/evidence_list.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        // ── Quick status update (AJAX-friendly) ───────────────────
        if ("updateStatus".equals(action)) {
            String evidenceId = req.getParameter("evidenceId");
            String status = req.getParameter("status");
            String[] valid = { "Collected", "In Lab", "Stored", "Released" };
            boolean ok = false;
            for (String v : valid) {
                if (v.equals(status)) {
                    ok = true;
                    break;
                }
            }
            try {
                if (ok && evidenceId != null && !evidenceId.isEmpty()) {
                    dao.updateStatus(evidenceId, status);
                    // If called via AJAX, return JSON
                    String accept = req.getHeader("Accept");
                    if (accept != null && accept.contains("application/json")) {
                        resp.setContentType("application/json");
                        resp.getWriter().write("{\"success\":true}");
                    } else {
                        String ref = req.getHeader("Referer");
                        resp.sendRedirect(ref != null ? ref : req.getContextPath() + "/evidence?msg=updated");
                    }
                } else {
                    resp.sendError(400, "Invalid status value.");
                }
            } catch (Exception e) {
                resp.sendError(500, e.getMessage());
            }
            return;
        }

        // ── Custody transfer ───────────────────────────────────────
        if ("transfer".equals(action)) {
            CustodyTransfer ct = new CustodyTransfer();
            ct.setEvidenceId(req.getParameter("evidenceId"));
            ct.setFromOfficerId(req.getParameter("fromOfficerId"));
            ct.setToOfficerId(req.getParameter("toOfficerId"));
            ct.setTransferDatetime(new Timestamp(System.currentTimeMillis()));
            ct.setPurpose(req.getParameter("purpose"));
            ct.setRemarks(req.getParameter("remarks"));
            try {
                dao.addCustodyTransfer(ct);
                resp.sendRedirect(req.getContextPath()
                        + "/evidence?action=chain&id=" + ct.getEvidenceId() + "&msg=transferred");
            } catch (Exception e) {
                req.setAttribute("error", e.getMessage());
                try {
                    req.setAttribute("evidence", dao.getById(ct.getEvidenceId()));
                    req.setAttribute("chain", dao.getCustodyChain(ct.getEvidenceId()));
                    req.setAttribute("officers", offDAO.getAllOfficers());
                } catch (Exception ignored) {
                }
                req.getRequestDispatcher("/jsp/custody_chain.jsp").forward(req, resp);
            }
            return;
        }

        // ── Add/Edit Evidence ───────────────────────────────────────────
        try {
            boolean isNew = "1".equals(req.getParameter("isNew"));
            Evidence e = new Evidence();
            e.setEvidenceId(req.getParameter("evidenceId"));
            e.setCaseId(req.getParameter("caseId"));
            e.setStorageId(req.getParameter("storageId"));
            e.setEvidenceType(req.getParameter("evidenceType"));
            e.setDescription(req.getParameter("description"));
            e.setSerialNumber(req.getParameter("serialNumber"));
            e.setSeizedDate(Date.valueOf(req.getParameter("seizedDate")));
            e.setSeizedStreet(req.getParameter("seizedStreet"));
            e.setSeizedArea(req.getParameter("seizedArea"));
            e.setSeizedPincode(req.getParameter("seizedPincode"));
            e.setCurrentStatus(req.getParameter("currentStatus"));

            String manualHash = req.getParameter("hashValue");
            if (manualHash == null || manualHash.trim().isEmpty()) {
                String autoHash = HashUtil.generateEvidenceHash(
                        e.getEvidenceId(), e.getEvidenceType(),
                        req.getParameter("seizedDate"), e.getSerialNumber());
                e.setHashValue(autoHash);
            } else {
                e.setHashValue(manualHash.trim());
            }

            if (isNew)
                dao.insert(e);
            else
                dao.update(e);
            resp.sendRedirect(req.getContextPath() + "/evidence?msg=" + (isNew ? "added" : "updated"));
        } catch (Exception ex) {
            req.setAttribute("error", ex.getMessage());
            try {
                req.setAttribute("cases", caseDAO.getAllCases());
            } catch (SQLException ignored) {
            }
            req.getRequestDispatcher("/jsp/evidence_form.jsp").forward(req, resp);
        }
    }
}

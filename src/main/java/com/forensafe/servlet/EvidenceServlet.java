package com.forensafe.servlet;

import com.forensafe.dao.CaseDAO;
import com.forensafe.dao.EvidenceDAO;
import com.forensafe.dao.OfficerDAO;
import com.forensafe.model.CustodyTransfer;
import com.forensafe.model.Evidence;
import com.forensafe.util.HashUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Timestamp;

@WebServlet("/evidence")
public class EvidenceServlet extends HttpServlet {

    private final EvidenceDAO dao     = new EvidenceDAO();
    private final CaseDAO     caseDAO = new CaseDAO();
    private final OfficerDAO  offDAO  = new OfficerDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "add":
                    req.setAttribute("cases", caseDAO.getAllCases());
                    req.getRequestDispatcher("/jsp/evidence_form.jsp").forward(req, resp);
                    return;
                case "chain": {
                    String evId = req.getParameter("id");
                    req.setAttribute("evidence", dao.getById(evId));
                    req.setAttribute("chain",    dao.getCustodyChain(evId));
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
                    req.setAttribute("caseObj",  caseDAO.getById(caseId));
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

        try {
            if ("transfer".equals(action)) {
                CustodyTransfer ct = new CustodyTransfer();
                ct.setEvidenceId(req.getParameter("evidenceId"));
                ct.setFromOfficerId(req.getParameter("fromOfficerId"));
                ct.setToOfficerId(req.getParameter("toOfficerId"));
                ct.setTransferDatetime(new Timestamp(System.currentTimeMillis()));
                ct.setPurpose(req.getParameter("purpose"));
                ct.setRemarks(req.getParameter("remarks"));
                dao.addCustodyTransfer(ct);
                resp.sendRedirect(req.getContextPath()
                    + "/evidence?action=chain&id=" + ct.getEvidenceId() + "&msg=transferred");
                return;
            }

            // ── Build Evidence object ──────────────────────────────
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

            // ── AUTO-GENERATE HASH if not provided ─────────────────
            String manualHash = req.getParameter("hashValue");
            if (manualHash == null || manualHash.trim().isEmpty()) {
                // Auto-generate SHA-256 from evidence metadata
                String autoHash = HashUtil.generateEvidenceHash(
                    e.getEvidenceId(),
                    e.getEvidenceType(),
                    req.getParameter("seizedDate"),
                    e.getSerialNumber()
                );
                e.setHashValue(autoHash);
                System.out.println("[FORENSAFE] 🔑 Auto-generated SHA-256 hash for evidence "
                    + e.getEvidenceId() + ": " + autoHash);
                // Tell JSP so we can show a success note
                req.getSession().setAttribute("lastAutoHash", autoHash);
                req.getSession().setAttribute("lastHashEvidenceId", e.getEvidenceId());
            } else {
                e.setHashValue(manualHash.trim());
                System.out.println("[FORENSAFE] 🔑 Manual hash used for evidence "
                    + e.getEvidenceId() + ": " + manualHash.trim());
            }

            dao.insert(e);
            resp.sendRedirect(req.getContextPath() + "/evidence?msg=added");

        } catch (Exception ex) {
            req.setAttribute("error", ex.getMessage());
            try {
                req.setAttribute("cases", caseDAO.getAllCases());
            } catch (SQLException e) {
                e.printStackTrace();
            }
            req.getRequestDispatcher("/jsp/evidence_form.jsp").forward(req, resp);
        }
    }
}

package com.forensafe.servlet;

import com.forensafe.dao.CaseDAO;
import com.forensafe.dao.EvidenceDAO;
import com.forensafe.dao.OfficerDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            CaseDAO    caseDAO     = new CaseDAO();
            EvidenceDAO evidDAO   = new EvidenceDAO();
            OfficerDAO  officerDAO = new OfficerDAO();

            req.setAttribute("totalCases",       caseDAO.countAll());
            req.setAttribute("openCases",         caseDAO.countByStatus("Open"));
            req.setAttribute("activeCases",       caseDAO.countByStatus("Under Investigation"));
            req.setAttribute("closedCases",       caseDAO.countByStatus("Closed"));
            req.setAttribute("totalEvidence",     evidDAO.countAll());
            req.setAttribute("totalOfficers",     officerDAO.count());
            req.setAttribute("recentCases",       caseDAO.getAllCases().subList(0,
                                                    Math.min(5, caseDAO.getAllCases().size())));
            List<Object[]> monthly = caseDAO.getMonthlyCaseCounts();
            req.setAttribute("monthlyData",       monthly);

        } catch (Exception e) {
            req.setAttribute("dbError", e.getMessage());
        }
        req.getRequestDispatcher("/jsp/dashboard.jsp").forward(req, resp);
    }
}

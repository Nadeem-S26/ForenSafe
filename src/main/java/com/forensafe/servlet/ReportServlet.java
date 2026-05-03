package com.forensafe.servlet;

import com.forensafe.dao.CaseDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/reports")
public class ReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String type = req.getParameter("type");
        CaseDAO dao = new CaseDAO();
        try {
            if ("active".equals(type)) {
                req.setAttribute("cases",      dao.getByStatus("Open"));
                req.setAttribute("reportTitle","Active (Open) Cases");
            } else if ("investigation".equals(type)) {
                req.setAttribute("cases",      dao.getByStatus("Under Investigation"));
                req.setAttribute("reportTitle","Cases Under Investigation");
            } else if ("closed".equals(type)) {
                req.setAttribute("cases",      dao.getByStatus("Closed"));
                req.setAttribute("reportTitle","Closed Cases");
            } else if ("range".equals(type)) {
                String from = req.getParameter("from");
                String to   = req.getParameter("to");
                if (from != null && to != null && !from.isEmpty()) {
                    req.setAttribute("cases", dao.getByDateRange(Date.valueOf(from), Date.valueOf(to)));
                    req.setAttribute("reportTitle", "Cases from " + from + " to " + to);
                } else {
                    req.setAttribute("cases", dao.getAllCases());
                    req.setAttribute("reportTitle","All Cases");
                }
            } else {
                req.setAttribute("cases",      dao.getAllCases());
                req.setAttribute("reportTitle","All Cases Report");
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
        }
        req.getRequestDispatcher("/jsp/reports.jsp").forward(req, resp);
    }
}

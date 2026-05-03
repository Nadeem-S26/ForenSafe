package com.forensafe.servlet;

import com.forensafe.dao.WorkloadDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/workload")
public class WorkloadServlet extends HttpServlet {
    private final WorkloadDAO dao = new WorkloadDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("officerWorkload",  dao.getOfficerWorkload());
            req.setAttribute("transferSummary",  dao.getOfficerTransferSummary());
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
        }
        req.getRequestDispatcher("/jsp/workload.jsp").forward(req, resp);
    }
}

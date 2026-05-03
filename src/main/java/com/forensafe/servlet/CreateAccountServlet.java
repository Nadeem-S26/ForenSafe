package com.forensafe.servlet;

import com.forensafe.dao.OfficerDAO;
import com.forensafe.model.Officer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * ============================================================
 *  CreateAccountServlet
 *  URL: /forensafe/create-account
 *  Admin-only: creates a new officer account.
 *  Password is BCrypt-hashed automatically before DB insert.
 * ============================================================
 */
@WebServlet("/create-account")
public class CreateAccountServlet extends HttpServlet {

    private final OfficerDAO dao = new OfficerDAO();

    // ── Show the create account form ───────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Only admin can access
        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }
        req.getRequestDispatcher("/jsp/admin/create_account.jsp").forward(req, resp);
    }

    // ── Process the form submission ────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        req.setCharacterEncoding("UTF-8");

        String officerId  = req.getParameter("officerId").trim();
        String firstName  = req.getParameter("firstName").trim();
        String lastName   = req.getParameter("lastName").trim();
        String designation= req.getParameter("designation").trim();
        String department = req.getParameter("department").trim();
        String phone      = req.getParameter("phone").trim();
        String email      = req.getParameter("email").trim();
        String role       = req.getParameter("role").trim();
        String username   = req.getParameter("username").trim();
        String password   = req.getParameter("password");
        String confirmPwd = req.getParameter("confirmPassword");

        // ── Server-side validation ─────────────────────────────────
        if (officerId.isEmpty() || username.isEmpty() || password.isEmpty()) {
            req.setAttribute("error", "Officer ID, username and password are required.");
            req.getRequestDispatcher("/jsp/admin/create_account.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(confirmPwd)) {
            req.setAttribute("error", "Passwords do not match.");
            req.setAttribute("formData", buildFormData(req));
            req.getRequestDispatcher("/jsp/admin/create_account.jsp").forward(req, resp);
            return;
        }

        if (password.length() < 6) {
            req.setAttribute("error", "Password must be at least 6 characters.");
            req.setAttribute("formData", buildFormData(req));
            req.getRequestDispatcher("/jsp/admin/create_account.jsp").forward(req, resp);
            return;
        }

        // ── Build Officer object ───────────────────────────────────
        // Password will be BCrypt-hashed inside OfficerDAO.insert()
        Officer officer = new Officer();
        officer.setOfficerId(officerId);
        officer.setFirstName(firstName);
        officer.setLastName(lastName);
        officer.setDesignation(designation);
        officer.setDepartment(department);
        officer.setPhone(phone);
        officer.setEmail(email);
        officer.setRole(role);
        officer.setUsername(username);
        officer.setPassword(password);  // plain text — DAO will hash it

        try {
            boolean success = dao.insert(officer);
            if (success) {
                // Log to console for verification
                System.out.println("[FORENSAFE] ✅ New account created by admin: "
                    + username + " | Role: " + role + " | ID: " + officerId);
                req.setAttribute("successMsg",
                    "✅ Account created for " + firstName + " " + lastName
                    + " (username: " + username + "). Password has been encrypted and stored securely.");
                req.getRequestDispatcher("/jsp/admin/create_account.jsp").forward(req, resp);
            } else {
                req.setAttribute("error", "Insert failed. Please try again.");
                req.getRequestDispatcher("/jsp/admin/create_account.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            String msg = e.getMessage();
            if (msg != null && msg.contains("Duplicate")) {
                if (msg.contains("PRIMARY")) {
                    req.setAttribute("error", "Officer ID '" + officerId + "' already exists.");
                } else if (msg.contains("username")) {
                    req.setAttribute("error", "Username '" + username + "' is already taken.");
                } else {
                    req.setAttribute("error", "Duplicate entry: " + msg);
                }
            } else {
                req.setAttribute("error", "Database error: " + msg);
            }
            req.setAttribute("formData", buildFormData(req));
            req.getRequestDispatcher("/jsp/admin/create_account.jsp").forward(req, resp);
        }
    }

    private boolean isAdmin(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return false;
        Officer o = (Officer) session.getAttribute("officer");
        return o != null && "admin".equalsIgnoreCase(o.getRole());
    }

    // Preserve form values on validation error
    private java.util.Map<String, String> buildFormData(HttpServletRequest req) {
        java.util.Map<String, String> map = new java.util.HashMap<>();
        for (String key : new String[]{"officerId","firstName","lastName","designation",
                                       "department","phone","email","role","username"}) {
            map.put(key, req.getParameter(key) != null ? req.getParameter(key) : "");
        }
        return map;
    }
}

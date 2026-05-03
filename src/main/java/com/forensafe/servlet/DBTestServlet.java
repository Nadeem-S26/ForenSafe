package com.forensafe.servlet;

import com.forensafe.util.DBConnection;
import com.forensafe.util.DBConnection.DBStatus;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * ============================================================
 *  DB Verification Page
 *  URL: http://localhost:8080/forensafe/dbtest
 *  Open this in your browser to verify DB connection.
 *  REMOVE or SECURE this servlet before going to production.
 * ============================================================
 */
@WebServlet("/dbtest")
public class DBTestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("text/html;charset=UTF-8");
        DBStatus status = DBConnection.testConnection();

        PrintWriter out = resp.getWriter();
        out.println("<!DOCTYPE html><html><head>");
        out.println("<title>Forensafe – DB Verification</title>");
        out.println("<link href='https://fonts.googleapis.com/css2?family=Share+Tech+Mono&family=Rajdhani:wght@600;700&display=swap' rel='stylesheet'>");
        out.println("<style>");
        out.println("body{background:#0a0d14;color:#e8edf5;font-family:'Share Tech Mono',monospace;padding:40px;margin:0}");
        out.println("h1{font-family:'Rajdhani',sans-serif;font-size:28px;letter-spacing:4px;color:#00d4ff;margin-bottom:6px}");
        out.println("p.sub{color:#6b7a99;font-size:12px;letter-spacing:2px;margin-bottom:30px}");
        out.println(".box{background:#0f1520;border:1px solid rgba(0,212,255,0.15);border-radius:10px;padding:24px;max-width:700px}");
        out.println(".ok  {color:#00ff9d}.fail{color:#ff3860}.info{color:#ffb347}.dim {color:#6b7a99}");
        out.println(".line{padding:4px 0;font-size:13px}");
        out.println(".badge{display:inline-block;padding:6px 20px;border-radius:6px;font-family:'Rajdhani',sans-serif;font-size:16px;font-weight:700;letter-spacing:2px;margin-top:16px}");
        out.println(".badge-ok  {background:rgba(0,255,157,0.15);color:#00ff9d;border:1px solid rgba(0,255,157,0.3)}");
        out.println(".badge-fail{background:rgba(255,56,96,0.15); color:#ff3860;border:1px solid rgba(255,56,96,0.3)}");
        out.println(".meta{display:grid;grid-template-columns:1fr 1fr;gap:10px;margin-bottom:20px;font-size:12px}");
        out.println(".meta-item{background:rgba(0,212,255,0.05);border:1px solid rgba(0,212,255,0.1);border-radius:6px;padding:10px}");
        out.println(".meta-label{color:#6b7a99;font-size:10px;letter-spacing:1.5px;text-transform:uppercase;margin-bottom:4px}");
        out.println(".meta-value{color:#00d4ff}");
        out.println("a.btn{display:inline-block;margin-top:20px;padding:10px 20px;background:#00d4ff;color:#000;border-radius:6px;text-decoration:none;font-family:'Rajdhani',sans-serif;font-weight:700;letter-spacing:1px}");
        out.println("</style></head><body>");

        out.println("<h1>🔐 FORENSAFE</h1>");
        out.println("<p class='sub'>DATABASE CONNECTION VERIFICATION</p>");

        out.println("<div class='box'>");

        // Meta info
        out.println("<div class='meta'>");
        out.println("<div class='meta-item'><div class='meta-label'>Host</div><div class='meta-value'>" + status.host + "</div></div>");
        out.println("<div class='meta-item'><div class='meta-label'>Database</div><div class='meta-value'>" + status.database + "</div></div>");
        out.println("<div class='meta-item'><div class='meta-label'>User</div><div class='meta-value'>" + status.user + "</div></div>");
        out.println("<div class='meta-item'><div class='meta-label'>Server</div><div class='meta-value'>" + (status.serverVersion.isEmpty() ? "—" : status.serverVersion) + "</div></div>");
        out.println("</div>");

        // Messages
        for (String msg : status.messages) {
            String cls = msg.startsWith("✅") || msg.startsWith("🎉") ? "ok"
                       : msg.startsWith("❌") ? "fail"
                       : msg.startsWith("⚠") || msg.startsWith("🔧") ? "info"
                       : msg.startsWith("━") ? "dim"
                       : "dim";
            out.println("<div class='line " + cls + "'>" + escHtml(msg) + "</div>");
        }

        // Overall badge
        if (status.connected && status.allTablesPresent) {
            out.println("<div class='badge badge-ok'>✅ DATABASE OK — READY TO USE</div>");
        } else if (status.connected) {
            out.println("<div class='badge badge-fail'>⚠️ CONNECTED BUT MISSING TABLES</div>");
        } else {
            out.println("<div class='badge badge-fail'>❌ CONNECTION FAILED</div>");
            out.println("<div class='line fail' style='margin-top:10px'>Error: " + escHtml(status.errorMessage) + "</div>");
        }

        out.println("<br><a class='btn' href='" + req.getContextPath() + "/login'>→ Go to Login</a>");
        out.println("</div></body></html>");
    }

    private String escHtml(String s) {
        return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;");
    }
}

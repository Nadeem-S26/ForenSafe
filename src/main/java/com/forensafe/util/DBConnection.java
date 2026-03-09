package com.forensafe.util;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * ============================================================
 *  DBConnection – JDBC utility with live verification
 * ============================================================
 *  CHANGE DB_PASS to your MySQL password before running.
 *  Call DBConnection.testConnection() from a servlet/JSP
 *  to see a full health-check in the browser.
 * ============================================================
 */
public class DBConnection {

    // ── ⚙️  CONFIGURE THESE ──────────────────────────────────────
    private static final String DB_HOST = "localhost";
    private static final String DB_PORT = "3306";
    private static final String DB_NAME = "digital_evidb";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "Mysql@Root@123";   // ← PUT YOUR MYSQL PASSWORD HERE
    // ────────────────────────────────────────────────────────────

    private static final String DB_URL =
        "jdbc:mysql://" + DB_HOST + ":" + DB_PORT + "/" + DB_NAME
        + "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";

    // Load driver once at startup
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("[FORENSAFE-DB] ✅ MySQL JDBC Driver loaded successfully.");
        } catch (ClassNotFoundException e) {
            System.err.println("[FORENSAFE-DB] ❌ MySQL JDBC Driver NOT found: " + e.getMessage());
            throw new RuntimeException("MySQL JDBC Driver not found.", e);
        }
    }

    /** Returns a live connection. Throws SQLException on failure. */
    public static Connection getConnection() throws SQLException {
        try {
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
            // Lightweight ping
            System.out.println("[FORENSAFE-DB] ✅ Connection obtained to database: " + DB_NAME);
            return conn;
        } catch (SQLException e) {
            System.err.println("[FORENSAFE-DB] ❌ Connection FAILED: " + e.getMessage());
            throw e;
        }
    }

    /**
     * Full DB health check.
     * Returns a DBStatus object with human-readable messages.
     * Call this from DBTestServlet to verify everything works.
     */
    public static DBStatus testConnection() {
        DBStatus status = new DBStatus();
        status.host     = DB_HOST + ":" + DB_PORT;
        status.database = DB_NAME;
        status.user     = DB_USER;

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {

            // ── Basic connection ──────────────────────────────
            status.connected = true;
            status.messages.add("✅ Connected to MySQL at " + DB_HOST + ":" + DB_PORT);

            // ── Server version ────────────────────────────────
            DatabaseMetaData meta = conn.getMetaData();
            status.serverVersion = meta.getDatabaseProductVersion();
            status.messages.add("✅ MySQL Server version: " + status.serverVersion);

            // ── Database selected ─────────────────────────────
            String dbCheck = conn.getCatalog();
            status.messages.add("✅ Active database: " + dbCheck);

            // ── Check required tables exist ───────────────────
            String[] requiredTables = {
                "OFFICER", "CASE", "EVIDENCE", "STORAGE_LOCATION",
                "FORENSIC_TOOL", "FORENSIC_REPORT", "CUSTODY_TRANSFER",
                "ACCESS_LOG", "EVIDENCE_MEDIA", "EVIDENCE_ANALYSIS_LOG"
            };

            ResultSet tables = meta.getTables(DB_NAME, null, "%", new String[]{"TABLE"});
            List<String> foundTables = new ArrayList<>();
            while (tables.next()) foundTables.add(tables.getString("TABLE_NAME").toUpperCase());
            tables.close();

            status.messages.add("✅ Tables found in database: " + foundTables.size());

            for (String required : requiredTables) {
                if (foundTables.contains(required.toUpperCase())) {
                    status.messages.add("  ✅ Table exists: " + required);
                } else {
                    status.messages.add("  ❌ MISSING TABLE: " + required);
                    status.missingTables.add(required);
                    status.allTablesPresent = false;
                }
            }

            // ── Row counts ────────────────────────────────────
            String[] countTables = {"OFFICER", "CASE", "EVIDENCE"};
            for (String t : countTables) {
                if (foundTables.contains(t)) {
                    var ps = conn.prepareStatement("SELECT COUNT(*) FROM `" + t + "`");
                    var rs = ps.executeQuery();
                    if (rs.next()) status.messages.add("  📊 " + t + " rows: " + rs.getInt(1));
                    rs.close(); ps.close();
                }
            }

            status.messages.add("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
            if (status.allTablesPresent) {
                status.messages.add("🎉 DATABASE FULLY READY — All tables verified!");
            } else {
                status.messages.add("⚠️  Some tables are missing. Re-run digital_evidb.sql");
            }

        } catch (SQLException e) {
            status.connected = false;
            status.errorMessage = e.getMessage();
            status.messages.add("❌ CONNECTION FAILED: " + e.getMessage());
            status.messages.add("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
            status.messages.add("🔧 CHECK:");
            status.messages.add("   1. MySQL is running (XAMPP / MySQL Service)");
            status.messages.add("   2. DB_PASS in DBConnection.java is correct");
            status.messages.add("   3. Database 'digital_evidb' exists");
            status.messages.add("   4. Port 3306 is not blocked");
        }
        return status;
    }

    /** Simple data class holding the results of testConnection() */
    public static class DBStatus {
        public boolean connected      = false;
        public boolean allTablesPresent = true;
        public String  host           = "";
        public String  database       = "";
        public String  user           = "";
        public String  serverVersion  = "";
        public String  errorMessage   = "";
        public List<String> messages      = new ArrayList<>();
        public List<String> missingTables = new ArrayList<>();
    }

    private DBConnection() {}
}

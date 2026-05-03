package com.forensafe.dao;

import com.forensafe.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * ============================================================
 *  OverdueEvidenceDAO
 *  Calls the MySQL cursor stored procedure:
 *      sp_cursor_overdue_evidence()
 *
 *  Returns evidence items stuck in 'In Lab' status with no
 *  custody movement in over 7 days, flagged by alert level.
 * ============================================================
 */
public class OverdueEvidenceDAO {

    /**
     * Calls sp_cursor_overdue_evidence() and maps results
     * into a list of OverdueItem objects.
     */
    public List<OverdueItem> getOverdueEvidence() throws SQLException {
        List<OverdueItem> list = new ArrayList<>();

        String sql = "CALL sp_cursor_overdue_evidence()";

        try (Connection con = DBConnection.getConnection();
             CallableStatement cs = con.prepareCall(sql);
             ResultSet rs = cs.executeQuery()) {

            while (rs.next()) {
                OverdueItem item = new OverdueItem();
                item.setEvidenceId(rs.getString("evidence_id"));
                item.setEvidenceType(rs.getString("evidence_type"));
                item.setCaseId(rs.getString("case_id"));
                item.setDaysStuck(rs.getInt("days_stuck"));
                item.setLastMovement(rs.getString("last_movement"));
                item.setAlertLevel(rs.getString("alert_level"));
                list.add(item);
            }
        }
        return list;
    }

    /**
     * Count how many overdue items exist — used for dashboard badge.
     */
    public int countOverdue() throws SQLException {
        return getOverdueEvidence().size();
    }

    // ── Inner model class ──────────────────────────────────────────
    public static class OverdueItem {
        private String evidenceId;
        private String evidenceType;
        private String caseId;
        private int    daysStuck;
        private String lastMovement;
        private String alertLevel;   // CRITICAL | WARNING | NOTICE

        public String getEvidenceId()    { return evidenceId; }
        public void   setEvidenceId(String v)  { evidenceId = v; }
        public String getEvidenceType()  { return evidenceType; }
        public void   setEvidenceType(String v){ evidenceType = v; }
        public String getCaseId()        { return caseId; }
        public void   setCaseId(String v){ caseId = v; }
        public int    getDaysStuck()     { return daysStuck; }
        public void   setDaysStuck(int v){ daysStuck = v; }
        public String getLastMovement()  { return lastMovement; }
        public void   setLastMovement(String v){ lastMovement = v; }
        public String getAlertLevel()    { return alertLevel; }
        public void   setAlertLevel(String v)  { alertLevel = v; }
    }
}

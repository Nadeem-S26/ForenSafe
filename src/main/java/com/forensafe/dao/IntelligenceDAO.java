package com.forensafe.dao;

import com.forensafe.util.DBConnection;
import java.sql.*;
import java.util.*;

public class IntelligenceDAO {

    // 3.4 Q2 – NOT EXISTS: evidence never transferred
    public List<Object[]> getUntouchedEvidence() throws SQLException {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT e.evidence_id, e.evidence_type, e.case_id, " +
                     "e.current_status, e.seized_date, c.case_title " +
                     "FROM EVIDENCE e JOIN `CASE` c ON e.case_id = c.case_id " +
                     "WHERE NOT EXISTS (SELECT 1 FROM CUSTODY_TRANSFER ct WHERE ct.evidence_id = e.evidence_id)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                list.add(new Object[]{rs.getString("evidence_id"), rs.getString("evidence_type"),
                                      rs.getString("case_id"), rs.getString("current_status"),
                                      rs.getString("seized_date"), rs.getString("case_title")});
        }
        return list;
    }

    // Query v_evidence_summary view (create if not exists)
    public List<Object[]> getEvidenceSummary() throws SQLException {
        List<Object[]> list = new ArrayList<>();
        ensureEvidenceSummaryView();
        String sql = "SELECT evidence_id, evidence_type, case_title, room_no, " +
                     "security_level, current_status, seized_date FROM v_evidence_summary " +
                     "ORDER BY seized_date DESC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                list.add(new Object[]{rs.getString("evidence_id"), rs.getString("evidence_type"),
                                      rs.getString("case_title"), rs.getString("room_no"),
                                      rs.getString("security_level"), rs.getString("current_status"),
                                      rs.getString("seized_date")});
        }
        return list;
    }

    // Alert level function equivalent (computed in Java)
    public String getAlertLevel(int daysOld) {
        if (daysOld > 30) return "CRITICAL";
        if (daysOld > 14) return "WARNING";
        if (daysOld > 7)  return "NOTICE";
        return "OK";
    }

    // Evidence with alert levels (uses fn_get_alert_level logic)
    public List<Object[]> getEvidenceWithAlertLevel() throws SQLException {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT e.evidence_id, e.evidence_type, e.current_status, " +
                     "e.seized_date, c.case_title, " +
                     "DATEDIFF(CURDATE(), e.seized_date) AS days_old " +
                     "FROM EVIDENCE e JOIN `CASE` c ON e.case_id = c.case_id " +
                     "ORDER BY days_old DESC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int daysOld = rs.getInt("days_old");
                list.add(new Object[]{rs.getString("evidence_id"), rs.getString("evidence_type"),
                                      rs.getString("current_status"), rs.getString("seized_date"),
                                      rs.getString("case_title"), daysOld, getAlertLevel(daysOld)});
            }
        }
        return list;
    }

    // INTERSECT: evidence with both report AND transfer
    public List<Object[]> getFullyDocumented() throws SQLException {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT DISTINCT e.evidence_id, e.evidence_type, e.current_status, c.case_title " +
                     "FROM EVIDENCE e JOIN `CASE` c ON e.case_id = c.case_id " +
                     "WHERE e.evidence_id IN (SELECT evidence_id FROM FORENSIC_REPORT) " +
                     "  AND e.evidence_id IN (SELECT DISTINCT evidence_id FROM CUSTODY_TRANSFER)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                list.add(new Object[]{rs.getString("evidence_id"), rs.getString("evidence_type"),
                                      rs.getString("current_status"), rs.getString("case_title")});
        }
        return list;
    }

    private void ensureEvidenceSummaryView() {
        String sql = "CREATE OR REPLACE VIEW v_evidence_summary AS " +
                     "SELECT e.evidence_id, e.evidence_type, c.case_title, sl.room_no, " +
                     "sl.security_level, e.current_status, e.seized_date " +
                     "FROM EVIDENCE e " +
                     "JOIN `CASE` c ON e.case_id = c.case_id " +
                     "JOIN STORAGE_LOCATION sl ON e.storage_id = sl.storage_id";
        try (Connection c = DBConnection.getConnection();
             Statement st = c.createStatement()) {
            st.execute(sql);
        } catch (Exception ignored) {}
    }
}

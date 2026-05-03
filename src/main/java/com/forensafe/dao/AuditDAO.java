package com.forensafe.dao;

import com.forensafe.util.DBConnection;
import java.sql.*;
import java.util.*;

public class AuditDAO {

    // Query v_active_cases view from Java
    public List<Object[]> getActiveCases() throws SQLException {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT case_id, case_title, crime_type, status, " +
                     "date_registered, area, evidence_count FROM v_active_cases " +
                     "ORDER BY date_registered DESC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                list.add(new Object[]{rs.getString("case_id"), rs.getString("case_title"),
                                      rs.getString("crime_type"), rs.getString("status"),
                                      rs.getString("date_registered"), rs.getString("area"),
                                      rs.getInt("evidence_count")});
        }
        return list;
    }

    // Call sp_case_evidence_audit() cursor procedure
    public List<Object[]> getCaseEvidenceAudit() throws SQLException {
        List<Object[]> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection()) {
            ensureAuditProc(c);
            try (CallableStatement cs = c.prepareCall("{CALL sp_case_evidence_audit()}");
                 ResultSet rs = cs.executeQuery()) {
                while (rs.next())
                    list.add(new Object[]{rs.getString("case_id"), rs.getString("case_title"),
                                          rs.getString("status"), rs.getInt("ev_count"),
                                          rs.getString("audit_flag")});
            }
        }
        return list;
    }

    // Cases with 0 evidence (unregistered evidence)
    public List<Object[]> getCasesWithNoEvidence() throws SQLException {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT c.case_id, c.case_title, c.status, c.date_registered " +
                     "FROM `CASE` c " +
                     "WHERE NOT EXISTS (SELECT 1 FROM EVIDENCE e WHERE e.case_id = c.case_id) " +
                     "ORDER BY c.date_registered DESC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                list.add(new Object[]{rs.getString("case_id"), rs.getString("case_title"),
                                      rs.getString("status"), rs.getString("date_registered")});
        }
        return list;
    }

    // Cases by date range (sp_cases_by_range equivalent)
    public List<Object[]> getCasesByDateRange(String fromDate, String toDate) throws SQLException {
        List<Object[]> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             CallableStatement cs = c.prepareCall("{CALL sp_cases_by_range(?,?)}")) {
            cs.setString(1, fromDate);
            cs.setString(2, toDate);
            ResultSet rs = cs.executeQuery();
            while (rs.next())
                list.add(new Object[]{rs.getString("case_id"), rs.getString("case_title"),
                                      rs.getString("crime_type"), rs.getString("status"),
                                      rs.getString("date_registered"), rs.getString("area"),
                                      rs.getInt("evidence_count")});
        }
        return list;
    }

    private void ensureAuditProc(Connection c) {
        String sql = "CREATE PROCEDURE IF NOT EXISTS sp_case_evidence_audit() " +
            "BEGIN " +
            "DECLARE v_cid VARCHAR(20); DECLARE v_title VARCHAR(150); DECLARE v_status VARCHAR(30); " +
            "DECLARE v_ecount INT; DECLARE v_flag VARCHAR(30); DECLARE v_done INT DEFAULT FALSE; " +
            "DECLARE cur_case CURSOR FOR SELECT case_id, case_title, status FROM `CASE` ORDER BY case_id; " +
            "DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE; " +
            "DROP TEMPORARY TABLE IF EXISTS tmp_audit; " +
            "CREATE TEMPORARY TABLE tmp_audit (" +
            "  case_id VARCHAR(20), case_title VARCHAR(150), status VARCHAR(30), ev_count INT, audit_flag VARCHAR(30)); " +
            "OPEN cur_case; " +
            "case_loop: LOOP " +
            "  FETCH cur_case INTO v_cid, v_title, v_status; " +
            "  IF v_done THEN LEAVE case_loop; END IF; " +
            "  SELECT COUNT(*) INTO v_ecount FROM EVIDENCE WHERE case_id = v_cid; " +
            "  SET v_flag = IF(v_ecount=0,'NO EVIDENCE REGISTERED','ACTIVE'); " +
            "  INSERT INTO tmp_audit VALUES (v_cid, v_title, v_status, v_ecount, v_flag); " +
            "END LOOP; " +
            "CLOSE cur_case; " +
            "SELECT * FROM tmp_audit ORDER BY case_id; " +
            "DROP TEMPORARY TABLE tmp_audit; " +
            "END";
        try (Statement st = c.createStatement()) { st.execute(sql); } catch (Exception ignored) {}
    }
}

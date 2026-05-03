package com.forensafe.dao;

import com.forensafe.util.DBConnection;
import java.sql.*;
import java.util.*;

public class WorkloadDAO {

    // Call sp_officer_workload() stored procedure
    public List<Object[]> getOfficerWorkload() throws SQLException {
        List<Object[]> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             CallableStatement cs = c.prepareCall("{CALL sp_officer_workload()}");
             ResultSet rs = cs.executeQuery()) {
            while (rs.next())
                list.add(new Object[]{
                    rs.getString("officer_id"),
                    rs.getString("officer_name"),
                    rs.getString("designation"),
                    rs.getInt("evidence_handled"),
                    rs.getInt("reports_filed")
                });
        }
        return list;
    }

    // Call sp_officer_transfer_summary() cursor procedure
    public List<Object[]> getOfficerTransferSummary() throws SQLException {
        List<Object[]> list = new ArrayList<>();
        // Create the procedure if not exists, then call it
        try (Connection c = DBConnection.getConnection()) {
            // Ensure procedure exists
            ensureTransferSummaryProc(c);
            try (CallableStatement cs = c.prepareCall("{CALL sp_officer_transfer_summary()}");
                 ResultSet rs = cs.executeQuery()) {
                while (rs.next())
                    list.add(new Object[]{
                        rs.getString("officer_id"),
                        rs.getString("officer_name"),
                        rs.getInt("total_transfers")
                    });
            }
        }
        return list;
    }

    private void ensureTransferSummaryProc(Connection c) {
        String sql = "CREATE PROCEDURE IF NOT EXISTS sp_officer_transfer_summary() " +
            "BEGIN " +
            "DECLARE v_oid VARCHAR(20); DECLARE v_fname VARCHAR(50); DECLARE v_lname VARCHAR(50); " +
            "DECLARE v_count INT; DECLARE v_done INT DEFAULT FALSE; " +
            "DECLARE cur_off CURSOR FOR SELECT officer_id, f_name, l_name FROM OFFICER ORDER BY officer_id; " +
            "DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE; " +
            "DROP TEMPORARY TABLE IF EXISTS tmp_summary; " +
            "CREATE TEMPORARY TABLE tmp_summary (officer_id VARCHAR(20), officer_name VARCHAR(100), total_transfers INT); " +
            "OPEN cur_off; " +
            "off_loop: LOOP " +
            "  FETCH cur_off INTO v_oid, v_fname, v_lname; " +
            "  IF v_done THEN LEAVE off_loop; END IF; " +
            "  SELECT COUNT(*) INTO v_count FROM CUSTODY_TRANSFER WHERE to_officer_id = v_oid; " +
            "  INSERT INTO tmp_summary VALUES (v_oid, CONCAT(v_fname,' ',v_lname), v_count); " +
            "END LOOP; " +
            "CLOSE cur_off; " +
            "SELECT * FROM tmp_summary ORDER BY total_transfers DESC; " +
            "DROP TEMPORARY TABLE tmp_summary; " +
            "END";
        try (Statement st = c.createStatement()) {
            st.execute(sql);
        } catch (Exception ignored) {}
    }

    // fn_officer_full_name function – inline using CONCAT as fallback
    public String getOfficerFullName(String officerId) throws SQLException {
        String sql = "SELECT CONCAT(f_name,' ',l_name) AS full_name FROM OFFICER WHERE officer_id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, officerId);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getString("full_name") : "Unknown Officer";
        }
    }
}

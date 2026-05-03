package com.forensafe.dao;

import com.forensafe.util.DBConnection;
import java.sql.*;
import java.util.*;

public class AnalyticsDAO {

    // 3.2 Q3 – Case count + percentage per status
    public List<Object[]> getCaseStatusPercentage() throws SQLException {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT status, COUNT(*) AS case_count, " +
                     "ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM `CASE`), 1) AS percentage " +
                     "FROM `CASE` GROUP BY status ORDER BY case_count DESC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                list.add(new Object[]{rs.getString("status"), rs.getInt("case_count"), rs.getDouble("percentage")});
        }
        return list;
    }

    // 3.2 Q2 – Officers with >1 custody transfer (HAVING)
    public List<Object[]> getActiveOfficers() throws SQLException {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT o.officer_id, CONCAT(o.f_name,' ',o.l_name) AS officer_name, " +
                     "o.designation, COUNT(ct.transfer_no) AS transfers_received " +
                     "FROM OFFICER o JOIN CUSTODY_TRANSFER ct ON o.officer_id = ct.to_officer_id " +
                     "GROUP BY o.officer_id, officer_name, o.designation " +
                     "HAVING COUNT(ct.transfer_no) > 1 ORDER BY transfers_received DESC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                list.add(new Object[]{rs.getString("officer_id"), rs.getString("officer_name"),
                                      rs.getString("designation"), rs.getInt("transfers_received")});
        }
        return list;
    }

    // 3.4 Q1 – Cases above average evidence count (subquery)
    public List<Object[]> getCasesAboveAvgEvidence() throws SQLException {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT c.case_id, c.case_title, c.status, COUNT(e.evidence_id) AS evidence_count " +
                     "FROM `CASE` c JOIN EVIDENCE e ON c.case_id = e.case_id " +
                     "GROUP BY c.case_id, c.case_title, c.status " +
                     "HAVING COUNT(e.evidence_id) > " +
                     "  (SELECT AVG(ev_count) FROM " +
                     "    (SELECT COUNT(evidence_id) AS ev_count FROM EVIDENCE GROUP BY case_id) sub) " +
                     "ORDER BY evidence_count DESC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                list.add(new Object[]{rs.getString("case_id"), rs.getString("case_title"),
                                      rs.getString("status"), rs.getInt("evidence_count")});
        }
        return list;
    }

    // 3.4 Q3 – Top officer by transfers (correlated subquery)
    public List<Object[]> getTopOfficerByTransfers() throws SQLException {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT o.officer_id, CONCAT(o.f_name,' ',o.l_name) AS officer_name, " +
                     "o.designation, " +
                     "(SELECT COUNT(*) FROM CUSTODY_TRANSFER ct WHERE ct.to_officer_id = o.officer_id) AS transfers " +
                     "FROM OFFICER o ORDER BY transfers DESC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                list.add(new Object[]{rs.getString("officer_id"), rs.getString("officer_name"),
                                      rs.getString("designation"), rs.getInt("transfers")});
        }
        return list;
    }

    // 3.3 Q3 – INTERSECT: evidence with both report AND transfer
    public List<Object[]> getEvidenceWithReportAndTransfer() throws SQLException {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT DISTINCT e.evidence_id, e.evidence_type, e.current_status, c.case_title " +
                     "FROM EVIDENCE e " +
                     "JOIN `CASE` c ON e.case_id = c.case_id " +
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

    // 3.3 Q1 – UNION: all officers who sent OR received transfers
    public List<Object[]> getTransferParticipants() throws SQLException {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT from_officer_id AS officer_id, 'SENDER' AS role_in_transfer " +
                     "FROM CUSTODY_TRANSFER UNION " +
                     "SELECT to_officer_id, 'RECEIVER' FROM CUSTODY_TRANSFER ORDER BY officer_id";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                list.add(new Object[]{rs.getString("officer_id"), rs.getString("role_in_transfer")});
        }
        return list;
    }

    // Summary counts
    public Map<String, Integer> getSummaryCounts() throws SQLException {
        Map<String, Integer> m = new LinkedHashMap<>();
        try (Connection c = DBConnection.getConnection()) {
            for (String[] q : new String[][]{
                    {"totalCases",     "SELECT COUNT(*) FROM `CASE`"},
                    {"openCases",      "SELECT COUNT(*) FROM `CASE` WHERE status='Open'"},
                    {"totalEvidence",  "SELECT COUNT(*) FROM EVIDENCE"},
                    {"totalOfficers",  "SELECT COUNT(*) FROM OFFICER"},
                    {"totalTransfers", "SELECT COUNT(*) FROM CUSTODY_TRANSFER"},
                    {"totalReports",   "SELECT COUNT(*) FROM FORENSIC_REPORT"}}) {
                try (PreparedStatement ps = c.prepareStatement(q[1]);
                     ResultSet rs = ps.executeQuery()) {
                    m.put(q[0], rs.next() ? rs.getInt(1) : 0);
                }
            }
        }
        return m;
    }
}

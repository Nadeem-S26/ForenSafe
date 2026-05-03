package com.forensafe.dao;

import com.forensafe.model.Case;
import com.forensafe.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CaseDAO {

    // ── All cases with evidence count ──────────────────────────────
    public List<Case> getAllCases() throws SQLException {
        List<Case> list = new ArrayList<>();
        String sql = "SELECT c.*, COUNT(e.evidence_id) AS ev_count " +
                     "FROM `CASE` c LEFT JOIN EVIDENCE e ON c.case_id=e.case_id " +
                     "GROUP BY c.case_id ORDER BY c.date_registered DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ── Filter by status ───────────────────────────────────────────
    public List<Case> getByStatus(String status) throws SQLException {
        List<Case> list = new ArrayList<>();
        String sql = "SELECT c.*, COUNT(e.evidence_id) AS ev_count " +
                     "FROM `CASE` c LEFT JOIN EVIDENCE e ON c.case_id=e.case_id " +
                     "WHERE c.status=? GROUP BY c.case_id ORDER BY c.date_registered DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ── Filter by date range ───────────────────────────────────────
    public List<Case> getByDateRange(Date from, Date to) throws SQLException {
        List<Case> list = new ArrayList<>();
        String sql = "SELECT c.*, COUNT(e.evidence_id) AS ev_count " +
                     "FROM `CASE` c LEFT JOIN EVIDENCE e ON c.case_id=e.case_id " +
                     "WHERE c.date_registered BETWEEN ? AND ? " +
                     "GROUP BY c.case_id ORDER BY c.date_registered DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDate(1, from);
            ps.setDate(2, to);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ── Get single case ────────────────────────────────────────────
    public Case getById(String id) throws SQLException {
        String sql = "SELECT c.*, COUNT(e.evidence_id) AS ev_count " +
                     "FROM `CASE` c LEFT JOIN EVIDENCE e ON c.case_id=e.case_id " +
                     "WHERE c.case_id=? GROUP BY c.case_id";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }

    // ── Insert ─────────────────────────────────────────────────────
    public boolean insert(Case c) throws SQLException {
        String sql = "INSERT INTO `CASE`(case_id,case_title,crime_type,description," +
                     "date_registered,status,street,area,pincode) VALUES(?,?,?,?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, c.getCaseId());
            ps.setString(2, c.getCaseTitle());
            ps.setString(3, c.getCrimeType());
            ps.setString(4, c.getDescription());
            ps.setDate(5,   c.getDateRegistered());
            ps.setString(6, c.getStatus());
            ps.setString(7, c.getStreet());
            ps.setString(8, c.getArea());
            ps.setString(9, c.getPincode());
            return ps.executeUpdate() > 0;
        }
    }

    // ── Update ─────────────────────────────────────────────────────
    public boolean update(Case c) throws SQLException {
        String sql = "UPDATE `CASE` SET case_title=?,crime_type=?,description=?," +
                     "status=?,street=?,area=?,pincode=? WHERE case_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, c.getCaseTitle());
            ps.setString(2, c.getCrimeType());
            ps.setString(3, c.getDescription());
            ps.setString(4, c.getStatus());
            ps.setString(5, c.getStreet());
            ps.setString(6, c.getArea());
            ps.setString(7, c.getPincode());
            ps.setString(8, c.getCaseId());
            return ps.executeUpdate() > 0;
        }
    }

    // ── Delete ─────────────────────────────────────────────────────
    public boolean delete(String id) throws SQLException {
        String sql = "DELETE FROM `CASE` WHERE case_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    // ── Count by status ────────────────────────────────────────────
    public int countByStatus(String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM `CASE` WHERE status=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public int countAll() throws SQLException {
        String sql = "SELECT COUNT(*) FROM `CASE`";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    // ── Monthly stats (for chart) ──────────────────────────────────
    public List<Object[]> getMonthlyCaseCounts() throws SQLException {
        List<Object[]> data = new ArrayList<>();
        String sql = "SELECT DATE_FORMAT(date_registered,'%Y-%m') AS month, COUNT(*) AS cnt " +
                     "FROM `CASE` GROUP BY month ORDER BY month DESC LIMIT 6";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) data.add(new Object[]{rs.getString(1), rs.getInt(2)});
        }
        return data;
    }

    private Case mapRow(ResultSet rs) throws SQLException {
        Case c = new Case();
        c.setCaseId(rs.getString("case_id"));
        c.setCaseTitle(rs.getString("case_title"));
        c.setCrimeType(rs.getString("crime_type"));
        c.setDescription(rs.getString("description"));
        c.setDateRegistered(rs.getDate("date_registered"));
        c.setStatus(rs.getString("status"));
        c.setStreet(rs.getString("street"));
        c.setArea(rs.getString("area"));
        c.setPincode(rs.getString("pincode"));
        try { c.setEvidenceCount(rs.getInt("ev_count")); } catch (Exception ignored) {}
        return c;
    }
}

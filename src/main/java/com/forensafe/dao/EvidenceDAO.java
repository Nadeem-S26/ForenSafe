package com.forensafe.dao;

import com.forensafe.model.Evidence;
import com.forensafe.model.CustodyTransfer;
import com.forensafe.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EvidenceDAO {

    // ── All evidence with case title ───────────────────────────────
    public List<Evidence> getAll() throws SQLException {
        List<Evidence> list = new ArrayList<>();
        String sql = "SELECT e.*, c.case_title, " +
                     "CONCAT('Room ',sl.room_no,' / Locker ',sl.locker_no) AS storage_loc " +
                     "FROM EVIDENCE e " +
                     "JOIN `CASE` c ON e.case_id=c.case_id " +
                     "LEFT JOIN STORAGE_LOCATION sl ON e.storage_id=sl.storage_id " +
                     "ORDER BY e.seized_date DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ── Evidence by case ───────────────────────────────────────────
    public List<Evidence> getByCase(String caseId) throws SQLException {
        List<Evidence> list = new ArrayList<>();
        String sql = "SELECT e.*, c.case_title, " +
                     "CONCAT('Room ',sl.room_no,' / Locker ',sl.locker_no) AS storage_loc " +
                     "FROM EVIDENCE e " +
                     "JOIN `CASE` c ON e.case_id=c.case_id " +
                     "LEFT JOIN STORAGE_LOCATION sl ON e.storage_id=sl.storage_id " +
                     "WHERE e.case_id=? ORDER BY e.seized_date";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, caseId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ── Single evidence ────────────────────────────────────────────
    public Evidence getById(String id) throws SQLException {
        String sql = "SELECT e.*, c.case_title, " +
                     "CONCAT('Room ',sl.room_no,' / Locker ',sl.locker_no) AS storage_loc " +
                     "FROM EVIDENCE e " +
                     "JOIN `CASE` c ON e.case_id=c.case_id " +
                     "LEFT JOIN STORAGE_LOCATION sl ON e.storage_id=sl.storage_id " +
                     "WHERE e.evidence_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }

    // ── Insert ─────────────────────────────────────────────────────
    public boolean insert(Evidence e) throws SQLException {
        String sql = "INSERT INTO EVIDENCE(evidence_id,case_id,storage_id,evidence_type," +
                     "description,serial_number,seized_date,seized_street,seized_area," +
                     "seized_pincode,hash_value,current_status) VALUES(?,?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1,  e.getEvidenceId());
            ps.setString(2,  e.getCaseId());
            ps.setString(3,  e.getStorageId());
            ps.setString(4,  e.getEvidenceType());
            ps.setString(5,  e.getDescription());
            ps.setString(6,  e.getSerialNumber());
            ps.setDate(7,    e.getSeizedDate());
            ps.setString(8,  e.getSeizedStreet());
            ps.setString(9,  e.getSeizedArea());
            ps.setString(10, e.getSeizedPincode());
            ps.setString(11, e.getHashValue());
            ps.setString(12, e.getCurrentStatus());
            return ps.executeUpdate() > 0;
        }
    }

    // ── Update status ──────────────────────────────────────────────
    public boolean updateStatus(String id, String status) throws SQLException {
        String sql = "UPDATE EVIDENCE SET current_status=? WHERE evidence_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, id);
            return ps.executeUpdate() > 0;
        }
    }

    // ── Delete ─────────────────────────────────────────────────────
    public boolean delete(String id) throws SQLException {
        String sql = "DELETE FROM EVIDENCE WHERE evidence_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    // ── Count total evidence ───────────────────────────────────────
    public int countAll() throws SQLException {
        String sql = "SELECT COUNT(*) FROM EVIDENCE";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    // ── Custody transfer chain ─────────────────────────────────────
    public List<CustodyTransfer> getCustodyChain(String evidenceId) throws SQLException {
        List<CustodyTransfer> list = new ArrayList<>();
        String sql = "SELECT ct.*, " +
                     "CONCAT(fo.f_name,' ',fo.l_name) AS from_name, " +
                     "CONCAT(to2.f_name,' ',to2.l_name) AS to_name " +
                     "FROM CUSTODY_TRANSFER ct " +
                     "JOIN OFFICER fo  ON ct.from_officer_id=fo.officer_id " +
                     "JOIN OFFICER to2 ON ct.to_officer_id=to2.officer_id " +
                     "WHERE ct.evidence_id=? ORDER BY ct.transfer_no";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, evidenceId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CustodyTransfer ct = new CustodyTransfer();
                ct.setEvidenceId(rs.getString("evidence_id"));
                ct.setTransferNo(rs.getInt("transfer_no"));
                ct.setFromOfficerId(rs.getString("from_officer_id"));
                ct.setToOfficerId(rs.getString("to_officer_id"));
                ct.setTransferDatetime(rs.getTimestamp("transfer_datetime"));
                ct.setPurpose(rs.getString("purpose"));
                ct.setRemarks(rs.getString("remarks"));
                ct.setFromOfficerName(rs.getString("from_name"));
                ct.setToOfficerName(rs.getString("to_name"));
                list.add(ct);
            }
        }
        return list;
    }

    // ── Add custody transfer ───────────────────────────────────────
    public boolean addCustodyTransfer(CustodyTransfer ct) throws SQLException {
        String sqlMax = "SELECT IFNULL(MAX(transfer_no),0)+1 FROM CUSTODY_TRANSFER WHERE evidence_id=?";
        String sqlIns = "INSERT INTO CUSTODY_TRANSFER(evidence_id,transfer_no,from_officer_id," +
                        "to_officer_id,transfer_datetime,purpose,remarks) VALUES(?,?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection()) {
            int nextNo;
            try (PreparedStatement ps = con.prepareStatement(sqlMax)) {
                ps.setString(1, ct.getEvidenceId());
                ResultSet rs = ps.executeQuery();
                nextNo = rs.next() ? rs.getInt(1) : 1;
            }
            try (PreparedStatement ps = con.prepareStatement(sqlIns)) {
                ps.setString(1, ct.getEvidenceId());
                ps.setInt(2, nextNo);
                ps.setString(3, ct.getFromOfficerId());
                ps.setString(4, ct.getToOfficerId());
                ps.setTimestamp(5, ct.getTransferDatetime());
                ps.setString(6, ct.getPurpose());
                ps.setString(7, ct.getRemarks());
                return ps.executeUpdate() > 0;
            }
        }
    }

    private Evidence mapRow(ResultSet rs) throws SQLException {
        Evidence e = new Evidence();
        e.setEvidenceId(rs.getString("evidence_id"));
        e.setCaseId(rs.getString("case_id"));
        e.setStorageId(rs.getString("storage_id"));
        e.setEvidenceType(rs.getString("evidence_type"));
        e.setDescription(rs.getString("description"));
        e.setSerialNumber(rs.getString("serial_number"));
        e.setSeizedDate(rs.getDate("seized_date"));
        e.setSeizedStreet(rs.getString("seized_street"));
        e.setSeizedArea(rs.getString("seized_area"));
        e.setSeizedPincode(rs.getString("seized_pincode"));
        e.setHashValue(rs.getString("hash_value"));
        e.setCurrentStatus(rs.getString("current_status"));
        try { e.setCaseTitle(rs.getString("case_title")); } catch (Exception ignored) {}
        try { e.setStorageLocation(rs.getString("storage_loc")); } catch (Exception ignored) {}
        return e;
    }
}

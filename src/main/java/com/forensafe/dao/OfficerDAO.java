package com.forensafe.dao;

import com.forensafe.model.Officer;
import com.forensafe.util.DBConnection;
import com.forensafe.util.PasswordUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OfficerDAO {

    // ── Authenticate login ─────────────────────────────────────────
    public Officer authenticate(String username, String password) throws SQLException {
    String sql = "SELECT * FROM OFFICER WHERE username = ?";
    try (Connection c = DBConnection.getConnection();
         PreparedStatement ps = c.prepareStatement(sql)) {
        ps.setString(1, username);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            String stored = rs.getString("password");
            boolean match = false;
            // Try BCrypt first (for accounts created via Create Account form)
            if (stored != null && stored.startsWith("$2a$")) {
                match = PasswordUtil.verify(password, stored);
            } else {
                // Plain text fallback (for manually inserted seed data)
                match = password.equals(stored);
            }
            if (match) return mapRow(rs);
        }
    }
    return null;
}

    // ── Get all officers ───────────────────────────────────────────
    public List<Officer> getAllOfficers() throws SQLException {
        List<Officer> list = new ArrayList<>();
        String sql = "SELECT * FROM OFFICER ORDER BY f_name";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ── Get officer by ID ──────────────────────────────────────────
    public Officer getById(String id) throws SQLException {
        String sql = "SELECT * FROM OFFICER WHERE officer_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }

    // ── Insert new officer ─────────────────────────────────────────
    public boolean insert(Officer o) throws SQLException {
        String sql = "INSERT INTO OFFICER VALUES(?,?,?,?,?,?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1,  o.getOfficerId());
            ps.setString(2,  o.getFirstName());
            ps.setString(3,  o.getLastName());
            ps.setString(4,  o.getDesignation());
            ps.setString(5,  o.getDepartment());
            ps.setString(6,  o.getPhone());
            ps.setString(7,  o.getEmail());
            ps.setString(8,  o.getRole());
            ps.setString(9,  o.getUsername());
            ps.setString(10, PasswordUtil.hash(o.getPassword()));
            return ps.executeUpdate() > 0;
        }
    }

    // ── Update officer ─────────────────────────────────────────────
    public boolean update(Officer o) throws SQLException {
        String sql = "UPDATE OFFICER SET f_name=?,l_name=?,designation=?," +
                     "department=?,phone=?,email=?,role=? WHERE officer_id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, o.getFirstName());
            ps.setString(2, o.getLastName());
            ps.setString(3, o.getDesignation());
            ps.setString(4, o.getDepartment());
            ps.setString(5, o.getPhone());
            ps.setString(6, o.getEmail());
            ps.setString(7, o.getRole());
            ps.setString(8, o.getOfficerId());
            return ps.executeUpdate() > 0;
        }
    }

    // ── Delete officer ─────────────────────────────────────────────
    public boolean delete(String id) throws SQLException {
        String sql = "DELETE FROM OFFICER WHERE officer_id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    // ── Count officers ─────────────────────────────────────────────
    public int count() throws SQLException {
        String sql = "SELECT COUNT(*) FROM OFFICER";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    private Officer mapRow(ResultSet rs) throws SQLException {
        Officer o = new Officer();
        o.setOfficerId(rs.getString("officer_id"));
        o.setFirstName(rs.getString("f_name"));
        o.setLastName(rs.getString("l_name"));
        o.setDesignation(rs.getString("designation"));
        o.setDepartment(rs.getString("department"));
        o.setPhone(rs.getString("phone"));
        o.setEmail(rs.getString("email"));
        o.setRole(rs.getString("role"));
        o.setUsername(rs.getString("username"));
        return o;
    }
}

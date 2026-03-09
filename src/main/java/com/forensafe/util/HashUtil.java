package com.forensafe.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.Instant;

/**
 * Utility to generate SHA-256 hash values for evidence items.
 * Used to auto-generate a hash when officer does not provide one.
 */
public class HashUtil {

    /**
     * Generates a SHA-256 hash from a string input.
     * Used to hash evidence descriptions + serial numbers + seized date.
     */
    public static String sha256(String input) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(input.getBytes(StandardCharsets.UTF_8));
            StringBuilder hex = new StringBuilder();
            for (byte b : hash) {
                hex.append(String.format("%02x", b));
            }
            return hex.toString();
        } catch (NoSuchAlgorithmException e) {
            // SHA-256 is always available in Java — this should never happen
            throw new RuntimeException("SHA-256 not available", e);
        }
    }

    /**
     * Auto-generates a unique evidence hash based on:
     * evidenceId + evidenceType + seizedDate + serialNumber + current timestamp
     *
     * This ensures even two identical items get different hashes
     * (due to the timestamp component).
     */
    public static String generateEvidenceHash(String evidenceId, String evidenceType,
                                               String seizedDate, String serialNumber) {
        String raw = evidenceId
                   + "|" + evidenceType
                   + "|" + seizedDate
                   + "|" + (serialNumber != null ? serialNumber : "NOSERIAL")
                   + "|" + Instant.now().toEpochMilli();
        return sha256(raw);
    }

    private HashUtil() {}
}

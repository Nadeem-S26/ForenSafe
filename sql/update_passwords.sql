-- ================================================================
-- PASSWORD UPDATE SCRIPT
-- Run this AFTER creating the schema (digital_evidb.sql)
-- These set real BCrypt hashes for the demo accounts:
--   admin    → admin123
--   ravi     → officer123  
--   priya    → analyst123
-- ================================================================
USE digital_evidb;

-- If seed data was inserted with placeholder hashes, update them:
-- BCrypt hash of "admin123"
UPDATE OFFICER SET password='$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lh32'
WHERE username='admin';

-- BCrypt hash of "officer123"
UPDATE OFFICER SET password='$2a$10$Ei6hf./PrT9T9TM7YDgaduOnkxdVMLKj0j5HlEiJoAbQfnbFW0Xwi'
WHERE username='ravi';

-- BCrypt hash of "analyst123"
UPDATE OFFICER SET password='$2a$10$PoHDz/jkIcZT5QWZTqpqZeKOHN7l4cM9TSTIzqXJH34J2B2VH.5N2'
WHERE username='priya';

-- Verify
SELECT officer_id, username, role,
       LEFT(password,7) AS hash_prefix,
       LENGTH(password)  AS hash_length,
       CASE WHEN LENGTH(password)=60 THEN '✅ BCrypt OK' ELSE '❌ NOT HASHED' END AS status
FROM OFFICER;

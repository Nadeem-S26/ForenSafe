-- ================================================================
-- FORENSAFE: Digital Evidence Chain-of-Custody Management System
-- Database: digital_evidb
-- ================================================================

CREATE DATABASE IF NOT EXISTS digital_evidb;
USE digital_evidb;

-- ================================
-- OFFICER  (also serves as login user)
-- ================================
CREATE TABLE OFFICER (
    officer_id  VARCHAR(20) PRIMARY KEY,
    f_name      VARCHAR(50),
    l_name      VARCHAR(50),
    designation VARCHAR(50),
    department  VARCHAR(100),
    phone       VARCHAR(15),
    email       VARCHAR(100),
    role        VARCHAR(50),          -- 'admin' | 'officer' | 'analyst'
    username    VARCHAR(50) UNIQUE,
    password    VARCHAR(255)          -- BCrypt hashed
) ENGINE=InnoDB;

-- ================================
-- CASE
-- ================================
CREATE TABLE `CASE` (
    case_id         VARCHAR(20) PRIMARY KEY,
    case_title      VARCHAR(150),
    crime_type      VARCHAR(100),
    description     TEXT,
    date_registered DATE,
    status          VARCHAR(30),      -- Open | Under Investigation | Closed
    street          VARCHAR(100),
    area            VARCHAR(100),
    pincode         VARCHAR(10)
) ENGINE=InnoDB;

-- ================================
-- STORAGE_LOCATION
-- ================================
CREATE TABLE STORAGE_LOCATION (
    storage_id     VARCHAR(20) PRIMARY KEY,
    room_no        VARCHAR(20),
    locker_no      VARCHAR(20),
    security_level VARCHAR(30)        -- Low | Medium | High | Maximum
) ENGINE=InnoDB;

-- ================================
-- FORENSIC_TOOL
-- ================================
CREATE TABLE FORENSIC_TOOL (
    tool_id    VARCHAR(20) PRIMARY KEY,
    tool_name  VARCHAR(100),
    version    VARCHAR(50),
    vendor     VARCHAR(100),
    license_no VARCHAR(100)
) ENGINE=InnoDB;

-- ================================
-- EVIDENCE
-- ================================
CREATE TABLE EVIDENCE (
    evidence_id     VARCHAR(20) PRIMARY KEY,
    case_id         VARCHAR(20),
    storage_id      VARCHAR(20),
    evidence_type   VARCHAR(100),
    description     TEXT,
    serial_number   VARCHAR(100),
    seized_date     DATE,
    seized_street   VARCHAR(100),
    seized_area     VARCHAR(100),
    seized_pincode  VARCHAR(10),
    hash_value      VARCHAR(255),
    current_status  VARCHAR(50),      -- Collected | In Lab | Stored | Released

    CONSTRAINT fk_evidence_case
        FOREIGN KEY (case_id) REFERENCES `CASE`(case_id) ON UPDATE CASCADE,

    CONSTRAINT fk_evidence_storage
        FOREIGN KEY (storage_id) REFERENCES STORAGE_LOCATION(storage_id) ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ================================
-- FORENSIC_REPORT
-- ================================
CREATE TABLE FORENSIC_REPORT (
    report_id     VARCHAR(20) PRIMARY KEY,
    evidence_id   VARCHAR(20),
    analyst_id    VARCHAR(20),
    analysis_type VARCHAR(100),
    findings      TEXT,
    report_date   DATE,

    CONSTRAINT fk_report_evidence
        FOREIGN KEY (evidence_id) REFERENCES EVIDENCE(evidence_id) ON UPDATE CASCADE,

    CONSTRAINT fk_report_analyst
        FOREIGN KEY (analyst_id) REFERENCES OFFICER(officer_id) ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ================================
-- CUSTODY_TRANSFER (Weak Entity)
-- ================================
CREATE TABLE CUSTODY_TRANSFER (
    evidence_id       VARCHAR(20),
    transfer_no       INT,
    from_officer_id   VARCHAR(20),
    to_officer_id     VARCHAR(20),
    transfer_datetime DATETIME,
    purpose           VARCHAR(150),
    remarks           TEXT,

    PRIMARY KEY (evidence_id, transfer_no),

    CONSTRAINT fk_transfer_evidence
        FOREIGN KEY (evidence_id) REFERENCES EVIDENCE(evidence_id)
        ON UPDATE CASCADE ON DELETE CASCADE,

    CONSTRAINT fk_transfer_from
        FOREIGN KEY (from_officer_id) REFERENCES OFFICER(officer_id) ON UPDATE CASCADE,

    CONSTRAINT fk_transfer_to
        FOREIGN KEY (to_officer_id) REFERENCES OFFICER(officer_id) ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ================================
-- ACCESS_LOG (Weak Entity)
-- ================================
CREATE TABLE ACCESS_LOG (
    evidence_id VARCHAR(20),
    log_no      INT,
    officer_id  VARCHAR(20),
    action      VARCHAR(50),
    timestamp   DATETIME,
    device_ip   VARCHAR(45),

    PRIMARY KEY (evidence_id, log_no),

    CONSTRAINT fk_log_evidence
        FOREIGN KEY (evidence_id) REFERENCES EVIDENCE(evidence_id)
        ON UPDATE CASCADE ON DELETE CASCADE,

    CONSTRAINT fk_log_officer
        FOREIGN KEY (officer_id) REFERENCES OFFICER(officer_id) ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ================================
-- EVIDENCE_MEDIA (Weak Entity)
-- ================================
CREATE TABLE EVIDENCE_MEDIA (
    evidence_id VARCHAR(20),
    media_no    INT,
    file_name   VARCHAR(150),
    file_type   VARCHAR(50),
    file_path   VARCHAR(255),
    upload_date DATETIME,

    PRIMARY KEY (evidence_id, media_no),

    CONSTRAINT fk_media_evidence
        FOREIGN KEY (evidence_id) REFERENCES EVIDENCE(evidence_id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- ================================
-- EVIDENCE_ANALYSIS_LOG (Weak Entity)
-- ================================
CREATE TABLE EVIDENCE_ANALYSIS_LOG (
    evidence_id      VARCHAR(20),
    analysis_no      INT,
    analyst_id       VARCHAR(20),
    tool_id          VARCHAR(20),
    action_performed VARCHAR(150),
    timestamp        DATETIME,
    remarks          TEXT,

    PRIMARY KEY (evidence_id, analysis_no),

    CONSTRAINT fk_analysis_evidence
        FOREIGN KEY (evidence_id) REFERENCES EVIDENCE(evidence_id)
        ON UPDATE CASCADE ON DELETE CASCADE,

    CONSTRAINT fk_analysis_analyst
        FOREIGN KEY (analyst_id) REFERENCES OFFICER(officer_id) ON UPDATE CASCADE,

    CONSTRAINT fk_analysis_tool
        FOREIGN KEY (tool_id) REFERENCES FORENSIC_TOOL(tool_id) ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ================================================================
-- INDEXES
-- ================================================================
CREATE INDEX idx_case_status   ON `CASE`(status);
CREATE INDEX idx_case_date     ON `CASE`(date_registered);
CREATE INDEX idx_evid_case     ON EVIDENCE(case_id);
CREATE INDEX idx_evid_status   ON EVIDENCE(current_status);

-- ================================================================
-- VIEWS
-- ================================================================
CREATE OR REPLACE VIEW v_active_cases AS
SELECT
    c.case_id,
    c.case_title,
    c.crime_type,
    c.status,
    c.date_registered,
    c.area,
    COUNT(DISTINCT e.evidence_id) AS evidence_count
FROM `CASE` c
LEFT JOIN EVIDENCE e ON c.case_id = e.case_id
WHERE c.status != 'Closed'
GROUP BY c.case_id, c.case_title, c.crime_type, c.status, c.date_registered, c.area;

CREATE OR REPLACE VIEW v_evidence_chain AS
SELECT
    e.evidence_id,
    e.evidence_type,
    e.current_status,
    c.case_title,
    ct.transfer_no,
    ct.transfer_datetime,
    CONCAT(fo.f_name,' ',fo.l_name) AS from_officer,
    CONCAT(to2.f_name,' ',to2.l_name) AS to_officer,
    ct.purpose
FROM EVIDENCE e
JOIN `CASE` c ON e.case_id = c.case_id
LEFT JOIN CUSTODY_TRANSFER ct ON e.evidence_id = ct.evidence_id
LEFT JOIN OFFICER fo  ON ct.from_officer_id = fo.officer_id
LEFT JOIN OFFICER to2 ON ct.to_officer_id   = to2.officer_id
ORDER BY e.evidence_id, ct.transfer_no;

-- ================================================================
-- TRIGGER: Auto-log access when custody transfer inserted
-- ================================================================
DELIMITER $$
CREATE TRIGGER trg_custody_access_log
AFTER INSERT ON CUSTODY_TRANSFER
FOR EACH ROW
BEGIN
    DECLARE next_log INT;
    SELECT IFNULL(MAX(log_no),0)+1 INTO next_log
    FROM ACCESS_LOG WHERE evidence_id = NEW.evidence_id;

    INSERT INTO ACCESS_LOG(evidence_id, log_no, officer_id, action, timestamp, device_ip)
    VALUES (NEW.evidence_id, next_log, NEW.to_officer_id, 'CUSTODY_RECEIVED', NEW.transfer_datetime, 'SYSTEM');
END$$
DELIMITER ;

-- ================================================================
-- STORED PROCEDURE: Cases by date range
-- ================================================================
DELIMITER $$
CREATE PROCEDURE sp_cases_by_range(IN p_start DATE, IN p_end DATE)
BEGIN
    SELECT c.case_id, c.case_title, c.crime_type, c.status,
           c.date_registered, c.area,
           COUNT(e.evidence_id) AS evidence_count
    FROM `CASE` c
    LEFT JOIN EVIDENCE e ON c.case_id = e.case_id
    WHERE c.date_registered BETWEEN p_start AND p_end
    GROUP BY c.case_id
    ORDER BY c.date_registered DESC;
END$$
DELIMITER ;

-- ================================================================
-- STORED PROCEDURE: Officer Workload
-- ================================================================
DELIMITER $$
CREATE PROCEDURE sp_officer_workload()
BEGIN
    SELECT
        o.officer_id,
        CONCAT(o.f_name,' ',o.l_name) AS officer_name,
        o.designation,
        COUNT(DISTINCT ct.evidence_id) AS evidence_handled,
        COUNT(DISTINCT fr.report_id)   AS reports_filed
    FROM OFFICER o
    LEFT JOIN CUSTODY_TRANSFER ct ON o.officer_id = ct.to_officer_id
    LEFT JOIN FORENSIC_REPORT  fr ON o.officer_id = fr.analyst_id
    GROUP BY o.officer_id, officer_name, o.designation
    ORDER BY evidence_handled DESC;
END$$
DELIMITER ;

-- ================================================================
-- SEED DATA
-- ================================================================
-- Passwords are BCrypt of: admin123, officer123, analyst123
INSERT INTO OFFICER VALUES
('OFC001','Admin','User','System Administrator','IT Department','9000000001','admin@forensafe.gov','admin','admin','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lh32'),
('OFC002','Ravi','Kumar','Senior Detective','Cybercrime','9000000002','ravi.kumar@forensafe.gov','officer','ravi','$2a$10$Ei6hf./PrT9T9TM7YDgaduOnkxdVMLKj0j5HlEiJoAbQfnbFW0Xwi'),
('OFC003','Priya','Sharma','Forensic Analyst','Digital Forensics','9000000003','priya.sharma@forensafe.gov','analyst','priya','$2a$10$PoHDz/jkIcZT5QWZTqpqZeKOHN7l4cM9TSTIzqXJH34J2B2VH.5N2');

INSERT INTO `CASE` VALUES
('CASE001','Phishing Attack on State Bank','Cyber Fraud','Mass phishing emails targeting bank customers. 500+ victims reported.','2026-01-10','Open','12 MG Road','Bengaluru','560001'),
('CASE002','Corporate Data Breach – TechCorp','Data Breach','Unauthorized exfiltration of 2M employee records from internal database.','2026-01-25','Under Investigation','Whitefield IT Park','Bengaluru','560066'),
('CASE003','Hospital Ransomware Attack','Ransomware','Ransomware deployed across hospital network encrypting patient records.','2025-11-15','Closed','Apollo Hospital Complex','Chennai','600006'),
('CASE004','Social Media Account Hacking','Identity Theft','High-profile social media accounts compromised via credential stuffing.','2026-02-05','Open','7th Block Koramangala','Bengaluru','560034');

INSERT INTO STORAGE_LOCATION VALUES
('SL001','Room A','Locker 1','Maximum'),
('SL002','Room B','Locker 5','High'),
('SL003','Room C','Locker 12','Medium');

INSERT INTO FORENSIC_TOOL VALUES
('FT001','Wireshark','4.2.0','Wireshark Foundation','OS-FOSS'),
('FT002','Autopsy','4.21.0','Basis Technology','CFTL-2024-001'),
('FT003','FTK Imager','4.7.1.2','AccessData','FTK-LIC-89723'),
('FT004','Cellebrite UFED','7.68','Cellebrite','CLB-2024-456');

INSERT INTO EVIDENCE VALUES
('EV001','CASE001','SL001','Email Headers','Phishing email metadata and headers from victim inbox','N/A','2026-01-11','12 MG Road','Bengaluru','560001','a3f5e2b1c9d4e7f6a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4','In Lab'),
('EV002','CASE001','SL001','Network PCAP','Packet capture from compromised workstation NIC','PC-2024-001','2026-01-12','12 MG Road','Bengaluru','560001','b4c6d3e2f1a9b8c7d6e5f4a3b2c1d0e9f8a7b6c5d4e3f2a1b0c9d8e7f6a5b4c3','In Lab'),
('EV003','CASE002','SL002','Hard Disk Image','Full forensic image of compromised server drive','SSD-CORP-007','2026-01-26','Whitefield IT Park','Bengaluru','560066','c5d7e4f3a2b1c0d9e8f7a6b5c4d3e2f1a0b9c8d7e6f5a4b3c2d1e0f9a8b7c6d5','Stored'),
('EV004','CASE003','SL003','Malware Binary','Ransomware executable isolated in sandbox environment','N/A','2025-11-16','Apollo Hospital Complex','Chennai','600006','d6e8f5a4b3c2d1e0f9a8b7c6d5e4f3a2b1c0d9e8f7a6b5c4d3e2f1a0b9c8d7e6','Stored');

INSERT INTO CUSTODY_TRANSFER VALUES
('EV001',1,'OFC001','OFC002','2026-01-11 09:00:00','Initial assignment to lead detective','Evidence sealed and transferred'),
('EV001',2,'OFC002','OFC003','2026-01-13 14:30:00','Lab analysis required','Transferred to forensics lab'),
('EV002',1,'OFC001','OFC002','2026-01-12 10:00:00','PCAP analysis','Assigned for network forensics'),
('EV003',1,'OFC001','OFC002','2026-01-26 11:00:00','Disk forensics','Drive imaging complete, analysis pending');

INSERT INTO FORENSIC_REPORT VALUES
('RPT001','EV003','OFC003','Disk Forensics','Found 1.2M exported records in /tmp/exfil directory. Timestamps show access between 2AM-4AM on Jan 24.','2026-02-01'),
('RPT002','EV004','OFC003','Malware Analysis','Identified LockBit 3.0 variant. C2 server at 192.168.99.x (internal pivot). Decryption key retrieved.','2025-12-01');

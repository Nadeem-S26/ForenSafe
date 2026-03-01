-- ============================================================
-- Forensafe: Digital Evidence Chain-of-Custody Management
-- Database Schema (MySQL)
-- ============================================================

CREATE DATABASE IF NOT EXISTS forensafe_db;
USE forensafe_db;

-- ─────────────────────────────────────────────
-- TABLE: user
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS user (
    user_id    INT AUTO_INCREMENT PRIMARY KEY,
    username   VARCHAR(50)  NOT NULL UNIQUE,
    password   VARCHAR(255) NOT NULL,   -- BCrypt hashed
    role       VARCHAR(20)  NOT NULL DEFAULT 'officer'
                            CHECK (role IN ('admin','officer','clerk')),
    full_name  VARCHAR(100) NOT NULL,
    email      VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ─────────────────────────────────────────────
-- TABLE: officer
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS officer (
    officer_id INT AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    rank       VARCHAR(50)  NOT NULL,
    phone      VARCHAR(15)  UNIQUE,
    email      VARCHAR(100) UNIQUE,
    user_id    INT,
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE SET NULL
);

-- ─────────────────────────────────────────────
-- TABLE: case_info
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS case_info (
    case_id         INT AUTO_INCREMENT PRIMARY KEY,
    title           VARCHAR(100) NOT NULL,
    description     TEXT         NOT NULL,
    case_type       VARCHAR(50)  NOT NULL,
    status          VARCHAR(30)  NOT NULL DEFAULT 'Open'
                                  CHECK (status IN ('Open','Under Investigation','Closed')),
    registered_date DATE         NOT NULL,
    created_by      INT,
    FOREIGN KEY (created_by) REFERENCES user(user_id) ON DELETE SET NULL
);

-- ─────────────────────────────────────────────
-- TABLE: evidence
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS evidence (
    evidence_id    INT AUTO_INCREMENT PRIMARY KEY,
    case_id        INT          NOT NULL,
    evidence_type  VARCHAR(50)  NOT NULL,
    description    TEXT         NOT NULL,
    collected_date DATE         NOT NULL,
    collected_by   VARCHAR(100),
    chain_notes    TEXT,
    FOREIGN KEY (case_id) REFERENCES case_info(case_id) ON DELETE CASCADE
);

-- ─────────────────────────────────────────────
-- TABLE: case_assignment
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS case_assignment (
    assignment_id  INT AUTO_INCREMENT PRIMARY KEY,
    case_id        INT  NOT NULL,
    officer_id     INT  NOT NULL,
    assigned_date  DATE NOT NULL DEFAULT (CURRENT_DATE),
    FOREIGN KEY (case_id)    REFERENCES case_info(case_id) ON DELETE CASCADE,
    FOREIGN KEY (officer_id) REFERENCES officer(officer_id) ON DELETE CASCADE,
    UNIQUE KEY uq_case_officer (case_id, officer_id)
);

-- ─────────────────────────────────────────────
-- INDEXES
-- ─────────────────────────────────────────────
CREATE INDEX idx_case_status   ON case_info(status);
CREATE INDEX idx_case_date     ON case_info(registered_date);
CREATE INDEX idx_evidence_case ON evidence(case_id);

-- ─────────────────────────────────────────────
-- VIEW: active_cases_view
-- ─────────────────────────────────────────────
CREATE OR REPLACE VIEW active_cases_view AS
SELECT
    c.case_id,
    c.title,
    c.case_type,
    c.status,
    c.registered_date,
    COUNT(DISTINCT e.evidence_id) AS evidence_count,
    COUNT(DISTINCT ca.officer_id) AS officer_count
FROM case_info c
LEFT JOIN evidence e         ON c.case_id = e.case_id
LEFT JOIN case_assignment ca ON c.case_id = ca.case_id
WHERE c.status != 'Closed'
GROUP BY c.case_id, c.title, c.case_type, c.status, c.registered_date;

-- ─────────────────────────────────────────────
-- VIEW: officer_workload_view
-- ─────────────────────────────────────────────
CREATE OR REPLACE VIEW officer_workload_view AS
SELECT
    o.officer_id,
    o.name,
    o.rank,
    COUNT(ca.case_id) AS total_cases,
    SUM(CASE WHEN ci.status != 'Closed' THEN 1 ELSE 0 END) AS active_cases
FROM officer o
LEFT JOIN case_assignment ca ON o.officer_id = ca.officer_id
LEFT JOIN case_info ci       ON ca.case_id   = ci.case_id
GROUP BY o.officer_id, o.name, o.rank;

-- ─────────────────────────────────────────────
-- TRIGGER: log status change (audit trail)
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS case_audit_log (
    log_id      INT AUTO_INCREMENT PRIMARY KEY,
    case_id     INT,
    old_status  VARCHAR(30),
    new_status  VARCHAR(30),
    changed_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$
CREATE TRIGGER trg_case_status_change
AFTER UPDATE ON case_info
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status THEN
        INSERT INTO case_audit_log(case_id, old_status, new_status)
        VALUES (NEW.case_id, OLD.status, NEW.status);
    END IF;
END$$
DELIMITER ;

-- ─────────────────────────────────────────────
-- STORED PROCEDURE: get_cases_by_date_range
-- ─────────────────────────────────────────────
DELIMITER $$
CREATE PROCEDURE get_cases_by_date_range(
    IN p_start DATE,
    IN p_end   DATE
)
BEGIN
    SELECT c.*, COUNT(e.evidence_id) AS evidence_count
    FROM case_info c
    LEFT JOIN evidence e ON c.case_id = e.case_id
    WHERE c.registered_date BETWEEN p_start AND p_end
    GROUP BY c.case_id
    ORDER BY c.registered_date DESC;
END$$
DELIMITER ;

-- ─────────────────────────────────────────────
-- SEED DATA
-- ─────────────────────────────────────────────
-- Default admin  password: Admin@123  (BCrypt hash below is illustrative)
INSERT INTO user (username, password, role, full_name, email) VALUES
('admin',   '$2a$12$exampleHashForAdminPassword123456789012345678', 'admin',   'System Administrator', 'admin@forensafe.gov'),
('officer1','$2a$12$exampleHashForOfficer1Password12345678901234', 'officer', 'John Reeves',          'jreeves@forensafe.gov'),
('clerk1',  '$2a$12$exampleHashForClerk1Password123456789012345',  'clerk',   'Maria Santos',         'msantos@forensafe.gov');

INSERT INTO officer (name, rank, phone, email, user_id) VALUES
('John Reeves',   'Detective',         '9000000001', 'jreeves@forensafe.gov',   2),
('Sarah Connor',  'Senior Inspector',  '9000000002', 'sconnor@forensafe.gov',   NULL),
('Raj Malhotra',  'Sub-Inspector',     '9000000003', 'rmalhotra@forensafe.gov', NULL);

INSERT INTO case_info (title, description, case_type, status, registered_date, created_by) VALUES
('Cyber Fraud – Case #CF001', 'Phishing attack targeting bank customers.',           'Cyber Crime',  'Open',                 '2026-01-15', 1),
('Data Breach – TechCorp',    'Unauthorized access to employee PII database.',       'Data Breach',  'Under Investigation',   '2026-02-01', 1),
('Ransomware – Hospital Net', 'Ransomware deployed across hospital internal network.','Ransomware',   'Closed',               '2025-11-20', 1);

INSERT INTO evidence (case_id, evidence_type, description, collected_date, collected_by) VALUES
(1, 'Email Log',      'Phishing email headers and metadata.',         '2026-01-16', 'John Reeves'),
(1, 'Network Packet', 'PCAP file from compromised workstation.',      '2026-01-17', 'John Reeves'),
(2, 'Database Dump',  'Partial dump showing unauthorized SELECTs.',   '2026-02-03', 'Sarah Connor'),
(3, 'Malware Sample', 'Ransomware binary isolated in sandbox.',       '2025-11-21', 'Raj Malhotra');

INSERT INTO case_assignment (case_id, officer_id, assigned_date) VALUES
(1, 1, '2026-01-15'),
(2, 2, '2026-02-01'),
(2, 1, '2026-02-02'),
(3, 3, '2025-11-20');

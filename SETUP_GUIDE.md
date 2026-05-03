# 🔐 FORENSAFE – Setup & Deployment Guide
## Digital Evidence Chain-of-Custody Management System

---

## ✅ PREREQUISITES – Install These First

| Tool | Version | Download |
|------|---------|----------|
| JDK | 11 or 17 | https://adoptium.net |
| Apache Tomcat | 9.x or 10.x | https://tomcat.apache.org |
| MySQL | 8.0+ | https://dev.mysql.com/downloads |
| Maven | 3.8+ | https://maven.apache.org |
| MySQL Workbench | Latest | https://dev.mysql.com/downloads/workbench |

> **Alternatively:** Use XAMPP for MySQL (start MySQL module from XAMPP Control Panel)

---

## 📁 PROJECT STRUCTURE

```
forensafe/
├── pom.xml                          ← Maven build file
├── sql/
│   └── digital_evidb.sql            ← Full database schema + seed data
└── src/main/
    ├── java/com/forensafe/
    │   ├── model/                   ← JavaBeans (Officer, Case, Evidence...)
    │   ├── dao/                     ← Database access (OfficerDAO, CaseDAO...)
    │   ├── servlet/                 ← Controllers (LoginServlet, CaseServlet...)
    │   ├── filter/                  ← AuthFilter (session guard)
    │   └── util/                    ← DBConnection, PasswordUtil
    └── webapp/
        ├── WEB-INF/web.xml          ← Deployment descriptor
        ├── css/style.css            ← Dark forensic theme
        ├── js/main.js               ← Charts, search, export
        ├── login.jsp                ← Login page
        └── jsp/                     ← All other pages
            ├── shared/sidebar.jsp
            ├── dashboard.jsp
            ├── cases.jsp
            ├── case_form.jsp
            ├── evidence_list.jsp
            ├── evidence_form.jsp
            ├── custody_chain.jsp
            ├── officers.jsp
            ├── officer_form.jsp
            ├── reports.jsp
            └── error.jsp
```

---

## 🗄️ STEP 1 – Set Up the Database

### Option A: Using MySQL Workbench
1. Open MySQL Workbench
2. Connect to your local MySQL server
3. Click **File → Open SQL Script**
4. Open the file: `forensafe/sql/digital_evidb.sql`
5. Click ⚡ **Execute All** (Ctrl+Shift+Enter)
6. You should see `digital_evidb` appear in the Schemas panel

### Option B: Using Command Line
```bash
# Login to MySQL
mysql -u root -p

# Run the SQL file
SOURCE /path/to/forensafe/sql/digital_evidb.sql;

# Verify tables were created
USE digital_evidb;
SHOW TABLES;
```

**Expected tables:**
```
OFFICER, CASE, STORAGE_LOCATION, FORENSIC_TOOL, EVIDENCE,
FORENSIC_REPORT, CUSTODY_TRANSFER, ACCESS_LOG,
EVIDENCE_MEDIA, EVIDENCE_ANALYSIS_LOG
```

---

## ⚙️ STEP 2 – Configure Database Connection

Open this file:
```
src/main/java/com/forensafe/util/DBConnection.java
```

Update these lines:
```java
private static final String DB_URL  = "jdbc:mysql://localhost:3306/digital_evidb?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
private static final String DB_USER = "root";
private static final String DB_PASS = "YOUR_MYSQL_PASSWORD_HERE";  // ← CHANGE THIS
```

> **Note:** If you're using XAMPP, the default MySQL password is usually empty ("").
> If you set a password during MySQL install, use that.

---

## 🔧 STEP 3 – Fix the Seed Data Passwords (IMPORTANT)

The `digital_evidb.sql` file contains **placeholder BCrypt hashes** for the seed users.
You need to replace them with **real BCrypt hashes** for your chosen passwords.

### Quick Fix – Run this Java snippet once:

Create a file `HashGen.java` anywhere and run it:
```java
import org.mindrot.jbcrypt.BCrypt;
public class HashGen {
    public static void main(String[] args) {
        System.out.println("admin123: " + BCrypt.hashpw("admin123", BCrypt.gensalt(10)));
        System.out.println("officer123: " + BCrypt.hashpw("officer123", BCrypt.gensalt(10)));
        System.out.println("analyst123: " + BCrypt.hashpw("analyst123", BCrypt.gensalt(10)));
    }
}
```

Then in MySQL Workbench, run:
```sql
USE digital_evidb;
UPDATE OFFICER SET password='$2a$10$YOUR_HASH_HERE' WHERE officer_id='OFC001';
UPDATE OFFICER SET password='$2a$10$YOUR_HASH_HERE' WHERE officer_id='OFC002';
UPDATE OFFICER SET password='$2a$10$YOUR_HASH_HERE' WHERE officer_id='OFC003';
```

**Or** use this shortcut – delete seed officers and re-insert them via the app after first login with a temporary known-good hash.

### ✅ Easiest workaround for testing:
Add this to `OfficerDAO.authenticate()` temporarily for plain-text comparison during dev:
```java
// TEMP: plain text compare for dev
if (password.equals(hashed)) { return mapRow(rs); }
```
Then update the DB to store plain passwords `admin123`, `officer123`, `analyst123` temporarily.

---

## 📦 STEP 4 – Build the Project with Maven

Open a terminal/command prompt in the `forensafe/` directory:

```bash
# Clean and build (generates forensafe.war in target/)
mvn clean package -DskipTests

# If successful, you'll see:
# [INFO] BUILD SUCCESS
# target/forensafe.war created
```

**If Maven is not installed:**
- Download from https://maven.apache.org/download.cgi
- Unzip and add `bin/` to your system PATH
- Verify: `mvn --version`

---

## 🚀 STEP 5 – Deploy to Apache Tomcat

### Method A: Copy WAR file (easiest)
```bash
# Copy the WAR to Tomcat's webapps folder
cp target/forensafe.war /path/to/tomcat/webapps/

# Tomcat will auto-deploy it
```

**Tomcat locations:**
- Windows: `C:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\`
- Linux/Mac: `/opt/tomcat/webapps/` or `~/tomcat/webapps/`
- XAMPP: `C:\xampp\tomcat\webapps\`

### Method B: Deploy via Tomcat Manager
1. Start Tomcat (run `startup.bat` or `startup.sh`)
2. Open browser: `http://localhost:8080/manager/html`
3. Login with Tomcat admin credentials
4. Scroll to "WAR file to deploy" → choose `forensafe.war` → Deploy

### Method C: Using IntelliJ IDEA
1. Open project in IntelliJ
2. Go to **Run → Edit Configurations**
3. Add **Tomcat Server → Local**
4. Set Tomcat installation path
5. Under **Deployment** tab → Add `forensafe:war exploded`
6. Set Application context to `/forensafe`
7. Click ▶️ **Run**

### Method D: Using Eclipse
1. Open Eclipse → File → Import → Maven → Existing Maven Project
2. Right-click project → **Run As → Run on Server**
3. Choose Tomcat server → Finish

---

## 🌐 STEP 6 – Access the Application

Open your browser and go to:
```
http://localhost:8080/forensafe
```

You will be redirected to the **login page**.

### 🧪 Demo Login Credentials

| Username | Password | Role |
|----------|----------|------|
| `admin` | `admin123` | Admin (full access) |
| `ravi` | `officer123` | Officer |
| `priya` | `analyst123` | Analyst |

> ⚠️ Remember to update the BCrypt hashes in the DB (see Step 3)!

---

## 🗺️ APPLICATION PAGES & URLs

| URL | Description |
|-----|-------------|
| `/forensafe/login` | Login page |
| `/forensafe/dashboard` | Main dashboard with stats & charts |
| `/forensafe/cases` | All cases list with filter |
| `/forensafe/cases?action=add` | Register new case |
| `/forensafe/cases?action=edit&id=CASE001` | Edit a case |
| `/forensafe/cases?action=view&id=CASE001` | View case details |
| `/forensafe/evidence` | All evidence items |
| `/forensafe/evidence?action=add` | Add new evidence |
| `/forensafe/evidence?action=chain&id=EV001` | Chain of custody view |
| `/forensafe/evidence?action=byCase&caseId=CASE001` | Evidence for a case |
| `/forensafe/officers` | Officer list |
| `/forensafe/officers?action=add` | Add new officer |
| `/forensafe/reports` | Reports module |
| `/forensafe/reports?type=active` | Active cases report |
| `/forensafe/reports?type=closed` | Closed cases report |
| `/forensafe/logout` | Logout |

---

## 🔐 ROLE-BASED ACCESS

| Feature | Admin | Officer | Analyst |
|---------|-------|---------|---------|
| View Dashboard | ✅ | ✅ | ✅ |
| View All Cases | ✅ | ✅ | ✅ |
| Add/Edit Case | ✅ | ✅ | ✅ |
| Delete Case | ✅ | ❌ | ❌ |
| Add Evidence | ✅ | ✅ | ✅ |
| Delete Evidence | ✅ | ❌ | ❌ |
| View Chain of Custody | ✅ | ✅ | ✅ |
| Record Custody Transfer | ✅ | ✅ | ✅ |
| View Officers | ✅ | ✅ | ✅ |
| Add/Edit Officers | ✅ | ❌ | ❌ |
| Delete Officers | ✅ | ❌ | ❌ |
| View Reports | ✅ | ✅ | ✅ |
| Export CSV | ✅ | ✅ | ✅ |

---

## 🗃️ DATABASE FEATURES IMPLEMENTED

### Constraints
- PRIMARY KEY on all tables
- FOREIGN KEY with CASCADE on Evidence, CustodyTransfer, AccessLog, etc.
- UNIQUE on username (OFFICER)
- NOT NULL on critical fields

### Advanced SQL
- **JOINS** – Evidence + CASE + STORAGE_LOCATION in all queries
- **GROUP BY** – Evidence count per case, monthly stats
- **HAVING** – Used in workload stored procedure
- **VIEWS** – `v_active_cases`, `v_evidence_chain`
- **INDEXES** – On case status, date, evidence case_id
- **TRIGGERS** – `trg_custody_access_log` (auto-logs custody receipts)
- **STORED PROCEDURES** – `sp_cases_by_range`, `sp_officer_workload`
- **PreparedStatement** – Used everywhere (SQL injection prevention)

---

## 🛡️ SECURITY FEATURES

- **BCrypt password hashing** via jbcrypt library
- **PreparedStatement** throughout (no SQL injection possible)
- **Session management** with HttpSession
- **AuthFilter** blocks all pages without valid session
- **30-minute session timeout**
- **Cache-Control headers** prevent back-button access after logout
- **Role-based access control** (admin/officer/analyst)
- **Server-side input validation**
- **Client-side JavaScript validation**

---

## 🐛 TROUBLESHOOTING

### ❌ "Access denied for user 'root'@'localhost'"
→ Wrong password in `DBConnection.java`. Double-check MySQL password.

### ❌ "Communications link failure"
→ MySQL is not running. Start it from XAMPP or Services.

### ❌ 404 on all pages
→ WAR not deployed. Check `webapps/forensafe/` folder exists in Tomcat.

### ❌ "ClassNotFoundException: com.mysql.cj.jdbc.Driver"
→ MySQL connector JAR not in classpath. Maven should handle this automatically.
If not, manually copy `mysql-connector-java-8.0.33.jar` to Tomcat's `lib/` folder.

### ❌ BCrypt verify always fails
→ Seed data hashes are placeholders. See Step 3 to regenerate real hashes.

### ❌ JSP shows raw code / EL not resolving
→ Add `<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>` at top.
Ensure jstl-1.2.jar is in WEB-INF/lib or Maven dependencies are bundled.

### ❌ "Table 'CASE' not found"
→ MySQL is case-sensitive on Linux. The SQL uses backticks: `` `CASE` ``.
Make sure you ran the SQL file on the correct MySQL server.

---

## 📝 VIVA PREPARATION NOTES

### Database Concepts to Explain:
- **Primary Key** – `officer_id`, `case_id`, `evidence_id` — uniquely identify each row
- **Composite Primary Key** – `CUSTODY_TRANSFER(evidence_id, transfer_no)` — weak entity
- **Foreign Key** – `EVIDENCE.case_id → CASE.case_id` with CASCADE UPDATE
- **Weak Entity** – `CUSTODY_TRANSFER`, `ACCESS_LOG`, `EVIDENCE_MEDIA` (depend on EVIDENCE)
- **1NF** – All columns atomic, no repeating groups
- **2NF** – No partial dependencies (all non-key columns depend on full PK)
- **3NF** – No transitive dependencies (each non-key attribute depends only on PK)
- **Cardinality** – CASE:EVIDENCE = 1:N, CASE:OFFICER (via CUSTODY_TRANSFER) = M:N

### Architecture to Explain:
- **Presentation Layer** – JSP + HTML/CSS/JS (login.jsp, dashboard.jsp, etc.)
- **Business Logic Layer** – Java Servlets + JavaBeans (CaseServlet, OfficerDAO, etc.)
- **Data Layer** – MySQL Database accessed via JDBC (PreparedStatement)
- **MVC Pattern** – Model=JavaBeans, View=JSP, Controller=Servlet
- **3-Tier** = Client browser ↔ Tomcat Server (Java) ↔ MySQL Database

---

*Forensafe v1.0 – Built with Java Servlet + JSP + MySQL*

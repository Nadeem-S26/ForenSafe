<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Forensafe – Add Evidence</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<%@ include file="shared/sidebar.jsp" %>

<div class="main-content">
  <div class="topbar">
    <button id="menuToggle" class="btn btn-ghost btn-icon">☰</button>
    <span class="topbar-title">➕ Add New Evidence</span>
    <span class="topbar-badge badge-<%= _role %>"><%= _role.toUpperCase() %></span>
  </div>

  <div class="page-body">
    <div class="page-header">
      <div>
        <div class="page-title">Add Evidence Item</div>
        <div class="page-subtitle">Record new evidence and link it to a case</div>
      </div>
      <a href="<%= request.getContextPath() %>/evidence" class="btn btn-ghost">← Back</a>
    </div>

    <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>

    <div class="card">
      <div class="card-header"><span class="card-title">Evidence Details</span></div>
      <div class="card-body">
        <form method="post" action="<%= request.getContextPath() %>/evidence">
          <div class="form-grid">
            <div class="form-group">
              <label>Evidence ID *</label>
              <input type="text" name="evidenceId" placeholder="e.g. EV005" required>
            </div>
            <div class="form-group">
              <label>Linked Case *</label>
              <select name="caseId" required>
                <option value="">-- Select Case --</option>
                <c:forEach var="c" items="${cases}">
                  <option value="${c.caseId}">${c.caseId} – ${c.caseTitle}</option>
                </c:forEach>
              </select>
            </div>
            <div class="form-group">
              <label>Evidence Type *</label>
              <select name="evidenceType" required>
                <option value="">-- Select Type --</option>
                <% String[] evTypes = {"Email Log","Network PCAP","Hard Disk Image","Malware Sample","Database Dump","Memory Dump","Mobile Device","Log Files","Screenshots","Other"}; %>
                <% for (String t : evTypes) { %>
                  <option value="<%= t %>"><%= t %></option>
                <% } %>
              </select>
            </div>
            <div class="form-group">
              <label>Storage Location ID</label>
              <input type="text" name="storageId" placeholder="e.g. SL001">
            </div>
            <div class="form-group">
              <label>Serial / Reference Number</label>
              <input type="text" name="serialNumber" placeholder="Device serial or N/A">
            </div>
            <div class="form-group">
              <label>Seized Date *</label>
              <input type="date" name="seizedDate" required>
            </div>
            <div class="form-group">
              <label>Seized Street</label>
              <input type="text" name="seizedStreet" placeholder="Street of seizure">
            </div>
            <div class="form-group">
              <label>Seized Area / City</label>
              <input type="text" name="seizedArea" placeholder="City or area">
            </div>
            <div class="form-group">
              <label>Pincode</label>
              <input type="text" name="seizedPincode" maxlength="10" placeholder="Pincode">
            </div>
            <div class="form-group">
              <label>Current Status *</label>
              <select name="currentStatus" required>
                <option value="Collected">Collected</option>
                <option value="In Lab">In Lab</option>
                <option value="Stored">Stored</option>
                <option value="Released">Released</option>
              </select>
            </div>
            <div class="form-group full">
              <label>Description *</label>
              <textarea name="description" rows="3" placeholder="Detailed description of this evidence item..." required></textarea>
            </div>
            <div class="form-group full">
              <label>SHA-256 Hash Value <span style="color:var(--accent-green);font-size:10px;font-weight:400">(AUTO-GENERATED IF LEFT BLANK)</span></label>
              <div style="display:flex;gap:8px">
                <input type="text" id="hashInput" name="hashValue" class="hash-input"
                  placeholder="Leave blank to auto-generate · or enter a pre-computed hash">
                <button type="button" class="btn btn-ghost btn-sm" onclick="generateHash('hashInput','hashInput')"
                  title="Manually generate hash">🔑 Generate</button>
                <button type="button" class="btn btn-ghost btn-sm" onclick="clearHash()"
                  title="Clear to use auto-generate">✕ Clear</button>
              </div>
              <div style="margin-top:8px;padding:10px 12px;background:rgba(0,255,157,0.05);border:1px solid rgba(0,255,157,0.15);border-radius:6px;font-size:12px;color:var(--accent-green)">
                🤖 <strong>Auto-hash:</strong> If left blank, the system will automatically generate a unique
                SHA-256 hash from the evidence ID + type + seized date + serial number + timestamp.
              </div>
            </div>
          </div>
          <div style="margin-top:24px;display:flex;gap:12px">
            <button type="submit" class="btn btn-primary">➕ Add Evidence</button>
            <a href="<%= request.getContextPath() %>/evidence" class="btn btn-ghost">Cancel</a>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>

<script src="<%= request.getContextPath() %>/js/main.js"></script>
<script>
function clearHash() {
  document.getElementById('hashInput').value = '';
  document.getElementById('hashInput').placeholder = 'Leave blank to auto-generate · or enter a pre-computed hash';
}
</script>
</body>
</html>

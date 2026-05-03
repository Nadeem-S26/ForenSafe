<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page import="com.forensafe.model.Evidence" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<%
  Evidence evObj = (Evidence) request.getAttribute("evidenceObj");
  boolean isNewEv = (evObj == null);
%>
<title>Forensafe – <%= isNewEv ? "Add Evidence" : "Edit Evidence" %></title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<%@ include file="shared/sidebar.jsp" %>

<div class="main-content">
  <div class="page-body">
    <div class="page-header">
      <div>
        <div class="page-title"><%= isNewEv ? "Add Evidence Item" : "Edit Evidence: " + evObj.getEvidenceId() %></div>
        <div class="page-subtitle"><%= isNewEv ? "Record new evidence and link it to a case" : "Modify existing evidence record" %></div>
      </div>
      <a href="<%= request.getContextPath() %>/evidence" class="btn btn-ghost">← Back</a>
    </div>

    <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>

    <div class="card">
      <div class="card-header"><span class="card-title">Evidence Details</span></div>
      <div class="card-body">
        <form method="post" action="<%= request.getContextPath() %>/evidence">
          <input type="hidden" name="isNew" value="<%= isNewEv ? "1" : "" %>">
          <div class="form-grid">
            <div class="form-group">
              <label>Evidence ID *</label>
              <input type="text" name="evidenceId"
                value="<%= isNewEv ? "" : evObj.getEvidenceId() %>"
                placeholder="e.g. EV005"
                <%= isNewEv ? "required" : "readonly style='opacity:0.6'" %>>
            </div>
            <div class="form-group">
              <label>Linked Case *</label>
              <select name="caseId" required>
                <option value="">-- Select Case --</option>
                <c:forEach var="c" items="${cases}">
                  <option value="${c.caseId}" ${!isNewEv && c.caseId == evidenceObj.caseId ? 'selected' : ''}>${c.caseId} – ${c.caseTitle}</option>
                </c:forEach>
              </select>
            </div>
            <div class="form-group">
              <label>Evidence Type *</label>
              <select name="evidenceType" required>
                <option value="">-- Select Type --</option>
                <% String[] evTypes = {"Email Log","Network PCAP","Hard Disk Image","Malware Sample","Database Dump","Memory Dump","Mobile Device","Log Files","Screenshots","Other"}; %>
                <% for (String t : evTypes) { boolean sel = !isNewEv && t.equals(evObj.getEvidenceType()); %>
                  <option value="<%= t %>" <%= sel ? "selected" : "" %>><%= t %></option>
                <% } %>
              </select>
            </div>
            <div class="form-group">
              <label>Storage Location ID</label>
              <input type="text" name="storageId" value="<%= isNewEv ? "" : (evObj.getStorageId() != null ? evObj.getStorageId() : "") %>" placeholder="e.g. SL001">
            </div>
            <div class="form-group">
              <label>Serial / Reference Number</label>
              <input type="text" name="serialNumber" value="<%= isNewEv ? "" : (evObj.getSerialNumber() != null ? evObj.getSerialNumber() : "") %>" placeholder="Device serial or N/A">
            </div>
            <div class="form-group">
              <label>Seized Date *</label>
              <input type="date" name="seizedDate" value="<%= isNewEv ? "" : evObj.getSeizedDate() %>" required>
            </div>
            <div class="form-group">
              <label>Seized Street</label>
              <input type="text" name="seizedStreet" value="<%= isNewEv ? "" : (evObj.getSeizedStreet() != null ? evObj.getSeizedStreet() : "") %>" placeholder="Street of seizure">
            </div>
            <div class="form-group">
              <label>Seized Area / City</label>
              <input type="text" name="seizedArea" value="<%= isNewEv ? "" : (evObj.getSeizedArea() != null ? evObj.getSeizedArea() : "") %>" placeholder="City or area">
            </div>
            <div class="form-group">
              <label>Pincode</label>
              <input type="text" name="seizedPincode" value="<%= isNewEv ? "" : (evObj.getSeizedPincode() != null ? evObj.getSeizedPincode() : "") %>" maxlength="10" placeholder="Pincode">
            </div>
            <div class="form-group">
              <label>Current Status *</label>
              <select name="currentStatus" required>
                <% String[] statuses = {"Collected","In Lab","Stored","Released"}; %>
                <% for (String s : statuses) { boolean sel = !isNewEv && s.equals(evObj.getCurrentStatus()); %>
                  <option value="<%= s %>" <%= sel ? "selected" : "" %>><%= s %></option>
                <% } %>
              </select>
            </div>
            <div class="form-group full">
              <label>Description *</label>
              <textarea name="description" rows="3" placeholder="Detailed description of this evidence item..." required><%= isNewEv ? "" : evObj.getDescription() %></textarea>
            </div>
            <div class="form-group full">
              <label>SHA-256 Hash Value <span style="color:var(--accent-green);font-size:10px;font-weight:400">(AUTO-GENERATED IF LEFT BLANK)</span></label>
              <div style="display:flex;gap:8px">
                <input type="text" id="hashInput" name="hashValue" class="hash-input"
                  value="<%= isNewEv ? "" : evObj.getHashValue() %>"
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
            <button type="submit" class="btn btn-primary"><%= isNewEv ? "➕ Add Evidence" : "💾 Save Changes" %></button>
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

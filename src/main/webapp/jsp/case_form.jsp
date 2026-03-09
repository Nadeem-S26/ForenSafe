<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.forensafe.model.Case" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Forensafe – Case Form</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<%@ include file="shared/sidebar.jsp" %>

<%
  Case caseObj = (Case) request.getAttribute("caseObj");
  boolean isNew = (caseObj == null);
%>

<div class="main-content">
  <div class="topbar">
    <button id="menuToggle" class="btn btn-ghost btn-icon">☰</button>
    <span class="topbar-title"><%= isNew ? "➕ Add New Case" : "✏ Edit Case" %></span>
    <span class="topbar-badge badge-<%= _role %>"><%= _role.toUpperCase() %></span>
  </div>

  <div class="page-body">
    <div class="page-header">
      <div>
        <div class="page-title"><%= isNew ? "Register New Case" : "Edit Case: " + caseObj.getCaseId() %></div>
        <div class="page-subtitle"><%= isNew ? "Fill in the case details below" : "Modify the case information" %></div>
      </div>
      <a href="<%= request.getContextPath() %>/cases" class="btn btn-ghost">← Back to Cases</a>
    </div>

    <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>

    <div class="card">
      <div class="card-header">
        <span class="card-title">Case Information</span>
      </div>
      <div class="card-body">
        <form method="post" action="<%= request.getContextPath() %>/cases" onsubmit="return validateCaseForm()">
          <input type="hidden" name="isNew" value="<%= isNew ? "1" : "" %>">

          <div class="form-grid">
            <div class="form-group">
              <label for="caseId">Case ID *</label>
              <input type="text" id="caseId" name="caseId"
                value="<%= isNew ? "" : caseObj.getCaseId() %>"
                placeholder="e.g. CASE005"
                <%= isNew ? "required" : "readonly style='opacity:0.6'" %>>
            </div>
            <div class="form-group">
              <label for="crimeType">Crime Type *</label>
              <select id="crimeType" name="crimeType" required>
                <option value="">-- Select Type --</option>
                <% String[] types = {"Cyber Fraud","Data Breach","Ransomware","Identity Theft","Phishing","Network Intrusion","Malware Attack","Digital Forgery","Other"}; %>
                <% for (String t : types) {
                     boolean sel = !isNew && t.equals(caseObj.getCrimeType()); %>
                  <option value="<%= t %>" <%= sel ? "selected" : "" %>><%= t %></option>
                <% } %>
              </select>
            </div>

            <div class="form-group full">
              <label for="caseTitle">Case Title *</label>
              <input type="text" id="caseTitle" name="caseTitle"
                value="<%= isNew ? "" : caseObj.getCaseTitle() %>"
                placeholder="Descriptive title for this case" required>
            </div>

            <div class="form-group full">
              <label for="description">Description *</label>
              <textarea id="description" name="description" rows="4" placeholder="Detailed description of the incident..." required><%= isNew ? "" : caseObj.getDescription() %></textarea>
            </div>

            <div class="form-group">
              <label for="dateRegistered">Date Registered *</label>
              <input type="date" id="dateRegistered" name="dateRegistered"
                value="<%= isNew ? "" : caseObj.getDateRegistered() %>" required>
            </div>
            <div class="form-group">
              <label for="status">Status *</label>
              <select id="status" name="status" required>
                <% String[] statuses = {"Open","Under Investigation","Closed"}; %>
                <% for (String s : statuses) {
                     boolean sel = !isNew && s.equals(caseObj.getStatus()); %>
                  <option value="<%= s %>" <%= sel ? "selected" : "" %>><%= s %></option>
                <% } %>
              </select>
            </div>

            <div class="form-group">
              <label for="street">Street / Address</label>
              <input type="text" id="street" name="street"
                value="<%= isNew ? "" : (caseObj.getStreet() != null ? caseObj.getStreet() : "") %>"
                placeholder="Street address">
            </div>
            <div class="form-group">
              <label for="area">City / Area</label>
              <input type="text" id="area" name="area"
                value="<%= isNew ? "" : (caseObj.getArea() != null ? caseObj.getArea() : "") %>"
                placeholder="Area or City">
            </div>
            <div class="form-group">
              <label for="pincode">Pincode</label>
              <input type="text" id="pincode" name="pincode" maxlength="10"
                value="<%= isNew ? "" : (caseObj.getPincode() != null ? caseObj.getPincode() : "") %>"
                placeholder="6-digit pincode">
            </div>
          </div>

          <div style="margin-top:24px;display:flex;gap:12px">
            <button type="submit" class="btn btn-primary">
              <%= isNew ? "➕ Register Case" : "💾 Save Changes" %>
            </button>
            <a href="<%= request.getContextPath() %>/cases" class="btn btn-ghost">Cancel</a>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>

<script src="<%= request.getContextPath() %>/js/main.js"></script>
<script>
function validateCaseForm() {
  const caseId = document.getElementById('caseId').value.trim();
  if (caseId && !/^[A-Za-z0-9_-]+$/.test(caseId)) {
    alert('Case ID must contain only letters, numbers, hyphens, and underscores.');
    return false;
  }
  const date = document.getElementById('dateRegistered').value;
  if (!date) { alert('Please select a date.'); return false; }
  return true;
}
</script>
</body>
</html>

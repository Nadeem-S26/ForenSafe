<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.forensafe.model.Case" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
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
  String currentStatus = isNew ? "Open" : caseObj.getStatus();
%>

<div class="main-content">
  <div class="page-body">
    <div class="page-header">
      <div>
        <div class="page-title">
          <%= isNew ? "REGISTER <span>NEW CASE</span>" : "EDIT <span>CASE</span>" %>
        </div>
        <div class="page-subtitle">
          <%= isNew ? "// FILL IN CASE DETAILS BELOW" : "// MODIFYING: " + caseObj.getCaseId() %>
        </div>
      </div>
      <a href="<%= request.getContextPath() %>/cases" class="btn btn-ghost">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-chevron-left"/></svg>
        Back to Cases
      </a>
    </div>

    <c:if test="${not empty error}">
      <div class="alert alert-danger">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-alert"/></svg>
        ${error}
      </div>
    </c:if>

    <div class="card">
      <div class="card-header">
        <span class="card-title">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor" style="vertical-align:middle;margin-right:6px"><use href="#icon-cases"/></svg>
          Case Information
        </span>
        <% if (!isNew) { %>
          <a href="<%= request.getContextPath() %>/cases?action=view&id=<%= caseObj.getCaseId() %>" class="btn btn-ghost btn-sm">
            <svg width="12" height="12" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-view"/></svg>
            View Case
          </a>
        <% } %>
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
                <%= isNew ? "required" : "readonly style='opacity:0.6;cursor:not-allowed'" %>>
            </div>

            <div class="form-group">
              <label for="crimeType">Crime Type *</label>
              <select id="crimeType" name="crimeType" required>
                <option value="">-- Select Type --</option>
                <% String[] types = {"Cyber Fraud","Data Breach","Ransomware","Identity Theft","Phishing","Network Intrusion","Malware Attack","Digital Forgery","Other"};
                   for (String t : types) {
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
              <textarea id="description" name="description" rows="4"
                placeholder="Detailed description of the incident..." required><%= isNew ? "" : caseObj.getDescription() %></textarea>
            </div>

            <div class="form-group">
              <label for="dateRegistered">Date Registered *</label>
              <input type="date" id="dateRegistered" name="dateRegistered"
                value="<%= isNew ? "" : caseObj.getDateRegistered() %>" required>
            </div>

            <%-- STATUS: always a dropdown, works for both new and edit --%>
            <div class="form-group">
              <label for="status">Status *</label>
              <select id="status" name="status" required>
                <% String[] statuses = {"Open","Under Investigation","Closed"};
                   for (String s : statuses) {
                     boolean sel = s.equals(currentStatus); %>
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

          <div class="form-actions">
            <button type="submit" class="btn btn-primary">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
                <use href="#<%= isNew ? "icon-add" : "icon-check" %>"/>
              </svg>
              <%= isNew ? "Register Case" : "Save Changes" %>
            </button>
            <a href="<%= request.getContextPath() %>/cases" class="btn btn-ghost">Cancel</a>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>

<script>
function validateCaseForm() {
  const caseId = document.getElementById('caseId').value.trim();
  if (caseId && !/^[A-Za-z0-9_-]+$/.test(caseId)) {
    alert('Case ID must contain only letters, numbers, hyphens, and underscores.');
    return false;
  }
  if (!document.getElementById('dateRegistered').value) {
    alert('Please select a date.');
    return false;
  }
  return true;
}
</script>
</body>
</html>

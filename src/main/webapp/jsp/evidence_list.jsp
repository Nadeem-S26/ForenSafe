<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Forensafe – Evidence Registry</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
<style>
.status-cell { display:flex; align-items:center; gap:6px; }
.status-change-form { display:inline-flex; align-items:center; }
.status-select-inline {
  background: var(--bg-input);
  border: 1px solid var(--border);
  color: var(--text-secondary);
  font-family: 'Share Tech Mono', monospace;
  font-size: 11px;
  padding: 3px 6px;
  cursor: pointer;
  outline: none;
  transition: all 0.2s;
  width: auto;
}
.status-select-inline:hover, .status-select-inline:focus {
  border-color: var(--accent);
  color: var(--accent);
}
</style>
</head>
<body>
<%@ include file="shared/sidebar.jsp" %>

<div class="main-content">
  <div class="page-body">

    <c:if test="${param.msg == 'added'}"><div class="alert alert-success auto-hide"><svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-check"/></svg> Evidence added successfully.</div></c:if>
    <c:if test="${param.msg == 'deleted'}"><div class="alert alert-danger auto-hide"><svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-delete"/></svg> Evidence deleted.</div></c:if>
    <c:if test="${param.msg == 'transferred'}"><div class="alert alert-success auto-hide"><svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-transfer"/></svg> Custody transfer recorded.</div></c:if>
    <c:if test="${param.msg == 'updated'}"><div class="alert alert-success auto-hide"><svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-check"/></svg> Evidence status updated.</div></c:if>
    <c:if test="${not empty error}"><div class="alert alert-danger"><svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-alert"/></svg> ${error}</div></c:if>

    <div class="page-header">
      <div>
        <div class="page-title">
          <c:choose>
            <c:when test="${not empty caseObj}">EVIDENCE FOR: <span>${caseObj.caseTitle}</span></c:when>
            <c:otherwise>EVIDENCE <span>VAULT</span></c:otherwise>
          </c:choose>
        </div>
        <div class="page-subtitle">// DIGITAL EVIDENCE WITH CHAIN-OF-CUSTODY TRACKING</div>
      </div>
      <div style="display:flex;gap:8px">
        <c:if test="${not empty caseObj}">
          <a href="<%= request.getContextPath() %>/cases?action=view&id=${caseObj.caseId}" class="btn btn-ghost">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-chevron-left"/></svg>
            Case
          </a>
        </c:if>
        <a href="<%= request.getContextPath() %>/evidence?action=add<c:if test="${not empty caseObj}">&caseId=${caseObj.caseId}</c:if>" class="btn btn-primary">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-add"/></svg>
          Add Evidence
        </a>
      </div>
    </div>

    <div class="filter-bar">
      <div class="filter-group" style="flex:1;max-width:400px">
        <label>Quick Search</label>
        <input type="text" id="evSearch" placeholder="Search by ID, type, case..." oninput="filterTable('evSearch','evTable')">
      </div>
      <button class="btn btn-ghost btn-sm" onclick="exportTableCSV('evTable','evidence_export.csv')">
        <svg width="13" height="13" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-export"/></svg>
        Export CSV
      </button>
    </div>

    <div class="card">
      <div class="card-header">
        <span class="card-title">Evidence Items</span>
        <span style="font-family:'Share Tech Mono',monospace;font-size:10px;color:var(--text-muted)">
          STATUS column: use dropdown to change status inline
        </span>
      </div>
      <div class="table-container">
        <table id="evTable">
          <thead>
            <tr>
              <th>Evidence ID</th>
              <th>Case</th>
              <th>Type</th>
              <th>Storage</th>
              <th>Seized Date</th>
              <th>Hash (SHA-256)</th>
              <th>Status</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
          <c:forEach var="ev" items="${evidence}">
            <tr>
              <td><span class="evidence-id-badge">${ev.evidenceId}</span></td>
              <td style="max-width:160px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">${ev.caseTitle}</td>
              <td>${ev.evidenceType}</td>
              <td style="font-size:12px">${ev.storageLocation}</td>
              <td style="font-family:'Share Tech Mono',monospace;font-size:12px">${ev.seizedDate}</td>
              <td>
                <span style="font-family:'Share Tech Mono',monospace;font-size:10px;color:var(--accent2)">
                  ${fn:substring(ev.hashValue, 0, 16)}…
                </span>
              </td>
              <td>
                <%-- Inline status change: dropdown posts directly --%>
                <form method="post" action="<%= request.getContextPath() %>/evidence"
                      class="status-change-form"
                      onchange="this.submit()"
                      title="Click to change status">
                  <input type="hidden" name="action" value="updateStatus">
                  <input type="hidden" name="evidenceId" value="${ev.evidenceId}">
                  <select name="status" class="status-select-inline"
                          title="Change status of ${ev.evidenceId}">
                    <option value="Collected"  ${ev.currentStatus == 'Collected'  ? 'selected' : ''}>Collected</option>
                    <option value="In Lab"     ${ev.currentStatus == 'In Lab'     ? 'selected' : ''}>In Lab</option>
                    <option value="Stored"     ${ev.currentStatus == 'Stored'     ? 'selected' : ''}>Stored</option>
                    <option value="Released"   ${ev.currentStatus == 'Released'   ? 'selected' : ''}>Released</option>
                  </select>
                </form>
              </td>
              <td>
                <a href="<%= request.getContextPath() %>/evidence?action=edit&id=${ev.evidenceId}" class="btn btn-ghost btn-sm" title="Edit details">
                  <svg width="12" height="12" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-edit"/></svg>
                </a>
                <a href="<%= request.getContextPath() %>/evidence?action=chain&id=${ev.evidenceId}" class="btn btn-ghost btn-sm">
                  <svg width="12" height="12" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-chain"/></svg>
                  Chain
                </a>
                <% if ("admin".equals(_role)) { %>
                  <button class="btn btn-danger btn-sm"
                    onclick="confirmDelete('<%= request.getContextPath() %>/evidence?action=delete&id=${ev.evidenceId}','${ev.evidenceId}')">
                    <svg width="12" height="12" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-delete"/></svg>
                  </button>
                <% } %>
              </td>
            </tr>
          </c:forEach>
          <c:if test="${empty evidence}">
            <tr><td colspan="8" style="text-align:center;padding:40px;color:var(--text-muted)">No evidence items found.</td></tr>
          </c:if>
          </tbody>
        </table>
      </div>
    </div>

  </div>
</div>
</body>
</html>

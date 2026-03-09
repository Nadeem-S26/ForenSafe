<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Forensafe – Evidence Registry</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<%@ include file="shared/sidebar.jsp" %>

<div class="main-content">
  <div class="topbar">
    <button id="menuToggle" class="btn btn-ghost btn-icon">☰</button>
    <span class="topbar-title">🔬 Evidence Registry</span>
    <span class="topbar-badge badge-<%= _role %>"><%= _role.toUpperCase() %></span>
  </div>

  <div class="page-body">

    <c:if test="${param.msg == 'added'}"><div class="alert alert-success auto-hide">✅ Evidence added successfully.</div></c:if>
    <c:if test="${param.msg == 'deleted'}"><div class="alert alert-danger auto-hide">🗑 Evidence deleted.</div></c:if>
    <c:if test="${param.msg == 'transferred'}"><div class="alert alert-success auto-hide">🔄 Custody transfer recorded.</div></c:if>
    <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>

    <div class="page-header">
      <div>
        <div class="page-title">
          <c:choose>
            <c:when test="${not empty caseObj}">Evidence for: ${caseObj.caseTitle}</c:when>
            <c:otherwise>All Evidence Items</c:otherwise>
          </c:choose>
        </div>
        <div class="page-subtitle">Digital evidence with chain-of-custody tracking</div>
      </div>
      <div style="display:flex;gap:8px">
        <c:if test="${not empty caseObj}">
          <a href="<%= request.getContextPath() %>/cases?action=view&id=${caseObj.caseId}" class="btn btn-ghost">← Case</a>
        </c:if>
        <a href="<%= request.getContextPath() %>/evidence?action=add<c:if test="${not empty caseObj}">&caseId=${caseObj.caseId}</c:if>" class="btn btn-primary">➕ Add Evidence</a>
      </div>
    </div>

    <!-- Search -->
    <div class="filter-bar">
      <div class="filter-group" style="flex:1;max-width:400px">
        <label>Quick Search</label>
        <input type="text" id="evSearch" placeholder="Search by ID, type, case..." oninput="filterTable('evSearch','evTable')">
      </div>
      <button class="btn btn-ghost btn-sm" onclick="exportTableCSV('evTable','evidence_export.csv')">📥 Export CSV</button>
    </div>

    <div class="card">
      <div class="card-header">
        <span class="card-title">Evidence Items</span>
      </div>
      <div class="table-container">
        <table id="evTable">
          <thead>
            <tr>
              <th>Evidence ID</th>
              <th>Case</th>
              <th>Type</th>
              <th>Storage Location</th>
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
              <td>${ev.caseTitle}</td>
              <td>${ev.evidenceType}</td>
              <td>${ev.storageLocation}</td>
              <td>${ev.seizedDate}</td>
              <td>
                <span style="font-family:'Share Tech Mono',monospace;font-size:10px;color:var(--accent-green)">
                  ${fn:substring(ev.hashValue, 0, 16)}…
                </span>
              </td>
              <td>
                <c:choose>
                  <c:when test="${ev.currentStatus == 'Collected'}"><span class="status-badge status-collected">${ev.currentStatus}</span></c:when>
                  <c:when test="${ev.currentStatus == 'In Lab'}"><span class="status-badge status-lab">${ev.currentStatus}</span></c:when>
                  <c:when test="${ev.currentStatus == 'Stored'}"><span class="status-badge status-stored">${ev.currentStatus}</span></c:when>
                  <c:otherwise><span class="status-badge status-released">${ev.currentStatus}</span></c:otherwise>
                </c:choose>
              </td>
              <td>
                <a href="<%= request.getContextPath() %>/evidence?action=chain&id=${ev.evidenceId}" class="btn btn-ghost btn-sm">🔗 Chain</a>
                <% if ("admin".equals(_role)) { %>
                  <button class="btn btn-danger btn-sm"
                    onclick="confirmDelete('<%= request.getContextPath() %>/evidence?action=delete&id=${ev.evidenceId}','${ev.evidenceId}')">🗑</button>
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

<script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>

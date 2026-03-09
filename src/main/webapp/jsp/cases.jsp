<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Forensafe – Cases</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<%@ include file="shared/sidebar.jsp" %>

<div class="main-content">
  <div class="topbar">
    <button id="menuToggle" class="btn btn-ghost btn-icon">☰</button>
    <span class="topbar-title">📁 Case Management</span>
    <span class="topbar-badge badge-<%= _role %>"><%= _role.toUpperCase() %></span>
  </div>

  <div class="page-body">

    <!-- Flash messages -->
    <c:if test="${param.msg == 'added'}"><div class="alert alert-success auto-hide">✅ Case added successfully.</div></c:if>
    <c:if test="${param.msg == 'updated'}"><div class="alert alert-success auto-hide">✅ Case updated successfully.</div></c:if>
    <c:if test="${param.msg == 'deleted'}"><div class="alert alert-danger auto-hide">🗑 Case deleted.</div></c:if>
    <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>

    <div class="page-header">
      <div>
        <div class="page-title">All Cases</div>
        <div class="page-subtitle">Search, filter, and manage all registered cases</div>
      </div>
      <a href="<%= request.getContextPath() %>/cases?action=add" class="btn btn-primary">➕ Add New Case</a>
    </div>

    <!-- Filter Bar -->
    <form method="get" action="<%= request.getContextPath() %>/cases">
      <div class="filter-bar">
        <div class="filter-group">
          <label>Filter by Status</label>
          <select name="status">
            <option value="">All Statuses</option>
            <option value="Open" ${filterStatus == 'Open' ? 'selected' : ''}>Open</option>
            <option value="Under Investigation" ${filterStatus == 'Under Investigation' ? 'selected' : ''}>Under Investigation</option>
            <option value="Closed" ${filterStatus == 'Closed' ? 'selected' : ''}>Closed</option>
          </select>
        </div>
        <div class="filter-group">
          <label>Date From</label>
          <input type="date" name="dateFrom" value="${filterFrom}">
        </div>
        <div class="filter-group">
          <label>Date To</label>
          <input type="date" name="dateTo" value="${filterTo}">
        </div>
        <div class="filter-group">
          <label>Quick Search</label>
          <input type="text" id="quickSearch" placeholder="Search table..." oninput="filterTable('quickSearch','casesTable')">
        </div>
        <button type="submit" class="btn btn-primary">🔍 Filter</button>
        <a href="<%= request.getContextPath() %>/cases" class="btn btn-ghost">✕ Clear</a>
      </div>
    </form>

    <!-- Table -->
    <div class="card">
      <div class="card-header">
        <span class="card-title">Case Registry</span>
        <button class="btn btn-ghost btn-sm" onclick="exportTableCSV('casesTable','cases_export.csv')">📥 Export CSV</button>
      </div>
      <div class="table-container">
        <table id="casesTable">
          <thead>
            <tr>
              <th>Case ID</th>
              <th>Title</th>
              <th>Crime Type</th>
              <th>Location</th>
              <th>Date Registered</th>
              <th>Status</th>
              <th>Evidence</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
          <c:forEach var="c" items="${cases}">
            <tr>
              <td><span class="evidence-id-badge">${c.caseId}</span></td>
              <td><strong>${c.caseTitle}</strong></td>
              <td>${c.crimeType}</td>
              <td>${c.area}</td>
              <td>${c.dateRegistered}</td>
              <td>
                <c:choose>
                  <c:when test="${c.status == 'Open'}"><span class="status-badge status-open">${c.status}</span></c:when>
                  <c:when test="${c.status == 'Under Investigation'}"><span class="status-badge status-investigation">${c.status}</span></c:when>
                  <c:otherwise><span class="status-badge status-closed">${c.status}</span></c:otherwise>
                </c:choose>
              </td>
              <td style="text-align:center">${c.evidenceCount}</td>
              <td>
                <a href="<%= request.getContextPath() %>/cases?action=view&id=${c.caseId}" class="btn btn-ghost btn-sm">👁 View</a>
                <a href="<%= request.getContextPath() %>/cases?action=edit&id=${c.caseId}" class="btn btn-ghost btn-sm">✏ Edit</a>
                <a href="<%= request.getContextPath() %>/evidence?action=byCase&caseId=${c.caseId}" class="btn btn-ghost btn-sm">🔬 Evidence</a>
                <% if ("admin".equals(_role)) { %>
                  <button class="btn btn-danger btn-sm"
                    onclick="confirmDelete('<%= request.getContextPath() %>/cases?action=delete&id=${c.caseId}','${c.caseTitle}')">
                    🗑
                  </button>
                <% } %>
              </td>
            </tr>
          </c:forEach>
          <c:if test="${empty cases}">
            <tr><td colspan="8" style="text-align:center;padding:40px;color:var(--text-muted)">No cases found matching the filter criteria.</td></tr>
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

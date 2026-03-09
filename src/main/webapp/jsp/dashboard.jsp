<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.forensafe.model.Case, java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Forensafe – Dashboard</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
</head>
<body>

<%@ include file="shared/sidebar.jsp" %>

<div class="main-content">
  <div class="topbar">
    <button id="menuToggle" class="btn btn-ghost btn-icon" style="display:none">☰</button>
    <span class="topbar-title">📊 Dashboard Overview</span>
    <span class="topbar-badge badge-<%= _role %>"><%= _role.toUpperCase() %></span>
  </div>

  <div class="page-body">

    <!-- Stat Cards -->
    <div class="stats-grid">
      <div class="stat-card" style="--card-accent: var(--accent-blue)">
        <div class="stat-icon">📁</div>
        <div class="stat-value">${totalCases}</div>
        <div class="stat-label">Total Cases</div>
      </div>
      <div class="stat-card" style="--card-accent: var(--accent-green)">
        <div class="stat-icon">🟢</div>
        <div class="stat-value">${openCases}</div>
        <div class="stat-label">Open Cases</div>
      </div>
      <div class="stat-card" style="--card-accent: var(--accent-amber)">
        <div class="stat-icon">🔍</div>
        <div class="stat-value">${activeCases}</div>
        <div class="stat-label">Under Investigation</div>
      </div>
      <div class="stat-card" style="--card-accent: var(--text-muted)">
        <div class="stat-icon">✅</div>
        <div class="stat-value">${closedCases}</div>
        <div class="stat-label">Closed Cases</div>
      </div>
      <div class="stat-card" style="--card-accent: var(--accent-purple)">
        <div class="stat-icon">🔬</div>
        <div class="stat-value">${totalEvidence}</div>
        <div class="stat-label">Evidence Items</div>
      </div>
      <div class="stat-card" style="--card-accent: var(--accent-blue)">
        <div class="stat-icon">👮</div>
        <div class="stat-value">${totalOfficers}</div>
        <div class="stat-label">Officers</div>
      </div>
    </div>

    <!-- Admin Quick Actions (admin only) -->
    <% if ("admin".equals(_role)) { %>
    <div class="card" style="margin-bottom:24px;border-color:rgba(0,212,255,0.3)">
      <div class="card-header" style="background:rgba(0,212,255,0.04)">
        <span class="card-title" style="color:var(--accent-blue)">⚡ Admin Quick Actions</span>
        <span style="font-size:11px;color:var(--text-muted)">Admin-only controls</span>
      </div>
      <div class="card-body" style="display:flex;gap:12px;flex-wrap:wrap">
        <a href="<%= request.getContextPath() %>/create-account" class="btn btn-primary">
          🔐 Create Officer Account
        </a>
        <a href="<%= request.getContextPath() %>/cases?action=add" class="btn btn-ghost">
          ➕ Add New Case
        </a>
        <a href="<%= request.getContextPath() %>/evidence?action=add" class="btn btn-ghost">
          🔬 Add Evidence
        </a>
        <a href="<%= request.getContextPath() %>/officers" class="btn btn-ghost">
          👮 Manage Officers
        </a>
        <a href="<%= request.getContextPath() %>/dbtest" class="btn btn-ghost" target="_blank">
          🔌 Verify DB Connection
        </a>
      </div>
    </div>
    <% } %>

    <!-- Charts -->
    <div class="grid-2" style="margin-bottom:24px">
      <div class="card">
        <div class="card-header">
          <span class="card-title">Case Status Distribution</span>
        </div>
        <div class="card-body" style="height:220px">
          <canvas id="statusChart"></canvas>
        </div>
      </div>
      <div class="card">
        <div class="card-header">
          <span class="card-title">Monthly Case Registrations</span>
        </div>
        <div class="card-body" style="height:220px">
          <canvas id="monthlyChart"></canvas>
        </div>
      </div>
    </div>

    <!-- Recent Cases -->
    <div class="card">
      <div class="card-header">
        <span class="card-title">Recent Cases</span>
        <a href="<%= request.getContextPath() %>/cases" class="btn btn-ghost btn-sm">View All →</a>
      </div>
      <div class="table-container">
        <table>
          <thead>
            <tr>
              <th>Case ID</th>
              <th>Title</th>
              <th>Crime Type</th>
              <th>Date Registered</th>
              <th>Status</th>
              <th>Evidence</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
          <c:forEach var="c" items="${recentCases}">
            <tr>
              <td><span class="evidence-id-badge">${c.caseId}</span></td>
              <td>${c.caseTitle}</td>
              <td>${c.crimeType}</td>
              <td>${c.dateRegistered}</td>
              <td>
                <c:choose>
                  <c:when test="${c.status == 'Open'}"><span class="status-badge status-open">${c.status}</span></c:when>
                  <c:when test="${c.status == 'Under Investigation'}"><span class="status-badge status-investigation">${c.status}</span></c:when>
                  <c:otherwise><span class="status-badge status-closed">${c.status}</span></c:otherwise>
                </c:choose>
              </td>
              <td>${c.evidenceCount}</td>
              <td>
                <a href="<%= request.getContextPath() %>/cases?action=view&id=${c.caseId}" class="btn btn-ghost btn-sm">View</a>
                <a href="<%= request.getContextPath() %>/evidence?action=byCase&caseId=${c.caseId}" class="btn btn-ghost btn-sm">Evidence</a>
              </td>
            </tr>
          </c:forEach>
          <c:if test="${empty recentCases}">
            <tr><td colspan="7" style="text-align:center;color:var(--text-muted);padding:30px">No cases found.</td></tr>
          </c:if>
          </tbody>
        </table>
      </div>
    </div>

  </div>
</div>

<script src="<%= request.getContextPath() %>/js/main.js"></script>
<script>
  <%
    Integer open   = (Integer) request.getAttribute("openCases");
    Integer active = (Integer) request.getAttribute("activeCases");
    Integer closed = (Integer) request.getAttribute("closedCases");
    if (open == null) open = 0;
    if (active == null) active = 0;
    if (closed == null) closed = 0;

    List<Object[]> monthly = (List<Object[]>) request.getAttribute("monthlyData");
    StringBuilder mLabels = new StringBuilder("[");
    StringBuilder mData   = new StringBuilder("[");
    if (monthly != null) {
      for (int i = monthly.size()-1; i >= 0; i--) {
        Object[] row = monthly.get(i);
        if (i < monthly.size()-1) { mLabels.append(","); mData.append(","); }
        mLabels.append("'").append(row[0]).append("'");
        mData.append(row[1]);
      }
    }
    mLabels.append("]"); mData.append("]");
  %>
  initDashboardCharts(
    [<%= open %>, <%= active %>, <%= closed %>],
    <%= mLabels %>,
    <%= mData %>
  );
</script>
</body>
</html>

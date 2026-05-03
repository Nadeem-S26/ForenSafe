<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Forensafe – Reports</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<%@ include file="shared/sidebar.jsp" %>

<div class="main-content">
  <div class="page-body">
    <div class="page-header">
      <div>
        <div class="page-title">FORENSIC <span>REPORTS</span></div>
        <div class="page-subtitle">// ${reportTitle} &mdash; Generated <%= new java.util.Date() %></div>
      </div>
      <div style="display:flex;gap:8px">
        <button class="btn btn-ghost" onclick="printReport()">🖨 Print</button>
        <button class="btn btn-ghost" onclick="exportTableCSV('reportTable','report_export.csv')">📥 CSV Export</button>
      </div>
    </div>

    <!-- Report Type Quick Links -->
    <div class="filter-bar" style="margin-bottom:20px">
      <a href="<%= request.getContextPath() %>/reports?type=active" class="btn btn-ghost btn-sm">🟢 Active Cases</a>
      <a href="<%= request.getContextPath() %>/reports?type=investigation" class="btn btn-ghost btn-sm">🟡 Under Investigation</a>
      <a href="<%= request.getContextPath() %>/reports?type=closed" class="btn btn-ghost btn-sm">✅ Closed Cases</a>
      <div style="flex:1"></div>
      <!-- Date Range Filter -->
      <form method="get" action="<%= request.getContextPath() %>/reports" style="display:flex;gap:8px;align-items:flex-end">
        <input type="hidden" name="type" value="range">
        <div class="filter-group">
          <label>From Date</label>
          <input type="date" name="from" value="${param.from}">
        </div>
        <div class="filter-group">
          <label>To Date</label>
          <input type="date" name="to" value="${param.to}">
        </div>
        <button type="submit" class="btn btn-primary btn-sm">🔍 Date Range</button>
      </form>
    </div>

    <!-- Summary Stats -->
    <div class="stats-grid" style="margin-bottom:20px">
      <div class="stat-card" style="--card-accent:var(--accent-blue)">
        <div class="stat-value">${fn:length(cases)}</div>
        <div class="stat-label">Cases in Report</div>
      </div>
    </div>

    <!-- Results Table -->
    <div class="card">
      <div class="card-header">
        <span class="card-title">${reportTitle}</span>
      </div>
      <div class="table-container">
        <table id="reportTable">
          <thead>
            <tr>
              <th>Case ID</th>
              <th>Case Title</th>
              <th>Crime Type</th>
              <th>Date Registered</th>
              <th>Area</th>
              <th>Status</th>
              <th>Evidence Count</th>
            </tr>
          </thead>
          <tbody>
          <c:forEach var="c" items="${cases}">
            <tr>
              <td><span class="evidence-id-badge">${c.caseId}</span></td>
              <td>${c.caseTitle}</td>
              <td>${c.crimeType}</td>
              <td>${c.dateRegistered}</td>
              <td>${c.area}</td>
              <td>
                <c:choose>
                  <c:when test="${c.status == 'Open'}"><span class="status-badge status-open">${c.status}</span></c:when>
                  <c:when test="${c.status == 'Under Investigation'}"><span class="status-badge status-investigation">${c.status}</span></c:when>
                  <c:otherwise><span class="status-badge status-closed">${c.status}</span></c:otherwise>
                </c:choose>
              </td>
              <td style="text-align:center">${c.evidenceCount}</td>
            </tr>
          </c:forEach>
          <c:if test="${empty cases}">
            <tr><td colspan="7" style="text-align:center;padding:40px;color:var(--text-muted)">No cases found for this report.</td></tr>
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

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Forensafe – Case Analytics</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
</head>
<body>
<%@ include file="shared/sidebar.jsp" %>

<div class="main-content">
<div class="page-body">

  <c:if test="${not empty error}">
    <div class="alert alert-danger">
      <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-alert"/></svg>
      ${error}
    </div>
  </c:if>

  <div class="page-header">
    <div>
      <div class="page-title">CASE <span>ANALYTICS</span></div>
      <div class="page-subtitle">// AGGREGATE FUNCTIONS &bull; SETS &bull; SUBQUERIES</div>
    </div>
  </div>

  <%-- Summary Counts --%>
  <div class="stats-grid" style="grid-template-columns:repeat(auto-fit,minmax(140px,1fr))">
    <div class="stat-card c1">
      <div class="stat-icon"><svg viewBox="0 0 24 24" fill="currentColor"><use href="#icon-cases"/></svg></div>
      <div class="stat-value">${summaryCounts.totalCases}</div>
      <div class="stat-label">Total Cases</div>
    </div>
    <div class="stat-card c2">
      <div class="stat-icon"><svg viewBox="0 0 24 24" fill="currentColor"><use href="#icon-evidence"/></svg></div>
      <div class="stat-value">${summaryCounts.totalEvidence}</div>
      <div class="stat-label">Total Evidence</div>
    </div>
    <div class="stat-card c3">
      <div class="stat-icon"><svg viewBox="0 0 24 24" fill="currentColor"><use href="#icon-transfer"/></svg></div>
      <div class="stat-value">${summaryCounts.totalTransfers}</div>
      <div class="stat-label">Transfers</div>
    </div>
    <div class="stat-card c4">
      <div class="stat-icon"><svg viewBox="0 0 24 24" fill="currentColor"><use href="#icon-reports"/></svg></div>
      <div class="stat-value">${summaryCounts.totalReports}</div>
      <div class="stat-label">Reports Filed</div>
    </div>
    <div class="stat-card c1">
      <div class="stat-icon"><svg viewBox="0 0 24 24" fill="currentColor"><use href="#icon-officers"/></svg></div>
      <div class="stat-value">${summaryCounts.totalOfficers}</div>
      <div class="stat-label">Officers</div>
    </div>
  </div>

  <%-- 3.2 Q3: Case status percentage --%>
  <div class="grid-2" style="margin-bottom:24px">
    <div class="card">
      <div class="card-header">
        <span class="card-title">Case Count by Status (3.2 – Aggregate)</span>
      </div>
      <div class="card-body">
        <div class="proc-banner">
          <svg viewBox="0 0 24 24" fill="currentColor"><use href="#icon-info"/></svg>
          <span>Query: <code>COUNT(*), ROUND(COUNT(*)*100.0/(SELECT COUNT(*) FROM CASE),1) ... GROUP BY status</code></span>
        </div>
        <div style="height:200px;margin-bottom:16px">
          <canvas id="analyticsStatusChart"></canvas>
        </div>
        <table>
          <thead><tr><th>Status</th><th>Cases</th><th>Share</th></tr></thead>
          <tbody>
          <c:forEach var="row" items="${statusPercentage}">
            <tr>
              <td>
                <c:choose>
                  <c:when test="${row[0]=='Open'}"><span class="status-badge status-open">${row[0]}</span></c:when>
                  <c:when test="${row[0]=='Under Investigation'}"><span class="status-badge status-investigation">${row[0]}</span></c:when>
                  <c:otherwise><span class="status-badge status-closed">${row[0]}</span></c:otherwise>
                </c:choose>
              </td>
              <td style="font-family:'Rajdhani',sans-serif;font-size:20px;color:var(--accent)">${row[1]}</td>
              <td style="font-family:'Share Tech Mono',monospace;font-size:12px;color:var(--accent2)">${row[2]}%</td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
    </div>

    <%-- 3.4 Q1: Cases above avg evidence --%>
    <div class="card">
      <div class="card-header">
        <span class="card-title">Cases Above Avg Evidence (3.4 – Subquery)</span>
      </div>
      <div class="card-body">
        <div class="proc-banner">
          <svg viewBox="0 0 24 24" fill="currentColor"><use href="#icon-info"/></svg>
          <span>Query: <code>HAVING COUNT(evidence) &gt; (SELECT AVG(ev_count) FROM ...)</code></span>
        </div>
        <c:choose>
          <c:when test="${empty casesAboveAvg}">
            <p style="color:var(--text-muted);font-family:'Share Tech Mono',monospace;font-size:12px">No cases exceed average evidence count.</p>
          </c:when>
          <c:otherwise>
            <table>
              <thead><tr><th>Case ID</th><th>Title</th><th>Status</th><th>Evidence</th></tr></thead>
              <tbody>
              <c:forEach var="row" items="${casesAboveAvg}">
                <tr>
                  <td><span class="evidence-id-badge">${row[0]}</span></td>
                  <td>${row[1]}</td>
                  <td>
                    <c:choose>
                      <c:when test="${row[2]=='Open'}"><span class="status-badge status-open">${row[2]}</span></c:when>
                      <c:when test="${row[2]=='Under Investigation'}"><span class="status-badge status-investigation">${row[2]}</span></c:when>
                      <c:otherwise><span class="status-badge status-closed">${row[2]}</span></c:otherwise>
                    </c:choose>
                  </td>
                  <td style="font-family:'Rajdhani',sans-serif;font-size:20px;color:var(--accent)">${row[3]}</td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </div>

  <%-- 3.2 Q2: Officers with >1 transfer (HAVING) --%>
  <div class="card">
    <div class="card-header">
      <span class="card-title">High-Activity Officers – HAVING transfers &gt; 1 (3.2 – Aggregate)</span>
    </div>
    <div class="card-body">
      <div class="proc-banner">
        <svg viewBox="0 0 24 24" fill="currentColor"><use href="#icon-info"/></svg>
        <span>Query: <code>COUNT(transfer_no) ... GROUP BY officer HAVING COUNT(transfer_no) &gt; 1</code></span>
      </div>
      <c:choose>
        <c:when test="${empty activeOfficers}">
          <p style="color:var(--text-muted);font-family:'Share Tech Mono',monospace;font-size:12px">No officers with more than 1 transfer yet.</p>
        </c:when>
        <c:otherwise>
          <table>
            <thead><tr><th>Officer ID</th><th>Name</th><th>Designation</th><th>Transfers Received</th></tr></thead>
            <tbody>
            <c:forEach var="row" items="${activeOfficers}">
              <tr>
                <td><span class="evidence-id-badge">${row[0]}</span></td>
                <td style="color:var(--text-primary);font-weight:600">${row[1]}</td>
                <td>${row[2]}</td>
                <td>
                  <span style="font-family:'Rajdhani',sans-serif;font-size:24px;color:var(--accent2)">${row[3]}</span>
                </td>
              </tr>
            </c:forEach>
            </tbody>
          </table>
        </c:otherwise>
      </c:choose>
    </div>
  </div>

  <%-- 3.4 Q3: Top officer correlated subquery --%>
  <div class="card">
    <div class="card-header">
      <span class="card-title">Officer Transfer Ranking – Correlated Subquery (3.4)</span>
    </div>
    <div class="card-body">
      <div class="proc-banner">
        <svg viewBox="0 0 24 24" fill="currentColor"><use href="#icon-info"/></svg>
        <span>Query: <code>(SELECT COUNT(*) FROM CUSTODY_TRANSFER WHERE to_officer_id = o.officer_id)</code> per officer</span>
      </div>
      <table>
        <thead><tr><th>Rank</th><th>Officer ID</th><th>Name</th><th>Designation</th><th>Transfers</th></tr></thead>
        <tbody>
        <c:set var="rank" value="0"/>
        <c:forEach var="row" items="${topOfficers}">
          <c:set var="rank" value="${rank+1}"/>
          <tr>
            <td style="font-family:'Rajdhani',sans-serif;font-size:18px;color:${rank==1?'var(--accent2)':rank==2?'var(--accent)':'var(--text-muted)'}">#${rank}</td>
            <td><span class="evidence-id-badge">${row[0]}</span></td>
            <td style="color:var(--text-primary);font-weight:600">${row[1]}</td>
            <td>${row[2]}</td>
            <td>
              <div style="display:flex;align-items:center;gap:8px">
                <span style="font-family:'Rajdhani',sans-serif;font-size:22px;color:var(--accent)">${row[3]}</span>
                <div style="height:6px;width:${row[3]*20}px;max-width:120px;background:var(--accent);opacity:0.5"></div>
              </div>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
  </div>

  <%-- 3.3 Q1: UNION sender/receiver --%>
  <div class="grid-2">
    <div class="card">
      <div class="card-header">
        <span class="card-title">Transfer Participants – UNION (3.3 – Sets)</span>
      </div>
      <div class="card-body">
        <div class="proc-banner">
          <svg viewBox="0 0 24 24" fill="currentColor"><use href="#icon-info"/></svg>
          <span>Query: <code>SELECT from_officer ... UNION SELECT to_officer ... FROM CUSTODY_TRANSFER</code></span>
        </div>
        <table>
          <thead><tr><th>Officer ID</th><th>Role</th></tr></thead>
          <tbody>
          <c:forEach var="row" items="${transferParticipants}">
            <tr>
              <td><span class="evidence-id-badge">${row[0]}</span></td>
              <td>
                <span class="badge ${row[1]=='SENDER'?'badge-lab':'badge-stored'}">${row[1]}</span>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
    </div>

    <%-- 3.3 Q3: INTERSECT --%>
    <div class="card">
      <div class="card-header">
        <span class="card-title">Fully Documented Evidence – INTERSECT (3.3 – Sets)</span>
      </div>
      <div class="card-body">
        <div class="proc-banner">
          <svg viewBox="0 0 24 24" fill="currentColor"><use href="#icon-info"/></svg>
          <span>Query: evidence IN (FORENSIC_REPORT) AND IN (CUSTODY_TRANSFER)</span>
        </div>
        <c:choose>
          <c:when test="${empty evidenceIntersect}">
            <p style="color:var(--text-muted);font-family:'Share Tech Mono',monospace;font-size:12px">No evidence with both report and transfer yet.</p>
          </c:when>
          <c:otherwise>
            <table>
              <thead><tr><th>Evidence ID</th><th>Type</th><th>Status</th><th>Case</th></tr></thead>
              <tbody>
              <c:forEach var="row" items="${evidenceIntersect}">
                <tr>
                  <td><span class="evidence-id-badge">${row[0]}</span></td>
                  <td>${row[1]}</td>
                  <td><span class="status-badge badge-stored">${row[2]}</span></td>
                  <td style="font-size:12px">${row[3]}</td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </div>

</div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
  var rows = [<c:forEach var="r" items="${statusPercentage}">{label:'${r[0]}',count:${r[1]}},</c:forEach>];
  var labels = rows.map(r=>r.label);
  var counts = rows.map(r=>r.count);
  initAnalyticsCharts(labels, counts, []);
});
</script>
</body>
</html>

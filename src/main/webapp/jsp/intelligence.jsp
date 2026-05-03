<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Forensafe – Evidence Intelligence</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
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
      <div class="page-title">EVIDENCE <span>INTELLIGENCE</span></div>
      <div class="page-subtitle">// VIEWS &bull; NOT EXISTS &bull; FUNCTIONS &bull; INTERSECT</div>
    </div>
  </div>

  <%-- Evidence Alert Levels (fn_get_alert_level logic) --%>
  <div class="card">
    <div class="card-header">
      <span class="card-title">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor" style="vertical-align:middle;margin-right:6px"><use href="#icon-alert"/></svg>
        Evidence Age Alerts – fn_get_alert_level() (3.8 – Functions)
      </span>
      <button class="btn btn-ghost btn-sm" onclick="exportTableCSV('alertTable','evidence_alerts.csv')">
        <svg width="13" height="13" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-export"/></svg>
        Export CSV
      </button>
    </div>
    <div class="card-body">
      <div class="proc-banner">
        <svg viewBox="0 0 24 24" fill="currentColor"><use href="#icon-info"/></svg>
        <span>Uses: <code>fn_get_alert_level(DATEDIFF(CURDATE(), seized_date))</code> — CRITICAL &gt;30d, WARNING &gt;14d, NOTICE &gt;7d</span>
      </div>

      <%-- Alert stats --%>
      <div class="stats-grid" style="grid-template-columns:repeat(4,1fr);margin-bottom:20px">
        <c:set var="crit" value="0"/><c:set var="warn" value="0"/><c:set var="notice" value="0"/><c:set var="ok" value="0"/>
        <c:forEach var="row" items="${evidenceAlerts}">
          <c:if test="${row[6]=='CRITICAL'}"><c:set var="crit"   value="${crit+1}"/></c:if>
          <c:if test="${row[6]=='WARNING'}"> <c:set var="warn"   value="${warn+1}"/></c:if>
          <c:if test="${row[6]=='NOTICE'}">  <c:set var="notice" value="${notice+1}"/></c:if>
          <c:if test="${row[6]=='OK'}">      <c:set var="ok"     value="${ok+1}"/></c:if>
        </c:forEach>
        <div class="stat-card c4"><div class="stat-value">${crit}</div><div class="stat-label">Critical</div></div>
        <div class="stat-card c3"><div class="stat-value">${warn}</div><div class="stat-label">Warning</div></div>
        <div class="stat-card c2"><div class="stat-value">${notice}</div><div class="stat-label">Notice</div></div>
        <div class="stat-card c1"><div class="stat-value">${ok}</div><div class="stat-label">OK</div></div>
      </div>

      <div class="table-container">
        <table id="alertTable">
          <thead>
            <tr><th>Evidence ID</th><th>Type</th><th>Status</th><th>Seized Date</th><th>Case</th><th>Days Old</th><th>Alert Level</th></tr>
          </thead>
          <tbody>
          <c:choose>
            <c:when test="${empty evidenceAlerts}">
              <tr><td colspan="7" style="text-align:center;padding:30px;color:var(--text-muted)">No evidence data.</td></tr>
            </c:when>
            <c:otherwise>
            <c:forEach var="row" items="${evidenceAlerts}">
              <tr>
                <td><span class="evidence-id-badge">${row[0]}</span></td>
                <td>${row[1]}</td>
                <td>
                  <c:choose>
                    <c:when test="${row[2]=='In Lab'}"><span class="status-badge status-lab">${row[2]}</span></c:when>
                    <c:when test="${row[2]=='Stored'}"><span class="status-badge status-stored">${row[2]}</span></c:when>
                    <c:when test="${row[2]=='Collected'}"><span class="status-badge status-collected">${row[2]}</span></c:when>
                    <c:otherwise><span class="status-badge status-released">${row[2]}</span></c:otherwise>
                  </c:choose>
                </td>
                <td style="font-family:'Share Tech Mono',monospace;font-size:12px">${row[3]}</td>
                <td style="font-size:12px">${row[4]}</td>
                <td style="font-family:'Rajdhani',sans-serif;font-size:22px;color:var(--warn)">${row[5]}</td>
                <td>
                  <span class="badge badge-${row[6]=='CRITICAL'?'critical':row[6]=='WARNING'?'warning':row[6]=='NOTICE'?'notice':'stored'}">${row[6]}</span>
                </td>
              </tr>
            </c:forEach>
            </c:otherwise>
          </c:choose>
          </tbody>
        </table>
      </div>
    </div>
  </div>

  <div class="grid-2">
    <%-- NOT EXISTS: Untouched evidence --%>
    <div class="card">
      <div class="card-header">
        <span class="card-title">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor" style="vertical-align:middle;margin-right:6px"><use href="#icon-alert"/></svg>
          Untouched Evidence – NOT EXISTS (3.4)
        </span>
      </div>
      <div class="card-body">
        <div class="proc-banner">
          <svg viewBox="0 0 24 24" fill="currentColor"><use href="#icon-info"/></svg>
          <span>Query: <code>WHERE NOT EXISTS (SELECT 1 FROM CUSTODY_TRANSFER WHERE evidence_id = e.evidence_id)</code></span>
        </div>
        <c:choose>
          <c:when test="${empty untouchedEvidence}">
            <p style="color:var(--accent2);font-family:'Share Tech Mono',monospace;font-size:12px">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-check"/></svg>
              All evidence items have been transferred at least once.
            </p>
          </c:when>
          <c:otherwise>
            <table>
              <thead><tr><th>Evidence ID</th><th>Type</th><th>Status</th><th>Case</th></tr></thead>
              <tbody>
              <c:forEach var="row" items="${untouchedEvidence}">
                <tr>
                  <td><span class="evidence-id-badge">${row[0]}</span></td>
                  <td>${row[1]}</td>
                  <td><span class="status-badge badge-collected">${row[3]}</span></td>
                  <td style="font-size:12px">${row[5]}</td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
          </c:otherwise>
        </c:choose>
      </div>
    </div>

    <%-- INTERSECT: Fully documented --%>
    <div class="card">
      <div class="card-header">
        <span class="card-title">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor" style="vertical-align:middle;margin-right:6px"><use href="#icon-check"/></svg>
          Fully Documented – Report + Transfer (3.3)
        </span>
      </div>
      <div class="card-body">
        <div class="proc-banner">
          <svg viewBox="0 0 24 24" fill="currentColor"><use href="#icon-info"/></svg>
          <span>Query: evidence IN FORENSIC_REPORT <strong>AND</strong> IN CUSTODY_TRANSFER (INTERSECT logic)</span>
        </div>
        <c:choose>
          <c:when test="${empty fullyDocumented}">
            <p style="color:var(--text-muted);font-family:'Share Tech Mono',monospace;font-size:12px">No fully documented evidence yet.</p>
          </c:when>
          <c:otherwise>
            <table>
              <thead><tr><th>Evidence ID</th><th>Type</th><th>Status</th><th>Case</th></tr></thead>
              <tbody>
              <c:forEach var="row" items="${fullyDocumented}">
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

  <%-- v_evidence_summary view --%>
  <div class="card">
    <div class="card-header">
      <span class="card-title">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor" style="vertical-align:middle;margin-right:6px"><use href="#icon-evidence"/></svg>
        Evidence Summary View – v_evidence_summary (3.6 – Views)
      </span>
      <button class="btn btn-ghost btn-sm" onclick="exportTableCSV('summaryTable','evidence_summary.csv')">
        <svg width="13" height="13" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-export"/></svg>
        Export
      </button>
    </div>
    <div class="card-body">
      <div class="proc-banner">
        <svg viewBox="0 0 24 24" fill="currentColor"><use href="#icon-info"/></svg>
        <span>Queries: <code>SELECT * FROM v_evidence_summary ORDER BY seized_date DESC</code></span>
      </div>
      <div class="table-container">
        <table id="summaryTable">
          <thead>
            <tr><th>Evidence ID</th><th>Type</th><th>Case Title</th><th>Room</th><th>Security Level</th><th>Status</th><th>Seized Date</th></tr>
          </thead>
          <tbody>
          <c:choose>
            <c:when test="${empty evidenceSummary}">
              <tr><td colspan="7" style="text-align:center;padding:30px;color:var(--text-muted)">No evidence in view.</td></tr>
            </c:when>
            <c:otherwise>
            <c:forEach var="row" items="${evidenceSummary}">
              <tr>
                <td><span class="evidence-id-badge">${row[0]}</span></td>
                <td>${row[1]}</td>
                <td style="font-size:12px">${row[2]}</td>
                <td style="font-family:'Share Tech Mono',monospace;font-size:12px">${row[3]}</td>
                <td>
                  <span class="badge ${row[4]=='Maximum'?'badge-critical':row[4]=='High'?'badge-warning':row[4]=='Medium'?'badge-notice':'badge-stored'}">${row[4]}</span>
                </td>
                <td>
                  <c:choose>
                    <c:when test="${row[5]=='In Lab'}"><span class="status-badge status-lab">${row[5]}</span></c:when>
                    <c:when test="${row[5]=='Stored'}"><span class="status-badge status-stored">${row[5]}</span></c:when>
                    <c:when test="${row[5]=='Collected'}"><span class="status-badge status-collected">${row[5]}</span></c:when>
                    <c:otherwise><span class="status-badge status-released">${row[5]}</span></c:otherwise>
                  </c:choose>
                </td>
                <td style="font-family:'Share Tech Mono',monospace;font-size:12px">${row[6]}</td>
              </tr>
            </c:forEach>
            </c:otherwise>
          </c:choose>
          </tbody>
        </table>
      </div>
    </div>
  </div>

</div>
</div>
</body>
</html>

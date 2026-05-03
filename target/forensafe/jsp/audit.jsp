<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Forensafe – Case Audit</title>
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
      <div class="page-title">CASE <span>AUDIT</span></div>
      <div class="page-subtitle">// CURSORS &bull; VIEWS &bull; PROCEDURES &bull; NOT EXISTS</div>
    </div>
  </div>

  <%-- sp_case_evidence_audit() cursor --%>
  <div class="card">
    <div class="card-header">
      <span class="card-title">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor" style="vertical-align:middle;margin-right:6px"><use href="#icon-audit"/></svg>
        Case Evidence Audit – Cursor Procedure (3.10)
      </span>
      <button class="btn btn-ghost btn-sm" onclick="exportTableCSV('auditTable','case_audit.csv')">
        <svg width="13" height="13" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-export"/></svg>
        Export CSV
      </button>
    </div>
    <div class="card-body">
      <div class="proc-banner">
        <svg viewBox="0 0 24 24" fill="currentColor"><use href="#icon-info"/></svg>
        <span>Calls: <code>CALL sp_case_evidence_audit()</code> — Cursor iterates each case, counts evidence, flags ACTIVE or NO EVIDENCE REGISTERED</span>
      </div>

      <%-- Audit summary stats --%>
      <c:set var="activeCnt" value="0"/><c:set var="noEvCnt" value="0"/>
      <c:forEach var="row" items="${auditResults}">
        <c:if test="${row[4]=='ACTIVE'}">             <c:set var="activeCnt" value="${activeCnt+1}"/></c:if>
        <c:if test="${row[4]=='NO EVIDENCE REGISTERED'}"><c:set var="noEvCnt" value="${noEvCnt+1}"/></c:if>
      </c:forEach>
      <div class="stats-grid" style="grid-template-columns:repeat(3,1fr);margin-bottom:20px">
        <div class="stat-card c1">
          <div class="stat-value">${activeCnt}</div>
          <div class="stat-label">Active Cases</div>
        </div>
        <div class="stat-card c4">
          <div class="stat-value">${noEvCnt}</div>
          <div class="stat-label">No Evidence</div>
        </div>
        <div class="stat-card c2">
          <div class="stat-value">${activeCnt + noEvCnt}</div>
          <div class="stat-label">Total Audited</div>
        </div>
      </div>

      <div class="table-container">
        <table id="auditTable">
          <thead>
            <tr><th>Case ID</th><th>Case Title</th><th>Status</th><th>Evidence Count</th><th>Audit Flag</th></tr>
          </thead>
          <tbody>
          <c:choose>
            <c:when test="${empty auditResults}">
              <tr><td colspan="5" style="text-align:center;padding:30px;color:var(--text-muted)">No audit data available.</td></tr>
            </c:when>
            <c:otherwise>
            <c:forEach var="row" items="${auditResults}">
              <tr>
                <td><span class="evidence-id-badge">${row[0]}</span></td>
                <td style="color:var(--text-primary)">${row[1]}</td>
                <td>
                  <c:choose>
                    <c:when test="${row[2]=='Open'}"><span class="status-badge status-open">${row[2]}</span></c:when>
                    <c:when test="${row[2]=='Under Investigation'}"><span class="status-badge status-investigation">${row[2]}</span></c:when>
                    <c:otherwise><span class="status-badge status-closed">${row[2]}</span></c:otherwise>
                  </c:choose>
                </td>
                <td style="font-family:'Rajdhani',sans-serif;font-size:24px;color:var(--accent)">${row[3]}</td>
                <td>
                  <c:choose>
                    <c:when test="${row[4]=='ACTIVE'}">
                      <span class="badge badge-stored">
                        <svg width="11" height="11" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-check"/></svg>
                        ACTIVE
                      </span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge badge-critical">
                        <svg width="11" height="11" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-alert"/></svg>
                        NO EVIDENCE
                      </span>
                    </c:otherwise>
                  </c:choose>
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
    <%-- v_active_cases view --%>
    <div class="card">
      <div class="card-header">
        <span class="card-title">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor" style="vertical-align:middle;margin-right:6px"><use href="#icon-cases"/></svg>
          Active Cases View – v_active_cases (3.6)
        </span>
      </div>
      <div class="card-body">
        <div class="proc-banner">
          <svg viewBox="0 0 24 24" fill="currentColor"><use href="#icon-info"/></svg>
          <span>Queries: <code>SELECT * FROM v_active_cases ORDER BY date_registered DESC</code></span>
        </div>
        <c:choose>
          <c:when test="${empty activeCases}">
            <p style="color:var(--text-muted);font-family:'Share Tech Mono',monospace;font-size:12px">No active cases found.</p>
          </c:when>
          <c:otherwise>
            <table>
              <thead><tr><th>Case ID</th><th>Title</th><th>Status</th><th>Evidence</th></tr></thead>
              <tbody>
              <c:forEach var="row" items="${activeCases}">
                <tr>
                  <td><a href="<%= request.getContextPath() %>/cases?action=view&id=${row[0]}" style="text-decoration:none"><span class="evidence-id-badge">${row[0]}</span></a></td>
                  <td style="font-size:12px">${row[1]}</td>
                  <td>
                    <c:choose>
                      <c:when test="${row[3]=='Open'}"><span class="status-badge status-open">${row[3]}</span></c:when>
                      <c:otherwise><span class="status-badge status-investigation">${row[3]}</span></c:otherwise>
                    </c:choose>
                  </td>
                  <td style="font-family:'Rajdhani',sans-serif;font-size:20px;color:var(--accent)">${row[6]}</td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
          </c:otherwise>
        </c:choose>
      </div>
    </div>

    <%-- Cases with no evidence (NOT EXISTS) --%>
    <div class="card">
      <div class="card-header">
        <span class="card-title">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor" style="vertical-align:middle;margin-right:6px"><use href="#icon-alert"/></svg>
          Cases Without Evidence – NOT EXISTS (3.4)
        </span>
      </div>
      <div class="card-body">
        <div class="proc-banner">
          <svg viewBox="0 0 24 24" fill="currentColor"><use href="#icon-info"/></svg>
          <span>Query: <code>WHERE NOT EXISTS (SELECT 1 FROM EVIDENCE WHERE case_id = c.case_id)</code></span>
        </div>
        <c:choose>
          <c:when test="${empty noEvidenceCases}">
            <p style="color:var(--accent2);font-family:'Share Tech Mono',monospace;font-size:12px">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-check"/></svg>
              All cases have at least one evidence item registered.
            </p>
          </c:when>
          <c:otherwise>
            <table>
              <thead><tr><th>Case ID</th><th>Title</th><th>Status</th><th>Registered</th></tr></thead>
              <tbody>
              <c:forEach var="row" items="${noEvidenceCases}">
                <tr>
                  <td><span class="evidence-id-badge">${row[0]}</span></td>
                  <td style="font-size:12px">${row[1]}</td>
                  <td>
                    <c:choose>
                      <c:when test="${row[2]=='Open'}"><span class="status-badge status-open">${row[2]}</span></c:when>
                      <c:when test="${row[2]=='Under Investigation'}"><span class="status-badge status-investigation">${row[2]}</span></c:when>
                      <c:otherwise><span class="status-badge status-closed">${row[2]}</span></c:otherwise>
                    </c:choose>
                  </td>
                  <td style="font-family:'Share Tech Mono',monospace;font-size:12px">${row[3]}</td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </div>

  <%-- sp_cases_by_range filter --%>
  <div class="card">
    <div class="card-header">
      <span class="card-title">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor" style="vertical-align:middle;margin-right:6px"><use href="#icon-filter"/></svg>
        Cases by Date Range – sp_cases_by_range() (3.7 – Procedure)
      </span>
    </div>
    <div class="card-body">
      <div class="proc-banner">
        <svg viewBox="0 0 24 24" fill="currentColor"><use href="#icon-info"/></svg>
        <span>Calls: <code>CALL sp_cases_by_range(p_start, p_end)</code></span>
      </div>
      <form method="get" action="<%= request.getContextPath() %>/audit" style="display:flex;gap:12px;align-items:flex-end;flex-wrap:wrap;margin-bottom:20px">
        <div class="form-group">
          <label>Date From</label>
          <input type="date" name="from" value="${filterFrom}" style="width:180px">
        </div>
        <div class="form-group">
          <label>Date To</label>
          <input type="date" name="to" value="${filterTo}" style="width:180px">
        </div>
        <button type="submit" class="btn btn-primary">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-filter"/></svg>
          Run Procedure
        </button>
        <a href="<%= request.getContextPath() %>/audit" class="btn btn-ghost">Clear</a>
      </form>

      <c:if test="${not empty rangeResults}">
        <table>
          <thead><tr><th>Case ID</th><th>Title</th><th>Crime Type</th><th>Status</th><th>Date Registered</th><th>Evidence</th></tr></thead>
          <tbody>
          <c:forEach var="row" items="${rangeResults}">
            <tr>
              <td><span class="evidence-id-badge">${row[0]}</span></td>
              <td style="color:var(--text-primary)">${row[1]}</td>
              <td>${row[2]}</td>
              <td>
                <c:choose>
                  <c:when test="${row[3]=='Open'}"><span class="status-badge status-open">${row[3]}</span></c:when>
                  <c:when test="${row[3]=='Under Investigation'}"><span class="status-badge status-investigation">${row[3]}</span></c:when>
                  <c:otherwise><span class="status-badge status-closed">${row[3]}</span></c:otherwise>
                </c:choose>
              </td>
              <td style="font-family:'Share Tech Mono',monospace;font-size:12px">${row[4]}</td>
              <td style="font-family:'Rajdhani',sans-serif;font-size:20px;color:var(--accent)">${row[6]}</td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </c:if>
      <c:if test="${empty rangeResults && not empty filterFrom}">
        <p style="color:var(--text-muted);font-family:'Share Tech Mono',monospace;font-size:12px">No cases found in selected date range.</p>
      </c:if>
      <c:if test="${empty filterFrom}">
        <p style="color:var(--text-muted);font-family:'Share Tech Mono',monospace;font-size:12px">Select a date range above and click Run Procedure to call sp_cases_by_range().</p>
      </c:if>
    </div>
  </div>

</div>
</div>
</body>
</html>

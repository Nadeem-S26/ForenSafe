<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Forensafe – Officer Workload</title>
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
      <div class="page-title">OFFICER <span>WORKLOAD</span></div>
      <div class="page-subtitle">// STORED PROCEDURES &bull; CURSORS &bull; FUNCTIONS</div>
    </div>
  </div>

  <%-- sp_officer_workload() --%>
  <div class="card">
    <div class="card-header">
      <span class="card-title">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor" style="vertical-align:middle;margin-right:6px"><use href="#icon-workload"/></svg>
        Officer Workload Report (3.7 – Stored Procedure)
      </span>
      <button class="btn btn-ghost btn-sm" onclick="exportTableCSV('workloadTable','officer_workload.csv')">
        <svg width="13" height="13" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-export"/></svg>
        Export CSV
      </button>
    </div>
    <div class="card-body">
      <div class="proc-banner">
        <svg viewBox="0 0 24 24" fill="currentColor"><use href="#icon-info"/></svg>
        <span>Calls: <code>CALL sp_officer_workload()</code> — Stored procedure joining CUSTODY_TRANSFER and FORENSIC_REPORT per officer</span>
      </div>
      <div class="table-container">
        <table id="workloadTable">
          <thead>
            <tr>
              <th>Officer ID</th>
              <th>Officer Name</th>
              <th>Designation</th>
              <th>Evidence Handled</th>
              <th>Reports Filed</th>
              <th>Workload Score</th>
            </tr>
          </thead>
          <tbody>
          <c:choose>
            <c:when test="${empty officerWorkload}">
              <tr><td colspan="6" style="text-align:center;padding:30px;color:var(--text-muted)">No workload data available.</td></tr>
            </c:when>
            <c:otherwise>
            <c:forEach var="row" items="${officerWorkload}">
              <c:set var="score" value="${row[3] + row[4]}"/>
              <tr>
                <td><span class="evidence-id-badge">${row[0]}</span></td>
                <td style="color:var(--text-primary);font-weight:600">${row[1]}</td>
                <td>${row[2]}</td>
                <td>
                  <span style="font-family:'Rajdhani',sans-serif;font-size:22px;color:var(--accent)">${row[3]}</span>
                </td>
                <td>
                  <span style="font-family:'Rajdhani',sans-serif;font-size:22px;color:var(--accent2)">${row[4]}</span>
                </td>
                <td>
                  <div style="display:flex;align-items:center;gap:8px">
                    <div style="height:8px;width:${score*16}px;max-width:100px;background:linear-gradient(90deg,var(--accent),var(--accent2));min-width:4px"></div>
                    <span style="font-family:'Share Tech Mono',monospace;font-size:11px;color:var(--text-muted)">${score}</span>
                  </div>
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

  <%-- sp_officer_transfer_summary() cursor --%>
  <div class="card">
    <div class="card-header">
      <span class="card-title">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor" style="vertical-align:middle;margin-right:6px"><use href="#icon-transfer"/></svg>
        Transfer Summary – Cursor Procedure (3.10)
      </span>
    </div>
    <div class="card-body">
      <div class="proc-banner">
        <svg viewBox="0 0 24 24" fill="currentColor"><use href="#icon-info"/></svg>
        <span>Calls: <code>CALL sp_officer_transfer_summary()</code> — Cursor iterates each officer, counts transfers row-by-row</span>
      </div>
      <div class="table-container">
        <table>
          <thead>
            <tr><th>Officer ID</th><th>Officer Name</th><th>Total Transfers Received</th><th>Distribution</th></tr>
          </thead>
          <tbody>
          <c:choose>
            <c:when test="${empty transferSummary}">
              <tr><td colspan="4" style="text-align:center;padding:30px;color:var(--text-muted)">No transfer data available.</td></tr>
            </c:when>
            <c:otherwise>
            <c:forEach var="row" items="${transferSummary}">
              <tr>
                <td><span class="evidence-id-badge">${row[0]}</span></td>
                <td style="color:var(--text-primary);font-weight:600">${row[1]}</td>
                <td>
                  <span style="font-family:'Rajdhani',sans-serif;font-size:28px;color:var(--accent)">${row[2]}</span>
                </td>
                <td>
                  <div style="height:10px;background:var(--bg-hover);width:160px;position:relative">
                    <div style="height:100%;width:${row[2]*25}%;max-width:100%;background:var(--accent);opacity:0.7"></div>
                  </div>
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

</div>
</div>
</body>
</html>

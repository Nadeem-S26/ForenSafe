<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Forensafe – Chain of Custody</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<%@ include file="shared/sidebar.jsp" %>

<div class="main-content">
  <div class="page-body">
    <c:if test="${param.msg == 'transferred'}"><div class="alert alert-success auto-hide">✅ Custody transfer recorded successfully.</div></c:if>

    <div class="page-header">
      <div>
        <div class="page-title">CHAIN OF <span>CUSTODY</span></div>
        <div class="page-subtitle">// ${evidence.evidenceId} &mdash; ${evidence.caseTitle}</div>
      </div>
      <div style="display:flex;gap:8px">
        <a href="<%= request.getContextPath() %>/evidence" class="btn btn-ghost">← Evidence</a>
        <button class="btn btn-ghost" onclick="window.print()">🖨 Print Chain</button>
      </div>
    </div>

    <!-- Evidence Details Card -->
    <div class="grid-2" style="margin-bottom:20px">
      <div class="card">
        <div class="card-header"><span class="card-title">Evidence Details</span></div>
        <div class="card-body">
          <table style="width:100%">
            <tr><td style="color:var(--text-muted);font-size:11px;padding:6px 0;width:120px">EVIDENCE ID</td><td><span class="evidence-id-badge">${evidence.evidenceId}</span></td></tr>
            <tr><td style="color:var(--text-muted);font-size:11px;padding:6px 0">CASE ID</td><td>${evidence.caseId}</td></tr>
            <tr><td style="color:var(--text-muted);font-size:11px;padding:6px 0">TYPE</td><td>${evidence.evidenceType}</td></tr>
            <tr><td style="color:var(--text-muted);font-size:11px;padding:6px 0">SEIZED DATE</td><td>${evidence.seizedDate}</td></tr>
            <tr><td style="color:var(--text-muted);font-size:11px;padding:6px 0">LOCATION</td><td>${evidence.seizedArea} ${evidence.seizedPincode}</td></tr>
            <tr><td style="color:var(--text-muted);font-size:11px;padding:6px 0">STORAGE</td><td>${evidence.storageLocation}</td></tr>
            <tr><td style="color:var(--text-muted);font-size:11px;padding:6px 0">STATUS</td>
              <td>
                <c:choose>
                  <c:when test="${evidence.currentStatus == 'In Lab'}"><span class="status-badge status-lab">${evidence.currentStatus}</span></c:when>
                  <c:when test="${evidence.currentStatus == 'Stored'}"><span class="status-badge status-stored">${evidence.currentStatus}</span></c:when>
                  <c:when test="${evidence.currentStatus == 'Collected'}"><span class="status-badge status-collected">${evidence.currentStatus}</span></c:when>
                  <c:otherwise><span class="status-badge status-released">${evidence.currentStatus}</span></c:otherwise>
                </c:choose>
              </td>
            </tr>
            <tr><td colspan="2" style="padding-top:10px">
              <div style="color:var(--text-muted);font-size:11px;margin-bottom:4px">SHA-256 HASH</div>
              <div class="hash-display">${evidence.hashValue}</div>
            </td></tr>
          </table>
        </div>
      </div>

      <!-- New Transfer Form -->
      <div class="card">
        <div class="card-header"><span class="card-title">🔄 Record Custody Transfer</span></div>
        <div class="card-body">
          <form method="post" action="<%= request.getContextPath() %>/evidence">
            <input type="hidden" name="action" value="transfer">
            <input type="hidden" name="evidenceId" value="${evidence.evidenceId}">
            <div class="form-grid" style="grid-template-columns:1fr">
              <div class="form-group">
                <label>From Officer *</label>
                <select name="fromOfficerId" required>
                  <option value="">-- Select Officer --</option>
                  <c:forEach var="o" items="${officers}">
                    <option value="${o.officerId}">${o.officerId} – ${o.firstName} ${o.lastName}</option>
                  </c:forEach>
                </select>
              </div>
              <div class="form-group">
                <label>To Officer *</label>
                <select name="toOfficerId" required>
                  <option value="">-- Select Officer --</option>
                  <c:forEach var="o" items="${officers}">
                    <option value="${o.officerId}">${o.officerId} – ${o.firstName} ${o.lastName}</option>
                  </c:forEach>
                </select>
              </div>
              <div class="form-group">
                <label>Purpose *</label>
                <input type="text" name="purpose" placeholder="Reason for transfer" required>
              </div>
              <div class="form-group">
                <label>Remarks</label>
                <textarea name="remarks" rows="2" placeholder="Additional notes..."></textarea>
              </div>
            </div>
            <button type="submit" class="btn btn-primary" style="width:100%;margin-top:12px">🔄 Record Transfer</button>
          </form>
        </div>
      </div>
    </div>

    <!-- Chain of Custody Timeline -->
    <div class="card">
      <div class="card-header">
        <span class="card-title">Chain of Custody Timeline</span>
        <span style="color:var(--text-muted);font-size:12px">${fn:length(chain)} transfer(s) recorded</span>
      </div>
      <div class="card-body">
        <c:choose>
          <c:when test="${empty chain}">
            <div style="text-align:center;padding:40px;color:var(--text-muted)">
              No custody transfers recorded yet. This evidence has not been transferred.
            </div>
          </c:when>
          <c:otherwise>
            <div class="custody-timeline">
              <c:forEach var="ct" items="${chain}">
                <div class="custody-event">
                  <div class="custody-transfer-no">TRANSFER #${ct.transferNo}</div>
                  <div class="custody-officers">
                    <span>${ct.fromOfficerName}</span>
                    <span class="custody-arrow">→</span>
                    <span style="color:var(--accent-blue)">${ct.toOfficerName}</span>
                  </div>
                  <div class="custody-time">🕐 ${ct.transferDatetime}</div>
                  <div class="custody-purpose">📋 ${ct.purpose}</div>
                  <c:if test="${not empty ct.remarks}">
                    <div class="custody-purpose" style="margin-top:4px">💬 ${ct.remarks}</div>
                  </c:if>
                </div>
              </c:forEach>
            </div>
          </c:otherwise>
        </c:choose>
      </div>
    </div>

  </div>
</div>

<script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>

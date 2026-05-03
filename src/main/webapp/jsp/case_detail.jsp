<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.forensafe.model.Case" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Forensafe – Case Details</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<%@ include file="shared/sidebar.jsp" %>

<div class="main-content">
  <div class="page-body">

    <c:if test="${empty caseObj}">
      <div class="alert alert-danger">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-alert"/></svg>
        Case not found or access denied.
      </div>
      <a href="<%= request.getContextPath() %>/cases" class="btn btn-ghost">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-chevron-left"/></svg>
        Back to Cases
      </a>
    </c:if>

    <c:if test="${not empty caseObj}">
      <div class="page-header">
        <div>
          <div class="page-title">CASE <span>${caseObj.caseId}</span></div>
          <div class="page-subtitle">// ${caseObj.caseTitle}</div>
        </div>
        <div style="display:flex;gap:8px;flex-wrap:wrap">
          <a href="<%= request.getContextPath() %>/cases" class="btn btn-ghost">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-chevron-left"/></svg>
            All Cases
          </a>
          <a href="<%= request.getContextPath() %>/cases?action=edit&id=${caseObj.caseId}" class="btn btn-primary">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-edit"/></svg>
            Edit Case
          </a>
          <a href="<%= request.getContextPath() %>/evidence?action=byCase&caseId=${caseObj.caseId}" class="btn btn-success">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-evidence"/></svg>
            View Evidence
          </a>
        </div>
      </div>

      <div class="grid-2" style="gap:20px;margin-bottom:20px">
        <!-- Case Info -->
        <div class="card">
          <div class="card-header">
            <span class="card-title">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor" style="vertical-align:middle;margin-right:6px"><use href="#icon-cases"/></svg>
              Case Information
            </span>
            <c:choose>
              <c:when test="${caseObj.status == 'Open'}"><span class="status-badge status-open">${caseObj.status}</span></c:when>
              <c:when test="${caseObj.status == 'Under Investigation'}"><span class="status-badge status-investigation">${caseObj.status}</span></c:when>
              <c:otherwise><span class="status-badge status-closed">${caseObj.status}</span></c:otherwise>
            </c:choose>
          </div>
          <div class="card-body">
            <table style="width:100%;border-collapse:collapse">
              <tr>
                <td style="padding:9px 0;color:var(--text-muted);font-family:'Share Tech Mono',monospace;font-size:10px;letter-spacing:1px;width:38%;border-bottom:1px solid var(--border)">CASE ID</td>
                <td style="padding:9px 0;border-bottom:1px solid var(--border)"><span class="evidence-id-badge">${caseObj.caseId}</span></td>
              </tr>
              <tr>
                <td style="padding:9px 0;color:var(--text-muted);font-family:'Share Tech Mono',monospace;font-size:10px;letter-spacing:1px;border-bottom:1px solid var(--border)">CRIME TYPE</td>
                <td style="padding:9px 0;color:var(--text-primary);border-bottom:1px solid var(--border)">${caseObj.crimeType}</td>
              </tr>
              <tr>
                <td style="padding:9px 0;color:var(--text-muted);font-family:'Share Tech Mono',monospace;font-size:10px;letter-spacing:1px;border-bottom:1px solid var(--border)">DATE REGISTERED</td>
                <td style="padding:9px 0;color:var(--text-primary);font-family:'Share Tech Mono',monospace;font-size:12px;border-bottom:1px solid var(--border)">${caseObj.dateRegistered}</td>
              </tr>
              <tr>
                <td style="padding:9px 0;color:var(--text-muted);font-family:'Share Tech Mono',monospace;font-size:10px;letter-spacing:1px;border-bottom:1px solid var(--border)">EVIDENCE COUNT</td>
                <td style="padding:9px 0;color:var(--accent);font-family:'Rajdhani',sans-serif;font-size:20px;font-weight:700;border-bottom:1px solid var(--border)">${caseObj.evidenceCount}</td>
              </tr>
              <tr>
                <td style="padding:9px 0;color:var(--text-muted);font-family:'Share Tech Mono',monospace;font-size:10px;letter-spacing:1px">STATUS</td>
                <td style="padding:9px 0">
                  <c:choose>
                    <c:when test="${caseObj.status == 'Open'}"><span class="status-badge status-open">${caseObj.status}</span></c:when>
                    <c:when test="${caseObj.status == 'Under Investigation'}"><span class="status-badge status-investigation">${caseObj.status}</span></c:when>
                    <c:otherwise><span class="status-badge status-closed">${caseObj.status}</span></c:otherwise>
                  </c:choose>
                </td>
              </tr>
            </table>
          </div>
        </div>

        <!-- Location -->
        <div class="card">
          <div class="card-header">
            <span class="card-title">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor" style="vertical-align:middle;margin-right:6px"><use href="#icon-info"/></svg>
              Location &amp; Description
            </span>
          </div>
          <div class="card-body">
            <div style="margin-bottom:14px">
              <div style="font-family:'Share Tech Mono',monospace;font-size:9px;letter-spacing:2px;color:var(--text-muted);margin-bottom:5px">LOCATION</div>
              <div style="color:var(--text-primary)">
                <c:if test="${not empty caseObj.street}">${caseObj.street}, </c:if>
                <c:if test="${not empty caseObj.area}">${caseObj.area}</c:if>
                <c:if test="${not empty caseObj.pincode}"> – ${caseObj.pincode}</c:if>
                <c:if test="${empty caseObj.area && empty caseObj.street}"><span style="color:var(--text-muted)">Not specified</span></c:if>
              </div>
            </div>
            <div>
              <div style="font-family:'Share Tech Mono',monospace;font-size:9px;letter-spacing:2px;color:var(--text-muted);margin-bottom:5px">DESCRIPTION</div>
              <div style="color:var(--text-secondary);font-size:13px;line-height:1.7">${caseObj.description}</div>
            </div>
          </div>
        </div>
      </div>

      <!-- Quick Actions -->
      <div class="card">
        <div class="card-header">
          <span class="card-title">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor" style="vertical-align:middle;margin-right:6px"><use href="#icon-status"/></svg>
            Quick Actions
          </span>
        </div>
        <div class="card-body" style="display:flex;gap:12px;flex-wrap:wrap">
          <a href="<%= request.getContextPath() %>/evidence?action=add&caseId=${caseObj.caseId}" class="btn btn-primary">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-add"/></svg>
            Add Evidence
          </a>
          <a href="<%= request.getContextPath() %>/evidence?action=byCase&caseId=${caseObj.caseId}" class="btn btn-success">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-evidence"/></svg>
            View All Evidence
          </a>
          <a href="<%= request.getContextPath() %>/cases?action=edit&id=${caseObj.caseId}" class="btn btn-ghost">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-edit"/></svg>
            Edit Case Details
          </a>
          <a href="<%= request.getContextPath() %>/reports?caseId=${caseObj.caseId}" class="btn btn-ghost">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-reports"/></svg>
            View Reports
          </a>
          <button onclick="window.print()" class="btn btn-ghost">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-print"/></svg>
            Print
          </button>
        </div>
      </div>
    </c:if>

  </div>
</div>
</body>
</html>

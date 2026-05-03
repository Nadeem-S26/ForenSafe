<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Forensafe – Officers</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<%@ include file="shared/sidebar.jsp" %>

<div class="main-content">
  <div class="page-body">
    <c:if test="${param.msg == 'added'}"><div class="alert alert-success auto-hide">✅ Officer added successfully.</div></c:if>
    <c:if test="${param.msg == 'updated'}"><div class="alert alert-success auto-hide">✅ Officer updated.</div></c:if>
    <c:if test="${param.msg == 'deleted'}"><div class="alert alert-danger auto-hide">🗑 Officer deleted.</div></c:if>
    <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>

    <div class="page-header">
      <div>
        <div class="page-title">OFFICER <span>REGISTRY</span></div>
        <div class="page-subtitle">// MANAGE SYSTEM USERS &amp; FORENSIC OFFICERS</div>
      </div>
      <% if ("admin".equals(_role)) { %>
        <a href="<%= request.getContextPath() %>/officers?action=add" class="btn btn-primary">➕ Add Officer</a>
      <% } %>
    </div>

    <div class="filter-bar">
      <div class="filter-group" style="flex:1;max-width:400px">
        <label>Search Officers</label>
        <input type="text" id="offSearch" placeholder="Search by name, ID, department..." oninput="filterTable('offSearch','offTable')">
      </div>
    </div>

    <div class="card">
      <div class="card-header"><span class="card-title">All Officers</span></div>
      <div class="table-container">
        <table id="offTable">
          <thead>
            <tr>
              <th>Officer ID</th>
              <th>Name</th>
              <th>Designation</th>
              <th>Department</th>
              <th>Phone</th>
              <th>Email</th>
              <th>Role</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
          <c:forEach var="o" items="${officers}">
            <tr>
              <td><span class="evidence-id-badge">${o.officerId}</span></td>
              <td>
                <div style="display:flex;align-items:center;gap:8px">
                  <div style="width:30px;height:30px;border-radius:50%;background:linear-gradient(135deg,var(--accent-blue),var(--accent-purple));display:flex;align-items:center;justify-content:center;font-size:11px;font-weight:700;color:#000">
                    ${fn:toUpperCase(fn:substring(o.firstName,0,1))}${fn:toUpperCase(fn:substring(o.lastName,0,1))}
                  </div>
                  <span><strong>${o.firstName} ${o.lastName}</strong></span>
                </div>
              </td>
              <td>${o.designation}</td>
              <td>${o.department}</td>
              <td>${o.phone}</td>
              <td>${o.email}</td>
              <td>
                <c:choose>
                  <c:when test="${o.role == 'admin'}"><span class="status-badge" style="background:rgba(255,56,96,0.1);color:var(--accent-red)">ADMIN</span></c:when>
                  <c:when test="${o.role == 'analyst'}"><span class="status-badge status-stored">ANALYST</span></c:when>
                  <c:otherwise><span class="status-badge status-collected">OFFICER</span></c:otherwise>
                </c:choose>
              </td>
              <td>
                <% if ("admin".equals(_role)) { %>
                  <a href="<%= request.getContextPath() %>/officers?action=edit&id=${o.officerId}" class="btn btn-ghost btn-sm">✏ Edit</a>
                  <button class="btn btn-danger btn-sm"
                    onclick="confirmDelete('<%= request.getContextPath() %>/officers?action=delete&id=${o.officerId}','${o.firstName} ${o.lastName}')">🗑</button>
                <% } %>
              </td>
            </tr>
          </c:forEach>
          <c:if test="${empty officers}">
            <tr><td colspan="8" style="text-align:center;padding:30px;color:var(--text-muted)">No officers found.</td></tr>
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

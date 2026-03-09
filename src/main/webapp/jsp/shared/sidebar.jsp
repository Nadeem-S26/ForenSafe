<%@ page import="com.forensafe.model.Officer" %>
<%
  Officer _officer = (Officer) session.getAttribute("officer");
  String _role = (_officer != null) ? _officer.getRole() : "officer";
  String _initials = (_officer != null) ?
    (_officer.getFirstName().charAt(0) + "" + _officer.getLastName().charAt(0)).toUpperCase() : "??";
  String ctx = request.getContextPath();
%>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<nav class="sidebar" id="sidebar">
  <div class="sidebar-brand">
    <div class="logo-icon" style="font-size:26px;color:var(--accent-blue)">
      <i class="bi bi-shield-lock-fill"></i>
    </div>
    <h1>FORENSAFE</h1>
    <small>Evidence Management System</small>
  </div>

  <div class="nav-section-label">Main</div>
  <a class="nav-link" href="<%= ctx %>/dashboard">
    <span class="nav-icon"><i class="bi bi-speedometer2"></i></span> Dashboard
  </a>

  <div class="nav-section-label">Cases</div>
  <a class="nav-link" href="<%= ctx %>/cases">
    <span class="nav-icon"><i class="bi bi-folder2-open"></i></span> All Cases
  </a>
  <a class="nav-link" href="<%= ctx %>/cases?action=add">
    <span class="nav-icon"><i class="bi bi-folder-plus"></i></span> Add New Case
  </a>

  <div class="nav-section-label">Evidence</div>
  <a class="nav-link" href="<%= ctx %>/evidence">
    <span class="nav-icon"><i class="bi bi-search"></i></span> Evidence Registry
  </a>
  <a class="nav-link" href="<%= ctx %>/evidence?action=add">
    <span class="nav-icon"><i class="bi bi-plus-circle"></i></span> Add Evidence
  </a>

  <div class="nav-section-label">Officers</div>
  <a class="nav-link" href="<%= ctx %>/officers">
    <span class="nav-icon"><i class="bi bi-person-badge"></i></span> Officer List
  </a>
  <% if ("admin".equals(_role)) { %>
  <a class="nav-link" href="<%= ctx %>/create-account">
    <span class="nav-icon"><i class="bi bi-person-plus-fill"></i></span> Create Account
  </a>
  <% } %>

  <div class="nav-section-label">Reports</div>
  <a class="nav-link" href="<%= ctx %>/reports?type=active">
    <span class="nav-icon"><i class="bi bi-file-earmark-text"></i></span> Active Cases
  </a>
  <a class="nav-link" href="<%= ctx %>/reports?type=closed">
    <span class="nav-icon"><i class="bi bi-check2-circle"></i></span> Closed Cases
  </a>
  <a class="nav-link" href="<%= ctx %>/reports">
    <span class="nav-icon"><i class="bi bi-clipboard-data"></i></span> All Reports
  </a>

  <% if ("admin".equals(_role)) { %>
  <div class="nav-section-label">Admin</div>
  <a class="nav-link" href="<%= ctx %>/dbtest" target="_blank">
    <span class="nav-icon"><i class="bi bi-database-check"></i></span> DB Verify
  </a>
  <% } %>

  <div class="sidebar-footer">
    <div class="officer-card">
      <div class="officer-avatar"><%= _initials %></div>
      <div class="officer-info">
        <small>Logged in as</small>
        <span><%= _officer != null ? _officer.getFullName() : "Unknown" %></span>
        <small style="color:var(--accent-blue)"><%= _role.toUpperCase() %></small>
      </div>
    </div>
    <a href="<%= ctx %>/logout" class="btn btn-ghost btn-sm"
       style="margin-top:12px;width:100%;justify-content:center">
      <i class="bi bi-box-arrow-left"></i>&nbsp; Logout
    </a>
  </div>
</nav>

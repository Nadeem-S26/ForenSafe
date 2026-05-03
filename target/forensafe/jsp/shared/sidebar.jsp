<%@ page import="com.forensafe.model.Officer" %>
<%
  Officer _officer = (Officer) session.getAttribute("officer");
  String  _role     = (_officer != null) ? _officer.getRole() : "officer";
  String  _initials = (_officer != null)
    ? (String.valueOf(_officer.getFirstName().charAt(0)) + String.valueOf(_officer.getLastName().charAt(0))).toUpperCase()
    : "??";
  String ctx = request.getContextPath();
%>

<%-- ── Topbar ─────────────────────────────────────────────── --%>
<div class="topbar">
  <div class="topbar-left">
    <button class="topbar-toggle" id="sidebarToggle" title="Toggle sidebar" aria-label="Toggle sidebar">
      <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
        <use href="#icon-menu"/>
      </svg>
    </button>
    <a href="<%= ctx %>/dashboard" class="topbar-logo">
      <svg width="24" height="24" viewBox="0 0 48 48" fill="none">
        <path d="M24 4L6 12V24C6 34 14 42 24 46C34 42 42 34 42 24V12L24 4Z"
              stroke="currentColor" stroke-width="2" fill="rgba(0,212,255,0.1)" style="color:var(--accent)"/>
        <path d="M16 24L21 29L32 18" stroke="var(--accent2)" stroke-width="2.5"
              stroke-linecap="round" stroke-linejoin="round"/>
      </svg>
      <span class="logo-name">FORENSAFE</span>
    </a>
  </div>

  <div class="topbar-center">
    <span class="topbar-page-title" id="topbarPageTitle"></span>
  </div>

  <div class="topbar-right">
    <button class="theme-toggle" id="themeToggle" title="Toggle theme" aria-label="Toggle theme">
      <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-sun"/></svg>
      <span>LIGHT</span>
    </button>
    <span class="topbar-badge badge-<%= _role %>"><%= _role.toUpperCase() %></span>
  </div>
</div>

<%-- ── Sidebar ────────────────────────────────────────────── --%>
<nav class="sidebar" id="sidebar" aria-label="Main navigation">

  <%-- MAIN --%>
  <div class="nav-section-label">Main</div>
  <a class="nav-link" href="<%= ctx %>/dashboard" data-tooltip="Dashboard">
    <span class="nav-icon">
      <svg viewBox="0 0 24 24" fill="currentColor"><use href="#icon-dashboard"/></svg>
    </span>
    <span class="nav-label">Dashboard</span>
  </a>

  <%-- CASES --%>
  <div class="nav-section-label">Cases</div>
  <a class="nav-link" href="<%= ctx %>/cases" data-tooltip="All Cases">
    <span class="nav-icon">
      <svg viewBox="0 0 24 24" fill="currentColor"><use href="#icon-cases"/></svg>
    </span>
    <span class="nav-label">All Cases</span>
  </a>
  <a class="nav-link" href="<%= ctx %>/cases?action=add" data-tooltip="Add Case">
    <span class="nav-icon">
      <svg viewBox="0 0 24 24" fill="currentColor"><use href="#icon-add"/></svg>
    </span>
    <span class="nav-label">Add New Case</span>
  </a>

  <%-- EVIDENCE --%>
  <div class="nav-section-label">Evidence</div>
  <a class="nav-link" href="<%= ctx %>/evidence" data-tooltip="Evidence Registry">
    <span class="nav-icon">
      <svg viewBox="0 0 24 24" fill="currentColor"><use href="#icon-evidence"/></svg>
    </span>
    <span class="nav-label">Evidence Registry</span>
  </a>
  <a class="nav-link" href="<%= ctx %>/evidence?action=add" data-tooltip="Add Evidence">
    <span class="nav-icon">
      <svg viewBox="0 0 24 24" fill="currentColor"><use href="#icon-add"/></svg>
    </span>
    <span class="nav-label">Add Evidence</span>
  </a>

  <%-- OFFICERS --%>
  <div class="nav-section-label">Officers</div>
  <a class="nav-link" href="<%= ctx %>/officers" data-tooltip="Officers">
    <span class="nav-icon">
      <svg viewBox="0 0 24 24" fill="currentColor"><use href="#icon-officers"/></svg>
    </span>
    <span class="nav-label">Officer List</span>
  </a>
  <% if ("admin".equals(_role)) { %>
  <a class="nav-link" href="<%= ctx %>/create-account" data-tooltip="Create Account">
    <span class="nav-icon">
      <svg viewBox="0 0 24 24" fill="currentColor"><use href="#icon-admin"/></svg>
    </span>
    <span class="nav-label">Create Account</span>
  </a>
  <% } %>

  <%-- REPORTS --%>
  <div class="nav-section-label">Reports</div>
  <a class="nav-link" href="<%= ctx %>/reports?type=active" data-tooltip="Active Cases">
    <span class="nav-icon">
      <svg viewBox="0 0 24 24" fill="currentColor"><use href="#icon-reports"/></svg>
    </span>
    <span class="nav-label">Active Cases</span>
  </a>
  <a class="nav-link" href="<%= ctx %>/reports?type=closed" data-tooltip="Closed Cases">
    <span class="nav-icon">
      <svg viewBox="0 0 24 24" fill="currentColor"><use href="#icon-check"/></svg>
    </span>
    <span class="nav-label">Closed Cases</span>
  </a>
  <a class="nav-link" href="<%= ctx %>/reports" data-tooltip="All Reports">
    <span class="nav-icon">
      <svg viewBox="0 0 24 24" fill="currentColor"><use href="#icon-analytics"/></svg>
    </span>
    <span class="nav-label">All Reports</span>
  </a>

  <%-- ANALYTICS (NEW) --%>
  <div class="nav-section-label">Analytics</div>
  <a class="nav-link" href="<%= ctx %>/analytics" data-tooltip="Case Analytics">
    <span class="nav-icon">
      <svg viewBox="0 0 24 24" fill="currentColor"><use href="#icon-analytics"/></svg>
    </span>
    <span class="nav-label">Case Analytics</span>
  </a>
  <a class="nav-link" href="<%= ctx %>/workload" data-tooltip="Officer Workload">
    <span class="nav-icon">
      <svg viewBox="0 0 24 24" fill="currentColor"><use href="#icon-workload"/></svg>
    </span>
    <span class="nav-label">Officer Workload</span>
  </a>
  <a class="nav-link" href="<%= ctx %>/intelligence" data-tooltip="Evidence Intelligence">
    <span class="nav-icon">
      <svg viewBox="0 0 24 24" fill="currentColor"><use href="#icon-intelligence"/></svg>
    </span>
    <span class="nav-label">Evidence Intelligence</span>
  </a>
  <a class="nav-link" href="<%= ctx %>/audit" data-tooltip="Case Audit">
    <span class="nav-icon">
      <svg viewBox="0 0 24 24" fill="currentColor"><use href="#icon-audit"/></svg>
    </span>
    <span class="nav-label">Case Audit</span>
  </a>

  <%-- ALERTS --%>
  <div class="nav-section-label">Alerts</div>
  <a class="nav-link" href="<%= ctx %>/overdue" data-tooltip="Overdue Alerts">
    <span class="nav-icon">
      <svg viewBox="0 0 24 24" fill="currentColor"><use href="#icon-alert"/></svg>
    </span>
    <span class="nav-label">Overdue Alerts</span>
    <%-- badge populated by JS if overdueCount is set --%>
  </a>

  <% if ("admin".equals(_role)) { %>
  <div class="nav-section-label">System</div>
  <a class="nav-link" href="<%= ctx %>/dbtest" target="_blank" data-tooltip="DB Verify">
    <span class="nav-icon">
      <svg viewBox="0 0 24 24" fill="currentColor"><use href="#icon-db"/></svg>
    </span>
    <span class="nav-label">DB Verify</span>
  </a>
  <% } %>

  <%-- Footer --%>
  <div class="sidebar-footer">
    <div class="officer-card">
      <div class="officer-avatar"><%= _initials %></div>
      <div class="officer-info">
        <small>Logged in as</small>
        <span><%= _officer != null ? _officer.getFullName() : "Unknown" %></span>
        <small style="color:var(--accent)"><%= _role.toUpperCase() %></small>
      </div>
    </div>
    <a href="<%= ctx %>/logout" class="btn-logout" aria-label="Logout">
      <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-logout"/></svg>
      <span class="logout-label">Logout</span>
    </a>
    <div class="status-indicator">
      <div class="status-dot"></div>
      <span>SYSTEM ONLINE</span>
    </div>
  </div>
</nav>

<script src="<%= ctx %>/js/main.js"></script>
<script>
// Highlight active nav link
(function() {
  var path = window.location.pathname + window.location.search;
  document.querySelectorAll('.nav-link').forEach(function(link) {
    var href = (link.getAttribute('href') || '').split('?')[0];
    if (href.length > 1 && path.indexOf(href) !== -1) {
      link.classList.add('active');
    }
  });
})();
</script>

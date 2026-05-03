<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.forensafe.model.Officer" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Forensafe – Officer Form</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<%@ include file="shared/sidebar.jsp" %>

<%
  Officer officerObj = (Officer) request.getAttribute("officerObj");
  boolean isNewOfficer = (officerObj == null);
%>

<div class="main-content">
  <div class="page-body">
    <div class="page-header">
      <div class="page-title"><%= isNewOfficer ? "Register New Officer" : "Edit Officer: " + officerObj.getOfficerId() %></div>
      <a href="<%= request.getContextPath() %>/officers" class="btn btn-ghost">← Back</a>
    </div>

    <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>

    <div class="card">
      <div class="card-header"><span class="card-title">Officer Information</span></div>
      <div class="card-body">
        <form method="post" action="<%= request.getContextPath() %>/officers">
          <input type="hidden" name="isNew" value="<%= isNewOfficer ? "1" : "" %>">
          <div class="form-grid">
            <div class="form-group">
              <label>Officer ID *</label>
              <input type="text" name="officerId"
                value="<%= isNewOfficer ? "" : officerObj.getOfficerId() %>"
                placeholder="e.g. OFC004"
                <%= isNewOfficer ? "required" : "readonly style='opacity:0.6'" %>>
            </div>
            <div class="form-group">
              <label>Role *</label>
              <select name="role" required>
                <% String[] roles = {"officer","analyst","admin"}; %>
                <% for (String r : roles) { boolean sel = !isNewOfficer && r.equals(officerObj.getRole()); %>
                  <option value="<%= r %>" <%= sel ? "selected" : "" %>><%= r.toUpperCase() %></option>
                <% } %>
              </select>
            </div>
            <div class="form-group">
              <label>First Name *</label>
              <input type="text" name="firstName" value="<%= isNewOfficer ? "" : officerObj.getFirstName() %>" required placeholder="First name">
            </div>
            <div class="form-group">
              <label>Last Name *</label>
              <input type="text" name="lastName" value="<%= isNewOfficer ? "" : officerObj.getLastName() %>" required placeholder="Last name">
            </div>
            <div class="form-group">
              <label>Designation</label>
              <input type="text" name="designation" value="<%= isNewOfficer ? "" : officerObj.getDesignation() %>" placeholder="e.g. Senior Detective">
            </div>
            <div class="form-group">
              <label>Department</label>
              <input type="text" name="department" value="<%= isNewOfficer ? "" : officerObj.getDepartment() %>" placeholder="e.g. Cybercrime">
            </div>
            <div class="form-group">
              <label>Phone</label>
              <input type="tel" name="phone" value="<%= isNewOfficer ? "" : officerObj.getPhone() %>" placeholder="Contact number">
            </div>
            <div class="form-group">
              <label>Email</label>
              <input type="email" name="email" value="<%= isNewOfficer ? "" : officerObj.getEmail() %>" placeholder="Official email">
            </div>
            <% if (isNewOfficer) { %>
            <div class="form-group">
              <label>Username *</label>
              <input type="text" name="username" required placeholder="Login username">
            </div>
            <div class="form-group">
              <label>Password *</label>
              <input type="password" name="password" required placeholder="Min 8 characters">
            </div>
            <% } %>
          </div>
          <div style="margin-top:24px;display:flex;gap:12px">
            <button type="submit" class="btn btn-primary">
              <%= isNewOfficer ? "➕ Register Officer" : "💾 Save Changes" %>
            </button>
            <a href="<%= request.getContextPath() %>/officers" class="btn btn-ghost">Cancel</a>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>

<script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.forensafe.model.Officer" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
  /* Admin-only guard */
  Officer _sessionOfficer = (Officer) session.getAttribute("officer");
  if (_sessionOfficer == null || !"admin".equalsIgnoreCase(_sessionOfficer.getRole())) {
      response.sendRedirect(request.getContextPath() + "/dashboard");
      return;
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Forensafe – Create Officer Account</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
<style>
.pwd-strength-bar { height: 4px; border-radius: 2px; background: var(--border); margin-top: 6px; overflow: hidden; }
.pwd-strength-fill { height: 100%; width: 0%; border-radius: 2px; transition: width 0.3s, background 0.3s; }
.pwd-hint { font-size: 11px; margin-top: 4px; }
.info-box {
  background: rgba(0,212,255,0.06);
  border: 1px solid var(--border);
  border-left: 3px solid var(--accent-blue);
  border-radius: 6px;
  padding: 14px 16px;
  margin-bottom: 20px;
  font-size: 13px;
  color: var(--text-muted);
}
.info-box strong { color: var(--accent-blue); }
.toggle-pwd { cursor: pointer; color: var(--text-muted); font-size: 16px; padding: 10px; }
.pwd-wrap { position: relative; display: flex; align-items: center; }
.pwd-wrap input { flex: 1; }
.hash-preview {
  font-family: 'Share Tech Mono', monospace;
  font-size: 10px;
  color: var(--accent-green);
  background: rgba(0,255,157,0.05);
  border: 1px solid rgba(0,255,157,0.15);
  border-radius: 4px;
  padding: 8px 10px;
  word-break: break-all;
  margin-top: 6px;
  display: none;
}
</style>
</head>
<body>
<%@ include file="../shared/sidebar.jsp" %>

<div class="main-content">
  <div class="page-body">

    <!-- Success message -->
    <c:if test="${not empty successMsg}">
      <div class="alert alert-success" style="font-size:14px">
        ${successMsg}
        <div style="margin-top:8px;font-size:12px;color:var(--text-muted)">
          The officer can now log in with their credentials. Password is BCrypt-encrypted in the database.
        </div>
      </div>
    </c:if>

    <!-- Error message -->
    <c:if test="${not empty error}">
      <div class="alert alert-danger">${error}</div>
    </c:if>

    <div class="page-header">
      <div>
        <div class="page-title">Register New Officer Account</div>
        <div class="page-subtitle">Admin panel · Password is automatically encrypted before storage</div>
      </div>
      <a href="<%= request.getContextPath() %>/officers" class="btn btn-ghost">← View All Officers</a>
    </div>

    <!-- Info box -->
    <div class="info-box">
      🔐 <strong>Security Note:</strong> The password you set will be automatically
      <strong>BCrypt-hashed</strong> (salted, one-way encryption) before being stored in the database.
      The plain-text password is <strong>never saved anywhere</strong> — share it with the officer verbally or via secure message.
    </div>

    <div class="grid-2">

      <!-- ── CREATE ACCOUNT FORM ─────────────────────────────── -->
      <div class="card">
        <div class="card-header">
          <span class="card-title">Account Details</span>
        </div>
        <div class="card-body">
          <form method="post" action="<%= request.getContextPath() %>/create-account"
                onsubmit="return validateForm()">

            <div class="form-grid" style="grid-template-columns:1fr 1fr">

              <!-- Officer ID -->
              <div class="form-group">
                <label for="officerId">Officer ID *</label>
                <input type="text" id="officerId" name="officerId"
                  value="${formData.officerId}" placeholder="e.g. OFC007" required
                  oninput="this.value=this.value.toUpperCase()">
              </div>

              <!-- Role -->
              <div class="form-group">
                <label for="role">Role *</label>
                <select id="role" name="role" required>
                  <option value="officer" ${formData.role == 'officer' ? 'selected' : ''}>OFFICER</option>
                  <option value="analyst" ${formData.role == 'analyst' ? 'selected' : ''}>ANALYST</option>
                  <option value="admin"   ${formData.role == 'admin'   ? 'selected' : ''}>ADMIN</option>
                </select>
              </div>

              <!-- First Name -->
              <div class="form-group">
                <label for="firstName">First Name *</label>
                <input type="text" id="firstName" name="firstName"
                  value="${formData.firstName}" placeholder="First name" required>
              </div>

              <!-- Last Name -->
              <div class="form-group">
                <label for="lastName">Last Name *</label>
                <input type="text" id="lastName" name="lastName"
                  value="${formData.lastName}" placeholder="Last name" required>
              </div>

              <!-- Designation -->
              <div class="form-group">
                <label for="designation">Designation</label>
                <input type="text" id="designation" name="designation"
                  value="${formData.designation}" placeholder="e.g. Detective">
              </div>

              <!-- Department -->
              <div class="form-group">
                <label for="department">Department</label>
                <input type="text" id="department" name="department"
                  value="${formData.department}" placeholder="e.g. Cybercrime">
              </div>

              <!-- Phone -->
              <div class="form-group">
                <label for="phone">Phone</label>
                <input type="tel" id="phone" name="phone"
                  value="${formData.phone}" placeholder="Contact number">
              </div>

              <!-- Email -->
              <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email"
                  value="${formData.email}" placeholder="Official email">
              </div>

            </div>

            <!-- Divider -->
            <div style="border-top:1px solid var(--border);margin:20px 0"></div>
            <div style="font-family:'Rajdhani',sans-serif;font-size:14px;font-weight:600;letter-spacing:1px;color:var(--accent-blue);margin-bottom:16px">🔑 LOGIN CREDENTIALS</div>

            <!-- Username -->
            <div class="form-group" style="margin-bottom:16px">
              <label for="username">Username *</label>
              <input type="text" id="username" name="username"
                value="${formData.username}" placeholder="Login username (no spaces)" required
                oninput="this.value=this.value.replace(/\s/g,'').toLowerCase()">
            </div>

            <!-- Password -->
            <div class="form-group" style="margin-bottom:8px">
              <label for="password">Password *</label>
              <div class="pwd-wrap">
                <input type="password" id="password" name="password"
                  placeholder="Min 6 characters" required
                  oninput="checkStrength(this.value)">
                <span class="toggle-pwd" onclick="togglePwd('password')" title="Show/hide">👁</span>
              </div>
              <div class="pwd-strength-bar"><div class="pwd-strength-fill" id="strengthFill"></div></div>
              <div class="pwd-hint" id="strengthHint" style="color:var(--text-muted)">Enter a password</div>
            </div>

            <!-- Confirm Password -->
            <div class="form-group" style="margin-bottom:24px">
              <label for="confirmPassword">Confirm Password *</label>
              <div class="pwd-wrap">
                <input type="password" id="confirmPassword" name="confirmPassword"
                  placeholder="Re-enter password" required
                  oninput="checkMatch()">
                <span class="toggle-pwd" onclick="togglePwd('confirmPassword')" title="Show/hide">👁</span>
              </div>
              <div class="pwd-hint" id="matchHint" style="color:var(--text-muted)"></div>
            </div>

            <button type="submit" class="btn btn-primary" style="width:100%;justify-content:center;padding:13px">
              ➕ Create Account & Encrypt Password
            </button>
          </form>
        </div>
      </div>

      <!-- ── INFO PANEL ──────────────────────────────────────── -->
      <div style="display:flex;flex-direction:column;gap:16px">

        <!-- What happens -->
        <div class="card">
          <div class="card-header"><span class="card-title">🔒 What Happens to the Password?</span></div>
          <div class="card-body" style="font-size:13px;line-height:1.8;color:var(--text-muted)">
            <div style="margin-bottom:10px">When you submit this form:</div>
            <div style="display:flex;flex-direction:column;gap:8px">
              <div>1️⃣  Plain password travels via HTTPS POST</div>
              <div>2️⃣  <code style="color:var(--accent-blue)">PasswordUtil.hash()</code> applies BCrypt with cost factor 10</div>
              <div>3️⃣  A unique random <strong style="color:var(--accent-green)">salt</strong> is generated per password</div>
              <div>4️⃣  The resulting 60-char hash is stored in the DB</div>
              <div>5️⃣  Plain text is <strong style="color:var(--accent-red)">never stored anywhere</strong></div>
            </div>
            <div style="margin-top:14px;padding:10px;background:rgba(0,255,157,0.05);border:1px solid rgba(0,255,157,0.15);border-radius:6px;font-family:'Share Tech Mono',monospace;font-size:11px;color:var(--accent-green)">
              DB stores: $2a$10$xyz...60chars...
            </div>
          </div>
        </div>

        <!-- Recently created (flash) -->
        <c:if test="${not empty successMsg}">
          <div class="card">
            <div class="card-header"><span class="card-title">✅ Account Created</span></div>
            <div class="card-body" style="font-size:13px">
              <div style="color:var(--text-muted);margin-bottom:10px">Share these credentials with the officer:</div>
              <table style="width:100%">
                <tr><td style="color:var(--text-muted);font-size:11px;padding:5px 0;width:90px">USERNAME</td>
                    <td style="font-family:'Share Tech Mono',monospace;color:var(--accent-blue)">${param.username}</td></tr>
                <tr><td style="color:var(--text-muted);font-size:11px;padding:5px 0">PASSWORD</td>
                    <td style="color:var(--accent-amber)">As set by you (shown once, not stored)</td></tr>
                <tr><td style="color:var(--text-muted);font-size:11px;padding:5px 0">ROLE</td>
                    <td>${param.role}</td></tr>
              </table>
              <div style="margin-top:14px">
                <a href="<%= request.getContextPath() %>/officers" class="btn btn-ghost btn-sm">View Officers List</a>
              </div>
            </div>
          </div>
        </c:if>

        <!-- Quick link -->
        <div class="card">
          <div class="card-header"><span class="card-title">📋 Quick Actions</span></div>
          <div class="card-body" style="display:flex;flex-direction:column;gap:8px">
            <a href="<%= request.getContextPath() %>/officers" class="btn btn-ghost">👮 View All Officers</a>
            <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-ghost">📊 Dashboard</a>
            <a href="<%= request.getContextPath() %>/dbtest" class="btn btn-ghost" target="_blank">🔌 DB Verification</a>
          </div>
        </div>

      </div>
    </div><!-- end grid -->
  </div>
</div>

<script src="<%= request.getContextPath() %>/js/main.js"></script>
<script>
function togglePwd(id) {
  const f = document.getElementById(id);
  f.type = f.type === 'password' ? 'text' : 'password';
}

function checkStrength(pwd) {
  const fill = document.getElementById('strengthFill');
  const hint = document.getElementById('strengthHint');
  let score = 0;
  if (pwd.length >= 6)  score++;
  if (pwd.length >= 10) score++;
  if (/[A-Z]/.test(pwd)) score++;
  if (/[0-9]/.test(pwd)) score++;
  if (/[^A-Za-z0-9]/.test(pwd)) score++;

  const levels = [
    { w:'20%', c:'#ff3860', t:'Very Weak' },
    { w:'40%', c:'#ff6b35', t:'Weak' },
    { w:'60%', c:'#ffb347', t:'Fair' },
    { w:'80%', c:'#7ed321', t:'Strong' },
    { w:'100%',c:'#00ff9d', t:'Very Strong' },
  ];
  const lvl = levels[Math.min(score, 4)];
  fill.style.width      = pwd.length === 0 ? '0%' : lvl.w;
  fill.style.background = lvl.c;
  hint.textContent      = pwd.length === 0 ? 'Enter a password' : 'Strength: ' + lvl.t;
  hint.style.color      = lvl.c;
}

function checkMatch() {
  const p1   = document.getElementById('password').value;
  const p2   = document.getElementById('confirmPassword').value;
  const hint = document.getElementById('matchHint');
  if (!p2) { hint.textContent = ''; return; }
  if (p1 === p2) {
    hint.textContent = '✅ Passwords match';
    hint.style.color = 'var(--accent-green)';
  } else {
    hint.textContent = '❌ Passwords do not match';
    hint.style.color = 'var(--accent-red)';
  }
}

function validateForm() {
  const p1 = document.getElementById('password').value;
  const p2 = document.getElementById('confirmPassword').value;
  if (p1 !== p2) {
    alert('❌ Passwords do not match!');
    return false;
  }
  if (p1.length < 6) {
    alert('❌ Password must be at least 6 characters.');
    return false;
  }
  const uid = document.getElementById('username').value.trim();
  if (!/^[a-z0-9_]+$/.test(uid)) {
    alert('❌ Username can only contain lowercase letters, numbers, underscores.');
    return false;
  }
  return true;
}
</script>
</body>
</html>

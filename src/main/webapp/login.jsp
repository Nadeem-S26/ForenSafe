<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Forensafe – Login</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Rajdhani:wght@400;600;700&family=Exo+2:wght@300;400;500&family=Share+Tech+Mono&display=swap" rel="stylesheet">
<style>
:root {
  --bg: #0a0d14; --card: #0f1520; --border: rgba(0,212,255,0.15);
  --blue: #00d4ff; --green: #00ff9d; --red: #ff3860;
  --text: #e8edf5; --muted: #6b7a99;
}
* { box-sizing: border-box; margin: 0; padding: 0; }
body {
  background: var(--bg);
  color: var(--text);
  font-family: 'Exo 2', sans-serif;
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  overflow: hidden;
}
/* Grid background */
body::before {
  content: '';
  position: fixed; inset: 0;
  background-image:
    linear-gradient(rgba(0,212,255,0.04) 1px, transparent 1px),
    linear-gradient(90deg, rgba(0,212,255,0.04) 1px, transparent 1px);
  background-size: 40px 40px;
  pointer-events: none;
}
.login-wrap {
  position: relative;
  width: 100%;
  max-width: 420px;
  padding: 20px;
}
.brand {
  text-align: center;
  margin-bottom: 36px;
}
.brand-icon {
  font-size: 48px;
  margin-bottom: 12px;
  filter: drop-shadow(0 0 20px var(--blue));
}
.brand h1 {
  font-family: 'Rajdhani', sans-serif;
  font-size: 32px;
  font-weight: 700;
  letter-spacing: 6px;
  color: var(--blue);
  text-shadow: 0 0 30px rgba(0,212,255,0.5);
}
.brand p {
  font-size: 11px;
  letter-spacing: 3px;
  color: var(--muted);
  text-transform: uppercase;
  margin-top: 4px;
}
.login-card {
  background: var(--card);
  border: 1px solid var(--border);
  border-radius: 14px;
  padding: 36px;
  box-shadow: 0 20px 60px rgba(0,0,0,0.5), 0 0 40px rgba(0,212,255,0.08);
}
.login-card h2 {
  font-family: 'Rajdhani', sans-serif;
  font-size: 18px;
  font-weight: 600;
  letter-spacing: 2px;
  margin-bottom: 6px;
}
.login-card .subtitle {
  font-size: 12px;
  color: var(--muted);
  margin-bottom: 28px;
  padding-bottom: 20px;
  border-bottom: 1px solid var(--border);
}
.form-group { margin-bottom: 18px; }
label {
  display: block;
  font-size: 10px;
  font-weight: 600;
  letter-spacing: 2px;
  text-transform: uppercase;
  color: var(--muted);
  margin-bottom: 8px;
}
input {
  width: 100%;
  background: rgba(255,255,255,0.04);
  border: 1px solid var(--border);
  border-radius: 8px;
  padding: 12px 16px;
  color: var(--text);
  font-family: 'Exo 2', sans-serif;
  font-size: 14px;
  transition: all 0.2s;
}
input:focus {
  outline: none;
  border-color: var(--blue);
  box-shadow: 0 0 0 3px rgba(0,212,255,0.12);
  background: rgba(0,212,255,0.04);
}
.btn-login {
  width: 100%;
  padding: 13px;
  background: var(--blue);
  color: #000;
  border: none;
  border-radius: 8px;
  font-family: 'Rajdhani', sans-serif;
  font-size: 16px;
  font-weight: 700;
  letter-spacing: 3px;
  text-transform: uppercase;
  cursor: pointer;
  margin-top: 8px;
  transition: all 0.2s;
}
.btn-login:hover {
  background: #00b8d9;
  box-shadow: 0 0 25px rgba(0,212,255,0.4);
  transform: translateY(-1px);
}
.alert-error {
  background: rgba(255,56,96,0.1);
  border: 1px solid rgba(255,56,96,0.3);
  color: var(--red);
  border-radius: 6px;
  padding: 10px 14px;
  font-size: 13px;
  margin-bottom: 18px;
}
.demo-creds {
  margin-top: 24px;
  padding: 14px;
  background: rgba(0,212,255,0.05);
  border: 1px solid var(--border);
  border-radius: 8px;
  font-family: 'Share Tech Mono', monospace;
  font-size: 11px;
  color: var(--muted);
}
.demo-creds strong { color: var(--blue); display: block; margin-bottom: 6px; font-size: 10px; letter-spacing: 1px; }
.footer {
  text-align: center;
  margin-top: 24px;
  font-size: 11px;
  color: var(--muted);
  letter-spacing: 1px;
}
</style>
</head>
<body>
<div class="login-wrap">
  <div class="brand">
    <div class="brand-icon">🔐</div>
    <h1>FORENSAFE</h1>
    <p>Digital Evidence Chain-of-Custody Management</p>
  </div>

  <div class="login-card">
    <h2>SECURE LOGIN</h2>
    <p class="subtitle">Authorized Personnel Only — All Access Logged</p>

    <% String error = (String) request.getAttribute("error"); %>
    <% if (error != null) { %>
      <div class="alert-error">⚠ <%= error %></div>
    <% } %>

    <form action="<%= request.getContextPath() %>/LoginServlet" method="post">
      <div class="form-group">
        <label for="username">Officer ID / Username</label>
        <input type="text" id="username" name="username" placeholder="Enter username" required autocomplete="username">
      </div>
      <div class="form-group">
        <label for="password">Password</label>
        <input type="password" id="password" name="password" placeholder="Enter password" required autocomplete="current-password">
      </div>
      <button type="submit" class="btn-login">🔓 Authenticate</button>
    </form>

    <div class="demo-creds">
      <strong>🧪 TEST CREDENTIALS (DEMO)</strong>
      admin / admin123 &nbsp;|&nbsp; ravi / officer123 &nbsp;|&nbsp; priya / analyst123
    </div>
  </div>

  <p class="footer">FORENSAFE v1.0 · Secured System · Unauthorized Access Prohibited</p>
</div>
</body>
</html>

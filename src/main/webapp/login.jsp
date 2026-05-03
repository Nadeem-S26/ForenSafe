<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
  // Redirect to dashboard if already logged in
  if (session.getAttribute("officer") != null) {
    response.sendRedirect(request.getContextPath() + "/dashboard");
    return;
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Forensafe – Login</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
<style>
  body { display: flex; align-items: center; justify-content: center; min-height: 100vh; }

  .login-wrap { width: 420px; position: relative; z-index: 1; }

  .login-glow {
    position: absolute; inset: -60px;
    background: radial-gradient(ellipse at center, rgba(0,212,255,0.08) 0%, transparent 70%);
    pointer-events: none;
    animation: pulse 3s ease-in-out infinite;
  }
  @keyframes pulse { 0%,100%{opacity:0.5} 50%{opacity:1} }

  .login-box {
    background: var(--bg-panel);
    border: 1px solid var(--border);
    border-top: 2px solid var(--accent);
    padding: 48px 44px;
    position: relative;
    clip-path: polygon(0 0, calc(100% - 20px) 0, 100% 20px, 100% 100%, 0 100%);
  }

  .login-logo { text-align: center; margin-bottom: 32px; }

  .logo-name {
    font-family: 'Rajdhani', sans-serif;
    font-size: 30px; font-weight: 700;
    letter-spacing: 6px; color: var(--accent);
    text-shadow: 0 0 20px rgba(0,212,255,0.5);
    display: block;
  }

  .logo-sub {
    font-family: 'Share Tech Mono', monospace;
    font-size: 10px; color: var(--text-muted);
    letter-spacing: 3px; margin-top: 4px;
  }

  .login-title {
    font-family: 'Share Tech Mono', monospace;
    font-size: 11px; color: var(--text-secondary);
    letter-spacing: 2px; margin-bottom: 24px;
    padding-bottom: 14px;
    border-bottom: 1px solid var(--border);
    text-align: center;
  }

  .field-group { margin-bottom: 18px; }

  .field-group label {
    display: block;
    font-family: 'Share Tech Mono', monospace;
    font-size: 10px; color: var(--accent);
    letter-spacing: 2px; margin-bottom: 7px;
    text-transform: uppercase;
  }

  .field-group input {
    width: 100%;
    background: rgba(0,212,255,0.04);
    border: 1px solid var(--border);
    border-left: 2px solid var(--accent);
    padding: 11px 14px;
    color: var(--text-primary);
    font-family: 'Share Tech Mono', monospace;
    font-size: 13px;
    outline: none;
    transition: all 0.2s;
  }

  .field-group input:focus {
    border-color: var(--accent);
    background: rgba(0,212,255,0.08);
    box-shadow: 0 0 15px rgba(0,212,255,0.1);
  }

  .btn-login {
    width: 100%;
    background: transparent;
    border: 1px solid var(--accent);
    color: var(--accent);
    padding: 13px;
    font-family: 'Rajdhani', sans-serif;
    font-size: 15px; font-weight: 600;
    letter-spacing: 4px; text-transform: uppercase;
    cursor: pointer;
    transition: all 0.3s;
    position: relative; overflow: hidden;
    margin-top: 8px;
  }

  .btn-login::before {
    content: '';
    position: absolute; inset: 0;
    background: var(--accent);
    transform: translateX(-100%);
    transition: transform 0.3s;
    z-index: -1;
  }

  .btn-login:hover { color: var(--bg-deep); box-shadow: 0 0 25px rgba(0,212,255,0.4); }
  .btn-login:hover::before { transform: translateX(0); }

  .login-error {
    font-family: 'Share Tech Mono', monospace;
    font-size: 11px; color: var(--danger);
    margin-top: 12px; text-align: center;
    padding: 8px; border: 1px solid rgba(255,59,92,0.3);
    background: rgba(255,59,92,0.05);
  }

  .demo-creds {
    margin-top: 22px; padding: 14px;
    background: rgba(0,212,255,0.03);
    border: 1px solid var(--border);
  }

  .demo-creds p {
    font-family: 'Share Tech Mono', monospace;
    font-size: 10px; color: var(--text-muted);
    letter-spacing: 1px; margin-bottom: 5px;
  }

  .demo-creds p:first-child { color: var(--text-secondary); margin-bottom: 8px; }
  .demo-creds span { color: var(--accent2); }
</style>
</head>
<body>
<div class="login-wrap">
  <div class="login-glow"></div>
  <div class="login-box">

    <div class="login-logo">
      <svg width="44" height="44" viewBox="0 0 48 48" fill="none" style="display:block;margin:0 auto 10px">
        <path d="M24 4L6 12V24C6 34 14 42 24 46C34 42 42 34 42 24V12L24 4Z"
              stroke="#00d4ff" stroke-width="2" fill="rgba(0,212,255,0.1)"/>
        <path d="M16 24L21 29L32 18" stroke="#00ff9d" stroke-width="2.5"
              stroke-linecap="round" stroke-linejoin="round"/>
      </svg>
      <span class="logo-name">FORENSAFE</span>
      <div class="logo-sub">Digital Evidence Chain-of-Custody System</div>
    </div>

    <div class="login-title">// SECURE ACCESS TERMINAL //</div>

    <c:if test="${not empty error}">
      <div class="login-error">&#9888; ${error}</div>
      <br>
    </c:if>

    <form method="post" action="<%= request.getContextPath() %>/LoginServlet">
      <div class="field-group">
        <label>USERNAME</label>
        <input type="text" name="username" placeholder="Enter username"
               autocomplete="off" required autofocus>
      </div>
      <div class="field-group">
        <label>PASSWORD</label>
        <input type="password" name="password" placeholder="Enter password" required>
      </div>
      <button type="submit" class="btn-login">&#9654; AUTHENTICATE</button>
    </form>

    <div class="demo-creds">
      <p>DEMO CREDENTIALS</p>
      <p>admin / <span>admin123</span> &mdash; Full Access (Admin)</p>
      <p>ravi / <span>officer123</span> &mdash; Officer</p>
      <p>priya / <span>analyst123</span> &mdash; Analyst</p>
    </div>

  </div>
</div>
</body>
</html>

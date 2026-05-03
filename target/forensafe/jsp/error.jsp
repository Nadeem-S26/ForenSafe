<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Forensafe – Error</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body style="display:flex;align-items:center;justify-content:center;min-height:100vh">
  <div style="text-align:center;max-width:500px;padding:40px">
    <div style="font-size:64px;margin-bottom:16px">⚠️</div>
    <h1 style="font-family:'Rajdhani',sans-serif;font-size:28px;color:var(--accent-red);letter-spacing:2px">
      ACCESS ERROR
    </h1>
    <p style="color:var(--text-muted);margin:16px 0">
      The requested resource could not be accessed. You may not have permission, or the page does not exist.
    </p>
    <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-primary">← Return to Dashboard</a>
  </div>
</body>
</html>

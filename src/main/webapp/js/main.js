/* ================================================================
   FORENSAFE – Shared SVG Icons
   Usage: <svg class="icon"><use href="#icon-dashboard"/></svg>
================================================================ */
(function() {
  const svgNS = 'http://www.w3.org/2000/svg';
  const defs = {
    'icon-dashboard':    'M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z',
    'icon-cases':        'M20 6h-2.18c.07-.44.18-.88.18-1a3 3 0 00-6 0c0 .12.11.56.18 1H10c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2zm-7-1a1 1 0 112 0c0 .12-.11.56-.18 1h-1.64C13.11 5.56 13 5.12 13 5zM9 20V8h2v2h6V8h2l.01 12H9z',
    'icon-add':          'M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z',
    'icon-evidence':     'M9.5 3A6.5 6.5 0 0116 9.5c0 1.61-.59 3.09-1.56 4.23l.27.27h.79l5 5-1.5 1.5-5-5v-.79l-.27-.27A6.516 6.516 0 019.5 16 6.5 6.5 0 013 9.5 6.5 6.5 0 019.5 3m0 2C7 5 5 7 5 9.5S7 14 9.5 14 14 12 14 9.5 12 5 9.5 5z',
    'icon-officers':     'M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z',
    'icon-reports':      'M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-5 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z',
    'icon-alert':        'M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z',
    'icon-admin':        'M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm-6 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zm3.1-9H8.9V6c0-1.71 1.39-3.1 3.1-3.1 1.71 0 3.1 1.39 3.1 3.1v2z',
    'icon-logout':       'M17 7l-1.41 1.41L18.17 11H8v2h10.17l-2.58 2.58L17 17l5-5zM4 5h8V3H4c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h8v-2H4V5z',
    'icon-db':           'M12 2C6.48 2 2 4.24 2 7v10c0 2.76 4.48 5 10 5s10-2.24 10-5V7c0-2.76-4.48-5-10-5zm0 2c4.42 0 8 1.57 8 3.5S16.42 11 12 11s-8-1.57-8-3.5S7.58 4 12 4zm0 14c-4.42 0-8-1.57-8-3.5v-2.09A12.98 12.98 0 0012 14c2.7 0 5.19-.83 7.21-2.24.49.45.79.95.79 1.74C20 15.43 16.42 17 12 17z',
    'icon-view':         'M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z',
    'icon-edit':         'M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z',
    'icon-delete':       'M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z',
    'icon-chain':        'M3.9 12c0-1.71 1.39-3.1 3.1-3.1h4V7H7c-2.76 0-5 2.24-5 5s2.24 5 5 5h4v-1.9H7c-1.71 0-3.1-1.39-3.1-3.1zM8 13h8v-2H8v2zm9-6h-4v1.9h4c1.71 0 3.1 1.39 3.1 3.1s-1.39 3.1-3.1 3.1h-4V17h4c2.76 0 5-2.24 5-5s-2.24-5-5-5z',
    'icon-export':       'M19 9h-4V3H9v6H5l7 7 7-7zM5 18v2h14v-2H5z',
    'icon-filter':       'M10 18h4v-2h-4v2zM3 6v2h18V6H3zm3 7h12v-2H6v2z',
    'icon-refresh':      'M17.65 6.35C16.2 4.9 14.21 4 12 4c-4.42 0-7.99 3.58-7.99 8s3.57 8 7.99 8c3.73 0 6.84-2.55 7.73-6h-2.08c-.82 2.33-3.04 4-5.65 4-3.31 0-6-2.69-6-6s2.69-6 6-6c1.66 0 3.14.69 4.22 1.78L13 11h7V4l-2.35 2.35z',
    'icon-transfer':     'M7.5 21H2V9h5.5v12zm7.25-18h-5.5v18h5.5V3zM22 11h-5.5v10H22V11z',
    'icon-print':        'M19 8H5c-1.66 0-3 1.34-3 3v6h4v4h12v-4h4v-6c0-1.66-1.34-3-3-3zm-3 11H8v-5h8v5zm3-7c-.55 0-1-.45-1-1s.45-1 1-1 1 .45 1 1-.45 1-1 1zm-1-9H6v4h12V3z',
    'icon-sun':          'M12 7c-2.76 0-5 2.24-5 5s2.24 5 5 5 5-2.24 5-5-2.24-5-5-5zM2 13h2c.55 0 1-.45 1-1s-.45-1-1-1H2c-.55 0-1 .45-1 1s.45 1 1 1zm18 0h2c.55 0 1-.45 1-1s-.45-1-1-1h-2c-.55 0-1 .45-1 1s.45 1 1 1zM11 2v2c0 .55.45 1 1 1s1-.45 1-1V2c0-.55-.45-1-1-1s-1 .45-1 1zm0 18v2c0 .55.45 1 1 1s1-.45 1-1v-2c0-.55-.45-1-1-1s-1 .45-1 1zM5.99 4.58c-.39-.39-1.03-.39-1.41 0-.39.39-.39 1.03 0 1.41l1.06 1.06c.39.39 1.03.39 1.41 0s.39-1.03 0-1.41L5.99 4.58zm12.37 12.37c-.39-.39-1.03-.39-1.41 0-.39.39-.39 1.03 0 1.41l1.06 1.06c.39.39 1.03.39 1.41 0 .39-.39.39-1.03 0-1.41l-1.06-1.06zm1.06-12.37l-1.06 1.06c-.39.39-.39 1.03 0 1.41s1.03.39 1.41 0l1.06-1.06c.39-.39.39-1.03 0-1.41s-1.03-.39-1.41 0zM7.05 18.36l-1.06 1.06c-.39.39-.39 1.03 0 1.41s1.03.39 1.41 0l1.06-1.06c.39-.39.39-1.03 0-1.41s-1.03-.39-1.41 0z',
    'icon-moon':         'M12 3c-4.97 0-9 4.03-9 9s4.03 9 9 9 9-4.03 9-9c0-.46-.04-.92-.1-1.36-.98 1.37-2.58 2.26-4.4 2.26-2.98 0-5.4-2.42-5.4-5.4 0-1.81.89-3.42 2.26-4.4-.44-.06-.9-.1-1.36-.1z',
    'icon-menu':         'M3 18h18v-2H3v2zm0-5h18v-2H3v2zm0-7v2h18V6H3z',
    'icon-chevron-left': 'M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z',
    'icon-analytics':    'M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z',
    'icon-workload':     'M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z',
    'icon-intelligence': 'M9.4 16.6L4.8 12l4.6-4.6L8 6l-6 6 6 6 1.4-1.4zm5.2 0l4.6-4.6-4.6-4.6L16 6l6 6-6 6-1.4-1.4z',
    'icon-audit':        'M14 2H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 1.99 2H18c1.1 0 2-.9 2-2V8l-6-6zm4 18H6V4h7v5h5v11z',
    'icon-check':        'M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z',
    'icon-info':         'M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z',
    'icon-status':       'M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z',
  };

  // Inject hidden SVG sprite
  const sprite = document.createElementNS(svgNS, 'svg');
  sprite.setAttribute('style', 'display:none;position:absolute');
  sprite.setAttribute('aria-hidden', 'true');
  const defsEl = document.createElementNS(svgNS, 'defs');

  Object.entries(defs).forEach(([id, path]) => {
    const sym = document.createElementNS(svgNS, 'symbol');
    sym.setAttribute('id', id);
    sym.setAttribute('viewBox', '0 0 24 24');
    const pathEl = document.createElementNS(svgNS, 'path');
    pathEl.setAttribute('d', path);
    pathEl.setAttribute('fill', 'currentColor');
    sym.appendChild(pathEl);
    defsEl.appendChild(sym);
  });

  sprite.appendChild(defsEl);
  document.body.insertBefore(sprite, document.body.firstChild);
})();

// ── Helper: render icon ──────────────────────────────────────────
function icon(id, cls) {
  return `<svg class="icon${cls?' '+cls:''}" aria-hidden="true"><use href="#${id}"/></svg>`;
}

// ── Sidebar collapse ─────────────────────────────────────────────
(function initSidebar() {
  const COLLAPSED_KEY = 'forensafe_sidebar_collapsed';
  const body = document.body;

  // Restore saved state
  if (localStorage.getItem(COLLAPSED_KEY) === '1') {
    body.classList.add('sidebar-collapsed');
  }

  // Toggle button
  const toggle = document.getElementById('sidebarToggle');
  if (toggle) {
    toggle.addEventListener('click', () => {
      body.classList.toggle('sidebar-collapsed');
      localStorage.setItem(COLLAPSED_KEY,
        body.classList.contains('sidebar-collapsed') ? '1' : '0');
    });
  }

  // Mobile: open/close
  const overlay = document.getElementById('sidebarOverlay');
  if (overlay) {
    overlay.addEventListener('click', () => {
      document.getElementById('sidebar').classList.remove('open');
    });
  }
})();

// ── Theme toggle (dark / light) ──────────────────────────────────
(function initTheme() {
  const THEME_KEY = 'forensafe_theme';
  const saved = localStorage.getItem(THEME_KEY) || 'dark';
  if (saved === 'light') {
    document.documentElement.setAttribute('data-theme', 'light');
    document.body.setAttribute('data-theme', 'light');
  }

  document.addEventListener('DOMContentLoaded', () => {
    const btn = document.getElementById('themeToggle');
    if (!btn) return;
    updateThemeBtn(btn, saved);
    btn.addEventListener('click', () => {
      const current = document.body.getAttribute('data-theme') || 'dark';
      const next = current === 'dark' ? 'light' : 'dark';
      document.body.setAttribute('data-theme', next);
      document.documentElement.setAttribute('data-theme', next);
      localStorage.setItem(THEME_KEY, next);
      updateThemeBtn(btn, next);
    });
  });

  function updateThemeBtn(btn, theme) {
    btn.innerHTML = theme === 'dark'
      ? `<svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-sun"/></svg><span>LIGHT</span>`
      : `<svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><use href="#icon-moon"/></svg><span>DARK</span>`;
  }
})();

// ── Flash message auto-hide ──────────────────────────────────────
document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('.alert.auto-hide').forEach(a => {
    setTimeout(() => {
      a.style.transition = 'opacity 0.5s';
      a.style.opacity = '0';
      setTimeout(() => a.remove(), 500);
    }, 3500);
  });

  // Active nav link highlight
  const currentPath = window.location.pathname + window.location.search;
  document.querySelectorAll('.nav-link').forEach(link => {
    const href = (link.getAttribute('href') || '').split('?')[0];
    if (href.length > 1 && currentPath.includes(href)) {
      link.classList.add('active');
    }
  });
});

// ── Confirmation dialog ──────────────────────────────────────────
function confirmDelete(url, itemName) {
  if (confirm('DELETE CONFIRMATION\n\nAre you sure you want to permanently delete "' + itemName + '"?\n\nThis action cannot be undone.')) {
    window.location.href = url;
  }
}

// ── Quick evidence status update ─────────────────────────────────
function updateEvidenceStatus(evidenceId, newStatus, ctxPath) {
  if (!confirm('Change status of ' + evidenceId + ' to "' + newStatus + '"?')) return;
  fetch(ctxPath + '/evidence', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: 'action=updateStatus&evidenceId=' + encodeURIComponent(evidenceId)
         + '&status=' + encodeURIComponent(newStatus)
  }).then(r => {
    if (r.ok || r.redirected) window.location.reload();
    else alert('Status update failed.');
  }).catch(() => window.location.reload());
}

// ── Table quick-filter ───────────────────────────────────────────
function filterTable(inputId, tableId) {
  const val = document.getElementById(inputId).value.toLowerCase();
  document.querySelectorAll('#' + tableId + ' tbody tr').forEach(row => {
    row.style.display = row.textContent.toLowerCase().includes(val) ? '' : 'none';
  });
}

// ── Export CSV ───────────────────────────────────────────────────
function exportTableCSV(tableId, filename) {
  const rows = document.querySelectorAll('#' + tableId + ' tr');
  const csv = Array.from(rows).map(r =>
    Array.from(r.querySelectorAll('th,td'))
      .map(c => '"' + c.innerText.replace(/"/g,'""') + '"')
      .join(',')
  ).join('\n');
  const blob = new Blob([csv], { type: 'text/csv' });
  const a = document.createElement('a');
  a.href = URL.createObjectURL(blob);
  a.download = filename || 'export.csv';
  a.click();
}

// ── Hash generator ───────────────────────────────────────────────
async function generateHash(inputId, outputId) {
  const val = document.getElementById(inputId).value;
  if (!val) { alert('Enter a value to hash.'); return; }
  const data = new TextEncoder().encode(val);
  const hashBuffer = await crypto.subtle.digest('SHA-256', data);
  const hashHex = Array.from(new Uint8Array(hashBuffer))
    .map(b => b.toString(16).padStart(2,'0')).join('');
  document.getElementById(outputId).value = hashHex;
}

// ── Dashboard Charts (Chart.js) ──────────────────────────────────
function initDashboardCharts(statusData, monthlyLabels, monthlyData) {
  const isDark = (document.body.getAttribute('data-theme') !== 'light');
  const gridColor = isDark ? 'rgba(0,212,255,0.08)' : 'rgba(0,0,0,0.06)';
  const textColor = isDark ? '#6b9ab8' : '#64748b';

  const ctx1 = document.getElementById('statusChart');
  if (ctx1) {
    new Chart(ctx1, {
      type: 'doughnut',
      data: {
        labels: ['Open','Under Investigation','Closed'],
        datasets: [{
          data: statusData,
          backgroundColor: ['rgba(0,255,157,0.8)','rgba(255,170,0,0.8)','rgba(107,122,153,0.6)'],
          borderColor: ['#00ff9d','#ffaa00','#6b7a99'],
          borderWidth: 2,
        }]
      },
      options: {
        responsive: true, maintainAspectRatio: false,
        plugins: {
          legend: { position: 'bottom', labels: { color: textColor, padding: 16, font: { size: 12 } } }
        },
        cutout: '65%',
      }
    });
  }

  const ctx2 = document.getElementById('monthlyChart');
  if (ctx2) {
    new Chart(ctx2, {
      type: 'bar',
      data: {
        labels: monthlyLabels,
        datasets: [{
          label: 'Cases',
          data: monthlyData,
          backgroundColor: 'rgba(0,212,255,0.3)',
          borderColor: '#00d4ff',
          borderWidth: 1,
          borderRadius: 2,
        }]
      },
      options: {
        responsive: true, maintainAspectRatio: false,
        plugins: { legend: { display: false } },
        scales: {
          x: { grid: { color: gridColor }, ticks: { color: textColor } },
          y: { grid: { color: gridColor }, ticks: { color: textColor, stepSize: 1 } }
        }
      }
    });
  }
}

// ── Analytics Charts ─────────────────────────────────────────────
function initAnalyticsCharts(statusLabels, statusCounts, percentages) {
  const isDark = (document.body.getAttribute('data-theme') !== 'light');
  const textColor = isDark ? '#6b9ab8' : '#64748b';

  const ctx = document.getElementById('analyticsStatusChart');
  if (!ctx) return;
  new Chart(ctx, {
    type: 'bar',
    data: {
      labels: statusLabels,
      datasets: [{
        label: 'Cases',
        data: statusCounts,
        backgroundColor: ['rgba(0,255,157,0.5)','rgba(255,170,0,0.5)','rgba(107,122,153,0.5)'],
        borderColor: ['#00ff9d','#ffaa00','#6b7a99'],
        borderWidth: 1, borderRadius: 3,
      }]
    },
    options: {
      responsive: true, maintainAspectRatio: false,
      plugins: { legend: { display: false } },
      scales: { y: { ticks: { color: textColor, stepSize: 1 } }, x: { ticks: { color: textColor } } }
    }
  });
}

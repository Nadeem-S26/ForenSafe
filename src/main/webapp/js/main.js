/* Forensafe – Main JS */

// ── Confirmation dialog ─────────────────────────────────────────
function confirmDelete(url, itemName) {
  if (confirm(`⚠️ DELETE CONFIRMATION\n\nAre you sure you want to permanently delete "${itemName}"?\n\nThis action cannot be undone.`)) {
    window.location.href = url;
  }
}

// ── Flash message auto-hide ─────────────────────────────────────
document.addEventListener('DOMContentLoaded', () => {
  const alerts = document.querySelectorAll('.alert.auto-hide');
  alerts.forEach(a => {
    setTimeout(() => {
      a.style.transition = 'opacity 0.5s';
      a.style.opacity = '0';
      setTimeout(() => a.remove(), 500);
    }, 3500);
  });

  // Active nav link highlight
  const currentPath = window.location.pathname;
  document.querySelectorAll('.nav-link').forEach(link => {
    const href = link.getAttribute('href');
    if (href && currentPath.includes(href.split('?')[0]) && href !== '/') {
      link.classList.add('active');
    }
  });

  // Mobile menu toggle
  const menuBtn = document.getElementById('menuToggle');
  const sidebar = document.getElementById('sidebar');
  if (menuBtn && sidebar) {
    menuBtn.addEventListener('click', () => sidebar.classList.toggle('open'));
    document.addEventListener('click', e => {
      if (!sidebar.contains(e.target) && !menuBtn.contains(e.target)) {
        sidebar.classList.remove('open');
      }
    });
  }
});

// ── Hash generator (SHA-256 via SubtleCrypto) ───────────────────
async function generateHash(inputId, outputId) {
  const val = document.getElementById(inputId).value;
  if (!val) { alert('Enter a value to hash.'); return; }
  const encoder = new TextEncoder();
  const data = encoder.encode(val);
  const hashBuffer = await crypto.subtle.digest('SHA-256', data);
  const hashArray = Array.from(new Uint8Array(hashBuffer));
  const hashHex = hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
  document.getElementById(outputId).value = hashHex;
}

// ── Dashboard Charts (Chart.js) ─────────────────────────────────
function initDashboardCharts(statusData, monthlyLabels, monthlyData) {
  // Case Status Donut
  const ctx1 = document.getElementById('statusChart');
  if (ctx1) {
    new Chart(ctx1, {
      type: 'doughnut',
      data: {
        labels: ['Open', 'Under Investigation', 'Closed'],
        datasets: [{
          data: statusData,
          backgroundColor: ['rgba(0,255,157,0.8)', 'rgba(255,179,71,0.8)', 'rgba(107,122,153,0.6)'],
          borderColor: ['#00ff9d', '#ffb347', '#6b7a99'],
          borderWidth: 2,
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            position: 'bottom',
            labels: { color: '#6b7a99', padding: 16, font: { size: 12 } }
          }
        },
        cutout: '65%',
      }
    });
  }

  // Monthly Cases Bar
  const ctx2 = document.getElementById('monthlyChart');
  if (ctx2) {
    new Chart(ctx2, {
      type: 'bar',
      data: {
        labels: monthlyLabels,
        datasets: [{
          label: 'Cases Registered',
          data: monthlyData,
          backgroundColor: 'rgba(0, 212, 255, 0.3)',
          borderColor: '#00d4ff',
          borderWidth: 2,
          borderRadius: 4,
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: { legend: { display: false } },
        scales: {
          x: {
            grid: { color: 'rgba(255,255,255,0.04)' },
            ticks: { color: '#6b7a99', font: { size: 11 } }
          },
          y: {
            grid: { color: 'rgba(255,255,255,0.04)' },
            ticks: { color: '#6b7a99', stepSize: 1, font: { size: 11 } },
            beginAtZero: true
          }
        }
      }
    });
  }
}

// ── Simple table search ─────────────────────────────────────────
function filterTable(inputId, tableId) {
  const query = document.getElementById(inputId).value.toLowerCase();
  const rows  = document.querySelectorAll(`#${tableId} tbody tr`);
  rows.forEach(row => {
    row.style.display = row.textContent.toLowerCase().includes(query) ? '' : 'none';
  });
}

// ── Print page ──────────────────────────────────────────────────
function printReport() { window.print(); }

// ── CSV Export ──────────────────────────────────────────────────
function exportTableCSV(tableId, filename) {
  const table = document.getElementById(tableId);
  if (!table) return;
  const rows = Array.from(table.querySelectorAll('tr'));
  const csv  = rows.map(row =>
    Array.from(row.querySelectorAll('th,td'))
      .map(cell => `"${cell.innerText.replace(/"/g, '""')}"`)
      .join(',')
  ).join('\n');
  const blob = new Blob([csv], { type: 'text/csv' });
  const a = document.createElement('a');
  a.href = URL.createObjectURL(blob);
  a.download = filename || 'export.csv';
  a.click();
}

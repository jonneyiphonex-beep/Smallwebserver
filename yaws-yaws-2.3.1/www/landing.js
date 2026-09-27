const toggleThemeButton = document.getElementById('toggleTheme');
const statusBadge = document.getElementById('statusBadge');
const primaryAction = document.getElementById('primaryAction');

if (toggleThemeButton) {
  toggleThemeButton.addEventListener('click', () => {
    document.body.classList.toggle('light');
    const isLight = document.body.classList.contains('light');
    toggleThemeButton.textContent = isLight ? 'Switch to dark' : 'Toggle theme';
  });
}

if (primaryAction) {
  primaryAction.addEventListener('click', () => {
    statusBadge.textContent = 'Updated';
    statusBadge.classList.remove('online');
    statusBadge.classList.add('badge');
    statusBadge.style.background = 'rgba(56, 189, 248, 0.16)';
    statusBadge.style.color = 'var(--accent)';
  });
}

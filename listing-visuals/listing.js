const names = {
  A: 'A — Ace on felt',
  B: 'B — Corner crop',
  C: 'C — Fan',
};
const order = ['A', 'B', 'C'];

function current() {
  const key = new URLSearchParams(location.search).get('variant') || 'A';
  return order.includes(key) ? key : 'A';
}

function show(key) {
  const url = new URL(location.href);
  url.searchParams.set('variant', key);
  history.replaceState(null, '', url);
  for (const stage of document.querySelectorAll('[data-variant]')) {
    stage.hidden = stage.dataset.variant !== key;
  }
  document.getElementById('variant-label').textContent = names[key];
}

function step(delta) {
  const i = order.indexOf(current());
  show(order[(i + delta + order.length) % order.length]);
}

document.getElementById('prev').addEventListener('click', () => step(-1));
document.getElementById('next').addEventListener('click', () => step(1));
document.addEventListener('keydown', (event) => {
  const tag = document.activeElement && document.activeElement.tagName;
  if (tag === 'INPUT' || tag === 'TEXTAREA') return;
  if (event.key === 'ArrowLeft') step(-1);
  if (event.key === 'ArrowRight') step(1);
});
show(current());

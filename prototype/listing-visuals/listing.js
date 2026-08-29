// Three listing-visual families, switchable via ?variant=
const VARIANTS = [
  { key: 'A', name: 'Ace on felt' },
  { key: 'B', name: 'Corner crop' },
  { key: 'C', name: 'Fan' },
];

function currentKey() {
  const v = new URLSearchParams(location.search).get('variant') || 'A';
  return VARIANTS.some((x) => x.key === v) ? v : 'A';
}

function setVariant(key) {
  const url = new URL(location.href);
  url.searchParams.set('variant', key);
  history.replaceState(null, '', url);
  render();
}

function cycle(dir) {
  const i = VARIANTS.findIndex((x) => x.key === currentKey());
  const next = VARIANTS[(i + dir + VARIANTS.length) % VARIANTS.length];
  setVariant(next.key);
}

function render() {
  const key = currentKey();
  document.querySelectorAll('.stage').forEach((el) => {
    el.hidden = el.dataset.variant !== key;
  });
  const meta = VARIANTS.find((x) => x.key === key);
  document.getElementById('variant-label').textContent = `${meta.key} — ${meta.name}`;
}

document.getElementById('prev').addEventListener('click', () => cycle(-1));
document.getElementById('next').addEventListener('click', () => cycle(1));
document.addEventListener('keydown', (e) => {
  const tag = (e.target && e.target.tagName) || '';
  if (tag === 'INPUT' || tag === 'TEXTAREA' || e.target.isContentEditable) return;
  if (e.key === 'ArrowLeft') cycle(-1);
  if (e.key === 'ArrowRight') cycle(1);
});

render();

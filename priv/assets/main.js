fetch('/some/api')
  .then(r => r.text())
  .then(html => document.body.insertAdjacentHTML('beforeend', html));

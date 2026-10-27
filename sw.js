/* Service worker — deixa o app abrir sem internet.
   O nome do cache muda a cada versão publicada, então uma versão
   nova nunca fica presa atrás da antiga. */
var VERSAO = '7656a5f42f';
var CACHE  = 'meu-dinheiro-' + VERSAO;
var CASCA  = [
  './', './index.html', './config.js', './manifest.webmanifest',
  './favicon.png', './icons/icon.svg',
  './icons/icon-192.png', './icons/icon-512.png',
  './icons/icon-maskable-512.png', './icons/apple-touch-icon.png'
];

self.addEventListener('install', function(ev){
  ev.waitUntil(
    caches.open(CACHE)
      .then(function(c){ return c.addAll(CASCA); })
      .then(function(){ return self.skipWaiting(); })
      .catch(function(){ return self.skipWaiting(); })
  );
});

self.addEventListener('activate', function(ev){
  ev.waitUntil(
    caches.keys().then(function(ns){
      return Promise.all(ns.map(function(n){
        return n !== CACHE ? caches.delete(n) : null;
      }));
    }).then(function(){ return self.clients.claim(); })
  );
});

self.addEventListener('fetch', function(ev){
  var req = ev.request;
  if (req.method !== 'GET') return;

  var url;
  try { url = new URL(req.url); } catch(e){ return; }
  /* chamadas ao Supabase nunca passam pelo cache */
  if (url.origin !== self.location.origin) return;

  /* abrir o app: tenta a rede (pega versão nova), cai para o cache */
  if (req.mode === 'navigate') {
    ev.respondWith(
      fetch(req).then(function(r){
        var copia = r.clone();
        caches.open(CACHE).then(function(c){ c.put('./index.html', copia); });
        return r;
      }).catch(function(){
        return caches.match('./index.html').then(function(r){
          return r || caches.match('./');
        });
      })
    );
    return;
  }

  /* demais arquivos: cache primeiro, atualizando por trás */
  ev.respondWith(
    caches.match(req).then(function(cacheado){
      var rede = fetch(req).then(function(r){
        if (r && r.ok) {
          var copia = r.clone();
          caches.open(CACHE).then(function(c){ c.put(req, copia); });
        }
        return r;
      }).catch(function(){ return cacheado; });
      return cacheado || rede;
    })
  );
});

const CACHE_NAME = 'butterfly-v4'; // Cambiamos a v4 para forzar actualización
const assets = [
  './',
  './index.html',
  './manifest.json',
  './Logo.jpeg'
];

self.addEventListener('install', event => {
  self.skipWaiting(); // Esto obliga al nuevo service worker a tomar el control de inmediato
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => {
      console.log('Cacheando archivos de lujo...');
      return cache.addAll(assets);
    })
  );
});

self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(keys => {
      return Promise.all(
        keys.filter(key => key !== CACHE_NAME).map(key => caches.delete(key))
      );
    })
  );
});

self.addEventListener('fetch', event => {
  event.respondWith(
    fetch(event.request).catch(() => caches.match(event.request))
  );
});

const CACHE_NAME = 'butterfly-v1';

// Esto ayuda a que la app cargue más rápido
self.addEventListener('install', (event) => {
  self.skipWaiting();
});

self.addEventListener('fetch', (event) => {
  // Aquí podemos configurar que funcione sin internet en el futuro
  event.respondWith(fetch(event.request));
});

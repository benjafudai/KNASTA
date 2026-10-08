// Offline support for the installed app. Pages are fetched from the network first so
// prices are always current, and the last copy is kept for when there's no signal.
// Fingerprinted assets (/assets/...) never change, so they're served from cache.
const CACHE = "knasta-v1"

self.addEventListener("install", () => self.skipWaiting())

self.addEventListener("activate", (event) => {
  event.waitUntil(
    caches.keys()
      .then((keys) => Promise.all(keys.filter((key) => key !== CACHE).map((key) => caches.delete(key))))
      .then(() => self.clients.claim())
  )
})

self.addEventListener("fetch", (event) => {
  const { request } = event
  const url = new URL(request.url)
  if (request.method !== "GET" || url.origin !== self.location.origin) return

  if (url.pathname.startsWith("/assets/")) {
    event.respondWith(
      caches.match(request).then((cached) => cached || fetchAndCache(request))
    )
  } else if (request.mode === "navigate" || request.headers.get("Accept")?.includes("text/html")) {
    event.respondWith(
      fetchAndCache(request).catch(() => caches.match(request).then((cached) => cached || caches.match("/")))
    )
  }
})

async function fetchAndCache(request) {
  const response = await fetch(request)
  if (response.ok) {
    const copy = response.clone()
    caches.open(CACHE).then((cache) => cache.put(request, copy))
  }
  return response
}

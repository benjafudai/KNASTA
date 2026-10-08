// Demo source: generates plausible prices so the app has data to show.
// Replace or complement it with real store sources (see scripts/sources/README.md).

const BASE_PRICE = {
  filtros: 9000, frenos: 28000, suspension: 55000, motor: 90000, encendido: 12000,
  electrico: 85000, iluminacion: 120000, carroceria: 140000, transmision: 180000,
  refrigeracion: 95000, lubricantes: 38000,
}

function hash(str) {
  let h = 0
  for (const c of str) h = (h * 31 + c.charCodeAt(0)) >>> 0
  return h
}

export default {
  id: 'demo',
  async fetchOffers({ part, stores, now }) {
    const day = now.toISOString().slice(0, 10)
    return stores.map((store) => {
      const seed = hash(`${part.id}:${store.id}`)
      const daily = hash(`${part.id}:${store.id}:${day}`)
      const base = BASE_PRICE[part.category] ?? 30000
      const price = Math.round((base * (0.8 + (seed % 50) / 100) * (0.97 + (daily % 7) / 100)) / 10) * 10
      return {
        partId: part.id,
        storeId: store.id,
        price,
        url: `${store.url}/buscar?q=${encodeURIComponent(part.code)}`,
        inStock: daily % 5 !== 0,
        updatedAt: now.toISOString(),
      }
    })
  },
}

# Fuentes de precios

Cada fuente es un módulo que exporta un objeto con:

```js
export default {
  id: 'mi-tienda',
  // Devuelve las ofertas de una pieza: [{ partId, storeId, price, url, inStock, updatedAt }]
  async fetchOffers({ part, stores, now }) { ... },
}
```

Para agregar una tienda real:

1. Agrega la tienda en `src/data/stores.json`.
2. Crea `scripts/sources/<tienda>.mjs` que busque la pieza (por `part.code` o nombre) en la página o API de la tienda y devuelva sus ofertas.
3. Regístrala en la lista `sources` de `scripts/update-prices.mjs`.

Revisa los términos de uso de cada sitio antes de leer sus precios; si la tienda ofrece API o feed de productos, úsalo en vez de leer el HTML.

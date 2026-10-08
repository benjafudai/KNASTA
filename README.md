# KNASTA de Repuestos

Buscador de repuestos de vehículos que reúne resultados de distintas páginas y mantiene los precios actualizados.

## Objetivo

- Buscar repuestos por vehículo (marca, modelo, año) o por nombre/código de pieza.
- Enlazar a las páginas de origen de cada repuesto.
- Actualizar los precios de forma periódica.

## Estado

Base de la app lista con datos de demostración (24 repuestos, 3 tiendas de prueba).

## Cómo funciona

- **Marcas por nacionalidad**: 63 marcas agrupadas en 12 nacionalidades (`src/data/brands.ts`). La nacionalidad es el país de origen de la marca.
- **Búsqueda tipo SoloTodo**: buscador por texto y filtros por marca, modelo, año y categoría, ordenando por precio.
- **Ficha de repuesto**: precio en cada tienda, stock, fecha de actualización y botón para ir a la tienda.
- **Precios**: `npm run update-prices` recorre las fuentes de `scripts/sources/` y regenera `src/data/offers.json`. Hoy solo existe una fuente de demostración; las tiendas reales se agregan como nuevas fuentes.

## Desarrollo

```bash
npm install
npm run dev            # servidor local
npm run build          # build de producción en dist/
npm run update-prices  # actualiza los precios
```

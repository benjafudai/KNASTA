# Repuestómetro

Buscador de repuestos de vehículos al estilo SoloTodo. Reúne los precios de distintas tiendas, enlaza a cada una y mantiene los precios actualizados. Funciona en el teléfono y se puede instalar en la pantalla de inicio.

Hecho con Ruby on Rails 8 y PostgreSQL, igual que GestFleet.

## Cómo funciona

- **Marcas por nacionalidad**: 63 marcas agrupadas en 12 nacionalidades (japonesas, coreanas, chinas, americanas, alemanas, etc.). La nacionalidad es el país de origen de la marca. La lista está en `db/seeds/brands.rb`.
- **Búsqueda**: por texto (sin importar tildes) y con filtros por marca, modelo, año y categoría, ordenando por el menor precio con stock (`app/models/part_search.rb`).
- **Ficha de repuesto**: precio en cada tienda, stock, fecha de actualización y botón para ir a la tienda.
- **Precios**: `UpdatePricesJob` descarga el catálogo de cada tienda, busca cada repuesto por su código y guarda el precio. Cada cambio de precio queda en el historial (`PricePoint`). En producción corre todos los días a las 6:00 (`config/recurring.yml`).
- **Celulares**: diseño adaptado a pantallas chicas y app instalable (PWA) con páginas visitadas disponibles sin conexión (`app/views/pwa/`).

## Modelo de datos

```
Nationality ─< Brand ─< VehicleModel ─< Fitment >─ Part >─ Category
                                                    │
Store ─< Offer >────────────────────────────────────┘
  │      └─< PricePoint (historial de precios)
  └─< StoreListing (catálogo descargado de la tienda)
```

## Tiendas conectadas

| Tienda | Marcas que cubre | Cómo se leen los precios |
|---|---|---|
| [MS Repuestos](https://www.msrepuestos.cl) | Hyundai, Kia, SsangYong, Maxus, MG | Catálogo público de Shopify |
| [Repuestos Europa](https://www.repuestoseuropa.cl) | BMW, Mercedes-Benz, VW, Audi, Volvo, MINI, Porsche, Land Rover... | Catálogo público de Shopify |

Cada actualización descarga el catálogo completo de la tienda desde `/products.json` (permitido por su `robots.txt`, con una pausa entre páginas) y lo guarda en `StoreListing`. Después cada repuesto se busca por su código: el SKU del producto o un número de parte en el título (por ejemplo, el repuesto con código `26300-35505` calza con "Filtro Aceite ... Original 2630035505"). Si no hay coincidencia exacta de código, la tienda no muestra precio para ese repuesto, para no mezclar productos distintos.

En desarrollo también existen tres «Tienda Demo» con precios generados.

### Agregar otra tienda

- **Si usa Shopify** (se reconoce por rutas `/products/...` y `/collections/...`): basta con crear la tienda con `source: "shopify"` y la URL de su página principal.
- **Si usa otra plataforma**: crea `app/models/price_sources/<plataforma>.rb` con `self.fetch(part, store)` (y opcionalmente `self.sync(store)` para descargar el catálogo), siguiendo `PriceSources::Shopify` como ejemplo.

Revisa el `robots.txt` y los términos de cada sitio antes de conectarlo.

## Desarrollo

Requisitos: Ruby 3.3 y PostgreSQL.

```bash
bin/setup                 # instala gemas, crea la base de datos y carga los datos de ejemplo
bin/dev                   # servidor en http://localhost:3000
bin/rails test            # tests
bin/rails prices:update   # actualiza los precios ahora
bin/ci                    # lint, auditorías de seguridad y tests
```

## Producción

La app se publica en un VPS con Kamal: cada cambio en `main` que pasa los tests se despliega solo desde GitHub Actions. Los pasos para conectar tu VPS están en [docs/despliegue.md](docs/despliegue.md).

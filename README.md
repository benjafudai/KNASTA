# Repuestómetro

Buscador de repuestos de vehículos al estilo SoloTodo. Reúne los precios de distintas tiendas, enlaza a cada una y mantiene los precios actualizados. Funciona en el teléfono y se puede instalar en la pantalla de inicio.

Hecho con Ruby on Rails 8 y PostgreSQL, igual que GestFleet.

## Cómo funciona

- **Marcas por nacionalidad**: 63 marcas agrupadas en 12 nacionalidades (japonesas, coreanas, chinas, americanas, alemanas, etc.). La nacionalidad es el país de origen de la marca. La lista está en `db/seeds/brands.rb`.
- **Búsqueda**: por texto (sin importar tildes) y con filtros por marca, modelo, año y categoría, ordenando por el menor precio con stock (`app/models/part_search.rb`).
- **Ficha de repuesto**: precio en cada tienda, stock, fecha de actualización y botón para ir a la tienda.
- **Precios**: `UpdatePricesJob` consulta la fuente de precios de cada tienda y guarda el precio. Cada cambio de precio queda en el historial (`PricePoint`). En producción corre todos los días a las 6:00 (`config/recurring.yml`).
- **Celulares**: diseño adaptado a pantallas chicas y app instalable (PWA) con páginas visitadas disponibles sin conexión (`app/views/pwa/`).

## Modelo de datos

```
Nationality ─< Brand ─< VehicleModel ─< Fitment >─ Part >─ Category
                                                    │
Store ─< Offer >────────────────────────────────────┘
         └─< PricePoint (historial de precios)
```

## Conectar una tienda real

Hoy solo existen tres tiendas de demostración con precios generados (`PriceSources::Demo`). Para agregar una tienda real:

1. Crea `app/models/price_sources/<tienda>.rb` con un método `self.fetch(part, store)` que devuelva `{ price:, url:, in_stock: }` o `nil` si la tienda no vende ese repuesto. Usa `PriceSources::Demo` como ejemplo.
2. Crea la tienda con `source: "<tienda>"`.
3. Ejecuta `bin/rails prices:update` para probarla.

Revisa los términos de uso de cada sitio antes de leer sus precios. Si la tienda ofrece una API o un feed de productos, úsalo en vez de leer el HTML.

## Desarrollo

Requisitos: Ruby 3.3 y PostgreSQL.

```bash
bin/setup                 # instala gemas, crea la base de datos y carga los datos de ejemplo
bin/dev                   # servidor en http://localhost:3000
bin/rails test            # tests
bin/rails prices:update   # actualiza los precios ahora
bin/ci                    # lint, auditorías de seguridad y tests
```

En producción define `SECRET_KEY_BASE` (o crea tus credenciales con `bin/rails credentials:edit`) y `REPUESTOMETRO_DATABASE_PASSWORD`. Las tareas programadas corren con `bin/jobs`.

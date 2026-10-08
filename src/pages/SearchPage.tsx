import { useState } from 'react'
import { useSearchParams } from 'react-router-dom'
import { brands, nationalities } from '../data/brands'
import { categories } from '../data/categories'
import { bestPrice, modelsOf, searchParts } from '../data/catalog'
import PartCard from '../components/PartCard'

type Sort = 'precio-asc' | 'precio-desc' | 'nombre'

export default function SearchPage() {
  const [params, setParams] = useSearchParams()
  const q = params.get('q') ?? ''
  const brand = params.get('marca') ?? ''
  const model = params.get('modelo') ?? ''
  const category = params.get('categoria') ?? ''
  const year = Number(params.get('anio')) || undefined
  const sort = (params.get('orden') as Sort) ?? 'precio-asc'

  const activeFilters = [brand, model, category, year].filter(Boolean).length
  // On phones the filters start collapsed so the results are visible first.
  const [filtersOpen, setFiltersOpen] = useState(() => window.matchMedia('(min-width: 721px)').matches)

  const set = (key: string, value: string) => {
    const next = new URLSearchParams(params)
    if (value) next.set(key, value)
    else next.delete(key)
    if (key === 'marca') next.delete('modelo')
    setParams(next)
  }

  const price = (id: string) => bestPrice(id) ?? Infinity
  const results = searchParts({ q, brand, model, category, year }).sort((a, b) =>
    sort === 'nombre'
      ? a.name.localeCompare(b.name)
      : sort === 'precio-desc'
        ? price(b.id) - price(a.id)
        : price(a.id) - price(b.id),
  )

  return (
    <div className="search-layout">
      <details className="filters card" open={filtersOpen} onToggle={(e) => setFiltersOpen(e.currentTarget.open)}>
        <summary>
          Filtros y orden{activeFilters > 0 && <span className="badge">{activeFilters}</span>}
        </summary>
        <div className="filters-body">
          <label>
            Marca
            <select value={brand} onChange={(e) => set('marca', e.target.value)}>
              <option value="">Todas</option>
              {nationalities.map((n) => (
                <optgroup key={n.id} label={`${n.flag} ${n.name}`}>
                  {brands
                    .filter((b) => b.nationality === n.id)
                    .map((b) => (
                      <option key={b.slug} value={b.slug}>
                        {b.name}
                      </option>
                    ))}
                </optgroup>
              ))}
            </select>
          </label>
          {brand && (
            <label>
              Modelo
              <select value={model} onChange={(e) => set('modelo', e.target.value)}>
                <option value="">Todos</option>
                {modelsOf(brand).map((m) => (
                  <option key={m}>{m}</option>
                ))}
              </select>
            </label>
          )}
          <label>
            Año
            <input
              type="number"
              min={1980}
              max={2030}
              value={year ?? ''}
              placeholder="Ej: 2018"
              onChange={(e) => set('anio', e.target.value)}
            />
          </label>
          <label>
            Categoría
            <select value={category} onChange={(e) => set('categoria', e.target.value)}>
              <option value="">Todas</option>
              {categories.map((c) => (
                <option key={c.slug} value={c.slug}>
                  {c.name}
                </option>
              ))}
            </select>
          </label>
          <label>
            Ordenar por
            <select value={sort} onChange={(e) => set('orden', e.target.value)}>
              <option value="precio-asc">Menor precio</option>
              <option value="precio-desc">Mayor precio</option>
              <option value="nombre">Nombre</option>
            </select>
          </label>
        </div>
      </details>
      <section>
        <p className="muted">
          {results.length} resultado{results.length === 1 ? '' : 's'}
          {q && <> para “{q}”</>}
        </p>
        {results.length ? (
          <div className="part-grid">
            {results.map((p) => (
              <PartCard key={p.id} part={p} />
            ))}
          </div>
        ) : (
          <p className="empty">No encontramos repuestos con esos filtros.</p>
        )}
      </section>
    </div>
  )
}

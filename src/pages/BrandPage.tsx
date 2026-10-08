import { Link, useParams } from 'react-router-dom'
import { brandBySlug, nationalityById } from '../data/brands'
import { categories } from '../data/categories'
import { modelsOf, searchParts } from '../data/catalog'
import PartCard from '../components/PartCard'

export default function BrandPage() {
  const { slug = '' } = useParams()
  const brand = brandBySlug(slug)
  if (!brand) return <p className="empty">Marca no encontrada.</p>

  const nationality = nationalityById(brand.nationality)!
  const models = modelsOf(slug)
  const results = searchParts({ brand: slug })

  return (
    <>
      <nav className="crumbs">
        <Link to="/">Inicio</Link> / <Link to={`/nacionalidad/${nationality.id}`}>{nationality.name}</Link> /{' '}
        {brand.name}
      </nav>
      <h1>
        Repuestos {brand.name} <span className="flag">{nationality.flag}</span>
      </h1>
      {brand.note && <p className="muted">{brand.note}</p>}

      {models.length > 0 && (
        <>
          <h2>Modelos</h2>
          <div className="brand-grid">
            {models.map((m) => (
              <Link key={m} to={`/buscar?marca=${slug}&modelo=${encodeURIComponent(m)}`} className="chip">
                {m}
              </Link>
            ))}
          </div>
        </>
      )}

      <h2>Categorías</h2>
      <div className="brand-grid">
        {categories.map((c) => (
          <Link key={c.slug} to={`/buscar?marca=${slug}&categoria=${c.slug}`} className="chip">
            {c.name}
          </Link>
        ))}
      </div>

      <h2>Repuestos</h2>
      {results.length ? (
        <div className="part-grid">
          {results.map((p) => (
            <PartCard key={p.id} part={p} />
          ))}
        </div>
      ) : (
        <p className="empty">Aún no hay repuestos cargados para {brand.name}.</p>
      )}
    </>
  )
}

import { Link } from 'react-router-dom'
import { brands, brandsOf, nationalities } from '../data/brands'
import { categories } from '../data/categories'
import BrandGrid from '../components/BrandGrid'

export default function Home() {
  return (
    <>
      <section className="hero">
        <h1>Compara precios de repuestos para tu auto</h1>
        <p className="muted">
          {brands.length} marcas ordenadas por nacionalidad. Elige la tuya y encuentra el mejor precio entre tiendas.
        </p>
      </section>

      <section>
        <h2>Categorías</h2>
        <div className="brand-grid">
          {categories.map((c) => (
            <Link key={c.slug} to={`/buscar?categoria=${c.slug}`} className="chip">
              {c.name}
            </Link>
          ))}
        </div>
      </section>

      <section>
        <h2>Marcas por nacionalidad</h2>
        <div className="nationality-list">
          {nationalities.map((n) => (
            <div key={n.id} className="card nationality">
              <Link to={`/nacionalidad/${n.id}`} className="nationality-title">
                <span className="flag">{n.flag}</span> {n.name}
                <span className="muted small"> ({brandsOf(n.id).length})</span>
              </Link>
              <BrandGrid brands={brandsOf(n.id)} />
            </div>
          ))}
        </div>
      </section>
    </>
  )
}

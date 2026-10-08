import { Link, useParams } from 'react-router-dom'
import { brandsOf, nationalityById } from '../data/brands'
import { searchParts } from '../data/catalog'
import BrandGrid from '../components/BrandGrid'
import PartCard from '../components/PartCard'

export default function NationalityPage() {
  const { id = '' } = useParams()
  const nationality = nationalityById(id)
  if (!nationality) return <p className="empty">Nacionalidad no encontrada.</p>

  const list = brandsOf(id)
  const results = list.flatMap((b) => searchParts({ brand: b.slug }))
  const unique = [...new Map(results.map((p) => [p.id, p])).values()]

  return (
    <>
      <nav className="crumbs">
        <Link to="/">Inicio</Link> / {nationality.name}
      </nav>
      <h1>
        {nationality.flag} Marcas {nationality.name.toLowerCase()}
      </h1>
      <BrandGrid brands={list} />
      <h2>Repuestos destacados</h2>
      {unique.length ? (
        <div className="part-grid">
          {unique.map((p) => (
            <PartCard key={p.id} part={p} />
          ))}
        </div>
      ) : (
        <p className="empty">Aún no hay repuestos cargados para estas marcas.</p>
      )}
    </>
  )
}

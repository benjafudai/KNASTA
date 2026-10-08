import { Link, useParams } from 'react-router-dom'
import { brandBySlug } from '../data/brands'
import { categoryBySlug } from '../data/categories'
import { formatCLP, formatDate, offersFor, partById, storeById } from '../data/catalog'

export default function PartPage() {
  const { id = '' } = useParams()
  const part = partById(id)
  if (!part) return <p className="empty">Repuesto no encontrado.</p>

  const category = categoryBySlug(part.category)
  const list = offersFor(part.id)
  const best = list.find((o) => o.inStock)

  return (
    <>
      <nav className="crumbs">
        <Link to="/">Inicio</Link> / <Link to={`/buscar?categoria=${part.category}`}>{category?.name}</Link> /{' '}
        {part.name}
      </nav>
      <h1>{part.name}</h1>
      <p className="muted">
        {part.manufacturer} · Código {part.code}
      </p>

      <h2>Compatible con</h2>
      <ul className="fits-list">
        {part.compatibleWith.map((c) => (
          <li key={`${c.brand}-${c.model}`}>
            <Link to={`/marca/${c.brand}`}>{brandBySlug(c.brand)?.name ?? c.brand}</Link> {c.model} ({c.years[0]}–
            {c.years[1]})
          </li>
        ))}
      </ul>

      <h2>Precios por tienda</h2>
      <table className="offers">
        <thead>
          <tr>
            <th>Tienda</th>
            <th>Precio</th>
            <th>Stock</th>
            <th>Actualizado</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          {list.map((o) => (
            <tr key={o.storeId} className={o === best ? 'best' : undefined}>
              <td>{storeById(o.storeId)?.name ?? o.storeId}</td>
              <td className="price">{formatCLP(o.price)}</td>
              <td>{o.inStock ? 'Disponible' : 'Sin stock'}</td>
              <td className="muted small">{formatDate(o.updatedAt)}</td>
              <td>
                <a href={o.url} target="_blank" rel="noopener noreferrer" className="button">
                  Ir a la tienda
                </a>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </>
  )
}

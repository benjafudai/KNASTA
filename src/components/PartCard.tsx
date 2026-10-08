import { Link } from 'react-router-dom'
import type { Part } from '../data/types'
import { bestPrice, formatCLP, offersFor } from '../data/catalog'
import { brandBySlug } from '../data/brands'

export default function PartCard({ part }: { part: Part }) {
  const price = bestPrice(part.id)
  const storeCount = offersFor(part.id).filter((o) => o.inStock).length
  const fits = part.compatibleWith
    .map((c) => `${brandBySlug(c.brand)?.name ?? c.brand} ${c.model} ${c.years[0]}–${c.years[1]}`)
    .join(' · ')

  return (
    <Link to={`/repuesto/${part.id}`} className="card part-card">
      <div className="part-name">{part.name}</div>
      <div className="muted small">
        {part.manufacturer} · {part.code}
      </div>
      <div className="small fits">{fits}</div>
      <div className="part-price">
        {price ? formatCLP(price) : 'Sin stock'}
        {storeCount > 0 && <span className="muted small"> en {storeCount} tienda{storeCount > 1 ? 's' : ''}</span>}
      </div>
    </Link>
  )
}

import { Link } from 'react-router-dom'
import type { Brand } from '../data/types'

export default function BrandGrid({ brands }: { brands: Brand[] }) {
  return (
    <div className="brand-grid">
      {brands.map((b) => (
        <Link key={b.slug} to={`/marca/${b.slug}`} className="chip" title={b.note}>
          {b.name}
        </Link>
      ))}
    </div>
  )
}

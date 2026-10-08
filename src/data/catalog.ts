import type { Offer, Part, Store } from './types'
import partsJson from './parts.json'
import storesJson from './stores.json'
import offersJson from './offers.json'
import { brandBySlug } from './brands'
import { categoryBySlug } from './categories'

export const parts = partsJson as Part[]
export const stores = storesJson as Store[]
export const offers = offersJson as Offer[]

export const partById = (id: string) => parts.find((p) => p.id === id)
export const storeById = (id: string) => stores.find((s) => s.id === id)

export const offersFor = (partId: string) =>
  offers.filter((o) => o.partId === partId).sort((a, b) => a.price - b.price)

export const bestPrice = (partId: string) => {
  const available = offersFor(partId).filter((o) => o.inStock)
  return available[0]?.price
}

export const modelsOf = (brandSlug: string) =>
  [...new Set(parts.flatMap((p) => p.compatibleWith.filter((c) => c.brand === brandSlug).map((c) => c.model)))].sort()

export interface PartQuery {
  q?: string
  brand?: string
  model?: string
  category?: string
  year?: number
}

const normalize = (s: string) =>
  s.toLowerCase().normalize('NFD').replace(/[̀-ͯ]/g, '')

export function searchParts({ q, brand, model, category, year }: PartQuery): Part[] {
  const terms = q ? normalize(q).split(/\s+/).filter(Boolean) : []
  return parts.filter((p) => {
    if (category && p.category !== category) return false
    const fits = p.compatibleWith.filter(
      (c) =>
        (!brand || c.brand === brand) &&
        (!model || c.model === model) &&
        (!year || (year >= c.years[0] && year <= c.years[1])),
    )
    if ((brand || model || year) && fits.length === 0) return false
    if (terms.length === 0) return true
    const haystack = normalize(
      [
        p.name,
        p.manufacturer,
        p.code,
        categoryBySlug(p.category)?.name ?? '',
        ...p.compatibleWith.map((c) => `${brandBySlug(c.brand)?.name ?? c.brand} ${c.model}`),
      ].join(' '),
    )
    return terms.every((t) => haystack.includes(t))
  })
}

export const formatCLP = (n: number) =>
  n.toLocaleString('es-CL', { style: 'currency', currency: 'CLP', maximumFractionDigits: 0 })

export const formatDate = (iso: string) =>
  new Date(iso).toLocaleString('es-CL', { dateStyle: 'medium', timeStyle: 'short' })

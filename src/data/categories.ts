import type { Category } from './types'

export const categories: Category[] = [
  { slug: 'filtros', name: 'Filtros' },
  { slug: 'frenos', name: 'Frenos' },
  { slug: 'suspension', name: 'Suspensión y dirección' },
  { slug: 'motor', name: 'Motor' },
  { slug: 'encendido', name: 'Encendido' },
  { slug: 'electrico', name: 'Eléctrico y baterías' },
  { slug: 'iluminacion', name: 'Iluminación' },
  { slug: 'carroceria', name: 'Carrocería' },
  { slug: 'transmision', name: 'Transmisión y embrague' },
  { slug: 'refrigeracion', name: 'Refrigeración' },
  { slug: 'lubricantes', name: 'Aceites y lubricantes' },
]

export const categoryBySlug = (slug: string) => categories.find((c) => c.slug === slug)

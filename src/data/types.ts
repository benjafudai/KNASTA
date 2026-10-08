export interface Nationality {
  id: string
  name: string
  flag: string
}

export interface Brand {
  slug: string
  name: string
  nationality: string
  note?: string
}

export interface Category {
  slug: string
  name: string
}

export interface Compatibility {
  brand: string
  model: string
  years: [number, number]
}

export interface Part {
  id: string
  name: string
  category: string
  manufacturer: string
  code: string
  compatibleWith: Compatibility[]
}

export interface Store {
  id: string
  name: string
  url: string
}

export interface Offer {
  partId: string
  storeId: string
  price: number
  url: string
  inStock: boolean
  updatedAt: string
}

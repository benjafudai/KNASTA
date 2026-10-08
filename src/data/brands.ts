import type { Brand, Nationality } from './types'

export const nationalities: Nationality[] = [
  { id: 'japon', name: 'Japonesas', flag: '🇯🇵' },
  { id: 'corea', name: 'Coreanas', flag: '🇰🇷' },
  { id: 'china', name: 'Chinas', flag: '🇨🇳' },
  { id: 'eeuu', name: 'Americanas', flag: '🇺🇸' },
  { id: 'alemania', name: 'Alemanas', flag: '🇩🇪' },
  { id: 'francia', name: 'Francesas', flag: '🇫🇷' },
  { id: 'italia', name: 'Italianas', flag: '🇮🇹' },
  { id: 'reino-unido', name: 'Británicas', flag: '🇬🇧' },
  { id: 'suecia', name: 'Suecas', flag: '🇸🇪' },
  { id: 'espana', name: 'Españolas', flag: '🇪🇸' },
  { id: 'chequia', name: 'Checas', flag: '🇨🇿' },
  { id: 'india', name: 'Indias', flag: '🇮🇳' },
]

// Nationality is the brand's country of origin, not where a given model is built.
export const brands: Brand[] = [
  { slug: 'toyota', name: 'Toyota', nationality: 'japon' },
  { slug: 'nissan', name: 'Nissan', nationality: 'japon' },
  { slug: 'honda', name: 'Honda', nationality: 'japon' },
  { slug: 'mazda', name: 'Mazda', nationality: 'japon' },
  { slug: 'mitsubishi', name: 'Mitsubishi', nationality: 'japon' },
  { slug: 'suzuki', name: 'Suzuki', nationality: 'japon' },
  { slug: 'subaru', name: 'Subaru', nationality: 'japon' },
  { slug: 'isuzu', name: 'Isuzu', nationality: 'japon' },
  { slug: 'lexus', name: 'Lexus', nationality: 'japon' },
  { slug: 'infiniti', name: 'Infiniti', nationality: 'japon' },
  { slug: 'daihatsu', name: 'Daihatsu', nationality: 'japon' },

  { slug: 'hyundai', name: 'Hyundai', nationality: 'corea' },
  { slug: 'kia', name: 'Kia', nationality: 'corea' },
  { slug: 'ssangyong', name: 'SsangYong (KGM)', nationality: 'corea' },
  { slug: 'genesis', name: 'Genesis', nationality: 'corea' },

  { slug: 'chery', name: 'Chery', nationality: 'china' },
  { slug: 'changan', name: 'Changan', nationality: 'china' },
  { slug: 'great-wall', name: 'Great Wall', nationality: 'china' },
  { slug: 'haval', name: 'Haval', nationality: 'china' },
  { slug: 'jac', name: 'JAC', nationality: 'china' },
  { slug: 'mg', name: 'MG', nationality: 'china', note: 'Origen británico, hoy de SAIC (China)' },
  { slug: 'geely', name: 'Geely', nationality: 'china' },
  { slug: 'byd', name: 'BYD', nationality: 'china' },
  { slug: 'dfsk', name: 'DFSK', nationality: 'china' },
  { slug: 'maxus', name: 'Maxus', nationality: 'china' },
  { slug: 'jmc', name: 'JMC', nationality: 'china' },
  { slug: 'foton', name: 'Foton', nationality: 'china' },
  { slug: 'baic', name: 'BAIC', nationality: 'china' },
  { slug: 'dongfeng', name: 'Dongfeng', nationality: 'china' },
  { slug: 'gac', name: 'GAC', nationality: 'china' },
  { slug: 'jetour', name: 'Jetour', nationality: 'china' },

  { slug: 'chevrolet', name: 'Chevrolet', nationality: 'eeuu' },
  { slug: 'ford', name: 'Ford', nationality: 'eeuu' },
  { slug: 'jeep', name: 'Jeep', nationality: 'eeuu' },
  { slug: 'dodge', name: 'Dodge', nationality: 'eeuu' },
  { slug: 'ram', name: 'RAM', nationality: 'eeuu' },
  { slug: 'chrysler', name: 'Chrysler', nationality: 'eeuu' },
  { slug: 'cadillac', name: 'Cadillac', nationality: 'eeuu' },
  { slug: 'tesla', name: 'Tesla', nationality: 'eeuu' },

  { slug: 'volkswagen', name: 'Volkswagen', nationality: 'alemania' },
  { slug: 'mercedes-benz', name: 'Mercedes-Benz', nationality: 'alemania' },
  { slug: 'bmw', name: 'BMW', nationality: 'alemania' },
  { slug: 'audi', name: 'Audi', nationality: 'alemania' },
  { slug: 'porsche', name: 'Porsche', nationality: 'alemania' },
  { slug: 'opel', name: 'Opel', nationality: 'alemania' },

  { slug: 'peugeot', name: 'Peugeot', nationality: 'francia' },
  { slug: 'renault', name: 'Renault', nationality: 'francia' },
  { slug: 'citroen', name: 'Citroën', nationality: 'francia' },
  { slug: 'ds', name: 'DS', nationality: 'francia' },

  { slug: 'fiat', name: 'Fiat', nationality: 'italia' },
  { slug: 'alfa-romeo', name: 'Alfa Romeo', nationality: 'italia' },
  { slug: 'iveco', name: 'Iveco', nationality: 'italia' },
  { slug: 'maserati', name: 'Maserati', nationality: 'italia' },

  { slug: 'land-rover', name: 'Land Rover', nationality: 'reino-unido' },
  { slug: 'jaguar', name: 'Jaguar', nationality: 'reino-unido' },
  { slug: 'mini', name: 'MINI', nationality: 'reino-unido' },

  { slug: 'volvo', name: 'Volvo', nationality: 'suecia' },
  { slug: 'scania', name: 'Scania', nationality: 'suecia' },

  { slug: 'seat', name: 'SEAT', nationality: 'espana' },
  { slug: 'cupra', name: 'Cupra', nationality: 'espana' },

  { slug: 'skoda', name: 'Škoda', nationality: 'chequia' },

  { slug: 'mahindra', name: 'Mahindra', nationality: 'india' },
  { slug: 'tata', name: 'Tata', nationality: 'india' },
]

export const brandBySlug = (slug: string) => brands.find((b) => b.slug === slug)
export const nationalityById = (id: string) => nationalities.find((n) => n.id === id)
export const brandsOf = (nationalityId: string) =>
  brands.filter((b) => b.nationality === nationalityId)

// Refreshes src/data/offers.json by asking every registered source for each part's offers.
// Run with: npm run update-prices
import { readFile, writeFile } from 'node:fs/promises'
import demo from './sources/demo.mjs'

const sources = [demo]

const dataDir = new URL('../src/data/', import.meta.url)
const readJson = async (name) => JSON.parse(await readFile(new URL(name, dataDir), 'utf8'))

const parts = await readJson('parts.json')
const stores = await readJson('stores.json')
const now = new Date()

const offers = []
for (const source of sources) {
  for (const part of parts) {
    try {
      offers.push(...(await source.fetchOffers({ part, stores, now })))
    } catch (err) {
      console.error(`[${source.id}] ${part.id}: ${err.message}`)
    }
  }
}

await writeFile(new URL('offers.json', dataDir), JSON.stringify(offers, null, 2) + '\n')
console.log(`${offers.length} ofertas actualizadas para ${parts.length} repuestos`)

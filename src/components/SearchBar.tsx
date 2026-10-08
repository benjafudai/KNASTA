import { useState, type FormEvent } from 'react'
import { useNavigate, useSearchParams } from 'react-router-dom'

export default function SearchBar() {
  const [params] = useSearchParams()
  const [q, setQ] = useState(params.get('q') ?? '')
  const navigate = useNavigate()

  const submit = (e: FormEvent) => {
    e.preventDefault()
    const next = new URLSearchParams(params)
    if (q.trim()) next.set('q', q.trim())
    else next.delete('q')
    navigate(`/buscar?${next}`)
  }

  return (
    <form className="searchbar" onSubmit={submit} role="search">
      <input
        value={q}
        onChange={(e) => setQ(e.target.value)}
        placeholder="Repuesto, código, marca o modelo"
        aria-label="Buscar repuestos"
      />
      <button type="submit">Buscar</button>
    </form>
  )
}

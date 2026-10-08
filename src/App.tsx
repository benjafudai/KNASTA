import { Link, Route, Routes } from 'react-router-dom'
import SearchBar from './components/SearchBar'
import Home from './pages/Home'
import NationalityPage from './pages/NationalityPage'
import BrandPage from './pages/BrandPage'
import SearchPage from './pages/SearchPage'
import PartPage from './pages/PartPage'

export default function App() {
  return (
    <>
      <header className="topbar">
        <div className="container topbar-inner">
          <Link to="/" className="logo">
            KNASTA <span>de Repuestos</span>
          </Link>
          <SearchBar />
        </div>
      </header>
      <main className="container">
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/nacionalidad/:id" element={<NationalityPage />} />
          <Route path="/marca/:slug" element={<BrandPage />} />
          <Route path="/buscar" element={<SearchPage />} />
          <Route path="/repuesto/:id" element={<PartPage />} />
          <Route path="*" element={<p className="empty">Página no encontrada.</p>} />
        </Routes>
      </main>
      <footer className="container footer">
        Precios de demostración. Las tiendas reales se conectan en <code>scripts/sources</code>.
      </footer>
    </>
  )
}

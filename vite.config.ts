import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vite.dev/config/
export default defineConfig({
  // Relative base so the build works from any folder (e.g. GitHub Pages under /KNASTA/).
  base: './',
  plugins: [react()],
})

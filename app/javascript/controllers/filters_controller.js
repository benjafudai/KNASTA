import { Controller } from "@hotwired/stimulus"

// Search filters: open on wide screens (collapsed on phones so results show first)
// and re-run the search as soon as a filter changes.
export default class extends Controller {
  static targets = [ "model" ]

  connect() {
    if (window.matchMedia("(min-width: 721px)").matches) this.element.open = true
  }

  submit(event) {
    if (event.target.name === "marca" && this.hasModelTarget) this.modelTarget.value = ""
    event.target.form.requestSubmit()
  }
}

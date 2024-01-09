import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="round"
export default class extends Controller {
  connect() {
    this.element.textContent = "Hello RRRR22223232444!"
  }
}

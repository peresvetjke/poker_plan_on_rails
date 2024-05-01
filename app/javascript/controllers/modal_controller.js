import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.modal = this.element
  }

  close(_event) {
    this.hideModal();
  }

  hideModal() {
    this.modal.classList.remove('is-active');
  }
}

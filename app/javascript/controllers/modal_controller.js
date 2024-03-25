import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.modal = this.element
    // this.displayModal();
  }

  close(event) {
    this.hideModal();
  }

  hideModal() {
    this.modal.classList.remove('is-active');
  }
}

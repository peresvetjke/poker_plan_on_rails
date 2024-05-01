import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const activeButton = this.element.querySelector('.active')

    if (activeButton) {
      console.log(activeButton)
      activeButton.classList.add('is-underlined')
      activeButton.classList.add('has-text-weight-bold')
    }
  }
}

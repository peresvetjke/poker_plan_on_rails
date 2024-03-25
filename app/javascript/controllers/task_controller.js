import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["action"]

  hideActions(e) {
    this.actionTargets.forEach((element) => this.hideAction(element));
  }

  showActions(e) {
    this.actionTargets.forEach((element) => this.showAction(element));
  }

  hideAction(element) {
    element.classList.add('is-hidden');
  }

  showAction(element) {
    element.classList.remove('is-hidden');
  }
}

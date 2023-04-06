import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['name', 'region']

  search(event) {
    event.preventDefault()
    location.pathname = `summoners/${this.regionTarget.value.toLowerCase()}/${this.nameTarget.value}`
  }
}

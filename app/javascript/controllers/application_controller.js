import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect () {
    this.initializeTooltips()
    this.initializePopovers()
  }

  initializeTooltips () {
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-te-toggle="tooltip"]'));
    tooltipTriggerList.map((tooltipTriggerEl) => te.Tooltip.getOrCreateInstance(tooltipTriggerEl, { sanitize: false }));
  }

  initializePopovers () {
    const popoverTriggerList = [].slice.call(document.querySelectorAll('[data-te-toggle="popover"]'));
    popoverTriggerList.map((popoverTriggerEl) => te.Popover.getOrCreateInstance(popoverTriggerEl, { sanitize: false }));
  }
}

import { Controller } from '@hotwired/stimulus'
import * as te from 'tw-elements'
import { Collapse, initTE } from 'tw-elements';

export default class extends Controller {
  connect () {
    this.initializeTooltips()
    this.initializePopovers()
    this.initializeCollapse()
  }

  initializeTooltips () {
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-te-toggle="tooltip"]'));
    tooltipTriggerList.map((tooltipTriggerEl) => te.Tooltip.getOrCreateInstance(tooltipTriggerEl, { sanitize: false }));
  }

  initializePopovers () {
    const popoverTriggerList = [].slice.call(document.querySelectorAll('[data-te-toggle="popover"]'));
    popoverTriggerList.map((popoverTriggerEl) => te.Popover.getOrCreateInstance(popoverTriggerEl, { sanitize: false }));
  }

  initializeCollapse () {
    initTE({ Collapse });
  }
}

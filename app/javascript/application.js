// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import '@hotwired/turbo-rails'
import 'controllers'

te.Tooltip.Default.allowList['lol-uikit-tooltipped-keyword'] = ['key']

const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-te-toggle="tooltip"]'));
tooltipTriggerList.map((tooltipTriggerEl) => new te.Tooltip(tooltipTriggerEl));

const popoverTriggerList = [].slice.call(document.querySelectorAll('[data-te-toggle="popover"]'));
popoverTriggerList.map((popoverTriggerEl) => new te.Popover(popoverTriggerEl));

/* eslint no-console:0 */
import 'babel-polyfill' // ES6 for browsers like IE

import 'assets'
import 'jquery-ujs' // Rails goodies

// Expose jQuery to developers
import jQuery from 'jquery'
window.jQuery = window.$ = jQuery

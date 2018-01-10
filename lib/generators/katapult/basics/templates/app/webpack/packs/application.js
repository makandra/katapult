/* eslint no-console:0 */
import 'babel-polyfill' // ES6 for browsers like IE

import 'unpoly/dist/unpoly'
import 'unpoly/dist/unpoly-bootstrap3'
import 'jquery-ujs' // Rails goodies

import 'assets'

// Expose jQuery to developers
import jQuery from 'jquery'
window.$ = jQuery
window.jQuery = jQuery

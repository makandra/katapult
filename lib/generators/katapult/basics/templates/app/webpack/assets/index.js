// This file will be processed when the directory gets imported

// Javascript
let webpackContext = require.context('./javascripts', true, /\.js$/)
for(let key of webpackContext.keys()) { webpackContext(key) }

// Images
require.context('./images', true, /\.(?:png|jpg|gif|ico|svg)$/)

// Styles
import './stylesheets/custom_bootstrap'
import './stylesheets/theme'

require.context('./stylesheets/blocks', true, /\.sass$/)

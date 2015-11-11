React = require 'react'
ReactDOM = require 'react-dom'
Immutable = require 'immutable'

window.React = React
window.Immutable = Immutable
Morearty  = require 'morearty'

{Application, Context} = require './app'

Bootstrap = Context.bootstrap Application

ReactDOM.render <Bootstrap />, document.getElementById 'application'



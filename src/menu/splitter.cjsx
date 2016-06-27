React = require 'react'

module.exports = React.createClass
  getDefaultProps: ->
    word: ""
    className: ""

  shouldComponentUpdate: (nextProps, nextState)->
    nextProps.className isnt @props.className or nextProps.word isnt @props.word
    return true

  render: ->
    <div className = {@props.className}>
      {@props.word.split('').map (symbol, i)-><span key = {i}>{symbol}</span>}
    </div>
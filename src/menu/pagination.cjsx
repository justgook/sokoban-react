React = require 'react'
classNames = require 'classnames/bind'
styles = require('./pagination.css')
cx = classNames.bind styles

Button = ({selected = false})->
  <a className = {cx "button", "selected": selected}></a>


module.exports = ({total = 5, current = 1})->
  <div className = {cx "container"}>
    {for i in [1..total]
        <Button key = {i} selected = {i is current} />
    }
  </div>

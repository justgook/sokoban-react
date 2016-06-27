React = require 'react'
classNames = require 'classnames/bind'
menuCx = classNames.bind require './menu.css'
succeededCx = classNames.bind require './succeeded.css'
Star = require "./star.cjsx"
Splitter = require "./splitter.cjsx"

module.exports = ->
  <div className={menuCx "menu"} >
    <Splitter word = "Succeeded" className = {succeededCx "succeeded"} />
    <div className = {succeededCx "stars"}>
      <Star score = {true} />
      <Star score = {true} />
      <Star score = {true} />
    </div>
  </div>

React = require 'react'
classNames = require 'classnames/bind'
styles = require './star.css'
cx = classNames.bind styles

module.exports = ({score = false})->
  <div className = { cx "star-five", score: score}></div>
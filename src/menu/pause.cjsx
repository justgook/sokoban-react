React = require 'react'
classNames = require 'classnames/bind'
cx = classNames.bind require './pause.css'
# cxMenu = classNames.bind require './menu.css'
# cx = classNames.bind require './button.css'

module.exports = ->
  <nav className={cx "index"} >
    <a className={cx "button", "green"} href="#"><span className = {cx "text"}>RESUME</span></a>
    <a className={cx "button"} href="#"><span className = {cx "text"}>RESTART</span></a>
    <a className={cx "button"} href="#"><span className = {cx "text"}>QUIT</span></a>
  </nav>
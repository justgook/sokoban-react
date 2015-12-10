React = require 'react'
classNames = require 'classnames/bind'
styles = require './menu.css'
cx = classNames.bind styles

module.exports = ->
  <section className = { cx "container"}>
    <nav className={cx "menu"} >
      <a className={cx "button", "default", "green"} href="#"><span className = {cx "text"}>RESUME</span></a>
      <a className={cx "button", "default"} href="#"><span className = {cx "text"}>RESTART</span></a>
      <a className={cx "button", "default"} href="#"><span className = {cx "text"}>QUIT</span></a>
    </nav>
  </section>
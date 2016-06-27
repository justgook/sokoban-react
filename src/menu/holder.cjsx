React = require 'react'
ReactCSSTransitionGroup = require 'react-addons-css-transition-group'

classNames = require 'classnames/bind'
cx = classNames.bind require './overlay.css'


Succeeded = require './succeeded.cjsx'
Pause = require './pause.cjsx'
Levels = require './levels.cjsx'

module.exports = (props)->
  <ReactCSSTransitionGroup
    className = {cx "overlay"}
    transitionName = {cx "animation"}
    transitionEnterTimeout={~~ cx "--transitionEnterTimeout"}
    transitionLeaveTimeout={~~ cx "--transitionLeaveTimeout"}
    transitionAppear={true}
    transitionAppearTimeout={~~ cx "--transitionAppearTimeout"}>
    {props.children}
  </ReactCSSTransitionGroup>
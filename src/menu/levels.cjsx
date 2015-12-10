merge = (xs...)->
  if xs?.length>0
    tap {}, (m)-> m[k]=v for k,v of x for x in xs
tap = (o, fn)-> fn(o); o


React = require 'react'
Morearty  = require 'morearty'
classNames = require 'classnames/bind'
styles = merge require('./menu.css'), require('./levels.css')
cx = classNames.bind styles

Star = require "./star.cjsx"
Pagination = require './pagination.cjsx'

module.exports = React.createClass
  displayName: 'levels'

  mixins: [Morearty.Mixin]
  click: (i, e)->
    e.preventDefault()
    e.stopPropagation()
    bindings = @getDefaultBinding()
    #TODO find better solution
    @props.setMap bindings.get("#{i}.map")

  render: ->
    bindings = @getDefaultBinding()
    levels = bindings.get()
    <section className = { cx "container"}>
      <div className={cx "menu", "complete"} >
        {for i in [1..levels.size]
          <a className = {cx "button", "level"} key = {i} onClick = {@click.bind @, i - 1}>
            <span className = {cx "text"}>{i}</span>
            <span className = {cx "star-holder"}>
              <Star score = {false} /><Star score = {false} /><Star score = {false} />
            </span>
          </a>
        }

      </div>

    </section>
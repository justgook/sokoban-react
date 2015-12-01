
###
http://sokobano.de/wiki/index.php?title=Level_format
+-----------------------+-----------+------------+
|     Level element     | Character | ASCII Code |
+-----------------------+-----------+------------+
|          Wall         |     #     |    0x23    |
+-----------------------+-----------+------------+
|         Player        |     @     |    0x40    |
+-----------------------+-----------+------------+
| Player on goal square |     +     |    0x2b    |
+-----------------------+-----------+------------+
|          Box          |     $     |    0x24    |
+-----------------------+-----------+------------+
|   Box on goal square  |     *     |    0x2a    |
+-----------------------+-----------+------------+
|      Goal square      |     .     |    0x2e    |
+-----------------------+-----------+------------+
|         Floor         |  (Space)  |    0x20    |
+-----------------------+-----------+------------+
http://www.tablesgenerator.com/text_tables
###


React = require 'react'
Morearty  = require 'morearty'


classNames = require 'classnames/bind'
styles = require './boxes.css'
cx = classNames.bind styles

tileStyle =
  width: "20px"
  height: "20px"
  display: "inline-block"
  #background: "#ccc"
  margin: 3

Tile = React.createClass
  displayName: 'MapRowTile'
  mixins: [Morearty.Mixin]
  render: ->
    bindings = @getDefaultBinding()
    t = bindings.get()
    <div className={
      cx "cube",
        "box": t is "$"
        "wall": t is "#"
        "player": t is "@"
        "goal": t is "."
        "player-on-goal": t is "+"
        "box-on-goal": t is "*"
    }></div>
    # <span style={tileStyle}> {bindings.get().replace("-","")} </span>

Row = React.createClass
  displayName: 'MapRow'
  mixins: [Morearty.Mixin]
  render: ->
    bindings = @getDefaultBinding()
    tiles = bindings.get()
    renderTile = (tile, index)->
      itemBinding = bindings.sub(index)
      <Tile key={index} binding={itemBinding} />

    <div>{ tiles.map(renderTile).toArray()}</div>

module.exports = React.createClass
  displayName: 'Map'
  mixins: [Morearty.Mixin]
  render: ->
    bindings = @getDefaultBinding()
    lastDirection = this.getBinding('lastMove')?.get() or "d"
    player = this.getBinding('player').get().toJS()
    offsetX = this.getBinding('size').get(0)
    offsetY = this.getBinding('size').get(1)
    rows = bindings.get()
    # console.log bindings.sub(0).get()
    renderTile = (t, index)->
      <div className={
        cx "cube",
          "box": t is "$"
          "wall": t is "#"
          "player": t is "@"
          "goal": t is "."
          "player-on-goal": t is "+"
          "box-on-goal": t is "*"
        }></div>
      # <Tile key={index} binding={itemBinding} />

    renderRow = (row, index)->
      itemBinding = bindings.sub(index)
      tiles = itemBinding.get()
      tiles.map(renderTile).toArray()
      #   <Row key={index} binding={itemBinding} />
    width = 3 * bindings.sub(0).get().count()
    height = 3 * rows.count()
    marginLeft = -player.x * 3 - 3
    marginTop = -player.y * 3 - 3
    # console.log marginLeft, marginTop
    <section className={cx "perspective", lastDirection.toLowerCase()} style={
        width:"#{width}em"
        height: "#{height}em"
        marginLeft: "#{offsetX / 2}px"
        marginTop: "#{offsetY / 2}px"
        transform: "rotateX(45deg) rotateZ(45deg) translate(#{marginLeft}em, #{marginTop}em)"
      }>
        { rows.map(renderRow).toArray() }

    </section>
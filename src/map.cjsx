
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

cx = require 'classnames'

styleNode = require './boxes.css'

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
    <section>
      <div className={cx "perspective", lastDirection.toLowerCase()} style={
        width:"#{width}em"
        height: "#{height}em"
        marginLeft: "-#{width/2 + 3}em"
        marginTop: "-#{height/2 + 3}em"
      }>
        { rows.map(renderRow).toArray() }
      </div>

    </section>
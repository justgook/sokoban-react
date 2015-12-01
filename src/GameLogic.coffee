mapDecode = require './map-decode.coffee'

module.exports = class
  constructor: (mapString)->
    mapData = mapDecode mapString
    @player = mapData.player
    @complite = mapData.complite
    @map = mapData.map

  canMoveBox: (direction, boxX, boxY)->
    switch direction
      when "LEFT"
        @map[boxY][boxX - 1] not in ["#","*","$"]
      when "UP"
        @map[boxY - 1][boxX] not in ["#","*","$"]
      when "RIGHT"
        @map[boxY][boxX + 1] not in ["#","*","$"]
      when "DOWN"
        @map[boxY + 1][boxX] not in ["#","*","$"]

  moveBox: (direction, boxX, boxY)->
    if @map[boxY][boxX] is "*"
      @complite--

    typeOfBox = (y, x)=> #type of new box - onSpot or onFloor
      if @map[y][x] is "."
        @complite++
        "*"
      else
        "$"

    switch direction
      when "LEFT"
        @map[boxY][boxX - 1] = typeOfBox boxY, boxX - 1
      when "UP"
        @map[boxY - 1][boxX] = typeOfBox boxY - 1, boxX
      when "RIGHT"
        @map[boxY][boxX + 1] = typeOfBox boxY, boxX + 1
      when "DOWN"
        @map[boxY + 1][boxX] = typeOfBox boxY + 1, boxX

  movePlayer: (x, y)->
    typeOfBox = (x,y)=> #type of new box - onSpot or onFloor
      if @map[y][x] in [".", "*"] then "+" else "@"
    newpos = x:x, y:y
    @map[@player.y][@player.x] = if @map[@player.y][@player.x] is "+" then "." else "-"
    @player = newpos

    @map[newpos.y][newpos.x] = typeOfBox newpos.x, newpos.y

  updateMap: (direction)->
    newpos = x: @player.x, y: @player.y
    switch direction
      when "LEFT"
        newpos.x = @player.x - 1
      when "UP"
        newpos.y = @player.y - 1
      when "RIGHT"
        newpos.x = @player.x + 1
      when "DOWN"
        newpos.y = @player.y + 1

    switch @map[newpos.y][newpos.x]
      # when "@"
      when " ", "-", "."
        @movePlayer newpos.x, newpos.y
        direction[0].toLowerCase()
      when "#"
        console.log "wall"
        false
      when "$", "*"
        if @canMoveBox direction, newpos.x, newpos.y
          @moveBox direction, newpos.x, newpos.y
          @movePlayer newpos.x, newpos.y
          direction[0].toUpperCase()
        else
          false


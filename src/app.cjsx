classNames = require 'classnames/bind'
styles = require './layout.css'
cx = classNames.bind styles


React = require 'react'
Morearty  = require 'morearty'
{fromJS} = require 'immutable'

Keybinding = require 'react-keybinding'

# Rules = require './rules'
Map = require './map'

Pause = require './menu/pause.cjsx'
Levels = require './menu/levels.cjsx'





#http://www.onlinespiele-sammlung.de/sokoban/sokobangames/nx3d/

# window.RLE = require './tools/rle'

# TESTMAP = "7#|#.@-#-#|#$*-$-#|#3-$-#|#-2.2-#|#2-*2-#|7#"

# console.log TESTMAP = RLE.encode """
# -      XXXXX
#  XXXXXXX   XX
# XX X @XX ** X
# X    *      X
# X  *  XXX   X
# XXX XXXXX*XXX
# X *  XXX ..X
# X * * * ...X
# X    XXX...X
# X ** X X...X
# X  XXX XXXXX
# XXXX
# """.split(' ').join('-').split("\n").join("|").replace(/X/gi,"#").replace(/\*/gi, "$")


GameLogic = require './GameLogic'

exports.Context = Morearty.createContext
  initialState:
    levels: require "./map-list.json"
    pause: no
    map: [] #TODO move it to application
    moves: []
    player: x:0, y:0
    size: [720, 400] #size in pixels

exports.Application = React.createClass

  displayName: 'Application'

  mixins: [Morearty.Mixin, Keybinding]

  keybindingsPlatformAgnostic: true

  keybindings:
    "arrow-left": "LEFT"
    "arrow-up": "UP"
    "arrow-right": "RIGHT"
    "arrow-down": "DOWN"
    "esc": ->
      binding = @getDefaultBinding()
      binding.set "pause", yes
      console.log "dsadasdsa"

  keybinding: (e, direction)->
    e.preventDefault()
    @move direction

  move: (direction)->
    if value = @gameLogic.updateMap direction
      binding = @getDefaultBinding()
      map = binding.sub "map"
      moves = binding.sub "moves"
      player =
      binding.sub("player").update (player)=>
        player.mergeDeep @gameLogic.player
      moves.update (moves)-> moves.push value
      map.update (map)=>
        map.mergeDeep @gameLogic.map

  setMap: (mapString)->
    binding = @getDefaultBinding()
    @gameLogic = new GameLogic mapString
    binding.sub("player").update (player)=>
      player.mergeDeep @gameLogic.player
    binding.update "map", (map)=>
      newMap = fromJS @gameLogic.map
      map.setSize(newMap.size).mergeDeep newMap

  componentWillMount: ->
    #@setMap @getDefaultBinding().sub("levels.0").get("map")

  componentDidMount: ->

  onFocus: ->
    console.log "focus"

  onBlur: ->
    console.log "blur"

  render: ->
    binding = @getDefaultBinding()
    activeMap = binding.sub("map").get().size #Find Better way
    if activeMap
      mapBinding = default: binding.sub "map", lastMove: null
      movesJs = binding.sub("moves").toJS()
      if (movesLastIndex = movesJs.length - 1) >= 0
        mapBinding.lastMove = binding.sub("moves.#{movesLastIndex}")
      mapBinding.player = binding.sub "player"
      mapBinding.size = binding.sub "size"

    # console.log @gameLogic.player
    #style={width:"#{binding.sub("size.0").get()}px", height:"#{binding.sub("size.1").get()}px"}
    <div onFocus = {@onFocus} onBlur = {@onBlur} className={cx "wrapper"} tabIndex = "-1">
      {if activeMap
        <header>
          <div className = {cx "moves"}>
            moves <span className = {cx "count"}>{movesJs.length}</span>
          </div>
        </header>
        <Map binding = {mapBinding} />
      else
        <Levels binding = {default: binding.sub("levels")} setMap={@setMap} />
      }
      {if binding.get "pause" then <Pause />}

    </div>

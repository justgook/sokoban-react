classNames = require 'classnames/bind'
styles = require './layout.css'
cx = classNames.bind styles


React = require 'react'
Morearty  = require 'morearty'

{fromJS} = require 'immutable'

# Rules = require './rules'
Map = require './map'
Keybinding = require 'react-keybinding'


#http://www.onlinespiele-sammlung.de/sokoban/sokobangames/nx3d/

window.RLE = require './tools/rle'
TESTMAP = "7#|#.@-#-#|#$*-$-#|#3-$-#|#-2.2-#|#2-*2-#|7#"

console.log TESTMAP = RLE.encode """
-      XXXXX
 XXXXXXX   XX
XX X @XX ** X
X    *      X
X  *  XXX   X
XXX XXXXX*XXX
X *  XXX ..X
X * * * ...X
X    XXX...X
X ** X X...X
X  XXX XXXXX
XXXX
""".split(' ').join('-').split("\n").join("|").replace(/X/gi,"#").replace(/\*/gi, "$")


GameLogic = require './GameLogic'

exports.Context = Morearty.createContext
  initialState:
    map: [] #TODO move it to application
    moves: []
    player: x:0, y:0
    size: [500, 600] #size in pixels

exports.Application = React.createClass

  displayName: 'Application'

  mixins: [Morearty.Mixin, Keybinding]

  keybindingsPlatformAgnostic: true

  keybindings:
    "arrow-left": "LEFT"
    "arrow-up": "UP"
    "arrow-right": "RIGHT"
    "arrow-down": "DOWN"

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

    mapList = [
      "4-5#|4-#3-#|4-#$2-#|2-3#2-$3#|2-#2-$2-$-#|3#-#-3#-#5-6#|#3-#-3#-7#2-2.#|#-$2-$13-2.#|5#-4#-#@4#2-2.#|4-#6-3#2-6#|4-8#"
      "12#|#2.2-#5-3#|#2.2-#-$2-$2-#|#2.2-#$4#2-#|#2.4-@-2#2-#|#2.2-#-#2-$-2#|6#-2#$-$-#|2-#-$2-$-$-$-#|2-#4-#5-#|2-12#"
      "8-8#|8-#5-@#|8-#-$#$-2#|8-#-$2-$#|8-2#$-$-#|9#-$-#-3#|#4.2-2#-$2-$2-#|2#3.4-$2-$3-#|#4.2-10#|8#"
      "14-8#|14-#2-4.#|3-12#2-4.#|3-#4-#2-$-$3-4.#|3-#-3$#$2-$-#2-4.#|3-#2-$5-$-#2-4.#|3-#-2$-#$-$-$8#|4#2-$-#5-#|#3-#-9#|#4-$2-2#|#-2$#2$-@#|#3-#3-2#|9#"
      "8-5#|8-#3-5#|8-#-#$2#2-#|8-#5-$-#|9#-3#3-#|#4.2-2#-$2-$3#|#4.4-$-2$-2#|#4.2-2#$2-$-@#|9#2-$2-2#|8-#-$-$2-#|8-3#-2#-#|10-#4-#|10-6#"
      "6#2-3#|#2.2-#-2#@2#|#2.2-3#3-#|#2.5-2$-#|#2.2-#-#-$-#|#2.3#-#-$-#|4#-$-#$2-#|3-#2-$#-$-#|3-#-$2-$2-#|3-#2-2#3-#|3-9#"
      "7-5#|-7#3-2#|2#-#-@2#-2$-#|#4-$6-#|#2-$2-3#3-#|3#-5#$3#|#-$2-3#-2.#|#-$-$-$-3.#|#4-3#3.#|#-2$-#-#3.#|#2-3#-5#|4#"
    ]
    @setMap mapList[2]

  render: ->
    binding = @getDefaultBinding()
    mapBinding = default: binding.sub "map", lastMove: null
    movesJs = binding.sub("moves").toJS()
    if (movesLastIndex = movesJs.length - 1) >= 0
      mapBinding.lastMove = binding.sub("moves.#{movesLastIndex}")
    mapBinding.player = binding.sub "player"
    mapBinding.size = binding.sub "size"
    # console.log @gameLogic.player
    <div className={cx "wrapper"} style={width:"#{binding.sub("size.0").get()}px", height:"#{binding.sub("size.1").get()}px"}>
      <header>
        <div className={cx "moves"}>
          moves <span className={cx "count"}>{movesJs.length}</span>
        </div>
      </header>
      <Map binding={mapBinding} />
    </div>

(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
/*!
  Copyright (c) 2015 Jed Watson.
  Licensed under the MIT License (MIT), see
  http://jedwatson.github.io/classnames
*/
/* global define */

(function () {
	'use strict';

	var hasOwn = {}.hasOwnProperty;

	function classNames () {
		var classes = '';

		for (var i = 0; i < arguments.length; i++) {
			var arg = arguments[i];
			if (!arg) continue;

			var argType = typeof arg;

			if (argType === 'string' || argType === 'number') {
				classes += ' ' + (this && this[arg] || arg);
			} else if (Array.isArray(arg)) {
				classes += ' ' + classNames.apply(this, arg);
			} else if (argType === 'object') {
				for (var key in arg) {
					if (hasOwn.call(arg, key) && arg[key]) {
						classes += ' ' + (this && this[key] || key);
					}
				}
			}
		}

		return classes.substr(1);
	}

	if (typeof module !== 'undefined' && module.exports) {
		module.exports = classNames;
	} else if (typeof define === 'function' && typeof define.amd === 'object' && define.amd) {
		// register as 'classnames', consistent with npm package name
		define('classnames', [], function () {
			return classNames;
		});
	} else {
		window.classNames = classNames;
	}
}());

},{}],2:[function(require,module,exports){
var mapDecode;

mapDecode = require('./map-decode.coffee');

module.exports = (function() {
  function _Class(mapString) {
    var mapData;
    mapData = mapDecode(mapString);
    this.player = mapData.player;
    this.complite = mapData.complite;
    this.map = mapData.map;
  }

  _Class.prototype.canMoveBox = function(direction, boxX, boxY) {
    var ref, ref1, ref2, ref3;
    switch (direction) {
      case "LEFT":
        return (ref = this.map[boxY][boxX - 1]) !== "#" && ref !== "*" && ref !== "$";
      case "UP":
        return (ref1 = this.map[boxY - 1][boxX]) !== "#" && ref1 !== "*" && ref1 !== "$";
      case "RIGHT":
        return (ref2 = this.map[boxY][boxX + 1]) !== "#" && ref2 !== "*" && ref2 !== "$";
      case "DOWN":
        return (ref3 = this.map[boxY + 1][boxX]) !== "#" && ref3 !== "*" && ref3 !== "$";
    }
  };

  _Class.prototype.moveBox = function(direction, boxX, boxY) {
    var typeOfBox;
    if (this.map[boxY][boxX] === "*") {
      this.complite--;
    }
    typeOfBox = (function(_this) {
      return function(y, x) {
        if (_this.map[y][x] === ".") {
          _this.complite++;
          return "*";
        } else {
          return "$";
        }
      };
    })(this);
    switch (direction) {
      case "LEFT":
        return this.map[boxY][boxX - 1] = typeOfBox(boxY, boxX - 1);
      case "UP":
        return this.map[boxY - 1][boxX] = typeOfBox(boxY - 1, boxX);
      case "RIGHT":
        return this.map[boxY][boxX + 1] = typeOfBox(boxY, boxX + 1);
      case "DOWN":
        return this.map[boxY + 1][boxX] = typeOfBox(boxY + 1, boxX);
    }
  };

  _Class.prototype.movePlayer = function(x, y) {
    var newpos, typeOfBox;
    typeOfBox = (function(_this) {
      return function(x, y) {
        var ref;
        if ((ref = _this.map[y][x]) === "." || ref === "*") {
          return "+";
        } else {
          return "@";
        }
      };
    })(this);
    newpos = {
      x: x,
      y: y
    };
    this.map[this.player.y][this.player.x] = this.map[this.player.y][this.player.x] === "+" ? "." : "-";
    this.player = newpos;
    return this.map[newpos.y][newpos.x] = typeOfBox(newpos.x, newpos.y);
  };

  _Class.prototype.updateMap = function(direction) {
    var newpos;
    newpos = {
      x: this.player.x,
      y: this.player.y
    };
    switch (direction) {
      case "LEFT":
        newpos.x = this.player.x - 1;
        break;
      case "UP":
        newpos.y = this.player.y - 1;
        break;
      case "RIGHT":
        newpos.x = this.player.x + 1;
        break;
      case "DOWN":
        newpos.y = this.player.y + 1;
    }
    switch (this.map[newpos.y][newpos.x]) {
      case " ":
      case "-":
      case ".":
        this.movePlayer(newpos.x, newpos.y);
        return direction[0].toLowerCase();
      case "#":
        console.log("wall");
        return false;
      case "$":
      case "*":
        if (this.canMoveBox(direction, newpos.x, newpos.y)) {
          this.moveBox(direction, newpos.x, newpos.y);
          this.movePlayer(newpos.x, newpos.y);
          return direction[0].toUpperCase();
        } else {
          return false;
        }
    }
  };

  return _Class;

})();


},{"./map-decode.coffee":7}],3:[function(require,module,exports){
var GameLogic, Keybinding, Levels, Map, MenuHolder, Morearty, React, classNames, cx, fromJS, styles;

classNames = require('classnames/bind');

styles = require('./layout.css');

cx = classNames.bind(styles);

React = require('react');

Morearty = require('morearty');

fromJS = require('immutable').fromJS;

Keybinding = require('react-keybinding');

Map = require('./map');

MenuHolder = require('./menu/holder.cjsx');

Levels = require('./menu/levels.cjsx');

GameLogic = require('./GameLogic');

exports.Context = Morearty.createContext({
  initialState: {
    'levels-list': require("./map-list.json"),
    curentLevel: {
      map: {},
      moves: [],
      time: 0,
      boxes: 0,
      boxesOnGoal: 0,
      player: {
        x: 0,
        y: 0
      },
      pause: false
    },
    pause: false,
    map: [],
    moves: [],
    player: {
      x: 0,
      y: 0
    },
    size: [720, 400]
  }
});

exports.Application = React.createClass({
  displayName: 'Application',
  mixins: [Morearty.Mixin, Keybinding],
  keybindingsPlatformAgnostic: true,
  keybindings: {
    "arrow-left": "LEFT",
    "arrow-up": "UP",
    "arrow-right": "RIGHT",
    "arrow-down": "DOWN",
    "esc": function() {
      var binding;
      binding = this.getDefaultBinding();
      binding.set("pause", !binding.get("pause"));
      return console.log("dsadasdsa");
    }
  },
  keybinding: function(e, direction) {
    e.preventDefault();
    return this.move(direction);
  },
  move: function(direction) {
    var binding, map, moves, player, value;
    if (value = this.gameLogic.updateMap(direction)) {
      binding = this.getDefaultBinding();
      map = binding.sub("map");
      moves = binding.sub("moves");
      player = binding.sub("player").update((function(_this) {
        return function(player) {
          return player.mergeDeep(_this.gameLogic.player);
        };
      })(this));
      moves.update(function(moves) {
        return moves.push(value);
      });
      return map.update((function(_this) {
        return function(map) {
          return map.mergeDeep(_this.gameLogic.map);
        };
      })(this));
    }
  },
  setMap: function(mapString) {
    var binding;
    binding = this.getDefaultBinding();
    this.gameLogic = new GameLogic(mapString);
    binding.sub("player").update((function(_this) {
      return function(player) {
        return player.mergeDeep(_this.gameLogic.player);
      };
    })(this));
    return binding.update("map", (function(_this) {
      return function(map) {
        var newMap;
        newMap = fromJS(_this.gameLogic.map);
        return map.setSize(newMap.size).mergeDeep(newMap);
      };
    })(this));
  },
  componentWillMount: function() {},
  componentDidMount: function() {},
  render: function() {
    var activeMap, binding, mapBinding, movesJs, movesLastIndex;
    binding = this.getDefaultBinding();
    activeMap = binding.sub("map").get().size;
    if (activeMap) {
      mapBinding = {
        "default": binding.sub("map", {
          lastMove: null
        })
      };
      movesJs = binding.sub("moves").toJS();
      if ((movesLastIndex = movesJs.length - 1) >= 0) {
        mapBinding.lastMove = binding.sub("moves." + movesLastIndex);
      }
      mapBinding.player = binding.sub("player");
      mapBinding.size = binding.sub("size");
    }
    return React.createElement("div", {
      "className": cx("wrapper")
    }, (activeMap ? (React.createElement("header", null, React.createElement("div", {
      "className": cx("moves")
    }, "moves ", React.createElement("span", {
      "className": cx("count")
    }, movesJs.length))), React.createElement(Map, {
      "binding": mapBinding
    })) : React.createElement(MenuHolder, null, React.createElement(Levels, {
      "binding": {
        "default": binding.sub("levels-list")
      },
      "setMap": this.setMap
    }))));
  }
});


},{"./GameLogic":2,"./layout.css":6,"./map":9,"./map-list.json":8,"./menu/holder.cjsx":11,"./menu/levels.cjsx":12,"classnames/bind":1,"immutable":undefined,"morearty":undefined,"react":undefined,"react-keybinding":undefined}],4:[function(require,module,exports){

module.exports = {"win":"_win_1bkfx_3","perspective":"_perspective_1bkfx_22","cube":"_cube_1bkfx_32","box":"_box_1bkfx_71","wall":"_wall_1bkfx_71","player":"_player_1bkfx_71","goal":"_goal_1bkfx_71","player-on-goal":"_player-on-goal_1bkfx_71","box-on-goal":"_box-on-goal_1bkfx_71","playDR":"_playDR_1bkfx_1","moveD":"_moveD_1bkfx_1","r":"_r_1bkfx_174","moveR":"_moveR_1bkfx_1","l":"_l_1bkfx_179","playUL":"_playUL_1bkfx_1","moveL":"_moveL_1bkfx_1","u":"_u_1bkfx_185","moveU":"_moveU_1bkfx_1"}
},{}],5:[function(require,module,exports){
var Application, Bootstrap, Context, Immutable, Morearty, React, ReactDOM, ref;

React = require('react');

ReactDOM = require('react-dom');

Immutable = require('immutable');

window.React = React;

window.Immutable = Immutable;

Morearty = require('morearty');

ref = require('./app'), Application = ref.Application, Context = ref.Context;

Bootstrap = Context.bootstrap(Application);

ReactDOM.render(React.createElement(Bootstrap, null), document.getElementById('application'));


},{"./app":3,"immutable":undefined,"morearty":undefined,"react":undefined,"react-dom":undefined}],6:[function(require,module,exports){

module.exports = {"wrapper":"_wrapper_16vnj_74","moves":"_moves_16vnj_103"}
},{}],7:[function(require,module,exports){
var decode, longestLength;

if (String.prototype.repeat == null) {
  String.prototype.repeat = function(count) {
    var pattern, result;
    if (count < 1) {
      return '';
    }
    result = '';
    pattern = this.valueOf();
    while (count > 1) {
      if (count & 1) {
        result += pattern;
      }
      count >>>= 1;
      pattern += pattern;
    }
    return result + pattern;
  };
}

longestLength = function(a) {
  var c, d, i, l;
  c = 0;
  d = 0;
  l = 0;
  i = a.length;
  if (i) {
    while (i--) {
      d = a[i].length;
      if (d > c) {
        l = i;
        c = d;
      }
    }
  }
  return c;
};

decode = function(row) {
  var j, len, part, ref, result;
  result = "";
  ref = row.split(/(\d+.)/);
  for (j = 0, len = ref.length; j < len; j++) {
    part = ref[j];
    if (part !== "") {
      if (!isNaN(part.charAt(0))) {
        result += part[part.length - 1].repeat(part.slice(0, -1));
      } else {
        result += part;
      }
    }
  }
  return result;
};

module.exports = function(mapString) {
  var decoded, result, row;
  result = {
    map: [],
    size: {
      h: 0,
      w: 0
    },
    player: {
      x: 0,
      y: 0
    },
    boxes: [],
    goals: [],
    complite: 0
  };
  decoded = (function() {
    var j, len, ref, results;
    ref = mapString.split("|");
    results = [];
    for (j = 0, len = ref.length; j < len; j++) {
      row = ref[j];
      results.push(decode(row));
    }
    return results;
  })();
  result.size = {
    w: longestLength(decoded),
    h: decoded.length
  };
  result.map = decoded.map(function(row, index, arr) {
    var char, i, j, len;
    for (i = j = 0, len = row.length; j < len; i = ++j) {
      char = row[i];
      switch (char) {
        case "@":
          result.player = {
            x: i,
            y: index
          };
          break;
        case "$":
          result.boxes.push([i, index]);
          break;
        case ".":
          result.goals.push([i, index]);
          break;
        case "+":
          result.player = {
            x: i,
            y: index
          };
          result.goals.push([i, index]);
          break;
        case "*":
          result.complite++;
          result.boxes.push([i, index]);
          result.goals.push([i, index]);
      }
    }
    if (row.length < result.size.w) {
      row += "-".repeat(result.size.w - row.length);
    }
    return row.split("");
  });
  return result;
};


},{}],8:[function(require,module,exports){
module.exports=[
 {"map":"4-5#|4-#3-#|4-#$2-#|2-3#2-$3#|2-#2-$2-$-#|3#-#-3#-#5-6#|#3-#-3#-7#2-2.#|#-$2-$13-2.#|5#-4#-#@4#2-2.#|4-#6-3#2-6#|4-8#"},
  {"map":"12#|#2.2-#5-3#|#2.2-#-$2-$2-#|#2.2-#$4#2-#|#2.4-@-2#2-#|#2.2-#-#2-$-2#|6#-2#$-$-#|2-#-$2-$-$-$-#|2-#4-#5-#|2-12#"},
  {"map":"8-8#|8-#5-@#|8-#-$#$-2#|8-#-$2-$#|8-2#$-$-#|9#-$-#-3#|#4.2-2#-$2-$2-#|2#3.4-$2-$3-#|#4.2-10#|8#"},
  {"map":"14-8#|14-#2-4.#|3-12#2-4.#|3-#4-#2-$-$3-4.#|3-#-3$#$2-$-#2-4.#|3-#2-$5-$-#2-4.#|3-#-2$-#$-$-$8#|4#2-$-#5-#|#3-#-9#|#4-$2-2#|#-2$#2$-@#|#3-#3-2#|9#"},
  {"map":"8-5#|8-#3-5#|8-#-#$2#2-#|8-#5-$-#|9#-3#3-#|#4.2-2#-$2-$3#|#4.4-$-2$-2#|#4.2-2#$2-$-@#|9#2-$2-2#|8-#-$-$2-#|8-3#-2#-#|10-#4-#|10-6#"},
  {"map":"6#2-3#|#2.2-#-2#@2#|#2.2-3#3-#|#2.5-2$-#|#2.2-#-#-$-#|#2.3#-#-$-#|4#-$-#$2-#|3-#2-$#-$-#|3-#-$2-$2-#|3-#2-2#3-#|3-9#"},
  {"map":"7-5#|-7#3-2#|2#-#-@2#-2$-#|#4-$6-#|#2-$2-3#3-#|3#-5#$3#|#-$2-3#-2.#|#-$-$-$-3.#|#4-3#3.#|#-2$-#-#3.#|#2-3#-5#|4#"}
]
},{}],9:[function(require,module,exports){

/*
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
 */
var Morearty, React, Row, Tile, classNames, cx, styles, tileStyle;

React = require('react');

Morearty = require('morearty');

classNames = require('classnames/bind');

styles = require('./boxes.css');

cx = classNames.bind(styles);

tileStyle = {
  width: "20px",
  height: "20px",
  display: "inline-block",
  margin: 3
};

Tile = React.createClass({
  displayName: 'MapRowTile',
  mixins: [Morearty.Mixin],
  render: function() {
    var bindings, t;
    bindings = this.getDefaultBinding();
    t = bindings.get();
    return React.createElement("div", {
      "className": cx("cube", {
        "box": t === "$",
        "wall": t === "#",
        "player": t === "@",
        "goal": t === ".",
        "player-on-goal": t === "+",
        "box-on-goal": t === "*"
      })
    });
  }
});

Row = React.createClass({
  displayName: 'MapRow',
  mixins: [Morearty.Mixin],
  render: function() {
    var bindings, renderTile, tiles;
    bindings = this.getDefaultBinding();
    tiles = bindings.get();
    renderTile = function(tile, index) {
      var itemBinding;
      itemBinding = bindings.sub(index);
      return React.createElement(Tile, {
        "key": index,
        "binding": itemBinding
      });
    };
    return React.createElement("div", null, tiles.map(renderTile).toArray());
  }
});

module.exports = React.createClass({
  displayName: 'Map',
  mixins: [Morearty.Mixin],
  render: function() {
    var bindings, height, lastDirection, marginLeft, marginTop, offsetX, offsetY, player, ref, renderRow, renderTile, rows, width;
    bindings = this.getDefaultBinding();
    lastDirection = ((ref = this.getBinding('lastMove')) != null ? ref.get() : void 0) || "d";
    player = this.getBinding('player').get().toJS();
    offsetX = this.getBinding('size').get(0);
    offsetY = this.getBinding('size').get(1);
    rows = bindings.get();
    renderTile = function(t, index) {
      return React.createElement("div", {
        "className": cx("cube", {
          "box": t === "$",
          "wall": t === "#",
          "player": t === "@",
          "goal": t === ".",
          "player-on-goal": t === "+",
          "box-on-goal": t === "*"
        })
      });
    };
    renderRow = function(row, index) {
      var itemBinding, tiles;
      itemBinding = bindings.sub(index);
      tiles = itemBinding.get();
      return tiles.map(renderTile).toArray();
    };
    width = 3 * bindings.sub(0).get().count();
    height = 3 * rows.count();
    marginLeft = -player.x * 3 - 3;
    marginTop = -player.y * 3 - 3;
    return React.createElement("section", {
      "className": cx("perspective", lastDirection.toLowerCase()),
      "style": {
        width: width + "em",
        height: height + "em",
        marginLeft: (offsetX / 2) + "px",
        marginTop: (offsetY / 2) + "px",
        transform: "rotateX(45deg) rotateZ(45deg) translate(" + marginLeft + "em, " + marginTop + "em)"
      }
    }, rows.map(renderRow).toArray());
  }
});


},{"./boxes.css":4,"classnames/bind":1,"morearty":undefined,"react":undefined}],10:[function(require,module,exports){

module.exports = {"button":"_button_pkab0_1","green":"_green_pkab0_11","text":"_text_pkab0_14"}
},{}],11:[function(require,module,exports){
var Levels, Pause, React, ReactCSSTransitionGroup, Succeeded, classNames, cx;

React = require('react');

ReactCSSTransitionGroup = require('react-addons-css-transition-group');

classNames = require('classnames/bind');

cx = classNames.bind(require('./overlay.css'));

Succeeded = require('./succeeded.cjsx');

Pause = require('./pause.cjsx');

Levels = require('./levels.cjsx');

module.exports = function(props) {
  return React.createElement(ReactCSSTransitionGroup, {
    "className": cx("overlay"),
    "transitionName": cx("animation"),
    "transitionEnterTimeout": ~~cx("--transitionEnterTimeout"),
    "transitionLeaveTimeout": ~~cx("--transitionLeaveTimeout"),
    "transitionAppear": true,
    "transitionAppearTimeout": ~~cx("--transitionAppearTimeout")
  }, props.children);
};


},{"./levels.cjsx":12,"./overlay.css":15,"./pause.cjsx":18,"./succeeded.cjsx":23,"classnames/bind":1,"react":undefined,"react-addons-css-transition-group":undefined}],12:[function(require,module,exports){
var Morearty, Pagination, React, Star, classNames, cx, merge, styles, tap,
  slice = [].slice;

merge = function() {
  var xs;
  xs = 1 <= arguments.length ? slice.call(arguments, 0) : [];
  if ((xs != null ? xs.length : void 0) > 0) {
    return tap({}, function(m) {
      var j, k, len, results, v, x;
      results = [];
      for (j = 0, len = xs.length; j < len; j++) {
        x = xs[j];
        results.push((function() {
          var results1;
          results1 = [];
          for (k in x) {
            v = x[k];
            results1.push(m[k] = v);
          }
          return results1;
        })());
      }
      return results;
    });
  }
};

tap = function(o, fn) {
  fn(o);
  return o;
};

React = require('react');

Morearty = require('morearty');

classNames = require('classnames/bind');

styles = merge(require('./menu.css'), require('./levels.css'));

cx = classNames.bind(styles);

Star = require("./star.cjsx");

Pagination = require('./pagination.cjsx');

module.exports = React.createClass({
  displayName: 'levels',
  mixins: [Morearty.Mixin],
  click: function(i, e) {
    var bindings;
    e.preventDefault();
    e.stopPropagation();
    bindings = this.getDefaultBinding();
    return this.props.setMap(bindings.get(i + ".map"));
  },
  render: function() {
    var bindings, i, levels;
    bindings = this.getDefaultBinding();
    levels = bindings.get();
    return React.createElement("section", {
      "className": cx("container")
    }, React.createElement("div", {
      "className": cx("menu", "complete")
    }, (function() {
      var j, ref, results;
      results = [];
      for (i = j = 1, ref = levels.size; 1 <= ref ? j <= ref : j >= ref; i = 1 <= ref ? ++j : --j) {
        results.push(React.createElement("a", {
          "className": cx("button", "level"),
          "key": i,
          "onClick": this.click.bind(this, i - 1)
        }, React.createElement("span", {
          "className": cx("text")
        }, i), React.createElement("span", {
          "className": cx("star-holder")
        }, React.createElement(Star, {
          "score": false
        }), React.createElement(Star, {
          "score": false
        }), React.createElement(Star, {
          "score": false
        }))));
      }
      return results;
    }).call(this)));
  }
});


},{"./levels.css":13,"./menu.css":14,"./pagination.cjsx":16,"./star.cjsx":21,"classnames/bind":1,"morearty":undefined,"react":undefined}],13:[function(require,module,exports){
require('/home/travis/build/justgook/sokoban-react/src/menu/button.css')
module.exports = {"complete":"_complete_ti1d9_1","button":"_button_ti1d9_6 _button_pkab0_1","level":"_level_ti1d9_9","star-holder":"_star-holder_ti1d9_23"}
},{"/home/travis/build/justgook/sokoban-react/src/menu/button.css":10}],14:[function(require,module,exports){

module.exports = {"menu":"_menu_1g26p_1"}
},{}],15:[function(require,module,exports){

module.exports = {"--transitionEnterTimeout":"500","--transitionLeaveTimeout":"300","--transitionAppearTimeout":"750","overlay":"_overlay_1sedv_1","animation":"_animation_1sedv_57","animation-enter":"_animation-enter_1sedv_61","animation-enter-active":"_animation-enter-active_1sedv_65","animation-leave":"_animation-leave_1sedv_70","animation-leave-active":"_animation-leave-active_1sedv_74","animation-appear":"_animation-appear_1sedv_79","animation-appear-active":"_animation-appear-active_1sedv_83","bounceInDown":"_bounceInDown_1sedv_1"}
},{}],16:[function(require,module,exports){
var Button, React, classNames, cx, styles;

React = require('react');

classNames = require('classnames/bind');

styles = require('./pagination.css');

cx = classNames.bind(styles);

Button = function(arg) {
  var ref, selected;
  selected = (ref = arg.selected) != null ? ref : false;
  return React.createElement("a", {
    "className": cx("button", {
      "selected": selected
    })
  });
};

module.exports = function(arg) {
  var current, i, ref, ref1, total;
  total = (ref = arg.total) != null ? ref : 5, current = (ref1 = arg.current) != null ? ref1 : 1;
  return React.createElement("div", {
    "className": cx("container")
  }, (function() {
    var j, ref2, results;
    results = [];
    for (i = j = 1, ref2 = total; 1 <= ref2 ? j <= ref2 : j >= ref2; i = 1 <= ref2 ? ++j : --j) {
      results.push(React.createElement(Button, {
        "key": i,
        "selected": i === current
      }));
    }
    return results;
  })());
};


},{"./pagination.css":17,"classnames/bind":1,"react":undefined}],17:[function(require,module,exports){

module.exports = {"container":"_container_193dz_1","button":"_button_193dz_4","selected":"_selected_193dz_14"}
},{}],18:[function(require,module,exports){
var React, classNames, cx;

React = require('react');

classNames = require('classnames/bind');

cx = classNames.bind(require('./pause.css'));

module.exports = function() {
  return React.createElement("nav", {
    "className": cx("index")
  }, React.createElement("a", {
    "className": cx("button", "green"),
    "href": "#"
  }, React.createElement("span", {
    "className": cx("text")
  }, "RESUME")), React.createElement("a", {
    "className": cx("button"),
    "href": "#"
  }, React.createElement("span", {
    "className": cx("text")
  }, "RESTART")), React.createElement("a", {
    "className": cx("button"),
    "href": "#"
  }, React.createElement("span", {
    "className": cx("text")
  }, "QUIT")));
};


},{"./pause.css":19,"classnames/bind":1,"react":undefined}],19:[function(require,module,exports){
require('/home/travis/build/justgook/sokoban-react/src/menu/menu.css')
require('/home/travis/build/justgook/sokoban-react/src/menu/button.css')
module.exports = {"index":"_index_1u4cx_1 _menu_1g26p_1","button":"_button_1u4cx_5 _button_pkab0_1","green":"_green_1u4cx_13 _green_pkab0_11","text":"_text_1u4cx_17 _text_pkab0_14"}
},{"/home/travis/build/justgook/sokoban-react/src/menu/button.css":10,"/home/travis/build/justgook/sokoban-react/src/menu/menu.css":14}],20:[function(require,module,exports){
var React;

React = require('react');

module.exports = React.createClass({displayName: "exports",
  getDefaultProps: function() {
    return {
      word: "",
      className: ""
    };
  },
  shouldComponentUpdate: function(nextProps, nextState) {
    nextProps.className !== this.props.className || nextProps.word !== this.props.word;
    return true;
  },
  render: function() {
    return React.createElement("div", {
      "className": this.props.className
    }, this.props.word.split('').map(function(symbol, i) {
      return React.createElement("span", {
        "key": i
      }, symbol);
    }));
  }
});


},{"react":undefined}],21:[function(require,module,exports){
var React, classNames, cx, styles;

React = require('react');

classNames = require('classnames/bind');

styles = require('./star.css');

cx = classNames.bind(styles);

module.exports = function(arg) {
  var ref, score;
  score = (ref = arg.score) != null ? ref : false;
  return React.createElement("div", {
    "className": cx("star-five", {
      score: score
    })
  });
};


},{"./star.css":22,"classnames/bind":1,"react":undefined}],22:[function(require,module,exports){

module.exports = {"star-five":"_star-five_1iwlp_1","score":"_score_1iwlp_10"}
},{}],23:[function(require,module,exports){
var React, Splitter, Star, classNames, menuCx, succeededCx;

React = require('react');

classNames = require('classnames/bind');

menuCx = classNames.bind(require('./menu.css'));

succeededCx = classNames.bind(require('./succeeded.css'));

Star = require("./star.cjsx");

Splitter = require("./splitter.cjsx");

module.exports = function() {
  return React.createElement("div", {
    "className": menuCx("menu")
  }, React.createElement(Splitter, {
    "word": "Succeeded",
    "className": succeededCx("succeeded")
  }), React.createElement("div", {
    "className": succeededCx("stars")
  }, React.createElement(Star, {
    "score": true
  }), React.createElement(Star, {
    "score": true
  }), React.createElement(Star, {
    "score": true
  })));
};


},{"./menu.css":14,"./splitter.cjsx":20,"./star.cjsx":21,"./succeeded.css":24,"classnames/bind":1,"react":undefined}],24:[function(require,module,exports){

module.exports = {"stars":"_stars_efomn_1","succeeded":"_succeeded_efomn_7","drop":"_drop_efomn_1"}
},{}]},{},[5]);

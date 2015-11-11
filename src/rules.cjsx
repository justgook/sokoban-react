React = require 'react'

module.exports = ->
  <article>
    <h1> The rules of the game</h1>
    <p>The objective of the Sokoban game is to move objects (usually boxes) to designated locations by pushing them.</p>
    <p>These objects are located inside a room surrounded by walls. The user controls a pusher called "Sokoban" which is said to mean something like "warehouse keeper" in Japanese.</p>
    <p>The pusher can move up, down, left and right, but cannot pass through walls or boxes, and can only push one box at a time (never pull).</p>
    <p>At any time, a square can only be occupied by either a wall, a box, or the pusher.</p>
  </article>
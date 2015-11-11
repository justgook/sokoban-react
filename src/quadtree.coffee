#based on https://github.com/timohausmann/quadtree-js/blob/master/quadtree.js

#need to compare with https://github.com/timohausmann/quadtree-js/blob/hitman/quadtree.js
Quadtree = (bounds, max_objects, max_levels, level) ->
  @max_objects = max_objects or 10
  @max_levels = max_levels or 4
  @level = level or 0
  @bounds = bounds
  @objects = []
  @nodes = []
  return

###
# Split the node into 4 subnodes
###

Quadtree::split = ->
  nextLevel = @level + 1
  subWidth = Math.round(@bounds.width / 2)
  subHeight = Math.round(@bounds.height / 2)
  x = Math.round(@bounds.x)
  y = Math.round(@bounds.y)
  #top right node
  @nodes[0] = new Quadtree({
    x: x + subWidth
    y: y
    width: subWidth
    height: subHeight
  }, @max_objects, @max_levels, nextLevel)
  #top left node
  @nodes[1] = new Quadtree({
    x: x
    y: y
    width: subWidth
    height: subHeight
  }, @max_objects, @max_levels, nextLevel)
  #bottom left node
  @nodes[2] = new Quadtree({
    x: x
    y: y + subHeight
    width: subWidth
    height: subHeight
  }, @max_objects, @max_levels, nextLevel)
  #bottom right node
  @nodes[3] = new Quadtree({
    x: x + subWidth
    y: y + subHeight
    width: subWidth
    height: subHeight
  }, @max_objects, @max_levels, nextLevel)
  return

###
# Determine which node the object belongs to
# @param Object pRect   bounds of the area to be checked, with x, y, width, height
# @return Integer   index of the subnode (0-3), or -1 if pRect cannot completely fit within a subnode and is part of the parent node
###

Quadtree::getIndex = (pRect) ->
  index = -1
  verticalMidpoint = @bounds.x + @bounds.width / 2
  horizontalMidpoint = @bounds.y + @bounds.height / 2
  topQuadrant = pRect.y < horizontalMidpoint and pRect.y + pRect.height < horizontalMidpoint
  bottomQuadrant = pRect.y > horizontalMidpoint
  #pRect can completely fit within the left quadrants
  if pRect.x < verticalMidpoint and pRect.x + pRect.width < verticalMidpoint
    if topQuadrant
      index = 1
    else if bottomQuadrant
      index = 2
    #pRect can completely fit within the right quadrants
  else if pRect.x > verticalMidpoint
    if topQuadrant
      index = 0
    else if bottomQuadrant
      index = 3
  index

###
# Insert the object into the node. If the node
# exceeds the capacity, it will split and add all
# objects to their corresponding subnodes.
# @param Object pRect   bounds of the object to be added, with x, y, width, height
###

Quadtree::insert = (pRect) ->
  i = 0
  index = undefined
  #if we have subnodes ...
  if typeof @nodes[0] != 'undefined'
    index = @getIndex(pRect)
    if index != -1
      @nodes[index].insert pRect
      return
  @objects.push pRect
  if @objects.length > @max_objects and @level < @max_levels
    #split if we don't already have subnodes
    if typeof @nodes[0] == 'undefined'
      @split()
    #add all objects to there corresponding subnodes
    while i < @objects.length
      index = @getIndex(@objects[i])
      if index != -1
        @nodes[index].insert @objects.splice(i, 1)[0]
      else
        i = i + 1
  return

###
# Return all objects that could collide with the given object
# @param Object pRect   bounds of the object to be checked, with x, y, width, height
# @Return Array   array with all detected objects
###

Quadtree::retrieve = (pRect) ->
  index = @getIndex(pRect)
  returnObjects = @objects
  #if we have subnodes ...
  if typeof @nodes[0] != 'undefined'
    #if pRect fits into a subnode ..
    if index != -1
      returnObjects = returnObjects.concat(@nodes[index].retrieve(pRect))
      #if pRect does not fit into a subnode, check it against all subnodes
    else
      i = 0
      while i < @nodes.length
        returnObjects = returnObjects.concat(@nodes[i].retrieve(pRect))
        i = i + 1
  returnObjects

###
# Clear the quadtree
###

Quadtree::clear = ->
  @objects = []
  i = 0
  while i < @nodes.length
    if typeof @nodes[i] != 'undefined'
      @nodes[i].clear()
    i = i + 1
  @nodes = []
  return

module.exports = Quadtree
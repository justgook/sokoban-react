#http://sokobano.de/wiki/index.php?title=Level_format
if not String::repeat?
  String::repeat = (count) ->
    if count < 1
      return ''
    result = ''
    pattern = @valueOf()
    while count > 1
      if count & 1
        result += pattern
      count >>>= 1
      pattern += pattern
    result + pattern

#http://stackoverflow.com/a/10710406
#locations = (substring, string) ->
#  i = -1
#  i while (i = string.indexOf(substring, i + 1)) >= 0


longestLength = (a) ->
  c = 0
  d = 0
  l = 0
  i = a.length
  if i
    while i--
      d = a[i].length
      if d > c
        l = i
        c = d
  c

decode = (row)->
  result = ""
  for part in row.split /(\d+.)/ when part isnt ""
    if !isNaN part.charAt(0) #If is a number
      result += part[part.length - 1].repeat part.slice 0, -1
    else
      result += part
  result

module.exports = (mapString)->
  result =
    map:[]
    size:
      h:0
      w:0
    player:
      x:0
      y:0
    boxes: []
    goals: []
  decoded = (decode row for row in mapString.split "|")
  result.size =
    w: longestLength decoded
    h: decoded.length
  result.map = decoded.map (row, index, arr)->
    for char, i in row
      switch char
        when "@"
         result.player = x: i, y: index
        when "$"
          result.boxes.push [i, index]
        when "."
          result.goals.push [i, index]
        when "+"
          result.player = x: i, y: index
          result.goals.push [i, index]
        when "*"
          result.boxes.push [i, index]
          result.goals.push [i, index]

    if row.length < result.size.w
      row += "-".repeat result.size.w - row.length
    row.split ""
  result




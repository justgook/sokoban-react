 module.exports = do ->

  decode = (input) ->
    repeat = /^\d+/.exec(input)
    character = undefined
    if repeat == null
      return ''
    repeat = repeat[0]
    character = input[repeat.length]
    new Array(+repeat + 1).join(character) + decode(input.substr((repeat + character).length))

  {
    encode: (input) ->
      i = 0
      j = input.length
      output = ''
      lastCharacter = undefined
      currentCharCount = 0
      while i < j
        if typeof lastCharacter == 'undefined'
          lastCharacter = input[i]
          currentCharCount = 1
          ++i
          continue
        if input[i] != lastCharacter
          output += "#{if currentCharCount > 1 then currentCharCount else ""}#{lastCharacter}"
          lastCharacter = input[i]
          currentCharCount = 1
          ++i
          continue
        currentCharCount++
        ++i
      output + currentCharCount + lastCharacter
    decode: decode
  }
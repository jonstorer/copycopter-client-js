class CopyCopter
  constructor: (options) ->
    @[key] = value for key, value of options

    throw 'please provide the apiKey' unless @apiKey?
    throw 'please provide the host'   unless @host?

  t: (key, options) ->
    load(key)

  load = -> console.log 'here'

module.exports = CopyCopter

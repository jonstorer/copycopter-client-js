CopyCopter = do ->
  create = (options) ->
    # private

    # state variables

    translations = {}
    host         = undefined
    apiKey       = undefined
    callbacks    = []
    isLoaded     = false

    drain = ->
      cb() while cb = callbacks.shift()

    lookup = (key, scope) ->
      scope = ['en'].concat key.split('.')
      msg = translations
      msg = msg?[key] for key in scope
      msg if msg?

    interpolate = (msg, scope) ->
      for key, value of scope
        regex = new RegExp("(.*)(?:\%|\{){#{key}}}?(.*)",'i')
        msg = msg.replace(regex, "$1#{value}$2") if regex.test(msg)
      msg

    url = ->
      "//#{host}/api/v2/projects/#{apiKey}/published_blurbs?format=hierarchy"

    load = ->
      request = jQuery.ajax({ url: url(), cache: true, dataType: 'jsonp' })
      request.success (data) -> translations = data
      request.success        -> isLoaded = true
      request.always drain

    setOptions = (options) ->
      throw 'please provide the apiKey' unless apiKey = options.apiKey
      throw 'please provide the host'   unless host   = options.host

    #public

    exports = {}

    exports.t = exports.translate = (key, options) ->
      defaultValue = options.defaultValue
      delete options.defaultValue
      interpolate((lookup(key) || defaultValue), options)

    exports.onLoaded = (callback) ->
      if isLoaded
        callback()
      else
        callbacks.push callback

    setOptions(options)
    load()

    exports

  return (options) ->
    create(options)

# Global
window?.CopyCopter = CopyCopter
# npm module
module?.exports = CopyCopter

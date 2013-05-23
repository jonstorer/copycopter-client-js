CopyCopter = do ->
  create = (options) ->

    # state variables
    throw 'please provide the host'   unless host   = options.host
    throw 'please provide the apiKey' unless apiKey = options.apiKey

    url          = "//#{host}/api/v2/projects/#{apiKey}/published_blurbs?format=hierarchy"
    isLoaded     = false
    translations = {}
    callbacks    = []

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

    do ->
      request = jQuery.ajax({ url: url, cache: true, dataType: 'jsonp' })
      request.success (data) -> translations = data
      request.success        -> isLoaded = true
      request.always drain

    #public

    exports = {}

    exports.translate = (key, options) ->
      defaultValue = options.defaultValue
      delete options.defaultValue
      interpolate((lookup(key) || defaultValue), options)

    exports.onTranslationsLoaded = (callback) ->
      if isLoaded
        callback()
      else
        callbacks.push callback

    # shortcut
    exports.t = exports.translate

    exports

  (options) -> create(options)

# Global
window?.CopyCopter = CopyCopter
# npm module
module?.exports = CopyCopter

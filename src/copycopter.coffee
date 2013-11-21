CopyCopter = do ->
  create = (options) ->

    # state variables
    host          = options.host
    apiKey        = options.apiKey
    uploadMissing = options.uploadMissing || false

    unless apiKey?
      throw 'please provide the apiKey'

    getUrl       = "#{ if host? then '//' + host else '' }/api/v2/projects/#{apiKey}/published_blurbs"
    postUrl      = "#{ if host? then '//' + host else '' }/api/v2/projects/#{apiKey}/draft_blurbs"
    isLoaded     = false
    translations = {}
    callbacks    = []

    drain = ->
      cb() while cb = callbacks.shift()

    uploadTranslation = (key, defaultValue) ->
      data = {}
      data["en.#{key}"] = defaultValue
      jQuery.ajax({ url: postUrl, dataType: 'jsonp', data: data })

    hasTranslation = (key) -> !!lookup(key)

    lookup = (key, scope) -> translations["en.#{key}"]

    interpolate = (msg, scope) ->
      for key, value of scope
        regex = new RegExp("(.*)(?:\%|\{){#{key}}}?(.*)",'i')
        msg = msg.replace(regex, "$1#{value}$2") if regex.test(msg)
      msg

    translate = (key, options = {}) ->
      defaultValue = options.defaultValue
      delete options.defaultValue
      uploadTranslation(key, defaultValue) if uploadMissing && !hasTranslation(key)
      interpolate((lookup(key) || defaultValue), options)

    onTranslationsLoaded = (callback) ->
      if isLoaded then callback() else callbacks.push callback

    do ->
      request = jQuery.ajax({ url: getUrl, cache: true, dataType: 'jsonp' })
      request.success (data) -> translations = data
      request.success        -> isLoaded = true
      request.success        -> drain()

    #public

    exports = {}

    exports.translate            = translate
    exports.onTranslationsLoaded = onTranslationsLoaded
    exports.hasTranslation       = hasTranslation
    # shortcut
    exports.t = translate

    exports

  (options) -> create(options)

# Global
window?.CopyCopter = CopyCopter
# npm module
module?.exports = CopyCopter

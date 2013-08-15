CopyCopter = do ->
  create = (options) ->

    # state variables
    throw 'please provide the host'   unless host   = options.host
    throw 'please provide the apiKey' unless apiKey = options.apiKey

    getUrl       = "//#{host}/api/v2/projects/#{apiKey}/published_blurbs?format=hierarchy"
    postUrl      = "//#{host}/api/v2/projects/#{apiKey}/draft_blurbs"
    isLoaded     = false
    translations = {}
    callbacks    = []

    newTranslations = {}

    setTimeout ->
      if Object.keys(newTranslations).length
        uploadNewTranslations()
    , 5000

    drain = ->
      cb() while cb = callbacks.shift()

    queueTranslation = (key, defaultValue) ->
      newTranslations["en.#{key}"] = defaultValue

    uploadNewTranslations = ->
      jQuery.ajax({
        url:       postUrl
        dataType:  'jsonp'
        data:      jQuery.extend({ _method: 'POST' }, newTranslations)
      }).success ->
        newTranslations = {}

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

    translate = (key, options = {}) ->
      defaultValue = options.defaultValue
      delete options.defaultValue
      queueTranslation(key, defaultValue) unless hasTranslation(key)
      interpolate((lookup(key) || defaultValue), options)

    onTranslationsLoaded = (callback) ->
      if isLoaded then callback() else callbacks.push callback

    hasTranslation = (key) -> !!lookup(key)

    do ->
      request = jQuery.ajax({ url: getUrl, cache: true, dataType: 'jsonp' })
      request.success (data) -> translations = data
      request.success        -> isLoaded = true
      request.always drain

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

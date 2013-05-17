class CopyCopter
  constructor: (options) ->
    @[key] = value for key, value of options

    throw 'please provide the apiKey' unless @apiKey?
    throw 'please provide the host'   unless @host?

    @translations = { }
    @load()

  translate: (key, options) ->

    defaultValue = options.defaultValue
    delete options.defaultValue

    msg = @lookup(key) || defaultValue
    @interpolate(msg, options)

  # private

  lookup: (key, scope) ->
    scope = ['en'].concat key.split('.')
    message = @translations
    message = ( message[key] || {} ) for key in scope
    message if message.length

  interpolate: (msg, scope) ->
    for key, value of scope
      for regex in [ new RegExp("(.*)%{#{key}}(.*)"), new RegExp("(.*){{#{key}}}(.*)") ]
        msg = msg.replace(regex, "$1#{value}$2") if regex.test(msg)
    msg

  url: ->
    "//#{@host}/api/v2/projects/#{@apiKey}/published_blurbs?format=hierarchy"

  load: ->
    request = jQuery.ajax({
      url:      @url()
      cache:    true
      dataType: 'jsonp'
    })
    request.always         => @isLoaded     = true
    request.success (data) => @translations = data


# Global
@CopyCopter = CopyCopter

# npm module
module?.exports = CopyCopter

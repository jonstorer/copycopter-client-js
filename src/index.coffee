class CopyCopter
  constructor: (options) ->
    @[key] = value for key, value of options

    throw 'please provide the apiKey' unless @apiKey?
    throw 'please provide the host'   unless @host?

    @isLoaded     = false
    @isLoading    = false
    @translations = { }

  translate: (key, options) ->
    @load() unless @isLoaded

    defaultValue = options.defaultValue
    delete options.defaultValue

    scope = key.split('.')
    scope.unshift('en')

    message = @translations
    for key in scope
      message = message[key] || {}
    msg = if message.length then message else defaultValue

    for key, value of options
      regex = new RegExp("(.*)%{#{key}}(.*)")
      if regex.test(msg)
        msg = msg.replace(regex, "$1#{value}$2")
      regex = new RegExp("(.*){{#{key}}}(.*)")
      if regex.test(msg)
        msg = msg.replace(regex, "$1#{value}$2")

    msg

  # private

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

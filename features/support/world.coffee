Browser   = require 'zombie'
should    = require 'should'
selectors = require './selectors'
root      = require('path').resolve('./test')

process.env.PORT     ||= 4404
process.env.NODE_ENV ||= 'test'

# Zombie options
Browser.debug = true if process.env.DEBUG == 'true'

class World
  constructor: (callback) ->
    @browser = new Browser()

    callback(@)

  selectorFor: (locator, callback = (s) -> s) ->
    for regexp, path of selectors
      if match = locator.match(new RegExp(regexp))
        return path.apply @, match.slice(1).concat [ callback ]

  visit: (path, next) ->
    url = 'file:/' + root + path
    @browser.visit url, (err, browser, status) =>
      @$ = browser.window.$
      next err, browser, status

module.exports.World = World

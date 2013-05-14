module.exports =
  # Helpers

  '^(.*) within (.*)$': (inner, outer, next) ->
    @selectorFor outer, (outerSelector) =>
      @selectorFor inner, (innerSelector) ->
        next "#{outerSelector} #{innerSelector}"

  # Dynamic Selectors

  '^the (.+) link$': (type, n) -> n ".#{type.replace(' ', '')}"

  # Static Selectors

  '^the page$':      (n) -> n 'body'
  '^passing tests$': (n) -> n '.symbolSummary .passed'
  '^failing tests$': (n) -> n '.symbolSummary .failed'

  # Paths

  '^the test page$':  (n) -> n '/index.html'

  # Fall through

  '^(.+)$': (selector, next) ->
    console.log "\n\nNo selector was found for '#{selector}'"
    console.log "Please do not commit code that uses this into master\n"
    next selector

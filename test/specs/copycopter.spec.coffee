describe 'CopyCopter', ->
  beforeEach ->
    @jqXHR = $.Deferred()
    $.extend @jqXHR,
      readyState:            0
      setRequestHeader:      -> @
      getAllResponseHeaders: ->
      getResponseHeader:     ->
      overrideMimeType:      -> @
      abort:                 -> @reject(arguments); @
      success:               @jqXHR.done
      complete:              @jqXHR.done
      error:                 @jqXHR.fail

    sinon.stub(jQuery, 'ajax').returns(@jqXHR)

  afterEach -> jQuery.ajax.restore()

  describe 'when initializing', ->
    beforeEach ->
      @options =
        apiKey: 'key'
        host:   'example.com'

    it 'throws an error without an apiKey', ->
      delete @options.apiKey
      (=> new CopyCopter @options ).should.Throw('please provide the apiKey')

    it 'throws an error without a host', ->
      delete @options.host
      (=> new CopyCopter @options ).should.Throw('please provide the host')

  describe 'fetching the translations from the server', ->
    beforeEach ->
      @copycopter = new CopyCopter({
        apiKey: 'key',
        host:   'example.com'
      })

    it 'fetches translations when it has none', ->
      jQuery.ajax.should.have.been.calledWith({
        url:       '//example.com/api/v2/projects/key/published_blurbs?format=hierarchy'
        cache:     true
        dataType:  'jsonp'
      })

    it 'returns found translations', ->
      @jqXHR.resolve({ en: { step: { one: 'Cut a hole in a box' } } })
      @copycopter.translate('step.one', { defaultValue: 'Cut a whole in the box' }).should.eql 'Cut a hole in a box'

    it 'returns the default translation when not found', ->
      @jqXHR.resolve({ })
      @copycopter.translate('step.one', { defaultValue: 'Cut a hole in the box' }).should.eql 'Cut a hole in the box'

    it 'interpolates %{key}', ->
      @jqXHR.resolve({ en: { step: { one: 'Cut a %{shape} in a box' } } })
      @copycopter.translate('step.one', {
        defaultValue: 'Cut a %{shape} in the box',
        shape: 'cresent'
      }).should.eql 'Cut a cresent in a box'

    it 'interpolates {{key}}', ->
      @jqXHR.resolve({ en: { step: { one: 'Cut a {{shape}} in a box' } } })
      @copycopter.translate('step.one', {
        defaultValue: 'Cut a {{shape}} in the box',
        shape: 'cresent'
      }).should.eql 'Cut a cresent in a box'

    it 'works with many translations', ->
      @jqXHR.resolve({ en: {
        step: {
          one:   'Cut a %{shape} in a box',
          two:   'Put your {{item}} in that box',
          three: "Make her %{action} the %{item}... and that's how you {{verb}} it!"
        }
      } })

      @copycopter.translate('step.one', {
        defaultValue: 'Cut a %{shape} in the box',
        shape: 'hole'
      }).should.eql 'Cut a hole in a box'

      @copycopter.translate('step.two', {
        defaultValue: 'Put your %{item} in that box',
        item: 'junk'
      }).should.eql 'Put your junk in that box'

      @copycopter.translate('step.three', {
        defaultValue: "Make her %{action} the %{item}... and that's how you {{verb}} it!",
        action: 'open',
        item: 'container',
        verb: 'jump'
      }).should.eql "Make her open the container... and that's how you jump it!"

  describe '#onTranslationsLoaded', ->
    beforeEach ->
      @copycopter = new CopyCopter({ apiKey: 'key', host: 'example.com' })
      @callback   = sinon.spy()

    it 'takes a callback and fires the callback when the translations have loaded', ->
      @copycopter.onTranslationsLoaded @callback
      @callback.should.not.have.been.called
      @jqXHR.resolve({ en: {} })
      @callback.should.have.been.calledOnce

    it 'takes a callback and calls the callback if already loaded', ->
      @jqXHR.resolve({ en: {} })
      @copycopter.onTranslationsLoaded @callback
      @callback.should.have.been.calledOnce

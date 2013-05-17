describe 'CopyCopter', ->
  describe 'when initializing', ->
    beforeEach ->
      @options =
        apiKey: 'key'
        host:   'example.com'

    it 'takes an apiKey', ->
      cc = new CopyCopter(@options)
      cc.apiKey.should.equal('key')

    it 'takes a host', ->
      cc = new CopyCopter(@options)
      cc.host.should.equal('example.com')

    it 'throws an error without a host', ->
      @options.host = undefined
      (=> new CopyCopter @options ).should.Throw('please provide the host')

    it 'throws an error without an apiKey', ->
      delete @options.apiKey
      (=> new CopyCopter @options ).should.Throw('please provide the apiKey')

  describe 'fetching the translations from the server', ->
    beforeEach ->
      @copycopter = new CopyCopter({
        apiKey: 'key',
        host:   'example.com'
      })

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
      @copycopter.translate('step.one', { defaultValue: 'Cut a hole in the box' })

    afterEach ->
      jQuery.ajax.restore()

    it 'fetches translations when it has none', ->
      jQuery.ajax.should.have.been.calledWith({
        url:       '//example.com/api/v2/projects/key/published_blurbs?format=hierarchy'
        cache:     true
        dataType:  'jsonp'
      })

    it 'loads the translations in memory', ->
      @jqXHR.resolve({
        en: { step: { one: 'Cut a hole in a box' } }
      })
      @copycopter.translations.en.step.one = 'Cut a hole in a box'

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

describe 'CopyCopter', ->
  describe 'initializing', ->
    beforeEach ->
      @options =
        apiKey: 'key'
        host:   'example.com'

    it 'throws an error if not created with an apiKey', ->
      delete @options.apiKey
      expect(=> new CopyCopter @options).toThrow('please provide the apiKey')

    it 'sets the apiKey on the instance', ->
      @options.apiKey = 'apiKey'
      copycopter = new CopyCopter @options
      copycopter.apiKey == 'apiKey'

    it 'throws an error if not created with a host', ->
      delete @options.host
      expect(=> new CopyCopter @options).toThrow('please provide the host')

    it 'sets the host on the instance', ->
      @options.host = 'example.com'
      copycopter = new CopyCopter @options
      copycopter.host == 'example.com'

  describe 'translating', ->
    beforeEach ->
      @copycopter = new CopyCopter { apiKey: 'key', host: 'example.com' }

    it 'makes an ajax call to the correct url', ->
      @copycopter.t('this', defaultValue: 'that')

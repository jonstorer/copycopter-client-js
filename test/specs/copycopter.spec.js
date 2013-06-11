// Generated by CoffeeScript 1.6.2
(function() {
  describe('CopyCopter', function() {
    beforeEach(function() {
      this.jqXHR = $.Deferred();
      $.extend(this.jqXHR, {
        readyState: 0,
        setRequestHeader: function() {
          return this;
        },
        getAllResponseHeaders: function() {},
        getResponseHeader: function() {},
        overrideMimeType: function() {
          return this;
        },
        abort: function() {
          this.reject(arguments);
          return this;
        },
        success: this.jqXHR.done,
        complete: this.jqXHR.done,
        error: this.jqXHR.fail
      });
      return sinon.stub(jQuery, 'ajax').returns(this.jqXHR);
    });
    afterEach(function() {
      return jQuery.ajax.restore();
    });
    describe('when initializing', function() {
      beforeEach(function() {
        return this.options = {
          apiKey: 'key',
          host: 'example.com'
        };
      });
      it('throws an error without an apiKey', function() {
        var _this = this;

        delete this.options.apiKey;
        return (function() {
          return new CopyCopter(_this.options);
        }).should.Throw('please provide the apiKey');
      });
      return it('throws an error without a host', function() {
        var _this = this;

        delete this.options.host;
        return (function() {
          return new CopyCopter(_this.options);
        }).should.Throw('please provide the host');
      });
    });
    describe('fetching the translations from the server', function() {
      beforeEach(function() {
        return this.copycopter = new CopyCopter({
          apiKey: 'key',
          host: 'example.com'
        });
      });
      it('fetches translations when it has none', function() {
        return jQuery.ajax.should.have.been.calledWith({
          url: '//example.com/api/v2/projects/key/published_blurbs?format=hierarchy',
          cache: true,
          dataType: 'jsonp'
        });
      });
      it('returns found translations', function() {
        this.jqXHR.resolve({
          en: {
            step: {
              one: 'Cut a hole in a box'
            }
          }
        });
        return this.copycopter.translate('step.one', {
          defaultValue: 'Cut a whole in the box'
        }).should.eql('Cut a hole in a box');
      });
      it('returns the default translation when not found', function() {
        this.jqXHR.resolve({});
        return this.copycopter.translate('step.one', {
          defaultValue: 'Cut a hole in the box'
        }).should.eql('Cut a hole in the box');
      });
      it('interpolates %{key}', function() {
        this.jqXHR.resolve({
          en: {
            step: {
              one: 'Cut a %{shape} in a box'
            }
          }
        });
        return this.copycopter.translate('step.one', {
          defaultValue: 'Cut a %{shape} in the box',
          shape: 'cresent'
        }).should.eql('Cut a cresent in a box');
      });
      it('interpolates {{key}}', function() {
        this.jqXHR.resolve({
          en: {
            step: {
              one: 'Cut a {{shape}} in a box'
            }
          }
        });
        return this.copycopter.translate('step.one', {
          defaultValue: 'Cut a {{shape}} in the box',
          shape: 'cresent'
        }).should.eql('Cut a cresent in a box');
      });
      return it('works with many translations', function() {
        this.jqXHR.resolve({
          en: {
            step: {
              one: 'Cut a %{shape} in a box',
              two: 'Put your {{item}} in that box',
              three: "Make her %{action} the %{item}... and that's how you {{verb}} it!"
            }
          }
        });
        this.copycopter.translate('step.one', {
          defaultValue: 'Cut a %{shape} in the box',
          shape: 'hole'
        }).should.eql('Cut a hole in a box');
        this.copycopter.translate('step.two', {
          defaultValue: 'Put your %{item} in that box',
          item: 'junk'
        }).should.eql('Put your junk in that box');
        return this.copycopter.translate('step.three', {
          defaultValue: "Make her %{action} the %{item}... and that's how you {{verb}} it!",
          action: 'open',
          item: 'container',
          verb: 'jump'
        }).should.eql("Make her open the container... and that's how you jump it!");
      });
    });
    describe('#onTranslationsLoaded', function() {
      beforeEach(function() {
        this.copycopter = new CopyCopter({
          apiKey: 'key',
          host: 'example.com'
        });
        return this.callback = sinon.spy();
      });
      it('takes a callback and fires the callback when the translations have loaded', function() {
        this.copycopter.onTranslationsLoaded(this.callback);
        this.callback.should.not.have.been.called;
        this.jqXHR.resolve({
          en: {}
        });
        return this.callback.should.have.been.calledOnce;
      });
      return it('takes a callback and calls the callback if already loaded', function() {
        this.jqXHR.resolve({
          en: {}
        });
        this.copycopter.onTranslationsLoaded(this.callback);
        return this.callback.should.have.been.calledOnce;
      });
    });
    return describe('#hasTranslation', function() {
      beforeEach(function() {
        this.copycopter = new CopyCopter({
          apiKey: 'key',
          host: 'example.com'
        });
        return this.jqXHR.resolve({
          en: {
            step: {
              one: 'Cut a hole in a box'
            }
          }
        });
      });
      it('returns true when the key exists', function() {
        return this.copycopter.hasTranslation('step.one').should.be["true"];
      });
      return it('returns false when the key does not exist', function() {
        return this.copycopter.hasTranslation('step.two').should.be["false"];
      });
    });
  });

}).call(this);

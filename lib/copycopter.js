// Generated by CoffeeScript 1.6.3
(function() {
  var CopyCopter;

  CopyCopter = (function() {
    var create;
    create = function(options) {
      var apiKey, callbacks, drain, exports, getUrl, hasTranslation, host, interpolate, isLoaded, lookup, onTranslationsLoaded, postUrl, translate, translations, uploadMissing, uploadTranslation;
      host = options.host;
      apiKey = options.apiKey;
      uploadMissing = options.uploadMissing || false;
      if (apiKey == null) {
        throw 'please provide the apiKey';
      }
      getUrl = "" + (host != null ? '//' + host : '') + "/api/v2/projects/" + apiKey + "/published_blurbs";
      postUrl = "" + (host != null ? '//' + host : '') + "/api/v2/projects/" + apiKey + "/draft_blurbs/publish";
      isLoaded = false;
      translations = {};
      callbacks = [];
      drain = function() {
        var cb, _results;
        _results = [];
        while (cb = callbacks.shift()) {
          _results.push(cb());
        }
        return _results;
      };
      uploadTranslation = function(key, defaultValue) {
        var data;
        data = {};
        data["en." + key] = defaultValue;
        return jQuery.ajax({
          url: postUrl,
          dataType: 'jsonp',
          data: {
            blurbs: data
          }
        });
      };
      hasTranslation = function(key) {
        return !!lookup(key);
      };
      lookup = function(key, scope) {
        return translations["en." + key];
      };
      interpolate = function(msg, scope) {
        var key, regex, value;
        for (key in scope) {
          value = scope[key];
          regex = new RegExp("(?:\%|\{){" + key + "}}?", 'ig');
          msg = msg.replace(regex, value);
        }
        return msg;
      };
      translate = function(key, options) {
        var defaultValue;
        if (options == null) {
          options = {};
        }
        defaultValue = options.defaultValue;
        delete options.defaultValue;
        if (uploadMissing && !hasTranslation(key)) {
          uploadTranslation(key, defaultValue);
        }
        return interpolate(lookup(key) || defaultValue, options);
      };
      onTranslationsLoaded = function(callback) {
        if (isLoaded) {
          return callback();
        } else {
          return callbacks.push(callback);
        }
      };
      (function() {
        var request;
        request = jQuery.ajax({
          url: getUrl,
          cache: true,
          dataType: 'jsonp'
        });
        request.success(function(data) {
          return translations = data;
        });
        request.success(function() {
          return isLoaded = true;
        });
        return request.success(function() {
          return drain();
        });
      })();
      exports = {};
      exports.translate = translate;
      exports.onTranslationsLoaded = onTranslationsLoaded;
      exports.hasTranslation = hasTranslation;
      exports.t = translate;
      return exports;
    };
    return function(options) {
      return create(options);
    };
  })();

  if (typeof window !== "undefined" && window !== null) {
    window.CopyCopter = CopyCopter;
  }

  if (typeof module !== "undefined" && module !== null) {
    module.exports = CopyCopter;
  }

}).call(this);

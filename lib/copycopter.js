// Generated by CoffeeScript 1.6.2
(function() {
  var CopyCopter;

  CopyCopter = (function() {
    var apiKey, host, interpolate, load, lookup, setOptions, translations, url;

    function CopyCopter(options) {
      setOptions(options);
      load();
    }

    CopyCopter.prototype.translate = function(key, options) {
      var defaultValue;

      defaultValue = options.defaultValue;
      delete options.defaultValue;
      return interpolate(lookup(key) || defaultValue, options);
    };

    translations = {};

    host = void 0;

    apiKey = void 0;

    setOptions = function(options) {
      if (!(apiKey = options.apiKey)) {
        throw 'please provide the apiKey';
      }
      if (!(host = options.host)) {
        throw 'please provide the host';
      }
    };

    lookup = function(key, scope) {
      var msg, _i, _len;

      scope = ['en'].concat(key.split('.'));
      msg = translations;
      for (_i = 0, _len = scope.length; _i < _len; _i++) {
        key = scope[_i];
        msg = msg != null ? msg[key] : void 0;
      }
      if (msg != null) {
        return msg;
      }
    };

    interpolate = function(msg, scope) {
      var key, regex, value;

      for (key in scope) {
        value = scope[key];
        regex = new RegExp("(.*)(?:\%|\{){" + key + "}}?(.*)", 'i');
        if (regex.test(msg)) {
          msg = msg.replace(regex, "$1" + value + "$2");
        }
      }
      return msg;
    };

    url = function() {
      return "//" + host + "/api/v2/projects/" + apiKey + "/published_blurbs?format=hierarchy";
    };

    load = function() {
      var request;

      request = jQuery.ajax({
        url: url(),
        cache: true,
        dataType: 'jsonp'
      });
      return request.success(function(data) {
        return translations = data;
      });
    };

    return CopyCopter;

  })();

  if (typeof window !== "undefined" && window !== null) {
    window.CopyCopter = CopyCopter;
  }

  if (typeof module !== "undefined" && module !== null) {
    module.exports = CopyCopter;
  }

}).call(this);
# copycopter-client-js

CopyCopter is a I18n translation client for the I18n based CMS, [CopyCopter](https://github.com/copycopter/copycopter-server)

CopyCopter can replace your I18n library to allow your translations to be updated without restarting your application

# Install

```zsh
  % npm install copycopter
```

# Use

In your app, require CopyCopter and create a client to your server.

```js
  var CopyCopter = require('copycopter');
  var copycopter = CopyCopter({apiKey: 'key', host: 'copycopter.example.com'})
```
    
In your views, user `copycopter` as you would `I18n`

```js
  copycopter.translate('header.title', defaultValue: 'Welcome to CopyCopter!')
```


## Blocking

CopyCopter does not currently handle asynchronous use. If you attempt to translate before the translations have loaded from the copycopter server, the default will be returned.

To block, do this:

```js
  copycopyer.onLoaded(function(){
    // Everything that needs translations to be loaded.
  });
```


## Gotchas

CopyCopter currently does not do any of the following: (all of these are on the ToDo list)

- only handles `en` as a locale
- does not localize currency, numbers, dates, times
- does not format currency, numbers, dates, times
- does not pluralize words

## ToDos

- Asynchronous loading
- Support Locales

# License

(The MIT License)

Copyright (c) 2013 Jonathon Storer. 

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
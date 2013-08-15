app  = require 'strata'
root = require('path').resolve('..')

app.use(app.commonLogger)
app.use(app.contentType, 'application/json')
app.use(app.contentLength)
app.use(app.file, root, 'example/index.html')
app.run({ port: 7070 })

pg = require('pg')
express = require('express')
log = new (require('log'))()

root = require('./root')

app = express.createServer()

app.configure ->
  app.use express.bodyParser()
  app.use express.methodOverride()

app.configure 'development', ->
    app.use express.errorHandler { dumpExceptions: true, showStack: true }

app.configure 'production', ->
    app.use express.errorHandler()

app.listen 3000, -> 
    log.info "Express server listening on port #{app.address().port} in #{app.settings.env} mode"

conString = "tcp://postgres:postgres@localhost/test"

query = (sql, callback) ->
    pg.connect conString, (err, client) ->
        if err then log.error JSON.stringify(err) else client.query sql, callback

root.process
    log: log
    app: app
    query: query


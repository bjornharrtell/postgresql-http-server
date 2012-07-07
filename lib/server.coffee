# Server implementation

express = require('express')
log = new (require('log'))(if process.env.NODE_ENV is 'development' then 'debug' else 'info')

app = express.createServer()

app.configure ->
  app.use express.bodyParser()
  app.use express.methodOverride()

app.configure 'development', ->
    app.use express.errorHandler { dumpExceptions: true, showStack: true }

app.configure 'production', ->
    app.use express.errorHandler()

start = (argv) ->
    passwordString = if argv.password then ":#{argv.password}" else ""
    connectionString = "tcp://#{argv.user}#{passwordString}@#{argv.dbhost}/#{argv.database}"

    # export for use in resources
    exports.db = require('./db')(log, connectionString)

    log.info "Setting up resources"
    require('./resources/root')(exports)
    require('./resources/db')(exports)
    require('./resources/database')(exports)
    require('./resources/schemas')(exports)
    require('./resources/schema')(exports)
    require('./resources/tables')(exports)
    require('./resources/table')(exports)
    require('./resources/rows')(exports)
    require('./resources/row')(exports)
        
    app.listen argv.port, -> 
        log.info "Listening on port #{app.address().port} in #{app.settings.env} mode"

# exports for use in resources
exports.log = log
exports.app = app
exports.start = start

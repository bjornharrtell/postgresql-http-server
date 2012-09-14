express = require 'express'
log = new (require('log'))(if process.env.NODE_ENV is 'development' then 'debug' else 'info')
app = express.createServer()
resources = require './resources'

app.configure ->
  app.use express.bodyParser()
  app.use express.methodOverride()

app.configure 'development', ->
    app.use express.errorHandler { dumpExceptions: true, showStack: true }

app.configure 'production', ->
    app.use express.errorHandler()

start = (argv) ->
    passwordString = if argv.password then ":#{argv.password}" else ""
    connectionString = "tcp://#{argv.user}#{passwordString}@#{argv.dbhost}"
    log.info "Using connection string #{connectionString}"

    exports.db = require('./db')(log, connectionString, argv.database)
    
    if argv.cors
        log.info "Enable Cross-origin Resource Sharing" 
        app.options '/*', (req,res,next) ->
            res.header 'Access-Control-Allow-Origin', '*'
            res.header 'Access-Control-Allow-Headers', 'origin, x-requested-with, content-type'
            next()

        app.get '/*', (req,res,next) ->
            res.header 'Access-Control-Allow-Origin', '*'
            res.header 'Access-Control-Allow-Headers', 'origin, x-requested-with, content-type'
            next()
        
        app.post '/*', (req,res,next) ->
            res.header 'Access-Control-Allow-Origin', '*'
            res.header 'Access-Control-Allow-Headers', 'origin, x-requested-with, content-type'
            next()

    log.info "Setting up resources"
    resources.root exports
    resources.db exports
    resources.database exports, argv.raw
    resources.schemas exports
    resources.schema exports
    resources.tables exports
    resources.table exports
    resources.rows exports
    resources.row exports
        
    app.listen argv.port, -> 
        log.info "Listening on port #{app.address().port} in #{app.settings.env} mode"

exports.log = log
exports.app = app
exports.start = start

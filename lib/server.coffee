express = require 'express'
bodyParser = require 'body-parser'
errorhandler = require 'errorhandler'
methodOverride = require 'method-override'
#auth = require './basic_auth'
argv = require('optimist').argv

class Server
  constructor: (app) ->
    @log = new (require('log'))(if process.env.NODE_ENV is 'development' then 'debug' else 'info')
    
    if not app?
      app = express()
      app.use bodyParser()
      app.use methodOverride()
      
      if process.env.NODE_ENV == 'development'
        app.use errorhandler { dumpExceptions: true, showStack: true }
      
      if process.env.NODE_ENV == 'production'
        app.use errorhandler()
      #if argv.secure 
        #app.use auth.secureAPI
    @app = app
  
  # Initialize 
  # @param [Object] options
  # @option options [String] dbhost PostgreSQL host
  # @option options [String] dbport PostgreSQL port
  # @option options [String] database PostgreSQL database
  # @option options [String] user PostgreSQL username
  # @option options [String] password PostgreSQL password
  setup: (options) ->
    passwordString = if options.password then ":#{options.password}" else ""
    connectionString = "tcp://#{options.user}#{passwordString}@#{options.dbhost}"
    @log.info "Using connection string #{connectionString}"

    @db = require('./db')(@log, connectionString, options.database)
    
    if options.cors
      @log.info "Enable Cross-origin Resource Sharing" 
      @app.options '/*', (req,res,next) ->
        res.header 'Access-Control-Allow-Origin', '*'
        res.header 'Access-Control-Allow-Headers', 'origin, x-requested-with, content-type'
        next()

      @app.get '/*', (req,res,next) ->
        res.header 'Access-Control-Allow-Origin', '*'
        res.header 'Access-Control-Allow-Headers', 'origin, x-requested-with, content-type'
        next()
      
      @app.post '/*', (req,res,next) ->
        res.header 'Access-Control-Allow-Origin', '*'
        res.header 'Access-Control-Allow-Headers', 'origin, x-requested-with, content-type'
        next()

    @log.info "Setting up resources"
    resources = require './resources'
    resources.root @
    resources.db @
    resources.database @, options.raw
    resources.schemas @
    resources.schema @
    resources.tables @
    resources.table @
    resources.rows @
    resources.row @
    resources.columns @
  
  start: (argv) ->
    @setup argv
    @app.listen argv.port, => 
      @log.info "Listening on port #{argv.port} in #{@app.settings.env} mode"

module.exports = Server
module.exports = (server) ->
    log = server.log
    db = server.db
    app = server.app
    
    log.debug "Setting up schema resource"
    
    app.get '/db/:databaseName/schemas/:schemaName', (req, res) ->
        res.send
            type: 'schema'
            children: ['tables']

module.exports = (server) ->
    log = server.log
    db = server.db
    app = server.app
    
    log.debug "Setting up database resource"
    
    app.get '/db/:databaseName', (req, res) ->
        res.send
            children: ['schemas']

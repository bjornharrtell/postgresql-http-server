module.exports = (server, raw) ->
    log = server.log
    db = server.db
    app = server.app
    
    log.debug "Setting up database resource"
    
    app.get '/db/:databaseName', (req, res) ->
        res.send
            type: 'database'
            children: ['schemas']
            
    if raw
        app.post '/db/:databaseName', (req, res) ->
            console.log 'RAW SQL POST: ' + req.body.sql
            db.query
                sql: req.body.sql
                res: res
                database: req.params.databaseName
                callback: (result) ->
                    res.send result.rows

module.exports = (server) ->
    log = server.log
    db = server.db
    app = server.app
    
    log.debug "Setting up databases resource"
    
    app.get '/db', (req, res) ->
        sql = "SELECT * FROM pg_database"
        db.query sql, res, (result) ->
            databaseNames = (row.datname for row in result.rows)
            res.send
                children: databaseNames

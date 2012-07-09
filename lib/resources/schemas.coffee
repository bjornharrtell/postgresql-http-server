module.exports = (server) ->
    log = server.log
    db = server.db
    app = server.app

    log.debug "Setting up schemas resource"
    
    app.get '/db/:databaseName/schemas', (req, res) ->
        sql = "SELECT * FROM information_schema.schemata WHERE catalog_name LIKE '#{req.params.databaseName}'"
        db.query 
            sql: sql
            res: res
            database: req.params.databaseName
            callback: (result) ->
                res.send
                    children: (row.schema_name for row in result.rows)

module.exports = (server) ->
    log = server.log
    db = server.db
    app = server.app

    log.debug "Setting up schemas resource"
    
    app.get '/db/:databaseName/schemas', (req, res) ->
        sql = "SELECT * FROM information_schema.schemata WHERE catalog_name = $1"
        db.query 
            sql: sql
            res: res
            values: [req.params.databaseName]
            database: req.params.databaseName
            callback: (result) ->
                res.send
                    type: 'schemas'
                    children: (row.schema_name for row in result.rows)

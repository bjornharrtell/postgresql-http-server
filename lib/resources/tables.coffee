module.exports = (server) ->
    log = server.log
    db = server.db
    app = server.app
    
    log.debug "Setting up tables resource"
    
    app.get '/db/:databaseName/schemas/:schemaName/tables', (req, res) ->
        sql = "SELECT * FROM pg_tables WHERE schemaname = $1"
        db.query 
            sql: sql
            res: res
            values: [req.params.schemaName]
            database: req.params.databaseName
            callback: (result) ->
                res.send
                    type: 'tables'
                    children: (row.tablename for row in result.rows)

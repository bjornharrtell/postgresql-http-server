module.exports = (server) ->
    log = server.log
    db = server.db
    app = server.app
    
    log.debug "Setting up columns resource"
    
    path = '/db/:databaseName/schemas/:schemaName/tables/:tableName/columns'

    app.get path, (req, res) ->
        sql = "SELECT * FROM information_schema.columns WHERE table_catalog = $1 AND table_name = $2"
        db.query 
            sql: sql
            res: res
            values: [req.params.databaseName, req.params.tableName]
            database: req.params.databaseName
            callback: (result) ->
                columns = {}
                for column in result.rows
                    columns[column.column_name] =
                        type: column.udt_name
                res.send columns


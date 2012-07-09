module.exports = (server) ->
    log = server.log
    db = server.db
    app = server.app
    
    log.debug "Setting up row resource"
    
    path = '/db/:databaseName/schemas/:schemaName/tables/:tableName/rows/:id'
    
    app.get path, (req, res) ->
        sql = "SELECT * FROM #{req.params.tableName} WHERE id = #{req.params.id}"
        db.query 
            sql: sql
            res: res
            database: req.params.databaseName
            callback: (result) ->
                if result.rows.length is 1 then res.send result.rows[0] else res.send 404


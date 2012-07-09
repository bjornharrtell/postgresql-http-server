module.exports = (server) ->
    log = server.log
    db = server.db
    app = server.app
    
    log.debug "Setting up row resource"
    
    path = '/db/:databaseName/schemas/:schemaName/tables/:tableName/rows/:id'
    
    app.get path, (req, res) ->
        sql = "SELECT * FROM #{req.params.tableName} WHERE id = $1"
        db.query 
            sql: sql
            res: res
            values: [req.params.id]
            database: req.params.databaseName
            callback: (result) ->
                if result.rows.length is 1 then res.send result.rows[0] else res.send 404

    app.put path, (req, res) ->
        parsedRow = db.parseRow req.body

        db.query
            sql: "UPDATE #{req.params.tableName} SET (#{parsedRow.fields}) = (#{parsedRow.params}) WHERE id = $#{parsedRow.count}"
            values: parsedRow.values.concat req.params.id
            res: res
            count: parsedRow.count
            callback: (result) ->
                res.send 200
                
    app.delete path, (req, res) ->
        sql = "DELETE FROM #{req.params.tableName} WHERE id = $1"
        db.query 
            sql: sql
            res: res
            values: [req.params.id]
            database: req.params.databaseName
            callback: (result) ->
                res.send 200

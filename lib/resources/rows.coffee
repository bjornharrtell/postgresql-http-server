module.exports = (server) ->
    log = server.log
    db = server.db
    app = server.app
    
    log.debug "Setting up rows resource"
    
    path = '/db/:databaseName/schemas/:schemaName/tables/:tableName/rows'

    app.get path, (req, res) ->
        config =
            sql: "SELECT * FROM #{req.params.tableName}"
            values: []
            count: 1
            res: res
            callback: (result) ->
                res.send result.rows
            
        db.parseWhere config, req.query.where
        db.parseLimit config, req.query.limit
        db.parseOffset config, req.query.offset
        
        db.query config
        
    app.post path, (req, res) ->
        parsedRow = parseRow req.body

        sql = "INSERT INTO #{req.params.tableName} (#{parsedRow.fields}) VALUES (#{parsedRow.params}) RETURNING id"
        db.query 
            sql: sql
            res: res
            values: parsedRow.values
            callback: (result) ->
                res.contentType 'application/json'
                id = result.rows[0].id
                id = if typeof id is "string" then "\"#{id}\"" else "#{id}"
                res.send id, 201
     
     app.put path, (req, res) ->
        parsedRow = db.parseRow req.body
        
        config =
            sql: "UPDATE #{req.params.tableName} SET (#{parsedRow.fields}) = (#{parsedRow.params})"
            values: parsedRow.values
            res: res
            count: parsedRow.count
            callback: (result) ->
                res.send 200
            
        db.parseWhere config, req.query.where
        
        db.query config
     
     app.delete path, (req, res) ->
        config =
            res: res
            count: 1
            callback: (result) ->
                res.send 200
                
        if req.query.where
            config.sql = "DELETE FROM #{req.params.tableName}"
            config.values = []
            db.parseWhere config, req.query.where
        else
            config.sql = "TRUNCATE #{req.params.tableName}"
            
        db.query config
        
            

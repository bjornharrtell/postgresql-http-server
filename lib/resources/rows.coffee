lexer = require('sql-parser').lexer

module.exports = (server) ->
    log = server.log
    db = server.db
    app = server.app
    
    log.debug "Setting up rows resource"
    
    path = '/db/:databaseName/schemas/:schemaName/tables/:tableName/rows'
    
    parseWhere = (config, where) -> if where
        config.sql += " WHERE "
        tokens = lexer.tokenize where
        for token in tokens
            if token[0] is 'STRING' or token[0] is 'NUMBER'
                config.values.push token[1]
                config.sql += "$#{config.count}"
                config.count += 1
            else if token[0] is 'CONDITIONAL'
                config.sql += " #{token[1].toUpperCase()} "
            else 
                config.sql += token[1]
    
    parseLimit = (config, limit) -> if limit
        config.sql += " LIMIT $#{config.count}"
        config.values.push parseInt limit
        config.count += 1
        
    parseOffset = (config, offset) -> if offset
        config.sql += " OFFSET $#{config.count}"
        config.values.push parseInt offset
        config.count += 1
    
    parseRow = (row) ->
        fields = []
        params = []
        values = []
        count = 1
        for k,v of config.row
            fields.push k
            params.push "$#{count}"
            values.push v
            count += 1
        
        fields: fields.join ','
        params: params.join ','
        values: values.join ','
        count: count
    
    app.get path, (req, res) ->
        config =
            sql: "SELECT * FROM #{req.params.tableName}"
            values: []
            count: 1
            res: res
            callback: (result) ->
                res.send result.rows
            
        parseWhere config, req.query.where
        parseLimit config, req.query.limit
        parseOffset config, req.query.offset
        
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
        parsedRow = parseRow req.body.row
        
        config =
            sql: "UPDATE #{req.params.tableName} SET (#{fields}) = (#{params})"
            values: parsedRow.values
            res: res
            callback: (result) ->
                res.send 200
            
        parseWhere config, req.body.where
        
        db.query config
     
     app.delete path, (req, res) ->
        config =
            callback: (result) ->
                res.send 200
                
        if req.query.where
            config.sql = "DELETE FROM #{req.params.tableName}"
            config.values = []
            parseWhere config, req.query.where
        else
            config.sql = "TRUNCATE #{req.params.tableName}"
            
        db.query config
        
            

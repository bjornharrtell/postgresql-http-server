parseTable = require('./utils').parseTable

module.exports = (server) ->
    log = server.log
    db = server.db
    app = server.app
    
    log.debug "Setting up rows resource"
    
    path = '/db/:databaseName/schemas/:schemaName/tables/:tableName/rows'

    app.get path, (req, res) ->
        table = parseTable req
        config =
            sql: "SELECT * FROM #{table}"
            values: []
            count: 1
            res: res
            database: req.params.databaseName
            callback: (result) ->
                res.send result.rows
            
        db.parseWhere config, req.query.where
        db.parseLimit config, req.query.limit
        db.parseOffset config, req.query.offset
        db.parseOrderBy config, req.query.orderby
        
        db.query config
        
    app.post path, (req, res) ->
        parsedRow = db.parseRow req.body

        table = parseTable req
        sql = "INSERT INTO #{table} (#{parsedRow.fields}) VALUES (#{parsedRow.params}) RETURNING id"
        db.query 
            sql: sql
            res: res
            values: parsedRow.values
            database: req.params.databaseName
            callback: (result) ->
                res.contentType 'application/json'
                id = result.rows[0].id
                id = if typeof id is "string" then "\"#{id}\"" else "#{id}"
                res.send id, 201
     
     app.put path, (req, res) ->
        parsedRow = db.parseRow req.body
        
        table = parseTable req
        config =
            sql: "UPDATE #{table} SET (#{parsedRow.fields}) = (#{parsedRow.params})"
            values: parsedRow.values
            res: res
            count: parsedRow.count
            database: req.params.databaseName
            callback: (result) ->
                res.send 200
            
        db.parseWhere config, req.query.where
        
        db.query config
     
     app.delete path, (req, res) ->
        table = parseTable req
        config =
            res: res
            count: 1
            database: req.params.databaseName
            callback: (result) ->
                res.send 200
        
        if req.query.where
            config.sql = "DELETE FROM #{table}"
            config.values = []
            db.parseWhere config, req.query.where
        else
            config.sql = "TRUNCATE #{table}"
            
        db.query config
        
            

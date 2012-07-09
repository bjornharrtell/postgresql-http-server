lexer = require('sql-parser').lexer

module.exports = (server) ->
    log = server.log
    db = server.db
    app = server.app
    
    log.debug "Setting up rows resource"
    
    path = '/db/:databaseName/schemas/:schemaName/tables/:tableName/rows'
    
    app.get path, (req, res) ->
        sql = "SELECT * FROM #{req.params.tableName}"
        values = []
        count = 1
        if req.query.where
            sql += " WHERE "
            tokens = lexer.tokenize req.query.where
            for token in tokens
                if token[0] is 'STRING' or token[0] is 'NUMBER'
                    values.push token[1]
                    sql += "$#{count} "
                    count += 1
                else
                    sql += "#{token[1]} "
        if req.query.limit
            sql += " LIMIT $#{count}"
            values.push parseInt req.query.limit
            count += 1
        if req.query.offset
            sql += " OFFSET $#{count}"
            values.push parseInt req.query.offset
            count += 1
        db.query 
            sql: sql
            res: res
            values: values
            callback: (result) ->
                res.send result.rows
    
    app.post path, (req, res) ->
        fields = []
        values = []
        for k,v of req.body
            fields.push k
            values.push if typeof v is "string" then "'#{v}'" else v
        fields = fields.join ','
        values = values.join ','
        # TODO: parameterize insert
        sql = "INSERT INTO #{req.params.tableName} (#{fields}) VALUES (#{values}) RETURNING id"
        db.query 
            sql: sql
            res: res
            callback: (result) ->
                res.contentType 'application/json'
                id = result.rows[0].id
                id = if typeof id is "string" then "\"#{id}\"" else "#{id}"
                res.send id, 201

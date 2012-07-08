module.exports = (server) ->
    log = server.log
    db = server.db
    app = server.app
    
    log.debug "Setting up rows resource"
    
    path = '/db/:databaseName/schemas/:schemaName/tables/:tableName/rows'
    
    app.get path, (req, res) ->
        sql = "SELECT * FROM #{req.params.tableName}"
        if req.query.where then sql += " WHERE #{req.query.where}"
        if req.query.limit then sql += " LIMIT #{req.query.limit}"
        if req.query.offset then sql += " OFFSET #{req.query.offset}"
        db.query sql, res, (result) ->
            res.send result.rows
    
    app.post path, (req, res) ->
        fields = []
        values = []
        for k,v of req.body
            fields.push k
            values.push if typeof v is "string" then "'#{v}'" else v
        fields = fields.join ','
        values = values.join ','
        sql = "INSERT INTO #{req.params.tableName} (#{fields}) VALUES (#{values}) RETURNING id"
        db.query sql, res, (result) ->
            res.contentType 'application/json'
            id = result.rows[0].id
            id = if typeof id is "string" then "\"#{id}\"" else "#{id}"
            res.send id, 201

process = (server) ->
    log = server.log
    app = server.app
    
    query = (sql, res, callback) -> 
        server.query sql, (err, result) ->
            if err
                log.error JSON.stringify(err)
                res.send err, 500
            else
                callback result
    
    log.info "Setting up resources"
    
    log.debug "Setting up root resource"
    app.get '/', (req, res) ->
        log.info "Requesting implementation information"
        sql = "SELECT * FROM information_schema.sql_implementation_info WHERE implementation_info_id LIKE '18'"
        query sql, res, (result) ->
            versionName = result.rows[0].character_value
            res.send
                version: null
                version_human: versionName
                description: "PostgreSQL #{versionName}"
                children: ['db']
    
    log.debug "Setting up databases resource"
    app.get '/db', (req, res) ->
        log.info "Requesting databases information"
        sql = "SELECT * FROM pg_database"
        query sql, res, (result) ->
            databaseNames = (row.datname for row in result.rows)
            res.send
                children: databaseNames
    
    log.debug "Setting up database resource"
    app.get '/db/:databaseName', (req, res) ->
        res.send
            children: ['schemas']
    
    log.debug "Setting up schemas resource"
    app.get '/db/:databaseName/schemas', (req, res) ->
        databaseName = req.params.databaseName
        log.info "Requesting schemas information for database #{databaseName}"
        sql = "SELECT * FROM information_schema.schemata WHERE catalog_name LIKE '#{databaseName}'"
        query sql, res, (result) ->
            res.send
                children: (row.schema_name for row in result.rows)
    
    log.debug "Setting up schema resource"
    app.get '/db/:databaseName/schemas/:schemaName', (req, res) ->
        res.send
            children: ['tables']
    
    log.debug "Setting up tables resource"
    app.get '/db/:databaseName/schemas/:schemaName/tables', (req, res) ->
        databaseName = req.params.databaseName
        schemaName = req.params.schemaName
        log.info "Requesting tables information for schema #{schemaName}"
        sql = "SELECT * FROM pg_tables WHERE schemaname LIKE '#{schemaName}'"
        query sql, res, (result) ->
            res.send
                children: (row.tablename for row in result.rows)
    
    log.debug "Setting up table resource"
    path = '/db/:databaseName/schemas/:schemaName/tables/:tableName'
    app.get path, (req, res) ->
        sql = "SELECT * FROM #{req.params.tableName}"
        query sql, res, (result) ->
            res.send result.rows
    app.post path, (req, res) ->
        fields = []
        values = []
        for k,v of req.body
            fields.push k
            values.push if typeof v is "string" then "'#{v}'" else v
        fields = fields.join ','
        values = values.join ','
        sql = "insert into #{req.params.tableName} (" + fields + ") VALUES (" + values + ")"
        query sql, res, (result) ->
            res.send 'ok'
    
    log.debug "Setting up row resource"
    path = '/db/:databaseName/schemas/:schemaName/tables/:tableName/:id'
    app.get path, (req, res) ->
        sql = "SELECT * FROM #{req.params.tableName} WHERE id = #{req.params.id}"
        query sql, res, (result) ->
            if result.rows.length is 1 then res.send result.rows[0] else res.send 404

exports.process = process


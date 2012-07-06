process = (server) ->
    log = server.log
    app = server.app
    
    query = (sql, callback) -> 
        server.query sql, (err, result) ->
            if err
                log.error JSON.stringify(err)
                res.send 500
            else
                callback result
    
    log.info "Setting up root resource"
    app.get '/', (req, res) ->
        log.info "Requesting implementation information"
        sql = "select * from information_schema.sql_implementation_info where implementation_info_id LIKE '18'"
        query sql, (result) ->
            versionName = result.rows[0].character_value
            res.send
                version: null
                version_human: versionName
                description: "PostgreSQL #{versionName}"
                children: ['db']
    
    log.info "Setting up databases resource"
    app.get '/db', (req, res) ->
        log.info "Requesting databases information"
        sql = "select * from pg_database"
        query sql, (result) ->
            databaseNames = (row.datname for row in result.rows)
            res.send
                children: databaseNames
    
    log.info "Setting up database resource"
    app.get '/db/:databaseName', (req, res) ->
        res.send
            children: ['schemas']
    
    log.info "Setting up schemas resource"
    app.get '/db/:databaseName/schemas', (req, res) ->
        databaseName = req.params.databaseName
        log.info "Requesting schemas information for database #{databaseName}"
        sql = "select * from information_schema.schemata where catalog_name LIKE '#{databaseName}'"
        query sql, (result) ->
            res.send
                children: (row.schema_name for row in result.rows)
    
    log.info "Setting up schema resource"
    app.get '/db/:databaseName/schemas/:schemaName', (req, res) ->
        res.send
            children: ['tables']
    
    log.info "Setting up tables resource"
    app.get '/db/:databaseName/schemas/:schemaName/tables', (req, res) ->
        databaseName = req.params.databaseName
        schemaName = req.params.schemaName
        log.info "Requesting tables information for schema #{schemaName}"
        sql = "select * from pg_tables where schemaname LIKE '#{schemaName}'"
        query sql, (result) ->
            res.send
                children: (row.tablename for row in result.rows)
                
exports.process = process


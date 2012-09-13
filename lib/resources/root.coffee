module.exports = (server) ->
    log = server.log
    db = server.db
    app = server.app
                
    log.debug "Setting up root resource"
    
    app.get '/', (req, res) ->
        sql = "SELECT * FROM information_schema.sql_implementation_info WHERE implementation_info_id = $1"
        db.query 
            sql: sql
            res: res
            values: ['18']
            callback: (result) ->
                versionName = result.rows[0].character_value
                res.send
                    type: 'server_root'
                    version: null
                    version_human: versionName
                    description: "PostgreSQL #{versionName}"
                    children: ['db']


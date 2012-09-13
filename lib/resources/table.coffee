module.exports = (server) ->
    log = server.log
    db = server.db
    app = server.app
    
    log.debug "Setting up table resource"
    
    path = '/db/:databaseName/schemas/:schemaName/tables/:tableName'

    app.get path, (req, res) ->
        res.send
            type: 'table'
            children: ['rows']
            # TODO: implement resources for children 'columns', 'constraints', 'indexes', 'rules', 'triggers'


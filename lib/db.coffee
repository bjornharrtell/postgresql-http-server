###
Helper functions for db access
###

pg = require 'pg'

module.exports = (log, connectionString, database) ->
    query = (config) ->
        connectionStringDb = connectionString + "/" + (config.database || database)
    
        log.debug "Sending query to #{connectionStringDb}\nSQL: #{config.sql}\nParameters: #{JSON.stringify(config.values)}"
        
        callback = (err, result) ->
            if err
                log.error JSON.stringify err
                config.res.send err, 500
            else
                config.callback result
        
        pg.connect connectionStringDb, (err, client) ->
            if err then callback err else client.query config.sql, config.values || [], callback

    query: query


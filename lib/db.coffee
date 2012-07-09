###
Helper functions for db access
###

pg = require 'pg'

module.exports = (log, connectionString, database) ->
    query = (config) ->
        log.debug "SQL: " + config.sql
        log.debug "VALUES: " + JSON.stringify(config.values)
        
        callback = (err, result) ->
            if err
                log.error JSON.stringify err
                config.res.send err, 500
            else
                config.callback result
        
        pg.connect connectionString + "/" + (config.database || database), (err, client) ->
            if err then callback err else client.query config.sql, config.values || [], callback

    query: query


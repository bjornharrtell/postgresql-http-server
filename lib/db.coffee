# Helper functions for db access

pg = require('pg')

module.exports = (log, connectionString) ->

    _query = (sql, callback) ->
        pg.connect connectionString, (err, client) ->
            if err then callback err else client.query sql, callback

    query = (sql, res, callback) ->
        log.debug sql
    
        _query sql, (err, result) ->
            if err
                log.error JSON.stringify err
                res.send err, 500
            else
                callback result

    query: query


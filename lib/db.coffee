###
Helper functions for DB access and SQL parsing
###

pg = require 'pg'
lexer = require './lexer'

module.exports = (log, connectionString, database) ->
    ###
    config.sql      - sql to query
    config.res      - response to send query results to (or eventual error)
    config.values   - parameter values
    config.callback - callback to be called on successful query with a single argument containing the query result
    ###
    query = (config) ->
        connectionStringDb = connectionString + "/" + (config.database || database)
    
        tokens = lexer.tokenize config.sql
        config.sql = (token[1] for token in tokens).join " "
    
        log.debug "Sending query to #{connectionStringDb}\nSQL: #{config.sql}\nParameters: #{JSON.stringify(config.values)}"
        
        callback = (err, result) ->
            if err
                log.error JSON.stringify err
                config.res.send err, 500
            else
                config.callback result
        
        pg.connect connectionStringDb, (err, client) ->
            if err then callback err else client.query config.sql, config.values || [], callback

    parseWhere = (config, where) -> if where
        config.sql += " WHERE "
        tokens = lexer.tokenize where
        for token in tokens
            if token[0] is 'STRING' or token[0] is 'NUMBER'
                config.values.push token[1]
                config.sql += "$#{config.count}"
                config.count += 1
            else if token[0] is 'CONDITIONAL'
                config.sql += " #{token[1].toUpperCase()} "
            else if token[0] is 'LITERAL'
                config.sql += "\"#{token[1]}\""
            else
                config.sql += token[1]
                
    parseLimit = (config, limit) -> if limit
        config.sql += " LIMIT $#{config.count}"
        config.values.push parseInt limit
        config.count += 1
        
    parseOffset = (config, offset) -> if offset
        config.sql += " OFFSET $#{config.count}"
        config.values.push parseInt offset
        config.count += 1
        
    parseOrderBy = (config, orderby) -> if orderby
        config.sql += " ORDER BY #{orderby}"
    
    parseRow = (row) ->
        fields = []
        params = []
        values = []
        count = 1
        for k,v of row
            fields.push "\"#{k}\""
            params.push "$#{count}"
            values.push v
            count += 1
        
        fields: fields.join ','
        params: params.join ','
        values: values
        count: count
    
    query: query
    parseWhere: parseWhere
    parseLimit: parseLimit
    parseOffset: parseOffset
    parseOrderBy: parseOrderBy
    parseRow: parseRow


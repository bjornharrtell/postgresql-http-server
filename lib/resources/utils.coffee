exports.parseTable = (req) ->
    "\"#{req.params.schemaName}\".\"#{req.params.tableName}\""

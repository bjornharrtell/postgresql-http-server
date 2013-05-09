http = require 'http'

exports.test = (options) ->
    options.host = 'localhost'
    options.port = 3000
    req = http.request options, (res) ->
        res.on 'data', (data) ->
            # try to parse as JSON
            try data = JSON.parse data catch error
            # if data is still unparsed, parse as String
            if data instanceof Buffer then data = data.toString()
            options.callback res, data
    if options.body?
        req.write JSON.stringify options.body
    req.end()

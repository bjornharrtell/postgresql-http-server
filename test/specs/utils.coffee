http = require 'http'

exports.test = (options) ->
    options.host = 'localhost'
    options.port = 3000
    req = http.request options, (res) ->
        res.on 'data', (chunk) ->
            try data = JSON.parse chunk catch error
            options.callback res, data
    if options.body?
        req.write JSON.stringify options.body
    req.end()

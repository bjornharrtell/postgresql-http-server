root = require '../../lib/resources/root'

mockedServer =
    log:
        debug: ->
    app:
        get: (path, callback) ->
            mockedServer.callback = callback
    db:
        query: (options) ->
            options.callback
                rows: [
                    character_value: "09.01.0004"
                ]
                

describe 'root', ->
    it 'should answer a GET request with an object created from db instance info', ->
        root mockedServer
        
        req =
            params:
                databaseName: 'test'
        res =
            send: (json) ->
                expect(json).toEqual
                    version : null
                    version_human : '09.01.0004'
                    description : 'PostgreSQL 09.01.0004'
                    children : [ 'db' ]
                       
        mockedServer.callback req, res 


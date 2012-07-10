http = require 'http'
assert = require 'assert'

describe 'Root resource', ->
    it 'should answer a GET request with an object created from db instance info', (done) ->
        
        options = 
            host: 'localhost',
            port: 3000
            path: '/',
            method: 'GET'
        
        req = http.request options, (res) ->
            res.on 'data', (chunk) ->
                data = JSON.parse chunk
                
                assert data.version is null, 'version should be string'
                assert typeof data.version_human is 'string', 'human should be string'
                assert typeof data.description is 'string', 'description should be string'
                assert data.children[0] is 'db', "should have child db"
                
                done()
                
        req.end()

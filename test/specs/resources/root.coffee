assert = require 'assert'

test = require('../utils').test

describe 'Root resource', ->
    it 'should answer a GET request with an object created from db instance info', (done) ->
        test
            path: '/'
            method: 'GET'
            callback: (res, data) ->
                assert data.version is null, 'version should be string'
                assert typeof data.version_human is 'string', 'human should be string'
                assert typeof data.description is 'string', 'description should be string'
                assert data.children[0] is 'db', "should have child db"
                done()

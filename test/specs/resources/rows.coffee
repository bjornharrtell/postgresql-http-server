assert = require 'assert'

test = require('../utils').test

describe 'Rows resource', ->
    it 'should answer first GET with empty recordset', (done) ->
        test
            path: '/db/test/schemas/testschema/tables/testtable/rows'
            method: 'GET'
            callback: (res, data) ->
                assert data.length is 0, '#{data.length} should be 0'
                done()
        
    it 'should answer a POST with status 201', (done) ->
        test
            path: '/db/test/schemas/testschema/tables/testtable/rows',
            method: 'POST'
            headers:
                'Content-Type': 'application/json'
            body:
                name: 'boo'
            callback: (res, data) ->
                assert res.statusCode is 201, "#{res.statusCode} should 200"
                done()
                
    it 'should answer second GET with single record in recordset', (done) ->
        test
            path: '/db/test/schemas/testschema/tables/testtable/rows'
            method: 'GET'
            callback: (res, data) ->
                assert data.length is 1, '#{data.length} should be 0'
                done()

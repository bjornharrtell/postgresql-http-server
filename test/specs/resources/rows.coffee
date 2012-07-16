assert = require 'assert'

test = require('../utils').test

path = '/db/test/schemas/testschema/tables/testtable/rows'

describe 'Rows resource', ->
    it 'should answer first GET with empty recordset', (done) ->
        test
            path: path
            method: 'GET'
            callback: (res, data) ->
                assert data.length is 0, '#{data.length} should be 0'
                done()
        
    it 'should answer a POST with status 201', (done) ->
        test
            path: path
            method: 'POST'
            headers:
                'Content-Type': 'application/json'
            body:
                name: 'first'
            callback: (res, data) ->
                assert res.statusCode is 201, "#{res.statusCode} should be 201"
                done()
                
    it 'should answer second GET with single record in recordset', (done) ->
        test
            path: path
            method: 'GET'
            callback: (res, data) ->
                assert data.length is 1, '#{data.length} should be 1'
                done()
                
    it 'should answer a second POST with status 201', (done) ->
        test
            path: path
            method: 'POST'
            headers:
                'Content-Type': 'application/json'
            body:
                name: 'second'
            callback: (res, data) ->
                assert res.statusCode is 201, "#{res.statusCode} should be 201"
                done()
                
    it 'should answer a PUT with status 200', (done) ->
        test
            path: path + "?where=name%3D'first'"
            method: 'PUT'
            headers:
                'Content-Type': 'application/json'
            body:
                name: 'updatedfirst'
            callback: (res, data) ->
                assert res.statusCode is 200, "#{res.statusCode} should be 200"
                done()
    
    it 'should answer third GET with single record in recordset', (done) ->
        test
            path: path + "?where=name%3D'updatedfirst'"
            method: 'GET'
            callback: (res, data) ->
                assert data.length is 1, '#{data.length} should be 1'
                done()
    
    it 'should DELETE all records', (done) ->
        test
            path: path
            method: 'DELETE'
            callback: (res, data) ->
                assert res.statusCode is 200, "#{res.statusCode} should be 200"
                done()

# PostgreSQL HTTP API Server

Attempt to implement something like the proposal at http://wiki.postgresql.org/wiki/HTTP_API

[![Build Status](https://secure.travis-ci.org/bjornharrtell/postgresql-http-server.png?branch=master)](http://travis-ci.org/bjornharrtell/postgresql-http-server)

## Installing

NOTE: Requires node.js

    # npm install postgresql-http-server

## Usage

    # postgresql-http-server --help
    PostgreSQL HTTP API Server
    
    Options:
      --port      HTTP Server port      [required]  [default: 3000]
      --dbhost    PostgreSQL host       [required]  [default: "localhost"]
      --dbport    PostgreSQL port       [required]  [default: 5432]
      --database  PostgreSQL database   [required]  [default: <user>]
      --user      PostgreSQL username   [required]  [default: <user>]
      --password  PostgreSQL password
      --raw       Enable raw SQL usage  [boolean]
      --cors      Enable CORS support   [boolean]
      --help      Show this message

## API Usage

The API is discoverable which means you can access the root resource at /
and follow links to subresources from there but lets say you have a database
named testdb with a table named testtable in the public schema you can then 
do the following operations:

    Retrieve (GET) or update (PUT) a single row at:
    /db/testdb/schemas/public/tables/testtable/rows/id

    Retrieve rows (GET), update rows (PUT) or create a new row (POST) at:
    /db/testdb/schemas/public/tables/testtable/rows

The above resources accepts URL encoded parameters where, limit, offset
and orderby where applicable. Example:

    GET a maximum of 10 rows where cost>100 at:
    /db/testdb/schemas/public/tables/testtable/rows?where=cost%3E100&limit=10

The default and currently the only dataformat is JSON. POSTing or PUTing
expects a JSON object with properties corresponding to column names.

Raw SQL queries can be POSTed to the database resource. Expected data
is a JSON object with the SQL string as property named "sql".

## TODOs

* Use real primary key (current single row operations assume a primary key named id)
* Stream row data
* Configurable max rows hard limit
* Optionally use authenticated user/password to connect to DB
* Handle PostGIS data

## License 

The MIT License (MIT)

Copyright (c) 2012 Björn Harrtell

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
